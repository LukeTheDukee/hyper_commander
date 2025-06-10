#!/usr/bin/env bash

# colors
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "Hello $USER"

# Menu function to display option
menu() {

  echo -e "\n"
  echo -e "------------------------------"
  echo -e "| Hyper Commander            |"
  echo -e "| 0: Exit                    |"
  echo -e "| 1: OS Info                 |"
  echo -e "| 2: User Info               |"
  echo -e "| 3: File and Dir operations |"
  echo -e "| 4: Find executables        |"
  echo -e "------------------------------"

  echo -ne "\n Enter your choice: "
  read -r choice

  case $choice in

  0)
    echo -e "\n Exiting..."
    exit 0
    ;;

  1)
    echo -e "\n"
    uname -no
    ;;

  2)
    echo -e "\n"
    whoami
    ;;

  3)
    echo -e "\n"
    file_and_dir_operations
    ;;

  4)
    echo -e "\nNot Implemented yet."
    ;;

  *)
    echo -e "\nInvalid choice. Please try again."
    ;;
  esac
}

# Function to handle file and directory operations
file_and_dir_operations() {
  files_and_dirs=(*)
  echo -e "\nThe list of files and directories:"

  for item in "${files_and_dirs[@]}"; do
    if [[ -f "$item" ]]; then
      echo "F $item"
    elif [[ -d "$item" ]]; then
      echo "D $item"
    fi
  done

  echo -e "\n---------------------------------------------------"
  echo -e "| ${RED}0${NC} Main menu | ${RED}'up'${NC} To parent | ${RED}'name'${NC} To select |"
  echo -e "---------------------------------------------------"

  read -r input

  if [[ "$input" == "0" ]]; then
    return # Go back to the main menu
  elif [[ "$input" == [Uu]p ]]; then
    cd .. || echo "Failed to change directory to parent."
    file_and_dir_operations
  elif [[ -d "$input" ]]; then
    cd "$input" || echo "Failed to change directory to $input."
    file_and_dir_operations
  elif [[ -f "$input" ]]; then
    echo -e "\nFile content of $input:"
    cat "$input"
    file_and_dir_operations
  else
    echo -e "\nInvalid input!"
    file_and_dir_operations
  fi

}

# While loop for execution
while true; do
  menu
done
