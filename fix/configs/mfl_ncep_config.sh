# NCEP Config file for global RTOFS and ESTOF init files

# RTOFS Domain for ocean currents
export RTOFSSECTOR="west_atl"
# RTOFSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export RTOFSDOMAIN="275.96 23.60 0. 237 171 0.029326 0.027027"
export RTOFSNX="238"
export RTOFSNY="172"

# ESTOFS Domain for water level
export ESTOFS_BASIN="stofs_2d_glo"
export ESTOFS_REGION="conus.east"
# ESFOTSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export ESTOFSDOMAIN="275.96 23.60 0. 237 171 0.029326 0.027027"
export ESTOFSNX="238"
export ESTOFSNY="172"
export ESTOFSUSEICEMASK="FALSE"

# GFS wind domain settings
# GFSWINDDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export GFSWINDDOMAIN="275.96 23.60 0. 237 171 0.029326 0.027027"
export GFSWINDNX="238"
export GFSWINDNY="172"
export GFSHOURS="180"
export GFSTIMESTEP="3"

