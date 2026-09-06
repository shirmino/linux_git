#!/bin/bash

###############################################################################
# CoreDataEngineers - Linux and Git Project
#
# Script Name: etl.sh
#
# Description:
#   This Bash script performs a simple ETL (Extract, Transform, Load) process.
#
# 
###############################################################################
# STEP 1: EXTRACT
###############################################################################
###############################################################################
# STEP 2: DEFINE THE DOWNLOAD URL
###############################################################################

# The URL should be provided as an environment variable.
#
# Before running the script, set it using:
#
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
#
# The script will then use the CSV_URL variable.

if [ -z "$CSV_URL" ]; then
    echo "[ERROR] CSV_URL environment variable is not set."
    echo ""
    echo "Please set the URL before running the script:"
    echo ""
    echo 'export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"'
    echo ""
    exit 1
fi


###############################################################################
# STEP 3: DEFINE PROJECT DIRECTORIES
###############################################################################

# Determine the directory where the script is located.
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Define the directories required for the ETL process.
RAW_DIR="$PROJECT_DIR/raw"
TRANSFORMED_DIR="$PROJECT_DIR/Transformed"
GOLD_DIR="$PROJECT_DIR/Gold"


###############################################################################
# STEP 4: DEFINE FILE PATHS
###############################################################################

# Name of the raw CSV file.
RAW_FILE="$RAW_DIR/annual-enterprise-survey-2023-financial-year-provisional.csv"

# Name and location of the transformed file.
TRANSFORMED_FILE="$TRANSFORMED_DIR/2023_year_finance.csv"

# Name and location of the final Gold file.
GOLD_FILE="$GOLD_DIR/2023_year_finance.csv"


###############################################################################
# STEP 5: CREATE REQUIRED DIRECTORIES
###############################################################################

echo "============================================================"
echo "STARTING ETL PROCESS"
echo "============================================================"
echo ""

echo "[SETUP] Creating required directories..."

# Create the directories if they do not already exist.
mkdir -p "$RAW_DIR"
mkdir -p "$TRANSFORMED_DIR"
mkdir -p "$GOLD_DIR"

echo "[SETUP] Directories created successfully."
echo ""


###############################################################################
# STEP 6: EXTRACT
###############################################################################

echo "============================================================"
echo "STEP 1: EXTRACT"
echo "============================================================"

echo "[EXTRACT] Downloading CSV file..."
echo "[EXTRACT] Source URL:"
echo "$CSV_URL"
echo ""

# Download the CSV file using curl.
#
# -L  = Follow redirects.
# -f  = Fail if the server returns an HTTP error.
# -s  = Silent mode.
# -S  = Show errors if they occur.
# -o  = Specify the output file.

curl -L -f -sS "$CSV_URL" -o "$RAW_FILE"


###############################################################################
# STEP 7: CONFIRM EXTRACT
###############################################################################

# Check whether the downloaded file exists.
if [ -f "$RAW_FILE" ]; then

    echo "[EXTRACT] Download successful!"
    echo "[EXTRACT] File has been saved in the raw folder:"
    echo "$RAW_FILE"

else

    echo "[ERROR] Download failed."
    echo "[ERROR] Raw CSV file was not created."
    exit 1

fi

echo ""

###############################################################################
# STEP 2: TRANSFORM
###############################################################################

echo "============================================================"
echo "STEP 2: TRANSFORM"
echo "============================================================"

echo "[TRANSFORM] Starting transformation..."
echo ""

# Define the Transformed directory.
TRANSFORMED_DIR="$PROJECT_DIR/Transformed"

# Define the output file.
TRANSFORMED_FILE="$TRANSFORMED_DIR/2023_year_finance.csv"

# Create the Transformed directory if it does not already exist.
mkdir -p "$TRANSFORMED_DIR"

echo "[TRANSFORM] Selecting the required columns:"
echo "             year"
echo "             Value"
echo "             Units"
echo "             variable_code"
echo ""

# Use awk to transform the CSV file.
#
# The first row is the header.
# We search the header to find the positions of:
#   year
#   Value
#   Units
#   Variable_code
#
# Variable_code is renamed to variable_code in the output.
#
# Only the four required columns are written to the new file.

awk -F',' '
BEGIN {
    OFS=","
}

# Process the header row
NR == 1 {

    # Find the position of each required column.
    for (i = 1; i <= NF; i++) {

        if ($i == "year")
            year_col = i

        if ($i == "Value")
            value_col = i

        if ($i == "Units")
            units_col = i

        if ($i == "Variable_code")
            variable_code_col = i
    }

    # Write the new header.
    # Variable_code has been renamed to variable_code.
    print "year", "Value", "Units", "variable_code"

    next
}

# Process all remaining rows
{
    # Select only the four required columns.
    print $year_col, $value_col, $units_col, $variable_code_col
}

' "$RAW_FILE" > "$TRANSFORMED_FILE"


###############################################################################
# STEP 3: CONFIRM TRANSFORMATION
###############################################################################

echo ""
echo "[TRANSFORM] Checking if the transformed file was created..."

if [ -f "$TRANSFORMED_FILE" ]; then

    echo "[TRANSFORM] Transformation successful!"
    echo "[TRANSFORM] File has been saved in the Transformed folder:"
    echo "$TRANSFORMED_FILE"

else

    echo "[ERROR] Transformation failed."
    echo "[ERROR] The transformed file was not created."
    exit 1

fi

echo ""
echo "[TRANSFORM] Transform step completed successfully."
echo "============================================================"

###############################################################################
# STEP 4: LOAD
###############################################################################

echo "============================================================"
echo "STEP 3: LOAD"
echo "============================================================"

echo "[LOAD] Loading transformed data into the Gold folder..."
echo ""

# Define the Gold directory.
GOLD_DIR="$PROJECT_DIR/Gold"

# Define the final Gold file.
GOLD_FILE="$GOLD_DIR/2023_year_finance.csv"

# Create the Gold directory if it does not already exist.
mkdir -p "$GOLD_DIR"

# Copy the transformed file into the Gold folder.
cp "$TRANSFORMED_FILE" "$GOLD_FILE"


###############################################################################
# STEP 5: CONFIRM LOAD
###############################################################################

echo "[LOAD] Checking if the file was saved in the Gold folder..."

if [ -f "$GOLD_FILE" ]; then

    echo "[LOAD] Load successful!"
    echo "[LOAD] File has been saved in the Gold folder:"
    echo "$GOLD_FILE"

else

    echo "[ERROR] Load failed."
    echo "[ERROR] The file was not saved in the Gold folder."
    exit 1

fi

echo ""
echo "[LOAD] Load step completed successfully."
echo "============================================================"