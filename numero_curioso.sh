clear -T $TERM
green="\e[32;1m"
red="\e[31;1m"
yellow="\e[33;1m"
white="\e[1m"
reset="\e[0m"
version="1.0.1v"
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
       888    888  [N]úmero [C]urioso -- github.com/cristophgaray

EOF
printf $reset
}
#=================================================================
function info(){
printf $green
cat <<- 'EOF'

 Tittle:       Número Curioso
 Autor:        Cristofer Garay
EOF
echo -e " Version:      $version\n"
cat <<- 'EOF'  
 Description:  Número curioso: todo número natural "n" que
               cumple que n^2 tiene al propio "n" como última
               cifra

               Por ejemplo:
               
                 5 : 5^2 = 25 | 2{5} : 5 
               
               5 es un número curiosos.

                 25 : 25^2 = 625 | 6{25} : 25
               
               25 es un número curioso.
                
EOF
printf $reset
}
#=================================================================
function help(){
printf $green
cat <<- 'EOF'

  Uso:

     numero_curioso [Opciones]

  Opciones

    -n | --number     Número a probar
    -i | --info       Muestra la versión del script y
                      la informacion a cerca del número curioso
                      y sale del scritp
    -h | --help       Muestra la ayuda del script y sale

   Ejemplo

   numero_curioso --number 6
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
   *) echo -e "${red}Opcion $1 no reconizida.${reset}" ;;
 esac
shift
done
#=================================================================
if [[ -n "$num" && "$num" =~ ^[[:digit:]]+$ ]]
then
  l=${#num}           # logitud del número de entrada
  N=$(( $num * $num)) # número de entrada al cuadrado
  L=${#N}             # longitud del número de entrada al cuadrado
  inv=$(( $L - $l ))  # diferencia entre el L - l
  n=${N:$(( $L - $l )):$L}
  if [ $n -eq $num ]
  then
    echo "[${num}] : ${num}^2 = ${N} | " \
         "${N:0:$inv}[${N:$inv:$L}] : [${num}]"
    echo -e "\n${green}${num}${reset} es un número curioso"
  else
    echo -e "\n${green}${num}${reset} no es un número curioso"
  fi
fi
#=================================================================
