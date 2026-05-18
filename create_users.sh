#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra detta script som root"
  exit 1
fi

# Loopa igenom alla användare
for user in "$@"; do

  HOME_DIR="/home/$user"

  # Skapa användaren med bash-shell
  useradd -m -s /bin/bash "$user"

  # Skapa mappar
  mkdir -p "$HOME_DIR/Documents"
  mkdir -p "$HOME_DIR/Downloads"
  mkdir -p "$HOME_DIR/Work"

  # Sätt rätt ägare
  chown -R "$user:$user" "$HOME_DIR"

  # Sätt rättigheter
  chmod 700 "$HOME_DIR/Documents"
  chmod 700 "$HOME_DIR/Downloads"
  chmod 700 "$HOME_DIR/Work"

  # Skapa welcome-fil
  echo "Välkommen $user" > "$HOME_DIR/welcome.txt"
  cut -d: -f1 /etc/passwd >> "$HOME_DIR/welcome.txt"

  # Rättigheter på welcome-filen
  chown "$user:$user" "$HOME_DIR/welcome.txt"
  chmod 600 "$HOME_DIR/welcome.txt"

done
