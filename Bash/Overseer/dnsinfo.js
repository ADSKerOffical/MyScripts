const domain = process.argv[2]
let dns = require("dns")

dns.resolveMx(domain, (err, mail) => {
   if (err) { console.log("    MX: не обнаружен"); return err };
   console.log("MX: ", mail.map(r => r.exchange).values().next().value);
});

dns.resolve6(domain, (err, ips) => {
  if (err) { console.log("    AAAA: не обнаружен"); return err };
  console.log("AAAA: ", ips[0])
});

dns.resolveNs(domain, (err, mail) => {
   if (err) { console.log("    NS: не обнаружен"); return err };
   console.log("NS: ", mail[0]);
});

dns.resolveSoa(domain, (err, mail) => {
   if (err) { console.log("    SOA: не обнаружен"); return err };
   console.log("SOA: ", mail["hostmaster"]);
});

dns.resolveTxt(domain, (err, mail) => {
  if (err) { console.log("    TXT: не обнаружен"); return err };
  console.log("TXT: ", mail)
});
