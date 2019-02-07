#!/usr/bin/env perl

use X11::GUITest qw(WaitWindowLike SendKeys ClickWindow IsWindowViewable);
use Getopt::Long;
use Pod::Usage;
use DateTime;
use warnings;
use strict;

$| = 1;

my $tws_tz = "America/Chicago"; # GLOBEX / CBOD, but can be set to whatever TZ your TWS is on
my $logoff_time = "11:59";
my $verbose = 0;
my $sleep = 10;

GetOptions(	"timezone|tz=s"		=> \$tws_tz,
			"logoff_time|time=s"=> \$logoff_time,
			"verbose"			=> \$verbose,
			"sleep=i"			=> \$sleep,
			"help|?"			=> sub { pod2usage(1); exit(0); },
			"man"				=> sub { pod2usage(-verbose => 2); exit(0); } ) or pod2usage(1);

while (42) {
	foreach my $id (WaitWindowLike('Exit Session Setting', undef, 1)) {
		if (IsWindowViewable($id)) {
			my $now = DateTime->from_epoch(epoch => time(), time_zone => $tws_tz);
			printf "$now: window #$id reset logoff time to $logoff_time " if $verbose;
			ClickWindow($id, 125, 55);
			SendKeys("^(a)");		# select all text
			SendKeys($logoff_time);	# enter our preferred time
			SendKeys("{TAB}");		# switch to AM/PM checkbox
			if ($now->hour > 12) {
				# it's afternoon, reset to AM
				SendKeys("{SPC}");	# select AM checkbox
				print "AM" if $verbose;
			} else {
				# it's morning, reset to PM
				SendKeys("{RIG}");	# goto PM checkbox
				SendKeys("{SPC}");	# select PM checkbox
				print "PM" if $verbose;
			}
			print "\n" if $verbose;
			# select "Update"
			SendKeys("{TAB}");
			SendKeys("{SPC}");
			# select "Close"
			SendKeys("{TAB}");
			SendKeys("{SPC}");
		}
	}
	sleep($sleep);
}

__END__

=head1 NAME

prevent_tws_auto_logoff.pl - Keep TWS gui running despite its pesky auto logoff feature.

=head1 SYNOPSIS

prevent_tws_auto_logoff.pl [options]

=head1 OPTIONS

=over 8

=item B<--timezone|--tz timezone>

Specify which time zone to use. Set this to the time zone your TWS gui is on (default=America/Chicago).

=item B<--logoff_time|--time HH:MM>

Give another logoff time to fill in the auto logoff popup. The time needs to be in 12h format (default=11:59).

=item B<--sleep N>

Sleep N seconds between polls (default=10).

=item B<--verbose>

Tell the script to print what it is doing.

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

This script prevents the Interactive Brokers TWS gui from exiting due to its auto logoff timer.
Simply start it in a console window or in the background, and it will automatically fill in a
new logoff time whenever the TWS auto logoff warning pops up.

It takes the specified logoff time and alternates between AM and PM, so if the logoff time is
currently set to 11:59 PM, it will set the new logoff time to 11:59 AM and vice versa ad infinitum.

It should run without problems on any Linux flavour, assuming you have installed the perl module X11::GUITest.
Your mileage may vary for other UNIXes / MacOS.
Windows users: there is a similar module, Win32::GuiTest - porting this script to use that
instead of X11::GUITest should be straight forward - I didn't bother since I only use TWS on Linux (sorry).

=head1 AUTHOR

Sinisa Susnjar <sini@euclidcapital.co.uk>

=cut
