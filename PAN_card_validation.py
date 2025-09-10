import pandas as pd
import re

df = pd.read_excel("PAN Number Validation Dataset.xlsx")
#print(df.head(10))
print('Total records = ', len(df))
total_records = len(df)

# DATA CLEANING:
df["Pan_Numbers"] = df['Pan_Numbers'].astype('string').str.strip().str.upper()
#print(df.head(10))

#print('\n')
# print(df[df['Pan_Numbers'] == ""])
# print(df[df['Pan_Numbers'].isna()])

df = df.replace({"Pan_Numbers": ''}, pd.NA).dropna(subset = "Pan_Numbers")
# print(df[df['Pan_Numbers'] == ""])
# print(df[df['Pan_Numbers'].isna()])

print('Total records = ', len(df))

print('Unique values: ', df["Pan_Numbers"].nunique())

df = df.drop_duplicates(subset="Pan_Numbers", keep='first')
print('Total records = ', len(df))

# DATA VALIDATION
def has_adjacent_repetition(pan):   #AABCD, #ABCDX
    for i in range(len(pan)-1):
        if pan[i] == pan[i+1]:
            return True
    return False

# print(has_adjacent_repetition('AABCD'))
# print(has_adjacent_repetition('ABCDX'))
# print(has_adjacent_repetition('QQWER'))
# print(has_adjacent_repetition('LOIUJ'))

def is_sequential(pan): #ABCDE, #ACFGT
    for i in range(len(pan)-1):
        if ord(pan[i+1]) - ord(pan[i]) != 1:
            return False
    return True

# print(is_sequential('ABCDE'))
# print(is_sequential('QWERT'))
# print(is_sequential('ASDFF'))
# print(is_sequential('MNOPQ'))

def is_valid_pan(pan):
    if len(pan) !=10:
        return False
    
    if not re.match(r'^[A-Z]{5}[0-9]{4}[A-Z]$', pan):
        return False
    
    if has_adjacent_repetition(pan):
        return False
    
    if is_sequential(pan):
        return False

    return True

df['Status'] = df['Pan_Numbers'].apply(lambda x: "Valid" if is_valid_pan(x) else "Invalid")
print(df.head(10))


valid_count = (df["Status"] == 'Valid').sum()
invalid_count = (df["Status"] == 'Invalid').sum()
missing_count  = total_records - (valid_count + invalid_count)

print('Total_records: ', total_records)
print('Valid: ', valid_count)
print('Invalid: ', invalid_count)
print('Missing: ', missing_count)


df_summary = pd.DataFrame({"TOTAL PROCESSED RECORDS":[total_records],
                           "TOTAL VALID COUNT":[valid_count],
                           "TOTAL INVALID COUNT": [invalid_count],
                           "TOTAL MISSING COUNT": [missing_count]})

print(df_summary.head())

with pd.ExcelWriter("PAN VALIDATION RESULT.xlsx") as writer:
    df.to_excel(writer, sheet_name="PAN Validations", index=False)
    df_summary.to_excel(writer, sheet_name="Summary", index=False)
    