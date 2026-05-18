#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra detta script som root"
  exit 1
fi

# Loopa igenom användare
for user in "$@"; do

  # Skapa användare med hemkatalog
  useradd -m "$user" 2>/dev/null

  # Skapa kataloger
  mkdir -p "/home/$user/Documents"
  mkdir -p "/home/$user/Downloads"
  mkdir -p "/home/$user/Work"

  # Sätt ägare
  chown -R "$user:$user" "/home/$user"

  # Sätt rättigheter
  chmod 700 "/home/$user/Documents"
  chmod 700 "/home/$user/Downloads"
  chmod 700 "/home/$user/Work"

  # Skapa welcome-fil
  echo "Välkommen $user" > "/home/$user/welcome.txt"

  # Lägg till andra användare (utan den själv)
  cut -d: -f1 /etc/passwd | grep -v "^$user$" >> "/home/$user/welcome.txt"

  # Sätt rättigheter på welcome-filen
  chmod 600 "/home/$user/welcome.txt"
  chown "$user:$user" "/home/$user/welcome.txt"

done
