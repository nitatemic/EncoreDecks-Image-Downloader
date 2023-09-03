#!/bin/bash

# Vérifie si le fichier d'entrée a été spécifié en argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 fichier.txt"
  exit 1
fi

# Vérifie si le dossier de destination existe, sinon le crée
output_dir="images_cartes"
if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
fi

# Parcours du fichier d'entrée ligne par ligne
while IFS= read -r card_id; do
  # Extrait la partie après le dernier '/' dans l'identifiant
  filename="${card_id##*/}"

  # Divise la partie après le '/' en deux parties séparées par le tiret '-'
  IFS='-' read -ra parts <<< "$filename"
  card_number="${parts[0]}"
  card_suffix="${parts[1]}"

  image_url="https://www.encoredecks.com/images/JP/${card_number}/${card_suffix}.gif"

  # Télécharge l'image et la place dans le dossier de destination
  curl -s -o "$output_dir/${card_number}-${card_suffix}.gif" "$image_url"
  
  if [ $? -eq 0 ]; then
    echo "Téléchargé : $image_url"
  else
    echo "Échec du téléchargement : $image_url"
  fi
done < "$1"

echo "Téléchargement terminé."
