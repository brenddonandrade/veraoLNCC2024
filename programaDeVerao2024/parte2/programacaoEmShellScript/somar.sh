#!/usr/bin/bash
A=${1:-13}
B=${2:-14}
echo $A + $B "=" $((A+B)) 
echo $B + $A "=" $((B+A)) 
