#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra detta script som root"
  exit 1
fi

# Kontrollera att minst en användare skickas in
if [ $# -eq 0 ]; then
  echo "Inga användare angivna"
  exit 1
fi

# Loopa igenom användare
for user in "$@"; do

  # Skapa användare om den inte finns
  if ! id "$user" &>/dev/null; then
    useradd -m -s /bin/bash "$user"
  fi

  # Skapa mappar
  mkdir -p "/home/$user/Documents"
  mkdir -p "/home/$user/Downloads"
  mkdir -p "/home/$user/Work"

  # Sätt ägare
  chown -R "$user:$user" "/home/$user"

  # Sätt rättigheter
  chmod 700 "/home/$user/Documents"
  chmod 700 "/home/$user/Downloads"
  chmod 700 "/home/$user/Work"

  # Skapa welcome.txt
  echo "Välkommen $user" > "/home/$user/welcome.txt"
  cut -d: -f1 /etc/passwd >> "/home/$user/welcome.txt"

  # Rättigheter på welcome.txt
  chown "$user:$user" "/home/$user/welcome.txt"
  chmod 600 "/home/$user/welcome.txt"

done
