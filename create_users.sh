#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra detta script som root"
  exit 1
fi

# Loopa igenom användare
for user in "$@"; do

  # Skapa användare om den inte finns
  if ! id "$user" &>/dev/null; then
    useradd -m "$user"
  fi

  # Skapa mappar
  mkdir -p "/home/$user/Documents"
  mkdir -p "/home/$user/Downloads"
  mkdir -p "/home/$user/Work"

  # Sätt ägare på hemkatalog och mappar
  chown -R "$user:$user" "/home/$user"

  # Rättigheter
  chmod 700 "/home/$user/Documents"
  chmod 700 "/home/$user/Downloads"
  chmod 700 "/home/$user/Work"

  # Welcome-fil
  echo "Välkommen $user" > "/home/$user/welcome.txt"

  # Rättigheter på filen
  chown "$user:$user" "/home/$user/welcome.txt"
  chmod 600 "/home/$user/welcome.txt"

done
