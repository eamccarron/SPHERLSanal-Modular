#!/bin/bash

#There is no reason to run this as root, and doing would permanatly modify the root users path, which should be avoided.  So exit if root.
[ $EUID -eq 0 ] && {
    echo "Error:  This script should not be run with root privileges! Run as normal user to continue. Exiting now."
    exit
}

cmake --version &> /dev/null || {
    echo "Error: cmake not installed.  Install cmake using your package manager to continue.  Exiting now." 
    exit
}

#ensure pip is installed and runnable from command line
pip --version &> /dev/null || {
    echo "Error: pip python package manager not found.  Install pip using your package manager to continue. Exiting now." 
    exit
}

#ensure G++ compiler is installed
g++ --version &> /dev/null || {
    echo "Error: G++ compiler not found.  Install the GNU C++ compiler using your package manager to continue. Exiting now." 
    exit
}

ROOT_DIR=`pwd`
BIN_PATH_EXPORT_CMD="export PATH=\$PATH:$ROOT_DIR/bin/"
SCRIPTS_PATH_EXPORT_CMD="export PATH=\$PATH:$ROOT_DIR/scripts/"

#if an argument is given, use it as the login profile 
[ $# -ne 0 ] && PROFILE_FILE=$1 || PROFILE_FILE="$HOME/.profile" 

#if profile file doesn't exist, create it and append #!/bin/bash to first line
[ -f $PROFILE_FILE ] || {
    touch $PROFILE_FILE
    echo "#!/bin/bash" > $PROFILE_FILE
}

#If not already added, append SPHERLSanal to the path in the profile file specified (or ~/.profile by default)
grep -q "$BIN_PATH_EXPORT_CMD" $PROFILE_FILE || sed -i.bak "$ a \\$BIN_PATH_EXPORT_CMD" $PROFILE_FILE 
grep -q "$SCRIPTS_PATH_EXPORT_CMD" $PROFILE_FILE || sed -i.bak "$ a \\$SCRIPTS_PATH_EXPORT_CMD" $PROFILE_FILE 

#install python packages using pip
pip install -r ./requirements.txt
#Make working directories
mkdir eos
mkdir data
