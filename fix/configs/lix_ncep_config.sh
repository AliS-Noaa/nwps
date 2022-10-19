# NCEP Config file for global RTOFS and ESTOF init files

# RTOFS Domain for ocean currents
export RTOFSSECTOR="west_atl"
# RTOFSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export RTOFSDOMAIN="267.70 27.00 0.0 185  152 0.029326 0.027027"
export RTOFSNX="186"
export RTOFSNY="153"

# ESTOFS Domain for water level
export ESTOFS_BASIN="estofs"
export ESTOFS_REGION="conus.east"
# ESFOTSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export ESTOFSDOMAIN="267.70 27.00 0.0 185  152 0.029326 0.027027"
export ESTOFSNX="186"
export ESTOFSNY="153"
export ESTOFSUSEICEMASK="FALSE"

# GFS wind domain settings
# GFSWINDDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export GFSWINDDOMAIN="267.70 27.00 0.0 185  152 0.029326 0.027027"
export GFSWINDNX="186"
export GFSWINDNY="153"
export GFSHOURS="180"
export GFSTIMESTEP="3"

