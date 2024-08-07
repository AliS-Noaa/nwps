# NCEP Config file for global RTOFS and ESTOF init files

# RTOFS Domain for ocean currents
export RTOFSSECTOR="west_atl"
# RTOFSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export RTOFSDOMAIN="259.23 24.76  0. 200 204 0.029326 0.027027"
export RTOFSNX="201"
export RTOFSNY="205"

# ESTOFS Domain for water level
export ESTOFS_BASIN="stofs_2d_glo"
export ESTOFS_REGION="conus.east"
# ESFOTSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export ESTOFSDOMAIN="259.23 24.76  0. 200 204 0.029326 0.027027"
export ESTOFSNX="201"
export ESTOFSNY="205"
export ESTOFSUSEICEMASK="FALSE"

# GFS wind domain settings
# GFSWINDDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export GFSWINDDOMAIN="259.23 24.76  0. 200 204 0.029326 0.027027"
export GFSWINDNX="201"
export GFSWINDNY="205"
export GFSHOURS="180"
export GFSTIMESTEP="3"

