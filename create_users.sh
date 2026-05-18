#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra detta script som root"
  exit 1
fi

# Loopa igenom alla användare som skickas in
for user in "$@"; do

  # Skapa användare om den inte redan finns
  if ! id "$user" &>/dev/null; then
    useradd -m "$user"
  fi

  # Skapa kataloger
  mkdir -p "/home/$user/Documents"
  mkdir -p "/home/$user/Downloads"
  mkdir -p "/home/$user/Work"

  # Sätt rätt ägare
  chown -R "$user:$user" "/home/$user"

  # Sätt rättigheter
  chmod 700 "/home/$user/Documents"
  chmod 700 "/home/$user/Downloads"
  chmod 700 "/home/$user/Work"

  # Skapa welcome.txt
  echo "Välkommen $user" > "/home/$user/welcome.txt"

  # Lista alla användare i systemet
  cut -d: -f1 /etc/passwd >> "/home/$user/welcome.txt"

  # Rättigheter på welcome-filen
  chown "$user:$user" "/home/$user/welcome.txt"
  chmod 600 "/home/$user/welcome.txt"

done
