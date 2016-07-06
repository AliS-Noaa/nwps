# NCEP Config file for global RTOFS and ESTOF init files

# RTOFS Domain for ocean currents
export RTOFSSECTOR="west_conus"
# RTOFSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export RTOFSDOMAIN="233.23 37.90 0.0  134  178 0.029326 0.027027"
export RTOFSNX="135"
export RTOFSNY="179"

# ESTOFS Domain for water level
export ESTOFS_BASIN="estofs.pac"
export ESTOFS_REGION="conus"
# ESFOTSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export ESTOFSDOMAIN="233.23 37.90 0.0  134  178 0.029326 0.027027"
export ESTOFSNX="135"
export ESTOFSNY="179"
export ESTOFSUSEICEMASK="FALSE"
