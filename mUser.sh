#!/bin/bash
 
if [ $# -eq 0 -o $# -gt 2 ]
then
    echo "use $0 --add username or $0 --del username or $0 --help."
    exit 1
fi
 
case $1 in
    --add)
        n=0
        for u in `echo $2|sed 's/,/ /g'`; do
            if awk -F: '{print $1}' /etc/passwd |grep -qw "$u"
            then
               echo "The user $u exist."
            else
                useradd $u
                echo -e "$u\n$u"|passwd $u >/dev/null 2>&1
                echo "The user $u added successfully."
                n=$[$n+1]
            fi
        done
 
        if [ $n -eq 0 ]; then
            exit 2
        fi
        ;;
 
    --del)
        n=0
        for u in `echo $2|sed 's/,/ /g'`; do
            if awk -F: '{print $1}' /etc/passwd|grep -qw "$u"
            then
               userdel -r $u
                echo "The user $u deleted successfully."
                n=$[$n+1]
            else
                echo "The user $u not exist."
            fi
        done
 
        if [ $n -eq 0 ]; then
                exit 3
        fi
        ;;
 
    --help)
        echo -e "--add can add user,and the passwd is the same as username.     
    It can add multiuser such as --add user1,user2,user3..."
        echo "--del cat delete user.It can delete user such as --del user1,user2,user3..."
        ;;
 
    *)
        echo "use $0 --add username or $0 --del username or $0 --help."
        exit 1
        ;;
esac
