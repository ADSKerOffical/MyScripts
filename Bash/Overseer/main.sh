#!/! /bin/bash

function overseer {
   case $1 in
      -str|-string)
         case $2 in
            -e|-encode)
               curl -fsSL --connect-timeout 8 'https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Bash/Overseer/EncodeOrDecode.py' | python3 - "$3" "$4" false
            ;;
            
            -d|-decrypt)
              curl -fsSL --connect-timeout 8 'https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Bash/Overseer/EncodeOrDecode.py' | python3 - "$3" "$4" true
            ;;
            
            -r|-random)
              local length=${3:-10}
              cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c "$length"; echo
            ;;
            
            -a|-alaphet)
              python -c 'import string; print(string.ascii_letters)'
            ;;
         esac
      ;;
      
      -math)
        case $2 in
          -c|-calc|-calculate)
            curl -fsSL --connect-timeout 8 https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Bash/Overseer/math.lua | lua - "$3"
          ;;
          
          -bc)
            echo "scale=4; $3" | bc
          ;;
        esac
      ;;
      
      -f|-files)
        case $2 in
           -c|-cat|-read)
              if file -b "$3" | grep -q "ELF"; then
                 strings "$3"
              else
                 cat "$3"
              fi
           ;;
           
           -h|-head)
              head "$3"
           ;;
           
           -u|-unpack|-unzip)
             local filename="$3"
             local extension="${filename##*.}"
             
             if [[ "$extension" == "zip" || "$extension" == "apk" ]]; then
                unzip -l "$filename"
             fi
           ;;
           
           -uid|-search_uid)
              echo "$(id -nu "$3")"
           ;;
           
           -s|-stats)
             local FileName="$3"
             if [ ! -f "$FileName" ]; then echo "Файл с именем "$3" не существует"; return 1; fi
             
             function entropy {
             od -An -v -t u1 "$FileName" \
            | tr -s ' \t' '\n' \
            | awk 'NF{ cnt[$1]++; total++ }
             END {
             if (total==0) { print "0.000000"; exit }
              e=0
              for (b in cnt) { p = cnt[b]/total; e -= p * (log(p)/log(2)) }
                 printf "%.6f\n", e
               }'
               }
             
             echo "Владелец: $(stat -c %U "$FileName")"
             echo "Разрешения: $(stat -c %a "$FileName")"
             echo "Размер файла в байтах: $(wc -c < "$FileName")"
             echo "Тип: $(stat -c %F "$FileName")"
             echo "Кодировка: $(file -b "$FileName")"
             echo "Путь: $(realpath "$FileName")"
             echo "Inode: $(stat -c %i "$FileName")"
             echo "Энтропия: $(entropy)"
             echo "SHA256: $(sha256sum "$FileName" | grep " " | awk '{print $1}')"
             echo "Последний раз редактировался: $(stat -c %z "$FileName")"
           ;;
        esac
      ;;
      
      -web|-w)
         case $2 in
           -d|-domain)
              local tmp_name="$(mcookie).py"
              curl -fsSL --connect-timeout 8 "https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Bash/Overseer/PyScript.py" -o "$tmp_name" && {
                 python3 -u "$tmp_name" "$3" domain
                 rm "$tmp_name"
               } || rm -f "$tmp_name" 2>/dev/null

              local url="https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Bash/Overseer/dnsinfo.js"
              curl -fsSL --connect-timeout 8 "$url" | node - "$3"
           ;;
           
           -i|-ip)
              if [[ "$3" == "" ]]; then
                 local myip=$(curl -s https://api.ipify.org?format=text)
                 curl -fsSL --connect-timeout 8 "https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Bash/Overseer/PyScript.py" | python3 - "$myip" ip
              else
                 curl -fsSL --connect-timeout 8 "https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Bash/Overseer/PyScript.py" | python3 - "$3" ip
              fi
           ;;
           
           -pnumber|-phonenumber)
              curl -fsSL --connect-timeout 8 "https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Bash/Overseer/PyScript.py" | python3 - "$3" pnumber
           ;;
           
           -wget|-savebody)
             curl -so --connect-timeout 10 "$4" "$3"
           ;;
         esac
      ;;
      
      -self|-sys)
         echo "Имя пользователя: $(whoami) ("$UID")"
         echo "Имя ОС: $(uname -s) $(uname -o) $(getprop ro.build.version.release)"
         echo "Имя хоста: $(hostname)"
         echo "Архитектура: $(uname -m)"
         echo "Релиз: $(uname -r)"
         echo "Дата выпуска: $(uname -v)"
         echo "Разрядность системы: $(getconf LONG_BIT)"
         echo "Количество процессоров: $(getconf _NPROCESSORS_CONF)"
         echo "RAM в килобайтах: $(cat /proc/meminfo | grep MemTotal | awk '{print $2}')"
         echo "Время работы системы: $(uptime)"
         echo "Регион устройства: $(getprop ro.product.locale.region)"
         echo "CPU Abilist: $(getprop ro.vendor.product.cpu.abilist)"
         echo "Fingerprint: $(getprop ro.system.build.fingerprint)"
         echo "Сборка: $(getprop ro.product.manufacturer), $(getprop ro.product.product.marketname), $(getprop ro.product.product.model)"
         echo "Операторы: $(getprop gsm.sim.operator.alpha)"
         echo "Внутреннее имя устройства: $(getprop ro.product.device)"
         echo "Уровень SDK: $(getprop ro.build.version.sdk)"
         echo "Версия прошивки: $(getprop ro.build.version.incremental)"
         echo "Baseband: $(getprop gsm.version.baseband)"
         echo "Root ID: $(getprop partition.vendor_dlkm.verified.root_digest)"
      ;;
      
      -t|-terminal|-env)
        case $2 in
           -s|-source)
             if [[ $(type -t "$3") == function ]]; then
               declare -f "$3"
             elif [[ $(type -t "$3") == file ]]; then
               if file -b $(which unzip) | grep -q "ELF"; then
                  strings "$3"
               else 
                 cat "$3"
               fi
             elif [[ $(type -t "$3") == builtin ]]; then
               echo "Нельзя узнать исходный код встроенной команды"
             elif [[ $(type -t "$3") == alias ]]; then
               echo $(alias "$3")
             fi
           ;;
           -print)
             local text="$3"; local colorCode=${4:-37}
             echo -e "\033["$colorCode"m"$text"\033[0m"
           ;;
           -cmds|-commands_list)
             ppwo=$(compgen -c)
             echo "${ppwo//$'\n'/ }"
           ;;
           -c|-clear)
             clear
           ;;
           -close|-exit)
             exit "$3"
           ;;
        esac
      ;;
      
      --version)
        echo "1.0"
      ;;
      
      --help)
        curl -s --connect-timeout 10 https://raw.githubusercontent.com/ADSKerOffical/MyScripts/refs/heads/main/Bash/Overseer/docs.txt
      ;;
      
      -ex|-execute)
        case $2 in
           -py|-python)
             if [[ "$(command -v python3)" == "" ]]; then echo "Нет установленной команды python3 для осуществления данной операции"; return 1; fi
             if [ -f "$3" ]; then
               python3 "$3" "$@"
             else
               local random="$(mcookie).py"
               touch "$random" && echo "$3" > "$random"
               python3 "$random"
               rm "$random"
             fi
           ;;
           -c)
             if [[ "$(command -v gcc)" == "" ]]; then echo "Нет установленной команды gcc для осуществления данной операции"; return 1; fi
             if [ -f "$3" ]; then
               gcc "$3" -o temp_out_c && ./temp_out_c
               rm temp_out_c
             else
               local random="$(mcookie).c"
               touch "$random" && echo "$3" > "$random"
               gcc "$random" -o temp_out_c && ./temp_out_c
               rm temp_out_c; rm "$random"
             fi
           ;;
           -cpp)
             if [[ "$(command -v g++)" == "" ]]; then echo "Нет установленной команды g++ для осуществления данной операции"; return 1; fi
             if [ -f "$3" ]; then
               g++ "$3" -o temp_out_cpp && ./temp_out_cpp
               rm temp_out_cpp
             else
               local random="$(mcookie).cpp"
               touch "$random" && echo "$3" > "$random"
               g++ "$random" -o temp_out_cpp && ./temp_out_cpp && rm temp_out_cpp
               rm "$random"
             fi
           ;;
           -sh|-shell|-bash)
             if [ -f "$3" ]; then
               bash "$3"
             else
               bash -c "$3"
             fi
           ;;
           -java)
             if [[ "$(command -v javac)" == "" ]]; then echo "Нет установленной команды javac для осуществления данной операции"; return 1; fi
             if [ -f "$3" ]; then
               javac "$3" && java "{3%.java}"
             else
               local random="$(mcookie).java"
               touch "$random" && echo "$3" > "$random" $$ javac "$random" && java "{$random}.java"
               rm "$random"
             fi
           ;;
           -node|-njs)
             if [[ "$(command -v node)" == "" ]]; then echo "Нет установленной команды node для осуществления данной операции"; return 1; fi
             if [ -f "$3" ]; then
               node "$3" "$@"
             else
               local random="$(mcookie).js"
               touch "$random" && echo "$3" > "$random" && node "$random" "$@"
               rm "$random"
             fi
           ;;
           -lua)
             if [ -f "$3" ]; then
               lua "$3"
             else
               lua -e "$3"
             fi
           ;;
        esac
      ;;
   esac
}
