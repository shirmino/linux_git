#!/bin/bash

###############################################################################
# MOVE CSV AND JSON FILES
###############################################################################

# Get the project directory based on where this script is located
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Define source and destination directories
SOURCE_DIR="$PROJECT_DIR/json_and_CSV_old"
DEST_DIR="$PROJECT_DIR/json_and_CSV"

echo "============================================================"
echo "MOVING CSV AND JSON FILES"
echo "============================================================"

# Check that the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory does not exist:"
    echo "$SOURCE_DIR"
    exit 1
fi

# Create destination directory if it does not exist
mkdir -p "$DEST_DIR"

echo ""
echo "Source:      $SOURCE_DIR"
echo "Destination: $DEST_DIR"
echo ""

# Move CSV files
csv_count=0

for file in "$SOURCE_DIR"/*.csv; do
    if [ -f "$file" ]; then
        mv "$file" "$DEST_DIR/"
        echo "[MOVED] $(basename "$file")"
        ((csv_count++))
    fi
done

# Move JSON files
json_count=0

for file in "$SOURCE_DIR"/*.json; do
    if [ -f "$file" ]; then
        mv "$file" "$DEST_DIR/"
        echo "[MOVED] $(basename "$file")"
        ((json_count++))
    fi
done

echo ""
echo "============================================================"
echo "MOVE SUMMARY"
echo "============================================================"
echo "CSV files moved:  $csv_count"
echo "JSON files moved: $json_count"
echo "Total files moved: $((csv_count + json_count))"

echo ""
echo "Files now in $DEST_DIR:"
echo "------------------------------------------------------------"

ls -l "$DEST_DIR"

echo ""
echo "File movement completed successfully."