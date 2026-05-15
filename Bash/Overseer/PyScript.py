import sys, os, http.client, ipaddress, json, socket
if len(sys.argv) == 3:
  arg, mode = sys.argv[1], sys.argv[2]

  if mode == "ip" or mode == "ipaddress":
    ip, hsot = ipaddress.ip_address(arg), None
    ipinfo = http.client.HTTPSConnection("ipinfo.io"); ipinfo.request("GET", f"/{arg}/json"); ipinfo = json.loads(ipinfo.getresponse().read())
    
    try:
       hsot = str(socket.gethostbyaddr(arg)[0])
    except Exception as en:
       pass

    print("Информацию об айпи адресе " + arg + ": ")
    print(f"   Является приватным: {"да" if ip.is_private == True else "нет"}")
    print(f"   Является глобальным: {"да" if ip.is_global == True else "нет"}")
    print(f"   Предполагаемое местоположение: {"city" in ipinfo and (ipinfo["country"] + " " + ipinfo["city"] + " " + ipinfo["region"]) or "не известно"}")
    print(f"   ASN: {"org" in ipinfo and ipinfo["org"] or "не найдено"}")
    print(f"   Локация: {"loc" in ipinfo and ipinfo["loc"] or "не найдено"}")
    print(f"   Имеет домен: {hsot != None and "да (" + hsot + ")" or "нет"}")
    print(f"   CGNAT: {ip._constants._public_network}")
    print(f"   LLA: {ip._constants._linklocal_network}")
    
  elif mode == "domain" or mode == "host":
    amam, server, asninfo = socket.gethostbyname(arg), None, ""
    
    try:
       req = http.client.HTTPSConnection("rdap.db.ripe.net")
       req.request("GET", f"/ip/{amam}")
       response = json.loads(req.getresponse().read())
       asninfo = f"""
      Имя провайдера: {response["name"]}
      Тип провайдера: {response["type"]}
       """
    except Exception as am:
       pass
    
    try:
       req = http.client.HTTPSConnection(arg)
       req.request("OPTIONS", "/")
       server = req.getresponse().getheader("Server")
       req.close()
    except Exception as am:
       pass
    
    print("Информация об домене " + arg + ": ")
    print(f"   Айпи адрес сайта: {amam}")
    print(f"   Домен сайта (FQDN): {socket.getfqdn(amam)}")
    print(f"   CIDR: {ipaddress.ip_network(amam).supernet()}")
    print(f"   Сервер: {server}")
    print(asninfo)
  elif mode == "self":
    pass
