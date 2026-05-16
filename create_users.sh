#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra detta script som root"
  exit 1
fi

# Gå igenom alla användare
for user in "$@"; do
  echo "Skapar användare: $user"
done
