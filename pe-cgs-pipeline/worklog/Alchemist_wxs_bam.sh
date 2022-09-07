cd /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl

git clone --recurse-submodules https://github.com/ding-lab/pecgs-pipeline.git
cd pecgs-pipeline/src/compute1

# git pull && git submodule update --remote https://github.com/ding-lab/pecgs-pipeline.git
# git pull --recurse-submodules https://github.com/ding-lab/pecgs-pipeline.git
# git clone --recurse-submodules  https://github.com/ding-lab/pecgs-pipeline.git
# git submodule update --remote


cd /scratch1/fs1/dinglab/Active/Projects/ysong
rm -r pecgs-pipeline
git clone --recurse-submodules -b v0.0.1-beta.2 https://github.com/sscien/pecgs-pipeline.git
cd pecgs-pipeline/src/compute1

tmux
export LSF_DOCKER_VOLUMES="/storage1/fs1/dinglab/Active:/storage1/fs1/dinglab/Active /scratch1/fs1/dinglab:/scratch1/fs1/dinglab"
export PATH="/miniconda/envs/pecgs/bin:$PATH"
bsub -q dinglab-interactive -G compute-dinglab -Is -a 'docker(estorrs/pecgs-pipeline:0.0.1)' '/bin/bash'
### generate run
# mmrf_TN_wxs_bam
python /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_TN_wxs_bam /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/run_list/Alchemist/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/Alchemist/alchemist_TN_wxs_bam_b2/

cd /scratch1/fs1/dinglab/Active/Projects/ysong/Alchemist/alchemist_TN_wxs_bam_b2/
bash 1.run_jobs.sh

python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_TN_wxs_bam /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/examples/pecgs_TN_wxs_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/Alchemist/alchemist_TN_wxs_bam_b2/


cd /scratch1/fs1/dinglab/Active/Projects/ysong/Alchemist/alchemist_TN_wxs_bam_b2/
rm -r *

tmux
export LSF_DOCKER_VOLUMES="/storage1/fs1/dinglab/Active:/storage1/fs1/dinglab/Active /scratch1/fs1/dinglab:/scratch1/fs1/dinglab"
export PATH="/miniconda/envs/pecgs/bin:$PATH"
bsub -q dinglab-interactive -G compute-dinglab -Is -a 'docker(songyizhe/pecgs:v0.1)' '/bin/bash'

python /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/src/compute1/generate_run_commands.py make-run pecgs_TN_wxs_bam /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/examples/pecgs_TN_wxs_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/Alchemist/alchemist_TN_wxs_bam_b2/

python /storage1/fs1/dinglab/Active/Projects/ysong/Projects/pecgs-cwl/pecgs-pipeline_aug_22/src/compute1/generate_run_commands.py make-run pecgs_TN_wxs_bam /scratch1/fs1/dinglab/Active/Projects/ysong/pecgs-pipeline/examples/pecgs_TN_wxs_bam/run_list.txt /scratch1/fs1/dinglab/Active/Projects/ysong/Alchemist/alchemist_TN_wxs_bam_b2/


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


Step 1: Generation of run directory and scripts
The pecgs-pipeline is most easily run on compute1 from an interactive docker session. To launch this session run the following command:

export LSF_DOCKER_VOLUMES="/storage1/fs1/dinglab/Active:/storage1/fs1/dinglab/Active /scratch1/fs1/dinglab:/scratch1/fs1/dinglab"
export PATH="/miniconda/envs/pecgs/bin:$PATH"
bsub -q dinglab-interactive -G compute-dinglab -Is -a 'docker(estorrs/pecgs-pipeline:0.0.1)' '/bin/bash'

NOTE: if the directory you intend to use for pipeline outputs is not in /storage1/fs1/dinglab/Active or /scratch1/fs1/dinglab you will need to add that path to the LSF_DOCKER_VOLUMES environmental variable in the first line.

You should now be inside a running container.

To generate the run directory, execute the following command. Replace PIPELINE_NAME with the pipeline variant you would like to run (i.e. pecgs_TN_wxs_bam), RUN_LIST with the filepath of the run list describing samples you would like to run (see inputs section for more details), and RUN_DIR with the absolute filepath where you would like the runs to execute

python generate_run_commands.py make-run PIPELINE_NAME RUN_LIST RUN_DIR
NOTE: for additinal arguments to generate_run_commands.py see Additional arguments to generate_run_commands.py section. Some of these arguments include being able to specify which compute1 queue to use and how to pass in sequencing info for fastq files.

Following execution of this command, a directory should now exist at whatever path was specified for RUN_DIR. Inside that directory you should see one file: 1.run_jobs.sh. There should also be three directories: inputs, logs, and runs.

inputs holds input configs and files used while running the pipeline. runs is the directory where all runs will execute. logs will contain the log file for each run in the run list.

To start the run open a new compute1 terminal (i.e. not the same terminal running the container that was created in the step above).

Then navigate to RUN_DIR. To start the runs, from inside RUN_DIR run 1.run_jobs.sh.

bash 1.run_jobs.sh
Your pipeline runs should now be running :).

To check on progress you can view log files for each run inside the logs directory.

You can see currently running jobs with the bjobs command.

For a more detailed look at the pipeline, you can get information from the cromwell server that is responsible for running the pipeline.

To look up more detailed information on each workflow, you will need to get the cromwell ID that is assigned to each run. To do so, run the following command from inside RUN_DIR.

egrep -H 'cwl \(Unspecified version\) workflow' logs/* | sed 's/^logs\/\(.*\).log:.* workflow \(.*\) .*$/\1, \2/'
The result of this command should give you two fields, the first of which is the run_id from the run list, and the second is the cromwell workflow id. The cromwell workflow id is what you can use with the below API calls to get more information on individual workflows.

Cromwell server commands
Replace {WORKFLOW_ID} in the below urls with the cromwell workflow id you are interested in.

To get the status of a workflow put the following in your browser http://mammoth.wusm.wustl.edu:8000/api/workflows/v1/{WORKFLOW_ID}/status

To get the outputs of a workflow put the following in your browser http://mammoth.wusm.wustl.edu:8000/api/workflows/v1/{WORKFLOW_ID}/outputs

To get a timing diagram for a workflow put the following in your browser http://mammoth.wusm.wustl.edu:8000/api/workflows/v1/{WORKFLOW_ID}/timing

To see metadata for a workflow put the following in your browser http://mammoth.wusm.wustl.edu:8000/api/workflows/v1/{WORKFLOW_ID}/metadata?expandSubWorkflows=false

You can also see additional GET endpoints at http://mammoth.wusm.wustl.edu:8000

Step 2: Deletion of large intermediate files
Cromwell leaves behind a lot of intermediary files that can be quite large. To clean up the workflow directory run the following command from the first terminal used at the beginning of step 1.

python generate_run_commands.py tidy-run PIPELINE_NAME RUN_LIST RUN_DIR
There should now be a file called 2.tidy_run.sh in RUN_DIR.

This file will contain commands to remove all finished and successfully completed pipeline runs. If you have multiple runs in your run_list then only runs that finished and completed successfully will have files to be deleted inside 2.tidy_run.sh.

If you are performing a large number of runs it is usually a good idea to periodically run the above command to clean out intermediarry files, otherwise they may fill up memory in whatever directory you are using to execute your runs.

To run 2.tidy_run.sh, in a compute1 terminal not inside a running container run this script to delete large intermediary files.

bash 2.tidy_run.sh
Step 3: Generation of analysis summary and run summary files
The pecgs-pipeline also has tooling to track output files and run metadata.

To generate result files run the following command from the terminal at the beginning of step 1.

python generate_run_commands.py summarize-run PIPELINE_NAME RUN_LIST RUN_DIR
After running this command, there should be three new files in RUN_DIR (assuming there are runs that have successfully completed): analysis_summary.txt, run_summary.txt, and runlist.txt.

analysis_summary.txt
A tab-seperated txt file containing output files and various metadata.
example analysis summary file
run_summary.txt
A tab-sperated txt file containing run metadata for each run in the run list.
example run summary file
Important Note: Only runs that have completed will be in the summary files. i.e. if you are running 10 runs and 4 have completed, outputs for those 4 runs will be included in the summary files, but not the 6 runs that are still ongoing. If you run this command multiple times throughout a run new UUIDs will be assigned to each output file in analysis_summary.txt.
