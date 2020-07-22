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
import "tasks/samtools.wdl" as samtools
import "tasks/picard.wdl" as picard
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

        File? talonDatabase
        File? spliceJunctions
        File? annotationGTFrefflat
        File? NoneFile #FIXME
    }

    meta {
        WDL_AID: {
            exclude: ["NoneFile"]
        }
        allowNestedInputs: true
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
    Boolean userProvidedSJfile = defined(spliceJunctions)

    if (! userProvidedDatabase) {
        call talon.InitializeTalonDatabase as createDatabase {
            input:
                gtfFile = annotationGTF,
                genomeBuild = genomeBuild,
                annotationVersion = annotationVersion,
                novelPrefix = novelIDprefix,
                outputPrefix = outputDirectory + "/" + pipelineRunName,
                dockerImage = dockerImages["talon"]
        }
    }

    if (! userProvidedSJfile) {
        if (runTranscriptClean) {
            call transcriptClean.GetSJsFromGtf as createSJsfile {
                input:
                    gtfFile = annotationGTF,
                    genomeFile = referenceGenome,
                    outputPrefix = outputDirectory + "/spliceJunctions",
                    dockerImage = dockerImages["transcriptclean"]
            }
        }
    }

    call samtools.Faidx as samtoolsFaidx {
        input:
            inputFile = referenceGenome,
            outputDir = outputDirectory,
            dockerImage = dockerImages["samtools"]
    }

    call picard.CreateSequenceDictionary as picardDict {
        input:
            inputFile = referenceGenome,
            outputDir = outputDirectory,
            dockerImage = dockerImages["picard"]
    }

    scatter (sample in allSamples) {
        call sampleWorkflow.SampleWorkflow as sampleWorkflow {
            input:
                sample = sample,
                outputDirectory = outputDirectory + "/" + sample.id,
                referenceGenome = referenceGenome,
                referenceGenomeIndex = samtoolsFaidx.outputIndex,
                referenceGenomeDict = picardDict.outputDict,
                spliceJunctionsFile = if (runTranscriptClean)
                                      then select_first([spliceJunctions, createSJsfile.spliceJunctionFile])
                                      else NoneFile,
                runTranscriptClean = runTranscriptClean,
                annotationGTFrefflat = annotationGTFrefflat,
                dockerImages = dockerImages
        }
    }

    call talon.Talon as talon {
        input:
            samFiles = flatten(sampleWorkflow.workflowSam),
            organism = organismName,
            sequencingPlatform = sequencingPlatform,
            databaseFile = select_first([talonDatabase, createDatabase.databaseFile]),
            genomeBuild = genomeBuild,
            outputPrefix = outputDirectory,
            dockerImage = dockerImages["talon"]
    }

    call talon.CreateAbundanceFileFromDatabase as createAbundanceFile {
        input:
            databaseFile = talon.updatedDatabase,
            annotationVersion = annotationVersion,
            genomeBuild = genomeBuild,
            outputPrefix = outputDirectory + "/" + pipelineRunName,
            dockerImage = dockerImages["talon"]
    }

    call talon.SummarizeDatasets as createSummaryFile {
        input:
            databaseFile = talon.updatedDatabase,
            outputPrefix = outputDirectory + "/" + pipelineRunName,
            dockerImage = dockerImages["talon"]
    }

    call multiqc.MultiQC as multiqcTask {
        input:
            reports = flatten(sampleWorkflow.workflowReports),
            outDir = outputDirectory + "/multiqc",
            dataDir = true,
            dockerImage = dockerImages["multiqc"]
    }

    output {
        File talonDatabaseFilled = talon.updatedDatabase
        File referenceIndex = samtoolsFaidx.outputIndex
        File referenceDict = picardDict.outputDict
        Array[File] workflowReports = flatten(sampleWorkflow.workflowReports)
        Array[File] minimap2Sam = flatten(sampleWorkflow.minimap2Sam)
        Array[File] minimap2SortedBam = flatten(sampleWorkflow.minimap2SortedBam)
        Array[File] minimap2SortedBai = flatten(sampleWorkflow.minimap2SortedBai)
        Array[File] minimap2SamLabeled = flatten(sampleWorkflow.minimap2SamLabeled)
        Array[File] minimap2SamReadLabels = flatten(sampleWorkflow.minimap2SamReadLabels)
        File talonLog = talon.talonLog
        File talonReadAnnotation = talon.talonAnnotation
        File talonConfigFile = talon.talonConfigFile
        File abundanceFile = createAbundanceFile.abundanceFile
        File summaryFile = createSummaryFile.summaryFile
        File multiqcReport = multiqcTask.multiqcReport
        File? multiqcZip = multiqcTask.multiqcDataDirZip
        File? spliceJunctionsFile = if (runTranscriptClean) then select_first([spliceJunctions, createSJsfile.spliceJunctionFile]) else NoneFile
        Array[File?] transcriptCleanFasta = flatten(sampleWorkflow.transcriptCleanFasta)
        Array[File?] transcriptCleanLog = flatten(sampleWorkflow.transcriptCleanLog)
        Array[File?] transcriptCleanSam = flatten(sampleWorkflow.transcriptCleanSam)
        Array[File?] transcriptCleanTELog = flatten(sampleWorkflow.transcriptCleanTELog)
        Array[File?] transcriptCleanSortedBam = flatten(sampleWorkflow.transcriptCleanSortedBam)
        Array[File?] transcriptCleanSortedBai = flatten(sampleWorkflow.transcriptCleanSortedBai)
        Array[File?] transcriptCleanSamLabeled = flatten(sampleWorkflow.transcriptCleanSamLabeled)
        Array[File?] transcriptCleanSamReadLabels = flatten(sampleWorkflow.transcriptCleanSamReadLabels)
    }

    parameter_meta {
        # inputs
        sampleConfigFile: {description: "Samplesheet describing input fasta/fastq files.", category: "required"}
        outputDirectory: {description: "The directory to which the outputs will be written.", category: "common"}
        annotationGTF: {description: "Gtf annotation containing genes, transcripts, and edges.", category: "required"}
        genomeBuild: {description: "Genome build (i.e. hg38) to use.", category: "required"}
        annotationVersion: {description: "Name of supplied annotation (will be used to label data).", category: "required"}
        referenceGenome: {description: "Reference genome fasta file.", category: "required"}
        sequencingPlatform: {description: "The sequencing machine used to generate the data.", category: "required"}
        organismName: {description: "The name of the organism from which the data was collected.", category: "required"}
        pipelineRunName: {description: "A name describing the pipeline run.", category: "required"}
        dockerImagesFile: {description: "The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "required"}
        novelIDprefix: {description: "Prefix for naming novel discoveries in eventual talon runs.", category: "common"}
        runTranscriptClean: {description: "Option to run transcriptclean after minimap2 alignment.", category: "common"}
        talonDatabase: {description: "A pre-generated talon database file.", category: "advanced"}
        spliceJunctions: {description: "A pre-generated splice junction annotation file.", category: "advanced"}
        annotationGTFrefflat: {description: "A refflat file of the annotation gtf used.", category: "common"}

        # outputs
        talonDatabaseFilled: {description: "Talon database after talon process."}
        referenceIndex: {description: "Index file of the reference genome."}
        referenceDict: {description: "Dictionary file of the reference genome."}
        workflowReports: {description: "A collection of all metrics outputs."}
        minimap2Sam: {description: "Mapping and alignment between collections of dna sequences file(s)."}
        minimap2SortedBam: {description: "Minimap2 bam file(s) sorted on position."}
        minimap2SortedBai: {description: "Index of sorted minimap2 BAM file(s)."}
        minimap2SamLabeled: {description: "Minimap2 alignments labeled for internal priming."}
        minimap2SamReadLabels: {description: "Tabular files with fraction description per read for minimap2 alignment."}
        talonLog: {description: "Log file from talon run."}
        talonReadAnnotation: {description: "Read annotation file from talon run."}
        talonConfigFile: {description: "The talon configuration file."}
        abundanceFile: {description: "Abundance for each transcript in the talon database across datasets."}
        summaryFile: {description: "Tab-delimited file of gene and transcript counts for each dataset."}
        multiqcReport: {description: "The multiqc html report."}
        multiqcZip: {description: "The multiqc data zip file."}
        spliceJunctionsFile: {description: "A pre-generated splice junction annotation file.", category: "advanced"}
        transcriptCleanFasta: {description: "Fasta file(s) containing corrected reads."}
        transcriptCleanLog: {description: "Log file(s) of transcriptclean run."}
        transcriptCleanSam: {description: "Sam file(s) containing corrected aligned reads."}
        transcriptCleanTELog: {description: "TE log file(s) of transcriptclean run."}
        transcriptCleanSortedBam: {description: "Transcriptclean bam file(s) sorted on position."}
        transcriptCleanSortedBai: {description: "Index of sorted transcriptclean bam file(s)."}
        transcriptCleanSamLabeled: {description: "Transcriptclean alignments labeled for internal priming."}
        transcriptCleanSamReadLabels: {description: "Tabular files with fraction description per read for transcriptclean alignment."}
    }
}
