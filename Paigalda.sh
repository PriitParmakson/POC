#!/bin/bash

# Puhastan võtmekaustad
cd ../CA
rm *
rm ../serverKeys/Keystore/*
rm ../serverKeys/Truststore/*
rm ../clientKeys/Keystore/*
rm ../clientKeys/Truststore/*

# Moodustan TARA-Mutual-CA
echo Moodustan TARA-Mutual-CA
openssl req -new \
  -x509 -days 365 \
  -keyout TARA-Mutual-CA.key \
  -out TARA-Mutual-CA.crt \
  -subj /C=/ST=/O=/CN=TARA-Mutual-CA \
  -nodes \
  > /dev/null

echo Moodustatud sert:
openssl x509 -in TARA-Mutual-CA.crt -noout -subject

# Genereerin TARA-Mutual-Server-i võtmepaari ja serdipäringu
echo Genereerin TARA-Mutual-Server-i võtmepaari ja serdipäringu
openssl req -new \
  -out TARA-Mutual-Server.csr \
  -newkey rsa:2048 \
  -nodes \
  -keyout TARA-Mutual-Server.key \
  -subj /CN=localhost \
  > /dev/null

# Genereerin TARA-Mutual-Server-i serdi
echo Genereerin TARA-Mutual-Server-i serdi
openssl x509 -req -days 365 \
  -in TARA-Mutual-Server.csr \
  -CA TARA-Mutual-CA.crt \
  -CAkey TARA-Mutual-CA.key \
  -CAcreateserial \
  -out TARA-Mutual-Server.crt \
  > /dev/null

echo Kontrolli sert:
openssl x509 -in TARA-Mutual-Server.crt -noout -subject

# Genereerin TARA-Mutual-Client-i võtmepaari ja serdipäringu
echo Genereerin TARA-Mutual-Client-i võtmepaari ja serdipäringu
openssl req -new \
  -out TARA-Mutual-Client.csr \
  -newkey rsa:2048 \
  -nodes \
  -keyout TARA-Mutual-Client.key \
  -subj /CN=localhost \
  > /dev/null

# Genereerin TARA-Mutual-Client-i serdi
echo Genereerin TARA-Mutual-Client-i serdi
openssl x509 -req -days 365 \
  -in TARA-Mutual-Client.csr \
  -CA TARA-Mutual-CA.crt \
  -CAkey TARA-Mutual-CA.key \
  -CAcreateserial \
  -out TARA-Mutual-Client.crt \
  > /dev/null

echo Moodustatud sert:
openssl x509 -in TARA-Mutual-Client.crt -noout -subject

# Paigaldan moodustatud krüptomaterjali kasutamiskaustadesse
# TARA-Mutual-Server-i võtmed
cp TARA-Mutual-Server.key ../serverKeys/Keystore/TARA-Mutual-Server.key
cp TARA-Mutual-Server.crt ../serverKeys/Keystore/TARA-Mutual-Server.crt
# TARA-Mutual-Client-i võtmed
cp TARA-Mutual-Client.key ../clientKeys/Keystore/TARA-Mutual-Client.key
cp TARA-Mutual-Client.crt ../clientKeys/Keystore/TARA-Mutual-Client.crt
# Paigaldan usaldusankrud
cp TARA-Mutual-CA.crt ../serverKeys/Truststore/TARA-Mutual-CA.crt 
cp TARA-Mutual-CA.crt ../clientKeys/Truststore/TARA-Mutual-CA.crt 

# Esitan kokkuvõtte
cd ..
echo Võtmed on paigaldatud
tree

# Paigaldan Node.js teegid
npm init
npm install express --save
npm install request --save

echo
echo Node.js teegid paigaldatud
echo