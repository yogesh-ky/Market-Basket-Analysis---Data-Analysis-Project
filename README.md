# Market Basket Analysis: Cross-Sell Opportunity Assessment

![Project Status](https://img.shields.io/badge/Status-Complete-success)
![Analysis Type](https://img.shields.io/badge/Analysis-Market%20Basket-blue)
![Tools](https://img.shields.io/badge/Tools-SQL%20%7C%20PowerBI-orange)

## Project Overview

This project analyzes 396,000+ retail transactions to identify strategic product bundling opportunities that can increase revenue through optimized cross-selling. Using market basket analysis techniques (Association Rules, Lift metrics), I identified $4.58M in incremental revenue potential.

**Key Achievement:** Identified product pairs with purchase associations 30X stronger than random chance, translating to a 38% increase in Average Order Value through strategic bundling.

---

## Executive Summary

### Business Problem
The retail dataset showed customers naturally purchasing multiple items together, but without strategic bundling or cross-sell recommendations, the company was missing revenue optimization opportunities.

### Key Findings
| Metric | Value | Impact |
|--------|-------|--------|
| **Revenue Opportunity** | $4.58M | 52% increase potential from Total Revenue($8M)|
| **Bundle AOV** | $653.91 | 38% higher than regular AOV ($476.09) |
| **Strong Associations Found** | 204,539 pairs | Lift scores up to 200X |
| **Priority Bundles** | Top 10 product pairs | $81,327 incremental revenue |
| **Natural Bundling Behavior** | 62% of orders | 10+ items per basket |

### Financial Impact
- **Incremental Annual Revenue:** $4.58M (20% uplift from strategic bundling)
- **Top 10 Bundles Alone:** $81K revenue opportunity
- **Average Order Value Increase:** 38% ($476 → $654)
- **Implementation Cost:** Minimal (products already in inventory)



## Methodology

### Data Source
- **Dataset:** UCI Machine Learning Repository - Online Retail Dataset
- **Period:** December 2010 - September 2011 (12 months)
- **Transactions:** 541,909 records (396,337 after cleaning)
- **Products:** 3,659 unique SKUs
- **Customers:** 4,334 unique customers
- **Countries:** 37 markets (primarily UK)

### Data Cleaning Process
**Removed:** **using SQL**
- 145,572 records (26.8% of data)
- Cancellations (InvoiceNo starting with 'C')
- Returns (Quantity < 0)
- Null customer IDs
- Test records (non-product StockCodes)
- Zero/negative prices

**Result:** Clean dataset of 396,337 valid transactions

### Analysis Approach

#### 1. **Exploratory Data Analysis**
- Revenue trends over time
- Basket size distribution
- Top products by revenue and frequency
- Average Order Value (AOV) patterns

#### 2. **Market Basket Analysis**
Used Association Rule Mining with three key metrics:

**Support:** How often do items A and B appear together?
```
Support(A,B) = Orders containing both A and B / Total Orders
```

**Confidence:** If customer buys A, what's the probability they buy B?
```
Confidence(A→B) = Support(A,B) / Support(A)
```

**Lift:** How much more likely are A and B bought together vs random?
```
Lift(A,B) = Support(A,B) / (Support(A) × Support(B))
```
- **Lift > 1:** Positive association (bought together more than random)
- **Lift = 1:** No association
- **Lift < 1:** Negative association

#### 3. **Revenue Impact Calculation**
```
Revenue Uplift = times_bought_together × Bundle_Price × 0.20
```
*Assumes 20% increase in purchase frequency through strategic bundling*

---

## 📈 Key Findings

### Finding 1: Strong Natural Bundling Behavior(SQl Analysis)
- **62% of orders** contain 10+ items (11,526 out of 18,402 orders)
- Customers already seeking product combinations
- Average basket size: 20 items
- **Insight:** Customer behavior shows readiness for formalized bundles

### Finding 2: Picnic & Party Product Family Dominates
**Top Revenue Bundle:**
- **Products:** PICNIC BASKET WICKER LARGE + PICNIC BASKET WICKER 60 PIECES
- **Lift Score:** 30.29 (bought together 30x more than expected)
- **Times Purchased Together:** 99 orders
- **Bundle Price:** $659.42
- **Revenue Potential:** $13056 annually

**Pattern Identified:**
- Picnic baskets + accessories naturally pair
- Large basket + smaller basket = complete set
- High price point + high frequency = maximum impact- Higher the price and number of orders for a bundle determines its high revenue potential

### Finding 3: Color Variety Drives High Lift Scores
**Exceptional Associations (Lift > 100):**

| Product Pair | Lift | Interpretation |
|-------------|------|----------------|
| Pink Parasol + Purple Parasol | 141.56 | Customers want color sets |
| Pink Parasol + Red Parasol | 126.04 | Decorative variety packs |
| Landmark Frame variants | 262.14 | Matching frame collections |
| Garden Glove colors | 220.56 | Complete color ranges |

**Insight:** Customers buying decorative/collectible items want multiple color options

### Finding 4: Premium Bundles Show Highest AOV Impact
- **Regular AOV:** $476.09
- **Bundle AOV:** $653.91
- **Increase:** 37.4%
- **Top 10 bundles average:** $1,305.44 per bundle

**Basket Size Analysis:**
| Basket Size | Orders | Avg Order Value |
|-------------|--------|-----------------|
| 1 item | 1,315 | $414.64 |
| 2-3 items | 1,356 | $263.17 |
| 4-5 items | 1,286 | $348.71 |
| 6-10 items | 2,919 | $367.54 |
| **10+ items** | **11,526** | **$549.86** |

**Insight:** Larger baskets don't necessarily mean higher AOV (bulk pricing effect), but strategic bundling can optimize pricing

### Finding 5: Medium Lift Pairs Represent Volume Opportunity
**Distribution of Product Pairs by Lift:**
- Low (1-2): 35,843 pairs
- **Medium (2-5): 128,516 pairs** ← Largest segment
- High (5-10): 32,140 pairs
- Very High (10-50): 7,476 pairs
- Exceptional (50+): 564 pairs

**Insight:** While exceptional Lift scores are exciting, medium Lift pairs (2-5) represent the bulk of scalable opportunities

---

## Top 10 Bundle Recommendations

### Priority Ranking by Revenue Uplift(assuming 20% uplift)

| Rank | Product Bundle | Bundle Price | Revenue Uplift | Lift | Rationale |
|------|---------------|--------------|----------------|------|-----------|
| 1 | Picnic Basket Large + 60 Pieces | $659.42 | $13,056.52 | 30.29 | Highest revenue, strong association |
| 2 | Picnic Basket 60 Pieces + Party Bunting | $654.45 | $5,628.24 | 20.34 | Party/event combo |
| 3 | Regency Cakestand + Picnic Basket | $662.33 | $5,168.17 | 18.45 | Premium entertaining set |
| 4 | Lunch Bag + Picnic Basket | $651.17 | $4,688.44 | 22.12 | Complete picnic solution |
| 5 | Retrospot Cake Cases + Picnic Basket | $650.07 | $3,770.40 | 15.67 | Baking + serving combo |
| 6 | Picnic Basket + Jam Making Set | $653.81 | $3,661.32 | 19.23 | DIY food + storage |
| 7 | Lunch Bag Blue + Picnic Basket | $651.16 | $3,615.52 | 21.45 | Color variant option |
| 8 | Lunch Bag Spaceboy + Picnic Basket | $651.16 | $3,646.50 | 20.89 | Themed set for kids |
| 9 | Baking Set + Picnic Basket | $654.53 | $3,534.46 | 17.34 | Complete party prep |
| 10 | Picnic Basket + Jam Set Printed | $651.02 | $3,385.32 | 16.78 | Gift set opportunity |

**Total Top 10 Impact:** $81,327.90 in incremental annual revenue 

---

## Strategic Recommendations

### Phase 1: Quick Wins (Month 1)
**Objective:** Capture immediate high-value opportunities

**Actions:**
1. **Create Top 5 Bundles**
   - Picnic basket combinations (Bundles 1-5)
   - Offer 10% bundle discount ($59-66 off)
   - Create dedicated bundle SKUs
   - Professional product photography showing both items

2. **Implement "Frequently Bought Together" Section**
   - Add to product detail pages
   - Show top 3 pairs for each product (Lift > 10)
   - Dynamic recommendations based on cart contents
   - One-click "Add Both to Cart" functionality

3. **Quick-Win Marketing**
   - Email to existing customers who bought Product A
   - Recommend Product B with special bundle offer
   - Target high-confidence pairs (>70%)
   - Subject line: "Complete Your [Product A] Experience"

**Expected Outcome:** $20,000 incremental revenue in Month 1

---

### Phase 2: Expansion (Months 2-3)
**Objective:** Scale successful bundles and test new combinations

**Actions:**
1. **Expand Bundle Portfolio**
   - Implement bundles 6-10
   - Create color variety packs (parasols, bowls, erasers)
   - Test themed bundles (picnic party, baking essentials, garden sets)

2. **Optimize Pricing Strategy**
   - A/B test discount levels (5%, 10%, 15%)
   - Monitor price elasticity
   - Calculate optimal discount that maximizes profit

3. **Cross-Sell Campaign Expansion**
   - Retargeting ads for cart abandoners
   - "You might also like" homepage widgets
   - Post-purchase email: "Customers who bought X also loved Y"

4. **Inventory Coordination**
   - Co-locate bundled products in warehouse
   - Ensure stock availability for all bundle components
   - Alert system if bundle component goes out of stock

**Expected Outcome:** Additional $30,000 incremental revenue

---

### Phase 3: Optimization (Months 4-6)
**Objective:** Data-driven refinement and continuous improvement

**Actions:**
1. **Performance Analytics**
   - Track bundle conversion rates by channel
   - Measure AOV lift vs baseline
   - Calculate customer lifetime value (CLV) of bundle buyers
   - Monitor return rates for bundled purchases

2. **Dynamic Bundling Algorithm**
   - Real-time recommendations based on browsing behavior
   - Personalized bundles by customer segment
   - Seasonal bundle adjustments
   - Geographic customization (different countries)

3. **Expansion Opportunities**
   - Apply methodology to new product categories
   - Test subscription bundles (quarterly deliveries)
   - B2B bulk bundle offerings
   - Gift bundle packaging

4. **Competitive Intelligence**
   - Monitor competitor bundling strategies
   - Price benchmarking
   - Identify white space opportunities

**Expected Outcome:** $15,000 additional revenue + sustainable bundling program

---

## Success Metrics & KPIs

### Primary Metrics
| KPI | Baseline | Target | Measurement |
|-----|----------|--------|-------------|
| **Revenue** | $8.76M | $13.34M | +52% increase |
| **Average Order Value** | $476.09 | $620 | +30% minimum |
| **Bundle Conversion Rate** | N/A | 15% | Orders with bundles |
| **Bundle Revenue %** | 0% | 20% | Bundle sales / Total |

### Secondary Metrics
- **Basket Size:** Monitor if bundles increase items per order
- **Customer Retention:** Do bundle buyers have higher repeat rate?
- **Margin Impact:** Ensure bundling doesn't erode margins
- **Cart Abandonment:** Track if bundles reduce abandonment

### Monthly Reporting
- Dashboard updates with bundle performance
- Top/bottom performing bundles
- A/B test results summary
- Inventory turnover for bundled products

---

## Technical Implementation

### Tools & Technologies
- **SQL Server:** Data cleaning, transformation, association rule mining
- **PowerBI:** Interactive dashboard, DAX calculations, visual analytics
- **Python (Optional):** Apriori algorithm validation, advanced analytics

### SQL Views Created
```sql
-- Core analytical views for PowerBI integration
Transactions_clean            -- Filtered and cleaned base table
vw_product_pairs_analysis     -- All product pairs with Lift/Confidence/Support
vw_basket_analysis            -- Basket size distribution and AOV
vw_top_products              -- Product performance metrics
vw_transactions_summary      -- Order-level aggregations
```

### Key DAX Measures
```dax
// Revenue uplift calculation
Revenue Uplift Opportunity = 
    vw_product_pairs_analysis[times_together] * 
    vw_product_pairs_analysis[Bundle_Price] * 
    0.2

// Bundle AOV for top recommendations
Top 10 Bundle AOV = 
    AVERAGEX(
        TOPN(10, vw_product_pairs_analysis, 
             vw_product_pairs_analysis[Projected Bundle Revenue], DESC),
        vw_product_pairs_analysis[Bundle_Price]
    )


```

---

## Dashboard Screenshots

### Executive Summary
![Executive Summary](screenshots/executive_summary.png)
*Overview of business metrics, revenue trends, and basket distribution*

### Product Pair Analysis
![Product Pair Analysis](screenshots/product_pair_analysis.png)
*Detailed cross-sell opportunities with Lift scores and revenue potential*

---

## How to Reproduce This Analysis

### Prerequisites
- SQL Server or PostgreSQL
- PowerBI Desktop
- UCI Online Retail Dataset

### Steps
1. **Clone Repository**
```bash
git clone https://github.com/yourusername/market-basket-analysis.git
cd market-basket-analysis
```

2. **Load Data**
```sql
-- Import online_retail.csv into SQL Server
-- Run data cleaning scripts in order:
\i sql/01_data_exploration.sql
\i sql/02_market_basket_analysis.sql
\i sql/03_basket_analysis.sql
```

3. **Open PowerBI Dashboard**
```
- Open market_basket_dashboard.pbix
- Update data source connection to your SQL Server
- Refresh data
```

4. **Explore Analysis**
- Navigate through dashboard pages
- Use slicers to filter by Lift, product categories
- Export insights to PDF/PowerPoint

---

## References & Resources

### Market Basket Analysis Theory
- Agrawal, R., & Srikant, R. (1994). "Fast Algorithms for Mining Association Rules"
- Association Rule Learning: [Wikipedia](https://en.wikipedia.org/wiki/Association_rule_learning)

### Dataset
- **Source:** [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/352/online+retail)
- **Citation:** Chen, D. (2015). Online Retail Dataset. UCI Machine Learning Repository.

### Tools Documentation
- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/)
- [PowerBI Documentation](https://docs.microsoft.com/en-us/power-bi/)
- [DAX Guide](https://dax.guide/)

---

## Key Learnings & Skills Demonstrated

### Technical Skills
 **SQL Mastery**
- Complex CTEs and window functions
- Self-joins for product pair generation
- Performance optimization for large datasets
- View creation for PowerBI integration

**Data Analysis**
- Association rule mining (Support, Confidence, Lift)
- Statistical significance testing
- Revenue modeling and forecasting
- Basket analysis and customer segmentation

**Business Intelligence**
- PowerBI dashboard design
- DAX measure creation
- Data modeling and relationships
- Interactive filtering and drill-through

**Business Acumen**
- Translating statistical findings to business value
- ROI calculation and financial modeling
- Actionable recommendation frameworks
- Implementation roadmap development

### Analytical Approach
- **Data-Driven:** All recommendations backed by quantitative analysis
- **Business-Focused:** Prioritized by revenue impact, not just statistical significance
- **Actionable:** Clear implementation steps with expected outcomes
- **Scalable:** Framework applicable to other product categories

---

##  Author

**Your Name**
-  Email: yogeshky241@gmail.com
-  LinkedIn: https://www.linkedin.com/in/yogeshk24/
-  GitHub: [

---


