 ## ********************************************
 ## * Warning:                                 
 ## * This Makefile  was generated automatically by:  MakeMakefileLocal.PL 
 ## * Don't edit this file,  edit MakeMakefileLocal.PL instead. 
 ##  *** ANY CHANGES MADE HERE WILL BE LOST! *** 
 ## ********************************************
 ## CREATED on: 2007-09-23 21:46:13  by USER:  jl 
 ## Centro de Investigaciones en Optica A.C. 
 ## Leon, Guanajuato, Mexico 
 ## jl :
 ## This is free software;.There is NO warranty.
 ##  J.L. Cabellos
 ##  

	ECHO=@echo 
	PRINTF=@printf 
	CWD=$(shell pwd)
	PLATAFORM=$(shell hostname)
	RED=\e[0;31m
	GREEN=\e[0;32m
	MAGENTA=\e[0;35m
	NC=\e[0m

	ifeq ($(PLATAFORM),master)
	 FC=/opt/intel/fc/9.0/bin/ifort -FR -O3 -tpp7 -xW -static 
	 OPT= -FR -O3 -tpp7 -xW -w -static
	 NAME=ibz.xeon
	 WHATPL=XEON
	 SUB=abinit_subrotinesXEON
	endif

	ifeq ($(PLATAFORM),itanium01)
	 FC=/opt/intel/fc/9.0/bin/ifort -O3 -static -tpp2
	 OPT= -O3 -static -tpp2
	 NAME=ibz.itan
	 WHATPL=Itanium
	 SUB=abinit_subrotinesITAN
	endif

	ifeq ($(PLATAFORM),quad01)
	 FC =/opt/intel/fce/9.1.036/bin/ifort -O3 -static
	 OPT = -O3 -static
	 NAME=ibz.quad
	 SUB=abinit_subrotinesQUAD
	 WHATPL=Quad
	endif

ABINITLOC=/home/jl/macondo/SRC_ibz/ibzNew/${SUB}
OBSFROMABINIT= hdr_io.o wrtout.o leave_new.o leave_myproc.o timab.o timein.o defs_time.o  print_ij.o
OBS =	ConstantsMod.o DebugMod.o UtilitiesMod.o  MathMod.o  SortingMod.o LatticeMod.o MyAllocateMod.o CommandLineArgumentsMod.o SymmetriesMod.o GridMod.o DefaultInput.o structFile.o abinitReader.o InitializeDataMod.o NextPassMod.o getIRtet.o PrintResultsMod.o
${NAME}:	IBZ.f90 ${OBS} 
	${FC} -o ${NAME}  IBZ.f90 ${OBS}  ${OBSFROMABINIT}
	$(PRINTF) "\t$(MAGENTA)============ $(NC)\n "
	$(PRINTF) "\tCheck if there is a file output:$(GREEN) ${NAME}  $(NC)\n "
	$(PRINTF) "\t$(MAGENTA)============ $(NC)\n "
ConstantsMod.o:	ConstantsMod.f90
		${FC} -c  ConstantsMod.f90
DebugMod.o:	DebugMod.f90 
		${FC} -c  DebugMod.f90
UtilitiesMod.o:	UtilitiesMod.f90
		${FC} -c UtilitiesMod.f90 
MathMod.o:	MathMod.f90
		${FC} -c MathMod.f90
SortingMod.o:	SortingMod.f90
		${FC} -c SortingMod.f90
LatticeMod.o:	LatticeMod.f90
		${FC} -c LatticeMod.f90
MyAllocateMod.o:	MyAllocateMod.f90
		${FC} -c MyAllocateMod.f90 
CommandLineArgumentsMod.o:	CommandLineArgumentsMod.f90
		${FC} -c CommandLineArgumentsMod.f90
SymmetriesMod.o:	SymmetriesMod.f90
		${FC} -c SymmetriesMod.f90
GridMod.o:	GridMod.f90
		${FC} -c GridMod.f90 
structFile.o:	structFile.f90
		${FC} -c structFile.f90
abinitReader.o:	abinitReader.f90
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/defs_basis.mod .
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/defs_datatypes.mod .
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/leave_myproc.o .
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/timab.o .
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/timein.o .
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/defs_time.o .
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/hdr_io.o .
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/wrtout.o .
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/leave_new.o .
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/print_ij.o .
	 ${FC} -c abinitReader.f90 
	 cp /home/jl/macondo/SRC_ibz/ibzNew/${SUB}/defs_interfaces.mod .
DefaultInput.o:	DefaultInput.f90
		${FC} -c DefaultInput.f90
InitializeDataMod.o:	InitializeDataMod.f90
		${FC} -c InitializeDataMod.f90
NextPassMod.o:	NextPassMod.f90
		${FC} -c NextPassMod.f90
getIRtet.o:	getIRtet.f90
		${FC} -c getIRtet.f90
PrintResultsMod.o:	PrintResultsMod.f90
		${FC} -c PrintResultsMod.f90
clean:		 
	rm -f *.o 
	rm -f *.mod 
	rm -f *~ 
help:
	$(PRINTF) "\t$(MAGENTA)================================================= $(NC)\n "
	 $(ECHO) "  make         -Compila and link "    
	 $(ECHO) "  make help    -Show this info   "    
	 $(ECHO) "  make clean   -clean all *.o *.mod " 
	$(PRINTF) "\t$(MAGENTA)================================================= $(NC)\n "
	$(PRINTF) "\t$(MAGENTA)This Makefile was CREATED by: $(NC) jl  \n\tat: Sun Sep 23 21:46:13 2007 \n "
