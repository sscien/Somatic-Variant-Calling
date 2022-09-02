tmux
cd pecgs-pipeline/src/compute1
export LSF_DOCKER_VOLUMES="/storage1/fs1/dinglab/Active:/storage1/fs1/dinglab/Active /scratch1/fs1/dinglab:/scratch1/fs1/dinglab"
export PATH="/miniconda/envs/pecgs/bin:$PATH"
bsub -q dinglab-interactive -G compute-dinglab -Is -a 'docker(estorrs/pecgs-pipeline:0.0.1)' '/bin/bash'
### generate run
# mmrf_TN_wxs_bam
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_TN_wxs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WXS_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wxs_bam

#mmrf_rna_fq
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_T_rna_fq /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq/MMRF_RNA_seq_priority_sample_catalog.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq

cd /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq

#mmrf_TN_wgs_bam
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_TN_wgs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WGS_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wgs_bam

#mmrf_TN_wgs_bam rerun
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_TN_wgs_bam /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wgs_bam/re_run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wgs_bam

###2 tidy run

python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py tidy-run pecgs_TN_wxs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WXS_bam/run_list.txt /storage1/fs1/dinglab/Active/Projects/MMRF_analysis_bulk/


python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py tidy-run pecgs_TN_wxs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WXS_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wxs_bam

#mmrf_rna_fq
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py tidy-run pecgs_T_rna_fq /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WXS_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq

#mmrf_TN_wgs_bam
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py tidy-run pecgs_TN_wgs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WGS_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wgs_bam

###3 summarize-run

python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py summarize-run pecgs_TN_wxs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WXS_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wxs_bam

#mmrf_rna_fq
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py summarize-run pecgs_T_rna_fq /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq/MMRF_RNA_seq_priority_sample_catalog.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq

#mmrf_TN_wgs_bam
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py summarize-run pecgs_TN_wgs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WGS_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wgs_bam

cp -r /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wgs_bam/ /storage1/fs1/dinglab/Active/Projects/MMRF_analysis_bulk


python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_TN_wxs_bam /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wxs_bam/runlist_rerun1.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wxs_bam

python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py tidy-run pecgs_TN_wxs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WXS_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wxs_bam


python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py tidy-run pecgs_TN_wxs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/run_instance/MMRF_WXS_bam/run_list.txt /storage1/fs1/dinglab/Active/Projects/MMRF_analysis_bulk/mmrf_TN_wxs_bam

###wxg re-run2
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_TN_wxs_bam /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wxs_bam/runlist_rerun2.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wxs_bam

cp -r /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_TN_wxs_bam /storage1/fs1/dinglab/Active/Projects/MMRF_analysis_bulk/backup


#mmrf_rna_fq re-run1
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_T_rna_fq /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq/rerun_list1.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq

cd /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq

python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_T_rna_fq /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq/rerun_list2.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq


#rna_expression
python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_T_rna_fq /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_fq/MMRF_RNA_seq_priority_sample_catalog.txt /scratch1/fs1/dinglab/Active/Projects/ysong/MMRF/mmrf_rna_expression
