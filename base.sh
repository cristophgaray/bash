#!/bin/bash
reset="\\e[0m"
red="\\e[31;1m"
blue="\\e[34;1m"
green="\\e[32;1m"
yellow="\\e[33;1m"
white="\\e[39;1m"
version=""
clear -T $TERM
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
       888    888       NameTool -- github.com/cristophgaray
EOF
printf $reset
}
#=================================================================
function info(){
printf $green
cat <<- 'EOF'

 Tittle:       
 Autor:        Cristofer Garay
 Description:  
EOF
  echo -e " Version:      $version\n"
printf $reset
}
#=================================================================
function help(){
printf $green
cat <<- 'EOF'

USE:
    NameTool  [Options]

Options

    -o | --out
    -v | --version
    -h | --help

Examples:

EOF
printf $reset
}
#=================================================================
if [ -z "$1" ]
then banner; help
else
  while [ -n "$1" ]
  do
   case "$1" in
    -o| --out)
      out="$2"; shift ;;
    -v| --version) # version
      banner; info; shift ;;
    -h| --help) # help
      banner;help; shift ;;
     *) echo -e "${red}Opcion $1 no reconizida.${reset}" ;;
   esac
  shift
  done
fi
#=================================================================
function main(){
}
