SHELL=/bin/sh

#Command for building a shared library. This varies depending on the OS.

LINK_SHARED_HEAD=ld -shared
LINK_SHARED_TAIL=

#If the ar command fails on your system, consult the ar manpage
#for your system.
#AR=ar 
DEFS=-DHAVE_CONFIG_H
AR = ar 

#CFLAGS=-g -DHAVE_LIBPNG -DHAVE_LIBZ -DHAVE_LIBJPEG -DHAVE_MALLOC_H -DHAVE_LIBFREETYPE -DHAVE_LIBXPM
#CFLAGS=-g -qchars=signed -O2 -DHAVE_LIBPNG -DHAVE_LIBZ -DHAVE_LIBJPEG
#CFLAGS=-g -qchars=signed -O2 -DHAVE_LIBPNG -DHAVE_LIBZ
CFLAGS = -O3 -Wall -fsigned-char -DHAVE_LIBPNG -DHAVE_LIBZ -DNONDLL

#LIBS=-lgd  -lpng -lz -ljpeg -lfreetype -lm
#LIBS=-lgd -lpng -lz -ljpeg -lm
LIBS=-lgd -lpng -lz -lm

#INCLUDEDIRS=-I. -I/usr/include/freetype2 -I/usr/include/X11 -I/usr/X11R6/include/X11 -I/usr/local/include
#INCLUDEDIRS=-I. -I../libpng -I../zlib -I../jpeg
#INCLUDEDIRS=-I. -I../libpng -I../zlib
INCLUDEDIRS=-I. -I$(PNG_INC) -I$(Z_INC)

#LIBDIRS=-L/usr/local/lib -L/usr/lib/X11 -L/usr/X11R6/lib
#LIBDIRS=-L. -L../libpng -L../zlib -L../freetype/lib
#LIBDIRS=-L../libpng -L../zlib -L../jpeg -L.
LIBDIRS=$(PNG_LIB) $(Z_LIB) -L.

#INSTALL_LIB=/usr/lib
INSTALL_LIB=.

#INSTALL_INCLUDE=/usr/include
INSTALL_INCLUDE=.

#INSTALL_BIN=/usr/bin
INSTALL_BIN=.

#
#
# Changes should not be required below here.
#
#

# Update these with each release!

MAJOR_VERSION=2
VERSION=2.0.33

#COMPILER=gcc -fPIC
COMPILER=icc
EXEEXT= 

CC=$(COMPILER) $(DEFS) $(INCLUDEDIRS)
LINK=$(CC) $(LIBDIRS) $(LIBS)

PROGRAMS=$(BIN_PROGRAMS) $(TEST_PROGRAMS)

BIN_PROGRAMS=pngtogd$(EXEEXT) pngtogd2$(EXEEXT) gdtopng$(EXEEXT)\
             gd2topng$(EXEEXT) gd2copypal$(EXEEXT) gdparttopng$(EXEEXT)\
             webpng$(EXEEXT) gd2togif$(EXEEXT) gdcmpgif$(EXEEXT)\
             giftogd2$(EXEEXT)

TEST_PROGRAMS=gdtest$(EXEEXT) gddemo$(EXEEXT) gd2time$(EXEEXT)\
             gdtestft$(EXEEXT) testac$(EXEEXT) fontsizetest$(EXEEXT)\
             fontwheeltest$(EXEEXT)

#default: instructions
default: libgd.a

instructions:
	@echo Edit this Makefile if you wish. The configure script makes
	@echo reasonable guesses, but as of this writing \(2.0.2\) has not
	@echo been field-tested on a lot of systems.
	@echo
	@echo Second, type \'make install\' as root.
	@echo
	@echo This installs the GD ${VERSION} shared library,
	@echo which is required in order to use the included
	@echo utility programs, and also includes the utility
	@echo programs such as webpng, pngtogd, etc.
	@echo
	@echo OPTIONAL third step: type \'make test\' to build
	@echo the optional test programs. Type \'make install\' FIRST.
	@echo
	@echo IF SHARED LIBRARIES WON\'T WORK FOR YOU:
	@echo Type \'make libgd.a\' to produce a static library,
	@echo which you can install manually in /usr/lib.

test: $(TEST_PROGRAMS)

install: libgd.so.${VERSION} $(BIN_PROGRAMS)
	sh ./install-item 755 pngtogd $(INSTALL_BIN)/pngtogd
	sh ./install-item 755 pngtogd2 $(INSTALL_BIN)/pngtogd2
	sh ./install-item 755 gdtopng $(INSTALL_BIN)/gdtopng
	sh ./install-item 755 gd2topng $(INSTALL_BIN)/gd2topng
	sh ./install-item 755 gd2copypal $(INSTALL_BIN)/gd2copypal
	sh ./install-item 755 gdparttopng $(INSTALL_BIN)/gdparttopng
	sh ./install-item 755 webpng $(INSTALL_BIN)/webpng
	sh ./install-item 755 gd2togif $(INSTALL_BIN)/gd2togif
	sh ./install-item 755 gdcmpgif $(INSTALL_BIN)/gdcmpgif
	sh ./install-item 755 giftogd2 $(INSTALL_BIN)/giftogd2
	sh ./install-item 755 bdftogd $(INSTALL_BIN)/bdftogd
	sh ./install-item 644 gd.h $(INSTALL_INCLUDE)/gd.h
	sh ./install-item 644 gdcache.h $(INSTALL_INCLUDE)/gdcache.h
	sh ./install-item 644 gd_io.h $(INSTALL_INCLUDE)/gd_io.h
	sh ./install-item 644 gdfontg.h $(INSTALL_INCLUDE)/gdfontg.h
	sh ./install-item 644 gdfontl.h $(INSTALL_INCLUDE)/gdfontl.h
	sh ./install-item 644 gdfontmb.h $(INSTALL_INCLUDE)/gdfontmb.h
	sh ./install-item 644 gdfonts.h $(INSTALL_INCLUDE)/gdfonts.h
	sh ./install-item 644 gdfontt.h $(INSTALL_INCLUDE)/gdfontt.h

gddemo: gddemo.o
	$(CC) gddemo.o -o gddemo	$(LIBDIRS) $(LIBS)

testac: testac.o
	$(CC) testac.o -o testac	$(LIBDIRS) $(LIBS)

pngtogd: pngtogd.o
	$(CC) pngtogd.o -o pngtogd	$(LIBDIRS) $(LIBS)

webpng: webpng.o
	$(CC) webpng.o -o webpng	$(LIBDIRS) $(LIBS)

pngtogd2: pngtogd2.o
	$(CC) pngtogd2.o -o pngtogd2	$(LIBDIRS) $(LIBS)

gdtopng: gdtopng.o
	$(CC) gdtopng.o -o gdtopng	$(LIBDIRS) $(LIBS)

gd2topng: gd2topng.o
	$(CC) gd2topng.o -o gd2topng	$(LIBDIRS) $(LIBS)

gd2togif: gd2togif.o
	$(CC) gd2togif.o -o gd2togif    $(LIBDIRS) $(LIBS)

gdcmpgif: gdcmpgif.o
	$(CC) gdcmpgif.o -o gdcmpgif    $(LIBDIRS) $(LIBS)

giftogd2: giftogd2.o
	$(CC) giftogd2.o -o giftogd2      $(LIBDIRS) $(LIBS)

gd2copypal: gd2copypal.o
	$(CC) gd2copypal.o -o gd2copypal	$(LIBDIRS) $(LIBS)

gdparttopng: gdparttopng.o
	$(CC) gdparttopng.o -o gdparttopng	$(LIBDIRS) $(LIBS)

gdtest: gdtest.o
	$(CC) gdtest.o -o gdtest	$(LIBDIRS) $(LIBS)

gd2time: gd2time.o
	$(CC) gd2time.o -o gd2time	$(LIBDIRS) $(LIBS)

gdtestft: gdtestft.o
	$(CC) --verbose gdtestft.o -o gdtestft $(LIBDIRS) $(LIBS)

fontwheeltest: fontwheeltest.o
	$(CC) --verbose fontwheeltest.o -o fontwheeltest $(LIBDIRS) $(LIBS)

fontsizetest: fontsizetest.o
	$(CC) --verbose fontsizetest.o -o fontsizetest $(LIBDIRS) $(LIBS)

LIBOBJS=gd.o gd_security.o gdfx.o gd_gd.o gd_gd2.o gd_io.o gd_io_dp.o gd_gif_in.o \
		gd_gif_out.o gd_io_file.o gd_io_ss.o gd_jpeg.o gd_png.o gd_ss.o gd_topal.o \
      gd_wbmp.o gdcache.o gdfontg.o gdfontl.o gdfontmb.o gdfonts.o gdfontt.o \
      gdft.o gdhelpers.o gdkanji.o gdtables.o gdxpm.o wbmp.o

#LIBOBJS=gd.o gd_gd.o gd_gd2.o gd_io.o gd_io_dp.o \
#		gd_io_file.o gd_ss.o gd_io_ss.o gd_png.o gd_jpeg.o gdxpm.o \
#		gdfontt.o gdfonts.o gdfontmb.o gdfontl.o gdfontg.o \
#		gdtables.o gdft.o gdcache.o gdkanji.o wbmp.o \
#		gd_wbmp.o gdhelpers.o gd_topal.o

#Shared library. This should work fine on any ELF platform (Linux, etc.) with
#GNU ld or something similarly intelligent. To avoid the chicken-and-egg
#problem, this target also installs the library so that applications can
#actually find it.

libgd.so.${VERSION}: ${LIBOBJS}
	-rm -f libgd.so.${VERSION} 2>/dev/null
	${LINK_SHARED_HEAD} -o libgd.so.${VERSION} ${LIBOBJS} 
	sh ./install-item 644 libgd.so.${VERSION} \
		$(INSTALL_LIB)/libgd.so.${VERSION}
	-rm $(INSTALL_LIB)/libgd.so.${MAJOR_VERSION} 2>/dev/null
	ln -s $(INSTALL_LIB)/libgd.so.${VERSION} \
		$(INSTALL_LIB)/libgd.so.${MAJOR_VERSION}	
	-rm $(INSTALL_LIB)/libgd.so 2>/dev/null
	ln -s $(INSTALL_LIB)/libgd.so.${VERSION} \
		$(INSTALL_LIB)/libgd.so	

#Static library, if you really need one for some reason.
libgd.a: ${LIBOBJS}
	rm -f libgd.a
	$(AR) rc libgd.a ${LIBOBJS}
	-ranlib libgd.a

clean:
	rm -f *.o *.a *.so ${PROGRAMS} test/gdtest.jpg test/gdtest.wbmp test/fttest.png test/fttest.jpg font*test*.png

distclean: clean
	rm -f Makefile config.h
