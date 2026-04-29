file_debug() {
  local path=$2
  local ext="${path##*.}"
  
  case $1 in
    -l|-list)
      echo "$ext"
      if [[ "$ext" == "apk" || "$ext" == "zip" ]]; then
        unzip -l "$path"
      else
        ls -a "$path"
      fi
    ;;
    -i|-info)
      local test=false
      
      if [[ $(whoami) == $(stat -c %U $path) ]]; then
        test=true
      fi
      
      echo "Permissions: $(stat -c %a $path)"
      echo "Inode (owner): $(stat -c %U $path)"
      echo "Is creator: $test"
      echo "Expansion: $ext"
      echo "Last change: $(stat -c %y $path)"
      echo "Size: $(stat -c %s $path)"
      echo "File id: $(stat -c %i $path)"
      echo "Full path: $(realpath $path)"
    ;;
    -asm|-assembly)
      local name="AssemblyCode_$(cat /dev/urandom | tr -dc 'a-z0-9' | head -c 10).s"
      g++ -S -masm=intel "$path" -o "$name"
      echo "Generated file with name $name"
    ;;
  esac
}

# -l | -list <path> <ext> – печатает все файлы в данном файле или папке. Можно указать с какими расширениями они должны быть (если не указано то все печатает)
# -s | -source – получает исходный код файла и сохраняет его в файл с заданным именем. Показывает сколько данный скрипт весит и потом скачивает его в терминал
# -i | -info (inode (owner), permissions, size, format, full_path, is_owner) – получает информацию о файле
# -asm | -assembly – получает ассемблер скрипт, сохраняя его в терминале с новым именем по типу AssemblyCode1.s
# -t | -touch – более удобный вариант touch, позволяя настроить содержимое файла
# -hget | -http_get – делает запрос по ссылке и создаёт файл в терминале с содержимым Body ссылки и расширением (если расшифрения нету, то автоматически будет расширение txt)
