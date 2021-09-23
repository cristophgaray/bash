#!/bin/bash
#
clear -T $TERM
green="\e[32;1m"
red="\e[31;1m"
yellow="\e[33;1m"
white="\e[1m"
reset="\e[0m"
version="1.0.2v"
#=================================================================
function banner(){
printf $green
cat <<- 'EOF'
 .d8888b.          
d88'  '88b         
888    888              ooooooooooooo                   oooo
888                     8'   888   '8                    888
888  88888                   888                         888
888    888    888            888     .ooooo.   .ooooo.   888
'888  8888    888   88888    888    d88' '88b d88' '88b  888
 'Y8888P88    888            888    888   888 888   888  888
       8888888888            888    888   888 888   888  888
       888    888           o888o   'Y8bod8P' 'Y8bod8P' o888o
       888    888 
       888    888   [N]úmero [F]eliz -- github.com/cristophgaray

EOF
printf $reset
}
#=================================================================
function info(){
printf $green
cat <<- 'EOF'

 Tittle:       Número Feliz
 Autor:        Cristofer Garay
EOF
echo " Version:      $version"
cat <<- 'EOF'
 Description:  Todo número natural que cumple que si sumamos los
               cuadrados de sus dígitos y seguimos el proceso con
               los resultados obtenidos el resultado es 1.

               Por ejemplo, el número 203 es un número feliz
               ya que
                  
                  203 | 2^2 + 0^2 + 3^2 = 13
                   13 | 1^2 + 3^2 = 10
                   10 | 1^2 + 0^2 = 1

EOF
printf $reset
}
#=================================================================
function help(){
printf $green
cat <<- 'EOF'
  Uso:

     numero_feliz [Opciones]

  Opciones

    -n | --number     Número a prubar
    -i | --info       Muestra la versión del script y
                      la informacion a cerca del número feliz
    -h | --help       Muestra la ayuda del script y sale

   Ejemplo

   numero_feliz -n 7

EOF
printf $reset
}
#=================================================================
while [ -n "$1" ]
do
 case "$1" in
  -n|--number)
     num="$2"; shift ;;
  -i|--info)
    banner; info; shift ;;
  -h|--help)
    banner; help; shift ;;
   *) echo -e "${green}"; banner; help; echo -e "${reset}"
      echo -e "${red}Opcion $1 no reconizida.${reset}" ;;
 esac
shift
done
 #=================================================================
if [[ -n "$num" && "$num" =~ ^[[:digit:]]+$ ]]
then
  N=$num
  iter=0
  while true
  do
    if [ ${#num} -eq 1 ]; then start="0$num"; else start="$num"; fi
    echo -n "[>_${iter}_<]: $start |"
#
    function sum(){
      N=$1
      l=${#N}
      for (( i=1; i<=$l; i++ ))
      do
        dig=${N:$(( $i - 1  )):1}
        if [ "$2" -eq 1 ]
        then echo -n " ${dig}^2 +"
        elif [ "$2" -eq 2 ]
        then echo -n " $(($dig * $dig)) +"
        fi
      done | sed 's/\+$//g'
    }
#
    echo "$(sum $start 1)|" \
         "$(sum $start 2)= $(expr $(sum $start 2))"
    num=$(expr $(sum $start 2))
    if [ $num -eq 1 ]
    then
      echo -e "\n${green}${N}${reset} es un número feliz :)"
      exit 0
    elif [ $num -eq 58 ]
    then
      echo -e "\n${red}${N}${reset} no es un número feliz :("
      exit 0
    fi
    iter=$(( $iter + 1 ))
  done
elif [[ -n "$num" && $num =~ ^[[:alnum:]]+ ]]
then
  banner
  echo -e  "${red}Error: ${num}${reset}"
fi
#=================================================================
