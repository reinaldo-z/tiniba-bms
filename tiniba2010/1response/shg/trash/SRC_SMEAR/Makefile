 ## ********************************************
 ## * Warning:                                 
 ## * This Makefile  was generated automatically by:  MakeMakefile.PL 
 ## * Don't edit this file,  edit MakeMakefile.PL instead. 
 ##  *** ANY CHANGES MADE HERE WILL BE LOST! *** 
 ## ********************************************
 ## CREATED on: 2007-11-27 01:03:47  by USER:  jl 
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
	GREEN=\e[;32m
	MAG=\e[;35m
	NC=\e[0m
	BASENAME = smear


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

SRCS =	smear2.f90

OBJS =	smear2.o

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

smear2.o: smear2.o
