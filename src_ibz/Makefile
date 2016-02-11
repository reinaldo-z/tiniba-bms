FC=/opt/intel/compilers_and_libraries_2016.1.150/linux/bin/intel64/ifort
FFLAGS=-axCORE-AVX2,-axSSE4.2
ABSUB=abinit_subroutines
ABINITDEP= ${ABSUB}/defs_basis.F90 ${ABSUB}/defs_datatypes.F90 ${ABSUB}/hdr_io.F90 ${ABSUB}/leave_myproc.F90 ${ABSUB}/leave_new.F90  ${ABSUB}/timab.F90 ${ABSUB}/timein.F90 ${ABSUB}/wrtout.F90
ABINITOBS= defs_basis.o defs_datatypes.o hdr_io.o leave_myproc.o leave_new.o  timab.o timein.o wrtout.o
DEPS = Sorting.F90 Global.F90 MyAllocateMod.F90 CommandLineArguments.F90 Symmetries.F90 Grid.F90 3by3matrices.F90 DefaultInput.F90  structFile.F90 abinitReader.F90 InitializeDataMod.F90 checkDimensions.F90 printIRpts.F90 printIRtet.F90 getDiag.F90 getIRtet.F90 NextPassMod.F90 
OBS = Sorting.o Global.o MyAllocateMod.o CommandLineArguments.o Symmetries.o Grid.o 3by3matrices.o DefaultInput.o  structFile.o abinitReader.o InitializeDataMod.o checkDimensions.o printIRpts.o printIRtet.o getDiag.o getIRtet.o NextPassMod.o

all: $(ABINITOBS) $(OBS) ibz clean
$(ABINITOBS): $(ABINITDEPS)
	$(FC) $(FFLAGS) -c $(ABINITDEP)
$(OBS): $(DEPS)
	$(FC) $(FFLAGS) -c $(DEPS)
ibz: IBZ.F90 $(OBS) $(ABINITOBS)
	$(FC) $(FFLAGS) -o ibz IBZ.F90 $(OBS) $(ABINITOBS)
clean:
	rm -f *.o
	rm -f *.mod
	rm -f *~
help:
	$(ECHO) "make         -Compila and link"
	$(ECHO) "make help    -Show this info"
	$(ECHO) "make clean   -clean all *.o *.mod"
