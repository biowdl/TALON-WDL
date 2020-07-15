# Test data

* [Reference genome](https://www.encodeproject.org/files/GRCh38_no_alt_analysis_set_GCA_000001405.15/@@download/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta.gz)
  * `gzip -d GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta.gz`
  * `awk '{print $1}' GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta > GRCh38.fasta`
  * `cat GRCh38.fasta | head -n 10000 > GRCh38.fasta`
* VCF: ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b151_GRCh38p7/VCF/GATK/common_all_20180418.vcf.gz
  * `zcat 00-common_all.vcf | head -n 3000 > commonVariants.vcf`
* GTF: ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.annotation.gtf.gz
  * `zcat gencode.v34.annotation.gtf | head -n 1000 > gencode.v34.annotation.gtf`
* [Refflat](http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/)
  * `gtfToGenePred -genePredExt gencode.v34.annotation.gtf GenePred.file`
  * `awk 'BEGIN { OFS="\t"} {print $12, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10}' GenePred.file > gencode.v34.annotation.refflat`
* [Alzheimer_2019_IsoSeq](https://downloads.pacbcloud.com/public/dataset/Alzheimer2019_IsoSeq/FullLengthReads/flnc.fasta)
  * `minimap2 -ax splice:hq --secondary=no --MD -uf -o flnc.sam GRCh38.fasta flnc.fasta`
  * `samtools sort -o flnc.sorted.bam --output-fmt BAM flnc.sam`
  * `samtools index flnc.sorted.bam`
  * `samtools view -h -o chr1.sam flnc.sorted.bam chr1`
  * `samtools fastq chr1.sam > chr1.fastq`
  * `cat chr1.fastq | head -n 3000 > pacbio.subset.1.fastq`
  * `cat chr1.fastq | tail -n 3000 > pacbio.subset.2.fastq`





* [ONT_GM12878_SUBSET.fastq](https://sra-pub-src-1.s3.amazonaws.com/SRR9304714/ONT_GM12878_3.fastq.gz.1)
  * `cat ONT_K562_1.fastq | head -n 3000 > ONT_K562_SUBSET.fastq`
