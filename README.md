# Understanding the Relationship Between Lifestyle Habits and Sleep Health

A data analysis project that investigates how lifestyle and health-related factors influence sleep quality and sleep disorders using R and statistical analysis techniques.

## Team Synapse

- Souptik De
- Shubhatithi Deb
- Sourab Kumar
- Prince Kumar

---

## Project Overview

Sleep health plays a crucial role in physical well-being, productivity, mental performance, and overall quality of life.

This project explores the relationship between lifestyle habits and sleep health by analyzing factors such as stress level, physical activity, BMI, heart rate, and daily steps. The goal is to identify which factors have the strongest influence on sleep quality and sleep disorders such as Insomnia and Sleep Apnea.

---

## Research Question

**Which lifestyle and health-related factors have the greatest impact on sleep quality and sleep disorders?**

Specifically, this project analyzes how:

- Stress Level
- Physical Activity
- BMI Category
- Heart Rate
- Daily Steps

affect:

- Sleep Duration
- Sleep Quality
- Sleep Disorders (Insomnia and Sleep Apnea)

---

## Dataset

Dataset Source:

https://www.kaggle.com/datasets/uom190346a/sleep-health-and-lifestyle-dataset

Dataset contains information about:

- Demographics
- Sleep duration
- Sleep quality
- Physical activity
- Stress levels
- BMI category
- Heart rate
- Daily steps
- Sleep disorder status

---

## Project Objectives

### Exploratory Data Analysis

- Analyze sleep disorder distribution
- Study stress and sleep relationships
- Explore BMI and disorder prevalence
- Examine physical activity patterns
- Visualize correlations among health indicators

### Deeper Exploratory Analysis

- Examine occupation and gender interactions
- Identify age-related sleep trends
- Segment high-risk populations

### Statistical Testing

- ANOVA for sleep quality differences
- Chi-Square test for BMI-disorder association
- Kruskal-Wallis test for stress differences

### Factor Importance Analysis

- Identify key predictors of sleep quality
- Measure independent effect of each factor
- Rank factors by predictive importance

---

## Indicators Used

### Sleep Indicators

- Sleep Duration
- Quality of Sleep
- Sleep Disorder

### Lifestyle Indicators

- Physical Activity Level
- Daily Steps
- Stress Level

### Health Indicators

- BMI Category
- Heart Rate
- Blood Pressure

### Demographic Indicators

- Age
- Gender
- Occupation

---

## Technologies Used

### Programming Language

- R

### Libraries

- ggplot2
- dplyr
- tidyr
- scales
- grid
- stats

### Statistical Methods

- Correlation Analysis
- ANOVA
- Tukey HSD
- Chi-Square Test
- Kruskal-Wallis Test
- Wilcoxon Post-hoc Test
- Multiple Linear Regression

---

## Database Integration

This project does not use a traditional database system.

The analysis is performed directly on CSV-based structured data loaded into R data frames.

Data Workflow:

CSV Dataset
↓
Data Cleaning
↓
Transformation
↓
Statistical Analysis
↓
Visualization
↓
Research Findings

---

## Key Findings

- Stress is one of the strongest predictors of poor sleep quality.
- Higher stress levels are associated with reduced sleep duration.
- Overweight and obese individuals show significantly higher disorder prevalence.
- Sleep quality differs significantly across disorder groups.
- High-risk populations can be identified using combined BMI and stress profiles.
- Physical activity positively influences sleep health.

---

## Project Structure

├── data/
│   └── Sleep_health_and_lifestyle_dataset.csv

├── analysis/
│   └── Sleep_Analysis.Rmd

├── figures/
│   ├── plot1.png
│   ├── plot2.png
│   ├── correlation_heatmap.png
│   └── dashboard.png

├── report/
│   └── final_report.pdf

└── README.md

---

## Visualizations Included

- Sleep Disorder Distribution
- Stress vs Sleep Quality
- BMI vs Disorder Rate
- Activity vs Disorder
- Correlation Heatmap
- Occupation & Gender Analysis
- Age Trend Analysis
- High-Risk Population Segmentation

---

## Future Scope

- Machine Learning based prediction of sleep disorders
- Interactive Shiny Dashboard
- Larger and more diverse datasets
- Real-time health monitoring integration

---

## Contributors
## Team Contributions

### Sourab Kumar
- Stress vs Sleep Quality and Sleep Duration Analysis
- Plot Analysis and Visualization Interpretation

### Prince Kumar
- Physical Activity by Sleep Disorder Analysis
- Data Preprocessing and Data Preparation

### Souptik De
- BMI vs Sleep Disorder Analysis
- Interpretation of All Analyses and Findings

### Shubhatithi Deb
- Stress Level by Disorder Group Analysis
- Planning and Design of the Remaining Project Analysis

### Team Synapse
All members collaboratively contributed to:
- Research design
- Dataset understanding
- Exploratory data analysis
- Statistical testing
- Report writing
- Presentation preparation
- Final project review
> Note: Individual contributions listed above correspond to the original research proposal stage. Subsequent analysis, statistical testing, and report development were completed collaboratively by Team Synapse.
---

## License

This project is intended for educational and academic purposes.
