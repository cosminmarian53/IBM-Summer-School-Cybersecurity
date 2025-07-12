#!/bin/bash

# Script pentru rezolvarea completă a temei pentru Sesiunea 3
# ATENȚIE: Scriptul cere parola de administrator (sudo) la început.


echo "================================================="
echo "PARTEA 1"
echo "================================================="

# --- Punctul 1 & 2: Certificat cu algoritm SHA256 și date specificate ---
echo "--- Se generează un certificat cu algoritm SHA256 și date predefinite... ---"
openssl req -x509 -newkey rsa:2048 -nodes \
  -keyout certificat_sha256.key \
  -out certificat_sha256.crt \
  -sha256 \
  -days 365 \
  -subj "/C=RO/ST=Bucuresti/L=Bucuresti/O=FirmaMea/CN=domeniulmeu.com"
echo "Finalizat. Certificatul 'certificat_sha256.crt' și cheia sa au fost create."

# --- Punctul 3: Certificat generat dintr-o cheie existentă ---
echo "--- Se generează un certificat nou, folosind o cheie privată deja creată... ---"
# Pasul 1: Crearea cheii private separate.
openssl genrsa -out cheie_separata.key 2048
# Pasul 2: Crearea certificatului pe baza cheii de mai sus.
openssl req -x509 -new -nodes \
  -key cheie_separata.key \
  -out certificat_din_cheie.crt \
  -sha256 \
  -days 365 \
  -subj "/C=RO/ST=Bucuresti/L=Bucuresti/O=FirmaMea/CN=altuldomeiu.com"
echo "Finalizat. Au fost create 'cheie_separata.key' și certificatul 'certificat_din_cheie.crt'."
echo ""

# --- Punctul 4: Verificarea lanțului de certificate ---
echo "--- Se verifică lanțul de certificate pentru un site (google.com)... ---"
# Comanda se conectează la server și afișează certificatele.
# Folosim 'echo |' pentru a ne asigura că scriptul nu se blochează aici.
echo | openssl s_client -connect google.com:443 -showcerts
echo ""


echo "================================================="
echo "PARTEA 2"
echo "================================================="

# --- Pasul 1: Crearea certificatului auto-semnat (Self-Signed) pentru server ---
echo "--- Se generează un certificat SSL auto-semnat pentru serverul local (Apache)... ---"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=RO/CN=localhost"
echo "Finalizat. Cheia și certificatul au fost salvate în folderul /etc/ssl/."
echo ""

# --- Pasul 2: Configurarea serverului Apache ---
echo "--- Se configurează Apache pentru a folosi noul certificat SSL... ---"
# Se activează modulul SSL, necesar pentru HTTPS.
a2enmod ssl

# Se modifică fișierul de configurare pentru a folosi certificatul nostru.
# (folosim 'sed' pentru a edita fișierul automat)
sed -i 's|SSLCertificateFile.*|SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt|' /etc/apache2/sites-available/default-ssl.conf
sed -i 's|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key|' /etc/apache2/sites-available/default-ssl.conf

# Se activează site-ul configurat pentru SSL.
a2ensite default-ssl.conf

# Se repornește serverul Apache pentru ca setările să aibă efect.
systemctl restart apache2
echo "Serverul Apache a fost configurat și repornit cu succes."
echo ""


echo "================================================="
echo "SCRIPT FINALIZAT. TEMA ESTE COMPLETĂ."
echo "================================================="
echo "URMĂTORUL PAS (verificare manuală):"
echo "1. Deschide un browser web (ex: Firefox)."
echo "2. Navighează la adresa: https://localhost"
echo "3. Browserul va afișa un avertisment de securitate. Acest lucru este normal."
echo "4. Apasă pe 'Advanced' -> 'Accept the Risk and Continue' (sau text similar)."
echo "5. Dacă apare pagina standard de Apache ('It works!'), înseamnă că totul a funcționat."
