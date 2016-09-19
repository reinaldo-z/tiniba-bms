
## cabellos 
CWD=$(shell pwd)
PLATAFORM=$(shell hostname)
PRINTF=@printf
ab=ascii

        ifeq  ($(PLATAFORM),master)
        FC=/opt/intel/fc/9.0/bin/ifort
        OPT= -O3 -tpp7 -xW 
        NAME=refine.xeon
        WHATPL=XEON
        endif
        ifeq    ($(PLATAFORM),itanium01)
        FC =/opt/intel/fc/9.0/bin/ifort
        OPT = -O3 -tpp2
        NAME=refine.itan
        WHATPL=ITANIUM
        endif

        ifeq    ($(PLATAFORM),quad01)
        FC =/opt/intel/fc/10.1.008/bin/ifort
        OPT = -O3 -static
        NAME=refine.quad
        WHATPL=QUAD
        endif

MODS = filestuff.o

OBJS = ${MODS} whichCubesToDivide.o

refine : ${OBJS}
	${FC} ${OPT} -o refine ${OBJS}
	mv refine  ${NAME}
	rm -f *.o *.mod *~
	$(PRINTF) "\t*********************************\n"
	$(PRINTF) "\tCOMPILED on: $(WHATPL)\n"
	$(PRINTF) "\tOUTPUT     : ${NAME}\n"
	$(PRINTF) "\t*********************************\n"


filestuff.o : filestuff.f90
	${FC} ${OPT} -c filestuff.f90

whichCubesToDivide.o : whichCubesToDivide.f90
	${FC} ${OPT} -c whichCubesToDivide.f90

all : ${ALL}

clean :
	rm -f *.o *.mod
