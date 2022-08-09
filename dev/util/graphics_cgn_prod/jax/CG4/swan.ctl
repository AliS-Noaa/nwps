DSET swan.grib2
index swan.idx
DTYPE grib2
TITLE SWAN CG4 Control File
UNDEF 9.999E+20
XDEF 34 linear -81.43 .0021212121
YDEF 28 linear 30.38 .0018518518
ZDEF 1 levels 1 1
TDEF 145 linear 12z23jan2021 1hr
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