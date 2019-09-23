---
layout: default
title: Home
---

This pipeline can be used to process RNA sequenced by either the Pacific Biosciences or Oxford Nanopore sequencer, starting from FastQ files. It will perform mapping to a reference genome (using minimap2), INDEL/mismatch and noncanonical splice junction correction (using TranscriptClean) and identify and count known and novel genes/transcripts (using TALON).

This pipeline is part of [BioWDL](https://biowdl.github.io/)
developed by the SASC team at [Leiden University Medical Center](https://www.lumc.nl/).

## Usage
You can run the pipeline using
[Cromwell](http://cromwell.readthedocs.io/en/stable/):

```bash
java -jar cromwell-<version>.jar run -i inputs.json pipeline.wdl
```

### Inputs
Inputs are provided through a JSON file. The minimally required inputs are
described below, but additional inputs are available.
A template containing all possible inputs can be generated using
Womtool as described in the
[WOMtool documentation](http://cromwell.readthedocs.io/en/stable/WOMtool/).

```json
{
    "Pipeline.sampleConfigFile": "A sample configuration file (see below).",
    "Pipeline.outputDirectory": "The path to the output directory.",
    "Pipeline.annotationGTF": "GTF annotation containing genes, transcripts, and edges.",
    "Pipeline.genomeBuild": "Name of genome build that the GTF file is based on (ie hg38).",
    "Pipeline.annotationVersion": "Name of supplied annotation (will be used to label data).",
    "Pipeline.referenceGenome": "Reference genome fasta file.",
    "Pipeline.sequencingPlatform": "The sequencing platform used to generate long reads.",
    "Pipeline.talonConfigFile": "TALON specific configuration file",
    "Pipeline.pipelineRunName": "A short name to distinguish a run.",
    "Pipeline.dockerImagesFile": "A file listing the used docker images.",
    "Pipeline.sampleWorkflow.presetOption": "This option applies multiple options at the same time to minimap2."
}
```

#### Sample configuration
The sample configuration should be a YML file which adheres to the following
structure:

```yml
samples:
  - id: <sampleId>
    libraries:
      - id: <libId>
        readgroups:
          - id: <rgId>
            reads:
              R1: <Path to first FastQ file.>
              R1_md5: <Path to MD5 checksum file of first FastQ file.>
              R2: <Path to second FastQ file.>
              R2_md5: <Path to MD5 checksum file of second FastQ file.>
```
Replace the text between `< >` with appropriate values. R2 values may be
omitted in the case of one FastQ file for a sample. Multiple samples, libraries (per
sample) and readgroups (per library) may be given.

#### Example
The following is an example of what an inputs JSON might look like:

```json
{
    "Pipeline.sampleConfigFile": "/tests/samplesheets/nanopore.yml",
    "Pipeline.outputDirectory": "/tests/test-ouput",
    "Pipeline.annotationGTF": "/tests/data/gencode.v29.annotation.gtf",
    "Pipeline.genomeBuild": "hg38",
    "Pipeline.annotationVersion": "gencode_v29",
    "Pipeline.referenceGenome": "/tests/data/GRCh38.fasta",
    "Pipeline.sequencingPlatform": "Nanopore",
    "Pipeline.talonConfigFile": "/tests/data/nanoporeTALONconfigFile.csv",
    "Pipeline.pipelineRunName": "testRun",
    "Pipeline.dockerImagesFile": "dockerImages.yml",
    "Pipeline.sampleWorkflow.presetOption": "splice"
}
```

And the associated sample configuration YML might look like this:
```yml
samples:
  - id: GM12878
    libraries:
      - id: lib1
        readgroups:
          - id: rg1
            reads:
              R1: /tests/data/ONT_GM12878_SUBSET.fastq
              R1_md5: 750dc282c02948b3f75a7ea76eeb3464
```

### Dependency requirements and tool versions
Biowdl pipelines use docker images to ensure  reproducibility. This
means that biowdl pipelines will run on any system that has docker
installed. Alternatively they can be run with singularity.

For more advanced configuration of docker or singularity please check
the [cromwell documentation on containers](
https://cromwell.readthedocs.io/en/stable/tutorials/Containers/).

Images from [biocontainers](https://biocontainers.pro) are preferred for
biowdl pipelines. The list of default images for this pipeline can be
found in the default for the `dockerImages` input.

### Output
The workflow will output mapped reads by minimap2 in a .sam file, a cleaned .sam file and log information from TranscriptClean, a database containing transcript information together with a log file of read/transcript comparison and a abundance plus summary file of the database.

## Contact
<p>
  <!-- Obscure e-mail address for spammers -->
For any questions about running this pipeline and feature request (such as
adding additional tools and options), please use the
<a href='https://github.com/biowdl/TALON-WDL/issues'>github issue tracker</a>
or contact the SASC team directly at: 
<a href='&#109;&#97;&#105;&#108;&#116;&#111;&#58;&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;'>
&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;</a>.
</p>
