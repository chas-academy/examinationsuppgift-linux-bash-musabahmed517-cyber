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
 id "$user" >/dev/null 2>&1 || useradd -m "$user"

  # Skapa mappar i hemkatalogen
  mkdir -p /home/"$user"/Documents
  mkdir -p /home/"$user"/Downloads
  mkdir -p /home/"$user"/Work

done
