# Zepto_sales_Analysis
# 🛒 Zepto E-Commerce & Inventory Optimization Analysis

An end-to-end SQL-based business intelligence project analyzing over 3,000 grocery SKUs from a quick-commerce dataset. This project focuses on data cleaning, schema optimization, and extracting actionable warehouse logistics and marketing insights.

---

## 📋 Project Description & Business Case

In the high-speed world of quick-commerce (10-minute delivery), maintaining optimal inventory levels, pricing strategies, and shelf availability is critical to survival. 

This project simulates the role of a **Data Analyst at Zepto** tasked with auditing an unrefined dataset of 3,000+ active product lines. By designing an optimized database schema, cleaning corrupted price structures, and writing targeted analytical queries, this project uncovers hidden operational bottlenecks, estimates potential revenue pipelines, and optimizes warehouse space allocation.

### 🛠️ Tech Stack & Methods
* **Database Engine:** MySQL
* **Tools:** MySQL Workbench, GitHub
* **Key SQL Techniques:** DDL/DML, Data Aggregation (`GROUP BY`), Conditional logic (`CASE WHEN`), Filtering & Pattern Matching, Multi-field Ordering.

---

## 📈 Key Business Findings & Analytical Insights

After cleaning and executing the analytical queries (found in `queries.sql`), several critical business insights were uncovered:

### 1. Revenue & High-Value Inventory Leakage
* **Out-of-Stock Loss:** We identified premium, high-margin items (MRP > ₹300) that are currently marked as *Out of Stock*. In quick-commerce, these represent immediate **revenue leakage** as consumers will instantly swap to competitors if these high-velocity items are unavailable.
* **Estimated Revenue Potential:** By calculating `discountedSellingPrice * availableQuantity` across all categories, we mapped out the true financial weight of our current warehouse stock, showing exactly which categories represent our largest locked capital.

### 2. Discount & Marketing Efficiency
* **Value-Driver Optimization:** Grouping the top 10 products by discount percentage highlighted our aggressive loss-leaders. 
* **Premium Margin Protection:** We isolated products with high price points (MRP > ₹500) that maintain healthy margins (discounts < 10%) to understand which premium SKUs do not require heavy promotional discounting to sell.
* **Top-Discount Categories:** Identified the top 5 product categories offering the highest average discount. This reveals whether our promotional campaigns are heavily skewed toward specific segments (e.g., Fresh Produce vs. Packed Goods).

### 3. Warehouse Logistics & Capacity Planning
* **Logistical Weight Footprint:** By calculating the total physical weight (`weightInGms * availableQuantity`) grouped by category, we established a blueprint for shelf-space allocation. Heavy categories require ground-level heavy-duty racking, while lighter categories can be placed higher up.
* **SKU Packaging Classification:** We segmented our catalog dynamically into **Low** (<1kg), **Medium** (1kg–5kg), and **Bulk** (≥5kg) weight classes to help logistics teams optimize delivery rider backpack weight limits.

---

## 🧹 Data Cleansing Steps Summary

Before performing the analysis, the raw dataset required three critical sanitation steps:
1. **Invalid Record Deletion:** Removed corrupted entries where the `mrp` or `discountedSellingPrice` was recorded as `0`.
2. **Currency Unit Normalization:** The raw CSV data stored prices in *paise* (e.g., `2500` instead of `25.00`). These were scaled down globally by dividing by `100.0` to represent standard currency units.
3. **Primary Key Automation:** Successfully mapped a CSV missing an ID column to an `AUTO_INCREMENT` database structure, allowing MySQL to safely generate unique identifiers (`sku_id`) automatically.

---

