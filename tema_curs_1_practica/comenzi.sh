#!/bin/bash

# Script pentru tema practica

echo "================================================="
echo "1. (Easy) Generate an SSH key pair using RSA and output the content of the files. (Research knowledge on the internet on how to create using RSA a SSH key pair)"
echo "================================================="
# Comanda pentru generarea cheilor (privată + publică) în folderul curent, fără parolă.
ssh-keygen -t rsa -b 4096 -f ./id_rsa_tema -N ""

echo ""
echo "Keys generated! Content:"
echo "--- CHEIA PRIVATA (id_rsa_tema): ---"
cat ./id_rsa_tema
echo ""
echo "--- CHEIA PUBLICA (id_rsa_tema.pub): ---"
cat ./id_rsa_tema.pub
echo ""


echo "================================================="
echo "2. (Medium) Encrypt symmetrically the “hashing.txt” file from the laboratory" 
echo "================================================="
# 1. Introducem text in fisier
echo "Hello, IBM!" > hashing.txt

# 2. Comenzi pentru generarea unei chei de criptare (16 bytes = 128 biți) și un IV (vector de inițializare).
openssl rand -out cheie.bin 16
openssl rand -out iv.bin 16

# 3. Conversie cheie și IV-ul în format text (hex) ca să le pot folosi în comenzi.
CHIA_HEX=$(xxd -p -c 256 cheie.bin)
IV_HEX=$(xxd -p -c 256 iv.bin)

# 4. Criptez fișierul în cele două moduri cerute.
echo "Criptez folosind AES-128-CFB (cu IV)..."
openssl enc -aes-128-cfb -in hashing.txt -out hashing_cfb.enc -K "$CHIA_HEX" -iv "$IV_HEX"

echo "Criptez folosind AES-128-ECB (fără IV)..."
openssl enc -aes-128-ecb -in hashing.txt -out hashing_ecb.enc -K "$CHIA_HEX"

echo ""
echo "Gata! Am creat fisierele criptate: hashing_cfb.enc si hashing_ecb.enc"
echo ""


echo "================================================="
echo "Verificare(decriptare fisier)"
echo "================================================="
echo "Textul original, recuperat prin decriptare:"
# Decriptez fișierul criptat cu CFB ca să arăt că procesul a funcționat.
openssl enc -d -aes-128-cfb -in hashing_cfb.enc -K "$CHIA_HEX" -iv "$IV_HEX"
echo ""
echo "================================================="
echo "Script finalizat."
echo "================================================="
