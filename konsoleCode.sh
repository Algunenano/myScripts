#!/bin/bash
# Hack to use Konsole to launch C/C++/rust programs in Visual Studio Code
# It's used as a substitute of xterm, so DON'T USE THESE COMMANDS if you don't 
# know how they modify your system (or if you have xterm installed and might
# need it in the future (back it up!))

# Setup:
# # chmod +x konsoleCode.sh
# # ln -s /path/to/konsoleCode.sh /usr/bin/xterm

# This is based on how MiCore currently works (https://git.io/vDlDc)
# Example of a command launched by VSCode:
# /usr/bin/xterm -title DebuggerTerminal -e bash -c "longAssCommand;"

if [[ "$#" -lt 6 ]]; then
    exit 1;
fi

#Uses --noclose to see the output of the program
konsole --noclose -title "$2" -e "bash -c \"$6\""
