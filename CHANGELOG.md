Changelog
==========

<!--
Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->

version develop
---------------------------
+ Add NanoPlot & NanoQC to the pipeline.
+ Update tasks and the input/output names.
+ Rename workflow outputs to shorter names.
+ Add `meta {allowNestedInputs: true}` to the workflows, to allow for the use
  of nested inputs.
+ Remove `execute` from the naming structure for calls of tasks and workflows.
+ Samtools index task was removed because samtools sort task now also creates
  a index.
+ Replace test files and tests for nanopore.
+ Add new test files and tests for pacbio.
+ Add `LabelReads` task from talon for labeling possible internal priming, both
  on minimap2 and transcriptclean alignments.
+ Update talon to version 5.0.
+ Make the multiqc task suitable for use with a `final_workflow_outputs_dir`
  so it can be used on all of cromwell's supported backends.
+ Tasks were updated to contain the `time_minutes` runtime attribute and
  associated `timeMinutes` input, describing the maximum time the task will
  take to run.
+ Add bammetrics for stats on transcriptclean alignment.
+ Renamed workflow from `pipeline` to `TalonWDL`.
+ Remove jenkinsfile from repo.
+ Add multiqc to collect all stats.
+ Add bammetrics for stats on minimap2 alignment.
+ Add indexing of sam files and reference genome.
+ Add fastqc task for stats on input files.
+ Update documentation with more specific example of sample sheet csv file.
+ Update talon to version 4.4.2.
+ Add prepulling docker images to jenkins.
+ Remove yaml examples from documentation.
+ Remove cromwell config from travis.
+ Added inputs overview to docs.
+ Added wdl-aid to linting.
+ Remove RunTalon task and now use talon.wdl to run the main talon script.
+ Update biowdl-input-converter to 0.2.1.
+ Update talon to version 4.4.1.
+ Add parameter_meta to pipeline.wdl workflow.
+ Update talon to version 4.4.
+ Update transcriptclean to version 2.0.2.
+ Change samplesheet converter from SampleConfigToSampleReadgroupLists to InputConverter.
+ Splice junctions file is no longer created when transcriptclean is set to FALSE.
+ Talon logs are now in the specified output directory.
+ Added link to documentation in README.
+ Added test for transcriptclean skip and renamed tests.
+ Removed user input for talon config file, is now created by pipeline.
+ Transcriptclean can now be skipped.
+ Added documentation to repository.
+ Removed talon qc logs from test_pipelines.yml.
+ Fixed bug were talon qc logs would be overwritten by next dataset in line.
+ Create the minimap2, transcriptclean, talon pipeline.
