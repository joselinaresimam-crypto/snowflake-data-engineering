import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session

st.set_page_config(page_title="Wages & CPI USA", layout="wide")

st.title("Wages & CPI USA")
st.write("Simple data pipeline demo in Snowflake: RAW → ANALYTICS → STREAMLIT")

session = get_active_session()

monthly_query = """
SELECT month_date, cpi, country
FROM WAGES_CPI.ANALYTICS.MONTHLY_CPI_USA
ORDER BY month_date
"""

annual_query = """
SELECT year, avg_annual_wage, avg_annual_cpi, country
FROM WAGES_CPI.ANALYTICS.ANNUAL_WAGES_CPI_USA
ORDER BY year
"""

monthly_df = session.sql(monthly_query).to_pandas()
annual_df = session.sql(annual_query).to_pandas()

col1, col2 = st.columns(2)

with col1:
    st.subheader("Monthly CPI - USA")
    st.line_chart(
        monthly_df.set_index("MONTH_DATE")["CPI"]
    )

with col2:
    st.subheader("Annual Average Wage - USA")
    st.bar_chart(
        annual_df.set_index("YEAR")["AVG_ANNUAL_WAGE"]
    )

st.subheader("Annual Average CPI - USA")
st.line_chart(
    annual_df.set_index("YEAR")["AVG_ANNUAL_CPI"]
)

with st.expander("See annual data"):
    st.dataframe(annual_df, use_container_width=True)

with st.expander("See monthly data"):
    st.dataframe(monthly_df, use_container_width=True)