# Shell Scripting: System Information Script

## Overview

This script (`system_info.sh`) prints basic system information, takes input from the user, creates a
directory and a file, and stores the running process list inside that file using output redirection.

---

## Script Features

| Feature | Command Used |
|---|---|
| Print current date | `date` |
| Print hostname | `hostname` |
| Print username | `whoami` |
| Print disk usage | `df -h` |
| Print running processes | `ps aux` |
| Use variables | `current_date=$(date)`, `host_name`, `user_name` |
| Take user input | `read -p` |
| Create a directory | `mkdir -p` |
| Create a file | `touch` |
| Store process info in file | `ps aux > file` (output redirection) |

---

## The Script

```bash
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
```

**Points about the script:**
- `$(...)` is command substitution. It runs the command and stores the output in the variable.
- Only the first few processes are shown on screen with `ps aux | head -6`, but the **full** list is
  written into the file.
- Variables are wrapped in double quotes (`"$dir_name"`) so a name with a space does not break the
  command.
- `mkdir -p` does not give an error if the directory already exists, so the script can be run again
  safely.

---

## Running the Script

```bash
chmod +x system_info.sh
./system_info.sh
```

Values entered when the script asks:
- Directory name: `sysinfo_data`
- File name: `process.log`

### Screenshot

![alt text](<screenshots/img_1.png>)

## Verifying the Directory and File

```bash
ls -l
ls -l sysinfo_data
head -3 sysinfo_data/process.log
wc -l < sysinfo_data/process.log
```

### Screenshot

![alt text](<screenshots/img_2.png>)

## Things to Remember

- `echo hostname` prints the word `hostname`. To print the actual value, command substitution is
  needed: `echo $(hostname)`, or store it first as `host_name=$(hostname)`.
- `>` overwrites the file each time and `>>` adds to the end, so `ps aux > file` gives a fresh
  process list on every run.
- `chmod +x` is required before `./script.sh` works. Without it the script can only be run as
  `bash script.sh`.
- `#!/bin/bash` on the first line tells the system which shell should run the file.
- `read -p` prints the prompt and waits for input on the same line, which is cleaner than using
  `echo` followed by `read`.
