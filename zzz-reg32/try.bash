#!/bin/bash
ps -a >ps.out

i=1
while read -r first_name last_name; do
   [[ $first_name = 'PID' ]] && continue
   # Only print the last name (second column)
   printf '%s\n' "$first_name"
   done < ps.out
