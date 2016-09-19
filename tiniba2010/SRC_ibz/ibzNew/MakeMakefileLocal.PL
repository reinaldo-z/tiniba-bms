#!/usr/bin/perl
  use Cwd;    
  use Env;
  use Term::ANSIColor;
  use File::Basename;

### solo para estos archivos NO COPIES A OTROS, NO ES GENERAL
### y esta hecho a fuerza bruta. 
### jLcabellos /13 Septiembre 2007 at 21:31
###===================================================
   $micamino=getcwd;
  ($BasePath, $case) = breakup_dirname($micamino);
   
   #($miname) = fileparse($0)
($QUIENSOY) = fileparse($0);
    
  open(MAKEFILE, "> Makefile");
  print MAKEFILE " ## ********************************************\n";
  print MAKEFILE " ## * Warning:                                 \n";
  print MAKEFILE " ## * This Makefile  was generated automatically by: ";
  print MAKEFILE " $QUIENSOY \n";
  print MAKEFILE " ## * Don't edit this file, ";
  print MAKEFILE " edit $QUIENSOY instead. \n";
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
   print MAKEFILE " ## $USER :\n";
   print MAKEFILE " ## This is free software;.There is NO warranty.\n";
   print MAKEFILE " ##  J.L. Cabellos\n";
   print MAKEFILE " ##  \n";

  
###======= Define common macros jl=======================
   print MAKEFILE "\n";
   print MAKEFILE "\tECHO=\@echo \n";
   print MAKEFILE "\tPRINTF=\@printf \n";
   print MAKEFILE "\tCWD=\$(shell pwd)\n";
   print MAKEFILE "\tPLATAFORM=\$(shell hostname)\n";
   print MAKEFILE "\tRED=\\e\[0;31m\n";
   print MAKEFILE "\tGREEN=\\e\[0;32m\n";
   print MAKEFILE "\tMAGENTA=\\e\[0;35m\n";
   print MAKEFILE "\tNC=\\e\[0m\n";
   print MAKEFILE "\n";
   #######
   
   print MAKEFILE "\tifeq (\$(PLATAFORM),master)\n"; 
   print MAKEFILE "\t FC=/opt/intel/fc/9.0/bin/ifort -O3 -tpp7 -xW -static \n";
   print MAKEFILE "\t OPT= -O3 -tpp7 -xW -static\n";
   print MAKEFILE "\t NAME=ibz.xeon\n";
   print MAKEFILE "\t WHATPL=XEON\n";
   print MAKEFILE "\t SUB=abinit_subrotinesXEON\n";
   
   print MAKEFILE "\tendif\n"; 
   #######
   #######
   print MAKEFILE "\n";
   print MAKEFILE "\tifeq (\$(PLATAFORM),itanium01)\n"; 
   #print MAKEFILE "\t\t##NO YET IMPLEMENTED   I NEED ... CABELLOS 13 SEP 2007\n";
  print MAKEFILE "\t FC=/opt/intel/fc/9.0/bin/ifort -O3 -static -tpp2\n";
  print MAKEFILE "\t OPT= -O3 -static -tpp2\n";
  print MAKEFILE "\t NAME=ibz.itan\n";
  print MAKEFILE "\t WHATPL=Itanium\n";
  print MAKEFILE "\t SUB=abinit_subrotinesITAN\n";
   print MAKEFILE "\tendif\n"; 
   #######
   #######
   print MAKEFILE "\n";
   print MAKEFILE "\tifeq (\$(PLATAFORM),quad01)\n"; 
   print MAKEFILE "\t FC =/opt/intel/fce/9.1.036/bin/ifort -O3 -static\n";
   print MAKEFILE "\t OPT = -O3 -static\n";
   print MAKEFILE "\t NAME=ibz.quad\n";
   print MAKEFILE "\t SUB=abinit_subrotinesQUAD\n";
   print MAKEFILE "\t WHATPL=Quad\n";
   print MAKEFILE "\tendif\n"; 
   #######
   
   print MAKEFILE "\n";

 
###====================================================
print MAKEFILE "ABINITLOC=$micamino/\$\{SUB\}\n";  
print MAKEFILE "OBSFROMABINIT= hdr_io.o wrtout.o leave_new.o leave_myproc.o timab.o timein.o defs_time.o  print_ij.o\n";



       if  (@ARGV=~1) { 
          print color 'blue';
	  print "Taking name: ";
          print color 'reset';  
          print color 'green ';
          print "$ARGV[0] \n ";
          print color 'reset';   
                      }       
       if ((@ARGV=~0)||(@ARGV>=2)) {
           @ARGV[0]=$case; 
           print "\n";
           print "\tOutput:";
           #print color 'green';
           print " Makefile\n";
	   #print "Taking name of your directory :";
           #print color 'reset';
           print "\n";  
           #print color 'green ';
           #print "$case \n ";
           #print "ibz \n ";
           #print color 'reset'; 
                                   }
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

####=====================================================       
print MAKEFILE "OBS =\tConstantsMod.o DebugMod.o UtilitiesMod.o  MathMod.o  SortingMod.o LatticeMod.o MyAllocateMod.o CommandLineArgumentsMod.o SymmetriesMod.o GridMod.o DefaultInput.o structFile.o abinitReader.o InitializeDataMod.o NextPassMod.o getIRtet.o PrintResultsMod.o\n";


#OBS = ConstantsMod.o \
#      DebugMod.o \
#      UtilitiesMod.o \
#      MathMod.o \
#      SortingMod.o \
#      LatticeMod.o \
#      MyAllocateMod.o \
#      CommandLineArgumentsMod.o \
#      SymmetriesMod.o \
#      GridMod.o \
#      DefaultInput.o \
#      structFile.o \
#      abinitReader.o \
#      InitializeDataMod.o \
#      NextPassMod.o \
#      getIRtet.o \
#      PrintResultsMod.o




#ConstantsMod.f90
#DebugMod.f90
#UtilitiesMod.f90
#MathMod.f90
#SortingMod.f90
#LatticeMod.f90
#MyAllocateMod.f90
#CommandLineArgumentsMod.f90
#SymmetriesMod.f90
#GridMod.f90
#structFile.f90
#DefaultInput.f90
#InitializeDataMod.f90
#NextPassMod.f90
#getIRtet.f90
#PrintResultsMod.f90


print MAKEFILE "\$\{NAME\}:\tIBZ.f90 \$\{OBS\} \n";
print MAKEFILE "\t\$\{FC\} -o \$\{NAME\}  IBZ.f90 \$\{OBS\}  \$\{OBSFROMABINIT\}\n";
print MAKEFILE "\t\$(PRINTF) \"\\t\$(MAGENTA)============ \$(NC)\\n \"\n";
print MAKEFILE "\t\$(PRINTF) \"\\tCheck if there is a file output:\$(GREEN) \$\{NAME\}  \$(NC)\\n \"\n";
print MAKEFILE "\t\$(PRINTF) \"\\t\$(MAGENTA)============ \$(NC)\\n \"\n";
#$(PRINTF) "\t$(GREEN)==========$(NC)\n"
print MAKEFILE "ConstantsMod.o:\tConstantsMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c  ConstantsMod.f90\n";
print MAKEFILE "DebugMod.o:\tDebugMod.f90 \n";
print MAKEFILE "\t\t\$\{FC\} -c  DebugMod.f90\n";
print MAKEFILE "UtilitiesMod.o:\tUtilitiesMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c UtilitiesMod.f90 \n";

print MAKEFILE "MathMod.o:\tMathMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c MathMod.f90\n";

print MAKEFILE "SortingMod.o:\tSortingMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c SortingMod.f90\n";


print MAKEFILE "LatticeMod.o:\tLatticeMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c LatticeMod.f90\n";


print MAKEFILE "MyAllocateMod.o:\tMyAllocateMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c MyAllocateMod.f90 \n";


print MAKEFILE "CommandLineArgumentsMod.o:\tCommandLineArgumentsMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c CommandLineArgumentsMod.f90\n";


print MAKEFILE "SymmetriesMod.o:\tSymmetriesMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c SymmetriesMod.f90\n";


print MAKEFILE "GridMod.o:\tGridMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c GridMod.f90 \n";

print MAKEFILE "structFile.o:\tstructFile.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c structFile.f90\n";

####
print MAKEFILE "abinitReader.o:\tabinitReader.f90\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/defs_basis.mod .\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/defs_datatypes.mod .\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/leave_myproc.o .\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/timab.o .\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/timein.o .\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/defs_time.o .\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/hdr_io.o .\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/wrtout.o .\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/leave_new.o .\n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/print_ij.o .\n";
print MAKEFILE "\t \$\{FC\} -c abinitReader.f90 \n";
print MAKEFILE "\t cp $micamino\/\$\{SUB\}\/defs_interfaces.mod .\n";


print MAKEFILE "DefaultInput.o:\tDefaultInput.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c DefaultInput.f90\n";

print MAKEFILE "InitializeDataMod.o:\tInitializeDataMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c InitializeDataMod.f90\n";

print MAKEFILE "NextPassMod.o:\tNextPassMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c NextPassMod.f90\n";

print MAKEFILE "getIRtet.o:\tgetIRtet.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c getIRtet.f90\n";

print MAKEFILE "PrintResultsMod.o:\tPrintResultsMod.f90\n";
print MAKEFILE "\t\t\$\{FC\} -c PrintResultsMod.f90\n";

#CLEAN 
my $now = localtime time;
print MAKEFILE "clean:\t\t \n";
print MAKEFILE "\trm -f *.o \n";
print MAKEFILE "\trm -f *.mod \n";
print MAKEFILE "\trm -f *~ \n";
#print MAKEFILE "\t\$(PRINTF) \"\\t\$(MAGENTA)This Makefile was CREATED by: \$(NC) $USER  \\n\\tat: $now \\n \"\n";


#$@#$@#!@#$#@$#@$!#@$
# make help
 print MAKEFILE "help:\n";
print MAKEFILE "\t\$(PRINTF) \"\\t\$(MAGENTA)================================================= \$(NC)\\n \"\n";
 print MAKEFILE "\t \$(ECHO) \"  make         -Compila and link \"    \n";
 print MAKEFILE "\t \$(ECHO) \"  make help    -Show this info   \"    \n";
 print MAKEFILE "\t \$(ECHO) \"  make clean   -clean all *.o *.mod \" \n";
 print MAKEFILE "\t\$(PRINTF) \"\\t\$(MAGENTA)================================================= \$(NC)\\n \"\n";
#print MAKEFILE "\t\$(PRINTF) \"\\t\$(MAGENTA)This Makefile was CREATED by: \$(NC) $USER \\n \"\n";
 
 #print "It is now $now\n";

print MAKEFILE "\t\$(PRINTF) \"\\t\$(MAGENTA)This Makefile was CREATED by: \$(NC) $USER  \\n\\tat: $now \\n \"\n";

# print MAKEFILE "\t \$(ECHO) \"  by capelli  \" \n";

## 07/junio/2006 Cabellos 
## 13/Septiembre/2007 Cabellos ultima modificacion : 00:08hrs 












 

         






    sub breakup_dirname {
#####################
   # break-up input path into a base and present directory
   $directory = $_[0];
   my @tmpArray = split(/\//,$directory);
   my $case = pop(@tmpArray);
   my $basePath = join("/", @tmpArray);
   return($basePath, $case);}
