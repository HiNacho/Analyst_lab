# BUSINESS ANALYTICS CASE STUDY REPORT: BANK MARKETING CAMPAIGN OPTIMIZATION

**Program:** AnalystLab Africa Data Analytics Internship Program  
**Week 5 Case Study:** Batch B (1st of June to 1st of August)  
**Prepared by:** Intern  
**Date:** July 8, 2026  
**Dataset:** Bank Marketing Dataset (11,162 records, 17 features)  

---

## 1. Introduction
In retail banking, term deposits represent a stable and low-cost source of funding, which banks can deploy for lending activities to drive profitability. However, retail banks face intense competition and rising customer acquisition costs (CAC). Direct marketing campaigns, primarily conducted via telephone calls, remain a primary channel for selling term deposits. While direct marketing is personal, it is often inefficient, resulting in low conversion rates, customer fatigue, and high operational costs.

This report analyzes historical campaign data from a retail bank to understand customer behavior and optimize the conversion rate of term deposit subscriptions. By leveraging exploratory data analysis (EDA) and machine learning (Random Forest feature importance), we identify key drivers of subscription success and provide data-driven recommendations to maximize campaign return on investment (ROI).

---

## 2. Business Problem Statement
Direct telephone marketing campaigns suffer from low efficiency. In our dataset:
* **Total Campaigns Analysed**: 11,162 customer contacts.
* **Conversion Rate**: 47.38% (5,289 subscribed, 5,873 did not subscribe).
* **Core Business Challenge**: The bank's outreach is currently unsegmented and untargeted. High volumes of cold calls are placed (especially in certain months like May), which creates campaign fatigue, increases call center overheads, and leads to high customer rejection rates. 

### Key Business Questions:
1. *Why do some customers subscribe to term deposits while others do not?*
2. *Which specific customer segments are most likely to respond positively to marketing campaigns?*
3. *How can the bank optimize its outreach schedule, contact frequency, and communication channels to maximize conversions while reducing costs?*

---

## 3. Dataset Description & Methodology
The dataset analyzed is `bank.csv`, which contains **11,162 rows and 17 columns**, with no missing values. The target variable is `deposit` (binary: `yes` / `no`), representing whether the client subscribed to a term deposit.

### Features breakdown:
* **Customer Demographics**: `age` (numerical), `job` (categorical), `marital` (categorical), `education` (categorical).
* **Financial Profile**: `balance` (average yearly balance in euros), `default` (has credit in default? binary), `housing` (has housing loan? binary), `loan` (has personal loan? binary).
* **Campaign Details**: `contact` (communication type), `day` (last contact day of the month), `month` (last contact month of the year), `duration` (last contact duration in seconds).
* **Previous Campaign History**: `campaign` (number of contacts performed during this campaign), `pdays` (days passed since last contact from a previous campaign), `previous` (number of contacts performed before this campaign), `poutcome` (outcome of the previous marketing campaign).

### Analytical Methodology:
1. **Exploratory Data Analysis (EDA)**: Profiling numerical distributions and cross-tabulating categorical variables against subscription rates.
2. **Feature Engineering**: Binning continuous variables (age, balance, campaign, duration) to uncover non-linear relationships.
3. **Driver Identification (Machine Learning)**: Training a Random Forest Classifier on label-encoded features to determine relative feature importance.

---

## 4. Key Findings & Data Analysis

Our analysis revealed that subscription conversion is not random but highly correlated with specific behavioral, temporal, and demographic features.

### A. Statistical Key Drivers of Subscription Success
A Random Forest Classifier trained on the dataset identified the relative importance of each feature in predicting whether a customer will subscribe:

| Rank | Feature | Random Forest Importance | Description |
|------|---------|-------------------------|-------------|
| 1    | `duration` | 36.87% | Last contact call duration in seconds |
| 2    | `balance` | 8.88% | Average yearly balance of the customer |
| 3    | `age` | 8.40% | Age of the customer |
| 4    | `month` | 8.32% | Month of contact |
| 5    | `day` | 7.16% | Day of contact |
| 6    | `pdays` | 4.58% | Number of days since last campaign contact |
| 7    | `contact` | 4.48% | Communication contact channel (cellular vs. landline vs. unknown) |
| 8    | `job` | 3.83% | Customer's occupation |

*Note: Visualized in [assets/driver_importance.png](file:///Users/mac/Documents/Tech_projects/Analyst_lab/week%205/assets/driver_importance.png).*

### B. Detailed Analysis of Key Drivers

#### 1. The Call Duration Effect (The Golden Metric)
Call duration is the single strongest predictor of subscription.
* **Shortest calls (0-2 minutes)**: Subscription rate of just **9.02%**.
* **Medium calls (3.5-5.5 minutes)**: Subscription rate of **48.54%**.
* **Longest calls (9.5+ minutes)**: Subscription rate of **84.70%**.
* *Insight*: Engaging the customer long enough to explain the product benefits is critical. Conversely, very short calls represent immediate rejections or poor agent engagement.

#### 2. Temporal Bottlenecks: The "May Campaign" Fatigue
Analyzing call volume and conversion rate by month revealed a major operational mismatch:
* **May Campaigns**: The bank conducted its heaviest outreach in May, placing **2,824 calls** (25.3% of all calls). However, May recorded the **lowest subscription rate at 32.76%**.
* **Off-Peak Months**: March, September, October, and December had very low call volumes (averaging 100-300 calls) but recorded **subscription rates between 82.4% and 90.9%**.
* *Insight*: The bank is heavily over-contacting customers during May, leading to campaign fatigue and wasted resources, while missing opportunities in high-performing transitional months.

#### 3. Diminishing Returns of Contact Frequency (`campaign`)
Repeatedly calling the same customer in a single campaign quickly yields diminishing returns:
* **1st Contact Attempt**: Subscription rate of **53.38%** (4,798 calls).
* **2nd Contact Attempt**: Subscription rate of **46.27%**.
* **6-10 Contact Attempts**: Subscription rate drops to **31.40%**.
* **10+ Contact Attempts**: Subscription rate drops to **22.38%**.
* *Insight*: If a customer does not subscribe within the first two calls, placing more calls is counterproductive and increases customer irritation.

#### 4. The Power of Previous Campaign Success (`poutcome`)
Historical customer relationships are highly predictive:
* Customers who successfully subscribed in a previous campaign (`poutcome = success`) have a **91.32% subscription rate** in the current campaign.
* Customers with unknown history subscribe at **40.67%**.

---

## 5. Business Insights

Based on the statistical analysis, we can segment the customer base into clear risk and opportunity profiles.

### Opportunity Profiles (High Conversion Segments)
1. **Students and Retirees**: Students have a **74.72%** conversion rate and retirees have a **66.32%** conversion rate. These groups represent a major opportunity. Their flexible schedules and desire for low-risk, steady-yield savings products align perfectly with term deposits.
2. **Cellular Contacts**: Customers contacted via cellular phone have a **54.33%** subscription rate, whereas those with "unknown" contact channels convert at only **22.59%**.
3. **High-Balance Customers**: The top 20% of customers by account balance (yearly balance > €1,708) subscribe at a rate of **58.00%**, compared to only **34.73%** for the bottom 20% (< €122 balance).

### Risk Profiles (Low Conversion Segments)
1. **Blue-Collar Workers**: Blue-collar workers constitute 17.4% of the database but convert at only **36.42%**. Similarly, entrepreneurs convert at **37.50%**. These groups likely face cash flow volatility or have a preference for other financial vehicles.
2. **Outstanding Personal/Housing Loans**: Customers with housing loans subscribe at **36.64%** (compared to 57.03% for no housing loan). Customers with personal loans subscribe at **33.15%**. Debtor customers have lower disposable income to lock up in term deposits.

---

## 6. Actionable Recommendations

To maximize the conversion rate and optimize marketing spend, the bank should implement the following 5 strategies:

### 1. Re-Allocate Monthly Campaign Budgets
* **Action**: Shift call center capacity away from May. Reduce outreach volume in May by 50% and reallocate agents to March, April, September, and October.
* **Impact**: Decreases customer fatigue, lowers cost-per-acquisition, and increases average conversion rates.

### 2. Implement a Smart Call-Capping Policy
* **Action**: Implement a hard cap of **3 contact attempts per customer** per campaign. If a customer is contacted three times without subscribing, flag them as "inactive" for the current campaign.
* **Impact**: Saves call center hours, reduces agent burnout, and avoids customer annoyance.

### 3. Deploy Segment-Specific Product Pitching
* **Action**: 
  * Pitch low-risk, monthly-payout savings plans to **Retirees** and high-yield, flexible-duration plans to **Students**.
  * Avoid cold-calling **Blue-Collar** workers and debtors with term deposit offers. Instead, offer them debt consolidation or automated micro-savings options.
* **Impact**: Increases message resonance and improves agent call duration/engagement.

### 4. Transition to Cellular and Digital Channels
* **Action**: Prioritize cellular communication over landlines. Mandate updating customer contact details to eliminate the "unknown" contact channel category, which currently performs poorly (22.59% conversion).
* **Impact**: Increases the likelihood of reaching clients at convenient times, raising subscription rates.

### 5. Prioritize "Warm Leads" (Previous Successes)
* **Action**: Automate immediate outreach to any client marked as `poutcome = success` in previous campaigns. These clients should be contacted first when new deposit rates are introduced.
* **Impact**: Leverages the outstanding 91.32% historical conversion rate for easy wins.

---

## 7. Conclusion
The Bank Marketing direct marketing campaign can be significantly optimized. By moving away from high-volume, unsegmented cold-calling (exemplified by the massive May outreach) and moving toward target segment marketing (focusing on students, retirees, high-balance clients, and cellular contacts), the bank can achieve higher conversion rates with a fraction of the current call volume. Implementing contact capping and prioritizing warm leads will enhance operational efficiency, reduce customer irritation, and maximize deposit-driven revenues.
