import sys, os, http.client, ipaddress, json, socket, ssl
if len(sys.argv) >= 3:
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
    print(f"   PTR: {"reverse_pointer" in ip and ip.reverse_pointer or "не найдено"}")
    
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
    
    newinfo = {}
    
    try:
       req = http.client.HTTPSConnection(arg)
       req.request("GET", "/")
       server = req.getresponse().getheader("Server")
       req.close()
    except Exception as am:
       pass
       
    try:
       context = ssl.create_default_context()
       with socket.create_connection((arg, 443)) as sock:
          with context.wrap_socket(sock, server_hostname=arg) as ssock:
             request = f"GET / HTTP/1.1\r\nHost: {arg}\r\nConnection: close\r\n\r\n"
             ssock.send(request.encode())
             
             peer = ssock.getpeercert()
             newinfo["s_ver"] = ssock.version()
             newinfo["alpn"] = str(ssock.selected_alpn_protocol())
             newinfo["cipher"] = ssock.cipher()
             newinfo["subject"] = peer.get("subject")
             newinfo["issuer"] = peer.get("issuer")
    except Exception as am:
       print(am)
    
    print("Информация об домене " + arg + ": ")
    print(f"   Айпи адрес сайта: {amam}")
    print(f"   Домен сайта (FQDN): {socket.getfqdn(amam)}")
    print(f"   CIDR: {ipaddress.ip_network(amam).supernet()}")
    print(f"   Сервер: {server}")
    
    if newinfo:
       print(f"   Версия сокета: {newinfo["s_ver"]}")
       print(f"   ALPN: {newinfo["alpn"] is None and "не обнаружено" or newinfo["alpn"]}")
       print(f"   Шифр: {newinfo["cipher"]}")
       print(f"   Субъект: {newinfo["subject"]}")
       print(f"   Издатель: {newinfo["issuer"]}")
    else:
       print("Not found")
    print(asninfo)
  elseif mode == "pnumber":
     import phonenumbers
     from phonenumbers import geocoder, carrier
     pnumber = arg.translate(str.maketrans("", "", "()- "))
     
     if pnumber[:1] != "+":
        pnumber = "+" + pnumber
     
     phonenumber = phonenumbers.parse(arg)
     
     print(dir(phonenumber))
