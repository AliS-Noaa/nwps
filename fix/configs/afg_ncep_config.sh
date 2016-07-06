# NCEP Config file for global RTOFS and ESTOF init files

# RTOFS Domain for ocean currents
export RTOFSSECTOR="alaska"
# RTOFSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export RTOFSDOMAIN="183.00 60.50 0.0  1313 482 0.029326 0.027027"
export RTOFSNX="1314"
export RTOFSNY="483"

# ESTOFS Domain for water level
export ESTOFS_BASIN="estofs.pac"
export ESTOFS_REGION="alaska"
# ESFOTSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export ESTOFSDOMAIN="183.00 60.50 0.0  1313 482 0.029326 0.027027"
export ESTOFSNX="1314"
export ESTOFSNY="483"
export ESTOFSUSEICEMASK="TRUE"

# Sea ice domain
export SEAICEBLOCKDENS="0.5"
# SEAICEDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export SEAICEDOMAIN="${ESTOFSDOMAIN}"
export SEAICENX="${ESTOFSNX}"
export SEAICENY="${ESTOFSNY}"
export SEAICEHOURS="${ESTOFSHOURS}"
export SEAICETIMESTEP="${ESTOFSTIMESTEP}"
