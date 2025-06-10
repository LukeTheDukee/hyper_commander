#!/usr/bin/env bash

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
    echo -e "\nNot Implemented yet."
    ;;

  4)
    echo -e "\nNot Implemented yet."
    ;;

  *)
    echo -e "\nInvalid choice. Please try again."
    ;;
  esac
}

# While loop for execution
while true; do
  menu
done
