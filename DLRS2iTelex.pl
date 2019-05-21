#!/usr/bin/perl -w

use strict;
use warnings;
use Device::SerialPort;

$| = 1;

my $port = Device::SerialPort->new("/dev/ttyUSB0");

$port->baudrate(9600); # Configure this to match your device
$port->databits(8);
$port->parity("none");
$port->stopbits(1);

$port->write("\x1");
sleep(1);

$port->write("05");
sleep(1);

open(my $yourhandle, '<', 'dlrs201919.txt') # always use a variable here containing filename
    or die "Unable to open file, $!";

#$port->write("Hello world\r\n");

while (<$yourhandle>) {
 $port->write("$_");
 sleep(10);
}

$port->write("\x13");

exit 0;
