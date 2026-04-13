for (let i = 0; i < 8; i++) {
  fetch("https://discord.com/api/webhooks/1485051491709489202/ujP5hXiuaUss9JxxpUZnP4pLkg2ihTFuF6MOP8PSLxrZlu-WJW34_5zKjILxbi1rDjHa", {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({
      "username": "Test",
      "content": ("a").repeat(2000)
    })
  })
}
console.log("finished")
