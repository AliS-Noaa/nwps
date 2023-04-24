#!/bin/bash
set -xa

# set environment variables
export ARCHBITS="64"
export PATH=$PATH:${EXECnwps}

# check if this is the first job (N=1)
if [ "${N}" = 1 ]; then
    # execute the first job
    ${USHnwps}/nwps_posproc_cg1.pl
    export err=$?; err_chk
    ${USHnwps}/nwps_posproc_cg1.sh 1
    export err=$?; err_chk
else
    # set the status file name and location
    status_file="${LOGdir}/grib2_status"

    # set the maximum number of iterations
    max_iter=5

    # set the initial iteration counter to 0
    iter=0

    # loop until all jobs are submitted successfully or the maximum number of iterations is reached
    while [ $iter -lt $max_iter ]
    do
        # increment the iteration counter
        iter=$(( iter + 1 ))

        # execute the cgn_cmdfile and capture the exit status of each job
        mpiexec -np 4 --cpu-bind verbose,core bash -c "cd ${RUNdir} && cat cgn_cmdfile | xargs -I {} sh -c '{} && echo \"{}:0\" || echo \"{}:1\"'" | awk -F ':' '{print $1 " " $2}' > $status_file
        export err=$?; err_chk
        # check the status file for failed jobs
        failed_jobs=$(grep ':1' $status_file | awk '{print $1}')

        # check if all jobs were successful
        if [ -z "$failed_jobs" ]; then
            # all jobs submitted successfully, exit the loop
            break
        else
            # at least one job failed, log the error and resubmit
            echo "Error submitting jobs (iteration $iter of $max_iter), resubmitting..."

            # set the name of the failed file to keep
            failed_file="${RUNdir}/failed_jobs.txt"

            # write the failed jobs to the failed file
            echo "$failed_jobs" > $failed_file
            
            # remove the && false part from the failed file
	    sed -i 's/ && false//' $failed_file

            # resubmit the failed jobs using the failed file
            mpiexec -np 4 --cpu-bind verbose,core bash -c "cd ${RUNdir} && cat $failed_file | xargs -I {} sh -c '{} && echo \"{}:0\" || echo \"{}:1\"'"
            export err=$?; err_chk
        fi
    done
fi
