# Test data

* [ONT_GM12878_SUBSET.fastq](https://sra-pub-src-1.s3.amazonaws.com/SRR9304714/ONT_GM12878_3.fastq.gz.1) (cat ONT_GM12878_3.fastq | head -n 3000 > ONT_GM12878_SUBSET.fastq)
* [ONT_K562_SUBSET.fastq](https://sra-pub-src-1.s3.amazonaws.com/SRR9304718/ONT_K562_1.fastq.gz.1) (cat ONT_K562_1.fastq | head -n 3000 > ONT_K562_SUBSET.fastq)
* [Reference genome](https://www.encodeproject.org/files/GRCh38_no_alt_analysis_set_GCA_000001405.15/@@download/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta.gz) (awk '{print $1}' GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta > GRCh38.fasta) (cat GRCh38.fasta | head -n 10000 > GRCh38.fasta)
* VCF: ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/00-common_all.vcf.gz (cat 00-common_all.vcf | head -n 3000 > commonVariants.vcf)
* GTF: ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_29/gencode.v29.annotation.gtf.gz (cat gencode.v29.annotation.gtf | head -n 1000 > gencode.v29.annotation.gtf)
