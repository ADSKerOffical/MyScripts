import os, sqlite3

dp_path = os.path.join("/sdcard/Download", "table_test.db")
conn = sqlite3.connect(dp_path)
comand = conn.cursor()

try:
    comand.execute("""
      CREATE TABLE IF NOT EXISTS Users (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         name TEXT NOT NULL,
         age INTEGER
      )
    """)
except sqlite3.Error as e:
    print(f"Internal error: {e}")
    conn.close()

def insert(name, age):
   try:
      comand.execute("INSERT INTO Users (name, age) VALUES (?, ?)", (name, age))
      conn.commit()
   except sqlite3.IntegrityError as e:
      print(f"Unexpected error: {e}")
   except Exception as Error:
      print(f"Internal error occured: {Error}")
      
def get_by_id(id: int):
    try:
        comand.execute(f"SELECT name, age FROM Users WHERE id = ?;", (id,))
        result = comand.fetchone()
        
        if not result is None:
            return result[0]
        else:
            return None
    except Exception as e:
        print(f"Error occured: {e}")
        
def delete(id: int):
    try:
        comand.execute(f"DELETE FROM Users WHERE id = ?;", (id,))
        conn.commit()
    except Exception as e:
        print(f"Error occured: {e}")
        
def size():
    try:
        comand.execute("SELECT COUNT() FROM Users")
        return comand.fetchone()[0]
    except Exception as e:
        print(e)
        return None

#insert("Denis", 15)
#insert("ADSKer", 66)
#insert("Abdul", 43)

comand.execute("SELECT id, name, age FROM Users")
all_users = comand.fetchall()
#delete(18)
print(get_by_id(18)) # None, потому что я удалил элемент
print(size())

for user in all_users:
   print(user)
