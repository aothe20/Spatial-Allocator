#.........................................................................
## COPYRIGHT
#    (C) 2014-     UNC Institute for the Environment
# Distributed under the GNU GENERAL PUBLIC LICENSE version 2
# See file "GPL.txt" for conditions of use.
#.........................................................................
#  Environment Variables:
#       BIN     machine/OS/compiler/mode type. Shows up as suffix
#               for "Makeinclude.${BIN}" to determine compilation
#               flags, and in ${OBJDIR} and $(INSTALL) to determine
#               binary directories
#       INSTDIR installation-directory root, used for "make install":
#               executables will be installed there
#            
#.........................................................................
#  Directories:
#       $(IODIR)    is the source directory for the I/O API library
#       $(IOLIB)    is the object-library directory for the I/O API library
#       $(PROJDIR)  is the base-directory for the PROJ4 installation
#       $(PROJLIB)  is the object-library directory for PROJ4
#       $(PROJINC)  is the include-directory for PROJ4
#       $(SRCDIR)   is the source directory for the Spatial Allocator
#       $(BLDDIR)   is the build  directory for the Spatial Allocator
#       $(INSTDIR)  is the install-directory
#.........................................................................
#

#####   Default I/O API binary-type:

#module add pgi 

BIN := Linux2_x86_64pg16.10
#BIN := Linux2_x86pg_pgcc_nomp


SRCDIR := ${PWD}
BLDDIR := ${PWD}/${BIN}

######   Location of PROJ, I/O API and NetCDF libraries compiled using pgcc

PROJDIR := /nas02/apps/proj-4.7.0
#PROJDIR := /proj/ie/apps/longleaf/sallocator/git/Spatial-Allocator/src/libs/proj-4.9.3/local
PROJLIB := ${PROJDIR}/lib
PROJINC := ${PROJDIR}/include

#Linux2_x86_64pg
IODIR :=  /proj/ie//apps/longleaf/ioapi-3.2/ioapi
IOLIB :=  /proj/ie//apps/longleaf/ioapi-3.2/${BIN}

# Linux2_x86pg_pgcc_nomp
#IODIR := /nas01/depts/ie/cempd/apps/ioapi_30/ioapi
#IOLIB := /nas01/depts/ie/cempd/apps/ioapi_30/${BIN}

INSTDIR := ${SA_HOME}/bin/64bits

VPATH := ${SRCDIR} ${OBJDIR} ${IODIR}

######  Architecture dependent stuff

include ${IODIR}/Makeinclude.${BIN}

OPTFLAGS := ${MFLAGS} ${COPTFLAGS} ${ARCHFLAGS}

######   Fortran libraries needed for compiling with the I/O API

#FORTLIBS := -lpgf90 -lpgf90_rpm1 -lpgf902 -lpgf90rtl -lpgftnrtl -lpgc -lm -lrt -lpthread -lc -nomp # Linux Portland Group
FORTLIBS := -lpgf90 -lpgf90_rpm1 -lpgf902 -lpgf90rtl -lpgftnrtl -lpgmp -lrt -lpthread -lc -nomp # Linux Portland Group

######  # Library paths

LIBPATH = -L. -L$(BLDDIR) -L$(PROJLIB) -L$(IOLIB)

LIBS := -Bstatic $(LIBPATH) -lspatial -lm -lproj -lioapi -lnetcdff -lnetcdf $(FORTLIBS) $(OMPLIBS)

IOAPIFLAGS := -DFLDMN=1 -DUSE_IOAPI

######  No I/O API support:
#LIBPATH=-L. -L$(PROJLIB)
#LIBS := $(LIBPATH) -lspatial -lm -lproj -static
#IOAPIFLAGS=


CFLAGS := -D_GNU_SOURCE ${MFLAGS} ${COPTFLAGS} ${IOAPIFLAGS} ${ARCHFLAGS} -I$(SRCDIR) -I$(PROJINC) -I${IODIR} -pgf90libs -g -traceback


CSRC := mims_spatial.c srg_main.c beld3smk.c PointFileReader.c  \
       PolygonFileReader.c parseAllocModes.c diffsurr.c io.c    \
       diffioapi.c io.c dbf2asc.c beld4smk.c

LSRC := attributes.c bbox.c data_weight.c dbfopen.c		\
 dscgridc.c fractionalVegReader.c inpoly.c       		\
 intersect.c io.c mims_spatl_proj.c polyops.c    		\
 regularGridReader.c EGridReader.c testPolyReader.c 		\
 segseg.c shpopen.c strlistc.c sumpoly.c surrogate.c 		\
 PolyReader.c gpc.c parseWeightAttributes.c 			\
 parse_include_exclude.c convert_beld.c 		        \
 create_subsets.c eval.c postfix.c 				\
 sastack.c sdstack.c allocate.c overlay.c 			\
 BoundingBoxReader.c variableGridReader.c 			\
 PolygonFileReader.c PointFileReader.c 				\
 union.c parseAllocModes.c 					\
 PolyShapeReader.c  PolyMShapeInOne.c AttachDBFAttribute.c 	\
 PolyShapeWrite.c centroid.c 					\
 IoapiInputReader.c AttachIoapiAttribute.c allocateIoapi.c

LOBJ := $(LSRC:.c=.o)

COBJ := $(CSRC:.c=.o)

OBJ :=  $(CSRC:.c=.o) $(LSRC:.c=.o)

LIB := libspatial.a

EXE := allocator.exe beld3smk.exe beld4smk.exe dbf2asc.exe diffioapi.exe diffsurr.exe srgcreate.exe

######################################################################

all:  lib exe

lib:  $(LIB)

exe:  $(EXE)

dir:
	mkdir -p $(BLDDIR)

install: $(EXE)
	mkdir -p $(INSTDIR)
	cp -f ${BIN}/*.exe  $(INSTDIR)

clean: 
	rm -f  ${BIN}/*.exe ${BIN}/*.o ${BIN}/*.a

neat: 
	rm -f $(OBJ)

realclean: clean
	rm -f *.exe *.o *.a
	rm -f ${BIN}/*.exe ${BIN}/*.o ${BIN}/*.a


#  ---------------------------  Dependencies:  --------------------------

.c.o:
	cd ${BLDDIR} ; $(CC) $(CFLAGS) -c $(SRCDIR)/$<

$(LIB): $(LOBJ)
	cd ${BLDDIR} ; $(AR) $(ARFLAGS) ${LIB} $(LOBJ) ; ranlib ${LIB}


eval.exe: postfix.o sdstack.o sastack.o io.o dbfopen.o
	cd ${BLDDIR} ; $(CC) $(CFLAGS) -DEVAL_UNIT -o $@ $(SRCDIR)/eval.o $^ $(LIBS)

allocator.exe: mims_spatial.o
	cd ${BLDDIR} ; $(CC) -o $@ $^ $(LIBS)

allocmodetest.exe: parseAllocModes.c
	cd ${BLDDIR} ; $(CC) $(CFLAGS) -DALLOC_MODE_TEST -o $@ $(SRCDIR)/$^ $(LIBS)

beld3smk.exe: beld3smk.o
	cd ${BLDDIR} ; cd ${BLDDIR} ; $(CC) -o $@ $^ $(LIBS)

beld4smk.exe: beld4smk.o
	cd ${BLDDIR} ; cd ${BLDDIR} ; $(CC) -o $@ $^ $(LIBS)

dbf2asc.exe: dbf2asc.o 
	cd ${BLDDIR} ; cd ${BLDDIR} ; $(CC) -o $@ $^ $(LIBS)

diffioapi.exe: diffioapi.o io.o
	cd ${BLDDIR} ; $(CC) -o $@ $^ $(LIBS)
	
diffsurr.exe: diffsurr.o io.o
	cd ${BLDDIR} ; $(CC) -o $@ $^ $(LIBS)

pointfiletest.exe: PointFileReader.c
	cd ${BLDDIR} ; $(CC) $(CFLAGS) -DTEST_POINTR -o $@ $(SRCDIR)/$^ $(LIBS)
	
polygonfiletest.exe: PolygonFileReader.c
	cd ${BLDDIR} ; $(CC) $(CFLAGS) -DTEST_POLYR -o $@ $(SRCDIR)/$^ $(LIBS)

srgcreate.exe: srg_main.o
	cd ${BLDDIR} ; $(CC) -o $@ $^ $(LIBS)


