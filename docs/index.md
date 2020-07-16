---
layout: default
title: Home
---

This pipeline can be used to process RNA sequenced by either a Pacific
Biosciences sequencer or Oxford Nanopore sequencer, starting from fastq files.
It will perform mapping to a reference genome (using minimap2), INDEL/mismatch
and noncanonical splice junction correction (using TranscriptClean) and
identify and count known and novel genes/transcripts (using TALON).

This pipeline is part of [BioWDL](https://biowdl.github.io/)
developed by the SASC team
at [Leiden University Medical Center](https://www.lumc.nl/).

## Usage
You can run the pipeline using
[Cromwell](http://cromwell.readthedocs.io/en/stable/):

```bash
java -jar cromwell-<version>.jar run -i inputs.json talon-wdl.wdl
```

### Inputs
Inputs are provided through a JSON file. The minimally required inputs are
described below, but additional inputs are available.
A template containing all possible inputs can be generated using
Womtool as described in the
[WOMtool documentation](http://cromwell.readthedocs.io/en/stable/WOMtool/).
For an overview of all available inputs, see [this page](./inputs.html).

```json
{
    "TalonWDL.sampleConfigFile": "A sample configuration file (see below).",
    "TalonWDL.outputDirectory": "The path to the output directory.",
    "TalonWDL.annotationGTF": "GTF annotation containing genes, transcripts, and edges.",
    "TalonWDL.genomeBuild": "Name of genome build that the GTF file is based on (ie hg38).",
    "TalonWDL.annotationVersion": "Name of supplied annotation (will be used to label data).",
    "TalonWDL.referenceGenome": "Reference genome fasta file.",
    "TalonWDL.sequencingPlatform": "The sequencing platform used to generate long reads.",
    "TalonWDL.organismName": "The name of the organism from which the samples originated.",
    "TalonWDL.pipelineRunName": "A short name to distinguish a run.",
    "TalonWDL.dockerImagesFile": "A file listing the used docker images.",
    "TalonWDL.runTranscriptClean": "Set to true in order to run TranscriptClean, set to false in order to disable TranscriptClean.",
    "TalonWDL.sampleWorkflow.presetOption": "This option applies multiple options at the same time to minimap2, this should be either 'splice'(directRNA) or 'splice:hq'(cDNA).",
    "TalonWDL.sampleWorkflow.variantVCF": "A VCF file with common variants should be supplied when running TranscriptClean, this will make sure TranscriptClean does not correct those known variants.",
}
```

Optional settings:
```json
{
    "TalonWDL.novelIDprefix": "A prefix for novel transcript discoveries.",
    "TalonWDL.sampleWorkflow.howToFindGTAG": "How to find canonical splicing sites GT-AG - f: transcript strand; b: both strands; n: no attempt to match GT-AG.",
    "TalonWDL.spliceJunctionsFile": "A pre-generated splice junction annotation file.",
    "TalonWDL.talonDatabase": "A pre-generated TALON database file.",
    "TalonWDL.annotationGTFrefflat": "A refflat file of the annotation GTF used."
}
```

#### Sample configuration
##### Verification
All samplesheet formats can be verified using `biowdl-input-converter`. 
It can be installed with `pip install biowdl-input-converter` or 
`conda install biowdl-input-converter` (from the bioconda channel). 
Python 3.7 or higher is required.

With `biowdl-input-converter --validate samplesheet.csv` The file
"samplesheet.csv" will be checked. Also the presence of all files in
the samplesheet will be checked to ensure no typos were made. For more
information check out the [biowdl-input-converter readthedocs page](
https://biowdl-input-converter.readthedocs.io).

##### CSV format
The sample configuration can be given as a csv file with the following 
columns: sample, library, readgroup, R1, R1_md5, R2, R2_md5.

column name | function
---|---
sample | sample ID
library | library ID. These are the libraries that are sequenced. Usually there is only one library per sample.
readgroup | readgroup ID. Usually a library is sequenced on multiple lanes in the sequencer, which gives multiple fastq files (referred to as readgroups). Each readgroup pair should have an ID.
R1| The fastq file containing the first reads of the read pairs.
R1_md5 | Optional: md5sum for the R1 file.

The easiest way to create a samplesheet is to use a spreadsheet program
such as LibreOffice Calc or Microsoft Excel, and create a table:

sample | library | read | R1 | R1_md5 | R2 | R2_md5
-------|---------|------|----|--------|----|-------
Sample1|lib1|rg1|tests/data/GM12878.subset.fastq.gz|2498f6d289e91b028d87080eb23a362e
Sample2|lib1|rg1|tests/data/K562.subset.fastq.gz|0fded322b59b212f111eb3c695cdbc17

NOTE: R1_md5, R2 and R2_md5 are optional do not have to be filled. And
additional fields may be added (eg. for documentation purposes), these will be
ignored by the pipeline.

After creating the table in a spreadsheet program it can be saved in 
csv format.

#### Example
The following is an example of what an inputs JSON might look like:

```json
{
    "TalonWDL.sampleConfigFile": "tests/samplesheets/GM12878.K562.csv",
    "TalonWDL.outputDirectory": "tests/test-output",
    "TalonWDL.annotationGTF": "tests/data/gencode.v29.annotation.gtf",
    "TalonWDL.genomeBuild": "hg38",
    "TalonWDL.annotationVersion": "gencode_v29",
    "TalonWDL.referenceGenome": "tests/data/grch38.fasta",
    "TalonWDL.sequencingPlatform": "Nanopore",
    "TalonWDL.organismName": "Human",
    "TalonWDL.pipelineRunName": "testRun",
    "TalonWDL.dockerImagesFile": "dockerImages.yml",
    "TalonWDL.runTranscriptClean": "true",
    "TalonWDL.annotationGTFrefflat": "tests/data/gencode.v29.annotation.refflat",
    "TalonWDL.sampleWorkflow.presetOption": "splice",
    "TalonWDL.sampleWorkflow.variantVCF": "tests/data/common.variants.vcf",
    "TalonWDL.sampleWorkflow.howToFindGTAG": "f"
}
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
The workflow will output mapped reads by minimap2 in a .sam file, a
cleaned .sam file and log information from TranscriptClean, a database
containing transcript information together with a log file of
read/transcript comparison and a abundance plus summary file of the database.
It will also output fastqc and picard statistics based on the fastq and
minimap2 alignment file, combined into a multiqc report.

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
