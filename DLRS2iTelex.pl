#!/usr/bin/perl -w

use strict;
use warnings;
use DateTime;
use Text::Wrap;
use Device::SerialPort;


my $dlrs_dir = "/home/itelex/dlrs";
my $itelex_port = "/dev/iTelex";
my $itelex_extension = 05;
my $linewidth = 68;

$Text::Wrap::columns = $linewidth;

$| = 1;

# Open file with current Deutschlandrundspruch by DARC

my $dt = DateTime->now;
my $year = $dt->year;
my $week = $dt->week_number;

my $file = $dlrs_dir."/dlrs".$year.$week.".txt";

open(my $ifh, '<', $file) # always use a variable here containing filename
   or die "Unable to open file $file, $!";

$file =~ s/\.txt/_wrapped.txt/;

open(my $ofh, '>', $file) # always use a variable here containing filename
   or die "Unable to open file $file, $!";

while (<$ifh>) {
   my $line = $_;

   # Do some character replacement for several characters
   # the telex machine cannot print
   $line =~ s/ä/ae/g;
   $line =~ s/Ä/Ae/g;
   $line =~ s/ö/oe/g;
   $line =~ s/Ö/Oe/g;
   $line =~ s/ü/ue/g;
   $line =~ s/Ü/Ue/g;
   $line =~ s/ß/ss/g;
   $line =~ s/@/(at)/g;
   $line =~ s/±/+-/g;
   $line =~ s/"/''/g;
   $line =~ s/\[/(/g;
   $line =~ s/\]/)/g;
   chomp($line);
   if (length($line) > $linewidth) {
      print $ofh wrap('', '', $line) . "\n";
   } else {
      print $ofh $line."\n";
   }
}

close ($ifh);
close ($ofh);

# Open iTelex Device
my $port = Device::SerialPort->new($itelex_port)
   or die "Unable to open port: $itelex_port, $!";

$port->baudrate(9600);
$port->databits(8);
$port->parity("none");
$port->stopbits(1);

# Dial iTelex extension
$port->write("\x1");
sleep(1);

$port->write("05");
sleep(1);

open($ifh, '<', $file) # always use a variable here containing filename
   or die "Unable to open file $file, $!";

while (<$ifh>) {
 $port->write("$_");
 my $delay = length($_) * 0.2;
 sleep($delay);
}
 
$port->write("\x13");
sleep(1);

close ($ifh);


exit 0;
