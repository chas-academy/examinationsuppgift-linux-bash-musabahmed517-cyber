#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra detta script som root"
  exit 1
fi

# Loopa igenom användare
for user in "$@"; do

  # Skapa användare
  useradd -m "$user"

  # Skapa mappar i hemkatalogen
  mkdir -p "/home/$user/Documents"
  mkdir -p "/home/$user/Downloads"
  mkdir -p "/home/$user/Work"

  # Sätt ägare
  chown -R "$user:$user" "/home/$user"

  # Sätt rättigheter (endast ägare)
  chmod 700 "/home/$user/Documents"
  chmod 700 "/home/$user/Downloads"
  chmod 700 "/home/$user/Work"

  # Skapa welcome.txt
  echo "Välkommen $user" > "/home/$user/welcome.txt"
  cut -d: -f1 /etc/passwd >> "/home/$user/welcome.txt"

done
