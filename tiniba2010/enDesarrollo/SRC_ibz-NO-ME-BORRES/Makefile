 ## ********************************************
 ## * Warning:                                 
 ## * This Makefile  was generated automatically by:  MakeMakefileLocal.PL 
 ## * Don't edit this file,  edit MakeMakefileLocal.PL instead. 
 ##  *** ANY CHANGES MADE HERE WILL BE LOST! *** 
 ## ********************************************
 ## CREATED on: 2010-03-16 05:28:28  by USER:  jl 
 ## Centro de Investigaciones en Optica A.C. 
 ## Leon, Guanajuato, Mexico 
 ## This is free software;.There is NO warranty. J.L. Cabellos
 ##  
ECHO=@echo 
FC = /opt/intel/fc/9.0/bin/ifort -O3 -tpp7 -xW 
	COMPILER-XEON = /opt/intel/fc/9.0/bin/ifort
	COMPILER-ITAN = /opt/intel/fc/9.0/bin/ifort
	COMPILER-QUAD = /opt/intel/fce/10.1.008/bin/ifort
	   FLAGS-XEON = -O3 -tpp7 -xW 
	   FLAGS-ITAN = -O3 -tpp2
	   FLAGS-QUAD = -O3

	CWD=$(shell pwd)
	PLATAFORM=$(shell hostname)
	ECHO=@echo 
	PRINTF=@printf 
	GREEN=\e[0;32m
	MAG=\e[0;35m
	NC=\e[0m
ABINITLOC=/home/jl/2010/tiniba2010/SRC_ibz/abinit_subroutines 
	BASENAME = ibz


	ifeq	($(PLATAFORM),master)
	NAME=$(BASENAME).xeon
	NAME1=$(BASENAME).master
	NAME2=$(BASENAME).node
	ABINITO=abinit_subroutines_node
OBSFROMABINIT= hdr_io.o wrtout.o leave_new.o leave_myproc.o timab.o timein.o 
	FC=$(COMPILER-XEON)
	OPT = $(FLAGS-XEON)
	WHATPL=XEON
	endif

	ifeq	($(PLATAFORM),itanium01)
	NAME=$(BASENAME).itanium.NO.IMPLEMENTADO.16.MARZO.2010 BY CABELLOS.11:44
	NAME1=$(BASENAME).itanium.NO.IMPLEMENTADO.16.MARZO.2010 BY CABELLOS.11:44
	NAME2=$(BASENAME).itanium.NO.IMPLEMENTADO.16.MARZO.2010 BY CABELLOS.11:44
	FC=$(COMPILER-ITAN)
	OPT = $(FLAGS-ITAN)
	WHATPL=ITAN
	endif

	ifeq	($(PLATAFORM),quad01)
	NAME=$(BASENAME).quad
	NAME1=$(BASENAME).quad
	NAME2=$(BASENAME).quad
	ABINITO=abinit_subroutines_quad
OBSFROMABINIT= hdr_io.o wrtout.o leave_new.o leave_myproc.o timab.o  timein.o defs_time.o print_ij.o
	FC=$(COMPILER-QUAD)
	OPT = $(FLAGS-QUAD)
	WHATPL=QUAD
	endif

OBS = 	Sorting.o Global.o MyAllocateMod.o CommandLineArguments.o Symmetries.o Grid.o 3by3matrices.o DefaultInput.o  structFile.o abinitReader.o InitializeDataMod.o checkDimensions.o printIRpts.o printIRtet.o getDiag.o getIRtet.o NextPassMod.o 

$(NAME):	IBZ.f90 ${OBS} 
	${FC} -o $(NAME) IBZ.f90 ${OBS}  ${OBSFROMABINIT} 
 
	@( if [ $(PLATAFORM) == "master" ]; then \
	cp -v $(NAME)  $(NAME1); \
	cp -v $(NAME)  $(NAME2) ;\
	fi )
	 $(PRINTF) " \n " 
	 $(PRINTF) " \t $(MAG)***********************************$(NC)\n " 
	 $(PRINTF) " \t  Compiled : $(WHATPL)\n " 
	 $(PRINTF) " \t  Output   : $(GREEN)$(NAME) $(NC)   \n " 
	 @( if [ $(PLATAFORM) == "master" ]; then \
	   cp -v $(NAME)  $(NAME1); \
	   cp -v $(NAME)  $(NAME2) ;\
	    fi )
	 $(PRINTF) " \t $(MAG)***********************************$(NC)\n " 
	rm -f *.o 
	rm -f *.mod 
	rm -f *~ 
MyAllocateMod.o:	MyAllocateMod.f90 
		${FC} -c MyAllocateMod.f90 
Sorting.o:	Sorting.f90 
		${FC} -c Sorting.f90 
Global.o:	Global.f90
		${FC} -c Global.f90 
CommandLineArguments.o:		CommandLineArguments.f90 
		${FC} -c CommandLineArguments.f90 
Symmetries.o:	Symmetries.f90 
		${FC} -c Symmetries.f90   
Grid.o:		Grid.f90 
		${FC} -c Grid.f90 
structFile.o:	structFile.f90 
		${FC} -c structFile.f90 
abinitReader.o:	abinitReader.f90 
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/defs_basis.mod .
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/defs_datatypes.mod .
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/hdr_io.o .
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/wrtout.o .
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/leave_new.o .
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/leave_myproc.o .
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/timab.o .
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/timein.o .
	@( if [ $(PLATAFORM) == "quad01" ]; then \
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/defs_time.o . ;\
	 cp /home/jl/2010/tiniba2010/SRC_ibz/$(ABINITO)/print_ij.o . ;\
	    fi )
	 ${FC} -c abinitReader.f90 
DefaultInput.o:		DefaultInput.f90 
	 ${FC} -c DefaultInput.f90 
InitializeDataMod.o:	 InitializeDataMod.f90 
	 ${FC} -c InitializeDataMod.f90  
NextPassMod.o:		NextPassMod.f90 
	${FC} -c NextPassMod.f90 
3by3matrices.o:		 3by3matrices.f90 
	 ${FC} -c 3by3matrices.f90 
checkDimensions.o:	checkDimensions.f90 
	 ${FC} -c checkDimensions.f90 
printIRpts.o:		printIRpts.f90 
	 ${FC} -c printIRpts.f90 
printIRtet.o:		printIRtet.f90 
	 ${FC} -c printIRtet.f90 
getDiag.o:		 getDiag.f90 
	 ${FC} -c getDiag.f90 
getIRtet.o:		 getIRtet.f90 
	 ${FC} -c getIRtet.f90 
clean:		 
	rm -f *.o 
	rm -f *.mod 
	rm -f *~ 
update:
	 cp -vf  /home/jl/2010/tiniba2010/SRC_ibz/ibz /home/jl/AbinitShells/bin/
	 $(ECHO) " *********************************** " >> README 
	 $(ECHO) "UPDATE :/home/jl/AbinitShells/bin/ibz  on">> README 
	 date >> README 
	 $(ECHO) " *********************************** ">> README 
cancel:
	 rm -vf  /home/jl/AbinitShells/bin/ibz 
	 $(ECHO) " *********************************** ">> README 
	 $(ECHO) "CANCEL  :/home/jl/AbinitShells/bin/ibz  on" >> README 
	 date >> README 
	 $(ECHO) " *********************************** " >> README 
help:
	 $(ECHO) "  make         -Compila and link "    
	 $(ECHO) "  make help    -Show this info   "    
	 $(ECHO) "  make clean   -clean all *.o *.mod " 
	 $(ECHO) "  make update  -update: /home/jl/AbinitShells/bin/ibz " 
	 $(ECHO) "  make cancel  -cancel :/home/jl/AbinitShells/bin/ibz " 
