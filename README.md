# 🔐 PAN Number Validation & Data Cleaning Project

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)
![DataValidation](https://img.shields.io/badge/Data--Validation-FF6B35?style=for-the-badge&logo=shield&logoColor=white)
![DataCleaning](https://img.shields.io/badge/Data--Cleaning-4CAF50?style=for-the-badge&logo=simpleanalytics&logoColor=white)
![CSV](https://img.shields.io/badge/CSV-FFDD00?style=for-the-badge&logo=files&logoColor=black)

A comprehensive PostgreSQL project that validates and cleans Indian PAN (Permanent Account Number) data using advanced SQL techniques and custom functions.

## 🎯 What This Project Does

This project takes a dataset of PAN numbers and performs complete data validation according to official Indian PAN format rules. It identifies valid vs invalid PANs, cleans messy data, and provides detailed reporting on data quality.

## 📋 About PAN Numbers

**PAN Format**: AAAAA1234A (10 characters)
- **First 5**: Alphabetic characters (A-Z)
- **Next 4**: Numeric digits (0-9) 
- **Last 1**: Alphabetic character (A-Z)

**Special Rules**:
- No adjacent identical characters (AABCD ❌, AXBCD ✅)
- No sequential patterns (ABCDE ❌, ABCDX ✅)
- Same rules apply to the 4-digit numeric section

## 🧹 Data Cleaning Process

### Step 1: Handle Missing Data
- Identified NULL and empty PAN entries
- Removed incomplete records from processing

### Step 2: Remove Duplicates
- Found duplicate PAN numbers using GROUP BY
- Ensured unique entries in final dataset

### Step 3: Clean Data Format
- Removed leading/trailing spaces with TRIM()
- Converted all letters to uppercase
- Standardized data format

### Step 4: Advanced Validation
- Built custom functions for adjacent character checking
- Created sequential character validation logic
- Applied regex pattern matching for structure validation

## 🛠️ Advanced SQL Features Used

### Custom Functions
```

-- Function to check adjacent identical characters
fn_check_adjacent_characters(text) → boolean

-- Function to detect sequential character patterns
fn_check_sequential_characters(text) → boolean

```

### Complex Validation Logic
- **Regex Pattern**: `^[A-Z]{5}[0-9]{4}[A-Z]$`
- **Multi-layer Validation**: Structure + Adjacent + Sequential checks
- **CTE Chains**: Organized complex logic flow

## 📊 Key Results

### Summary Report
- **Total Records Processed**: All input records
- **Valid PANs**: Count of correctly formatted PANs
- **Invalid PANs**: Count of incorrectly formatted PANs  
- **Missing/Incomplete**: Count of NULL or empty entries

![output Screenshot](summary_report.jpg)

### Validation Categories
- ✅ **Valid PAN**: Meets all format requirements
- ❌ **Invalid PAN**: Fails one or more validation rules

![output Screenshot](validation_catagories.jpg)

## 🗃️ Database Structure

### Main Table
```

stg_pan_number_dataset
├── pan_number (text) -- Raw PAN data

```

### View
```

vw_valid_invalid_pans
├── pan_number (text) -- Cleaned PAN
└── status (text)     -- Valid/Invalid classification

```

## 💻 SQL Skills Demonstrated

- **Data Cleaning**: NULL handling, duplicate removal, string formatting
- **Custom Functions**: PostgreSQL PL/pgSQL function development
- **Regular Expressions**: Pattern matching for data validation
- **CTEs**: Multi-step data processing and organization
- **Window Functions**: Advanced data analysis techniques
- **Views**: Creating reusable data structures
- **String Functions**: TRIM(), UPPER(), SUBSTRING(), ASCII()

## 📁 Project Files

```

📦 pan-validation-sql
├── 📄 README.md                              (This file)
├── 📄 PAN_card_validation.sql                (Complete project code)
├── 📄 PAN Number Validation Dataset.csv      (Original dataset)
├── 📄 PAN Number Validation - Problem Statement.pdf  (Project requirements)
├── 📷 summary_report.jpg                 (Summary analysis results)
└── 📷 validation_categories.jpg          (Valid/Invalid categorization)


```

## 🚀 How to Run This Project

### Prerequisites
- PostgreSQL installed
- pgAdmin or any PostgreSQL client
- Basic SQL knowledge

### Steps
1. **Clone** this repository
2. **Create** a new PostgreSQL database
3. **Run** the table creation script
4. **Import** your PAN dataset into `stg_pan_number_dataset`
5. **Execute** the validation script step by step
6. **View** results using the created view and summary queries

## 💡 What I Learned

- Advanced PostgreSQL function development
- Complex data validation logic implementation
- Real-world data cleaning challenges
- Government data format requirements
- Performance optimization for large datasets

## 🎓 Business Value

This project demonstrates ability to:
- ✅ Handle sensitive financial data validation
- ✅ Implement complex business rules in SQL
- ✅ Create reusable validation functions
- ✅ Build comprehensive data quality reports
- ✅ Work with government compliance requirements

*This project highlights my ability to check data accuracy and run powerful SQL analysis.*

## ✉️ Contact

**Sankaran S**  
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/sankaran-s2001) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sankaran-s21/) [![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:sankaran121101@gmail.com)

---
