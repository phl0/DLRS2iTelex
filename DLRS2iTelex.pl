#!/usr/bin/perl -w

use strict;
use warnings;
use DateTime;
use Device::SerialPort;

$| = 1;

# Open file with current Deutschlandrundspruch by DARC

my $dt = DateTime->now;
my $year = $dt->year;
my $week = $dt->week_number;

my $file = "dlrs/dlrs".$year.$week.".txt";

open(my $fh, '<', $file) # always use a variable here containing filename
	or die "Unable to open file $file, $!";

while (<$fh>) {
	print $_;
}

# my $port = Device::SerialPort->new("/dev/ttyUSB0");
# 
# $port->baudrate(9600); # Configure this to match your device
# $port->databits(8);
# $port->parity("none");
# $port->stopbits(1);
# 
# $port->write("\x1");
# sleep(1);
# 
# $port->write("05");
# sleep(1);
# 
# 
# while (<$yourhandle>) {
#  $port->write("$_");
#  sleep(10);
# }
# 
# $port->write("\x13");

exit 0;
