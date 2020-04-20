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

import "structs.wdl" as structs
import "BamMetrics/bammetrics.wdl" as metrics
import "tasks/fastqc.wdl" as fastqc
import "tasks/minimap2.wdl" as minimap2
import "tasks/transcriptclean.wdl" as transcriptClean

workflow SampleWorkflow {
    input {
        Sample sample
        String outputDirectory = "."
        File referenceGenome
        File referenceGenomeIndex
        File referenceGenomeDict
        String presetOption
        Boolean runTranscriptClean = true
        Map[String, String] dockerImages

        File? variantVCF
        String? howToFindGTAG
        File? spliceJunctionsFile
        File? annotationGTFrefflat
    }

    Array[Readgroup] readgroups = sample.readgroups

    scatter (readgroup in readgroups) {
        String readgroupIdentifier = sample.id + "-" + readgroup.lib_id + "-" + readgroup.id
        call fastqc.Fastqc as fastqcTask {
            input:
                seqFile = readgroup.R1,
                outdirPath = outputDirectory + "/" + readgroupIdentifier + "-fastqc",
                dockerImage = dockerImages["fastqc"]
        }

        call minimap2.Mapping as executeMinimap2 {
            input:
                queryFile = readgroup.R1,
                referenceFile = referenceGenome,
                outputPrefix = outputDirectory + "/" + readgroupIdentifier + ".sam",
                presetOption = presetOption,
                outputSAM = true,
                howToFindGTAG = howToFindGTAG,
                addMDtagToSAM = true,
                dockerImage = dockerImages["minimap2"]
        }

        call SortAndIndex as executeSamtoolsMinimap2 {
            input:
                inputFile = executeMinimap2.outputAlignmentFile,
                outputPrefix = outputDirectory + "/" + readgroupIdentifier,
                dockerImage = dockerImages["samtools"]
        }

        call metrics.BamMetrics as bamMetricsMinimap2 {
            input:
                bam = executeSamtoolsMinimap2.outputSortedBAM,
                bamIndex = executeSamtoolsMinimap2.outputSortedBai,
                outputDir = outputDirectory + "/metrics-minimap2",
                referenceFasta = referenceGenome,
                referenceFastaFai = referenceGenomeIndex,
                referenceFastaDict = referenceGenomeDict,
                refRefflat = annotationGTFrefflat,
                dockerImages = dockerImages
        }

        if (runTranscriptClean) {
            call transcriptClean.TranscriptClean as executeTranscriptClean {
                input:
                    SAMfile = executeMinimap2.outputAlignmentFile,
                    referenceGenome = referenceGenome,
                    outputPrefix = outputDirectory + "/" + readgroupIdentifier,
                    spliceJunctionAnnotation = spliceJunctionsFile,
                    variantFile = variantVCF,
                    primaryOnly = true,
                    dockerImage = dockerImages["transcriptclean"]
            }

            call SortAndIndex as executeSamtoolsTranscriptClean {
                input:
                    inputFile = executeTranscriptClean.outputTranscriptCleanSAM,
                    outputPrefix = outputDirectory + "/" + readgroupIdentifier + "_clean",
                    dockerImage = dockerImages["samtools"]
            }
        }
    }

    output {
        Array[File] outputHtmlReport = fastqcTask.htmlReport
        Array[File] outputZipReport = fastqcTask.reportZip
        Array[File] outputFlagstats = bamMetricsMinimap2.flagstats
        Array[File] outputPicardMetricsFiles = flatten(bamMetricsMinimap2.picardMetricsFiles)
        Array[File] outputRnaMetrics = flatten(bamMetricsMinimap2.rnaMetrics)
        Array[File] outputTargetedPcrMetrics = flatten(bamMetricsMinimap2.targetedPcrMetrics)
        Array[File] outputSAMsampleWorkflow = if (runTranscriptClean) 
                    then select_all(executeTranscriptClean.outputTranscriptCleanSAM)
                    else executeMinimap2.outputAlignmentFile
        Array[File] outputMinimap2 = executeMinimap2.outputAlignmentFile
        Array[File] outputMinimap2BAM = executeSamtoolsMinimap2.outputBAM
        Array[File] outputMinimap2SortedBAM = executeSamtoolsMinimap2.outputSortedBAM
        Array[File] outputMinimap2SortedBai = executeSamtoolsMinimap2.outputSortedBai
        Array[File?] outputTranscriptCleanFasta = executeTranscriptClean.outputTranscriptCleanFasta
        Array[File?] outputTranscriptCleanLog = executeTranscriptClean.outputTranscriptCleanLog
        Array[File?] outputTranscriptCleanSAM = executeTranscriptClean.outputTranscriptCleanSAM
        Array[File?] outputTranscriptCleanTElog = executeTranscriptClean.outputTranscriptCleanTElog
        Array[File?] outputTranscriptCleanBAM = executeSamtoolsTranscriptClean.outputBAM
        Array[File?] outputTranscriptCleanSortedBAM = executeSamtoolsTranscriptClean.outputSortedBAM
        Array[File?] outputTranscriptCleanSortedBai = executeSamtoolsTranscriptClean.outputSortedBai
    }

    parameter_meta {
        # inputs
        sample: {description: "The sample data.", category: "required"}
        outputDirectory: {description: "The directory to which the outputs will be written.", category: "common"}
        referenceGenome: {description: "Reference genome fasta file.", category: "required"}
        referenceGenomeIndex: {description: "Reference genome index file.", category: "required"}
        referenceGenomeDict: {description: "Reference genome dictionary file.", category: "required"}
        presetOption: {description: "This option applies multiple options at the same time in minimap2.", category: "common"}
        runTranscriptClean: {description: "Option to run TranscriptClean after Minimap2 alignment.", category: "common"}
        dockerImages: {description: "The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}
        variantVCF: {description: "VCF formatted file of variants.", category: "common"}
        howToFindGTAG: {description: "How to find GT-AG. f:transcript strand, b:both strands, n:don't match GT-AG.", category: "common"}
        spliceJunctionsFile: {description: "A pre-generated splice junction annotation file.", category: "advanced"}
        annotationGTFrefflat: {description: "A refflat file of the annotation GTF used.", category: "common"}

        # outputs
        outputHtmlReport: {description: "FastQC output HTML file(s)."}
        outputZipReport: {description: "FastQC output support file(s)."}
        outputFlagstats: {description: "Samtools flagstat output for minimap2 BAM file(s)."}
        outputPicardMetricsFiles: {description: "Picard metrics output for minimap2 BAM file(s)."}
        outputRnaMetrics: {description: "RNA metrics output for minimap2 BAM file(s)."}
        outputTargetedPcrMetrics: {description: "Targeted PCR metrics output for minimap2 BAM file(s)."}
        outputSAMsampleWorkflow: {description: "Either the minimap2 or TranscriptClean SAM file(s)."}
        outputMinimap2: {description: "Mapping and alignment between collections of DNA sequences file(s)."}
        outputMinimap2BAM: {description: "Minimap2 BAM file(s) converted from SAM file(s)."}
        outputMinimap2SortedBAM: {description: "Minimap2 BAM file(s) sorted on position."}
        outputMinimap2SortedBai: {description: "Index of sorted minimap2 BAM file(s)."}
        outputTranscriptCleanFasta: {description: "Fasta file(s) containing corrected reads."}
        outputTranscriptCleanLog: {description: "Log file(s) of TranscriptClean run."}
        outputTranscriptCleanSAM: {description: "SAM file(s) containing corrected aligned reads."}
        outputTranscriptCleanTElog: {description: "TE log file(s) of TranscriptClean run."}
        outputTranscriptCleanBAM: {description: "TranscriptClean BAM file(s) converted from SAM file(s)."}
        outputTranscriptCleanSortedBAM: {description: "TranscriptClean BAM file(s) sorted on position."}
        outputTranscriptCleanSortedBai: {description: "Index of sorted TranscriptClean BAM file(s)."}
    }
}

task SortAndIndex {
    input {
        File inputFile
        String outputPrefix

        Int cores = 1
        String memory = "2G"
        String dockerImage = "quay.io/biocontainers/samtools:1.10--h9402c20_2"
    }

    command {
        set -e
        mkdir -p "$(dirname ~{outputPrefix})"
        samtools view \
        --threads ~{cores} \
        -S \
        -b \
        -o "~{outputPrefix}.bam" \
        ~{inputFile}
        samtools sort \
        --threads ~{cores} \
        -o "~{outputPrefix}.sorted.bam" \
        "~{outputPrefix}.bam"
        samtools index \
        -@ ~{cores} \
        -b \
        "~{outputPrefix}.sorted.bam" \
        "~{outputPrefix}.sorted.bai"
    }

    output {
        File outputBAM = outputPrefix + ".bam"
        File outputSortedBAM = outputPrefix + ".sorted.bam"
        File outputSortedBai = outputPrefix + ".sorted.bai"
    }

    runtime {
        cpu: cores
        memory: memory
        docker: dockerImage
    }

    parameter_meta {
        # inputs
        inputFile: {description: "The input SAM file.", category: "required"}
        outputPrefix: {description: "Output directory path + output file prefix.", category: "required"}
        cores: {description: "The number of cores to be used.", category: "advanced"}
        memory: {description: "The amount of memory available to the job.", category: "advanced"}
        dockerImage: {description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}

        # outputs
        outputBAM: {description: "BAM file converted from SAM file."}
        outputSortedBAM: {description: "Sorted BAM file."}
        outputSortedBai: {description: "Index of the sorted BAM file."}
    }
}
