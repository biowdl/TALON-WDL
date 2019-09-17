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

        File? talonDatabase
        File? spliceJunctionsFile
        String? novelIDprefix
        Int? minimumLength
        Int? cutoff5p
        Int? cutoff3p
        Boolean? filterTranscriptsAbundance = false
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

    call SampleConfigToSampleReadgroupLists as convertSampleConfig {
        input:
            yaml = sampleConfigFile,
            outputJson = outputDirectory + "/samples.json",
            dockerImage = dockerImages["pyyaml"]
    }

    SampleConfig sampleConfig = read_json(convertSampleConfig.json)
    Array[Sample] allSamples = sampleConfig.samples

    Boolean runInitDatabase = defined(talonDatabase)
    Boolean runGetSJsFromGTF = defined(spliceJunctionsFile)

    if (runInitDatabase == false) {
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

    if (runGetSJsFromGTF == false) {
        call transcriptClean.GetSJsFromGtf as createSJsfile {
            input:
                GTFfile = annotationGTF,
                genomeFile = referenceGenome,
                outputPrefix = outputDirectory + "/" + "spliceJunctionsFile",
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
        File outputTalonLog = runTalon.outputLog
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

        Float? minimumCoverage = 0.9
        Int? minimumIdentity = 0

        Int cores = 1
        Int memory = 20
        String dockerImage = "biocontainers/talon:v4.2_cv2"
    }

    command <<<
        #$ -l h_vmem=~{memory}G
        #$ -pe BWA ~{cores}
        set -e
        mkdir -p $(dirname ~{outputPrefix})
        counter=1
        for file in ~{sep=" " SAMfiles}
        do
            userInput="$(sed -n ${counter}p ~{configFile})"
            configFileLine="${userInput},~{sequencingPlatform},${file}"
            echo ${configFileLine} > configFile.csv
            talon \
                --f configFile.csv \
                ~{"--db " + databaseFile} \
                ~{"--o " + outputPrefix} \
                ~{"--build " + genomeBuild} \
                ~{"--cov " + minimumCoverage} \
                ~{"--identity " + minimumIdentity}
            counter=$((counter+1))
        done
    >>>

    output {
        File outputUpdatedDatabase = databaseFile
        File outputLog = outputPrefix + "_talon_QC.log"
    }

    runtime {
        cpu: cores
        memory: memory
        docker: dockerImage
    }
}

task SampleConfigToSampleReadgroupLists {
    input {
        File yaml
        String outputJson = "samples.json"
        String dockerImage = "biowdl/pyyaml:3.13-py37-slim"
    }

    command <<<
        set -e
        mkdir -p $(dirname ~{outputJson})
        python <<CODE
        import json
        import yaml
        with open("~{yaml}", "r") as input_yaml:
            sample_config = yaml.load(input_yaml)

        sample_rg_lists = []
        for sample in sample_config["samples"]:
            new_sample = {"readgroups": [], "id": sample['id']}
            for library in sample["libraries"]:
                for readgroup in library["readgroups"]:
                    new_readgroup = {'lib_id': library['id'], 'id': readgroup['id']}
                    # Having a nested "reads" struct does not make any sense.
                    new_readgroup.update(readgroup["reads"])
                    new_sample['readgroups'].append(new_readgroup)
            sample_rg_lists.append(new_sample)
        sample_mod_config = {"samples": sample_rg_lists}
        with open("~{outputJson}", "w") as output_json:
            json.dump(sample_mod_config, output_json)
        CODE
    >>>

    output {
        File json = outputJson
    }

    runtime {
        docker: dockerImage
    }
}
