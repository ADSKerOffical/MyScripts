# итерация чисел

for i in {1..5}; do
    echo "Iteration $i"
done

# проверка

bol=true # обязательно слитно
if [[ "$bol" == "true" ]]; then
  echo "True"
fi

# цикл

count=1
while [ $count -le 5 ]; do
    echo "Count is $count"
    ((count++))
done
