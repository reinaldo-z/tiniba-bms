#!/usr/bin/perl -w
use strict;
use Cwd;     # provides getcwd
use File::Basename;
use File::Copy;

my $debug = 0;
##################################################################
###############  Test command line argument ######################
##################################################################
if (@ARGV!=3) {
    ARGVerror();
}
my $klist_file = $ARGV[0];
my $N = $ARGV[1];
my $Nlayer = $ARGV[2];
my @arrl = (1 .. $Nlayer);
my @arr = (1 .. $N);
#print "Got command-line arguments \n" if $debug;
##################################################################
##################################################################
################ Get current path and directory ##################
##################################################################
my $directory = getcwd;              # gets current path
my ($basePath, $case) = breakup_dirname($directory);
print "\n" if $debug;
print "Determined directory to be: $directory \n" if $debug;
print "Determined case to be: $case \n" if $debug;
print "Determined basepath to be: $basePath \n" if $debug;
print "\n" if $debug;
##################################################################
########################################################################
######################## make JOBS directory ###########################
########################################################################
my $jobdir = $directory.'/JOBS';
if (-d $jobdir) {
   print "Found directory $jobdir \n";
} else {
   print "Making directory $jobdir \.\.\. ";
   mkdir("$jobdir", 0777) || die "cannot mkdir $jobdir: $!";
   print "  MADE \n";
}
##################################################################
############# count number of lines in kpoint file ###############
##################################################################
my $numlines = linecount($klist_file);
print "Found $numlines lines in $klist_file.\n" if $debug;
##################################################################
##################################################################
############## make script to combine output files ###############
##################################################################
my $outfile = $jobdir.'/'."concatenatefiles.pl";
open( PL, ">$outfile") or
    die "Could not open file $outfile :$!";

print PL <<ENDOFFILE;
\#\!/usr/bin/perl
## gets arguments
\$opt1=\$ARGV[0];
\$opt2=\$ARGV[1];
\$spin=\$ARGV[2];
\$count = 0;
\@arr = (1 .. $N);
\@arrl = (1 .. $Nlayer);
\$Nk = $numlines;
##
########### Energy
if ( ( ( \$opt1 == 0 ) && ( \$opt2 == 1 ) ) || ( ( \$opt1 == 0 ) && ( \$opt2 == 2 ) ) 
|| ( ( \$opt1 == 1 )  ) || ( ( \$opt1 == 3 ) && ( \$opt2 == 1 ) ) )
{
   if ( \$opt2 == 10 )
   {
      print "concatenating energies for option: \$opt1","\\n";
   }
   else
   {
      print "concatenating energies for option: \$opt1 \$opt2","\\n";
   }
   \$outfile = "$directory\/energy.d";
   open (OUTF, ">\$outfile");
   foreach \$i (\@arr) {
   \$infile = "$directory\/$case\_\$i/energy.d";
   open( FL, "<\$infile");
   \@filearr = <FL>;
   close(FL);
   foreach (\@filearr) {
     \@words = split;
     \$count = \$count + 1;
     \$number = \$count/100;
     if (\$number == int(\$number)) {
        print "\$count", "\\n";
     }
     \$words[0] = \$count;
     \$_ = join(" ", \@words);
     print OUTF \$_, "\\n";
     }
   }
   close(OUTF);
}
#########################pmn
if ( 
      (( \$opt1 == 0 ) && ( \$opt2 == 2 ) )
      || ( \$opt1 == 1 ) 
      || ( ( \$opt1 == 3 ) && ( \$opt2 == 1 ) )
   )
{
   if ( \$opt2 == 10 )
   {
      print "concatenating pmn for option: \$opt1","\\n";
   }
   else
   {
      print "concatenating pmn for option: \$opt1 \$opt2","\\n";
   }
   ## Loop for pmn
   foreach \$mn ("pmn.d") 
   {
      \$outfile = "$directory/\$mn";
      open( OUTF, ">\$outfile") or die;
      foreach \$i (\@arr) 
      {
        \$infile = "$directory\/$case\_\$i/\$mn";
        open( FL, "<\$infile") or die;
        while (<FL>) 
        {
           print OUTF \$_;
        }
        close(FL);
      }
   }
   close( OUTF );
}
###########################spinmn
if ( 
     (
        ( \$opt1 == 1 ) ||(( \$opt1 == 3 )&&( \$opt2 == 1 ))||(( \$opt1 == 3 )&&( \$opt2 == 0 ))
     )&&( \$spin == 2 )
   )
{
   if ( \$opt2 == 10 )
   {
      print "concatenating spinmn for option: \$opt1","\\n";
   } 
   else
   {
      print "concatenating spinmn for option: \$opt1 \$opt2","\\n";
   }
   ## Loop for spinmn
   foreach \$mn ("spinmn.d") 
   {
      \$outfile = "$directory/\$mn";
      open( OUTF, ">\$outfile") or die;
      foreach \$i (\@arr) 
      {
         \$infile = "$directory\/$case\_\$i/\$mn";
         open( FL, "<\$infile") or die;
         while (<FL>) 
         {
             print OUTF \$_;
         }
         close(FL);
      }
   } 
   close( OUTF );
##
}
############################csmnd
if (( \$opt1 == 1 ) && ( \$spin == 2 ))
{
   if ( \$opt2 == 10 )
   {
      print "concatenating csmnd for option: \$opt1","\\n";
   }
   else
   {
      print "concatenating csmnd for option: \$opt1 \$opt2","\\n";
   }
   foreach \$L (\@arrl) 
   {
      foreach \$mn ("csmnd_") 
      {
	 \$outfile = "$directory/\$mn\$Nk\\_\$L";
	 open( OUTF, ">\$outfile") or die;
	 foreach \$i (\@arr) 
         {
	    \$infile = "$directory\/$case\_\$i/\$mn\$L";
	    open( FL, "<\$infile") or die;
	    while (<FL>) 
            {
	       print OUTF \$_;
	    }
	    close(FL);
	 }
      }
   }
   close( OUTF );   
}


############################cpmn
if ( \$opt1 == 1 )
{
   if ( \$opt2 == 10 )
   {
      print "concatenating cpmn for option: \$opt1","\\n";
   }
   else
   {
      print "concatenating cpmn for option: \$opt1 \$opt2","\\n";
   }
   ## Loop for layer
   foreach \$L (\@arrl) 
   {
      foreach \$mn ("cpmnd_") 
      {
	 \$outfile = "$directory/\$mn\$Nk\\_\$L";
	 open( OUTF, ">\$outfile") or die;
	 foreach \$i (\@arr) 
         {
	    \$infile = "$directory\/$case\_\$i/\$mn\$L";
	    open( FL, "<\$infile") or die;
	    while (<FL>) 
            {
	       print OUTF \$_;
	    }
	    close(FL);
	 }
      }
   }
   close( OUTF );
}

############################cSmnd
if (
      (
         ( \$opt1 == 1 )|| ( \$opt1 == 4 )
      ) && ( \$spin == 2 )
   )
{
   if ( \$opt2 == 10 )
   {
      print "concatenating  cSmmd for option: \$opt1","\\n";
   }
   else
   {
      print "concatenating  cSmmd for option: \$opt1 \$opt2","\\n";
   }
   foreach \$L (\@arrl) 
   {
      foreach \$mn ("cSmmd_") 
      {
       \$outfile = "$directory/\$mn\$Nk\\_\$L";
	 open( OUTF, ">\$outfile") or die;
	 foreach \$i (\@arr) 
         {
	    \$infile = "$directory\/$case\_\$i/\$mn\$L";
	    open( FL, "<\$infile") or die;
	    while (<FL>) 
            {
	       print OUTF \$_;
	    }
	    close(FL);
	 }
      }
   }
   close( OUTF );
}
############################
############################


ENDOFFILE
close(PL);
chmod( 0754, $outfile) or
    die "Could not chmod $outfile :$!";
##################################################################

########################## SUBROUTINES ###########################
#####################
sub breakup_dirname {
#####################
   # break-up input path into a base and present directory 
   $directory = $_[0];
   my @tmpArray = split(/\//,$directory);
   my $case = pop(@tmpArray);
   my $basePath = join("/", @tmpArray);
   return($basePath, $case);
}
#################################################################
###############
sub ARGVerror {
###############
    print "Requires three arguments.\n";
    print "Argument 1: the klist file\n";
    print "Argument 2: the number of CPUs you want ".
          "klist split into\n";
    print "Argument 3: the number of Layers\n";
    die;
}
###############
###############
sub linecount {
###############
    my $filename = $_[0];
    my $cnt;
    open(FH, "<$filename") or 
        die "Couldn't open $filename: $!";
    $cnt++ while <FH>;
    close FH;
    return $cnt;
}
###############
