DSET swan.grib2
index swan.idx
DTYPE grib2
TITLE SWAN CG1 Control File
UNDEF 9.999E+20
XDEF 131 linear -81.7 .0184615384
YDEF 204 linear 28.7 .0162561576
ZDEF 1 levels 1 1
TDEF 145 linear 00z09feb2021 1hr
VARS 11
HTSGWsfc=>htsgw        0,1,0   10,0,3 ** surface Significant Height of Combined Wind Waves and Swell [m]
DIRPWsfc=>wavedir      0,1,0   10,0,10 ** surface Primary Wave Direction [deg]
PERPWsfc=>waveper      0,1,0   10,0,11 ** surface Primary Wave Mean Period [s]
DBSSsfc=>depth         0,1,0   10,4,195 ** surface Geometric Depth Below Sea Surface [m]
SWELLsfc=>swell        0,1,0   10,0,8 ** surface Significant Height of Swell Waves [m]
WDIRsfc=>wnddir        0,1,0   0,2,0 ** surface Wind Direction (from which blowing) [deg]
WINDsfc=>wndspdms      0,1,0   0,2,1 ** surface Wind Speed [m/s]
DSLMsfc=>wlevel        0,1,0   10,3,1 ** surface Deviation of Sea Level from Mean [m]
DIRCsfc=>curdir        0,1,0   10,1,0 ** surface Current Direction [deg]
SPCsfc=>curspdms       0,1,0   10,1,1 ** surface Current Speed [m/s]
var10255255sfc=>wlen   0,1,0   10,255,255 ** surface mean wave length (m)
ENDVARS