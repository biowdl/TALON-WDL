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
import "tasks/biowdl.wdl" as biowdl
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
        String organismName
        String pipelineRunName
        File dockerImagesFile
        String novelIDprefix = "TALON"
        Boolean runTranscriptClean = true

        File? talonDatabase
        File? spliceJunctionsFile

        File? NoneFile #FIXME
    }

    call common.YamlToJson as convertDockerImagesFile {
        input:
            yaml = dockerImagesFile,
            outputJson = outputDirectory + "/dockerImages.json"
    }

    Map[String, String] dockerImages = read_json(convertDockerImagesFile.json)

    call biowdl.InputConverter as convertSampleConfig {
        input:
            samplesheet = sampleConfigFile,
            outputFile = outputDirectory + "/samplesheet.json",
            dockerImage = dockerImages["biowdl-input-converter"]
    }

    SampleConfig sampleConfig = read_json(convertSampleConfig.json)
    Array[Sample] allSamples = sampleConfig.samples
    Boolean userProvidedDatabase = defined(talonDatabase)
    Boolean userProvidedSJfile = defined(spliceJunctionsFile)

    if (! userProvidedDatabase) {
        call talon.InitializeTalonDatabase as createDatabase {
            input:
                GTFfile = annotationGTF,
                genomeBuild = genomeBuild,
                annotationVersion = annotationVersion,
                novelIDprefix = novelIDprefix,
                outputPrefix = outputDirectory + "/" + pipelineRunName,
                dockerImage = dockerImages["talon"]
        }
    }

    if (! userProvidedSJfile) {
        if (runTranscriptClean) {
            call transcriptClean.GetSJsFromGtf as createSJsfile {
                input:
                    GTFfile = annotationGTF,
                    genomeFile = referenceGenome,
                    outputPrefix = outputDirectory + "/spliceJunctionsFile",
                    dockerImage = dockerImages["transcriptclean"]
            }
        }
    }

    scatter (sample in allSamples) {
        call sampleWorkflow.SampleWorkflow as executeSampleWorkflow {
            input:
                sample = sample,
                outputDirectory = outputDirectory + "/" + sample.id,
                referenceGenome = referenceGenome,
                spliceJunctionsFile = if (runTranscriptClean)
                                      then select_first([spliceJunctionsFile, createSJsfile.outputSJsFile])
                                      else NoneFile,
                runTranscriptClean = runTranscriptClean,
                dockerImages = dockerImages
        }
    }

    call talon.Talon as executeTalon {
        input:
            SAMfiles = flatten(executeSampleWorkflow.outputSAMsampleWorkflow),
            organism = organismName,
            sequencingPlatform = sequencingPlatform,
            databaseFile = select_first([talonDatabase, createDatabase.outputDatabase]),
            genomeBuild = genomeBuild,
            outputPrefix = outputDirectory,
            dockerImage = dockerImages["talon"]
    }

    call talon.CreateAbundanceFileFromDatabase as createAbundanceFile {
        input:
            databaseFile = executeTalon.outputUpdatedDatabase,
            annotationVersion = annotationVersion,
            genomeBuild = genomeBuild,
            outputPrefix = outputDirectory + "/" + pipelineRunName,
            dockerImage = dockerImages["talon"]
    }

    call talon.SummarizeDatasets as createSummaryFile {
        input:
            databaseFile = executeTalon.outputUpdatedDatabase,
            outputPrefix = outputDirectory + "/" + pipelineRunName,
            dockerImage = dockerImages["talon"]
    }

    output {
        Array[File] outputMinimap2 = flatten(executeSampleWorkflow.outputMinimap2)
        File outputTalonDatabase = executeTalon.outputUpdatedDatabase
        File outputAbundance = createAbundanceFile.outputAbundanceFile
        File outputSummary = createSummaryFile.outputSummaryFile
        File outputTalonLog = executeTalon.outputLog
        File outputTalonReadAnnot = executeTalon.outputAnnot
        File outputTalonConfigFile = executeTalon.outputConfigFile
        File? outputSpliceJunctionsFile = if (runTranscriptClean)
              then select_first([spliceJunctionsFile, createSJsfile.outputSJsFile])
              else NoneFile
        Array[File?] outputTranscriptCleanFasta = flatten(executeSampleWorkflow.outputTranscriptCleanFasta)
        Array[File?] outputTranscriptCleanLog = flatten(executeSampleWorkflow.outputTranscriptCleanLog)
        Array[File?] outputTranscriptCleanSAM = flatten(executeSampleWorkflow.outputTranscriptCleanSAM)
        Array[File?] outputTranscriptCleanTElog = flatten(executeSampleWorkflow.outputTranscriptCleanTElog)
    }

    parameter_meta {
        # inputs
        sampleConfigFile: {description: "Samplesheet describing input fasta/fastq files.", category: "required"}
        outputDirectory: {description: "The directory to which the outputs will be written.", category: "common"}
        annotationGTF: {description: "GTF annotation containing genes, transcripts, and edges.", category: "required"}
        genomeBuild: {description: "Genome build (i.e. hg38) to use.", category: "required"}
        annotationVersion: {description: "Name of supplied annotation (will be used to label data).", category: "required"}
        referenceGenome: {description: "Reference genome fasta file.", category: "required"}
        sequencingPlatform: {description: "The sequencing machine used to generate the data.", category: "required"}
        organismName: {description: "The name of the organism from which the data was collected.", category: "required"}
        pipelineRunName: {description: "A name describing the pipeline run.", category: "required"}
        dockerImagesFile: {description: "The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "required"}
        novelIDprefix: {description: "Prefix for naming novel discoveries in eventual TALON runs.", category: "common"}
        runTranscriptClean: {description: "Option to run TranscriptClean after Minimap2 alignment.", category: "common"}
        talonDatabase: {description: "A pre-generated TALON database file.", category: "advanced"}
        spliceJunctionsFile: {description: "A pre-generated splice junction annotation file.", category: "advanced"}

        # outputs
        outputMinimap2: {description: "Mapping and alignment between collections of DNA sequences file."}
        outputTalonDatabase: {description: "TALON database."}
        outputAbundance: {description: "Abundance for each transcript in the TALON database across datasets."}
        outputSummary: {description: "Tab-delimited file of gene and transcript counts for each dataset."}
        outputTalonLog: {description: "Log file from TALON run."}
        outputTalonReadAnnot: {description: "Read annotation file from TALON run."}
        outputTalonConfigFile: {description: "The TALON configuration file."}
        outputSpliceJunctionsFile: {description: "Splice junction annotation file."}
        outputTranscriptCleanFasta: {description: "Fasta files containing corrected reads."}
        outputTranscriptCleanLog: {description: "Log files of TranscriptClean run."}
        outputTranscriptCleanSAM: {description: "SAM files containing corrected aligned reads."}
        outputTranscriptCleanTElog: {description: "TE log files of TranscriptClean run."}
    }

    meta {
        WDL_AID: {
            exclude: ["NoneFile"]
        }
    }
}
