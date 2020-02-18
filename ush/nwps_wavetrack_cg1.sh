#!/bin/bash
set -xa

# Halt this script it the model or Perl interface crashes
#if [ -e ${OUTPUTdir}/netCdf/not_completed ]
#    then
#    echo "SWAN Run failed!"                                  | tee -a $logfile
#    echo "Exiting ${PROGRAMname} with no further processing" | tee -a $logfile
#    export err=1; err_chk
#fi

echo " "                                            | tee -a $logfile
echo -n "SWAN Run Finished: "                       | tee -a $logfile
date                                                | tee -a $logfile
echo " " | tee -a $logfile

#Running Wave Tracking 
#Next line if a test then ww3_systrk.inp from the test directory
#TESTYoN 
hastracking=$(cat ${RUNdir}/Tracking.flag)
if [ "${hastracking}" == "TRUE" ] 
   then
   echo "Wave Tracking Started: "                      | tee -a $logfile
   date -u                                             | tee -a $logfile
   cd ${RUNdir}
   pwd                                                 | tee -a $logfile
   #AW echo 'Removing empty lines in partition.raw file...'
   #AW sed -i.bak '/ 0.0  0.0 270.0  0.0   0.0/,+1d' ${RUNdir}/swan_part.CG1.raw
   #AW20200206 echo "perl -I${PMnwps} -I${RUNdir} ${USHnwps}/waveTracking.pl" | tee -a $logfile    
   #AW20200206 perl -I${PMnwps} -I${RUNdir} ${USHnwps}/waveTracking.pl | tee -a $logfile
   #AW20200206 export err=$?; err_chk
   #AW20200206 mv -fv ${OUTPUTdir}/partition/CG1/SYS_HSIGN.OUT ${OUTPUTdir}/partition/CG1/SYS_HSIGN.OUT.SPRL
   #AW20200206 mv -fv ${OUTPUTdir}/partition/CG1/SYS_TP.OUT ${OUTPUTdir}/partition/CG1/SYS_TP.OUT.SPRL
   #AW20200206 mv -fv ${OUTPUTdir}/partition/CG1/SYS_DIR.OUT ${OUTPUTdir}/partition/CG1/SYS_DIR.OUT.SPRL
   #AW20200206 mv -fv ${OUTPUTdir}/partition/CG1/SYS_DSPR.OUT ${OUTPUTdir}/partition/CG1/SYS_DSPR.OUT.SPRL
   #AW20200206 mv -fv ${OUTPUTdir}/partition/CG1/SYS_PNT.OUT ${OUTPUTdir}/partition/CG1/SYS_PNT.OUT.SPRL

   #AW073017 ----- Convert partition file to Python scikit learn format ----
   mv swan_part.CG1.raw partition.raw
   ${EXECnwps}/ww3_sysprep.exe
   #AW073017 ---------------------------------------------------------------
   #AW020218 ----- Run Python scikit learn version of wave tracking --------

   cd ${RUNdir}

   #aprun -n1 -N1 -d1 ${PYTHON} ${NWPSdir}/sorc/ww3_syscluster/ww3_systrk_nobasemap_tables_gh.py ${SITEID,,}
   perl -I${PMnwps} -I${RUNdir} ${USHnwps}/waveTracking_clust.pl | tee -a $logfile

   #${USHnwps}/postprocess_partition_fields_clust.sh ${SITEID} CG1

   cycle=$(awk '{print $1;}' ${RUNdir}/CYCLE)
   COMOUTCYC="${COMOUT}/${cycle}/CG0"
   tar -czvf mapplots_CG0_${PDY}${cycle}.tar.gz swan_systrk1_hr???.png
   cp -fv ${RUNdir}/mapplots_CG0_${PDY}${cycle}.tar.gz $COMOUTCYC/
   cp -fv ${RUNdir}/${siteid}_nwps_CG0_Trkng_${PDY}_${cycle}00.bull $COMOUTCYC/
   cp -fv ${RUNdir}/${siteid}_${PDY}.${cycle}0000.sys $COMOUTCYC/
   rm ${RUNdir}/swan_systrk1_hr???.png
   #rm ${RUNdir}/coastal_bound_high.txt
   #AW020218 ---------------------------------------------------------------
fi

#########################################################################

echo " "                                            | tee -a $logfile
echo -n "Wave Tracking Run Finished: "              | tee -a $logfile
date                                                | tee -a $logfile
echo " " | tee -a $logfile

################################################################### 
echo " "                                            | tee -a $logfile
echo "===================================="         | tee -a $logfile
echo "Done running Wave Tracking"                            | tee -a $logfile
date "+%D  %H:%M:%S"                                | tee -a $logfile
echo "===================================="         | tee -a $logfile
echo " "                                            | tee -a $logfile

cd ${DATAROOT}
exit 0
