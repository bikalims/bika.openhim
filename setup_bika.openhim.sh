#!/bin/bash


if [ ! -d VENV ]; then

    virtualenv -p python3 VENV

fi

source VENV/bin/activate

pip install -r requirements.txt

./make_cert.sh

python test_auth_cert.py


