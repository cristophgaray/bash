#!/bin/bash
reset="\\e[0m"
red="\\e[31;1m"
blue="\\e[34;1m"
green="\\e[32;1m"
yellow="\\e[33;1m"
white="\\e[39;1m"
version="1.0.3v"
clear -T $TERM
#=================================================================
function banner(){
printf $green
cat <<- 'EOF'
 .d8888b.                  ooooooooooooo                   oooo
d88'  '88b                 8'   888   '8                    888
888    888                      888                         888
888                             888     .ooooo.   .ooooo.   888
888  88888          8888888     888    d88' '88b d88' '88b  888
888    888    888               888    888   888 888   888  888
'888  8888    888               888    888   888 888   888  888
 'Y8888P88    888              o888o   'Y8bod8P' 'Y8bod8P' o888o
       8888888888
       888    888
       888    888
       888    888

EOF
printf $reset
}
#=================================================================
function info(){
printf $green
cat <<- 'EOF'

 Tittle:       Lower to Upper & Upper to Lower
 Autor:        Cristofer Garay
 Description:  Crea una animación cambiando carácter
               por carácter,  ya sea de mayúscula a minúscula
               o viceversa
EOF
  echo -e " Version:      $version\n"
printf $reset
}
#=================================================================
main(){
  str="$1"
  rcolor="\\e[3$(( $(($RANDOM%4)) + 1 ));1m"
  for (( i=0; i<=${#str}; i++ ))
  do
    echo -e "${rcolor}"
    echo -n "${str:0:$i}"
    echo -n "${str:$i:1}" | tr $2 $3
    echo "${str:$(( $i + 1)):${#str}}"
    echo -e "${reset}"
    sleep 0.2
    clear -T $TERM
done
}
#=================================================================
help(){
printf $green
cat <<- 'EOF'

USE:

    lowertoupper  [Options]

Options

    -t | --texto    Lee el texto de entrada
    -op| --opcion   Mayúsculas:=upper, Minúsculas:=lower
    -v | --version  Muestra la version del script y sale
    -h | --help     Muestra el menú de ayuda y sale del script

Examples:

   lowertoupper --texto "texto de ejemplo" --option upper
EOF
printf $reset
}
#=================================================================
if [ -z "$1" ]; then banner; help
else
while [ -n "$1" ]
do
 case "$1" in
  -t |--texto) #
    text="$2"; shift ;;
  -op|--opcion)
    op="$2"; shift ;;
  -v | --version)
    banner;info; shift ;;
  -h |--help) # help
    banner;help; shift ;;
   *) echo -e "Opción ${red}$1${reset} no reconizida." ;;
 esac
shift
done
fi
#=================================================================
if [[ -n "$text" && -n "$op" ]]
then
  case "$op" in
    upper|UPPER|U|u)
      main "$text" '[:lower:]' '[:upper:]';;
    lower|LOWER|L|l) #
      main "$text" '[:upper:]' '[:lower:]';;
     *) echo -e "Opcion ${red}${op}${reset} no reconizida.";;
 esac
elif [[ -z "$text" && -n "$op" ]]
then
  case "$op" in
    upper|UPPER|U|u)
      main "mucielago" '[:lower:]' '[:upper:]';;
    lower|LOWER|L|l) #
      main "MURCIELAGO" '[:upper:]' '[:lower:]';;
     *) echo -e "Opcion ${red}${op}${reset} no reconizida.";;
 esac
fi
#=================================================================
