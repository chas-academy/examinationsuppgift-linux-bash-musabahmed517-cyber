#!/bin/bash

# Kontrollera att scriptet kan köra root-kommandon
if [ "$EUID" -ne 0 ] && ! sudo -n true 2>/dev/null; then
  echo "Du måste köra detta script som root"
  exit 1
fi

for user in "$@"; do
  if ! id "$user" &>/dev/null; then
    sudo useradd -m "$user"
  fi

  sudo mkdir -p "/home/$user/Documents" "/home/$user/Downloads" "/home/$user/Work"
  sudo chown -R "$user:$user" "/home/$user"
  sudo chmod 700 "/home/$user/Documents" "/home/$user/Downloads" "/home/$user/Work"

  echo "Välkommen $user" | sudo tee "/home/$user/welcome.txt" >/dev/null
  cut -d: -f1 /etc/passwd | sudo tee -a "/home/$user/welcome.txt" >/dev/null
  sudo chown "$user:$user" "/home/$user/welcome.txt"
  sudo chmod 600 "/home/$user/welcome.txt"
done
