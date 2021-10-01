#!/bin/bash
reset="\\e[0m"
red="\\e[31;1m"
green="\\e[32;1m"
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
       8888888888            888    d88' '88b d88' '88b  888
       888    888           o888o   'Y8bod8P' 'Y8bod8P' o888o
       888    888
       888    888       signboard -- github.com/cristophgaray
EOF
printf $reset
}
#=================================================================
function info(){
printf $green
cat <<- 'EOF'

 Tittle:       signboard
 Autor:        Cristofer Garay
 Description:  Crea un letrero con caracteres que uno elija y
               el texto que uno le ingreso centrado
EOF
  echo -e " Version:      $version\n"
printf $reset
}
#=================================================================
function help(){
printf $green
cat <<- 'EOF'

Use:
     signboard  [Options]

Options:

    -n | --num   Tamaño del letrero
    -t | --text  Texto que mostrara el letrero
    -c | --char  Carácter para crear los marcos
    -id          Identificador center line o
                 no center line

                 [cl]:  [C]enter [L]ine
                 [ncl]: [N]o [C]enter [L]ine

    -h | --help  muestra la ayuda del script y sale

Examples:

   signboard -t " Test Text " -c "x" -id ncl -n 51

EOF
printf $reset
}
#================================================================================
if [ -z "$1" ]; then banner; help
else
  while [ -n "$1" ]
  do
   case "$1" in
    -n| --num)  N="$2";       shift ;;
    -t| --text) txt="$2";     shift ;;
    -c| --char) chr="$2";     shift ;;
    -h| --help) banner; help; shift ;;
    -id)        id="$2";      shift ;;
   esac
   shift
  done
fi
#================================================================================
if [[ -n "$txt" || -n "$N" ||  -n "$chr" ||  -n "$id"  ]]
then
  if [ -z "$txt" ]; then txt=" Default Text "; fi
  if [ -z "$N" ]; then N=80
  elif [[ -n "$N" && -n "$txt"  && $N -le ${#txt} ]]
  then N=$(( ${#txt} + 2  )); fi
  if [ -z "$chr" ]; then chr="="; fi
  if [ -z "$id" ]; then id="ncl"; fi
  line=$(for ((i=1; i<=$N; i++)); do echo -n "${chr:0:1}"; done)
  nL=$(($(($N-${#txt}))/2))
  nR=$(($nL+${#txt}))
  if [[ -n "$id" && "$id" == "cl"  ]]
  then
    L=$(for ((i=1; i<$nL; i++)); do echo -n "${chr:0:1}"; done)
    R=$(for ((i=$nR; i<=$N; i++)); do echo -n "${chr:0:1}"; done)
    echo "$line"
    echo "${L}${txt}${R}"
    echo "$line"
  elif [[ -n "$id" && "$id" == "ncl"  ]]
  then
    L=$(for ((i=1; i<=$(( $nL - 1 )); i++)); do echo -n " "; done)
    R=$(for ((i=$nR; i<$(( $N - 1 )); i++)); do echo -n " "; done)
    echo "$line"
    echo "${chr:0:1}${L}${txt}${R}${chr:0:1}"
    echo "$line"
  fi
fi
#================================================================================
 unset N txt chr id nL nR L R help