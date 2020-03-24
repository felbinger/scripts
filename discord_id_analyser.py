import sys
import datetime
import time

# this script can be used to analyse discord user id's to extract the information when the account has been created 

def info(text):
    try:
        text = int(text)
    except:
        print("Invalid ID.")
        return

    text = bin(text)
    text = text[0:len(text)-22]
    text = int(text, 2)
    text = text + 1420070400000
    text = text / 1000
    utc_time = datetime.datetime.utcfromtimestamp(text)
    germany_time = datetime.datetime.fromtimestamp(text)
    print("Format:   DD-MM-YYYY HH:MM:SS")
    print("Timstamp: {0:0>2}.{1:0>2}.{2:0>4} {3:0>2}:{4:0>2}:{5:0>2}.{6} GMT".format(utc_time.day, utc_time.month, utc_time.year, utc_time.hour, utc_time.minute, utc_time.second, utc_time.microsecond))
    print("Timstamp: {0:0>2}.{1:0>2}.{2:0>4} {3:0>2}:{4:0>2}:{5:0>2}.{6} in Germany".format(germany_time.day, germany_time.month, germany_time.year, germany_time.hour, germany_time.minute, germany_time.second, germany_time.microsecond))


if __name__ == "__main__":
    info(input("ID: "))

