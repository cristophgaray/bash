#!/bin/zsh
clear -T $TERM
green="\e[32;1m"
red="\e[31;1m"
yellow="\e[33;1m"
white="\e[1m"
reset="\e[0m"
version="1.0.0v"
#=================================================================
function banner(){
printf ${green}
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
       888    888

[N]umero & [C]onstante de [K]aprekar -- github.com/cristophgaray

EOF
printf ${reset}
}
#=================================================================
function info(){
printf $green
cat <<- 'EOF'

 Tittle:      [N]umero & [C]onstante de [K]aprekar
 Autor:       Cristofer Garay
EOF
echo -e " Version:      $version\n Description:\n\n"
case "$1" in
   num*|n|N)
     if [ -e "info_kaprekar_num.txt" ]
     then cat info_kaprekar_num.txt; echo
     else echo -e "https://en.wikipedia.org/wiki/Kaprekar_number\n"
     fi ;;
  const*|c|C)
     if [ -e "info_kaprekar_const.txt" ]
     then
       cat info_kaprekar_const.txt; echo
     else
       echo -e "https://en.wikipedia.org/wiki/Kaprekar%27s_routine\n"
     fi
  ;;
  esac
printf $reset
}
#=================================================================
function help(){
printf $green
cat <<- 'EOF'
  Uso:

     kaprekar [Opciones]

  Opciones

    -n | --number     Número de Kaprekar.
    -c | --const      Constante de Kaprekar.
    -i | --info       Muestra la versión del script y la
                      información a cerca de la constante y
                      el número de Kaprekar.
                      
                      [num|number|numero|n|N]:
                          opciones para ver la informaci+on
                          a cerca del número de Kaprekar
                          
                      [constant|constante|const|c|C]:
                         opciones para ver la infromación
                         a cerca de la constante de Kaprekar
                         
    -h | --help       Muestra la ayuda del script y sale.

   Ejemplo:

   kaprekar --number 9
    
   kaprekar --info const

EOF
printf $reset
}
#=================================================================
if [ -z "$1" ]; then banner; help
else
while [ -n "$1" ]
do
 case "$1" in
  -n|--number)
     num="$2"; shift ;;
  -c|--const)
     const="$2"; shift ;;
  -i|--info)
     info="$2"; shift ;;
  -h|--help)
     banner; help; shift ;;
   *) echo -e "${red}Opcion $1 no reconizida.${reset}" ;;
 esac
shift
done
fi
#=================================================================
if [ -n "$info" ]
then
  banner; info "$info"
fi
#=================================================================
#			  Número de KAPREKAR
#=================================================================
if [[ -n "$num" && $num =~ ^[0-9]+$ && -z "$const" ]]
then
   N="$(( $num * $num ))"
   if [ $( expr ${#N} % 2 ) -eq 0 ]
   then
     uno=${N:0:$( expr ${#N} / 2 )}
     dos=${N:$( expr ${#N} / 2 ):${#N}}
     n=$(expr $uno + $dos)
     if [ $n -eq $num ]
     then
       echo "${num} es un número de Kaprekar"
       echo "${num}^2 = $N : $uno + $dos = $n"
     else
       echo "${num} no es un número de Kaprekar"
     fi
   else
     uno=${N:0:$( expr ${#N} / 2 )}
     dos=${N:$( expr ${#N} / 2 ):${#N}}
     n=$(expr $uno + $dos)
     if [ $n -eq $num ]
     then
       echo "${num} es un número de Kaprekar"
       echo "${num}^2 = $N : $uno + $dos = $n"
     else
       echo "${num} no es un número de Kaprekar"
     fi
   fi
elif [[ -n "$num" && "$num" =~ [[:alpha:]]+ ]]
then
  echo -e "Error ${red}${num}${reset} solo se permite números"
fi
#=================================================================
# 			Constante de KAPREKAR
#=================================================================
function nusort(){
  num=$(echo "$1" | \
  sed 's/\([0-9]\)/\n\1/g' | \
  while read line
  do
    echo "$line"
  done)
  if [ -n "$2" ]; then echo "$num" | sort "$2" | sed ':a;N;$!ba;s/\n//g'
  elif [ -z "$2" ]; then echo "$num" | sort | sed ':a;N;$!ba;s/\n//g'
  fi
}
#=================================================================
if [[ -n "$const" && "$const" =~ ^[[:digit:]]{4}$ && -z "$num" ]]
then
  i=0
  start=$const
  while true
  do
    i=$(( $i + 1))
    uno=$(nusort "$const" "-r")
    dos=$(nusort "$const")
    if [[ $uno > $dos ]]
    then const=$(expr $uno - $dos )
         echo "[>_${i}_<] $uno - $dos: $const"
    elif [[ $uno < $dos ]]
    then const=$(expr $dos - $uno )
         echo "[>_${i}_<] $uno - $dos: $const"
    elif [[ $uno == $dos ]]
    then
      echo "El número ${const} no llega a la constante de Kaprekar"
      exit 0
    fi
    if [[ "${#const}" -eq 3 ]]
    then const=$(echo "${const}0")
    fi
    if [[ "$const" -eq 6174 ]]
    then echo -e "\n${green}${start}${reset}" \
                 " llega a la constante de Kaprekar"
         exit 0
   fi
  done
elif [[ -n "$const" && "$const" =~ ^([[:alnum:]]{1,3}|[[:alnum:]]{5,}) ]]
then
  echo -e "Error ${red}${const}${reset}" \
          " solo se permiten números con 4 dígitos"
fi
#=================================================================
unset uno dos