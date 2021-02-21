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

targetFilePath="../../Logs/${crashFileName}"
mkdir -p $targetFilePath

echo "copying files..."
cp -f -r $crashFilePath $targetFilePath

cd $targetFilePath

symbolicatecrashPath="../../Tools/Files/symbolicatecrash"
dSYMPath="../../Tools/Files/EZView.app.dSYM"

echo "decoding..."
chmod 777 $symbolicatecrashPath
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
./$symbolicatecrashPath $crashFileFullName dSYMPath >$crashFileName.crash

echo -e "\n${Default}================================================"
echo -e "  Target Log File Path  :  ${Cyan}${targetFilePath}${Default}"
echo -e "${Default}================================================\n"

open $targetFilePath