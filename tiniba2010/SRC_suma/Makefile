 ## ********************************************
 ## * Warning:                                 
 ## * This Makefile  was generated automatically by:  MakeMakefile2010.PL 
 ## * Don't edit this file,  edit MakeMakefile2010.PL instead. 
 ##  *** ANY CHANGES MADE HERE WILL BE LOST! *** 
 ## ********************************************
 ## CREATED on: 2010-03-16 10:13:43  by USER:  jl 
 ## Centro de Investigaciones en Optica A.C. 
 ## Leon, Guanajuato, Mexico 
 ## This is free software;.There is NO warranty. JL
 ##  
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
	BASENAME = suma


	ifeq	($(PLATAFORM),master)
	NAME=$(BASENAME).xeon
	NAME1=$(BASENAME).master
	NAME2=$(BASENAME).node
	F90=$(COMPILER-XEON)
	OPT = $(FLAGS-XEON)
	WHATPL=XEON
	endif

	ifeq	($(PLATAFORM),itanium01)
	NAME=$(BASENAME).itanium
	NAME1=$(BASENAME).itanium
	NAME2=$(BASENAME).itanium
	F90=$(COMPILER-ITAN)
	OPT = $(FLAGS-ITAN)
	WHATPL=ITAN
	endif

	ifeq	($(PLATAFORM),quad01)
	NAME=$(BASENAME).quad
	NAME1=$(BASENAME).quad
	NAME2=$(BASENAME).quad
	F90=$(COMPILER-QUAD)
	OPT = $(FLAGS-QUAD)
	WHATPL=QUAD
	endif

SRCS =	suma.f

OBJS =	suma.o

$(NAME): $(OBJS)
	$(FC) $(OPT) -o $@ $(OBJS) $(LIBS)
	 rm -f $(OBJS) *.mod *~ *.o 
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
clean:
	 rm -f $(OBJS) *.mod *~ *.o 

help:
	 $(ECHO) "you are compiling :$(WHATPL)  "   
	 $(ECHO) "  make         -Compila and link "    
	 $(ECHO) "  make clean   -clean all *.o *.mod " 
.SUFFIXES: $(SUFFIXES) .f90

.f90.o:
	$(F90) $(F90FLAGS) -c $<

