import phonenumbers, requests, ipaddress, socket
from phonenumbers import carrier, geocoder

def osint(pnumbers="0", country="en"):
   try:
       pnm = str(pnumbers)
       pnm = pnm.replace(" ", "").replace("-", "")
       pars = phonenumbers.parse(pnm, country.upper())
    
       if phonenumbers.is_valid_number(pars):
         return {
            "operator": carrier.name_for_number(pars, country),
            "region": geocoder.description_for_number(pars, country)
          }
       else:
         print("Invalid phone number")
         return {}
   except Exception as error:
         ipadr = ipaddress.ip_address(pnumbers)
         ipreq = requests.Session().get(f"https://ipinfo.io/{pnumbers}/json").json()
         iptable = {}
         
         try:
           iptable["host"] = socket.gethostbyaddr(pnumbers)[0]
           iptable["fqdn"] = socket.getfqdn(iptable["host"])
         except socket.herror:
           iptable["host"] = "null"
           iptable["fqdn"] = "null"
         
         iptable["is-private"] = ipadr.is_private
         iptable["is-vpn"] = ipadr.is_global
         iptable["is-ipv4"] = ipadr.version == 4
         iptable["provider"] = ("org" in ipreq and ipreq["org"] or "not found")
         iptable["position"] = ("loc" in ipreq and ipreq["loc"] or "not found")
         iptable["region"] = ("city" in ipreq and (ipreq["country"] + " " + ipreq["region"] + " " + ipreq["city"]) or "not found")
         
         return iptable

an = osint("1.1.1.1")
for i in an:
    print(i, an[i])
