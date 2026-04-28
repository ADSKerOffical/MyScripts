if [[ $EUID == 0 || "$(whoami)" == "root" ]]; then
  echo "У тебя есть рут права"
else
  echo "У тебя нету рут прав"
fi
