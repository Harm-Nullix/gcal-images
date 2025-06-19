#!/bin/bash

(
  cd "$(dirname "$0")" || exit 1

# Step 1: Fetch keywords and their options from the root file
KEYWORDS=()
ROOT_FILE="keywords.txt" # Replace with the actual root file path

if [[ -f $ROOT_FILE ]]; then
  # Read the root file line by line
  while IFS=: read -r keyword options; do
    # Store keywords while trimming leading/trailing spaces
    KEYWORDS+=("$(echo "$keyword" | xargs)")
  done < "$ROOT_FILE"
else
  echo "Root file not found: $ROOT_FILE"
  exit 1
fi

# Step 2: Update only lines in keyword files if the keyword exists in the file
IMAGES_DIR="images" # Replace with your actual images directory

if [[ -d $IMAGES_DIR ]]; then
  # Find all files named "keywords" under the images folder
  find "$IMAGES_DIR" -type f -name "keywords.txt" | while read -r keywords_file; do
    echo "Processing: $keywords_file"

    # Create a temporary file to store updated content
    TMP_FILE=$(mktemp)

    # Process the keywords file line by line
    while IFS= read -r line || [[ -n $line ]]; do
      # Extract the keyword before `:` in the line
      current_keyword=$(echo "$line" | awk -F: '{print $1}' | xargs)

      # Check if the current keyword exists in the fetched keywords
      if grep -q "^$current_keyword:" "$ROOT_FILE"; then
        # Replace the full line with the corresponding line from the root file
        root_line=$(grep "^$current_keyword:" "$ROOT_FILE")
        echo "$root_line" >> "$TMP_FILE"
      else
        # Keep the original line as is
        echo "$line" >> "$TMP_FILE"
      fi

    done < "$keywords_file"

    # Replace the original keywords file with the updated content
    mv "$TMP_FILE" "$keywords_file"
    echo "Updated file: $keywords_file"
  done
else
  echo "Images directory not found: $IMAGES_DIR"
  exit 1
fi

echo "Done."
)
