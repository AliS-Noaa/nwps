#!/bin/bash
# ----------------------------------------------------------- 
# UNIX Shell Script File
# Tested Operating System(s): RHEL 5,6
# Tested Run Level(s): 3, 5
# Shell Used: BASH shell
# Original Author(s): Alex Gibbs, Tony Freeman, Pablo Santos, Douglas Gaer
# File Creation Date: 06/01/2009
# Date Last Modified: 12/12/2016
#
# Version control: 1.01
#
# Support Team:
#
# Contributors: Roberto Padilla
# ----------------------------------------------------------- 
# ------------- Program Description and Details ------------- 
# ----------------------------------------------------------- 
#
#
# ----------------------------------------------------------- 
export CGNUMPLOT=${1}
CGNUM="${1}"
export CGNUMPLOT
echo "= = = =  = = =   IN NWPS_POSPROC_CGN_PARALLEL.SH  = =  = = =  = = ="
echo " CGNUMPLOT= ${CGNUMPLOT}"
ndata=1
while read p; do
  echo ${ndata} $p
   if [ ${ndata} -eq 1 ]; then
    NWPSdir=$p;
   fi
   if [ ${ndata} -eq 2 ]; then
     ISPRODUCTIO=$p;
   fi
   if [ ${ndata} -eq 3 ]; then
     DEBUGGING=$p;
   fi
   if [ ${ndata} -eq 4 ]; then
     DEBUG_LEVEL=$p;
   fi
   if [ ${ndata} -eq 5 ]; then
     BATHYdb=$p;
   fi
   if [ ${ndata} -eq 6 ]; then
     SHAPEFILEdb=$p;
   fi
   if [ ${ndata} -eq 7 ]; then
     ARCHdir=$p;
   fi
   if [ ${ndata} -eq 8 ]; then
    DATAdir=$p;
   fi
   if [ ${ndata} -eq 9 ]; then
    INPUTdir=$p;
   fi
   if [ ${ndata} -eq 10 ]; then
     LOGdir=$p;
   fi
   if [ ${ndata} -eq 11 ]; then
     VARdir=$p;
   fi
   if [ ${ndata} -eq 12 ]; then
     OUTPUTdir=$p;
   fi
   if [ ${ndata} -eq 13 ]; then
     RUNdir=$p;
   fi
   if [ ${ndata} -eq 14 ]; then
     TMPdir=$p;
   fi
   if [ ${ndata} -eq 15 ]; then
     RUNLEN=$p;
   fi
   if [ ${ndata} -eq 16 ]; then
     WNA=$p;
   fi
   if [ ${ndata} -eq 17 ]; then
     NEST=$p;
   fi
   if [ ${ndata} -eq 18 ]; then
     RTOFS=$p;
   fi
   if [ ${ndata} -eq 19 ]; then
     ESTOFS=$p;
   fi
   if [ ${ndata} -eq 20 ]; then
     WINDS=$p;
   fi
   if [ ${ndata} -eq 21 ]; then
     WEB=$p;
   fi
   if [ ${ndata} -eq 22 ]; then
     export PLOT=$p;
   fi
   if [ ${ndata} -eq 23 ]; then
     SITEID=$p;
   fi
   if [ ${ndata} -eq 24 ]; then
    MODELCORE=$p;
   fi
  ndata=$(( $ndata + 1 ))
done < ${RUNdir}/info_to_nwps_coremodel.txt

#export NWPSdir DEBUGGING DEBUG_LEVEL BATHYdb SHAPEFILEdb ARCHdir
#export DATAdir LOGdir VARdir OUTPUTdir RUNdir TMPdir RUNLEN
#export NEST RTOFS ESTOFS WEB PLOT MODELCORE LOGdir SITEID WNA 
#export WINDS INPUTdir  ISPRODUCTIO DATAdir
#source ${NWPSdir}/parm/platform/set_platform.sh
logrunup=${LOGdir}/runup.log
echo " " | tee -a $logrunup
echo "NWPS Processing CG${CGNUM} " | tee -a $logrunup
# Halt this script it the model or Perl interface crashes
if [ -e ${OUTPUTdir}/netCdf/not_completed ]
    then
    echo "SWAN Run failed!"                                  | tee -a $logrunup
    echo "Exiting ${PROGRAMname} with no further processing" | tee -a $logrunup
    #RemoveLockFile
    export err=1; err_chk
fi

echo " "                                            | tee -a $logrunup
echo -n "SWAN Run Finished OK Preparing for Post-Process"     | tee -a $logrunup                                                
echo " " | tee -a $logrunup
#____________________________RUNUP PROGRAM________________________________
#Run Program    
  echo "DATA: ${DATA}  DATAdir: ${DATAdir}"   | tee -a $logrunup
  source ${DATA}/parm/templates/${siteid}/${SITEID}
  runupcg=${RUNUPDOMAIN:2:1}
  runupcg2="${RUNUPDOMAIN:2:1}"
  echo "runupcg: ${runupcg}"
  echo "runupcg2: ${runupcg2}"
  echo "${RUNUPPROG} -eq ${RUNUPPROG}  and   ${runupcg} == ${CGNUM} ?"   | tee -a $logrunup

  if [ ${RUNUPPROG} -eq "1" ] && [ ${runupcg} == ${CGNUM} ]
  then
     echo "RUNUP WILL BE PROCESSED" | tee -a $logrunup
     dpt_runup_contour=${RUNUPCONT}
     echo " Domain for Runup                : ${RUNUPDOMAIN}" | tee -a $logrunup
     echo " Depth-contour used for runup    : ${dpt_runup_contour}" | tee -a $logrunup

     inputparm="${RUNdir}/inputCG${CGNUM}"
     if [ ! -e ${inputparm} ]
     then
        msg="FATAL ERROR: Runup program: Missing inputCG${CGNUM} file. Cannot open ${inputparm}"
        postmsg $jlogfile "$msg"        
        export err=1; err_chk
     fi
     #Moving input files and programs to the temporary directory
     export TEMPDIRrunup=${VARdir}/${siteid}.tmp/CG${CGNUM}/runup
     mkdir -p ${TEMPDIRrunup}
     cd ${TEMPDIRrunup}
     #Copying all needed data; input and programs here to run run_runup.sh
     # in ${VARdir}/${siteid}.tmp/CG${CGNUM}/runup
     cp ${inputparm} .
     grep "^INPGRID WIND" inputCG${CGNUM} > blah1
     init=$(awk '{print $11;}' blah1)
     echo "$init" > datetime
     cut -c 1-4 datetime > year
     cut -c 5-6 datetime > mon
     cut -c 7-8 datetime > day
     cut -c 10-11 datetime > hh
     cut -c 12-13 datetime > mm

     yyyy=$(cat year)
     mon=$(cat mon)
     dd=$(cat day)
     hh=$(cat hh)
     mm=$(cat mm)

     date_stamp="${yyyy}${mon}${dd}"
     echo "date_stamp: ${date_stamp}"  | tee -a $logrunup
     CYCLErunup="${hh}${mm}" 
     CYCLErunupout="${hh}"
     # nomenclature input file for run_runup.sh e.g 20m_contour_CG2.20150202_0000_MHX
     fileor="${dpt_runup_contour}_contour_CG${CGNUM}"
     filein="${dpt_runup_contour}_contour_CG${CGNUM}.${yyyy}${mon}${dd}_${CYCLErunup}_${SITEID}"
     #fileout="${dpt_runup_contour}_CG${CGNUM}_runup.${yyyy}${mon}${dd}_${hh}${mm}_${SITEID}.txt"
     #fileout="${WFO}_${NET}_${dpt_runup_contour}_CG${CGNUM}_runup.${yyyy}${mon}${dd}_${hh}${mm}"
     echo "filein: ${filein}"  | tee -a $logrunup
     cp -fvp ${RUNdir}/${fileor} .
     cp ${fileor} ${filein}    | tee -a $logrunup
     cp -fvp ${FIXnwps}/beach_slope_db/CG${CGNUM}.${SITEID}_slopes.txt .   | tee -a $logrunup
     #cp ${HOMEnwps}/exec/runupforecast.exe .   | tee -a $logrunup
     #cp ${USHnwps}/run_runup.sh .   | tee -a $logrunup
     ls -lt  | tee -a $logrunup
     source ${USHnwps}/run_runup.sh  ${CYCLErunup} ${date_stamp}  
     export err=$?; err_chk
     
     #Make output directory
     OUTDIRrunup=${DATA}/output/runup/CG${CGNUM}/
     mkdir -p ${OUTDIRrunup}
     cp -fv  ${filein} ${OUTDIRrunup}/${filein}
     cp -fv  ${FORT22} ${OUTDIRrunup}/${FORT22}

     cycle=$(awk '{print $1;}' ${RUNdir}/CYCLE)
     COMOUTCYC="${COMOUT}/${cycle}/CG${CGNUM}"
     if [ "${SENDCOM}" == "YES" ]; then
        mkdir -p $COMOUTCYC
        cp -fv  ${OUTDIRrunup}/${filein} ${COMOUTCYC}/${filein}
        cp -fv  ${OUTDIRrunup}/${FORT22} ${COMOUTCYC}/${FORT22}
        if [ "${SENDDBN}" == "YES" ]; then
            ${DBNROOT}
        fi
     fi

     # TODO: 12/08/2016 - Testing RUNUP GRIB2 encoding
     gribfile=$(ls ${DATA}/output/grib2/CG${CGNUM}/*CG${CGNUM}*grib2 | xargs -n 1 basename | tail -n 1)
     fullname=`echo $gribfile | cut -c14-26`
     GRIB2file=${NWPSDATA}/output/grib2/CG${CGNUM}/${gribfile}
     WAVE_RUNUP_TO_BIN="${EXECnwps}/wave_runup_to_bin"
     cgnCLON1=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lon | grep to | grep by | awk '{ print $2 }')
     cgnLON1=$(echo "${cgnCLON1} - 360" | bc)
     cgnCLON2=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lon | grep to | grep by | awk '{ print $4 }')
     cgnLON2=$(echo "${cgnCLON2} - 360" | bc)
     cgnNX=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lat-lon | grep grid | grep x | awk '{ print $2 }' | sed s/'grid:('//g)
     cgnLAT1=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lat | grep to | grep by | awk '{ print $2 }')
     cgnLAT2=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lat | grep to | grep by | awk '{ print $4 }')
     cgnNY=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lat-lon | grep grid | grep x | awk '{ print $4 }' | sed s/')'//g)
     SWAN_RUNUP_OUTPUT_FILE="${OUTDIRrunup}/${FORT22}"
     RUNUPparms="erosion_flag owash_flag"
     RUNUPerrors=0
     for parm in ${RUNUPparms}
     do
	 cat ${FIXnwps}/templates/${parm}.meta > ${parm}.meta
	 sed -i s/'<< SET NX >>'/${cgnNX}/g ${parm}.meta
	 sed -i s/'<< SET NY >>'/${cgnNY}/g ${parm}.meta
	 sed -i s/'<< SET LA1 >>'/${cgnLAT1}/g ${parm}.meta
	 sed -i s/'<< SET LA2 >>'/${cgnLAT2}/g ${parm}.meta
	 sed -i s/'<< SET LO1 >>'/${cgnLON1}/g ${parm}.meta
	 sed -i s/'<< SET LO2 >>'/${cgnLON2}/g ${parm}.meta
	 echo "${WAVE_RUNUP_TO_BIN} -v -d -c ${SWAN_RUNUP_OUTPUT_FILE} ${parm} ${parm}.meta ${parm}_templates.grib2 ${parm}_points.bin"
	 ${WAVE_RUNUP_TO_BIN} -v -d -c ${SWAN_RUNUP_OUTPUT_FILE} ${parm} ${parm}.meta ${parm}_templates.grib2 ${parm}_points.bin
	 if [ $? -eq 0 ]; then
	     echo "${WGRIB2} ${parm}_templates.grib2  -no_header -import_bin ${parm}_points.bin -grib_out ${parm}_final_runup.grib2"
	     ${WGRIB2} ${parm}_templates.grib2  -no_header -import_bin ${parm}_points.bin -grib_out ${parm}_final_runup.grib2
	 else
	     RUNUPerrors=1
	     break
	 fi
     done
     
     if [ ${RUNUPerrors} -eq 0 ]; then
	 cat /dev/null > final_runup.grib2
	 for parm in ${RUNUPparms}
	 do
	     cat ${parm}_final_runup.grib2 >> final_runup.grib2
	     cp -f final_runup.grib2 ${COMOUTCYC}/${siteid}_nwps_CG${CGNUM}_${fullname}_RipRunup.grib2
	     cp -f final_runup.grib2 ${NWPSDATA}/output/grib2/CG${CGNUM}/${siteid}_nwps_CG${CGNUM}_${fullname}_RipRunup.grib2
	 done
         #AW052917 Do not include runup output in general GRIB2 output, because it won't go over SBN yet.
         #cat final_runup.grib2 >> ${GRIB2file}
     else 
	 echo "ERROR - ${WAVE_RUNUP_TO_BIN} program error, no RUNUP GRIB2 file generated for this run"
     fi
  else
     echo " Runup calculation not activated for this domain (CG${CGNUM})"
  fi
#_________________________RIP CURRENT PROGRAM____________________________________________
#Run Program 
  SITEID=${SITEID^^}
  source ${DATA}/parm/templates/${siteid}/${SITEID}
#  source ${DOMAINFILE}
  ripcg=${RIPDOMAIN:2:1}
  if [ ${RIPPROG} -eq "1" ] && [ ${ripcg} == ${CGNUM} ]
  then
     echo "RIP CURRENT PROBABILITY WILL BE COMPUTED" 
     dptcontour=${RIPCONT:0:1}
     echo " CG domain for rip currents: ${RIPDOMAIN}"
     echo " Depth contour used        : ${dptcontour} m"
     source ${USHnwps}/run_ripcurrent.sh ${RIPDOMAIN} ${dptcontour} ${RUNLEN}
     export err=$?; err_chk     

     # Copy results to output directories
     cycleout=$(awk '{print $1;}' ${RUNdir}/CYCLE)
     COMOUTCYC="${COMOUT}/${cycleout}/${RIPDOMAIN}"
     mkdir -p $COMOUTCYC
     cp -fv  ${RIPDATA}/${CGCONT} ${COMOUTCYC}/${CGCONT}
     cp -fv  ${RIPDATA}/${FORT23} ${COMOUTCYC}/${FORT23}

     mkdir -p $GESOUT/riphist/${SITEID}
     cp -fv  ${RIPDATA}/${CGCONT} ${GESOUT}/riphist/${SITEID}/${CGCONT}

     # TODO: 11/29/2016 - Tesing RIP GRIB2 encoding below
     SWAN_RIP_OUTPUT_FILE="${RIPDATA}/${FORT23}"
     rip_current_meta_template="${FIXnwps}/templates/RIP.meta"
     rip_current_meta="${RIPDATA}/RIP.meta"
     cat ${rip_current_meta_template} > ${rip_current_meta}
     RIP_CURRENT_TO_BIN="${EXECnwps}/rip_current_to_bin"
     gribfile=$(ls ${DATA}/output/grib2/CG${CGNUM}/*CG${CGNUM}*grib2 | xargs -n 1 basename | tail -n 1)
     fullname=`echo $gribfile | cut -c14-26`
     GRIB2file=${NWPSDATA}/output/grib2/CG${CGNUM}/${gribfile}
     cgnCLON1=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lon | grep to | grep by | awk '{ print $2 }')
     cgnLON1=$(echo "${cgnCLON1} - 360" | bc)
     cgnCLON2=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lon | grep to | grep by | awk '{ print $4 }')
     cgnLON2=$(echo "${cgnCLON2} - 360" | bc)
     cgnNX=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lat-lon | grep grid | grep x | awk '{ print $2 }' | sed s/'grid:('//g)
     cgnLAT1=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lat | grep to | grep by | awk '{ print $2 }')
     cgnLAT2=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lat | grep to | grep by | awk '{ print $4 }')
     cgnNY=$(${WGRIB2} ${GRIB2file} -V -d 1 | grep lat-lon | grep grid | grep x | awk '{ print $4 }' | sed s/')'//g)
     sed -i s/'<< SET NX >>'/${cgnNX}/g ${rip_current_meta}
     sed -i s/'<< SET NY >>'/${cgnNY}/g ${rip_current_meta}
     sed -i s/'<< SET LA1 >>'/${cgnLAT1}/g ${rip_current_meta}
     sed -i s/'<< SET LA2 >>'/${cgnLAT2}/g ${rip_current_meta}
     sed -i s/'<< SET LO1 >>'/${cgnLON1}/g ${rip_current_meta}
     sed -i s/'<< SET LO2 >>'/${cgnLON2}/g ${rip_current_meta}
     echo "${RIP_CURRENT_TO_BIN} -v -d -c ${SWAN_RIP_OUTPUT_FILE} ${rip_current_meta} ${RIPDATA}/templates.grib2 ${RIPDATA}/points.bin"
     ${RIP_CURRENT_TO_BIN} -v -d -c ${SWAN_RIP_OUTPUT_FILE} ${rip_current_meta} ${RIPDATA}/templates.grib2 ${RIPDATA}/points.bin
     if [ $? -eq 0 ]; then
	 # Only create the GRIB2 file if the encoding process is successful
	 echo "${WGRIB2} ${RIPDATA}/templates.grib2 -no_header -import_bin ${RIPDATA}/points.bin -grib_out ${RIPDATA}/final_rip.grib2"
	 ${WGRIB2} ${RIPDATA}/templates.grib2 -no_header -import_bin ${RIPDATA}/points.bin -grib_out ${RIPDATA}/final_rip.grib2
         #AW052917 Do not include runup output in general GRIB2 output, because it won't go over SBN yet.
         #cat ${RIPDATA}/final_rip.grib2 >> ${GRIB2file}
	 #cp -f ${RIPDATA}/final_rip.grib2 ${COMOUTCYC}/${siteid}_nwps_CG${CGNUM}_${fullname}_RipRunup.grib2
         cat ${RIPDATA}/final_rip.grib2 >> ${COMOUTCYC}/${siteid}_nwps_CG${CGNUM}_${fullname}_RipRunup.grib2
         cat ${RIPDATA}/final_rip.grib2 >> ${NWPSDATA}/output/grib2/CG${CGNUM}/${siteid}_nwps_CG${CGNUM}_${fullname}_RipRunup.grib2
     fi
     # TODO: 11/29/2016 - Tesing RIP GRIB2 encoding above
  else
     echo " Rip current calculation not activated for this domain (CG${CGNUM})"
  fi
#_______________________________________________________________________________________

# NOTE: If WEB is enable we must set PLOT to YES
if [ "${WEB}" == "YES" ]; then export PLOT="YES"; fi
# NOTE: Deactivating plotting of nests. This now done outside of the operational run 
export PLOTNEST="NO"

# NOTE: This will allow us to automate plotting with out send to Web option
# NOTE: To save time, deactivate plotting when running retrospectives
if [ "${PLOTNEST}" == "YES" ] && [ "${RETROSPECTIVE}" == "FALSE" ]
then
  echo "RUN PYTHON PLOTTING SCRIPTS"

  TEMPDIR=${VARdir}/${siteid}.tmp/CG${CGNUM}
  mkdir -p ${TEMPDIR}
  GRAPHICSdir="${OUTPUTdir}/figures/${siteid}/CG${CGNUM}"
  mkdir -p ${GRAPHICSdir}

  echo "Creating output plots"
  ${NWPSdir}/ush/python/plot_nwps_run.sh ${SITEID}
  export err=$?; err_chk 

  cycleout=$(awk '{print $1;}' ${RUNdir}/CYCLE)
  COMOUTCYC="${COMOUT}/${cycleout}/CG${CGNUM}"
  mkdir -p $COMOUTCYC

  inputparm="${RUNdir}/inputCG${CGNUM}"
  if [ ! -e ${inputparm} ]
  then
     echo "ERROR - Missing inputCG${CGNUM} file"
     echo "ERROR - Cannot open ${inputparm}"
     export err=1; err_chk
  fi
  cp ${inputparm} .
  grep "^INPGRID WIND" inputCG${CGNUM} > blah1
  init=$(awk '{print $11;}' blah1)
  echo "$init" > datetime
  cut -c 1-4 datetime > year
  cut -c 5-6 datetime > mon
  cut -c 7-8 datetime > day
  cut -c 10-11 datetime > hh
  cut -c 12-13 datetime > mm

  yyyy=$(cat year)
  mon=$(cat mon)
  dd=$(cat day)
  hh=$(cat hh)
  mm=$(cat mm)

  # Copying field plots to COMOUT
  echo "Copying PNG images to ${GRAPHICSdir}"
  rm ${TEMPDIR}/*logo* ${TEMPDIR}/*Logo*
  cp -vpf ${TEMPDIR}/*.png ${GRAPHICSdir}/.
  chmod 777 ${GRAPHICSdir}/*.png
  cd ${GRAPHICSdir}
  figsTarFile="plots_CG${CGNUM}_${yyyy}${mon}${dd}${hh}.tar.gz"
  tar cvfz ${figsTarFile} *.png
  cp ${figsTarFile} $COMOUTCYC/${figsTarFile}
fi

#Sending grib2 files with gridded wave parameters to COMOUT
cd ${DATA}/output/grib2/CG${CGNUM}
     inputparm="${RUNdir}/inputCG${CGNUM}"
     if [ ! -e ${inputparm} ]
     then
        echo "ERROR - Missing inputCG${CGNUM} file"
        echo "ERROR - Cannot open ${inputparm}"
        export err=1; err_chk
     fi
     #Copying all needed data; input and programs here to run ru_runup.sh
     # in ${VARdir}/${siteid}.tmp/CG${CGNUM}/runup
     cp ${inputparm} .
     grep "^INPGRID WIND" inputCG${CGNUM} > blah1
     init=$(awk '{print $11;}' blah1)
     echo "$init" > datetime
     cut -c 1-4 datetime > year
     cut -c 5-6 datetime > mon
     cut -c 7-8 datetime > day
     cut -c 10-11 datetime > hh
     cut -c 12-13 datetime > mm

     yyyy=$(cat year)
     mon=$(cat mon)
     dd=$(cat day)
     hh=$(cat hh)
     mm=$(cat mm)

     date_stamp="${yyyy}${mon}${dd}"
     grib2File="${siteid}_nwps_CG${CGNUM}_${date_stamp}_${hh}${mm}.grib2"
     cycle=$(awk '{print $1;}' ${RUNdir}/CYCLE)
     COMOUTCYC="${COMOUT}/${cycle}/CG${CGNUM}"
     if [ "${SENDCOM}" == "YES" ]; then
        mkdir -p $COMOUTCYC
        cp -fv  ${grib2File} ${COMOUTCYC}/${grib2File}
        # Restart and other input files
        cp -fv  ${RUNdir}/inputCG${CGNUM} ${COMOUTCYC}/
        cp -fv  ${RUNdir}/${date_stamp}${cycle}.wnd ${COMOUTCYC}/
        if [ -e ${RUNdir}/${date_stamp}${cycle}_CG${CGNUM}.wlev ]; then
           cp -fv  ${RUNdir}/${date_stamp}${cycle}_CG${CGNUM}.wlev ${COMOUTCYC}/
        fi
        if [ -e ${RUNdir}/${date_stamp}${cycle}_CG${CGNUM}.cur ]; then
           cp -fv  ${RUNdir}/${date_stamp}${cycle}_CG${CGNUM}.cur ${COMOUTCYC}/
        fi
        #cp -fv  ${RUNdir}/bc_CG${CGNUM} ${COMOUTCYC}/

        if [ "${SENDDBN}" == "YES" ]; then
            ${DBNROOT}/bin/dbn_alert MODEL NWPS_GRIB $job ${COMOUTCYC}/${grib2File}
        fi
     fi

#Sending spec2d files at buoy locations to COMOUT
if [[ -d "${DATA}/output/spectra/CG${CGNUM}" ]]; then
   cd ${DATA}/output/spectra/CG${CGNUM}
   yy=$(echo $yyyy | cut -c 3-4)
   spec2dFile="SPC2D.*.CG${CGNUM}.YY${yy}.MO${mon}.DD${dd}.HH${hh}"
   if [ "${SENDCOM}" == "YES" ]; then
      mkdir -p $COMOUTCYC
      cp -fv  ${spec2dFile} ${COMOUTCYC}/
   fi
  # ----------------------------------------
  # Send alerts to DBNet
  # ----------------------------------------
  if [ "${SENDDBN}" == "YES" ]; then
    for f in ${spec2dFile}; do
      if [ -f "${COMOUTCYC}/${f}" ]; then
        echo "Sending ${f} to DBNet"
        $DBNROOT/bin/dbn_alert MODEL NWPS_ASCII_SPECTRA ${job} ${COMOUTCYC}/${f}
      else
        echo "Warning: ${COMOUTCYC}/${f} does not exist, skipping DBNet alert"
      fi
    done
  fi
else
   echo "Wave spectra not computed over this domain (CG${CGNUM})"
fi

#if [ "${WEB}" == "YES" ]
#then
#    echo "Sending output plots to Web" | tee -a $logfile
#    ${NWPSdir}/src/grads/bin/send_to_web.sh ${SITEID} | tee -a $logfile
#    export WEB="YES"
#else
#    echo "Not sending images Web"  | tee -a $logfile
    export WEB="NO"
#fi

#echo " " | tee -a $logfile
#
#echo "Cleaning out archive directory:"              | tee -a $logfile
#cd ${ARCHdir}/
#ITEMSTOKEEP=60
#TOTAL=$(ls -1 *tgz | sort | wc -l)
#HEAD=$(expr $TOTAL - $ITEMSTOKEEP)
#if [[ $TOTAL -le $ITEMSTOKEEP ]]
#then
#    echo ": Nothing to clean ..."               | tee -a $logfile
#else
#    for i in $(ls -1 *tgz | head -n $HEAD)
#    do
#	echo -n ": "                        | tee -a $logfile
#	rm -vf $i                           | tee -a $logfile
#    done
#fi

echo " " | tee -a $logfile
################################################################### 
echo "Cleaning out netcdf/cdl directory:"           | tee -a $logfile
cd ${OUTPUTdir}/netCdf/cdl
KEEP=0
COUNT=$(ls -1 | wc -l)
TRIM=$(expr $COUNT - $KEEP)
if [[ $TRIM -gt 0 ]]
then
    for i in $(ls -1 | head -n $TRIM)
    do
	echo -n ": "                        | tee -a $logfile
        rm -vf $i                           | tee -a $logfile
    done
fi
echo "Done" | tee -a $logfile

echo " " | tee -a $logfile
echo "Cleaning out netcdf/CG directories:"           | tee -a $logfile

if [ -e ${OUTPUTdir}/netCdf/${CGNUMPLOT} ]
then
cd ${OUTPUTdir}/netCdf/${CGNUMPLOT}
KEEP=2
COUNT=$(ls -1 | wc -l)
TRIM=$(expr $COUNT - $KEEP)
if [[ $TRIM -gt 0 ]]
then
    for i in $(ls -1 | head -n $TRIM)
    do
        echo -n ": "                        | tee -a $logfile
        rm -vf $i                           | tee -a $logfile
    done
fi
echo "Done" | tee -a $logfile

echo " " | tee -a $logfile
fi

################################################################### 
#echo "Cleaning out grib2/CG directories:"           | tee -a $logfile
#if [ -e ${OUTPUTdir}/grib2/${CGNUMPLOT} ]
#then
#cd ${OUTPUTdir}/grib2/${CGNUMPLOT}
#KEEP=2
#COUNT=$(ls -1 | wc -l)
#TRIM=$(expr $COUNT - $KEEP)
#if [[ $TRIM -gt 0 ]]
#then
#    for i in $(ls -1 | head -n $TRIM)
#    do
#        echo -n ": "                        | tee -a $logfile
#        rm -vf $i                           | tee -a $logfile
#    done
#fi
#echo "Done" | tee -a $logfile#
#
#echo " " | tee -a $logfile
#fi

################################################################### 
echo "Cleaning out hdf5/CG directories:"           | tee -a $logfile

if [ -e ${OUTPUTdir}/hdf5/${CGNUMPLOT} ]
then
cd ${OUTPUTdir}/hdf5/${CGNUMPLOT}
KEEP=2
COUNT=$(ls -1 | wc -l)
TRIM=$(expr $COUNT - $KEEP)
if [[ $TRIM -gt 0 ]]
then
    for i in $(ls -1 | head -n $TRIM)
    do
        echo -n ": "                        | tee -a $logfile
        rm -vf $i                           | tee -a $logfile
    done
fi
echo "Done" | tee -a $logfile

echo " " | tee -a $logfile
fi
###################################################################

echo "Platform is: $NWPSplatform"
if [ $NWPSplatform == "SRSWAN" ]
then
  NWPSDATA="${NWPSSRSWANDATA}"
elif [ $NWPSplatform == "DEV" ]
then
  NWPSDATA="${NWPSDEVDATA}"
elif [ $NWPSplatform == "IFPSWAN" ]
then
  NWPSDATA="${NWPSIFPSWANDATA}"
elif [ $NWPSplatform == "DEVWCOSS" ]
then
  NWPSDATA="${NWPSDEVDATA}"
fi

echo "Platform is: $NWPSplatform"
echo "NWPSDATA=${NWPSDEVDATA}"

echo "HANDLE LOCK FILE"                             | tee -a $logfile
echo "DONE"

echo " " | tee -a $logfile


echo " "                                            | tee -a $logfile
echo "===================================="         | tee -a $logfile
echo "Done running NWPS"                            | tee -a $logfile
date "+%D  %H:%M:%S"                                | tee -a $logfile
echo "===================================="         | tee -a $logfile
echo " "                                            | tee -a $logfile

source ${USHnwps}/calc_runtime.sh
export err=$?; err_chk
echo " " | tee -a $logfile

date +%s > ${VARdir}/total_end_secs.txt
START=$(cat ${VARdir}/total_start_secs.txt)
FINISH=$(cat ${VARdir}/total_end_secs.txt)
PROCNAME="NWPS package"
calc_runtime ${START} ${FINISH} "${PROCNAME}"| tee -a $logfile
export err=$?; err_chk

echo " " | tee -a $logfile

cd ${NWPSdir}/
#RemoveLockFile
exit 0
