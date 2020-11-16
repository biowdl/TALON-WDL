---
layout: default
title: Home
---

This workflow can be used to process RNA sequenced with either a Pacific
Biosciences sequencer or Oxford Nanopore sequencer. Input files should be
in fastq format. The workflow performs mapping to a reference
genome (using minimap2), INDEL/mismatch and noncanonical splice junction
correction (using transcriptclean) and identification and counting of
known and novel genes/transcripts (using talon).

This workflow is part of [BioWDL](https://biowdl.github.io/)
developed by the SASC team
at [Leiden University Medical Center](https://www.lumc.nl/).

## Usage
This workflow can be run using
[Cromwell](http://cromwell.readthedocs.io/en/stable/):

First download the latest version of the workflow wdl file(s)
from the
[github page](https://github.com/biowdl/TALON-WDL).

The workflow can then be started with the following command:
```bash
java \
    -jar cromwell-<version>.jar \
    run \
    -o options.json \
    -i inputs.json \
    talon-wdl.wdl
```

Where `options.json` contains the following json:
```json
{
    "final_workflow_outputs_dir": "/path/to/outputs",
    "use_relative_output_paths": true,
    "final_workflow_log_dir": "/path/to/logs/folder"
}
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
    "TalonWDL.annotationGTF": "GTF annotation containing genes, transcripts, and edges.",
    "TalonWDL.genomeBuild": "Name of genome build that the GTF file is based on (ie hg38).",
    "TalonWDL.annotationVersion": "Name of supplied annotation (will be used to label data).",
    "TalonWDL.referenceGenome": "Reference genome fasta file.",
    "TalonWDL.sequencingPlatform": "The sequencing platform used to generate long reads.",
    "TalonWDL.organismName": "The name of the organism from which the samples originated.",
    "TalonWDL.pipelineRunName": "A short name to distinguish a run.",
    "TalonWDL.dockerImagesFile": "A file listing the used docker images.",
    "TalonWDL.runTranscriptClean": "Set to true in order to run transcriptclean, set to false in order to disable transcriptclean.",
    "TalonWDL.sampleWorkflow.presetOption": "This option applies multiple options at the same time to minimap2, this should be either 'splice'(directRNA) or 'splice:hq'(cDNA).",
    "TalonWDL.sampleWorkflow.variantVCF": "A VCF file with common variants should be supplied when running transcriptclean, this will make sure transcriptclean does not correct those known variants.",
    "TalonWDL.sampleWorkflow.howToFindGTAG": "How to find canonical splicing sites GT-AG - f: transcript strand; b: both strands; n: no attempt to match GT-AG.",
    "TalonWDL.outputDirectory": "The path to the output directory."
}
```

Optional settings:
```json
{
    "TalonWDL.novelIDprefix": "A prefix for novel transcript discoveries.",
    "TalonWDL.talonDatabase": "A pre-generated talon database file.",
    "TalonWDL.spliceJunctions": "A pre-generated splice junction annotation file.",
    "TalonWDL.annotationGTFrefflat": "A refflat file of the annotation gtf used."
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
R2| Optional: The fastq file containing the reverse reads.
R2_md5| Optional: md5sum for the R2 file.

The easiest way to create a samplesheet is to use a spreadsheet program
such as LibreOffice Calc or Microsoft Excel, and create a table:

sample | library | read | R1 | R1_md5 | R2 | R2_md5
-------|---------|------|----|--------|----|-------
Sample1|lib1|rg1|tests/data/GM12878.subset.fastq.gz|2498f6d289e91b028d87080eb23a362e
Sample2|lib1|rg1|tests/data/K562.subset.fastq.gz|0fded322b59b212f111eb3c695cdbc17

NOTE: R1_md5, R2 and R2_md5 are optional do not have to be filled. And
additional fields may be added (eg. for documentation purposes), these will be
ignored by the workflow.

After creating the table in a spreadsheet program it can be saved in 
csv format.

#### Example
The following is an example of what an inputs JSON might look like:
```json
{
    "TalonWDL.sampleConfigFile": "tests/samplesheets/pacbio.csv",
    "TalonWDL.annotationGTF": "tests/data/reference/gencode.v34.annotation.gtf",
    "TalonWDL.genomeBuild": "hg38",
    "TalonWDL.annotationVersion": "gencode_v34",
    "TalonWDL.referenceGenome": "tests/data/reference/grch38.fasta",
    "TalonWDL.sequencingPlatform": "PacBio",
    "TalonWDL.organismName": "Human",
    "TalonWDL.pipelineRunName": "pacbio-test",
    "TalonWDL.dockerImagesFile": "dockerImages.yml",
    "TalonWDL.runTranscriptClean": "true",
    "TalonWDL.annotationGTFrefflat": "tests/data/reference/gencode.v34.annotation.refflat",
    "TalonWDL.sampleWorkflow.presetOption": "splice:hq",
    "TalonWDL.sampleWorkflow.variantVCF": "tests/data/reference/common.variants.vcf",
    "TalonWDL.sampleWorkflow.howToFindGTAG": "f",
    "TalonWDL.outputDirectory": "tests/test-output"
}
```

## Dependency requirements and tool versions
Biowdl workflows use docker images to ensure reproducibility. This
means that biowdl workflows will run on any system that has docker
installed. Alternatively they can be run with singularity.

For more advanced configuration of docker or singularity please check
the [cromwell documentation on containers](
https://cromwell.readthedocs.io/en/stable/tutorials/Containers/).

Images from [biocontainers](https://biocontainers.pro) are preferred for
biowdl workflows. The list of default images for this workflow can be
found in the default for the `dockerImages` input.

## Output
The workflow will output mapped reads by minimap2 in a .sam file. A
cleaned .sam file and log information from transcriptclean. A database
containing transcript information together with a log file of
read/transcript comparison and a abundance plus summary file of the database.
It will also output fastqc and picard statistics based on the fastq files and
minimap2 alignment files, combined into a multiqc report.

## Contact
<p>
  <!-- Obscure e-mail address for spammers -->
For any questions about running this workflow and feature requests (such as
adding additional tools and options), please use the
<a href='https://github.com/biowdl/TALON-WDL/issues'>github issue tracker</a>
or contact the SASC team directly at: 
<a href='&#109;&#97;&#105;&#108;&#116;&#111;&#58;&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;'>
&#115;&#97;&#115;&#99;&#64;&#108;&#117;&#109;&#99;&#46;&#110;&#108;</a>.
</p>
