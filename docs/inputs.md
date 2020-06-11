# TalonWDL


## Inputs


### Required inputs
<p name="TalonWDL.annotationGTF">
        <b>TalonWDL.annotationGTF</b><br />
        <i>File &mdash; Default: None</i><br />
        GTF annotation containing genes, transcripts, and edges.
</p>
<p name="TalonWDL.annotationVersion">
        <b>TalonWDL.annotationVersion</b><br />
        <i>String &mdash; Default: None</i><br />
        Name of supplied annotation (will be used to label data).
</p>
<p name="TalonWDL.dockerImagesFile">
        <b>TalonWDL.dockerImagesFile</b><br />
        <i>File &mdash; Default: None</i><br />
        The docker image used for this workflow. Changing this may result in errors which the developers may choose not to address.
</p>
<p name="TalonWDL.executeSampleWorkflow.presetOption">
        <b>TalonWDL.executeSampleWorkflow.presetOption</b><br />
        <i>String &mdash; Default: None</i><br />
        This option applies multiple options at the same time in minimap2.
</p>
<p name="TalonWDL.genomeBuild">
        <b>TalonWDL.genomeBuild</b><br />
        <i>String &mdash; Default: None</i><br />
        Genome build (i.e. hg38) to use.
</p>
<p name="TalonWDL.organismName">
        <b>TalonWDL.organismName</b><br />
        <i>String &mdash; Default: None</i><br />
        The name of the organism from which the data was collected.
</p>
<p name="TalonWDL.pipelineRunName">
        <b>TalonWDL.pipelineRunName</b><br />
        <i>String &mdash; Default: None</i><br />
        A name describing the pipeline run.
</p>
<p name="TalonWDL.referenceGenome">
        <b>TalonWDL.referenceGenome</b><br />
        <i>File &mdash; Default: None</i><br />
        Reference genome fasta file.
</p>
<p name="TalonWDL.sampleConfigFile">
        <b>TalonWDL.sampleConfigFile</b><br />
        <i>File &mdash; Default: None</i><br />
        Samplesheet describing input fasta/fastq files.
</p>
<p name="TalonWDL.sequencingPlatform">
        <b>TalonWDL.sequencingPlatform</b><br />
        <i>String &mdash; Default: None</i><br />
        The sequencing machine used to generate the data.
</p>

### Other common inputs
<p name="TalonWDL.annotationGTFrefflat">
        <b>TalonWDL.annotationGTFrefflat</b><br />
        <i>File? &mdash; Default: None</i><br />
        A refflat file of the annotation GTF used.
</p>
<p name="TalonWDL.createDatabase.minimumLength">
        <b>TalonWDL.createDatabase.minimumLength</b><br />
        <i>Int &mdash; Default: 300</i><br />
        Minimum required transcript length.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.ampliconIntervals">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.ampliconIntervals</b><br />
        <i>File? &mdash; Default: None</i><br />
        An interval list describinig the coordinates of the amplicons sequenced. This should only be used for targeted sequencing or WES. Required if `ampliconIntervals` is defined.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.strandedness">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.strandedness</b><br />
        <i>String &mdash; Default: "None"</i><br />
        The strandedness of the RNA sequencing library preparation. One of "None" (unstranded), "FR" (forward-reverse: first read equal transcript) or "RF" (reverse-forward: second read equals transcript).
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetIntervals">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetIntervals</b><br />
        <i>Array[File]+? &mdash; Default: None</i><br />
        An interval list describing the coordinates of the targets sequenced. This should only be used for targeted sequencing or WES. If defined targeted PCR metrics will be collected. Requires `ampliconIntervals` to also be defined.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.ampliconIntervals">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.ampliconIntervals</b><br />
        <i>File? &mdash; Default: None</i><br />
        An interval list describinig the coordinates of the amplicons sequenced. This should only be used for targeted sequencing or WES. Required if `ampliconIntervals` is defined.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.refRefflat">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.refRefflat</b><br />
        <i>File? &mdash; Default: None</i><br />
        A refflat file containing gene annotations. If defined RNA sequencing metrics will be collected.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.strandedness">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.strandedness</b><br />
        <i>String &mdash; Default: "None"</i><br />
        The strandedness of the RNA sequencing library preparation. One of "None" (unstranded), "FR" (forward-reverse: first read equal transcript) or "RF" (reverse-forward: second read equals transcript).
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetIntervals">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetIntervals</b><br />
        <i>Array[File]+? &mdash; Default: None</i><br />
        An interval list describing the coordinates of the targets sequenced. This should only be used for targeted sequencing or WES. If defined targeted PCR metrics will be collected. Requires `ampliconIntervals` to also be defined.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.bufferSize">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.bufferSize</b><br />
        <i>Int &mdash; Default: 100</i><br />
        Number of lines to output to file at once by each thread during run.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.correctIndels">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.correctIndels</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Set this to make TranscriptClean correct indels.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.correctMismatches">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.correctMismatches</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Set this to make TranscriptClean correct mismatches.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.correctSJs">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.correctSJs</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Set this to make TranscriptClean correct splice junctions.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.deleteTmp">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.deleteTmp</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        The temporary directory generated by TranscriptClean will be removed.
</p>
<p name="TalonWDL.executeSampleWorkflow.howToFindGTAG">
        <b>TalonWDL.executeSampleWorkflow.howToFindGTAG</b><br />
        <i>String? &mdash; Default: None</i><br />
        How to find GT-AG. f:transcript strand, b:both strands, n:don't match GT-AG.
</p>
<p name="TalonWDL.executeSampleWorkflow.variantVCF">
        <b>TalonWDL.executeSampleWorkflow.variantVCF</b><br />
        <i>File? &mdash; Default: None</i><br />
        VCF formatted file of variants.
</p>
<p name="TalonWDL.executeTalon.minimumCoverage">
        <b>TalonWDL.executeTalon.minimumCoverage</b><br />
        <i>Float &mdash; Default: 0.9</i><br />
        Minimum alignment coverage in order to use a SAM entry.
</p>
<p name="TalonWDL.executeTalon.minimumIdentity">
        <b>TalonWDL.executeTalon.minimumIdentity</b><br />
        <i>Int &mdash; Default: 0</i><br />
        Minimum alignment identity in order to use a SAM entry.
</p>
<p name="TalonWDL.novelIDprefix">
        <b>TalonWDL.novelIDprefix</b><br />
        <i>String &mdash; Default: "TALON"</i><br />
        Prefix for naming novel discoveries in eventual TALON runs.
</p>
<p name="TalonWDL.outputDirectory">
        <b>TalonWDL.outputDirectory</b><br />
        <i>String &mdash; Default: "."</i><br />
        The directory to which the outputs will be written.
</p>
<p name="TalonWDL.runTranscriptClean">
        <b>TalonWDL.runTranscriptClean</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Option to run TranscriptClean after Minimap2 alignment.
</p>

### Advanced inputs
<details>
<summary> Show/Hide </summary>
<p name="TalonWDL.convertDockerImagesFile.dockerImage">
        <b>TalonWDL.convertDockerImagesFile.dockerImage</b><br />
        <i>String &mdash; Default: "quay.io/biocontainers/biowdl-input-converter:0.2.1--py_0"</i><br />
        The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</p>
<p name="TalonWDL.convertDockerImagesFile.memory">
        <b>TalonWDL.convertDockerImagesFile.memory</b><br />
        <i>String &mdash; Default: "128M"</i><br />
        The maximum amount of memory the job will need.
</p>
<p name="TalonWDL.convertDockerImagesFile.timeMinutes">
        <b>TalonWDL.convertDockerImagesFile.timeMinutes</b><br />
        <i>Int &mdash; Default: 1</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.convertSampleConfig.checkFileMd5sums">
        <b>TalonWDL.convertSampleConfig.checkFileMd5sums</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Whether or not the MD5 sums of the files mentioned in the samplesheet should be checked.
</p>
<p name="TalonWDL.convertSampleConfig.old">
        <b>TalonWDL.convertSampleConfig.old</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Whether or not the old samplesheet format should be used.
</p>
<p name="TalonWDL.convertSampleConfig.skipFileCheck">
        <b>TalonWDL.convertSampleConfig.skipFileCheck</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Whether or not the existance of the files mentioned in the samplesheet should be checked.
</p>
<p name="TalonWDL.convertSampleConfig.timeMinutes">
        <b>TalonWDL.convertSampleConfig.timeMinutes</b><br />
        <i>Int &mdash; Default: 1</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.createAbundanceFile.datasetsFile">
        <b>TalonWDL.createAbundanceFile.datasetsFile</b><br />
        <i>File? &mdash; Default: None</i><br />
        A file indicating which datasets should be included.
</p>
<p name="TalonWDL.createAbundanceFile.memory">
        <b>TalonWDL.createAbundanceFile.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.createAbundanceFile.timeMinutes">
        <b>TalonWDL.createAbundanceFile.timeMinutes</b><br />
        <i>Int &mdash; Default: 30</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.createAbundanceFile.whitelistFile">
        <b>TalonWDL.createAbundanceFile.whitelistFile</b><br />
        <i>File? &mdash; Default: None</i><br />
        Whitelist file of transcripts to include in the output.
</p>
<p name="TalonWDL.createDatabase.cutoff3p">
        <b>TalonWDL.createDatabase.cutoff3p</b><br />
        <i>Int &mdash; Default: 300</i><br />
        Maximum allowable distance (bp) at the 3' end during annotation.
</p>
<p name="TalonWDL.createDatabase.cutoff5p">
        <b>TalonWDL.createDatabase.cutoff5p</b><br />
        <i>Int &mdash; Default: 500</i><br />
        Maximum allowable distance (bp) at the 5' end during annotation.
</p>
<p name="TalonWDL.createDatabase.memory">
        <b>TalonWDL.createDatabase.memory</b><br />
        <i>String &mdash; Default: "10G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.createDatabase.timeMinutes">
        <b>TalonWDL.createDatabase.timeMinutes</b><br />
        <i>Int &mdash; Default: 60</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.createSJsfile.memory">
        <b>TalonWDL.createSJsfile.memory</b><br />
        <i>String &mdash; Default: "8G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.createSJsfile.minIntronSize">
        <b>TalonWDL.createSJsfile.minIntronSize</b><br />
        <i>Int &mdash; Default: 21</i><br />
        Minimum size of intron to consider a junction.
</p>
<p name="TalonWDL.createSJsfile.timeMinutes">
        <b>TalonWDL.createSJsfile.timeMinutes</b><br />
        <i>Int &mdash; Default: 30</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.createSummaryFile.datasetGroupsCSV">
        <b>TalonWDL.createSummaryFile.datasetGroupsCSV</b><br />
        <i>File? &mdash; Default: None</i><br />
        File of comma-delimited dataset groups to process together.
</p>
<p name="TalonWDL.createSummaryFile.memory">
        <b>TalonWDL.createSummaryFile.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.createSummaryFile.setVerbose">
        <b>TalonWDL.createSummaryFile.setVerbose</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Print out the counts in terminal.
</p>
<p name="TalonWDL.createSummaryFile.timeMinutes">
        <b>TalonWDL.createSummaryFile.timeMinutes</b><br />
        <i>Int &mdash; Default: 50</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executePicardDict.javaXmx">
        <b>TalonWDL.executePicardDict.javaXmx</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executePicardDict.memory">
        <b>TalonWDL.executePicardDict.memory</b><br />
        <i>String &mdash; Default: "3G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.ampliconIntervalsLists.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.ampliconIntervalsLists.javaXmx</b><br />
        <i>String &mdash; Default: "3G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.ampliconIntervalsLists.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.ampliconIntervalsLists.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.ampliconIntervalsLists.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.ampliconIntervalsLists.timeMinutes</b><br />
        <i>Int &mdash; Default: 5</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.collectAlignmentSummaryMetrics">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.collectAlignmentSummaryMetrics</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectAlignmentSummaryMetrics` argument in Picard.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.Flagstat.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.Flagstat.memory</b><br />
        <i>String &mdash; Default: "1G"</i><br />
        The amount of memory needed for the job.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.Flagstat.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.Flagstat.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil(size(inputBam,"G"))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.meanQualityByCycle">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.meanQualityByCycle</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=MeanQualityByCycle` argument in Picard.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectBaseDistributionByCycle">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectBaseDistributionByCycle</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectBaseDistributionByCycle` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectGcBiasMetrics">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectGcBiasMetrics</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectGcBiasMetrics` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectInsertSizeMetrics">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectInsertSizeMetrics</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectInsertSizeMetrics` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectQualityYieldMetrics">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectQualityYieldMetrics</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectQualityYieldMetrics` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectSequencingArtifactMetrics">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.collectSequencingArtifactMetrics</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectSequencingArtifactMetrics` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.javaXmx</b><br />
        <i>String &mdash; Default: "8G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.memory</b><br />
        <i>String &mdash; Default: "9G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.qualityScoreDistribution">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.qualityScoreDistribution</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=QualityScoreDistribution` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.picardMetrics.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam,"G") * 6))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.rnaSeqMetrics.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.rnaSeqMetrics.javaXmx</b><br />
        <i>String &mdash; Default: "8G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.rnaSeqMetrics.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.rnaSeqMetrics.memory</b><br />
        <i>String &mdash; Default: "9G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.rnaSeqMetrics.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.rnaSeqMetrics.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam,"G") * 6))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetIntervalsLists.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetIntervalsLists.javaXmx</b><br />
        <i>String &mdash; Default: "3G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetIntervalsLists.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetIntervalsLists.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetIntervalsLists.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetIntervalsLists.timeMinutes</b><br />
        <i>Int &mdash; Default: 5</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetMetrics.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetMetrics.javaXmx</b><br />
        <i>String &mdash; Default: "3G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetMetrics.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetMetrics.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetMetrics.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsMinimap2.targetMetrics.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam,"G") * 6))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.ampliconIntervalsLists.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.ampliconIntervalsLists.javaXmx</b><br />
        <i>String &mdash; Default: "3G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.ampliconIntervalsLists.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.ampliconIntervalsLists.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.ampliconIntervalsLists.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.ampliconIntervalsLists.timeMinutes</b><br />
        <i>Int &mdash; Default: 5</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.Flagstat.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.Flagstat.memory</b><br />
        <i>String &mdash; Default: "1G"</i><br />
        The amount of memory needed for the job.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.Flagstat.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.Flagstat.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil(size(inputBam,"G"))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectBaseDistributionByCycle">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectBaseDistributionByCycle</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectBaseDistributionByCycle` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectGcBiasMetrics">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectGcBiasMetrics</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectGcBiasMetrics` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectInsertSizeMetrics">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectInsertSizeMetrics</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectInsertSizeMetrics` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectQualityYieldMetrics">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectQualityYieldMetrics</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectQualityYieldMetrics` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectSequencingArtifactMetrics">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.collectSequencingArtifactMetrics</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=CollectSequencingArtifactMetrics` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.javaXmx</b><br />
        <i>String &mdash; Default: "8G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.memory</b><br />
        <i>String &mdash; Default: "9G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.qualityScoreDistribution">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.qualityScoreDistribution</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to the `PROGRAM=QualityScoreDistribution` argument.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.picardMetrics.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam,"G") * 6))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.rnaSeqMetrics.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.rnaSeqMetrics.javaXmx</b><br />
        <i>String &mdash; Default: "8G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.rnaSeqMetrics.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.rnaSeqMetrics.memory</b><br />
        <i>String &mdash; Default: "9G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.rnaSeqMetrics.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.rnaSeqMetrics.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam,"G") * 6))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetIntervalsLists.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetIntervalsLists.javaXmx</b><br />
        <i>String &mdash; Default: "3G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetIntervalsLists.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetIntervalsLists.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetIntervalsLists.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetIntervalsLists.timeMinutes</b><br />
        <i>Int &mdash; Default: 5</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetMetrics.javaXmx">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetMetrics.javaXmx</b><br />
        <i>String &mdash; Default: "3G"</i><br />
        The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetMetrics.memory">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetMetrics.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetMetrics.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.bamMetricsTranscriptClean.targetMetrics.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam,"G") * 6))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeIndexMinimap2.memory">
        <b>TalonWDL.executeSampleWorkflow.executeIndexMinimap2.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory needed for the job.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeIndexMinimap2.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.executeIndexMinimap2.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(bamFile,"G") * 4))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeIndexTranscriptClean.memory">
        <b>TalonWDL.executeSampleWorkflow.executeIndexTranscriptClean.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory needed for the job.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeIndexTranscriptClean.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.executeIndexTranscriptClean.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(bamFile,"G") * 4))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.cores">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.cores</b><br />
        <i>Int &mdash; Default: 4</i><br />
        The number of cores to be used.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.kmerSize">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.kmerSize</b><br />
        <i>Int &mdash; Default: 15</i><br />
        K-mer size (no larger than 28).
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.matchingScore">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.matchingScore</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Matching score.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.maxFragmentLength">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.maxFragmentLength</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Max fragment length (effective with -xsr or in the fragment mode).
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.maxIntronLength">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.maxIntronLength</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Max intron length (effective with -xsplice; changing -r).
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.memory">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.memory</b><br />
        <i>String &mdash; Default: "30G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.mismatchPenalty">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.mismatchPenalty</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Mismatch penalty.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.retainMaxSecondaryAlignments">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.retainMaxSecondaryAlignments</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Retain at most INT secondary alignments.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.secondaryAlignment">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.secondaryAlignment</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Whether to output secondary alignments.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.skipSelfAndDualMappings">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.skipSelfAndDualMappings</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Skip self and dual mappings (for the all-vs-all mode).
</p>
<p name="TalonWDL.executeSampleWorkflow.executeMinimap2.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.executeMinimap2.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(queryFile,"G") * 200 / cores))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortMinimap2.compressionLevel">
        <b>TalonWDL.executeSampleWorkflow.executeSortMinimap2.compressionLevel</b><br />
        <i>Int &mdash; Default: 1</i><br />
        Compression level from 0 (uncompressed) to 9 (best).
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortMinimap2.memory">
        <b>TalonWDL.executeSampleWorkflow.executeSortMinimap2.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortMinimap2.sortByName">
        <b>TalonWDL.executeSampleWorkflow.executeSortMinimap2.sortByName</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Sort the inputBam by read name instead of position.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortMinimap2.threads">
        <b>TalonWDL.executeSampleWorkflow.executeSortMinimap2.threads</b><br />
        <i>Int? &mdash; Default: None</i><br />
        The number of additional threads that will be used for this task.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortMinimap2.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.executeSortMinimap2.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam,"G") * 2))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.compressionLevel">
        <b>TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.compressionLevel</b><br />
        <i>Int &mdash; Default: 1</i><br />
        Compression level from 0 (uncompressed) to 9 (best).
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.memory">
        <b>TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.sortByName">
        <b>TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.sortByName</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Sort the inputBam by read name instead of position.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.threads">
        <b>TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.threads</b><br />
        <i>Int? &mdash; Default: None</i><br />
        The number of additional threads that will be used for this task.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.executeSortTranscriptClean.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(inputBam,"G") * 2))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.canonOnly">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.canonOnly</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Only output canonical transcripts and transcript containing annotated noncanonical junctions.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.cores">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.cores</b><br />
        <i>Int &mdash; Default: 1</i><br />
        The number of cores to be used.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.dryRun">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.dryRun</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        TranscriptClean will read in the data but don't do any correction.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.maxLenIndel">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.maxLenIndel</b><br />
        <i>Int &mdash; Default: 5</i><br />
        Maximum size indel to correct.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.maxSJoffset">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.maxSJoffset</b><br />
        <i>Int &mdash; Default: 5</i><br />
        Maximum distance from annotated splice junction to correct.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.memory">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.memory</b><br />
        <i>String &mdash; Default: "25G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.executeSampleWorkflow.executeTranscriptClean.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.executeTranscriptClean.timeMinutes</b><br />
        <i>Int &mdash; Default: 2880</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.adapters">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.adapters</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to fastqc's --adapters option.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.casava">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.casava</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --casava flag.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.contaminants">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.contaminants</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to fastqc's --contaminants option.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.dir">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.dir</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to fastqc's --dir option.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.extract">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.extract</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --extract flag.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.format">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.format</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to fastqc's --format option.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.kmers">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.kmers</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Equivalent to fastqc's --kmers option.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.limits">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.limits</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to fastqc's --limits option.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.memory">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.memory</b><br />
        <i>String &mdash; Default: "~{250 + 250 * threads}M"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.minLength">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.minLength</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Equivalent to fastqc's --min_length option.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.nano">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.nano</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --nano flag.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.noFilter">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.noFilter</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --nofilter flag.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.nogroup">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.nogroup</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to fastqc's --nogroup flag.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.threads">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.threads</b><br />
        <i>Int &mdash; Default: 1</i><br />
        The number of cores to use.
</p>
<p name="TalonWDL.executeSampleWorkflow.fastqcTask.timeMinutes">
        <b>TalonWDL.executeSampleWorkflow.fastqcTask.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil(size(seqFile,"G")) * 4</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.executeSamtoolsFaidx.memory">
        <b>TalonWDL.executeSamtoolsFaidx.memory</b><br />
        <i>String &mdash; Default: "2G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.executeTalon.cores">
        <b>TalonWDL.executeTalon.cores</b><br />
        <i>Int &mdash; Default: 4</i><br />
        The number of cores to be used.
</p>
<p name="TalonWDL.executeTalon.memory">
        <b>TalonWDL.executeTalon.memory</b><br />
        <i>String &mdash; Default: "25G"</i><br />
        The amount of memory available to the job.
</p>
<p name="TalonWDL.executeTalon.timeMinutes">
        <b>TalonWDL.executeTalon.timeMinutes</b><br />
        <i>Int &mdash; Default: 2880</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.multiqcTask.clConfig">
        <b>TalonWDL.multiqcTask.clConfig</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--cl-config` option.
</p>
<p name="TalonWDL.multiqcTask.comment">
        <b>TalonWDL.multiqcTask.comment</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--comment` option.
</p>
<p name="TalonWDL.multiqcTask.config">
        <b>TalonWDL.multiqcTask.config</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--config` option.
</p>
<p name="TalonWDL.multiqcTask.dataFormat">
        <b>TalonWDL.multiqcTask.dataFormat</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--data-format` option.
</p>
<p name="TalonWDL.multiqcTask.dirs">
        <b>TalonWDL.multiqcTask.dirs</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--dirs` flag.
</p>
<p name="TalonWDL.multiqcTask.dirsDepth">
        <b>TalonWDL.multiqcTask.dirsDepth</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--dirs-depth` option.
</p>
<p name="TalonWDL.multiqcTask.exclude">
        <b>TalonWDL.multiqcTask.exclude</b><br />
        <i>Array[String]+? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--exclude` option.
</p>
<p name="TalonWDL.multiqcTask.export">
        <b>TalonWDL.multiqcTask.export</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--export` flag.
</p>
<p name="TalonWDL.multiqcTask.fileList">
        <b>TalonWDL.multiqcTask.fileList</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--file-list` option.
</p>
<p name="TalonWDL.multiqcTask.fileName">
        <b>TalonWDL.multiqcTask.fileName</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--filename` option.
</p>
<p name="TalonWDL.multiqcTask.flat">
        <b>TalonWDL.multiqcTask.flat</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--flat` flag.
</p>
<p name="TalonWDL.multiqcTask.force">
        <b>TalonWDL.multiqcTask.force</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--force` flag.
</p>
<p name="TalonWDL.multiqcTask.fullNames">
        <b>TalonWDL.multiqcTask.fullNames</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--fullnames` flag.
</p>
<p name="TalonWDL.multiqcTask.ignore">
        <b>TalonWDL.multiqcTask.ignore</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--ignore` option.
</p>
<p name="TalonWDL.multiqcTask.ignoreSamples">
        <b>TalonWDL.multiqcTask.ignoreSamples</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--ignore-samples` option.
</p>
<p name="TalonWDL.multiqcTask.interactive">
        <b>TalonWDL.multiqcTask.interactive</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to MultiQC's `--interactive` flag.
</p>
<p name="TalonWDL.multiqcTask.lint">
        <b>TalonWDL.multiqcTask.lint</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--lint` flag.
</p>
<p name="TalonWDL.multiqcTask.megaQCUpload">
        <b>TalonWDL.multiqcTask.megaQCUpload</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Opposite to MultiQC's `--no-megaqc-upload` flag.
</p>
<p name="TalonWDL.multiqcTask.memory">
        <b>TalonWDL.multiqcTask.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory this job will use.
</p>
<p name="TalonWDL.multiqcTask.module">
        <b>TalonWDL.multiqcTask.module</b><br />
        <i>Array[String]+? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--module` option.
</p>
<p name="TalonWDL.multiqcTask.pdf">
        <b>TalonWDL.multiqcTask.pdf</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Equivalent to MultiQC's `--pdf` flag.
</p>
<p name="TalonWDL.multiqcTask.sampleNames">
        <b>TalonWDL.multiqcTask.sampleNames</b><br />
        <i>File? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--sample-names` option.
</p>
<p name="TalonWDL.multiqcTask.tag">
        <b>TalonWDL.multiqcTask.tag</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--tag` option.
</p>
<p name="TalonWDL.multiqcTask.template">
        <b>TalonWDL.multiqcTask.template</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--template` option.
</p>
<p name="TalonWDL.multiqcTask.timeMinutes">
        <b>TalonWDL.multiqcTask.timeMinutes</b><br />
        <i>Int &mdash; Default: 120</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="TalonWDL.multiqcTask.title">
        <b>TalonWDL.multiqcTask.title</b><br />
        <i>String? &mdash; Default: None</i><br />
        Equivalent to MultiQC's `--title` option.
</p>
<p name="TalonWDL.multiqcTask.zipDataDir">
        <b>TalonWDL.multiqcTask.zipDataDir</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        Equivalent to MultiQC's `--zip-data-dir` flag.
</p>
<p name="TalonWDL.spliceJunctionsFile">
        <b>TalonWDL.spliceJunctionsFile</b><br />
        <i>File? &mdash; Default: None</i><br />
        A pre-generated splice junction annotation file.
</p>
<p name="TalonWDL.talonDatabase">
        <b>TalonWDL.talonDatabase</b><br />
        <i>File? &mdash; Default: None</i><br />
        A pre-generated TALON database file.
</p>
</details>








<hr />

> Generated using WDL AID (0.1.1)
