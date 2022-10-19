# NCEP Config file for global RTOFS and ESTOF init files

# RTOFS Domain for ocean currents
export RTOFSSECTOR="west_atl"
# RTOFSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export RTOFSDOMAIN="270.80 28.50 0. 268 110 0.029326 0.027027"
export RTOFSNX="269"
export RTOFSNY="111"

# ESTOFS Domain for water level
export ESTOFS_BASIN="stofs_2d_glo"
export ESTOFS_REGION="conus.east"
# ESFOTSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export ESTOFSDOMAIN="270.80 28.50 0. 268 110 0.029326 0.027027"
export ESTOFSNX="269"
export ESTOFSNY="111"
export ESTOFSUSEICEMASK="FALSE"
