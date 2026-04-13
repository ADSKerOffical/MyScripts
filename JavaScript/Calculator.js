function exf() {
  let a = prompt("Input your example")
  const sqrt = Math.sqrt
  const perc = (numb) => {return numb / 100}
  const inf = Infinity
  a = a.replace("^", "**")
  try {
    alert(eval(a))
  } catch {alert("Error in calculations")} finally {exf()}
}
exf()
