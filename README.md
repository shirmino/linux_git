# CoreDataEngineers — Linux and Git Project

## Project Overview

This project was completed as part of the CoreDataEngineers Linux and Git exercise.

The objective is to demonstrate practical knowledge of:

* Linux
* Bash scripting
* ETL processes
* File management
* Cron scheduling
* Git
* GitHub

The project implements a simple ETL pipeline using Bash scripting, schedules the pipeline using cron, and includes a Bash script for moving CSV and JSON files.

---

## Project Structure

```text
linux-git/
│
├── raw/
│   └── annual-enterprise-survey-2023-financial-year-provisional.csv
│
├── Transformed/
│   └── 2023_year_finance.csv
│
├── Gold/
│   └── 2023_year_finance.csv
│
├── json_and_CSV/
│   ├── example.csv
│   └── example.json
│
├── scripts/
│   ├── etl.sh
│   └── move_files.sh
│
├── logs/
│   └── etl.log
│
├── .gitignore
└── README.md
```

---

# 1. ETL Pipeline

The ETL pipeline consists of three stages:

```text
Extract → Transform → Load
```

## Extract

The `etl.sh` script downloads the Annual Enterprise Survey 2023 provisional CSV dataset from Stats NZ.

The URL is stored in the environment variable:

```bash
DATA_URL
```

The downloaded file is stored in:

```text
raw/
```

The script confirms that the file has been successfully downloaded.

---

## Transform

The transformation performs two operations.

### Rename column

The column:

```text
Variable_code
```

is renamed to:

```text
variable_code
```

### Select columns

Only the following columns are retained:

```text
year
Value
Units
variable_code
```

The transformed dataset is saved as:

```text
Transformed/2023_year_finance.csv
```

The transformation is performed using Bash and `awk`.

---

## Load

The transformed file is copied into:

```text
Gold/
```

The final file is:

```text
Gold/2023_year_finance.csv
```

The script confirms that the file has been successfully loaded.

---

The script prints messages showing the progress of:

1. Extraction
2. Transformation
3. Loading

---

# 3. Cron Scheduling

The ETL script is scheduled to run every day at 12:00 AM.

The cron expression used is:

```text
0 0 * * *
```

The five cron fields represent:

```text
Minute Hour Day-of-Month Month Day-of-Week
```

Therefore:

```text
0 0 * * *
```

means:

```text
Every day at 00:00
```

The crontab entry is:

```bash
0 0 * * * /absolute/path/to/linux-git/scripts/etl.sh >> /absolute/path/to/linux-git/logs/etl.log 2>&1
```

To edit the crontab:

```bash
crontab -e
```

To verify the scheduled job:

```bash
crontab -l
```

For testing, the job can temporarily be scheduled every minute:

```bash
* * * * * /absolute/path/to/linux-git/scripts/etl.sh >> /absolute/path/to/linux-git/logs/etl.log 2>&1
```

After testing, it should be changed back to:

```bash
0 0 * * * /absolute/path/to/linux-git/scripts/etl.sh >> /absolute/path/to/linux-git/logs/etl.log 2>&1
```

---

# 4. CSV and JSON File Management

The `move_files.sh` script moves CSV and JSON files from:

```text
source_files/
```

to:

```text
json_and_CSV/
```

The script supports one or multiple CSV and JSON files.

To make it executable:

```bash
chmod +x scripts/move_files.sh
```

Run:

```bash
./scripts/move_files.sh
```

The script checks for both `.csv` and `.json` files and moves any matching files into the destination directory.

---

# 5. Git Version Control

Git is used to version all project scripts and documentation.

Initialize the repository:

```bash
git init
```

Check the repository:

```bash
git status
```

Stage files:

```bash
git add .
```

Commit changes:

```bash
git commit -m "Add Bash ETL pipeline and file management scripts"
```

Connect the repository to GitHub:

```bash
git remote add origin https://github.com/YOUR_USERNAME/linux-git.git
```

Rename the branch:

```bash
git branch -M main
```

Push to GitHub:

```bash
git push -u origin main
```

---

# 6. Technologies Used

* Linux
* Bash
* AWK
* curl
* Cron
* Git
* GitHub

---

# 7. ETL Architecture

```text
                 Stats NZ CSV
                      │
                      ▼
                  [Extract]
                      │
                      ▼
                    raw/
                      │
                      ▼
                 [Transform]
                      │
          ┌───────────┴───────────┐
          │                       │
   Rename Variable_code      Select columns
          │                       │
          └───────────┬───────────┘
                      │
                      ▼
              Transformed/
                      │
                      ▼
                   [Load]
                      │
                      ▼
                    Gold/
```

---

# 8. Conclusion

This project demonstrates the implementation of a basic Bash-based ETL pipeline together with Linux file management, automated scheduling using cron, and Git version control.

The pipeline extracts data from an external source, transforms the required columns, stores the resulting dataset in a Gold directory, and provides automated daily execution through cron.
