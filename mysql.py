#!/usr/bin/python

import pymysql.cursors

dbhost = ""
dbport = ""
dbuser = ""
dbpass = ""
dbname = ""
dbchar = ""

connection = "";

class MySQL:
    def __init__(self, dbhost, dbport, dbuser, dbpass, dbname, dbchar):
        self.dbhost = dbhost
        self.dbport = dbport
        self.dbuser = dbuser
        self.dbpass = dbpass
        self.dbname = dbname
        self.dbchar = dbchar
        self.connection = pymysql.connect(host=dbhost,user=dbuser,password=dbpass,db=dbname,charset=dbchar,cursorclass=pymysql.cursors.DictCursor)

    # SELECT all rows
    def queryAll(self, sql):
        try:
            self.connection.cursor().execute(sql)
            return self.connection.cursor().fetchall()
        except:
            print('error/exception')

    # SELECT one row
    def query(self, sql):
        try:
            self.connection.cursor().execute(sql)
            return self.connection.cursor().fetchone()
        except:
            print('error/exception')

    # INSERT, UPDATE, DELETE
    def update(self, sql):
        try:
            self.connection.cursor().execute(sql)
            return self.connection.cursor().lastrowid
        except:
            print('error/exception')

# DEBUG
if __name__ == "__main__":
    db = MySQL('localhost', '3306', 'root', '', 'test', 'utf8')
    res = db.queryAll('SELECT * FROM reisen')
    print(res)
    print(res[0].get("ziel"))
    #print(str(res['ziel']))
