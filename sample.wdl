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
import "tasks/minimap2.wdl" as minimap2
import "tasks/transcriptclean.wdl" as transcriptClean

workflow SampleWorkflow {
    input {
        Sample sample
        String outputDirectory = "."
        File referenceGenome
        String presetOption
        Boolean runTranscriptClean = true
        Map[String, String] dockerImages

        File? variantVCF
        String? howToFindGTAG
        File? spliceJunctionsFile
    }

    Array[Readgroup] readgroups = sample.readgroups

    scatter (readgroup in readgroups) {
        String readgroupIdentifier = sample.id + "-" + readgroup.lib_id + "-" + readgroup.id
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
        }
    }

    output {
        Array[File] outputSAMsampleWorkflow = if (runTranscriptClean) 
                    then select_all(executeTranscriptClean.outputTranscriptCleanSAM)
                    else executeMinimap2.outputAlignmentFile
        Array[File] outputMinimap2 = executeMinimap2.outputAlignmentFile
        Array[File?] outputTranscriptCleanFasta = executeTranscriptClean.outputTranscriptCleanFasta
        Array[File?] outputTranscriptCleanLog = executeTranscriptClean.outputTranscriptCleanLog
        Array[File?] outputTranscriptCleanSAM = executeTranscriptClean.outputTranscriptCleanSAM
        Array[File?] outputTranscriptCleanTElog = executeTranscriptClean.outputTranscriptCleanTElog
    }

    parameter_meta {
        # inputs
        sample: {description: "The sample data.", category: "required"}
        outputDirectory: {description: "The directory to which the outputs will be written.", category: "common"}
        referenceGenome: {description: "Reference genome fasta file.", category: "required"}
        presetOption: {description: "This option applies multiple options at the same time in minimap2.", category: "common"}
        runTranscriptClean: {description: "Option to run TranscriptClean after Minimap2 alignment.", category: "common"}
        dockerImages: {description: "The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}
        variantVCF: {description: "VCF formatted file of variants.", category: "common"}
        howToFindGTAG: {description: "How to find GT-AG. f:transcript strand, b:both strands, n:don't match GT-AG.", category: "common"}
        spliceJunctionsFile: {description: "A pre-generated splice junction annotation file.", category: "advanced"}

        # outputs
        outputSAMsampleWorkflow: {description: "Either the minimap2 or TranscriptClean SAM file(s)."}
        outputMinimap2: {description: "Mapping and alignment between collections of DNA sequences file(s)."}
        outputTranscriptCleanFasta: {description: "Fasta file(s) containing corrected reads."}
        outputTranscriptCleanLog: {description: "Log file(s) of TranscriptClean run."}
        outputTranscriptCleanSAM: {description: "SAM file(s) containing corrected aligned reads."}
        outputTranscriptCleanTElog: {description: "TE log file(s) of TranscriptClean run."}
    }
}
