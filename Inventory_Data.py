import pandas as pd
import matplotlib.pyplot as plt

# 1. LOAD CSV - change 'inventory_data.csv' to your filename
df = pd.read_csv("C:/Users/Nayana/OneDrive/ドキュメント/Test+Environment+Inventory+Dataset (1) (1).xlsx")
df.columns = ['Product_ID', 'Category', 'Unit_Cost', 'Demand', 'Availability']

# 2. CALCULATE COLUMNS
df['Shortage'] = (df['Demand'] - df['Availability']).clip(lower=0)
df['Loss_Value'] = df['Shortage'] * df['Unit_Cost']

# 3. 6 KPIs
total_loss = df['Loss_Value'].sum()
total_shortage = df['Shortage'].sum()
avg_loss = df['Loss_Value'].mean()
total_availability = df['Availability'].sum()
total_demand = df['Demand'].sum()
fulfillment_rate = total_availability / total_demand * 100

# 4. PRINT KPIs
print(f"Total Loss: ₹{total_loss:,.2f}")
print(f"Total Shortage: {total_shortage:,.0f}")
print(f"Avg Loss: ₹{avg_loss:,.2f}")
print(f"Total Availability: {total_availability:,.0f}")
print(f"Total Demand: {total_demand:,.0f}")
print(f"Fulfillment Rate: {fulfillment_rate:.1f}%")

# 5. 3 DASHBOARDS
# Dashboard 1: Demand vs Availability
plt.figure(figsize=(10,5))
plt.plot(df['Product_ID'], df['Demand'], marker='o', label='Demand')
plt.plot(df['Product_ID'], df['Availability'], marker='s', label='Availability')
plt.title('Demand vs Availability')
plt.legend()
plt.show()

# Dashboard 2: Top 5 Loss Products
top5 = df.nlargest(5, 'Loss_Value')
plt.figure(figsize=(10,5))
plt.bar(top5['Product_ID'], top5['Loss_Value'], color='red')
plt.title('Top 5 Loss Products')
plt.show()

# Dashboard 3: Shortage by Product
plt.figure(figsize=(10,5))
plt.bar(df['Product_ID'], df['Shortage'], color='orange')
plt.title('Shortage Units')
plt.show()