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
import "tasks/samtools.wdl" as samtools
import "/exports/sasc/jboom/WorkInProgress/tasks/talon.wdl" as talon
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

        call samtools.Sort as executeSortMinimap2 {
            input:
                inputBam = executeMinimap2.outputAlignmentFile,
                outputPath = outputDirectory + "/" + readgroupIdentifier + ".sorted.bam",
                dockerImage = dockerImages["samtools"]
        }

        call samtools.Index as executeIndexMinimap2 {
            input:
                bamFile = executeSortMinimap2.outputSortedBam,
                outputBamPath = outputDirectory + "/" + readgroupIdentifier + ".sorted.bam",
                dockerImage = dockerImages["samtools"]
        }

        call metrics.BamMetrics as bamMetricsMinimap2 {
            input:
                bam = executeIndexMinimap2.indexedBam,
                bamIndex = executeIndexMinimap2.index,
                outputDir = outputDirectory + "/metrics-minimap2",
                referenceFasta = referenceGenome,
                referenceFastaFai = referenceGenomeIndex,
                referenceFastaDict = referenceGenomeDict,
                refRefflat = annotationGTFrefflat,
                dockerImages = dockerImages
        }

        call talon.LabelReads as executeLabelReadsMinimap2 {
            input:
                SAMfile = executeMinimap2.outputAlignmentFile,
                referenceGenome = referenceGenome,
                outputPrefix = outputDirectory + "/" + readgroupIdentifier,
                dockerImage = dockerImages["talon"]
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

            call samtools.Sort as executeSortTranscriptClean {
                input:
                    inputBam = executeTranscriptClean.outputTranscriptCleanSAM,
                    outputPath = outputDirectory + "/" + readgroupIdentifier + "_clean" + ".sorted.bam",
                    dockerImage = dockerImages["samtools"]
            }

            call samtools.Index as executeIndexTranscriptClean {
                input:
                    bamFile = executeSortTranscriptClean.outputSortedBam,
                    outputBamPath = outputDirectory + "/" + readgroupIdentifier + "_clean" + ".sorted.bam",
                    dockerImage = dockerImages["samtools"]
            }

            call metrics.BamMetrics as bamMetricsTranscriptClean {
                input:
                    bam = executeIndexTranscriptClean.indexedBam,
                    bamIndex = executeIndexTranscriptClean.index,
                    outputDir = outputDirectory + "/metrics-transcriptclean",
                    referenceFasta = referenceGenome,
                    referenceFastaFai = referenceGenomeIndex,
                    referenceFastaDict = referenceGenomeDict,
                    collectAlignmentSummaryMetrics = false,
                    meanQualityByCycle = false,
                    dockerImages = dockerImages
            }

            call talon.LabelReads as executeLabelReadsTranscriptClean {
                input:
                    SAMfile = executeTranscriptClean.outputTranscriptCleanSAM,
                    referenceGenome = referenceGenome,
                    outputPrefix = outputDirectory + "/" + readgroupIdentifier + "_clean",
                    dockerImage = dockerImages["talon"]
            }
        }
    }

    output {
        Array[File] outputHtmlReport = fastqcTask.htmlReport
        Array[File] outputZipReport = fastqcTask.reportZip
        Array[File] outputSAMsampleWorkflow = if (runTranscriptClean) 
                    then select_all(executeLabelReadsTranscriptClean.outputLabeledSAM)
                    else executeLabelReadsMinimap2.outputLabeledSAM
        Array[File] outputMinimap2 = executeMinimap2.outputAlignmentFile
        Array[File] outputMinimap2SortedBAM = executeIndexMinimap2.indexedBam
        Array[File] outputMinimap2SortedBAI = executeIndexMinimap2.index
        Array[File] outputBamMetricsReportsMinimap2 = flatten(bamMetricsMinimap2.reports)
        Array[File] outputMinimap2Labeled = executeLabelReadsMinimap2.outputLabeledSAM
        Array[File?] outputTranscriptCleanFasta = executeTranscriptClean.outputTranscriptCleanFasta
        Array[File?] outputTranscriptCleanLog = executeTranscriptClean.outputTranscriptCleanLog
        Array[File?] outputTranscriptCleanSAM = executeTranscriptClean.outputTranscriptCleanSAM
        Array[File?] outputTranscriptCleanTElog = executeTranscriptClean.outputTranscriptCleanTElog
        Array[File?] outputTranscriptCleanSortedBAM = executeIndexTranscriptClean.indexedBam
        Array[File?] outputTranscriptCleanSortedBAI = executeIndexTranscriptClean.index
        Array[File?] outputBamMetricsReportsTranscriptClean = flatten(select_all(bamMetricsTranscriptClean.reports))
        Array[File?] outputTranscriptCleanLabeled = executeLabelReadsTranscriptClean.outputLabeledSAM
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
        outputSAMsampleWorkflow: {description: "Either the minimap2 or TranscriptClean SAM file(s)."}
        outputMinimap2: {description: "Mapping and alignment between collections of DNA sequences file(s)."}
        outputMinimap2SortedBAM: {description: "Minimap2 BAM file(s) sorted on position."}
        outputMinimap2SortedBAI: {description: "Index of sorted minimap2 BAM file(s)."}
        outputBamMetricsReportsMinimap2: {description: "All reports from the BamMetrics pipeline for the minimap2 alignment."}
        outputMinimap2Labeled: {description: "Minimap2 alignments labeled for internal priming."}
        outputTranscriptCleanFasta: {description: "Fasta file(s) containing corrected reads."}
        outputTranscriptCleanLog: {description: "Log file(s) of TranscriptClean run."}
        outputTranscriptCleanSAM: {description: "SAM file(s) containing corrected aligned reads."}
        outputTranscriptCleanTElog: {description: "TE log file(s) of TranscriptClean run."}
        outputTranscriptCleanSortedBAM: {description: "TranscriptClean BAM file(s) sorted on position."}
        outputTranscriptCleanSortedBAI: {description: "Index of sorted TranscriptClean BAM file(s)."}
        outputBamMetricsReportsTranscriptClean: {description: "All reports from the BamMetrics pipeline for the TranscriptClean alignment."}
        outputTranscriptCleanLabeled: {description: "TranscriptClean alignments labeled for internal priming."}
    }
}
