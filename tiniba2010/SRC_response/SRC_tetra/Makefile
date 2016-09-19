 ## ********************************************
 ## * Warning:                                 
 ## * This Makefile  was generated automatically by:  MakeMakefile.PL 
 ## * Don't edit this file,  edit MakeMakefile.PL instead. 
 ##  *** ANY CHANGES MADE HERE WILL BE LOST! *** 
 ## ********************************************
 ## CREATED on: 2010-04-07 09:47:20  by USER:  jl 
 ## Centro de Investigaciones en Optica A.C. 
 ## Leon, Guanajuato, Mexico 
 ## This is free software;.There is NO warranty. JL
 ##  
	COMPILER-XEON = /opt/intel/fc/9.0/bin/ifort
	COMPILER-ITAN = /opt/intel/fc/9.0/bin/ifort
	COMPILER-QUAD = /opt/intel//fc/10.1.008/bin/ifort
	   FLAGS-XEON = -O3 -tpp7 -xW 
	   FLAGS-ITAN = -O3 -tpp2
	   FLAGS-QUAD = -O3

	CWD=$(shell pwd)
	PLATAFORM=$(shell hostname)
	ECHO=@echo 
	PRINTF=@printf 
	GREEN=\e[;32m
	MAG=\e[;35m
	NC=\e[0m
	BASENAME = tetra


	ifeq	($(PLATAFORM),master)
	NAME=$(BASENAME).xeon
	F90=$(COMPILER-XEON)
	OPT = $(FLAGS-XEON)
	WHATPL=XEON
	endif

	ifeq	($(PLATAFORM),itanium01)
	NAME=$(BASENAME).itan
	F90=$(COMPILER-ITAN)
	OPT = $(FLAGS-ITAN)
	WHATPL=ITAN
	endif

	ifeq	($(PLATAFORM),quad01)
	NAME=$(BASENAME).quad
	F90=$(COMPILER-QUAD)
	OPT = $(FLAGS-QUAD)
	WHATPL=QUAD
	endif

SRCS =	ConstantsMod.f90 DebugMod.f90 EnergyMeshMod.f90 \
	InputParametersFileMod.f90 InputParametersMod.f90 \
	LoadIntegrandMod.f90 ReadEnergiesMod.f90 SortMod.f90 tetra_method.f90 \
	TetrahedraMod.f90 TransitionsMod.f90

OBJS =	ConstantsMod.o DebugMod.o EnergyMeshMod.o InputParametersFileMod.o \
	InputParametersMod.o LoadIntegrandMod.o ReadEnergiesMod.o SortMod.o \
	tetra_method.o TetrahedraMod.o TransitionsMod.o

$(NAME): $(OBJS)
	$(F90) $(OPT) -o $@ $(OBJS) $(LIBS)
	 rm -f $(OBJS) *.mod *~ *.o 

	 cp $(NAME) ../

	 $(PRINTF) " \n " 
	 $(PRINTF) " \t $(MAG)***********************************$(NC)\n " 
	 $(PRINTF) " \t  Compiled : $(WHATPL)\n " 
	 $(PRINTF) " \t  Output   :../$(GREEN)$(NAME) $(NC)   \n " 
	 $(PRINTF) " \t $(MAG)***********************************$(NC)\n " 
clean:
	 rm -f $(OBJS) *.mod *~ *.o 

help:
	 $(ECHO) "you are compiling :$(WHATPL)  "   
	 $(ECHO) "  make         -Compila and link "    
	 $(ECHO) "  make clean   -clean all *.o *.mod " 
.SUFFIXES: $(SUFFIXES) .f90

.f90.o:
	$(F90) $(F90FLAGS) -c $<

EnergyMeshMod.o: ConstantsMod.o InputParametersMod.o
InputParametersFileMod.o: ConstantsMod.o DebugMod.o InputParametersMod.o
InputParametersMod.o: ConstantsMod.o
LoadIntegrandMod.o: ConstantsMod.o InputParametersMod.o TransitionsMod.o
ReadEnergiesMod.o: ConstantsMod.o InputParametersFileMod.o \
	InputParametersMod.o TransitionsMod.o
SortMod.o: ConstantsMod.o
tetra_method.o: ConstantsMod.o EnergyMeshMod.o InputParametersFileMod.o \
	InputParametersMod.o LoadIntegrandMod.o ReadEnergiesMod.o SortMod.o \
	TetrahedraMod.o TransitionsMod.o
TetrahedraMod.o: ConstantsMod.o InputParametersFileMod.o InputParametersMod.o
TransitionsMod.o: InputParametersMod.o
