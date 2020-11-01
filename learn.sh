#!/bin/bash
echo_he(){
echo "Hello"
return 0
}
echo_she(){
echo "Hi"
return 1
}

echo_he
echo the return status of echo_he is $?
echo_she
echo $?
