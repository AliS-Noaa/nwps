# owash.py script
# Author: Andre van der Westhuysen, 12/15/16
# Purpose: Plots SWAN output parameters from GRIB2.

import matplotlib
matplotlib.use('Agg',warn=False)
import sys
import os
import datetime
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap
from mpl_toolkits.basemap import Basemap
from matplotlib import colors

# Parameters
monthstr = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC']

# Read NOAA and NWS logos
noaa_logo = plt.imread('NOAA-Transparent-Logo.png')
nws_logo = plt.imread('NWS_Logo.png')
usgs_logo = plt.imread('USGS_Logo.png')

# Read control file
print '*** owash.py ***'
if os.path.isfile("swan_riprunup.ctl"):
   print 'Reading: swan_riprunup.ctl'

   with open("swan_riprunup.ctl") as f:
       content = f.readlines()
   dummy = content[0]
   dummy2 = dummy.split(" ")
   DSET = dummy2[1].rstrip("\n")

   dummy = content[5]
   dummy2 = dummy.split(" ")
   nlon = int(dummy2[1])
   x0 = float(dummy2[3])
   dx = float(dummy2[4])

   dummy = content[6]
   dummy2 = dummy.split(" ")
   nlat = int(dummy2[1])
   y0 = float(dummy2[3])
   dy = float(dummy2[4])

   dummy = content[8]
   dummy2 = dummy.split(" ")
   TDEF = int(dummy2[1])
   TINCR = int(dummy2[4].rstrip("hr\n"))
   #----- Default to a plotting interval of 3h; adjust TDEF accordingly -----
   TINCR_OLD = TINCR
   TINCR = 3
   TDEF = (TDEF-1)/(TINCR/TINCR_OLD)+1
   #-------------------------------------------------------------------------
else:
   print '*** TERMINATING ERROR: Missing control file: swan_riprunup.ctl'
   sys.exit()

# Load model results
if os.path.isfile(DSET):
   print 'Reading: '+DSET
else:
   print '*** TERMINATING ERROR: Missing input file: '+DSET
   sys.exit()

# Extract GRIB2 files to text
for tstep in range(1, (TDEF+1)):
   print ''
   print 'Extracting Time step: '+str(tstep)

   # Deviation of sea level from mean
   grib2dump = 'OWASH_extract_f'+str((tstep-1)*TINCR).zfill(3)+'.txt'
   fieldmax = 'OWASH_extract_fieldmax.txt'
   fieldmin = 'OWASH_extract_fieldmin.txt'
   if tstep == 1:
      command = '$WGRIB2 '+DSET+' -s | grep "var discipline=10 master_table=2 parmcat=3 parm=4:surface:anl" | $WGRIB2 -i '+DSET+' -rpn "sto_1:-9999:rcl_1:merge" -spread '+grib2dump
      command2 = '$WGRIB2 '+DSET+' -s | grep "var discipline=10 master_table=2 parmcat=3 parm=4:surface:anl" | $WGRIB2 -i '+DSET+' -max | cat > '+fieldmax
      command3 = '$WGRIB2 '+DSET+' -s | grep "var discipline=10 master_table=2 parmcat=3 parm=4:surface:anl" | $WGRIB2 -i '+DSET+' -min | cat > '+fieldmin
   else:
      command = '$WGRIB2 '+DSET+' -s | grep "var discipline=10 master_table=2 parmcat=3 parm=4:surface:'+str((tstep-1)*TINCR)+' hour" | $WGRIB2 -i '+DSET+' -rpn "sto_1:-9999:rcl_1:merge" -spread '+grib2dump
      command2 = '$WGRIB2 '+DSET+' -s | grep "var discipline=10 master_table=2 parmcat=3 parm=4:surface:'+str((tstep-1)*TINCR)+' hour" | $WGRIB2 -i '+DSET+' -max | cat >> '+fieldmax
      command3 = '$WGRIB2 '+DSET+' -s | grep "var discipline=10 master_table=2 parmcat=3 parm=4:surface:'+str((tstep-1)*TINCR)+' hour" | $WGRIB2 -i '+DSET+' -min | cat >> '+fieldmin
   os.system(command)
   os.system(command2)
   os.system(command3)

# Set up lon/lat mesh
lons=np.linspace(x0,x0+float(nlon-1)*dx,num=nlon)
lats=np.linspace(y0,y0+float(nlat-1)*dy,num=nlat)
reflon,reflat=np.meshgrid(lons,lats)

if (lons.max()-lons.min()) > 15.0:
   dlon = 4.0
elif (lons.max()-lons.min()) > 1.0:
   dlon = 1.0
else:
   dlon = (lons.max()-lons.min())/5.
if (lats.max()-lats.min()) > 0.5:
   dlat = 0.5
else:
   dlat = (lats.max()-lats.min())/5.

SITEID = os.environ.get('SITEID')
CGNUMPLOT = os.environ.get('CGNUMPLOT')
WATERLEVELS = os.environ.get('WATERLEVELS')
EXCD = os.environ.get('EXCD')

temp=np.loadtxt(fieldmax, delimiter='=', usecols=[1])
maxval=max(temp)
temp=np.loadtxt(fieldmin, delimiter='=', usecols=[1])
minval=min(temp)

plt.figure()
# Read the extracted text file
for tstep in range(1, (TDEF+1)):
   print ''
   print 'Processing Time step: '+str(tstep)

   # Create a matrices of nlat x nlon initialized to 0
   par = np.zeros((nlat, nlon))
   par2 = np.zeros((nlat, nlon))

   # Read dates
   grib2dump = 'OWASH_extract_f'+str((tstep-1)*TINCR).zfill(3)+'.txt'
   fo = open(grib2dump, "r")
   line = fo.readline()
   linesplit = line.split()
   if linesplit[7] == 'anl':
      forecastTime = 0
   else:
      forecastTime = int(linesplit[7])
   temp = linesplit[6]
   temp = temp[2:12]
   date = datetime.datetime(int(temp[0:4]),int(temp[4:6]),int(temp[6:8]),int(temp[8:10]))
   # Add the forecast hour to the start of the cycle timestamp
   date = date + datetime.timedelta(hours=forecastTime)
   fo.close()
   print 'Cycle: '+str(forecastTime)+', Hour: '+str(date)

   # Overwash probability (0-1)
   grib2dump = 'OWASH_extract_f'+str((tstep-1)*TINCR).zfill(3)+'.txt'
   data=np.loadtxt(grib2dump,delimiter=',',comments='l') 

   #lons=np.linspace(x0,x0+float(nlon-1)*dx,num=nlon)
   #lats=np.linspace(y0,y0+float(nlat-1)*dy,num=nlat)
   #reflon,reflat=np.meshgrid(lons,lats)

   # Set up parameter field
   for lat in range(0, nlat):
      for lon in range(0, nlon):
         par[lat,lon] = data[nlon*lat+lon,2:3]

   # Remove exception values
   par[np.where(par==-9999)] = np.nan

   # Plot data
   if tstep == 1:
      if ((SITEID == 'afg') & (CGNUMPLOT == '1')):
         m=Basemap(projection='merc',llcrnrlon=lons.min(),urcrnrlon=lons.max(),llcrnrlat=(lats.min()-0.1),urcrnrlat=lats.max(),resolution='f')
      else:
         m=Basemap(projection='merc',llcrnrlon=lons.min(),urcrnrlon=lons.max(),llcrnrlat=lats.min(),urcrnrlat=lats.max(),resolution='f')
      x,y=m(reflon,reflat)

   clevs = [0,5,50,95,100]
   # specify the bounds for the colors
   bounds=[0,5,50,95,100]
   # create the custom colormap
   cmap = colors.ListedColormap(['grey', 'blue', 'yellow','red'])
   # specify the mapping from value-->color
   norm = colors.BoundaryNorm(bounds, cmap.N)

   m.contourf(x,y,par,clevs,cmap=cmap,norm=norm)
   m.colorbar(location='right',size='2.5%',pad='7%',spacing='proportional')
   #bar(np.nan,np.nan,color='blue',label='blue label')
   #bar(np.nan,np.nan,color='red',label='red label')
   #legend(fancybox=True,shadow=True,loc='best')

   # There is an issue with plotting m.fillcontinents with inland lakes, so omitting it in
   # the case of WFO-GYX, CG2 and CG3 (Lakes Sebago and Winni)
   if (not ((SITEID == 'mfl') & (CGNUMPLOT == '3'))) & \
      (not ((SITEID == 'gyx') & (CGNUMPLOT == '2'))) & \
      (not ((SITEID == 'gyx') & (CGNUMPLOT == '3'))):
      #m.fillcontinents()
      m.drawcoastlines()
   m.drawmeridians(np.arange(lons.min(),lons.max(),dlon),labels=[0,0,0,dlon],dashes=[1,3],color='0.50',fontsize=7)   
   m.drawparallels(np.arange(lats.min(),lats.max(),dlat),labels=[dlat,0,0,0],dashes=[1,3],color='0.50',fontsize=7)

   # Draw CWA zones from ESRI shapefiles. NB: Make sure the lon convention is -180:180.
   #m.readshapefile('marine_zones','marine_zones')
   #m.drawcounties()

   # Draw Columbia River Mouth piers
   if ((SITEID == 'pqr') & (CGNUMPLOT == '3')):
      ipierlons = [(235.96161-360),(235.96173-360),(235.95755-360)]
      ipierlats = [46.265216,46.267288,46.276829]
      npierlons = [(235.90511-360),(235.91421-360),(235.91421-360),
                   (235.93265-360),(235.93841-360),(235.94009-360)]
      npierlats = [46.261173,46.264595,46.264595,46.275276,46.279504,46.280726]
      spierlons = [(235.92139-360),(235.92446-360),(235.92598-360),(235.9313-360),
                   (235.95295-360),(235.95676-360),(235.98158-360),(235.99183-360)]
      spierlats = [46.23481,46.234087,46.233942,46.233758,
                   46.232979,46.233316,46.227833,46.224246]
      xx, yy = m(ipierlons, ipierlats) 
      xxx, yyy = m(npierlons, npierlats) 
      xxxx, yyyy = m(spierlons, spierlats) 
      m.plot(xx,yy,color="black", linewidth=2.5, linestyle="-")
      m.plot(xxx,yyy,color="black", linewidth=2.5, linestyle="-")
      m.plot(xxxx,yyyy,color="black", linewidth=2.5, linestyle="-")

   figtitle = '** EXPERIMENTAL **   NWPS-USGS Overwash Probability (%) \n Hour '\
              +str(forecastTime)+' ('+str(date.hour).zfill(2)+'Z'+str(date.day).zfill(2)\
              +monthstr[int(date.month)-1]+str(date.year)+')'
   plt.title(figtitle,fontsize=14)

   # Set up subaxes and plot the logos in them
   plt.axes([0.02,.87,.08,.08])
   plt.axis('off')
   plt.imshow(noaa_logo,interpolation='gaussian')
   plt.axes([.92,.87,.08,.08])
   plt.axis('off')
   plt.imshow(nws_logo,interpolation='gaussian')
   plt.axes([0.02,.02,.11,.08])
   plt.axis('off')
   plt.imshow(usgs_logo,interpolation='gaussian')

   filenm = 'swan_owash_hr'+str(forecastTime).zfill(3)+'.png'
   plt.savefig(filenm,dpi=150,bbox_inches='tight',pad_inches=0.1)
   plt.clf()

# Clean up text dump files
os.system('rm OWASH_extract*f???.txt')