#!/bin/bash
set -x
# DEVHERA Config
# Last Modified: 2/13/2023

DEVHERA="FALSE"
DEVHERA_SYSTEM=""
DEVHERA_USER=$(whoami)
if [ -e /u/${DEVHERA_USER} ] && [ -e /ptmpp1 ]
then
    echo "INFO - Configuring NWPS for DEVHERA system"
    DEVHERA="TRUE"
    if [ -e /gpfs/gd1 ]
    then
	echo "INFO - DEVHERA is on GYRE system"
	DEVHERA_SYSTEM="GYRE"
    fi
    if [ -e /gpfs/td1 ]
    then
	echo "INFO - DEVHERA is on TIDE system"
	DEVHERA_SYSTEM="TIDE"
    fi
fi

#export NWPSDEVDATA="/ptmpp1/${DEVWCOSS_USER}/data/nwps_${siteid}"
export NWPSDEVDATA=${DATA}

echo "++++++++++++++ in devhera_config.sh ++++++++++++++"
echo " NWPSDEVDATA = ${NWPSDEVDATA}"

if [ ! -e ${NWPSDEVDATA} ]; then mkdir -vp ${NWPSDEVDATA}; fi
if [ ! -e ${NWPSDEVDATA} ] 
then 
    echo "ERROR - Error creating SRSWAN data DIR ${NWPSDEVDATA}" 
    export err=1; err_chk
fi

# Set database DIRs here
export BATHYdb=${NWPSdir}/fix/bathy_db
export SHAPEFILEdb=${NWPSdir}/fix/shapefile_db

# Set processing DIRs here
export ARCHdir=${NWPSDEVDATA}/archive
export DATAdir=${NWPSDEVDATA}/data
export INPUTdir=${NWPSDEVDATA}/input
export VARdir=${NWPSDEVDATA}/var
export OUTPUTdir=${NWPSDEVDATA}/output
export RUNdir=${NWPSDEVDATA}/run
export TMPdir=${NWPSDEVDATA}/tmp
export LDMdir=${NWPSDEVDATA}/ldm

# Set log DIRs here
export LOGdir=${NWPSDEVDATA}/logs

# Set our regional baseline here
export DEBUGGING="FALSE"
export ISPRODUCTION="FALSE"
export SITETYPE="EMC"

##export SENDLDADALERTS="TRUE"

# Build options for WCOSS
# -xSSE4.2 optimization flag for 55XX series, 56XX series, 75XX series, E7 Family, i3/5/7                                                                 
# For SRSWAN Intel builds
##export INTEL_INSTALL_DIR="/opt/intel"
##export INTELVARS="${INTEL_INSTALL_DIR}/bin/compilervars.sh"
##export COMPILER="INTEL"
##export OPTFLAGS="-xSSE4.2 -O2" 

# Runtime options for SRSWAN
export MPMODE="MPI"

