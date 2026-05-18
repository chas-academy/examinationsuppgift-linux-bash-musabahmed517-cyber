if ./$SCRIPT $TEST_USER $TEST_USER_2 > /dev/null; then

Det betyder att ditt script inte får krascha.

Problemet är troligen att useradd returnerar felkod ibland och då failar hela scriptet.

Byt hela din fil till detta exakt:

#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra detta script som root"
  exit 1
fi

# Loopa igenom användare
for user in "$@"; do

  # Skapa användare
  useradd -m "$user" || true

  # Skapa mappar
  mkdir -p "/home/$user/Documents"
  mkdir -p "/home/$user/Downloads"
  mkdir -p "/home/$user/Work"

  # Sätt rättigheter
  chmod 700 "/home/$user/Documents"
  chmod 700 "/home/$user/Downloads"
  chmod 700 "/home/$user/Work"

done

exit 0
