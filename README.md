<div align="center">
  <img src="https://github.com/rbeaubrun/SQL-Exploratory-Analysis-Project/blob/main/covid19%20(1).jpg" alt="covid19 (1)">
</div>

# Global Health Data Analysis & Visualization

## Project Overview  
This project utilizes SQL for exploratory data analysis (EDA) on COVID-19 data from the Our World in Data dataset. Spanning from 2020 to 2023, the analysis examines key relationships between infections, vaccinations, and deaths across five major continents. View the full codebase <a href="https://github.com/rbeaubrun/Visualizing-the-Impact-of-Covid-19/blob/main/Covid-19%20EDA%20v2.sql">here.</a>

Additionally, an interactive Power BI dashboard was designed to visualize trends, highlight regional impacts, and support data-driven decision-making for global health strategies.

## Key Tasks  
- **SQL EDA**:  
  Conducted in-depth exploratory analysis of COVID-19 data, investigating the relationships between infection rates, vaccination coverage, and death tolls. Utilized **window functions** to compute running totals of cases and vaccination trends over time. Applied **aggregation techniques** such as `SUM()`, `AVG()`, and `RANK()` to rank countries by case count and vaccination rates. Created **temporary tables and common table expressions (CTEs)** to structure the analysis efficiently and improve query readability.

- **Power BI Dashboard**:  
  Designed an interactive dashboard to visualize infection trends and vaccination impacts across five continents. Incorporated **SQL-extracted summary tables** to streamline Power BI integration. Enabled dynamic filtering by country, date, and continent for deeper insights.

- **Insights & Reporting**:  
  The analysis provided actionable insights into the progression of the COVID-19 pandemic across different regions. Key trends identified include:
  - The impact of vaccination rates on decreasing death tolls.
  - Variation in infection peaks across different continents.
  - Correlation between high case rates and healthcare capacity challenges.

## Technologies Used  
- **SQL**: Data extraction, transformation, cleaning, and exploratory analysis  
- **Power BI**: Interactive data visualization and dashboard creation  
- **PostgreSQL (pgAdmin4)**: Execution of SQL queries and database management  
- **Our World in Data**: COVID-19 dataset (2020–2023)

## Conclusion  
This project highlights the power of SQL and Power BI in conducting meaningful analyses and creating dynamic visualizations. By leveraging SQL-based data transformations and window functions, the dashboard effectively presents key health trends and supports informed decision-making in pandemic response planning.

