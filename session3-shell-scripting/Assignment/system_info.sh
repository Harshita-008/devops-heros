#!/bin/bash

# store the system details in variables
current_date=$(date)
host_name=$(hostname)
user_name=$(whoami)

echo "===== System Information ====="
echo "Date     : $current_date"
echo "Hostname : $host_name"
echo "Username : $user_name"

echo ""
echo "===== Disk Usage ====="
df -h

echo ""
echo "===== Running Processes ====="
ps aux | head -6

# take the directory and file name from the user
read -p "Enter a directory name to create: " dir_name
read -p "Enter a file name to create: " file_name

# create the directory and the file
mkdir -p "$dir_name"
touch "$dir_name/$file_name"

# save the full process list inside the file
ps aux > "$dir_name/$file_name"

echo ""
echo "Directory created : $dir_name"
echo "File created      : $dir_name/$file_name"
echo "Lines saved       : $(wc -l < "$dir_name/$file_name")"
