#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
targetDirectory="$1"
destinationDirectory="$2"

# [TASK 2]
echo "Target directory: $targetDirectory"
echo "Destination directory: $destinationDirectory"

# [TASK 3]
# current timestamp in seconds
currentTS=$(date +%s)

# [TASK 4]
# backup-<timestamp>.tar.gz
backupFileName="backup-${currentTS}.tar.gz"

# We're going to:
#   1: Go into the target directory
#   2: Create the backup file
#   3: Move the backup file to the destination directory
#
# To make things easier, we will define some useful variables...

# [TASK 5]
# absolute path of the directory where the script was started
origAbsPath=$(pwd)

# [TASK 6]
# go to the destination directory and get its absolute path
cd "$destinationDirectory" || exit
destDirAbsPath=$(pwd)

# [TASK 7]
# go back, then into the *target* directory where we will search for files
cd "$origAbsPath" || exit
cd "$targetDirectory" || exit

# [TASK 8]
# timestamp for "24 hours ago"
yesterdayTS=$(( currentTS - 24*60*60 ))

declare -a toBackup

# [TASK 9]
# iterate over all files and directories in the current folder
for file in *
do
  # [TASK 10]
  # check if file was modified within the last 24 hours
  if [[ $(date -r "$file" +%s) -gt $yesterdayTS ]]
  then
    # [TASK 11]
    # add file to the array of files to back up
    toBackup+=("$file")
  fi
done

# [TASK 12]
# create the tar.gz archive from the list of files
tar -czf "$backupFileName" "${toBackup[@]}"

# [TASK 13]
# move the backup file to the destination directory
mv "$backupFileName" "$destDirAbsPath"

# (optional) go back to where we started
cd "$origAbsPath" || exit