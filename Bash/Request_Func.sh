request() {
  local link="$2"
  
  case $1 in
    -b|-body)
       local amam=$(curl -sS "$link")
       echo "$amam"
     ;;
     -h|-headers)
       local amam=$(curl -I "$link")
       echo "$amam"
     ;;
  esac
}
