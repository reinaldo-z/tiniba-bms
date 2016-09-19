#!/usr/bin/perl
  use Cwd;    
  use Env;
  use Term::ANSIColor;
### 07/junio/2006 by JL
### Este MakeMakefileAbintShells trabaja para: AbinitShells 
### y solo para estos archivos NO COPIES A OTROS, NO ES GENERAL
### y esta hecho a fuerza bruta. jl
###
### 16 Marzo 2010 by jl 
### Solo para tiniba2010 
### LAST MODIFICATION :: 16 Marzo 2010 at 13:44 by cabellos 
###===================================================
   $micamino=getcwd;
  ($BasePath, $case) = breakup_dirname($micamino);
   
  open(MAKEFILE, "> Makefile");
  print MAKEFILE " ## ********************************************\n";
  print MAKEFILE " ## * Warning:                                 \n";
  print MAKEFILE " ## * This Makefile  was generated automatically by: ";
  print MAKEFILE " MakeMakefileLocal.PL \n";
  print MAKEFILE " ## * Don't edit this file, ";
  print MAKEFILE " edit MakeMakefileLocal.PL instead. \n";
  print MAKEFILE " ##  *** ANY CHANGES MADE HERE WILL BE LOST! *** \n";
  print MAKEFILE " ## ********************************************\n";
###======= time=======================================
   ($sec,$min,$hour,$mday,$mon,$year,$wday,
   $yday,$isdst)=localtime(time);
   print MAKEFILE " ## CREATED on:";
   printf  MAKEFILE " %4d-%02d-%02d %02d:%02d:%02d ",
   $year+1900,$mon+1,$mday,$hour,$min,$sec;
   print MAKEFILE " by USER:  $USER \n";
   print MAKEFILE " ## Centro de Investigaciones en Optica A.C. \n";
   print MAKEFILE " ## Leon, Guanajuato, Mexico \n";
   print MAKEFILE " ## This is free software;.There is NO warranty. J.L. Cabellos\n";
   print MAKEFILE " ##  \n";

  
###======= Define common macros =======================
   print MAKEFILE "ECHO=\@echo \n";
  # print MAKEFILE "FC = /opt/ifc_v8.1/bin/ifort -O3 \n";
print MAKEFILE "FC = /opt/intel/fc/9.0/bin/ifort -O3 -tpp7 -xW \n";
   ###======= Define common macros =======================
 print MAKEFILE "\tCOMPILER-XEON = /opt/intel/fc/9.0/bin/ifort\n"; 
 print MAKEFILE "\tCOMPILER-ITAN = /opt/intel/fc/9.0/bin/ifort\n";
 print MAKEFILE "\tCOMPILER-QUAD = /opt/intel/fce/10.1.008/bin/ifort\n";
   
 print MAKEFILE "\t   FLAGS-XEON = -O3 -tpp7 -xW \n"; 
#print MAKEFILE "\t   FLAGS-XEON = -O3 -tpp7 -xW -static\n"; 
 print MAKEFILE "\t   FLAGS-ITAN = -O3 -tpp2\n"; 
#print MAKEFILE "\t   FLAGS-ITAN = -O3 -tpp2 -static \n";
 print MAKEFILE "\t   FLAGS-QUAD = -O3\n"; 
#print MAKEFILE "\t   FLAGS-QUAD = -O3 -static\n";
   print MAKEFILE "\n";
   print MAKEFILE "\tCWD=\$\(shell pwd\)\n";
   print MAKEFILE "\tPLATAFORM=\$\(shell hostname\)\n"; 
   print MAKEFILE "\tECHO=\@echo \n";
   print MAKEFILE "\tPRINTF=\@printf \n";
   print MAKEFILE "\tGREEN=\\e\[0;32m\n"; 
   print MAKEFILE "\tMAG=\\e\[0;35m\n"; 
   print MAKEFILE "\tNC=\\e\[0m\n"; 




###====================================================
   print MAKEFILE "ABINITLOC=$micamino/abinit_subroutines \n";  


       if  (@ARGV=~1) { 
          print color 'blue';
	  print "Taking name: ";
          print color 'reset';  
          print color 'green ';
          print "$ARGV[0] \n ";
          print color 'reset';   
                      }       
      # if ((@ARGV=~0)||(@ARGV>=2)) {
      #     @ARGV[0]=$case; 
      #     print color 'blue';
      #	   print "Taking name of your directory :";
      #     print color 'reset';  
      #     print color 'green ';
      #     print "$case \n ";
      #     print color 'reset'; 
      #                             }

     if (($ARGV[0]=~"help")||($ARGV[0]=~"HELP")||($ARGV[0]=~"Help")){
        print " ";
        print color 'red'; 
        print "USAGE: Makefile.pl [namefile] \n\n";
        print "[namefile]=Any name file that you want\n";
        print "[namefile]=empty, take the name : $case \n";
        print "This produce a:  Makefile \n ";
        print color 'reset';
         die " stoping rigth now .." ;
      } 


     
###===================================================

        if ((@ARGV=~0)||(@ARGV>=2)) {
	   my $src_x = 'SRC_';
           $string = $case;
           $first_4char= substr( $string, 0, 4 );  # SRC_
         #  print "$string\n";
         #  print "$first_4char\n";
         #  print "$src_x\n";
          
            if ( $first_4char eq $src_x ) {
                $salida=substr $case, 4;
                @ARGV[0]=$salida; 
             } else {
                @ARGV[0]=$case; 
	    }
       }

    print color 'blue';
         print "Taking basename : ";
           print color 'reset';  
           print color 'green ';
           print "@ARGV[0]\n ";
           print color 'reset';
         print "Output : Makefile\n ";

 print MAKEFILE "\tBASENAME = $ARGV[0]\n\n";
        print MAKEFILE "\n";
#### XEON
#### XEON
#### XEON
        print MAKEFILE "\tifeq\t\(\$\(PLATAFORM\),master\)\n";
        print MAKEFILE "\tNAME=\$\(BASENAME\).xeon\n";
        print MAKEFILE "\tNAME1=\$\(BASENAME\).master\n";
        print MAKEFILE "\tNAME2=\$\(BASENAME\).node\n";
        print MAKEFILE "\tABINITO=abinit_subroutines_node\n";
        print MAKEFILE "OBSFROMABINIT= hdr_io.o wrtout.o leave_new.o leave_myproc.o timab.o timein.o \n";
        print MAKEFILE "\tFC=\$\(COMPILER-XEON\)\n";
        print MAKEFILE "\tOPT = \$\(FLAGS-XEON\)\n";
        print MAKEFILE "\tWHATPL=XEON\n";
        print MAKEFILE "\tendif\n";
        print MAKEFILE "\n";
#### ITANIUM 
#### ITANIUM 
#### ITANIUM 
        print MAKEFILE "\tifeq\t\(\$\(PLATAFORM\),itanium01\)\n";
        print MAKEFILE "\tNAME=\$\(BASENAME\).itanium.NO.IMPLEMENTADO.16.MARZO.2010 BY CABELLOS.11:44\n";
        print MAKEFILE "\tNAME1=\$\(BASENAME\).itanium.NO.IMPLEMENTADO.16.MARZO.2010 BY CABELLOS.11:44\n";
        print MAKEFILE "\tNAME2=\$\(BASENAME\).itanium.NO.IMPLEMENTADO.16.MARZO.2010 BY CABELLOS.11:44\n";
        print MAKEFILE "\tFC=\$\(COMPILER-ITAN\)\n";
        print MAKEFILE "\tOPT = \$\(FLAGS-ITAN\)\n";
        print MAKEFILE "\tWHATPL=ITAN\n";
        print MAKEFILE "\tendif\n";
        print MAKEFILE "\n";
#### QUAD
#### QUAD
#### QUAD 
        print MAKEFILE "\tifeq\t\(\$\(PLATAFORM\),quad01\)\n";
        print MAKEFILE "\tNAME=\$\(BASENAME\).quad\n";
        print MAKEFILE "\tNAME1=\$\(BASENAME\).quad\n";
        print MAKEFILE "\tNAME2=\$\(BASENAME\).quad\n";
        print MAKEFILE "\tABINITO=abinit_subroutines_quad\n";
        print MAKEFILE "OBSFROMABINIT= hdr_io.o wrtout.o leave_new.o leave_myproc.o timab.o  timein.o defs_time.o print_ij.o\n";
        print MAKEFILE "\tFC=\$\(COMPILER-QUAD\)\n";
        print MAKEFILE "\tOPT = \$\(FLAGS-QUAD\)\n";
        print MAKEFILE "\tWHATPL=QUAD\n";
        print MAKEFILE "\tendif\n";
        print MAKEFILE "\n";





####=====================================================      
  print MAKEFILE "OBS = \tSorting.o Global.o MyAllocateMod.o CommandLineArguments.o Symmetries.o Grid.o 3by3matrices.o DefaultInput.o  structFile.o abinitReader.o InitializeDataMod.o checkDimensions.o printIRpts.o printIRtet.o getDiag.o getIRtet.o NextPassMod.o \n\n"; 
#print MAKEFILE "\$(NAME): \$(OBJS)\n";
print MAKEFILE "\$(NAME):\tIBZ.f90 \$\{OBS\} \n";
#print MAKEFILE "$ARGV[0]:\tIBZ.f90 \$\{OBS\} \n";
print MAKEFILE "\t\$\{FC\} -o \$(NAME) IBZ.f90 \$\{OBS\}  \$\{OBSFROMABINIT\} \n \n";
#print MAKEFILE "\t\$\{FC\} -o $ARGV[0] IBZ.f90 \$\{OBS\}  \$\{OBSFROMABINIT\} \n ";
print MAKEFILE "\t@( if [ \$(PLATAFORM) == \"master\" ]; then \\\n";
print MAKEFILE "\tcp -v \$(NAME)  \$(NAME1); \\\n";
print MAKEFILE "\tcp -v \$(NAME)  \$(NAME2) ;\\\n";
print MAKEFILE "\tfi )\n";
print MAKEFILE "\t \$(PRINTF) \" \\n \" \n";
print MAKEFILE "\t \$(PRINTF) \" \\t \$(MAG)***********************************\$(NC)\\n \" \n";
print MAKEFILE "\t \$(PRINTF) \" \\t  Compiled : \$\(WHATPL\)\\n \" \n";
print MAKEFILE "\t \$(PRINTF) \" \\t  Output   : \$(GREEN)\$\(NAME\) \$(NC)   \\n \" \n";
print MAKEFILE "\t @( if [ \$(PLATAFORM) == \"master\" ]; then \\\n";
#print MAKEFILE "\t \$(PRINTF) \" \\t  Output   : \$(GREEN)\$\(NAME\) \$(NC)   \\n \" \n";
print MAKEFILE "\t   cp -v \$(NAME)  \$(NAME1); \\\n";
print MAKEFILE "\t   cp -v \$(NAME)  \$(NAME2) ;\\\n";
print MAKEFILE "\t    fi )\n";
print MAKEFILE "\t \$(PRINTF) \" \\t \$(MAG)***********************************\$(NC)\\n \" \n";
print MAKEFILE "\trm -f *.o \n";
print MAKEFILE "\trm -f *.mod \n";
print MAKEFILE "\trm -f *~ \n";

print MAKEFILE "MyAllocateMod.o:\tMyAllocateMod.f90 \n";
print MAKEFILE "\t\t\$\{FC\} -c MyAllocateMod.f90 \n";
print MAKEFILE "Sorting.o:\tSorting.f90 \n";
print MAKEFILE "\t\t\$\{FC\} -c Sorting.f90 \n";
print MAKEFILE "Global.o:\tGlobal.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c Global.f90 \n";
print MAKEFILE "CommandLineArguments.o:\t\tCommandLineArguments.f90 \n";
print MAKEFILE "\t\t\$\{FC\} -c CommandLineArguments.f90 \n";
print MAKEFILE "Symmetries.o:\tSymmetries.f90 \n";
print MAKEFILE "\t\t\$\{FC\} -c Symmetries.f90   \n";
print MAKEFILE "Grid.o:\t\tGrid.f90 \n";
print MAKEFILE "\t\t\$\{FC\} -c Grid.f90 \n";
print MAKEFILE "structFile.o:\tstructFile.f90 \n";
print MAKEFILE "\t\t\$\{FC\} -c structFile.f90 \n";
print MAKEFILE "abinitReader.o:\tabinitReader.f90 \n";
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/defs_basis.mod .\n";
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/defs_datatypes.mod .\n";            
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/hdr_io.o .\n";
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/wrtout.o .\n";
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/leave_new.o .\n";
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/leave_myproc.o .\n";
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/timab.o .\n";
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/timein.o .\n";
print MAKEFILE "\t@( if [ \$(PLATAFORM) == \"quad01\" ]; then \\\n";
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/defs_time.o . ;\\\n";
print MAKEFILE "\t cp $micamino\/\$(ABINITO)\/print_ij.o . ;\\\n";
print MAKEFILE "\t    fi )\n";
##
#print MAKEFILE "\t cp $micamino\/abinit_subroutines\/defs_basis.mod .\n";
#print MAKEFILE "\t cp $micamino\/abinit_subroutines\/defs_datatypes.mod .\n";            
#print MAKEFILE "\t cp $micamino\/abinit_subroutines\/hdr_io.o .\n";
#print MAKEFILE "\t cp $micamino\/abinit_subroutines\/wrtout.o .\n";
#print MAKEFILE "\t cp $micamino\/abinit_subroutines\/leave_new.o .\n";
#print MAKEFILE "\t cp $micamino\/abinit_subroutines\/leave_myproc.o .\n";
#print MAKEFILE "\t cp $micamino\/abinit_subroutines\/timab.o .\n";
#print MAKEFILE "\t cp $micamino\/abinit_subroutines\/timein.o .\n"; print_ij.o
##
print MAKEFILE "\t \$\{FC\} -c abinitReader.f90 \n";
print MAKEFILE "DefaultInput.o:\t\tDefaultInput.f90 \n";
print MAKEFILE "\t \$\{FC\} -c DefaultInput.f90 \n";
print MAKEFILE "InitializeDataMod.o:\t InitializeDataMod.f90 \n";
print MAKEFILE "\t \$\{FC\} -c InitializeDataMod.f90  \n";
print MAKEFILE "NextPassMod.o:\t\tNextPassMod.f90 \n";
print MAKEFILE "\t\$\{FC\} -c NextPassMod.f90 \n";
print MAKEFILE "3by3matrices.o:\t\t 3by3matrices.f90 \n";
print MAKEFILE "\t \$\{FC\} -c 3by3matrices.f90 \n";
print MAKEFILE "checkDimensions.o:\tcheckDimensions.f90 \n";
print MAKEFILE "\t \$\{FC\} -c checkDimensions.f90 \n";
print MAKEFILE "printIRpts.o:\t\tprintIRpts.f90 \n";
print MAKEFILE "\t \$\{FC\} -c printIRpts.f90 \n";
print MAKEFILE "printIRtet.o:\t\tprintIRtet.f90 \n";
print MAKEFILE "\t \$\{FC\} -c printIRtet.f90 \n";
print MAKEFILE "getDiag.o:\t\t getDiag.f90 \n";
print MAKEFILE "\t \$\{FC\} -c getDiag.f90 \n";
print MAKEFILE "getIRtet.o:\t\t getIRtet.f90 \n";
print MAKEFILE "\t \$\{FC\} -c getIRtet.f90 \n";
# CLEAN 
print MAKEFILE "clean:\t\t \n";
print MAKEFILE "\trm -f *.o \n";
print MAKEFILE "\trm -f *.mod \n";
print MAKEFILE "\trm -f *~ \n";
# make update
print MAKEFILE "update:\n";
#print MAKEFILE "\t rm -vf  \/home\/$USER\/AbinitShells\/bin\/$ARGV[0] \n";
print MAKEFILE "\t cp -vf  $micamino\/$ARGV[0] \/home\/$USER\/AbinitShells\/bin\/\n";
print MAKEFILE "\t \$(ECHO) \" *********************************** \" \>\> README \n";
print MAKEFILE "\t \$(ECHO) \"UPDATE :\/home\/$USER\/AbinitShells\/bin\/$ARGV[0]  on\"\>\> README \n";
print MAKEFILE "\t date \>\> README \n";
print MAKEFILE "\t \$(ECHO) \" *********************************** \"\>\> README \n";
#CANCEL
print MAKEFILE "cancel:\n";
print MAKEFILE "\t rm -vf  \/home\/$USER\/AbinitShells\/bin\/$ARGV[0] \n";
print MAKEFILE "\t \$(ECHO) \" *********************************** \"\>\> README \n";
print MAKEFILE "\t \$(ECHO) \"CANCEL  :\/home\/$USER\/AbinitShells\/bin\/$ARGV[0]  on\" \>\> README \n";
print MAKEFILE "\t date \>\> README \n";
print MAKEFILE "\t \$(ECHO) \" *********************************** \" \>\> README \n";
#help 
# make help
 print MAKEFILE "help:\n";
 print MAKEFILE "\t \$(ECHO) \"  make         -Compila and link \"    \n";
 print MAKEFILE "\t \$(ECHO) \"  make help    -Show this info   \"    \n";
 print MAKEFILE "\t \$(ECHO) \"  make clean   -clean all *.o *.mod \" \n";
 print MAKEFILE "\t \$(ECHO) \"  make update  -update: \/home\/$USER\/AbinitShells\/bin\/$ARGV[0] \" \n";
 print MAKEFILE "\t \$(ECHO) \"  make cancel  -cancel :\/home\/$USER\/AbinitShells\/bin\/$ARGV[0] \" \n";

## 07/junio/2006 Cabellos 












 

         






    sub breakup_dirname {
#####################
   # break-up input path into a base and present directory
   $directory = $_[0];
   my @tmpArray = split(/\//,$directory);
   my $case = pop(@tmpArray);
   my $basePath = join("/", @tmpArray);
   return($basePath, $case);}
