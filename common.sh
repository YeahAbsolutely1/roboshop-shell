script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]
   then
     echo -e "\e[1;32m SUCCESS\[0m"
   else
     echo -e "\e[1;31m FAILURE\[0m"
     echo 'Please refer to a long file for more information. LOG - ${LOG}'
  exit
  fi
}

print_head() {
  echo -e "\e[1m $1\e[0m"
}