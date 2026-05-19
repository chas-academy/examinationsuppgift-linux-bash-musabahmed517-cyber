#!/bin/bash

# Kontrollera att scriptet kan köra admin-kommandon
if [ "$EUID" -ne 0 ]; then
  if sudo -n true 2>/dev/null; then
    SUDO="sudo"
  else
    echo "Du måste köra detta script som root"
    exit 1
  fi
else
  SUDO=""
fi

# Loopa igenom alla användare
for user in "$@"; do

  # Skapa användaren om den inte finns
  if ! id "$user" &>/dev/null; then
    $SUDO useradd -m "$user"
  fi

  # Skapa mappar
  $SUDO mkdir -p "/home/$user/Documents" "/home/$user/Downloads" "/home/$user/Work"

  # Sätt ägare och rättigheter
  $SUDO chown -R "$user:$user" "/home/$user"
  $SUDO chmod 700 "/home/$user/Documents" "/home/$user/Downloads" "/home/$user/Work"

  # Skapa welcome.txt
  echo "Välkommen $user" | $SUDO tee "/home/$user/welcome.txt" >/dev/null
  cut -d: -f1 /etc/passwd | $SUDO tee -a "/home/$user/welcome.txt" >/dev/null

  $SUDO chown "$user:$user" "/home/$user/welcome.txt"
  $SUDO chmod 600 "/home/$user/welcome.txt"

done

exit 0
