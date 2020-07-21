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
import "tasks/talon.wdl" as talon
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

    meta {allowNestedInputs: true}

    Array[Readgroup] readgroups = sample.readgroups

    scatter (readgroup in readgroups) {
        String readgroupIdentifier = sample.id + "-" + readgroup.lib_id + "-" + readgroup.id
        call fastqc.Fastqc as fastqcTask {
            input:
                seqFile = readgroup.R1,
                outdirPath = outputDirectory + "/" + readgroupIdentifier + "-fastqc",
                dockerImage = dockerImages["fastqc"]
        }

        call minimap2.Mapping as minimap2 {
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

        call samtools.Sort as sortMinimap2 {
            input:
                inputBam = minimap2.outputAlignmentFile,
                outputPath = outputDirectory + "/" + readgroupIdentifier + ".sorted.bam",
                dockerImage = dockerImages["samtools"]
        }

        call metrics.BamMetrics as bamMetricsMinimap2 {
            input:
                bam = sortMinimap2.outputBam,
                bamIndex = sortMinimap2.outputBamIndex,
                outputDir = outputDirectory + "/metrics-minimap2",
                referenceFasta = referenceGenome,
                referenceFastaFai = referenceGenomeIndex,
                referenceFastaDict = referenceGenomeDict,
                refRefflat = annotationGTFrefflat,
                dockerImages = dockerImages
        }

        call talon.LabelReads as labelReadsMinimap2 {
            input:
                SAMfile = minimap2.outputAlignmentFile,
                referenceGenome = referenceGenome,
                outputPrefix = outputDirectory + "/" + readgroupIdentifier,
                dockerImage = dockerImages["talon"]
        }

        if (runTranscriptClean) {
            call transcriptClean.TranscriptClean as transcriptClean {
                input:
                    SAMfile = minimap2.outputAlignmentFile,
                    referenceGenome = referenceGenome,
                    outputPrefix = outputDirectory + "/" + readgroupIdentifier,
                    spliceJunctionAnnotation = spliceJunctionsFile,
                    variantFile = variantVCF,
                    primaryOnly = true,
                    dockerImage = dockerImages["transcriptclean"]
            }

            call samtools.Sort as sortTranscriptClean {
                input:
                    inputBam = transcriptClean.outputTranscriptCleanSAM,
                    outputPath = outputDirectory + "/" + readgroupIdentifier + "_clean" + ".sorted.bam",
                    dockerImage = dockerImages["samtools"]
            }

            call metrics.BamMetrics as bamMetricsTranscriptClean {
                input:
                    bam = sortTranscriptClean.outputBam,
                    bamIndex = sortTranscriptClean.outputBamIndex,
                    outputDir = outputDirectory + "/metrics-transcriptclean",
                    referenceFasta = referenceGenome,
                    referenceFastaFai = referenceGenomeIndex,
                    referenceFastaDict = referenceGenomeDict,
                    collectAlignmentSummaryMetrics = false,
                    meanQualityByCycle = false,
                    dockerImages = dockerImages
            }

            call talon.LabelReads as labelReadsTranscriptClean {
                input:
                    SAMfile = transcriptClean.outputTranscriptCleanSAM,
                    referenceGenome = referenceGenome,
                    outputPrefix = outputDirectory + "/" + readgroupIdentifier + "_clean",
                    dockerImage = dockerImages["talon"]
            }
        }
    }

    Array[File] qualityReports = flatten([fastqcTask.htmlReport, fastqcTask.reportZip, flatten(bamMetricsMinimap2.reports), flatten(select_all(bamMetricsTranscriptClean.reports))])

    output {
        Array[File] workflowSam = if (runTranscriptClean) 
                    then select_all(labelReadsTranscriptClean.outputLabeledSAM)
                    else labelReadsMinimap2.outputLabeledSAM
        Array[File] minimap2Sam = minimap2.outputAlignmentFile
        Array[File] minimap2SortedBam = sortMinimap2.outputBam
        Array[File] minimap2SortedBai = sortMinimap2.outputBamIndex
        Array[File] minimap2SamLabeled = labelReadsMinimap2.outputLabeledSAM
        Array[File] minimap2SamReadLabels = labelReadsMinimap2.outputReadLabels
        Array[File] workflowReports = qualityReports
        Array[File?] transcriptCleanFasta = transcriptClean.outputTranscriptCleanFasta
        Array[File?] transcriptCleanLog = transcriptClean.outputTranscriptCleanLog
        Array[File?] transcriptCleanSam = transcriptClean.outputTranscriptCleanSAM
        Array[File?] transcriptCleanTELog = transcriptClean.outputTranscriptCleanTElog
        Array[File?] transcriptCleanSortedBam = sortTranscriptClean.outputBam
        Array[File?] transcriptCleanSortedBai = sortTranscriptClean.outputBamIndex
        Array[File?] transcriptCleanSamLabeled = labelReadsTranscriptClean.outputLabeledSAM
        Array[File?] transcriptCleanSamReadLabels = labelReadsTranscriptClean.outputReadLabels
    }

    parameter_meta {
        # inputs
        sample: {description: "The sample data.", category: "required"}
        outputDirectory: {description: "The directory to which the outputs will be written.", category: "common"}
        referenceGenome: {description: "Reference genome fasta file.", category: "required"}
        referenceGenomeIndex: {description: "Reference genome index file.", category: "required"}
        referenceGenomeDict: {description: "Reference genome dictionary file.", category: "required"}
        presetOption: {description: "This option applies multiple options at the same time in minimap2.", category: "common"}
        runTranscriptClean: {description: "Option to run transcriptclean after minimap2 alignment.", category: "common"}
        dockerImages: {description: "The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}
        variantVCF: {description: "Vcf formatted file of variants.", category: "common"}
        howToFindGTAG: {description: "How to find GT-AG. f:transcript strand, b:both strands, n:don't match GT-AG.", category: "common"}
        spliceJunctionsFile: {description: "A pre-generated splice junction annotation file.", category: "advanced"}
        annotationGTFrefflat: {description: "A refflat file of the annotation gtf used.", category: "common"}

        # outputs
        workflowSam: {description: "Either the minimap2 or transcriptclean Sam file(s)."}
        minimap2Sam: {description: "Mapping and alignment between collections of DNA sequence file(s)."}
        minimap2SortedBam: {description: "Minimap2 Bam file(s) sorted on position."}
        minimap2SortedBai: {description: "Index of sorted minimap2 Bam file(s)."}
        minimap2SamLabeled: {description: "Minimap2 alignments labeled for internal priming."}
        minimap2SamReadLabels: {description: "Tabular file with fraction description per read for minimap2 alignment."}
        workflowReports: {description: "A collection of all metrics."}
        transcriptCleanFasta: {description: "Fasta file(s) containing corrected reads."}
        transcriptCleanLog: {description: "Log file(s) of transcriptclean run."}
        transcriptCleanSam: {description: "Sam file(s) containing corrected reads."}
        transcriptCleanTELog: {description: "TE log file(s) of transcriptclean run."}
        transcriptCleanSortedBam: {description: "Transcriptclean bam file(s) sorted on position."}
        transcriptCleanSortedBai: {description: "Index of sorted transcriptclean bam file(s)."}
        transcriptCleanSamLabeled: {description: "Transcriptclean alignments labeled for internal priming."}
        transcriptCleanSamReadLabels: {description: "Tabular file(s) with fraction description per read for TranscriptClean alignment."}
    }
}
