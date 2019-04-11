# Bika OpenHIM

Provide proof-of-concept to connect to OpenHIM API 
via python

A working OpenHIM installation with valid admin user is assumed.

## Prerequisites
```
python3
virtualenv
CA certificates  - normally at /etc/ssl/certs/ca-certificates.crt
```

## The setup_bika.openhim.sh script

1.  sets up the environment and
installs further packages with pip from `requirements.txt`, then

2.  calls setup script `make_cert.sh` to create the local certificate.
  - Creates a virtual environment `VENV` 
  - Retrieves the OpenHIM server's certificate via unverified https 
  - Retrieves root certificate from letsencrypt.org if not available locally
  - Concatenates certificates for authentication
  - Verifies the new certificate

3. Use python script `test_auth_cert.py` with the newly created certificate 
   to make an API call to the OpenHIM server to retrieve eg. channels. 
   
   ``` 
    USERNAME='test@bikalabs.com'
    PASSWORD='test123'
    API_URL = 'https://openhim.froidio.org:8008/authenticate' 
   ```
   (Note API port differs from the default OpenHIM port of 8080).

# Installation
  -  Clone repo to preferred folder
  -  Configure `make_cert.sh` variables (defaults shown)  
     ```   
        OPENHIM_CERT=openhim.cert   
        LETSENCRYPT_CERT=letsencrypt.cert
        CA_CERT=/etc/ssl/certs/ca-certificates.crt
        MYCERT=my.cert
    ```
  - Configure `test_auth_cert.py` variables `USERNAME, PASSWORD, API_URL, CERT` if needed
  - Run `make` (or `./setup_bika.openhim.sh`)
  - Run `make clean` to delete certificates
  - Run `make distclean` to delete VENV directory and certificates

