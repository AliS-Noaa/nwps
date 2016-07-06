# NCEP Config file for global RTOFS and ESTOF init files

# RTOFS Domain for ocean currents
export RTOFSSECTOR="honolulu"
# RTOFSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export RTOFSDOMAIN="198.03 17.30 0.0 301 243 0.029326 0.027027"
export RTOFSNX="302"
export RTOFSNY="244"

# ESTOFS Domain for water level
export ESTOFS_BASIN="estofs.pac"
export ESTOFS_REGION="hawaii"
# ESFOTSDOMAIN="LON LAT 0. NX NY EW-RESOLUTION NS-RESOLUTION"
export ESTOFSDOMAIN="198.03 17.30 0.0 301 243 0.029326 0.027027"
export ESTOFSNX="302"
export ESTOFSNY="244"
export ESTOFSUSEICEMASK="FALSE"
