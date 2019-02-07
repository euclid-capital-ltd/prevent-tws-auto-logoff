# prevent_tws_auto_logoff.pl
Keep TWS gui running despite its pesky auto logoff feature.

# SYNOPSIS
    prevent_tws_auto_logoff.pl [options]

# OPTIONS
    --timezone|--tz timezone
            Specify which time zone to use. Set this to the time zone your TWS
            gui is on (default=America/Chicago).

    --logoff_time|--time HH:MM
            Give another logoff time to fill in the auto logoff popup. The
            time needs to be in 12h format (default=11:59).

    --sleep N
            Sleep N seconds between polls (default=10).

    --verbose
            Tell the script to print what it is doing.

    --help  Print a brief help message and exits.

    --man   Prints the manual page and exits.

# DESCRIPTION
This script prevents the Interactive Brokers TWS gui from exiting due to
its auto logoff timer. Simply start it in a console window or in the
background, and it will automatically fill in a new logoff time whenever
the TWS auto logoff warning pops up.

It takes the specified logoff time and alternates between AM and PM, so if
the logoff time is currently set to 11:59 PM, it will set the new logoff
time to 11:59 AM and vice versa ad infinitum.
It should run without problems on any Linux flavour, assuming you have
installed the perl module X11::GUITest. Your mileage may vary for other
UNIXes / MacOS. Windows users: there is a similar module, Win32::GuiTest -
porting this script to use that instead of X11::GUITest should be straight
forward - I didn't bother since I only use TWS on Linux (sorry).
