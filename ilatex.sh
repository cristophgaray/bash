#!/bin/bash
reset="\\e[0m"
red="\\e[31;1m"
blue="\\e[34;1m"
green="\\e[32;1m"
yellow="\\e[33;1m"
white="\\e[39;1m"
version="1.0.0v"
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
       888    888       ilatex -- github.com/cristophgaray
EOF
printf $reset
}
#=================================================================
function info(){
printf $green
cat <<- 'EOF'


 Tittle:       Texlive Installer (ilatex)
 Autor:        Cristofer Garay
 Description:  Instalación limpia y sencilla de todo lo necesario
               para principiantes en LaTex
EOF
  echo -e " Version:      $version\n"
printf $reset
}
#=================================================================
function help(){
printf $green
cat <<- 'EOF'

USE:

    ilatex  [Options]

Options

  -op| --option    [check]    revisa los paquetes que faltan
                   [save]     revisa y guarda la lista de los
                              paquetes que faltan

                   [install]  instala los paquetes que faltan

  -o | --out       Nombre del archivo salida
  -i | --info      Muestra la version e informacion del script
                   y sale
  -h | --help      Muetra el menudo de opciones y sale del script

Examples:

   ilatex --option save --out save-out.txt

EOF
printf $reset
}
#=================================================================
while [ -n "$1" ]
do
 case "$1" in
   -op| --option)
     opt="$2"; shift ;;
   -o | --out)
     out="$2"; shift ;;
   -i | --info) # version
     banner; info; shift ;;
   -h | --help) # help
     banner;help; shift ;;
   *) echo -e "${red}Opcion $1 no reconizida.${reset}" ;;
 esac
shift
done
#=================================================================
info(){
  declare -a list=('texlive-base' 'texlive-bibtex-extra' \
  'texlive-extra-utils' 'texlive-font-utils' 'texlive-fonts-recommended' \
  'texlive-formats-extra' 'texlive-lang-spanish' 'texlive-latex-base' \
  'texlive-latex-extra' 'texlive-latex-recommended' 'texlive-pictures' \
  'texlive-plain-generic' 'texlive-publishers' 'texlive-science' \
  'texlive-xetex');
  declare -a nlist
  for i in "${list[@]}"
  do  dpkg -l | grep -soq "$i"; test $? -eq 0 || nlist+=( "$i" )
  done
  line=$(for i in {1..50}; do echo -n "="; done)
  case "$1" in
    0)  echo "${nlist[@]}";;
    1)  $(echo "apt-cache show ${nlist[@]}") | \
        grep 'Package:\|Version:\|Depends:' | \
        sed 's/,/\n\t/g' | sed 's/\(Depends: \)/\1\n\t /g' | \
        sed "s/\(Package:\)/${line}\n\1/g";;
  esac
}
#=================================================================
if [[ -n "$opt" ]]
then
  case "$opt" in
    save|SAVE|s|S)
      if [ -z "$out" ]; then out="texlive-list.txt"; fi
      echo -e "${white}Creando el archivo: ${green}${out}${reset}"
      echo "los siguinetes paquetes son requeridos:" > $out
            info "1">> $out;;
    check|CHECK|c|C)
      echo -e "${white}los siguinetes paquetes son requeridos:${reset}"
      echo -e $(info "1"| sed "s/\([[:blank:]]\{2,\}\)/\1\\${green}/g" | \
      sed "s/$/\\${reset}\\\n/g" | \
      sed 's/: /: \\e[32;1m/g');;
    install|ins|I|i)
      echo -e "${white}Paquetes a instalar: ${reset}"
      echo -e $(echo "$( info "0" )" | \
      sed "s/[[:blank:]]/\n/g" | \
      sed "s/^/\\${green}/g" | \
      sed "s/$/\\${reset}\\\n/g")
      $(echo "sudo apt install $(info "0")");;
  esac
fi
#=================================================================
