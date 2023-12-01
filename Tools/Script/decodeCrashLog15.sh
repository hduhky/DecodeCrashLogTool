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

# python3 /Applications/Xcode13.app/Contents/SharedFrameworks/CoreSymbolicationDT.framework/Versions/A/Resources/CrashSymbolicator.py

crashSymbolicatorPath="/Applications/Xcode13.app/Contents/SharedFrameworks/CoreSymbolicationDT.framework/Versions/A/Resources/CrashSymbolicator.py"
dSYMPath="../../Tools/Files/EZView.app.dSYM"

echo "decoding..."
python3 $crashSymbolicatorPath $crashFileFullName -d $dSYMPath -o $crashFileName-crash.ips

echo -e "\n${Default}================================================"
echo -e "  Target Log File Path  :  ${Cyan}${targetFilePath}${Default}"
echo -e "${Default}================================================\n"

open $targetFilePath