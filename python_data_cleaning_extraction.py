
# =========================================
# PYTHON DATA CLEANING & EXTRACTION TEMPLATE
# =========================================

import pandas as pd

# Load raw data
df = pd.read_csv("raw_sales_data.csv")

# 1. Remove duplicates
df = df.drop_duplicates(subset="order_id", keep="last")

# 2. Handle missing values
df["sales_amount"] = df["sales_amount"].fillna(0)
df["cost_amount"] = df["cost_amount"].fillna(0)
df["region"] = df["region"].fillna("Unknown")

# 3. Standardize date formats
df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")

# 4. Remove invalid records
df = df[(df["sales_amount"] >= 0) & (df["cost_amount"] >= 0)]

# 5. Feature engineering
df["profit"] = df["sales_amount"] - df["cost_amount"]

# 6. Extract clean dataset for Power BI
df.to_csv("cleaned_sales_data.csv", index=False)

print("Data cleaning and extraction completed successfully.")
