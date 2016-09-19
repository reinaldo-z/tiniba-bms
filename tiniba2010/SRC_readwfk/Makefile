
CWD=$(shell pwd)
PLATAFORM=$(shell hostname)
PRINTF=@printf
ab=ascii


        ifeq  ($(PLATAFORM),master)
	 ABINITLOC =/home/prog/abinit/ABINITv4.6.5_XEON
        FC=/opt/intel/fc/9.0/bin/ifort
        OPT= -O3 -tpp7 -xW -static
	#OPT= -O3 -tpp7 -xW 
        NAME=readwfk.xeon
        WHATPL=XEON
        endif
        ifeq    ($(PLATAFORM),itanium01)
	 ABINITLOC =/home/prog/abinit/ABINITv4.6.5_ITAN
        FC =/opt/intel/fc/9.0/bin/ifort
        OPT = -O3 -static -tpp2
        NAME=readwfk.itan
        WHATPL=ITANIUM
        endif

        ifeq    ($(PLATAFORM),quad01)
	#ABINITLOC=/home/jl/share_new/quad/ABINITv4.6.5
	 ABINITLOC=/home/jl/share_new/quad/abinit-4.6.5
        FC =/opt/intel/fc/10.1.008/bin/ifort
        OPT = -O3 -static
        NAME=readwfk.quad
        WHATPL=QUAD
        endif


## The order the object files are listed in OBS is more or
## less the order that the object files are compiled in.
OBSFROMABINIT = hdr_io.o wrtout.o leave_new.o leave_myproc.o timab.o timein.o defs_time.o print_ij.o

OBS = DebugMod.o \
      UtilitiesMod.o \
      CommandLineArgumentsMod.o \
      MathMod.o \
      AbinitReaderMod.o

${NAME}	: main.f90 ${OBS}
	${FC} ${OPT} -o ${NAME}  main.f90 ${OBS} ${OBSFROMABINIT}
	#cp ${NAME} ../
	rm -f *.o *.mod *~
	$(PRINTF) "\t*********************************\n"
	$(PRINTF) "\tCOMPILED on: $(WHATPL)\n"
	$(PRINTF) "\tOUTPUT     : ${NAME}\n"
	$(PRINTF) "\t*********************************\n"


UtilitiesMod.o: UtilitiesMod.f90
	${FC} ${OPT} -c UtilitiesMod.f90

CommandLineArgumentsMod.o: CommandLineArgumentsMod.f90
	${FC} ${OPT} -c CommandLineArgumentsMod.f90

DebugMod.o: DebugMod.f90
	${FC} ${OPT} -c DebugMod.f90

MyAllocateMod.o: MyAllocateMod.f90
	${FC} ${OPT} -c MyAllocateMod.f90

MathMod.o: MathMod.f90
	${FC} ${OPT} -c MathMod.f90

AbinitReaderMod.o: AbinitReaderMod.f90
	cp ${ABINITLOC}/Src_0basis/defs_basis.mod .
	cp ${ABINITLOC}/Src_0basis/defs_datatypes.mod .
#	cp ${ABINITLOC}/Src_0basis/defs_interfaces.mod .
	cp ${ABINITLOC}/Src_1managempi/hdr_io.o .
	cp ${ABINITLOC}/Src_1managempi/wrtout.o .
	cp ${ABINITLOC}/Src_1managempi/leave_new.o .
	cp ${ABINITLOC}/Src_0basis/leave_myproc.o .
	cp ${ABINITLOC}/Src_0basis/timab.o .
	cp ${ABINITLOC}/Src_0basis/timein.o .
	cp ${ABINITLOC}/Src_0basis/defs_time.o .
	cp ${ABINITLOC}/Src_1util/print_ij.o .
	${FC} ${OPT} -c AbinitReaderMod.f90

clean:
	rm -rf *.o *.mod
