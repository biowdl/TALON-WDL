---
layout: default
title: "Inputs: Pipeline"
---

# Inputs for Pipeline

The following is an overview of all available inputs in
Pipeline.


## Required inputs
<dl>
<dt id="Pipeline.annotationGTF"><a href="#Pipeline.annotationGTF">Pipeline.annotationGTF</a></dt>
<dd>
    <i>File </i><br />
    GTF annotation containing genes, transcripts, and edges.
</dd>
<dt id="Pipeline.annotationVersion"><a href="#Pipeline.annotationVersion">Pipeline.annotationVersion</a></dt>
<dd>
    <i>String </i><br />
    Name of supplied annotation (will be used to label data).
</dd>
<dt id="Pipeline.dockerImagesFile"><a href="#Pipeline.dockerImagesFile">Pipeline.dockerImagesFile</a></dt>
<dd>
    <i>File </i><br />
    The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="Pipeline.executeSampleWorkflow.presetOption"><a href="#Pipeline.executeSampleWorkflow.presetOption">Pipeline.executeSampleWorkflow.presetOption</a></dt>
<dd>
    <i>String </i><br />
    This option applies multiple options at the same time in minimap2.
</dd>
<dt id="Pipeline.genomeBuild"><a href="#Pipeline.genomeBuild">Pipeline.genomeBuild</a></dt>
<dd>
    <i>String </i><br />
    Genome build (i.e. hg38) to use.
</dd>
<dt id="Pipeline.organismName"><a href="#Pipeline.organismName">Pipeline.organismName</a></dt>
<dd>
    <i>String </i><br />
    The name of the organism from which the data was collected.
</dd>
<dt id="Pipeline.pipelineRunName"><a href="#Pipeline.pipelineRunName">Pipeline.pipelineRunName</a></dt>
<dd>
    <i>String </i><br />
    A name describing the pipeline run.
</dd>
<dt id="Pipeline.referenceGenome"><a href="#Pipeline.referenceGenome">Pipeline.referenceGenome</a></dt>
<dd>
    <i>File </i><br />
    Reference genome fasta file.
</dd>
<dt id="Pipeline.sampleConfigFile"><a href="#Pipeline.sampleConfigFile">Pipeline.sampleConfigFile</a></dt>
<dd>
    <i>File </i><br />
    Samplesheet describing input fasta/fastq files.
</dd>
<dt id="Pipeline.sequencingPlatform"><a href="#Pipeline.sequencingPlatform">Pipeline.sequencingPlatform</a></dt>
<dd>
    <i>String </i><br />
    The sequencing machine used to generate the data.
</dd>
</dl>

## Other common inputs
<dl>
<dt id="Pipeline.createDatabase.minimumLength"><a href="#Pipeline.createDatabase.minimumLength">Pipeline.createDatabase.minimumLength</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>300</code><br />
    Minimum required transcript length.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.bufferSize"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.bufferSize">Pipeline.executeSampleWorkflow.executeTranscriptClean.bufferSize</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>100</code><br />
    Number of lines to output to file at once by each thread during run.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.correctIndels"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.correctIndels">Pipeline.executeSampleWorkflow.executeTranscriptClean.correctIndels</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>true</code><br />
    Set this to make TranscriptClean correct indels.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.correctMismatches"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.correctMismatches">Pipeline.executeSampleWorkflow.executeTranscriptClean.correctMismatches</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>true</code><br />
    Set this to make TranscriptClean correct mismatches.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.correctSJs"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.correctSJs">Pipeline.executeSampleWorkflow.executeTranscriptClean.correctSJs</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>true</code><br />
    Set this to make TranscriptClean correct splice junctions.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.deleteTmp"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.deleteTmp">Pipeline.executeSampleWorkflow.executeTranscriptClean.deleteTmp</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>true</code><br />
    The temporary directory generated by TranscriptClean will be removed.
</dd>
<dt id="Pipeline.executeSampleWorkflow.howToFindGTAG"><a href="#Pipeline.executeSampleWorkflow.howToFindGTAG">Pipeline.executeSampleWorkflow.howToFindGTAG</a></dt>
<dd>
    <i>String? </i><br />
    How to find GT-AG. f:transcript strand, b:both strands, n:don't match GT-AG.
</dd>
<dt id="Pipeline.executeSampleWorkflow.variantVCF"><a href="#Pipeline.executeSampleWorkflow.variantVCF">Pipeline.executeSampleWorkflow.variantVCF</a></dt>
<dd>
    <i>File? </i><br />
    VCF formatted file of variants.
</dd>
<dt id="Pipeline.executeTalon.minimumCoverage"><a href="#Pipeline.executeTalon.minimumCoverage">Pipeline.executeTalon.minimumCoverage</a></dt>
<dd>
    <i>Float </i><i>&mdash; Default:</i> <code>0.9</code><br />
    Minimum alignment coverage in order to use a SAM entry.
</dd>
<dt id="Pipeline.executeTalon.minimumIdentity"><a href="#Pipeline.executeTalon.minimumIdentity">Pipeline.executeTalon.minimumIdentity</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>0</code><br />
    Minimum alignment identity in order to use a SAM entry.
</dd>
<dt id="Pipeline.novelIDprefix"><a href="#Pipeline.novelIDprefix">Pipeline.novelIDprefix</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"TALON"</code><br />
    Prefix for naming novel discoveries in eventual TALON runs.
</dd>
<dt id="Pipeline.outputDirectory"><a href="#Pipeline.outputDirectory">Pipeline.outputDirectory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"."</code><br />
    The directory to which the outputs will be written.
</dd>
<dt id="Pipeline.runTranscriptClean"><a href="#Pipeline.runTranscriptClean">Pipeline.runTranscriptClean</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>true</code><br />
    Option to run TranscriptClean after Minimap2 alignment.
</dd>
</dl>

## Advanced inputs
<details>
<summary> Show/Hide </summary>
<dl>
<dt id="Pipeline.convertDockerImagesFile.dockerImage"><a href="#Pipeline.convertDockerImagesFile.dockerImage">Pipeline.convertDockerImagesFile.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"quay.io/biocontainers/biowdl-input-converter:0.2.1--py_0"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="Pipeline.convertSampleConfig.checkFileMd5sums"><a href="#Pipeline.convertSampleConfig.checkFileMd5sums">Pipeline.convertSampleConfig.checkFileMd5sums</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Whether or not the MD5 sums of the files mentioned in the samplesheet should be checked.
</dd>
<dt id="Pipeline.convertSampleConfig.old"><a href="#Pipeline.convertSampleConfig.old">Pipeline.convertSampleConfig.old</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Whether or not the old samplesheet format should be used.
</dd>
<dt id="Pipeline.convertSampleConfig.skipFileCheck"><a href="#Pipeline.convertSampleConfig.skipFileCheck">Pipeline.convertSampleConfig.skipFileCheck</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>true</code><br />
    Whether or not the existance of the files mentioned in the samplesheet should be checked.
</dd>
<dt id="Pipeline.createAbundanceFile.datasetsFile"><a href="#Pipeline.createAbundanceFile.datasetsFile">Pipeline.createAbundanceFile.datasetsFile</a></dt>
<dd>
    <i>File? </i><br />
    A file indicating which datasets should be included.
</dd>
<dt id="Pipeline.createAbundanceFile.memory"><a href="#Pipeline.createAbundanceFile.memory">Pipeline.createAbundanceFile.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"4G"</code><br />
    The amount of memory available to the job.
</dd>
<dt id="Pipeline.createAbundanceFile.whitelistFile"><a href="#Pipeline.createAbundanceFile.whitelistFile">Pipeline.createAbundanceFile.whitelistFile</a></dt>
<dd>
    <i>File? </i><br />
    Whitelist file of transcripts to include in the output.
</dd>
<dt id="Pipeline.createDatabase.cutoff3p"><a href="#Pipeline.createDatabase.cutoff3p">Pipeline.createDatabase.cutoff3p</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>300</code><br />
    Maximum allowable distance (bp) at the 3' end during annotation.
</dd>
<dt id="Pipeline.createDatabase.cutoff5p"><a href="#Pipeline.createDatabase.cutoff5p">Pipeline.createDatabase.cutoff5p</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>500</code><br />
    Maximum allowable distance (bp) at the 5' end during annotation.
</dd>
<dt id="Pipeline.createDatabase.memory"><a href="#Pipeline.createDatabase.memory">Pipeline.createDatabase.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"10G"</code><br />
    The amount of memory available to the job.
</dd>
<dt id="Pipeline.createSJsfile.memory"><a href="#Pipeline.createSJsfile.memory">Pipeline.createSJsfile.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The amount of memory available to the job.
</dd>
<dt id="Pipeline.createSJsfile.minIntronSize"><a href="#Pipeline.createSJsfile.minIntronSize">Pipeline.createSJsfile.minIntronSize</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>21</code><br />
    Minimum size of intron to consider a junction.
</dd>
<dt id="Pipeline.createSummaryFile.datasetGroupsCSV"><a href="#Pipeline.createSummaryFile.datasetGroupsCSV">Pipeline.createSummaryFile.datasetGroupsCSV</a></dt>
<dd>
    <i>File? </i><br />
    File of comma-delimited dataset groups to process together.
</dd>
<dt id="Pipeline.createSummaryFile.memory"><a href="#Pipeline.createSummaryFile.memory">Pipeline.createSummaryFile.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"4G"</code><br />
    The amount of memory available to the job.
</dd>
<dt id="Pipeline.createSummaryFile.setVerbose"><a href="#Pipeline.createSummaryFile.setVerbose">Pipeline.createSummaryFile.setVerbose</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Print out the counts in terminal.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.cores"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.cores">Pipeline.executeSampleWorkflow.executeMinimap2.cores</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>4</code><br />
    The number of cores to be used.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.kmerSize"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.kmerSize">Pipeline.executeSampleWorkflow.executeMinimap2.kmerSize</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>15</code><br />
    K-mer size (no larger than 28).
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.matchingScore"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.matchingScore">Pipeline.executeSampleWorkflow.executeMinimap2.matchingScore</a></dt>
<dd>
    <i>Int? </i><br />
    Matching score.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.maxFragmentLength"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.maxFragmentLength">Pipeline.executeSampleWorkflow.executeMinimap2.maxFragmentLength</a></dt>
<dd>
    <i>Int? </i><br />
    Max fragment length (effective with -xsr or in the fragment mode).
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.maxIntronLength"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.maxIntronLength">Pipeline.executeSampleWorkflow.executeMinimap2.maxIntronLength</a></dt>
<dd>
    <i>Int? </i><br />
    Max intron length (effective with -xsplice; changing -r).
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.memory"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.memory">Pipeline.executeSampleWorkflow.executeMinimap2.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"30G"</code><br />
    The amount of memory available to the job.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.mismatchPenalty"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.mismatchPenalty">Pipeline.executeSampleWorkflow.executeMinimap2.mismatchPenalty</a></dt>
<dd>
    <i>Int? </i><br />
    Mismatch penalty.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.retainMaxSecondaryAlignments"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.retainMaxSecondaryAlignments">Pipeline.executeSampleWorkflow.executeMinimap2.retainMaxSecondaryAlignments</a></dt>
<dd>
    <i>Int? </i><br />
    Retain at most INT secondary alignments.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.secondaryAlignment"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.secondaryAlignment">Pipeline.executeSampleWorkflow.executeMinimap2.secondaryAlignment</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Whether to output secondary alignments.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeMinimap2.skipSelfAndDualMappings"><a href="#Pipeline.executeSampleWorkflow.executeMinimap2.skipSelfAndDualMappings">Pipeline.executeSampleWorkflow.executeMinimap2.skipSelfAndDualMappings</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Skip self and dual mappings (for the all-vs-all mode).
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.canonOnly"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.canonOnly">Pipeline.executeSampleWorkflow.executeTranscriptClean.canonOnly</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Only output canonical transcripts and transcript containing annotated noncanonical junctions.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.cores"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.cores">Pipeline.executeSampleWorkflow.executeTranscriptClean.cores</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1</code><br />
    The number of cores to be used.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.dryRun"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.dryRun">Pipeline.executeSampleWorkflow.executeTranscriptClean.dryRun</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    TranscriptClean will read in the data but don't do any correction.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.maxLenIndel"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.maxLenIndel">Pipeline.executeSampleWorkflow.executeTranscriptClean.maxLenIndel</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>5</code><br />
    Maximum size indel to correct.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.maxSJoffset"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.maxSJoffset">Pipeline.executeSampleWorkflow.executeTranscriptClean.maxSJoffset</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>5</code><br />
    Maximum distance from annotated splice junction to correct.
</dd>
<dt id="Pipeline.executeSampleWorkflow.executeTranscriptClean.memory"><a href="#Pipeline.executeSampleWorkflow.executeTranscriptClean.memory">Pipeline.executeSampleWorkflow.executeTranscriptClean.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"25G"</code><br />
    The amount of memory available to the job.
</dd>
<dt id="Pipeline.executeTalon.cores"><a href="#Pipeline.executeTalon.cores">Pipeline.executeTalon.cores</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>4</code><br />
    The number of cores to be used.
</dd>
<dt id="Pipeline.executeTalon.memory"><a href="#Pipeline.executeTalon.memory">Pipeline.executeTalon.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"25G"</code><br />
    The amount of memory available to the job.
</dd>
<dt id="Pipeline.spliceJunctionsFile"><a href="#Pipeline.spliceJunctionsFile">Pipeline.spliceJunctionsFile</a></dt>
<dd>
    <i>File? </i><br />
    A pre-generated splice junction annotation file.
</dd>
<dt id="Pipeline.talonDatabase"><a href="#Pipeline.talonDatabase">Pipeline.talonDatabase</a></dt>
<dd>
    <i>File? </i><br />
    A pre-generated TALON database file.
</dd>
</dl>
</details>





## Do not set these inputs!
The following inputs should ***not*** be set, even though womtool may
show them as being available inputs.

* Pipeline.NoneFile