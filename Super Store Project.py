##SuperStore ETL & EDA Project
##Import Libraries

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import warnings
warnings.filterwarnings('ignore')

plt.rcParams['figure.figsize'] = (10,5)
# Load Dataset
df = pd.read_csv(r"C:\Users\Nayana\Downloads\Sample - Superstore.csv", encoding="latin1")

print(df.head())
print(df.info())


##Data Cleaning (ETL)
##Check Missing Values
print(df.isnull().sum())

# Remove Duplicates
df.drop_duplicates(inplace=True)

# Convert Date Columns
df['Order Date'] = pd.to_datetime(df['Order Date'])
df['Ship Date'] = pd.to_datetime(df['Ship Date'])

# Create Day and Month Columns
df['Month'] = df['Order Date'].dt.month_name()
df['Day'] = df['Order Date'].dt.day_name()

##1. Exploratory Data Analysis
##1.Most Frequent Product Sold
most_product = df['Product Name'].value_counts().head(10)

print(most_product)

most_product.plot(kind='bar')
plt.title("Top 10 Most Sold Products")
plt.show()

##2.Most Ordered Region
print(df['Region'].value_counts())

df['Region'].value_counts().plot(kind='bar')
plt.title("Orders by Region")
plt.show()

##3.Most Ordered State
top_state = df['State'].value_counts().head(10)

print(top_state)

top_state.plot(kind='bar')
plt.title("Top States")
plt.show()

##4.Most Ordered City
top_city = df['City'].value_counts().head(10)

print(top_city)

top_city.plot(kind='bar')
plt.title("Top Cities")
plt.show()

##5.Highest Discount Given
discount_customer = df.groupby('Customer Name')['Discount'].sum()

print(discount_customer.sort_values(ascending=False).head(10))

##6.Most Sold Category
category_sales = df.groupby('Category')['Quantity'].sum()

print(category_sales)

category_sales.plot(kind='pie', autopct='%1.1f%%')
plt.title("Most Sold Category")
plt.show()

##7.Most Sold Sub-Category
subcat = df.groupby('Sub-Category')['Quantity'].sum()

print(subcat.sort_values(ascending=False).head(10))

##8.Most Loyal Customer
loyal = df['Customer Name'].value_counts()

print(loyal.head(10))

##9.Business Flourished by Day
day_sales = df.groupby('Day')['Sales'].sum()

print(day_sales)

day_sales.plot(kind='bar')
plt.title("Sales by Day")
plt.show()

##10.Business Flourished by Month
month_sales = df.groupby('Month')['Sales'].sum()

print(month_sales)

month_sales.plot(kind='bar')
plt.title("Sales by Month")
plt.show()

##2. Sales & Profit Analysis
##1.Sales-Profit Ratio per Customer
customer_sp = df.groupby('Customer Name')[['Sales','Profit']].sum()

customer_sp['Ratio'] = customer_sp['Profit'] / customer_sp['Sales']

print(customer_sp.sort_values('Ratio', ascending=False).head())

##2.Region Sales & Profit
region_profit = df.groupby('Region')[['Sales','Profit']].sum()

print(region_profit)

region_profit.plot(kind='bar')
plt.show()

##3.State Sales & Profit
state_profit = df.groupby('State')[['Sales','Profit']].sum()

print(state_profit.sort_values('Profit', ascending=False).head(10))

##4.City Sales & Profit
city_profit = df.groupby('City')[['Sales','Profit']].sum()

print(city_profit.sort_values('Profit', ascending=False).head(10))

##5.Most Profitable Segment
segment_profit = df.groupby('Segment')['Profit'].sum()

print(segment_profit)

segment_profit.plot(kind='bar')
plt.show()

##6.Most Profitable Product
product_profit = df.groupby('Product Name')['Profit'].sum()

print(product_profit.sort_values(ascending=False).head(10))

##7.Best Seller Category
best_category = df.groupby('Category')['Sales'].sum()

print(best_category)

##8.Best Seller Sub-Category
best_subcat = df.groupby('Sub-Category')['Sales'].sum()

print(best_subcat.sort_values(ascending=False).head(10))

##3. Bivariate Analysis
##1.Profitable Category by Region
cat_region = pd.pivot_table(
    df,
    values='Profit',
    index='Region',
    columns='Category',
    aggfunc='sum'
)

print(cat_region)

cat_region.plot(kind='bar')
plt.show()

##2.Best Seller Day by Category
day_cat = pd.pivot_table(
    df,
    values='Sales',
    index='Day',
    columns='Category',
    aggfunc='sum'
)

print(day_cat)

##3.Profitable Ship Mode by Region
ship_region = pd.pivot_table(
    df,
    values='Profit',
    index='Region',
    columns='Ship Mode',
    aggfunc='sum'
)

print(ship_region)

##4.Best Seller Month by Category
month_cat = pd.pivot_table(
    df,
    values='Sales',
    index='Month',
    columns='Category',
    aggfunc='sum'
)

print(month_cat)

##5.Best Seller Sub-Category by Segment
sub_seg = pd.pivot_table(
    df,
    values='Sales',
    index='Sub-Category',
    columns='Segment',
    aggfunc='sum'
)

print(sub_seg)

##4. Multivariate Analysis
##1.Correlation Analysis
corr = df[['Sales','Quantity','Discount','Profit']].corr()

print(corr)

##Correlation Heatmap
plt.figure(figsize=(6,4))

plt.imshow(corr, cmap='coolwarm')

plt.colorbar()

plt.xticks(range(len(corr.columns)), corr.columns)
plt.yticks(range(len(corr.columns)), corr.columns)

plt.title("Correlation Matrix")

plt.show()

##NumPy Usage
sales = np.array(df['Sales'])

print("Average Sales:", np.mean(sales))
print("Maximum Sales:", np.max(sales))
print("Minimum Sales:", np.min(sales))
print("Standard Deviation:", np.std(sales))