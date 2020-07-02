Changelog
==========

<!--
Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->

version develop
---------------------------
+ Update TALON to version 5.0.
+ Make the MultiQC task suitable for use with a `final_workflow_outputs_dir`
  so it can be used on all of Cromwell's supported backends.
+ Tasks were updated to contain the `time_minutes` runtime attribute and
  associated `timeMinutes` input, describing the maximum time the task will
  take to run.
+ Add BamMetrics for stats on TranscriptClean alignment.
+ Renamed workflow from `pipeline` to `TalonWDL`.
+ Remove Jenkinsfile from repo.
+ Add multiqc to collect all stats.
+ Add BamMetrics for stats on minimap2 alignment.
+ Add indexing of sam files and reference genome.
+ Add fastqc task for stats on input files.
+ Update documentation with more specific example of sample sheet CSV file.
+ Update TALON to version 4.4.2.
+ Add prepulling docker images to Jenkins.
+ Remove YAML examples from documentation.
+ Remove cromwell config from Travis.
+ Added inputs overview to docs.
+ Added WDL-AID to linting.
+ Remove RunTalon task and now use talon.wdl to run the main TALON script.
+ Update biowdl-input-converter to 0.2.1.
+ Update TALON to version 4.4.1.
+ Add parameter_meta to pipeline.wdl workflow.
+ Update TALON to version 4.4.
+ Update TranscriptClean to version 2.0.2.
+ Change samplesheet converter from SampleConfigToSampleReadgroupLists to InputConverter.
+ Splice Junctions file is no longer created when TranscriptClean is set to FALSE.
+ TALON logs are now in the specified output directory.
+ Added link to documentation in README.
+ Added test for TranscriptClean skip and renamed tests.
+ Removed user input for TALON config file, is now created by pipeline.
+ TranscriptClean can now be skipped.
+ Added documentation to repository.
+ Removed TALON QC logs from test_pipelines.yml.
+ Fixed bug were TALON QC logs would be overwritten by next dataset in line.
+ Create the Minimap2, TranscriptClean, TALON pipeline.
