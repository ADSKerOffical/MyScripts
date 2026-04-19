import subprocess

"""
  можно использовать и os.system, но там сложнее получать код
  clear – очищает консоль
  ping httpbin.org – получает айпи адрес и пинг хоста
  help – получает все комманды

  curl https://httpbin.org/get – получает body ссылки
  curl -I https://httpbin.org/get – получает все заголовки ссылки
  
  при запуске команды возвращаются параметры:
    • args – то что запусается в команде
    • returncode – то что возвращает команда
"""

subprocess.run("clear", shell=True)
