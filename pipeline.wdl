version 1.0

# Copyright (c) 2019 Sequencing Analysis Support Core - Leiden University Medical Center
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import "sample.wdl" as sampleWorkflow
import "structs.wdl" as structs
import "tasks/common.wdl" as common
import "tasks/talon.wdl" as talon
import "tasks/transcriptclean.wdl" as transcriptClean

workflow Pipeline {
    input {
        File sampleConfigFile
        String outputDirectory = "."
        File annotationGTF
        String genomeBuild
        String annotationVersion
        File referenceGenome
        String sequencingPlatform
        File talonConfigFile
        String pipelineRunName
        File dockerImagesFile
        Boolean filterTranscriptsAbundance = false
        String novelIDprefix = "TALON"
        Int minimumLength = 300
        Int cutoff5p = 500
        Int cutoff3p = 300

        File? talonDatabase
        File? spliceJunctionsFile
        File? filterPairingsFileAbundance
        File? summaryDatasetGroupsCSV
        Int? minIntronSize
    }

    call common.YamlToJson as convertDockerImagesFile {
        input:
            yaml = dockerImagesFile,
            outputJson = outputDirectory + "/dockerImages.json"
    }

    Map[String, String] dockerImages = read_json(convertDockerImagesFile.json)

    call common.SampleConfigToSampleReadgroupLists as convertSampleConfig {
        input:
            yaml = sampleConfigFile,
            outputJson = outputDirectory + "/samples.json",
            dockerImage = dockerImages["pyyaml"]
    }

    SampleConfig sampleConfig = read_json(convertSampleConfig.json)
    Array[Sample] allSamples = sampleConfig.samples

    Boolean userProvidedDatabase = defined(talonDatabase)
    Boolean userProvidedSJfile = defined(spliceJunctionsFile)

    if (! userProvidedDatabase) {
        call talon.InitializeTalonDatabase as createDatabase {
            input:
                GTFfile = annotationGTF,
                outputPrefix = outputDirectory + "/" + pipelineRunName,
                genomeBuild = genomeBuild,
                annotationVersion = annotationVersion,
                minimumLength = minimumLength,
                novelIDprefix = novelIDprefix,
                cutoff5p = cutoff5p,
                cutoff3p = cutoff3p,
                dockerImage = dockerImages["talon"]
        }
    }

    if (! userProvidedSJfile) {
        call transcriptClean.GetSJsFromGtf as createSJsfile {
            input:
                GTFfile = annotationGTF,
                genomeFile = referenceGenome,
                outputPrefix = outputDirectory + "/spliceJunctionsFile",
                minIntronSize = minIntronSize,
                dockerImage = dockerImages["transcriptclean"]
        }
    }

    scatter (sample in allSamples) {
        call sampleWorkflow.SampleWorkflow as sampleWorkflow {
            input:
                sample = sample,
                outputDirectory = outputDirectory + "/" + sample.id,
                genomeFile = referenceGenome,
                spliceJunctionsFile = select_first([spliceJunctionsFile, createSJsfile.outputSJsFile]),
                dockerImages = dockerImages
        }
    }

    call RunTalonOnLoop as runTalon {
        input:
            SAMfiles = flatten(sampleWorkflow.outputTranscriptCleanSAM),
            configFile = talonConfigFile,
            databaseFile = select_first([talonDatabase, createDatabase.outputDatabase]),
            outputPrefix = outputDirectory + "/" + pipelineRunName,
            genomeBuild = genomeBuild,
            sequencingPlatform = sequencingPlatform,
            dockerImage = dockerImages["talon"]
    }

    call talon.CreateAbundanceFileFromDatabase as createAbundanceFile {
        input:
            databaseFile = runTalon.outputUpdatedDatabase,
            outputPrefix = outputDirectory + "/" + pipelineRunName,
            genomeBuild = genomeBuild,
            annotationVersion = annotationVersion,
            filterTranscripts = filterTranscriptsAbundance,
            filterPairingsFile = filterPairingsFileAbundance,
            dockerImage = dockerImages["talon"]
    }

    call talon.SummarizeDatasets as createSummaryFile {
        input:
            databaseFile = runTalon.outputUpdatedDatabase,
            outputPrefix = outputDirectory + "/" + pipelineRunName,
            datasetGroupsCSV = summaryDatasetGroupsCSV,
            dockerImage = dockerImages["talon"]
    }

    output {
        File outputSpliceJunctionsFile = select_first([spliceJunctionsFile, createSJsfile.outputSJsFile])
        Array[File] outputMinimap2 = flatten(sampleWorkflow.outputMinimap2)
        Array[File] outputTranscriptCleanFasta = flatten(sampleWorkflow.outputTranscriptCleanFasta)
        Array[File] outputTranscriptCleanLog = flatten(sampleWorkflow.outputTranscriptCleanLog)
        Array[File] outputTranscriptCleanSAM = flatten(sampleWorkflow.outputTranscriptCleanSAM)
        Array[File] outputTranscriptCleanTElog = flatten(sampleWorkflow.outputTranscriptCleanTElog)
        File outputTalonDatabase = runTalon.outputUpdatedDatabase
        Array[File] outputTalonLogs = runTalon.outputLogs
        File outputAbundance = createAbundanceFile.outputAbundanceFile
        File outputSummary = createSummaryFile.outputSummaryFile
    }
}

task RunTalonOnLoop {
    input {
        Array[File] SAMfiles
        File configFile
        File databaseFile
        String outputPrefix
        String genomeBuild
        String sequencingPlatform = "PacBio-Sequal"
        Float minimumCoverage = 0.9
        Int minimumIdentity = 0

        Int cores = 1
        Int memory = 20
        String dockerImage = "biocontainers/talon:v4.2_cv2"
    }

    command <<<
        set -e
        mkdir -p $(dirname ~{outputPrefix})
        counter=1
        for file in ~{sep=" " SAMfiles}
        do
            userInput="$(sed -n ${counter}p ~{configFile})"
            configFileLine="${userInput},~{sequencingPlatform},${file}"
            outputPrefixString="~{outputPrefix}_${userInput%,*}"
            echo ${configFileLine} > configFile.csv
            talon \
                --f configFile.csv \
                ~{"--db " + databaseFile} \
                --o ${outputPrefixString} \
                ~{"--build " + genomeBuild} \
                ~{"--cov " + minimumCoverage} \
                ~{"--identity " + minimumIdentity}
            counter=$((counter+1))
        done
    >>>

    output {
        File outputUpdatedDatabase = databaseFile
        Array[File] outputLogs = glob(outputPrefix + "*_talon_QC.log")
    }

    runtime {
        cpu: cores
        memory: memory
        docker: dockerImage
    }

    parameter_meta {
        SAMfiles: "Input SAM files, same one as described in configFile."
        configFile: "Dataset config file."
        databaseFile: "TALON database. Created using initialize_talon_database.py."
        outputPrefix: "Output directory path + output file prefix."
        genomeBuild: "Genome build (i.e. hg38) to use."
        sequencingPlatform: "The sequencing platform used to generate long reads."
        minimumCoverage: "Minimum alignment coverage in order to use a SAM entry."
        minimumIdentity: "Minimum alignment identity in order to use a SAM entry."

        outputUpdatedDatabase: "Updated TALON database."
        outputLogs: "Log files from TALON run."
    }
}
