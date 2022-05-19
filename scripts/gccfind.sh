#!/bin/bash
#207017443 Yonathan Mevarech-Radai
P=${1}
WORD=${2}
FLAG=${3}
cd $P

del(){
    rm $E

}

delFile(){

   E=$(grep --include=\*.out $1 --no-messages)
   if [ -z "$E" ]
        then
            :
    else
      del $E

    fi

}

compFile(){

    S=$(grep --include=\*.c -wl $1 -e $WORD --no-messages)

    if [ -z "$S" ]
        then
            :
    else
        modified=${S::-2}
        gcc $S  -o "$modified.out"

    fi
}
compInALoop(){
    for var in "$@"
        do
            compFile $var
    done

}


if [ "$FLAG" = "-r" ]; then
    files=$(grep --include=\*.out -wrl $P -e $WORD --no-messages)
    rm $files -f
    files=$(grep --include=\*.c -wrl $P -e $WORD --no-messages)
    compInALoop $files


else
    for file in $P/*
        do
            delFile $file
    done
     for file in $P/*
        do
            compFile $file
    done
fi

