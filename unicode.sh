#!/bin/bash
reset="\\e[0m"
red="\\e[31;1m"
green="\\e[32;1m"
version="1.0.0v"
clear -T $TERM
#=================================================================
function percent(){
  local scp=('2b' '2f' '3f' '5b' '5d' '40' '24' '26')
  local nscp=('25' '20' '21' '23' '28' '29' '2a' '2c' '3b' '3d' '22'\
              '7b' '7d' '7c' '3c' '3e')
  local acvo=('\xc3\xa1' '\xc3\xa9' '\xc3\xad' '\xc3\xb3' '\xc3\xba' '\xc2\xbf' \
               '\xc2\xb0' '\xc2\xac' '\xc2\xa8')
   echo -n "$1 \"$2\" | "
   for i in "${nscp[@]}"; do echo -ne "sed 's/\x$i/%$i/g' | "; done
   for i in "${scp[@]}"; do echo -en "sed 's/\\\\\x$i/%$i/g' | "; done
   for i in "${acvo[@]}"
   do a=$(echo "$i" | sed 's/\\x/%/g'); echo -ne "sed 's/$i/$a/g' | "; done
      echo "sed -e s/\'/%27/g"
}
#=================================================================
utf(){
  if [[ -n "$4" ]]
  then  "$1" "$2" | od -An -"$3" | sed "s/[[:blank:]]/$4/g" | \
       sed ':a;N;$!ba;s/\n//g'
   else
      "$1" "$2" | od -An -"$3" | sed ':a;N;$!ba;s/\n//g' | \
      sed 's/[[:blank:]]\{2,\}/ /g'
  fi
}
#=================================================================
function dec2hex(){
 printf "%x" "$1" | sed 's/^a$/0a/g' | sed 's/^/\\x/g'
}
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
       888    888
EOF
printf $reset
}
#=================================================================
function info(){
printf $green
cat <<- 'EOF'

 Tittle:       unicode
 Autor:        Cristofer Garay
 Description:  Unicode Converter - Decimal,
               text, URL, and unicode converter
EOF
  echo -e " Version:      $version\n"
printf $reset
}
#=================================================================
function help(){
printf $green
cat <<- 'EOF'

USE:
    unicode  [Options]

Options

    -op | --option  decoder/encoder
    -c  | --code    utf8|utf16|utf32|u8|u16|u32
                    percent|%
                    decimal|dec
    -t  |  --text   input text
    -f  |  --file   input file
    -h  | --help

Examples:

     UTF-8 (Example: \u61\u4e\u2d\u04\u2f)
      unicon --option decoder --code utf8 --file filename.txt

     UTF-16 (Example: \u0061\u4e2d\u042f)
      unicon --option encoder --code utf16 --text "input text"

     UTF-32 (Example: u+00000061u+00004e2du+0000042f)
      unicon -op decoder -c u32 -f filename.txt

     Percent Encoding (Example: a%20%e4%b8%ad%20%d0%af)
      unicon -op encoder -c % -t "inpout text"

     Decimal (Example: 97 20013 1071)
      unicon -op encoder -c dec -t "inpout text"

EOF
printf $reset
}
#=================================================================
if [ -z "$1" ]; then banner; help
else
while [ -n "$1" ]
do
 case "$1" in
  -f| --file)
    name="$2"; shift ;;
  -t| --text)
    text="$2"; shift ;;
  -op|--option)
    opt="$2"; shift ;;
  -c|--code)
     code="$2"; shift ;;
  -h| --help) # help
    banner;help; shift ;;
   *) echo -e "${red}Opcion $1 no reconizida.${reset}" ;;
 esac
shift
done
fi
#=================================================================
if [[ -n "$opt" && "$opt" == "encoder" && -n "$code" ]]
then
  case "$code" in
    percent|P|p|per|%)
      if [[ -n "$name" && -e "$name" ]]
      then  bash <(percent "cat" "$name")
      elif [[ -n "$text" ]]
      then  bash <(percent "echo" "$text")
      fi ;;
    utf8|8|U8|u8)
      if [[ -n "$name" && -e "$name" ]]
      then  utf "cat" "$name"  "tx1" "\\\x"
      elif [[ -n "$text" ]]
      then  utf "echo" "$text" "tx1" "\\\x"
      fi ;;
    utf16|16|U16|u16)
      if [[ -n "$name" && -e "$name" ]]
      then  utf "cat" "$name"  "tx1" "\\\u00"
      elif [[ -n "$text" ]]
      then  utf "echo" "$text" "tx1" "\\\u00"
      fi ;;
    utf32|32|U32|u32)
      if [[ -n "$name" && -e "$name" ]]
      then  utf "cat" "$name"  "tx1" "u+000000"
      elif [[ -n "$text" ]]
      then  utf "echo" "$text" "tx1" "u+000000"
      fi ;;
    dec|10|D|d)
      if [[ -n "$name" && -e "$name" ]]
      then  utf "cat" "$name"  "tu1"
      elif [[ -n "$text" ]]
      then  utf "echo" "$text" "tu1"
      fi ;;
    esac
elif [[ -n "$opt" && "$opt" == "decoder"  ]]
then
  case "$code" in
    percent|P|p|per|%)
      if [[ -n "$name" && -e "$name" ]]
      then  echo -e "$(sed 's/%/\\x/g' $name)"
      elif [[ -n "$text" ]]
      then  echo -e "$(echo $text | sed 's/%/\\x/g')"
      fi ;;
    utf8|8|U8|u8)
      if [[ -n "$name" && -e "$name" ]]
      then  echo -e "$(cat $name)"
      elif [[ -n "$text" ]]
      then  echo -e "$text"
      fi ;;
    utf16|16|U16|u16)
      if [[ -n "$name" && -e "$name" ]]
      then  echo -e "$(sed 's/\u00/\x/g' $name)"
      elif [[ -n "$text" ]]
      then  echo -e "$(echo $text | sed 's/\u00/\x/g')"
      fi ;;
    utf32|32|U32|u32)
      if [[ -n "$name" && -e "$name" ]]
      then  echo -e "$(sed 's/u+000000/\\x/g' $name)"
      elif [[ -n "$text" ]]
      then  echo -e "$(echo $text | sed 's/u+000000/\\x/g')"
      fi ;;
    dec|10|D|d)
      if [[ -n "$name" && -e "$name" ]]
      then
        echo -e "$(cat "$name" | sed 's/[[:blank:]]/\n/g' | \
        while read line; do
          dec2hex "$line"
       done)"
      elif [[ -n "$text" ]]
      then
        echo -e "$(echo "$text" | sed 's/[[:blank:]]/\n/g' | \
        while read line; do
          dec2hex "$line"
       done)"
      fi ;;
  esac
fi
#=================================================================
unset reset red green version  scp nscp acvo a utf dec2hex \
banner info help name text opt code
