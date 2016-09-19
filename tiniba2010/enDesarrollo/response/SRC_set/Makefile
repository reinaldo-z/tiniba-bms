 ## ********************************************
 ## * Warning:                                 
 ## * This Makefile  was generated automatically by:  MakeMakefile.PL 
 ## * Don't edit this file,  edit MakeMakefile.PL instead. 
 ##  *** ANY CHANGES MADE HERE WILL BE LOST! *** 
 ## ********************************************
 ## CREATED on: 2008-11-22 14:51:24  by USER:  jl 
 ## Centro de Investigaciones en Optica A.C. 
 ## Leon, Guanajuato, Mexico 
 ## This is free software;.There is NO warranty. JL
 ##  
	COMPILER-XEON = /opt/intel/fc/9.0/bin/ifort
	COMPILER-ITAN = /opt/intel/fc/9.0/bin/ifort
	COMPILER-QUAD = /opt/intel/fce/9.1.036/bin/ifort
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
	BASENAME = set


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

SRCS =	ArraysMod.f90 CommandLineArgumentsMod.f90 ConstantsMod.f90 \
	DebugMod.f90 FileControlMod.f90 FileUtilitiesMod.f90 FunctionsMod.f90 \
	InputParametersFileMod.f90 InputParametersMod.f90 \
	IntegrandImChi1Mod.f90 IntegrandsMod.f90 ishg1la.f90 ishg1ll.f90 \
	ishg1ta.f90 ishg1ta_wrong.f90 ishg1tg.f90 ishg1tl.f90 ishg2la.f90 \
	ishg2ll.f90 ishg2ta.f90 ishg2ta_wrong.f90 ishg2tg.f90 ishg2tl.f90 \
	PhysicalConstantsMod.f90 set_input.f90 SpectrumParametersFileMod.f90 \
	SpectrumParametersMod.f90 SymmetryOperationsMod.f90

OBJS =	ArraysMod.o CommandLineArgumentsMod.o ConstantsMod.o DebugMod.o \
	FileControlMod.o FileUtilitiesMod.o FunctionsMod.o \
	InputParametersFileMod.o InputParametersMod.o IntegrandImChi1Mod.o \
	IntegrandsMod.o ishg1la.o ishg1ll.o ishg1ta.o ishg1ta_wrong.o \
	ishg1tg.o ishg1tl.o ishg2la.o ishg2ll.o ishg2ta.o ishg2ta_wrong.o \
	ishg2tg.o ishg2tl.o PhysicalConstantsMod.o set_input.o \
	SpectrumParametersFileMod.o SpectrumParametersMod.o \
	SymmetryOperationsMod.o

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

ArraysMod.o: ConstantsMod.o DebugMod.o InputParametersFileMod.o \
	InputParametersMod.o
CommandLineArgumentsMod.o: DebugMod.o FileUtilitiesMod.o InputParametersMod.o \
	SpectrumParametersMod.o
FileControlMod.o: DebugMod.o InputParametersMod.o IntegrandImChi1Mod.o \
	SpectrumParametersMod.o ishg1la.o ishg1ll.o ishg1ta.o ishg1ta_wrong.o \
	ishg1tg.o ishg1tl.o ishg2la.o ishg2ll.o ishg2ta.o ishg2ta_wrong.o \
	ishg2tg.o ishg2tl.o
FileUtilitiesMod.o: DebugMod.o
FunctionsMod.o: ArraysMod.o ConstantsMod.o InputParametersMod.o \
	PhysicalConstantsMod.o
InputParametersFileMod.o: ConstantsMod.o DebugMod.o InputParametersMod.o
InputParametersMod.o: ConstantsMod.o
IntegrandImChi1Mod.o: ArraysMod.o ConstantsMod.o DebugMod.o \
	InputParametersMod.o PhysicalConstantsMod.o SpectrumParametersMod.o
IntegrandsMod.o: DebugMod.o IntegrandImChi1Mod.o SpectrumParametersMod.o \
	ishg1la.o ishg1ll.o ishg1ta.o ishg1ta_wrong.o ishg1tg.o ishg1tl.o \
	ishg2la.o ishg2ll.o ishg2ta.o ishg2ta_wrong.o ishg2tg.o ishg2tl.o
ishg1la.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg1ll.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg1ta.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg1ta_wrong.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg1tg.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg1tl.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg2la.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg2ll.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg2ta.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg2ta_wrong.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg2tg.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
ishg2tl.o: ArraysMod.o ConstantsMod.o DebugMod.o InputParametersMod.o \
	PhysicalConstantsMod.o SpectrumParametersMod.o
PhysicalConstantsMod.o: ConstantsMod.o
set_input.o: ArraysMod.o CommandLineArgumentsMod.o ConstantsMod.o DebugMod.o \
	FileControlMod.o FileUtilitiesMod.o FunctionsMod.o \
	InputParametersFileMod.o InputParametersMod.o IntegrandsMod.o \
	SpectrumParametersFileMod.o SymmetryOperationsMod.o
SpectrumParametersFileMod.o: SpectrumParametersMod.o
SpectrumParametersMod.o: ConstantsMod.o
SymmetryOperationsMod.o: DebugMod.o InputParametersMod.o \
	SpectrumParametersMod.o
