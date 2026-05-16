#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra detta script som root"
  exit 1
fi

# Gå igenom alla användare
for user in "$@"; do
  echo "Skapar användare: $user"

  # Skapa användare med hemkatalog
  useradd -m "$user" 2>/dev/null

  # Skapa mappar
  mkdir -p /home/$user/Documents
  mkdir -p /home/$user/Downloads
  mkdir -p /home/$user/Work

  chmod 700 /home/$user/Documents
  chmod 700 /home/$user/Downloads
  chmod 700 /home/$user/Work

done
