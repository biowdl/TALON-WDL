Changelog
==========

<!--
Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->

version 0.1
---------------------------
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
