# Team Activity 2

## Documentation

For this project, we began by constructing the Point4 model, which features an SQL script designed to address missing values within our dataset. The script identifies these gaps and systematically substitutes them with the median value for each respective field. Once the table was successfully created with all missing values imputed, we advanced to tackling the requirements of Point5. Each query crafted to resolve Point5's objectives was subsequently transformed into a distinct table within BigQuery. This structured approach allowed for seamless integration and accessibility in Looker Studio, which served as the final phase of our project. In Looker Studio, we curated a dashboard that effectively displays the results, providing a comprehensive report and visual analysis of our findings.

The key to the BigQuery was sent with the zip file, we decided not to upload it to the repo for safety reasons.

For Point 4:

- imputate.sql: Creates imputate table with the median of the prices in case of null values.

  - Olimpica_Prices: A subset of prices from the Olimpica source, excluding any NULL values. This is used as a basis for calculating the median price of products sold in Olimpica stores.

  - Ranked_Prices: A ranking of the Olimpica prices with ascending and descending row numbers, along with the total count of prices. This aids in the median price calculation by providing rank positions needed to identify the middle value(s).

  - Median_Price: The calculated median price of products sold in Olimpica stores. If the total number of prices is odd, the median is the middle value. If even, it's the average of the two middle values. This CTE provides a single value representing the median across all Olimpica product prices.

For Point 5:

- avg_spending.sql: Query that calculates the average spending per product in each supermarket

  - Compras_Aggregated: CTE that aggregates the number of purchases per product.

  - Vinotinto_Prod: CTE that selects the products that are Vino Tinto from both supermarkets.

- top_buyers.sql: Order the results by comprasTotales in descending order after the union operation

  - top_clients: CTE that gets the top clients from Exito and Olimpica.

- unique_olimpica_buyers.sql: Query that returns the unique buyers of the Olimpica supermarket with Left Join to check for the existence of the EXI product in the purchase table.

- popular_purchases.sql: Query that returns only the most bought products from both supermarkets.

- unpurchased_items.sql: Query that returns the products that were not bought from both supermarkets.

## Dashboard Link

https://lookerstudio.google.com/reporting/884c24a6-340e-4788-92eb-ff20826a3937

## How to run:

Try running the following commands:

- dbt run

### Resources:

- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
