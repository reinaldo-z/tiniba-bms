##  Makefile:
##  24 Septimbre 2007, Leon, Gto. Mex. at 01:34
##  Author: J. Luis Cabellos
##  CIO
PROGRAMA=mmeReader
NOMBRE=mmeReader
CWD=$(shell pwd)
PLATAFORM=$(shell hostname)
ECHO=@echo
PRINTF=@printf
RED=\e[0;31m
NC=\e[0m
GREEN=\e[0;32m
MAG=\e[0;35m
	ifeq    ($(PLATAFORM),master)
	FC =/opt/intel/fc/9.0/bin/ifort
	OPTS =-O3	
	NAME=${NOMBRE}.xeon
	WHATPL=Xeon
	endif

	ifeq    ($(PLATAFORM),itanium01)
        FC =/opt/intel/fc/9.0/bin/ifort
        OPTS = -O3 -parallel -static -tpp2
	NAME=${NOMBRE}.itan
        WHATPL=Itanium
        endif


	ifeq    ($(PLATAFORM),quad01)
	FC =/opt/intel/fce/9.1.036/bin/ifort
	OPT = -O3 -static
	NAME=${NOMBRE}.quad
        WHATPL=Quad
        endif



${NAME}	:${PROGRAMA}.o
	${FC} -o ${NAME} ${PROGRAMA}.o
	$(PRINTF) "\t$(GREEN)==========$(NC)\n"
	$(PRINTF) "\tPLATAFORM   : $(GREEN)$(WHATPL)$(NC)\n"
	$(PRINTF) "\tCOMPILER    : "
	$(PRINTF) "$(GREEN)$(FC)$(NC)\n"
	$(PRINTF) "\tFILE OUTPUT :$(GREEN) $(ls )$(NAME)$(NC)\n"
	$(PRINTF) "\t$(GREEN)==========$(NC)\n"
	rm -f ${PROGRAMA}.o
	rm -f ../${NAME}
	cp -v ${NAME} ../

${PROGRAMA}.o	:${PROGRAMA}.f90
		${FC} -c $(OPTS) ${PROGRAMA}.f90


help    :
	$(PRINTF) "\t$(GREEN)==========$(NC)\n"
	$(PRINTF) "\tmake               - compila and link    \n"
	$(PRINTF) "\tmake help          - display this info   \n"
	$(PRINTF) "\tmake clean         - clean all: *.o, *~  \n"
	$(PRINTF) "\t$(GREEN)==========$(NC)\n"


clean	:
	$(PRINTF) "\t$(GREEN)Cleaning files trash...$(NC)\n"
	 rm -f *.o
	 rm -f *~
note    :
	$(ECHO) "   J. Luis Cabellos                         "
	$(ECHO) "   at C.I.O "
