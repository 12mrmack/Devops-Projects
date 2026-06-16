#!/bin/bash

BASE="/home"
NINJA="ninja_global"

getent group $NINJA >/dev/null || sudo groupadd $NINJA

case $1 in

addTeam)
    sudo groupadd $2 2>/dev/null && echo "Team created" || echo "Exists"
    ;;

addUser)
    U=$2; T=$3
    id $U &>/dev/null && { echo "User exists"; exit; }
    getent group $T >/dev/null || { echo "Team missing"; exit; }

    sudo useradd -m -d $BASE/$U -s /bin/bash -g $T $U
    sudo usermod -aG $NINJA $U

    H=$BASE/$U
    sudo chmod 751 $H
    sudo chown $U:$T $H

    sudo mkdir -p $H/{team,ninja}

    sudo chown $U:$T $H/team && sudo chmod 770 $H/team
    sudo chown $U:$NINJA $H/ninja && sudo chmod 770 $H/ninja

    echo "User added"
    ;;

delUser)
    sudo userdel -r $2 2>/dev/null && echo "Deleted" || echo "Not found"
    ;;

delTeam)
    sudo groupdel $2 2>/dev/null && echo "Deleted" || echo "Not found"
    ;;

changePasswd)
    sudo passwd $2
    ;;

changeShell)
    sudo chsh -s $3 $2
    ;;

ls)
    [ "$2" = "User" ] && cut -d: -f1 /etc/passwd
    [ "$2" = "Team" ] && cut -d: -f1 /etc/group
    ;;

*)
    echo "Usage: addTeam|addUser|delUser|delTeam|changePasswd|changeShell|ls"
    ;;
esac
