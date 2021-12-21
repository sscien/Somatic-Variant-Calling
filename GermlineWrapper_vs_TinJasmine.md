##########################################################################
## Comparison between GermlineWrapper and TinJasmine germline calls	##
## Last modified: 12/21/2021						##
## Contact:	Yizhe Song (y.song@wustl.edu);                          ##
##              Fernanda Martins Rodrigues (fernanda@wustl.edu);        ##
##		Matthew Wyczalkowski (m.wyczalkowski@wustl.edu)		## 
##########################################################################

## quick overview of the results

![image](https://user-images.githubusercontent.com/80489022/146967485-5b73787c-cc45-4a73-9a99-694a4bac8608.png)

1. compare GW/AD_ROI_indel_filtered to TJ Canonical filter yield 2,114 GW unique variants.
2. compare 2,114 GW unique variants to TJ Merge VCF step, yield 2,071 GW unique variants.
3. compare 2,071 GW unique variants to TJ GATK indel bcftool normalize step, yield 2,040 unique GW variants.
4. compare 2,040 unique GW variants to TJ GATK SNP bcftool normalize step, yield 397 unique GW variant. So a larger number of GW unique variants were filtered out at this step. We rescued 1,634 variants here!
5. compare 397 GW unique variants to TJ varscan indel bcftool normalize step, yield 390 unique GW variants.
6. compare 390 GW unique variants to TJ varscan SNP bcftool normalize step, yield 276 unique GW variants.
7. compare 276 unique GW variants to TJ varscan caller, GATK caller and Pindel caller, remain 276 unique GW variants. No variants were rescued in these steps.

For initial testing of the TinJasmine germline variant calling pipeline, we are comparing TinJasmine results with those from GermlineWrapper.
The testing dataset is CPTAC3 LUSC/LSCC sample C3L-00081.

--> GermlineWrapper version:
	- Germline variant calling was performed using Song's GermlineWrapper pipeline (https://github.com/ding-lab/germlinewrapper ; latest commit as of 02/04/2019: 8614037).
	- Pipeline was slightly modified to work with reference genome GRCh38. Check the following file for changes: /gscmnt/gc2737/ding/fernanda/Germline_MMY/Tools/germlinewrapper_grch38/germlinewrapper.pl

--> CPTAC3 LUSC GermlineWrapper results: /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GermlineWrapper/AD_ROI_indel_filtered/

Directories have the following structure:

/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GermlineWrapper/AD_ROI_indel_filtered/ # stores germline wrapper results after all filters

/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/ # stores TinJasmine raw results
/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-canonical_filter/execution/output/ # stores TinJasmine results after canonical filters

## VCF file store the unique GW calls
/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_Varscan.indel.Final/0000.vcf.gz

##== 1st round of comparisons: sample C3L-00081 ==##

Here, I am comparing the results from GermlineWrapper/AD_ROI_indel_filtered with Tindaisy after the following filters:

* [`GATK_GermlineCaller`](https://github.com/ding-lab/GATK_GermlineCaller.git)
* [`Varscan_GermlineCaller`](https://github.com/ding-lab/Varscan_GermlineCaller.git)
* [`Pindel_GermlineCaller`](https://github.com/ding-lab/Pindel_GermlineCaller.git)
* [`varscan_vcf_remap`](https://github.com/ding-lab/varscan_vcf_remap.git)
* [`MergeFilterVCF`](https://github.com/ding-lab/MergeFilterVCF.git)
* [`TinDaisy-VEP`](https://github.com/ding-lab/TinDaisy-VEP.git)
* [`HotspotFilter`](https://github.com/ding-lab/HotspotFilter.git)
* [`VCF2MAF`](https://github.com/ding-lab/vcf2maf-CWL.git)
* [`VLD_Filter`](https://github.com/ding-lab/VLD_FilterVCF.git)

https://github.com/ding-lab/TinJasmine/blob/master/doc/TinJasmine.wf1.4.png?raw=true

I used bcftools (version 1.14) isec to compare vcf files from the two pipelines.
VCF files must be compressed with bgzip and indexed with tabix prior to using bcftools.
VCF files were also normalized prior to comparison.

Steps taken and summary of results are below.

--> VCF normalization:

cd /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/

bcftools norm -f /gscmnt/gc3020/dinglab/fernanda/Projects/CPTAC_HRD/SequenzaCalls/GRCh38.d1.vd1.fa --multiallelics - --check-ref e -Oz -o /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GermlineWrapper/AD_ROI_indel_filtered/C3L-00081.filtered.ROI.AD.5.noLongIndels.normalized.vcf GermlineWrapper/AD_ROI_indel_filtered/C3L-00081.filtered.ROI.AD.5.noLongIndels.vcf.gz -oo GW_vs_TJ/logs/GW.vcf.normalize.log 

bcftools norm -f /diskmnt/Projects/Users/ysong/test_data/GRCh38.d1.vd1.fa --multiallelics - --check-ref e -Oz -o /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-roi_filter/execution/output/call_roi_filter.normalized.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-roi_filter/execution/output/HotspotFiltered.vcf  -oo GW_vs_TJ/logs/TJ.vcf.normalize.log 

--> convert vcf file to vcf.gz

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-canonical_filter/execution/output/HotspotFiltered.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-canonical_filter/execution/output/HotspotFiltered.vcf.gz

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-merge_vcf/execution/output/merged.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-merge_vcf/execution/output/merged.vcf.gz

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-pindel_filter/execution/filtered/pindel_sifted.out.CvgVafStrand_pass.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-pindel_filter/execution/filtered/pindel_sifted.out.CvgVafStrand_pass.vcf.gz

--> Indexed resulting vcfs with tabix

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GermlineWrapper/AD_ROI_indel_filtered/C3L-00081.filtered.ROI.AD.5.noLongIndels.normalized.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-canonical_filter/execution/output/HotspotFiltered.vcf.gz
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-filter_vcf/execution/output/filtered.vcf

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-gatk_germline_caller/execution/output/GATK.snp.Final.vcf.gz
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-gatk_germline_caller/execution/output/GATK.indel.Final.vcf.gz
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-varscan_germline_caller/execution/output/Varscan.snp.Final.vcf.gz
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-varscan_germline_caller/execution/output/Varscan.indel.Final.vcf.gz
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-pindel_filter/execution/filtered/pindel_sifted.out.CvgVafStrand_pass.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-merge_vcf/execution/output/merged.vcf.gz
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-roi_filter/execution/output/HotspotFiltered.vcf

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-varscan_vcf_remap_snp/execution/varscan-remapped.vcf
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-vep_annotate/execution/results/vep/output_vep.vcf

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-pindel_filter/execution/filtered/pindel_sifted.out.CvgVafStrand_pass.vcf

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-vld_filter_gatk_indel/execution/VLD_FilterVCF_output.vcf
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-vld_filter_gatk_snp/execution/VLD_FilterVCF_output.vcf
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-vld_filter_pindel/execution/VLD_FilterVCF_output.vcf
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-vld_filter_varscan_indel/execution/VLD_FilterVCF_output.vcf
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-vld_filter_varscan_snp/execution/VLD_FilterVCF_output.vcf

--> Compared resulting VCFs:

0. GW  vs TJ_canonical_filter

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GermlineWrapper/AD_ROI_indel_filtered/C3L-00081.filtered.ROI.AD.5.noLongIndels.normalized.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-canonical_filter/execution/output/HotspotFiltered.vcf.gz -p GW_vs_TJ/GW_vs_canonical_filter -oo GW_vs_TJ/logs/C3L-00081.GW.TJ.isec.log 

Examples:
   # Create intersection and complements of two sets saving the output in dir/*
   bcftools isec A.vcf.gz B.vcf.gz -p dir

   # Filter sites in A and B (but not in C) and create intersection
   bcftools isec -e'MAF<0.01' -i'dbSNP=1' -e - A.vcf.gz B.vcf.gz C.vcf.gz -p dir

   # Extract and write records from A shared by both A and B using exact allele match
   bcftools isec A.vcf.gz B.vcf.gz -p dir -n =2 -w 1

   # Extract and write records from C found in A and C but not in B
   bcftools isec A.vcf.gz B.vcf.gz C.vcf.gz -p dir -n~101 -w 3

   # Extract records private to A or B comparing by position only
   bcftools isec A.vcf.gz B.vcf.gz -p dir -n -1 -c all

--> Outputs:

sites unique to GW (GW vs. TJ canonical_filter)
/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_canonical_filter/0000.vcf

change it to gz format
bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_canonical_filter/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_canonical_filter/0000.vcf.gz

index it
tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_canonical_filter/0000.vcf.gz

Next step we would compare all other TJ steps with this file, to see whether we could rescure these variants.

 count variants
gatk CountVariants -V /GW_vs_TJ/GW_vs_canonical_filter/0000.vcf
gatk CountVariants -V /GW_vs_TJ/GW_vs_canonical_filter/0001.vcf
gatk CountVariants -V /GW_vs_TJ/GW_vs_canonical_filter/0003.vcf
gatk CountVariants -V /GW_vs_TJ/GW_vs_canonical_filter/0004.vcf

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_canonical_filter/0000.vcf.gz

- NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 2114	

### 1. GW unique from step0  vs mergeVCF
bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_canonical_filter/0000.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-merge_vcf/execution/output/merged.vcf.gz -p GW_vs_TJ/GW_vs_merge_vcf 

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_merge_vcf/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_merge_vcf/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_merge_vcf/0000.vcf.gz

 count variants
/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_merge_vcf/0000.vcf.gz
      
- NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 2071	
  
### 2. GW unique from step1  vs bcftools_normalize_gatk_indel
bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_merge_vcf/0000.vcf.gz  /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-bcftools_normalize_gatk_indel/execution/output.normalized.vcf.gz -p GW_vs_TJ/GW_vs_bcftools_normalize_gatk_indel

"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_indel/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_indel/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_indel/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_indel/0000.vcf.gz

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_indel/0000.vcf.gz
      
      - NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 2040

### 3. GW unique from step2  vs bcftools_normalize_gatk_snp

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_indel/0000.vcf.gz  /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-bcftools_normalize_gatk_snp/execution/output.normalized.vcf.gz -p GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp

"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf.gz

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf.gz
      
      - NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 397
      
### 4. GW unique from step3  vs bcftools_normalize_pindel

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-bcftools_normalize_pindel/execution/output.normalized.vcf.gz -p GW_vs_TJ/GW_vs_bcftools_normalize_pindel

0000.vcf.gz is the VCF contains VARIANTS UNIQUE TO GERMLINEWRAPPER(excluded rescued variants from mergeVCF, bcftools_normalize_gatk_indel and bcftools_normalize_gatk_snp stages)

output.normalized.vcf.gz is the bcftools_normalize_pindel VCF 

Error message:
#[W::bcf_hdr_check_sanity] PL should be declared as Number=G


"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf.gz

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf.gz
      
      - NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 397
 
### 5. GW unique from step4  vs bcftools_normalize_varscan_indel

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_gatk_snp/0000.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-bcftools_normalize_varscan_indel/execution/output.normalized.vcf.gz -p GW_vs_TJ/GW_vs_bcftools_normalize_varscan_indel

"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_indel/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_indel/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_indel/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_indel/0000.vcf.gz

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_indel/0000.vcf.gz
      
      - NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 390

### 6. GW unique from step5  vs bcftools_normalize_varscan_snp

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_indel/0000.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-bcftools_normalize_varscan_snp/execution/output.normalized.vcf.gz -p GW_vs_TJ/GW_vs_bcftools_normalize_varscan_snp

"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_snp/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_snp/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_snp/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_snp/0000.vcf.gz

bcftools stats "/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_snp/0000.vcf.gz" > /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_snp/0000.file.stats

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_snp/0000.vcf.gz
      
	- NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 276
	
### 7. GW unique from step6  vs bcftools_gatk_germline_caller

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_normalize_varscan_snp/0000.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-gatk_germline_caller/execution/output/GATK.snp.Final.vcf.gz -p GW_vs_TJ/GW_vs_bcftools_gatk_germline_caller

"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_gatk_germline_caller/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_gatk_germline_caller/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_gatk_germline_caller/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_gatk_germline_caller/0000.vcf.gz

bcftools stats /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_gatk_germline_caller/0000.vcf.gz > /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_gatk_germline_caller/0000.file.stats

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_gatk_germline_caller/0000.vcf.gz
      
	- NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 276	

### 8. GW unique from step7  vs bcftools_gatk_germline_caller

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_bcftools_gatk_germline_caller/0000.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-gatk_germline_caller/execution/output/GATK.indel.Final.vcf.gz -p GW_vs_TJ/GW_vs_GATK.indel.Final

"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz

bcftools stats /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz > /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.file.stats

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz
      
	- NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 276

### 9. GW unique from step8 vs bcftools_gatk_germline_caller

bcftools norm -f /diskmnt/Projects/Users/ysong/test_data/GRCh38.d1.vd1.fa --multiallelics - --check-ref e -Oz -o /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-pindel_filter/execution/filtered/pindel_sifted.out.CvgVafStrand_pass_normalized.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-pindel_filter/execution/filtered/pindel_sifted.out.CvgVafStrand_pass.vcf.gz

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-pindel_filter/execution/filtered/pindel_sifted.out.CvgVafStrand_pass_normalized.vcf.gz  -p GW_vs_TJ/GW_vs_call-pindel_filter

"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-pindel_filter/execution/filtered/pindel_sifted.out.CvgVafStrand_pass_normalized.vcf.gz 

bcftools stats /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz > /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.file.stats

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz
      
	- NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 276

### 10. GW unique from step9  vs varscan_germline_caller

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_GATK.indel.Final/0000.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-varscan_germline_caller/execution/output/Varscan.snp.Final.vcf.gz -p GW_vs_TJ/GW_vs_varscan_germline_caller

"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_varscan_germline_caller/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_varscan_germline_caller/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_varscan_germline_caller/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_varscan_germline_caller/0000.vcf.gz

bcftools stats /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_varscan_germline_caller/0000.vcf.gz > /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_varscan_germline_caller/0000.file.stats

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_varscan_germline_caller/0000.vcf.gz
      
	- NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 276

### 11. GW unique  from step10 vs Varscan.indel.Final

bcftools isec /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_varscan_germline_caller/0000.vcf.gz /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/TJ/LUSC/call-varscan_germline_caller/execution/output/Varscan.indel.Final.vcf.gz -p GW_vs_TJ/GW_vs_Varscan.indel.Final

"/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_Varscan.indel.Final/0000.vcf"

bgzip /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_Varscan.indel.Final/0000.vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_Varscan.indel.Final/0000.vcf.gz

tabix -p vcf /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_Varscan.indel.Final/0000.vcf.gz

bcftools stats /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_Varscan.indel.Final/0000.vcf.gz > /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_Varscan.indel.Final/0000.file.stats

/diskmnt/Projects/Users/ysong/program/gatk/gatk-4.2.3.0/gatk CountVariants \
      -V /diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_Varscan.indel.Final/0000.vcf.gz
      
	- NUMBER OF VARIANTS UNIQUE TO GERMLINEWRAPPER: 276

## VCF file store the unique GW calls
/diskmnt/Projects/Users/ysong/project/PECGS/GermlineWrapper_vs_TinJasmine/SW/CPTAC/LUSC/C3L-00081/GW_vs_TJ/GW_vs_Varscan.indel.Final/0000.vcf.gz
