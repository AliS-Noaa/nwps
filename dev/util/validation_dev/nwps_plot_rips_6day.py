import matplotlib
#matplotlib.use('Agg',warn=False)  # Use this to run Matplotlib in the background and avoid issues with the X-Server

import sys
import os
import os.path
import re
import numpy as np
from scipy.linalg import norm
#from datetime import datetime
import datetime
from datetime import timedelta, date
from netCDF4 import Dataset, num2date
import matplotlib.pyplot as plt
import matplotlib.dates as mdate
from scipy.interpolate import interp1d
from matplotlib.ticker import MultipleLocator

# global vars
COMOUT = os.environ.get('COMOUT')
#COMOUTm1 = os.environ.get('COMOUTm1')
#COMOUTm2 = os.environ.get('COMOUTm2')
workdir = os.environ.get('workdir')

#TDEF = 35
REGION = sys.argv[1]
WFO = sys.argv[2]
CGextract = sys.argv[3]

#Get analysis dates from shell
tmp1 = os.environ.get('STARTDATE')
tmp2 = os.environ.get('STARTDATEm1')
tmp3 = os.environ.get('STARTDATEm2')
tmp4 = os.environ.get('ENDDATE')

startDate=datetime.datetime(int(tmp1[0:4]),int(tmp1[4:6]),int(tmp1[6:8]))
startDatem1=datetime.datetime(int(tmp2[0:4]),int(tmp2[4:6]),int(tmp2[6:8]))
startDatem2=datetime.datetime(int(tmp3[0:4]),int(tmp3[4:6]),int(tmp3[6:8]))
stopDate=datetime.datetime(int(tmp4[0:4]),int(tmp4[4:6]),int(tmp4[6:8]))

timestamp = startDate.strftime("%Y%m%d")

# Read NOAA and NWS logos
noaa_logo = plt.imread('NOAA-Transparent-Logo.png')
nws_logo = plt.imread('NWS_Logo.png')

modtim = [[0 for x in range(145)] for x in range(5000)]
modlon = [[0 for x in range(145)] for x in range(5000)]
modlat = [[0 for x in range(145)] for x in range(5000)]
modprb = [[0 for x in range(145)] for x in range(5000)]
modhs = [[0 for x in range(145)] for x in range(5000)]
moddir = [[0 for x in range(145)] for x in range(5000)]
modper = [[0 for x in range(145)] for x in range(5000)]
modlev = [[0 for x in range(145)] for x in range(5000)]
istat = 1

#Find rip current data
revcycles=['23','22','21','20','19','18','17','16','15','14','13','12','11','10','09','08','07','06','05','04','03','02','01','00']
datafound = 'false'
for cycle in revcycles:
   print('Search for '+WFO+' cycle '+cycle) 
   extdir=COMOUT+REGION+'.'+timestamp+'/'+WFO+'/'+cycle+'/'+CGextract+'/'
   #infile = WFO+'_nwps_5m_'+CGextract+'_ripprob.'+timestamp+'_'+cycle+'00'
   infile = 'nwps.t' + cycle + 'z.5m_' + CGextract + '_ripprob.' + WFO + '.txt'
   if os.path.isfile(extdir+infile):
      print('Reading file '+infile)
      datafound = 'true'
      f = open(extdir+infile, "r")

      tstep = 0
      istat = 0
      print('Reading rip current data...')
      for line in f:
          if tstep == 145:
             tstep = 0
             istat = istat+1
          #print(istat, tstep)
          data = line.split()
          if data[0] == '%':
             continue
          elif data[0] == '%DATE':
             continue
          else:
             timestr = data[0]
             modtim[istat][tstep] = int(datetime.datetime(int(timestr[0:4]),int(timestr[4:6]),int(timestr[6:8]),int(timestr[9:11]),int(timestr[11:13])).strftime('%s'))
             if data[1] != 'MM':
                modlon[istat][tstep] = float(data[1])
             else:
                modlon[istat][tstep] = np.nan
             if data[2] != 'MM':
                modlat[istat][tstep] = float(data[2])
             else:
                modlat[istat][tstep] = np.nan
             if data[3] != 'MM':
                modprb[istat][tstep] = float(data[3])
             else:
                modprb[istat][tstep] = np.nan
             if data[4] != 'MM':
                modhs[istat][tstep] = float(data[4])
             else:
                modper[istat][tstep] = np.nan
             if data[5] != 'MM':
                modper[istat][tstep] = float(data[5])
             else:
                modper[istat][tstep] = np.nan
             if data[6] != 'MM':
                moddir[istat][tstep] = float(data[6])
             else:
                moddir[istat][tstep] = np.nan
             if data[7] != 'MM':
                modlev[istat][tstep] = float(data[7])
             else:
                modlev[istat][tstep] = np.nan
             tstep = tstep+1
   if datafound == 'true':
      break
nstat = istat+1

if datafound == 'true':
   for istat in range(nstat):
      print('Plotting '+WFO+' station '+str(istat+1))
      convfac = 1/0.3048   #meters to feet

      plt.figure(figsize=(8,7))

      # Rip prob
      hoffset = 0.05
      voffset = 5.0
      ax = plt.subplot(5, 1, 1)
      ax.axhline(25.0, linestyle='-', color='y') # horizontal lines
      ax.text(int(mdate.epoch2num(modtim[istat][0]))+hoffset, 25.0+voffset, 'Moderate risk', style='italic',fontsize=8)
      ax.axhline(50.0, linestyle='-', color='r') # horizontal lines
      ax.text(int(mdate.epoch2num(modtim[istat][0]))+hoffset, 50.0+voffset, 'High risk', style='italic',fontsize=8)
      ax.plot_date(mdate.epoch2num(modtim[istat][0:(tstep)]), modprb[istat][0:(tstep)], 'b-o', linewidth=1.0, markeredgecolor='b',markersize=2)
      date_formatter = mdate.DateFormatter('%m/%d')  # Use a DateFormatter to set the data to the correct format.
      ax.xaxis.set_major_formatter(date_formatter)  # Use a DateFormatter to set the data to the correct format.
      ax.tick_params(direction='in', pad=3, labelsize=8)
      ax.set_xlim([startDate, stopDate])
      ax.set_ylim([0, 1])
      ax.set_yticks(np.arange(0, 125, 25))
      ax.xaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      ax.yaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      plt.ylabel('Rip prob [%]', fontsize=10)  

      # Hs
      ax = plt.subplot(5, 1, 2)
      ax.plot_date(mdate.epoch2num(modtim[istat][0:(tstep)]), convfac*np.asarray(modhs[istat][0:(tstep)]), 'b-o', linewidth=1.0, markeredgecolor='b',markersize=2)
      date_formatter = mdate.DateFormatter('%m/%d')  # Use a DateFormatter to set the data to the correct format.  
      ax.xaxis.set_major_formatter(date_formatter)  # Use a DateFormatter to set the data to the correct format.
      ax.tick_params(direction='in', pad=3, labelsize=8)
      ax.set_xlim([startDate, stopDate])
      ax.set_ylim([0., int(max(convfac*np.asarray(modhs[istat][0:(tstep)])))+1.])
      ax.xaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      ax.yaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      plt.ylabel('Hsig [ft]', fontsize=10)

      # Peak per
      ax = plt.subplot(5, 1, 3)
      ax.plot_date(mdate.epoch2num(modtim[istat][0:(tstep)]), modper[istat][0:(tstep)], 'b-o', linewidth=1.0, markeredgecolor='b',markersize=2)
      date_formatter = mdate.DateFormatter('%m/%d')  # Use a DateFormatter to set the data to the correct format.
      ax.xaxis.set_major_formatter(date_formatter)  # Use a DateFormatter to set the data to the correct format.
      ax.tick_params(direction='in', pad=3, labelsize=8)
      ax.set_xlim([startDate, stopDate])
      ax.set_ylim([0., 20.])  
      ax.xaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      ax.yaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      plt.ylabel('Peak period [s]', fontsize=10)      

      # Mean dir relative to shore normal
      ax = plt.subplot(5, 1, 4)
      ax.plot_date(mdate.epoch2num(modtim[istat][0:(tstep)]), moddir[istat][0:(tstep)], 'b-o', linewidth=1.0, markeredgecolor='b',markersize=2)
      ax.axhline(0., linestyle='--', linewidth=1.0, color='k') # horizontal lines
      date_formatter = mdate.DateFormatter('%m/%d')  # Use a DateFormatter to set the data to the correct format.   
      ax.xaxis.set_major_formatter(date_formatter)  # Use a DateFormatter to set the data to the correct format.   
      ax.tick_params(direction='in', pad=3, labelsize=8)
      ax.set_xlim([startDate, stopDate])
      ax.set_ylim([-90., 90.])  
      ax.xaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      ax.yaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      plt.ylabel('Dir SN [deg]', fontsize=10)

      # Water level
      ax = plt.subplot(5, 1, 5)
      ax.plot_date(mdate.epoch2num(modtim[istat][0:(tstep)]), convfac*np.asarray(modlev[istat][0:(tstep)]), 'b-o', linewidth=1.0, markeredgecolor='b',markersize=2)
      ax.axhline(0., linestyle='--', linewidth=1.0, color='k') # horizontal lines
      date_formatter = mdate.DateFormatter('%m/%d')  # Use a DateFormatter to set the data to the correct format.
      ax.xaxis.set_major_formatter(date_formatter)  # Use a DateFormatter to set the data to the correct format.    
      ax.tick_params(direction='in', pad=3, labelsize=8)   
      ax.set_xlim([startDate, stopDate])
      ax.xaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      ax.yaxis.grid(b=True, which='major', color='#C0C0C0', linestyle=':')
      plt.ylabel('WL [ft, MSL]', fontsize=10)

      dstring = timestamp[0:4]+'/'+timestamp[4:6]+'/'+timestamp[6:8]+' '+cycle+'Z'
      plt.suptitle('NWPS WFO-'+WFO.upper()+': Rip Current Probability '+dstring+'\n'+\
           'Station '+str(istat+1)+' ('+"{:.3f}".format(modlat[istat][0])+','+"{:.3f}".format(modlon[istat][0]-360)+')')
           #'Station '+str(istat+1)+' ('+str(modlat[istat][0])+','+str(modlon[istat][0]-360)+')')
   
      # Set up subaxes and plot the logos in them
      #plt.axes([0.09,.93,.08,.08])
      plt.axes([0.09,.90,.08,.08])
      plt.axis('off')
      plt.imshow(noaa_logo,interpolation='gaussian')
      #plt.axes([.83,.93,.08,.08])
      plt.axes([.83,.90,.08,.08])
      plt.axis('off')
      plt.imshow(nws_logo,interpolation='gaussian')
   
      #filenmdate = 'nwps_'+timestamp+'_'+WFO+'_ripprob_stat'+str(istat+1)+'.png'
      #plt.savefig(filenmdate,dpi=150,bbox_inches='tight',pad_inches=0.1)
      filenm = 'nwps_'+WFO+'_ripprob_stat'+str(istat+1)+'.png'
      plt.savefig(filenm,dpi=150,bbox_inches='tight',pad_inches=0.1)
      plt.close()

   # Write output file with max rip prob values for forcast period
   ofilenm = WFO.upper()+'1.rip'
   text_file = open(ofilenm, "w")
   for istat in range(nstat):
      #if max(modprb[istat][0:(tstep)]) < 25.0:
      if max(modprb[istat][0:25]) < 25.0:        #Integrate risk over first day only
         ripwarncol = 'gray'
         ripwarnlev = 'LOW'
      #elif max(modprb[istat][0:(tstep)]) > 50.0:
      elif max(modprb[istat][0:25]) > 50.0:        #Integrate risk over first day only
         ripwarncol = 'red'
         ripwarnlev = 'HIGH'
      else:
         ripwarncol = 'yellow' 
         ripwarnlev = 'MODERATE'      
      outstring = '"'+WFO+'_ripprob_stat'+str(istat+1)+'|'+\
                  "{:.3f}".format(modlat[istat][0])+'|'+"{:.3f}".format(modlon[istat][0]-360)+\
                  '|Rip Current Station '+str(istat+1)+'|'+WFO.upper()+'|'+ripwarncol+'|'+ripwarnlev+'",\n'
      text_file.write("%s" % outstring)
   text_file.close()

else:
   print(' *** Warning: no model data found')

print('-------- Exiting nwps_plot_rips.py ---------')
print('')

