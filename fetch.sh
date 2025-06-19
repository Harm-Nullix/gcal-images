(
  cd "$(dirname "$0")" || exit 1

  # Parse parameters
  YEAR=""
  VERSION=""
  while [[ $# -gt 0 ]]; do
    case $1 in
      --year|-y)
        YEAR="$2"
        shift 2
        ;;
      --version|-v)
        VERSION="$2"
        shift 2
        ;;
      *)
        echo "Unknown parameter: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$YEAR" || -z "$VERSION" ]]; then
      echo "Usage: $0 --year <year> --version <version>"
      exit 1
  fi

  # Start time
  START_TIME=$(date +%s)

  # Read keywords from keywords.txt
  KEYWORDS_FILE="keywords.txt"
  if [[ ! -f "$KEYWORDS_FILE" ]]; then
    echo "File $KEYWORDS_FILE not found!"
    exit 1
  fi

  KEYWORDS=()
  while IFS=: read -r keyword _; do
    KEYWORDS+=("$keyword")
  done < "$KEYWORDS_FILE"

  # Output directories
  OUTPUT_DIR="images/${YEAR}_${VERSION}"
  FAILED_LOG="$OUTPUT_DIR/failed.txt"

  mkdir -p "$OUTPUT_DIR"

  # Clear the failed log file at the start
: > "$FAILED_LOG" || {
  echo "Failed to create or write to $FAILED_LOG"
}

# Function to attempt SVG to JPG conversion with available tools
  convert_svg_to_jpg() {
    local input_file="$1"
    local output_file="$2"
    local success=false

    # Attempt conversion using ImageMagick
    if command -v magick >/dev/null 2>&1; then
      if magick "$input_file" "$output_file"; then
        success=true
        echo "Conversion successful using ImageMagick."
      fi
    fi

    # Attempt conversion using Inkscape
    if ! $success && command -v inkscape >/dev/null 2>&1; then
      if inkscape "$input_file" --export-type=jpeg --export-filename="$output_file" >/dev/null 2>&1; then
        success=true
        echo "Conversion successful using Inkscape."
      fi
    fi
    # Attempt conversion using Inkscape (App)
    if ! $success && command -v /Applications/Inkscape.app/Contents/MacOS/inkscape >/dev/null 2>&1; then
      if /Applications/Inkscape.app/Contents/MacOS/inkscape "$input_file" --export-type=jpeg --export-filename="$output_file" >/dev/null 2>&1; then
        success=true
        echo "Conversion successful using Inkscape."
      fi
    fi

    # Attempt conversion using CairoSVG (if installed via pip)
    if ! $success && command -v cairosvg >/dev/null 2>&1; then
      if cairosvg "$input_file" -o "$output_file" 2>/dev/null; then
        success=true
        echo "Conversion successful using CairoSVG."
      fi
    fi

    # Attempt conversion using svgexport (if installed via npm)
    if ! $success && command -v svgexport >/dev/null 2>&1; then
      if svgexport "$input_file" "$output_file" 2>/dev/null; then
        success=true
        echo "Conversion successful using svgexport."
      fi
    fi

    # Attempt conversion using resvg (if installed via brew or cargo)
    if ! $success && command -v resvg >/dev/null 2>&1; then
      if resvg "$input_file" "$output_file" 2>/dev/null; then
        success=true
        echo "Conversion successful using resvg."
      fi
    fi

    if ! $success; then
      echo "Conversion failed for SVG file: $input_file."
    fi

    if $success; then
      echo "$success"
    fi
  }


  # Function to fetch images
  fetch_images() {
    local keyword="$1"
    local svg_success=false
    local svg_file="${OUTPUT_DIR}/${keyword}.svg"
    local jpg_file="${OUTPUT_DIR}/${keyword}.jpg"

    # Attempt to fetch the SVG
    local svg_url="https://ssl.gstatic.com/calendar/images/eventillustrations/${YEAR}_${VERSION}/img_${keyword}.svg"
    local svg_status=$(curl -s -o "$svg_file" -w "%{http_code}" "$svg_url")
    if [[ $svg_status -eq 200 ]]; then
      svg_success=true
    else
      rm -f "$svg_file" 2>/dev/null
    fi

    # Convert SVG to JPG if SVG was successful
    # FIXME, someone with more knowledge should be able to get this working
#    if $svg_success; then
#      local conversion_success
#      conversion_success=$(convert_svg_to_jpg "$svg_file" "$jpg_file")
#       # Log failure if JPG fails
#      if [[ "$conversion_success" != "true" ]]; then
#        echo "${keyword}, ${conversion_success}" >> "$FAILED_LOG"
#      fi
#    fi

    # Log failure if SVG fails (all is lost)
    if ! $svg_success; then
      echo "${keyword}, ${svg_status}, $svg_url" >> "$FAILED_LOG"
      echo "false"
    else
      echo "true"
    fi
  }


  # Process keywords
  SUCCESSFUL=0
  FAILED=0
  SUCCESSFUL_KEYWORDS=()
  FAILED_KEYWORDS=()

  for keyword in "${KEYWORDS[@]}"; do
    if [[ $(fetch_images "$keyword") == "true" ]]; then
      ((SUCCESSFUL++))
      SUCCESSFUL_KEYWORDS+=("$keyword")
    else
      ((FAILED++))
      FAILED_KEYWORDS+=("$keyword")
    fi
  done

  # Write successful keywords to a new keywords.txt file in the output directory
  NEW_KEYWORDS_FILE="${OUTPUT_DIR}/keywords.txt"
  printf "%s\n" "${SUCCESSFUL_KEYWORDS[@]}" > "$NEW_KEYWORDS_FILE"

  # End time
  END_TIME=$(date +%s)
  ELAPSED_TIME=$((END_TIME - START_TIME))

  # Log results
  echo "Time taken: ${ELAPSED_TIME} seconds."
  echo "Successful downloads: $SUCCESSFUL"
  echo "Failed keywords: $FAILED"
  if [[ $FAILED -gt 0 ]]; then
    echo -e "Keywords with failures:\n${FAILED_KEYWORDS[*]}"
  fi
)
