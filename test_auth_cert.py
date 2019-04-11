import requests
import datetime
import hashlib
import os

import urllib3
urllib3.disable_warnings()

#from requests import *

USERNAME='test@bikalabs.com'
PASSWORD='test123'

API_URL = 'https://openhim.froidio.org:8008/authenticate'
CERT=os.getcwd() + '/my.cert'

REQ = API_URL + '/' + USERNAME

req = requests.get(REQ,
            verify=CERT,
            )

#print( req.status_code);
#print( req.text);
body = req.json()
salt=body['salt']
ts=body['ts']
#print("Salt:%s"%salt);
#print("ts:%s"%ts);


if not salt:
    raise Exception(
        "User %s has not been authenticated. Please use the .authenticate() function first"%USERNAME
    )

sha = hashlib.sha512()

hashstring = salt + PASSWORD

#sha.update("{salt + PASSWORD}".encode('utf-8'))
sha.update(hashstring.encode('utf-8'))
password_hash = sha.hexdigest()

sha = hashlib.sha512()
now = str(datetime.datetime.utcnow())

sha_update = password_hash + salt + ts
sha.update( sha_update.encode('utf-8'))
#print("DEBUG:" f"{password_hash + salt + ts}".encode('utf-8'))
token = sha.hexdigest()

#print("Token %s"%token)


#
# curl -k -H "auth-username: $username" -H "auth-ts: $ts" -H "auth-salt: $salt" -H "auth-token: $token" $@;
#

headers = {"auth-username": USERNAME,
           "auth-ts": ts,
           "auth-salt": salt,
           "auth-token": token}

channels =  requests.get('https://openhim.froidio.org:8008/channels',
        auth=(USERNAME, PASSWORD),
        #auth=('test@bikalabs.com', 'test123'),
        headers=headers,
        #verify=False,
        verify=CERT
        )

#print(channels.status_code)
#print(channels.text)
print(channels.json())




