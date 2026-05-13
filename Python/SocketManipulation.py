import socket, ssl

context = ssl.create_default_context()
domain = "httpbin.org"

with socket.create_connection((domain, 443)) as sock:
    with context.wrap_socket(sock, server_hostname=domain) as ssock:
        request = f"GET /get HTTP/1.1\r\nHost: {domain}\r\nConnection: close\r\n\r\n" # ты можешь поменять значение хоста (тогда url и Host изменяться), но для TCP будет всё равно
        ssock.send(request.encode())
        
        r"""
       \r\n (это называется CRLF) – перенос на следующую строку для заголовков
       \r\n\r\n – конец блока заголовков
        """
        
        response, peer = b"", ssock.getpeercert()
        while True:
            data = ssock.recv(4096)
            if not data: break
            response += data
        print(response.decode())
        
        print("Версия сокета: ", ssock.version())
        print("ALPN: ", str(ssock.selected_alpn_protocol()))
        print("Шифр: ", ssock.cipher())
        print("Субъект: ", peer.get("subject"))
        print("Издатель: ", peer.get("issuer"))
        print("Имя хоста: ", ssock._sslobj.server_hostname)
        print("Сторона сервера: ", ssock._sslobj.server_side)
        print("Настройки: ", ssock._sslobj.context.options)
        print("Метод верификации: ", ssock._sslobj.context.verify_mode)
        print("Флаг хоста: ", ssock._sslobj.context._host_flags)
        print("Максимальная версия: ", ssock._sslobj.context.maximum_version)
        print("ID: ", ssock._sslobj.session.id)
        print("Время (с начала эпохи UNIX): ", ssock._sslobj.session.time)
        print("Продолжительность тикета: ", ssock._sslobj.session.ticket_lifetime_hint)
        # id, time, ticket_lifetime_hint, has_ticket
        # verify_mode, options, maximum_version, keylog_filename, session_stats, _host_flags
        # server_hostname, server_side, session (class), owner, version, verify_client_post_handshake (method), get_verified_chain, context (class)
