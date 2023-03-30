# makefile : makes the program runupforecast.exe
# Author: Andre van der Westhuysen (andre.vanderwesthuysen@noaa.gov)
# Ali Salimi 2/8/2023 changed it to be machine based

MACHINE_ID := $(shell $(NWPSdir)/env/detect_machine.sh)
$(info Machine ID: $(MACHINE_ID)

ifeq ($(MACHINE_ID),wcoss2)
FC = ftn

else
FC = ifort

endif


clean :
	rm runupforecast_wr.exe runupforecast.o read_nwps.o read_slope.o runupcalc.o

runupforecast_wr : read_nwps.o read_slope.o runupcalc.o runupforecast.o
	$(FC) -o runupforecast_wr.exe runupforecast.o read_nwps.o read_slope.o runupcalc.o

runupforecast.o : runupforecast.f
	$(FC) -c -O runupforecast.f

read_nwps.o : read_nwps.f
	$(FC) -c -O read_nwps.f

read_slope.o : read_slope.f
	$(FC) -c -O read_slope.f

runupcalc.o : runupcalc.f
	$(FC) -c -O runupcalc.f

