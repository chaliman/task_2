#!/bin/bash
#Script to rotate provided file in each n time
file=$1
declare -l time=$2

if [[ -n $3 ]]; then #Validating only 2 args were being provided
  echo "Only 2 arguments are expected"
  echo $'i.e. Script.sh FileName Interval\n' ; exit
else
  echo "File: $file"
  echo "Time: $time"

  z=$(sed 's/[a-zA-Z]*\|[0-9]*/&\n/g; s/\n$//' <<<"$time"|wc -l) 
  if [[ $z != 2 ]] ; then
    echo $'Time interval should be provided by number from 1 to 99 and measure of time like mins or secs\n' ; exit
  fi

  x=$(sed 's/[a-zA-Z]*\|[0-9]*/&\n/g; s/\n$//' <<<"$time"|head -n1) #Number(s) from string
  y=$(sed 's/[a-zA-Z]*\|[0-9]*/&\n/g; s/\n$//' <<<"$time"|tail -n1) #Character(s) from string

  if [[ $x -gt 99 || $x -lt 1 ]] ;then
    echo $'Only use intervals from 1 to 99\n' ; exit
  fi

  if [[ $y != "s"  && $y != "sec" && $y != "secs" && $y != "second" && $y != "seconds" &&  $y != "m"  && $y != "min" && $y != "mins" && $y != "minute" && $y != "minutes" ]] ; then
     echo "Only seconds or minutes can be used"
     echo $'i.e. s , sec, secs, seconds , m , min, mins, minute, minutes\n'; exit
  fi

  a=$(echo $y|cut -b1) #Stores in "a" if mins (m) or secs (s)
 
  if [ ! -f $file ] ; then
    touch $file # creates file in case this doesn't exists
  fi

  chmod 666 $file #file should have read+write permissions for everybody
  echo $'\nFile "'$file'" verified with comand "ls -l"'
  ls -l $file ; echo $'\n'
  
  mkdir ./archieved 2>/dev/null #creation of folder named archieved (could exist or not exist previously the folder)
  
  while true; do #here is where file is being rotated
    d=$(date +%Y%m%d_%H%M%S)
    b=$(echo $file"_"$d)
    echo -ne $'File '$file' was rotated to ./archieved/'; echo -ne $b ; echo " next will happend in $x$a"
    sudo cp $file ./archieved/$b ; sudo chmod 644 ./archieved/$b ; sudo chown $user:$user ./archieved/$b
    sleep $x$a
  done

fi
