const domain = process.argv[2]
const dns = require("dns")
const net = require("net")

let fullResponse = "";

const client = net.createConnection({ host: "199.7.59.74", port: 43 }, () => {
  client.write(`${domain}\r\n`);
});

client.setEncoding("utf8");

client.on("data", (chunk) => {
  fullResponse += chunk;
});

client.on("end", () => {
  const regex = /(?:Creation Date|created):\s*(.+)/i;
  const match = fullResponse.match(regex);
  const match2 = fullResponse.match(/(?:Registry Domain ID|created):\s*(.+)/i);
  const match3 = fullResponse.match(/(?:Registrar|created):\s*(.+)/i);

  if ((match && match[1]) && (match2 && match2[1]) && (match3 && match3[1])) {
    const creationDate = match[1].trim();
    console.log(`    Дата создания: ${creationDate}`);
    console.log(`    Айди регистрации домена: ${match2[1].trim()}`);
    console.log(`    Регистратор: ${match3[1].trim()}`);
  } else {
    console.log(`    Дата создания: не найдено`);
    console.log(`    Айди регистрации домена: не  найдено`);
    console.log(`    Регистратор: не найдено`);
  }
});

dns.resolveMx(domain, (err, mail) => {
   if (err) { console.log("    MX: не обнаружен"); return err };
   console.log("    MX: ", mail.map(r => r.exchange).values().next().value);
});

dns.resolve6(domain, (err, ips) => {
  if (err) { console.log("    AAAA: не обнаружен"); return err };
  console.log("    AAAA: ", ips[0])
});

dns.resolveNs(domain, (err, mail) => {
   if (err) { console.log("    NS: не обнаружен"); return err };
   console.log("    NS: ", mail[0]);
});

dns.resolveSoa(domain, (err, mail) => {
   if (err) { console.log("    SOA: не обнаружен"); return err };
   console.log("    SOA: ", mail["hostmaster"]);
});

dns.resolveTxt(domain, (err, mail) => {
  if (err) { console.log("    TXT: не обнаружен"); return err };
  console.log("    TXT: ", mail)
});

dns.resolveSrv(domain, (err, mail) => {
  if (err) { console.log("    SRV: не обнаружен"); return err };
  console.log("    SRV: ", mail)
});
