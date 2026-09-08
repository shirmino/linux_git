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

# Check source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory does not exist:"
    echo "$SOURCE_DIR"
    exit 1
fi

# Create destination directory
mkdir -p "$DEST_DIR"

echo ""
echo "Source:      $SOURCE_DIR"
echo "Destination: $DEST_DIR"
echo ""

###############################################################################
# COUNT CSV FILES
###############################################################################

csv_count=$(find "$SOURCE_DIR" -maxdepth 1 -type f -iname "*.csv" | wc -l)

echo "CSV files found: $csv_count"

###############################################################################
# COUNT JSON FILES
###############################################################################

json_count=$(find "$SOURCE_DIR" -maxdepth 1 -type f -iname "*.json" | wc -l)

echo "JSON files found: $json_count"

###############################################################################
# MOVE CSV FILES
###############################################################################

echo ""
echo "Moving CSV files..."

find "$SOURCE_DIR" -maxdepth 1 -type f -iname "*.csv" -exec mv {} "$DEST_DIR/" \;

###############################################################################
# MOVE JSON FILES
###############################################################################

echo ""
echo "Moving JSON files..."

find "$SOURCE_DIR" -maxdepth 1 -type f -iname "*.json" -exec mv {} "$DEST_DIR/" \;

###############################################################################
# SUMMARY
###############################################################################

total_count=$((csv_count + json_count))

echo ""
echo "=============================================================="
echo "MOVE SUMMARY"
echo "=============================================================="

echo "CSV files moved:   $csv_count"
echo "JSON files moved:  $json_count"
echo "Total files moved: $total_count"

echo ""
echo "File movement completed successfully."