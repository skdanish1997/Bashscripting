#!/usr/bin/bash

# Set the script to exit immediately if any command exits with a non-zero status
set -e
echo !!! The logs will store On given path /var/log/myscript.log

LOG_FILE="/var/log/my_script_$(date +%Y-%m-%d).log"

DEST_ERROR=0
LOG_ERROR=0

# Parse command-line arguments using getopts
while getopts ":s:d:n:" opt; do
  case $opt in
    s) source_path="$OPTARG" # Set source_path to the argument passed to the -s option
    ;;
    d) destination_path="$OPTARG" # Set destination_path to the argument passed to the -d option
    ;;
    n) num_logs="$OPTARG" # Set num_logs to the argument passed to the -n option
    ;;
    \?) echo "Invalid option -$OPTARG" >&2  # If an invalid option is passed, print an error message and exit with a non-zero status
    ;;
  esac
done


# Print the values of the variables source_path, destination_path, and num_logs
echo "Source Path (-s): $source_path"
echo "Destination Path (-d): $destination_path"
echo "Number of Logs (-n): $num_logs"

# Check if the source path exists and is either a directory or a file
if [[ -d $source_path || -f $source_path ]]; then

 # Print the contents of the source directory
    ls "$source_path"

    # Check if the destination path is empty
    if [ -z "$destination_path" ]; then
        echo "Error: Destination path is not provided." >&2 # Redirect error message to standard error
         echo "$(date +%Y-%m-%d_%H:%M:%S)Error: Destination path is not provided." >> $LOG_FILE # Append error message to log file
         DEST_ERROR=1
# exit 1 # Exit with a non-zero status to indicate an error
    fi
       if [ -z "$num_logs" ]; then
        echo "Error: Destination log is not provided." >&2 # Redirect error message to standard error
         echo "$(date +%Y-%m-%d_%H:%M:%S)Error: Destination log  is not provided." >> $LOG_FILE # Append error message to log file
        LOG_ERROR=1
# exit 1 # Exit with a non-zero status to indicate an error
 fi
      if [ $DEST_ERROR -eq 1 ] || [ $LOG_ERROR -eq 1 ]; then
        exit 1
    fi

    # Create the destination directory if it doesn't already exist
    if [ ! -d "$destination_path" ]; then
         /bin/mkdir -p "$destination_path"
    fi

    # Get the most recent num_logs log files in the source directory and copy them to the destination directory
    files=$(/bin/ls -t "$source_path"/*.log | /bin/head -n "$num_logs")
    /bin/cp -R $files "$destination_path" || (echo "Error: Failed to copy log files." >&2; echo "$(date +%Y-%m-%d_%H:%M:%S)Error: Failed to copy log files." >> $LOG_FILE; exit 1) # Redirect error message to standard error and append to log file

    # Print a success message
    echo "Copied $num_logs log files from $source_path to $destination_path"
    echo "Logs copied successfully to destination path."
else
    echo "Error: Source path does not exist" >&2 # Redirect error message to standard error
    echo "$(date +%Y-%m-%d_%H:%M:%S)Error: Source path does not exist" >> $LOG_FILE # Append error message to log file
fi
