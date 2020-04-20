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
import "tasks/multiqc.wdl" as multiqc

workflow TalonWDL {
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
        Boolean runMultiQC = if (outputDirectory == ".") then false else true

        File? talonDatabase
        File? spliceJunctionsFile
        File? annotationGTFrefflat

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

    call Faidx as executeSamtoolsFaidx {
        input:
            inputFile = referenceGenome,
            outputDir = outputDirectory,
            dockerImage = dockerImages["samtools"]
    }

    call Dict as executePicardDict {
        input:
            inputFile = referenceGenome,
            outputDir = outputDirectory,
            dockerImage = dockerImages["picard"]
    }

    scatter (sample in allSamples) {
        call sampleWorkflow.SampleWorkflow as executeSampleWorkflow {
            input:
                sample = sample,
                outputDirectory = outputDirectory + "/" + sample.id,
                referenceGenome = referenceGenome,
                referenceGenomeIndex = executeSamtoolsFaidx.outputIndex,
                referenceGenomeDict = executePicardDict.outputDict,
                spliceJunctionsFile = if (runTranscriptClean)
                                      then select_first([spliceJunctionsFile, createSJsfile.outputSJsFile])
                                      else NoneFile,
                runTranscriptClean = runTranscriptClean,
                annotationGTFrefflat = annotationGTFrefflat,
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

    if (runMultiQC) {
        call multiqc.MultiQC as multiqcTask {
            input:
                dependencies = flatten(executeSampleWorkflow.outputHtmlReport),
                outDir = outputDirectory + "/multiqc",
                analysisDirectory = outputDirectory,
                dockerImage = dockerImages["multiqc"]
        }
    }

    output {
        File outputReferenceIndex = executeSamtoolsFaidx.outputIndex
        File outputReferenceDict = executePicardDict.outputDict
        Array[File] outputMinimap2 = flatten(executeSampleWorkflow.outputMinimap2)
        Array[File] outputMinimap2BAM = flatten(executeSamtoolsMinimap2.outputBAM)
        Array[File] outputMinimap2SortedBAM = flatten(executeSamtoolsMinimap2.outputSortedBAM)
        Array[File] outputMinimap2SortedBai = flatten(executeSamtoolsMinimap2.outputSortedBai)
        File outputTalonDatabase = executeTalon.outputUpdatedDatabase
        File outputAbundance = createAbundanceFile.outputAbundanceFile
        File outputSummary = createSummaryFile.outputSummaryFile
        File outputTalonLog = executeTalon.outputLog
        File outputTalonReadAnnot = executeTalon.outputAnnot
        File outputTalonConfigFile = executeTalon.outputConfigFile
        Array[File] outputHtmlReport = flatten(executeSampleWorkflow.outputHtmlReport)
        Array[File] outputZipReport = flatten(executeSampleWorkflow.outputZipReport)
        Array[File] outputFlagstats = flatten(executeSampleWorkflow.outputFlagstats)
        Array[File] outputPicardMetricsFiles = flatten(executeSampleWorkflow.outputPicardMetricsFiles)
        Array[File] outputRnaMetrics = flatten(executeSampleWorkflow.outputRnaMetrics)
        Array[File] outputTargetedPcrMetrics = flatten(executeSampleWorkflow.outputTargetedPcrMetrics)
        File? outputSpliceJunctionsFile = if (runTranscriptClean)
              then select_first([spliceJunctionsFile, createSJsfile.outputSJsFile])
              else NoneFile
        Array[File?] outputTranscriptCleanFasta = flatten(executeSampleWorkflow.outputTranscriptCleanFasta)
        Array[File?] outputTranscriptCleanLog = flatten(executeSampleWorkflow.outputTranscriptCleanLog)
        Array[File?] outputTranscriptCleanSAM = flatten(executeSampleWorkflow.outputTranscriptCleanSAM)
        Array[File?] outputTranscriptCleanTElog = flatten(executeSampleWorkflow.outputTranscriptCleanTElog)
        Array[File?] outputTranscriptCleanBAM = flatten(executeSamtoolsTranscriptClean.outputBAM)
        Array[File?] outputTranscriptCleanSortedBAM = flatten(executeSamtoolsTranscriptClean.outputSortedBAM)
        Array[File?] outputTranscriptCleanSortedBai = flatten(executeSamtoolsTranscriptClean.outputSortedBai)
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
        runMultiQC: {description: "Whether or not MultiQC should be run.", category: "advanced"}
        talonDatabase: {description: "A pre-generated TALON database file.", category: "advanced"}
        spliceJunctionsFile: {description: "A pre-generated splice junction annotation file.", category: "advanced"}
        annotationGTFrefflat: {description: "A refflat file of the annotation GTF used.", category: "common"}

        # outputs
        outputReferenceIndex: {description: "Index file of the reference genome."}
        outputReferenceDict: {description: "Dictionary file of the reference genome."}
        outputMinimap2: {description: "Mapping and alignment between collections of DNA sequences file(s)."}
        outputMinimap2BAM: {description: "Minimap2 BAM file(s) converted from SAM file(s)."}
        outputMinimap2SortedBAM: {description: "Minimap2 BAM file(s) sorted on position."}
        outputMinimap2SortedBai: {description: "Index of sorted minimap2 BAM file(s)."}
        outputTalonDatabase: {description: "TALON database."}
        outputAbundance: {description: "Abundance for each transcript in the TALON database across datasets."}
        outputSummary: {description: "Tab-delimited file of gene and transcript counts for each dataset."}
        outputTalonLog: {description: "Log file from TALON run."}
        outputTalonReadAnnot: {description: "Read annotation file from TALON run."}
        outputTalonConfigFile: {description: "The TALON configuration file."}
        outputHtmlReport: {description: "FastQC output HTML files."}
        outputZipReport: {description: "FastQC output support files."}
        outputFlagstats: {description: "Samtools flagstat output for minimap2 BAM file(s)."}
        outputPicardMetricsFiles: {description: "Picard metrics output for minimap2 BAM file(s)."}
        outputRnaMetrics: {description: "RNA metrics output for minimap2 BAM file(s)."}
        outputTargetedPcrMetrics: {description: "Targeted PCR metrics output for minimap2 BAM file(s)."}
        outputSpliceJunctionsFile: {description: "Splice junction annotation file."}
        outputTranscriptCleanFasta: {description: "Fasta file(s) containing corrected reads."}
        outputTranscriptCleanLog: {description: "Log file(s) of TranscriptClean run."}
        outputTranscriptCleanSAM: {description: "SAM file(s) containing corrected aligned reads."}
        outputTranscriptCleanTElog: {description: "TE log file(s) of TranscriptClean run."}
        outputTranscriptCleanBAM: {description: "TranscriptClean BAM file(s) converted from SAM file(s)."}
        outputTranscriptCleanSortedBAM: {description: "TranscriptClean BAM file(s) sorted on position."}
        outputTranscriptCleanSortedBai: {description: "Index of sorted TranscriptClean BAM file(s)."}
    }

    meta {
        WDL_AID: {
            exclude: ["NoneFile"]
        }
    }
}

task Faidx {
    input {
        File inputFile
        String outputDir
        String basenameInputFile = basename(inputFile)

        String memory = "2G"
        String dockerImage = "quay.io/biocontainers/samtools:1.10--h9402c20_2"
    }

    command <<<
        set -e
        mkdir -p "$(dirname ~{outputDir})"
        ln -s ~{inputFile} "~{outputDir}/~{basenameInputFile}"
        samtools faidx \
        "~{outputDir}/~{basenameInputFile}"
    >>>

    output {
        File outputIndex = outputDir + "/" + basenameInputFile + ".fai"
    }

    runtime {
        memory: memory
        docker: dockerImage
    }

    parameter_meta {
        # inputs
        inputFile: {description: "The input fasta file.", category: "required"}
        outputDir: {description: "Output directory path.", category: "required"}
        basenameInputFile: {description: "The basename of the input file.", category: "required"}
        memory: {description: "The amount of memory available to the job.", category: "advanced"}
        dockerImage: {description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}

        # outputs
        outputIndex: {description: "Index of the input fasta file."}
    }
}

task Dict {
    input {
        File inputFile
        String outputDir
        String basenameInputFile = basename(inputFile)

        String memory = "2G"
        String dockerImage = "quay.io/biocontainers/picard:2.22.3--0"
    }

    command {
        set -e
        mkdir -p "$(dirname ~{outputDir})"
        picard CreateSequenceDictionary \
        REFERENCE=~{inputFile} \
        OUTPUT="~{outputDir}/~{basenameInputFile}.dict"
    }

    output {
        File outputDict = outputDir + "/" + basenameInputFile + ".dict"
    }

    runtime {
        memory: memory
        docker: dockerImage
    }

    parameter_meta {
        # inputs
        inputFile: {description: "The input fasta file.", category: "required"}
        outputDir: {description: "Output directory path.", category: "required"}
        basenameInputFile: {description: "The basename of the input file.", category: "required"}
        memory: {description: "The amount of memory available to the job.", category: "advanced"}
        dockerImage: {description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}

        # outputs
        outputDict: {description: "Dictionary of the input fasta file."}
    }
}
