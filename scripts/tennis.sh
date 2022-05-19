#!/bin/bash
#207017443 Yonathan Mevarech-Radai

    STATE=7
    P1=50
    P2=50
    P1INPUT=0
    P2INPUT=0
    WINNER=0


printBoardState(){

    case $STATE in

    0)
        echo -e " |       |       #       |       |O"
        ;;

    1)
        echo -e " |       |       #       |   O   | "
        ;;

    2)
        echo -e " |       |       #   O   |       | "
        ;;

    3)
        echo -e " |       |   O   #       |       | "
        ;;
    4)
        echo -e " |   O   |       #       |       | "
        ;;
    5)
        echo -e "O|       |       #       |       | "
        ;;
    *)
        echo -e " |       |       O       |       | "
        ;;
   



esac

}

printBoard(){

    echo -e " Player 1: $P1         Player 2: $P2 "
    echo -e " --------------------------------- "
    echo -e " |       |       #       |       | "
    echo -e " |       |       #       |       | "
    printBoardState 
    echo -e " |       |       #       |       | "
    echo -e " |       |       #       |       | "
    echo -e " --------------------------------- "


}

printPlayerInput(){

    echo -e "       Player 1 played: $P1INPUT\n       Player 2 played: $P2INPUT\n\n"

}

printWinner(){

    case $WINNER in
        1)
            echo -e "PLAYER 1 WINS !"
            ;;
        2)  echo -e "PLAYER 2 WINS !"
            ;;
        3)
            echo -e "IT'S A DRAW !"
            ;;
    esac

}

firstStrike(){

    getPlayersInput


    if (($P1INPUT > $P2INPUT)); then
        STATE=2
    elif (($P1INPUT == $P2INPUT)); then
        STATE=7
    else
        STATE=3
    fi
    printBoard 
    printPlayerInput
    whoWon  
    if ((($STATE == 7) && ($WINNER == 0))); then
        firstStrike
    elif (($WINNER != 0)); then
        return
    else
        game
    fi
}

checkIfNotANum(){
    c=${1}
    re='^[0-9]+$'
    if  ! [[ $c =~ $re ]] ; then
        return true
    else
        return false
    fi




}

getPlayersInput(){

    re='^[0-9]+$'

    echo -e "PLAYER 1 PICK A NUMBER: " 
    read -s P1INPUT


    while true; do
        if [[ $P1INPUT =~ $re ]] ; then
            if (($P1INPUT <= $P1)); then
                break
            fi

        fi
        echo -e "NOT A VALID MOVE !"
        echo -e "PLAYER 1 PICK A NUMBER: " 
        read -s P1INPUT
    done

    echo -e "PLAYER 2 PICK A NUMBER: "
    read -s P2INPUT

    while true; do
        if [[ $P2INPUT =~ $re ]] ; then
            if (($P2INPUT <= $P2)); then
                break
            fi

        fi
    echo -e "NOT A VALID MOVE !"
    echo -e "PLAYER 2 PICK A NUMBER: "
    read -s P2INPUT

    done

    P1=$((P1-P1INPUT))
    P2=$((P2-P2INPUT))

}

whoWon(){
    if (($STATE == 5)); then
        WINNER=2
    elif (($STATE == 0));then
        WINNER=1
    elif ((($P1 != 0)&&($P2 == 0)));then
        WINNER=1
    elif ((($P2 != 0)&&($P1 == 0)));then
        WINNER=2
    elif (((($P1 == 0)&&($P1 == $P2))&&(($STATE == 1)||($STATE == 2))));then
        WINNER=1
    elif (((($P1 == 0)&&($P1 == $P2))&&(($STATE == 3)||($STATE == 4))));then
        WINNER=2
    elif (((($P1 == 0)&&($P2 == 0))&&(STATE=7))); then
        WINNER=3
    fi
    printWinner

}
match(){

    getPlayersInput

    if (($P1INPUT > $P2INPUT)); then
        if ((STATE==3)); then
            STATE=2
        elif ((STATE==4)); then
            STATE=2
        else
            STATE=$((STATE-1))

        fi
    elif (($P1INPUT == $P2INPUT)); then
        :
    else
        if ((STATE==1)); then 
            STATE=3
        elif ((STATE==2)); then
            STATE=3
        else
            STATE=$((STATE+1))
        fi
    fi
    printBoard
    printPlayerInput
}

game(){
    while (((($P1 > 0) && ($P2 > 0))&&(($STATE > 0)&&($STATE < 5)))); do
        match
    done
    whoWon
}

start(){
    printBoard
    firstStrike
}

start