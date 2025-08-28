#!/usr/bin/env bash

# This program is a simple command line file manager and system info tool.
# It allows users to navigate directories, perform file operations, view system info, and find and
# start executables. It is designed to be lightweight and easy to use. It was created as a learning project
# as part of the Jetbrains Academy Bash course.

# colors
RED='\033[0;31m'
NC='\033[0m' # No Color
LIGHT_BLUE='\033[1;34m'
LIGHT_GRAY='\033[1;36m'
DARK_GRAY='\033[0;36m'

echo -e "Hello $USER"

# Menu function to display option
menu() {

  echo -e "\n"
  echo -e " ${LIGHT_BLUE}Hyper Commander       ${NC}"
  echo -e "------------------------------"
  echo -e "| ${RED}0${NC}: Exit                    |"
  echo -e "| ${RED}1${NC}: OS Info                 |"
  echo -e "| ${RED}2${NC}: User Info               |"
  echo -e "| ${RED}3${NC}: File and Dir operations |"
  echo -e "| ${RED}4${NC}: Find executables        |"
  echo -e "------------------------------"

  read -rp "Enter your choice: " choice

  case $choice in # switch case for menu options

  0)
    echo -e "\n Exiting..." # exit option
    exit 0
    ;;

  1)
    echo -e "\n" #TODO: Flesh out behaviour.
    uname -no    # OS name and kernel version
    ;;

  2)
    echo -e "\nUser: $USER\n" # Memeory usage by user
    memory_usage
    ;;

  3)
    echo -e "\n" # Simple file and directory operations inspired by Norton Commander. TODO: add more options
    file_and_dir_operations
    ;;

  4)
    find_and_run_executable # Find and run executables.
    ;;

  *)
    echo -e "\nInvalid choice. Please try again." # Default case for invalid input
    ;;
  esac
}

# Function to handle file and directory operations. TODO: add more options
file_and_dir_operations() {
  files_and_dirs=(*)
  echo -e "\nThe list of files and directories:"

  for item in "${files_and_dirs[@]}"; do
    if [[ -f "$item" ]]; then
      echo -e "${LIGHT_GRAY}F${NC} $item"
    elif [[ -d "$item" ]]; then
      echo -e "${DARK_GRAY}D${NC} $item"
    fi
  done

  echo -e "\n---------------------------------------------------"
  echo -e "| ${RED}0${NC} Main menu | ${RED}'up'${NC} To parent | ${RED}'name'${NC} To select |"
  echo -e "---------------------------------------------------"

  read -r input

  if [[ "$input" == "0" ]]; then
    return # Go back to the main menu
  elif [[ "$input" == [Uu]p ]]; then
    cd .. || echo "Failed to change directory to parent."       # Execute command or trhwow error
    file_and_dir_operations                                     # recursively call function to refresh view
  elif [[ -d "$input" ]]; then                                  # if directory, change to it
    cd "$input" || echo "Failed to change directory to $input." # Execute command or throw error
    file_and_dir_operations                                     # Recursively call function to refresh view
  elif [[ -f "$input" ]]; then                                  # if file, offer manipulations
    file_manipulations                                          # send to file manipulations function
  else
    echo -e "\nInvalid input!" # Invalid input handling
    file_and_dir_operations
  fi
}

# function to handle file manipulations. Gets called from file_and_dir_operations. TODO: add more options
file_manipulations() {

  echo -e "\n---------------------------------------------------------------------"
  echo -e "| ${RED}0${NC} Back | ${RED}1${NC} Delete | ${RED}2${NC} Rename | ${RED}3${NC} Make Writable | ${RED}4${NC} Make read-only |"
  echo -e "---------------------------------------------------------------------"

  read -r answer

  if [[ "$answer" == "0" ]]; then
    file_and_dir_operations
  elif [[ "$answer" == "1" ]]; then
    /bin/rm "$input"
    echo -e "\n$input has been deleted."
    file_and_dir_operations
  elif [[ "$answer" == "2" ]]; then
    read -rp "Enter new name for $input: " new_name
    mv "$input" "$new_name"
    echo -e "\n$input has been renamed to $new_name."
    file_and_dir_operations
  elif [[ "$answer" == "3" ]]; then
    chmod 666 "$input" # set permissions to read and write for user, group, and others
    echo -e "\nPermissions have been updated.\n"
    ls -l "$input"
    file_and_dir_operations
  elif [[ "$answer" == "4" ]]; then
    chmod 664 "$input" # set permissions to read and write for user and group, read for others
    echo -e "\nPermissions have been updated.\n"
    ls -l "$input"
    file_and_dir_operations
  else
    echo -e "\nInvalid input!"
    file_manipulations
  fi
}

# Memory usage function to display memory usage by user
memory_usage() {
  echo -e "System resources in use: \n"

  (
    echo -e "${DARK_GRAY}user rss(KiB) vmem(KiB)${NC}"
    for user in $(users | tr ' ' '\n' | sort -u); do
      echo "$user" "$(ps -U "$user" --no-headers -o rss,vsz | # Iterate through each user and echo their memory usage. RSS is resident set size, VSZ is virtual memory size.
        awk '{rss+=$1; vmem+=$2} END{print rss" "vmem}')"
    done | grep "$USER" # Only show the current user.
  ) | column -t
}

# Function to find and run executables
find_and_run_executable() {
  echo -e "\n"
  read -rp "Enter an executable name: " REPLY

  if ! which "$REPLY" >/dev/null 2>&1; then # Reroute stderr to stdout and combined output to /dev/null
    echo -e "\nThe executable with that name does not exist!"
    return
  else
    echo -ne "\nLocated in: "
    which "$REPLY"
    echo -e "\n"
    read -rp "Enter arguments: " arguments
    echo -e "\n"
    "$REPLY" "$arguments"
  fi
}

# While loop for execution
while true; do
  menu
done
