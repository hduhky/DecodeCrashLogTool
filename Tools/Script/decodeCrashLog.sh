#!/bin/bash


Cyan='\033[0;36m'
Default='\033[0;m'

crashFilePath="$1"
crashFileFullName=""
crashFileName=""
confirmed="n"

getCrashFilePath() {
    if test -z "$crashFilePath"; then
        echo "Crash Log Invalid!"
        exit
    fi
}

getInfomation() {
    getCrashFilePath
    crashFileFullName=${crashFilePath##*/}
    crashFileName=${crashFileFullName%%.*}

    echo -e "\n${Default}================================================"
    echo -e "  Crash File Name  :  ${Cyan}${crashFileName}${Default}"
    echo -e "${Default}================================================\n"
}

getInfomation

mkdir -p "../../Logs/${crashFileName}"

symbolicatecrashPath="../Files/symbolicatecrash"
dSYMPath="../Files/EZView.app.dSYM"

targetFilePath="../../Logs/${crashFileName}"

echo "copying files..."
cp -f -r $crashFilePath $symbolicatecrashPath $dSYMPath $targetFilePath

cd $targetFilePath

echo "decoding..."
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
./symbolicatecrash $crashFileFullName ./EZView.app.dSYM >./$crashFileName.log

echo -e "\n${Default}================================================"
echo -e "  Target Log File Path  :  ${Cyan}${targetFilePath}${Default}"
echo -e "${Default}================================================\n"

open $targetFilePath