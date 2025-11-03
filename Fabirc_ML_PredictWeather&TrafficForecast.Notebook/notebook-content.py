# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "a31e291b-059a-4453-bb21-0d608c35bda8",
# META       "default_lakehouse_name": "SmartCity_Traffic_Weather_Realtime_Gold",
# META       "default_lakehouse_workspace_id": "17b733fc-1594-4387-b79c-380cc4bad913",
# META       "known_lakehouses": [
# META         {
# META           "id": "a31e291b-059a-4453-bb21-0d608c35bda8"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import pytz

# Set IST timezone
ist = pytz.timezone("Asia/Kolkata")

# Current time in IST (ISO format)
current_ist = datetime.now(ist).replace(microsecond=0)
print("Current IST:", current_ist.isoformat())

# Generate future times in IST (ISO format)
future_times = [(current_ist + timedelta(hours=i)).isoformat() for i in range(6)]
print("Future IST Times:", future_times)

# Read latest data from Spark table
df_spark = spark.read.table("SmartCity_Traffic_Weather_Realtime_Gold.dbo.SmartCIty_Traffic_Weather_Realtime")
df_pd = df_spark.toPandas()

# Validate required columns
required_cols = ['temp_c', 'humidity', 'wind_kph', 'PeakHourDelay_mins', 'air_quality_pm25', 'AverageSpeed_kmph', 'CongestionIndex_percent']
for col in required_cols:
    if col not in df_pd.columns:
        raise KeyError(f"Column '{col}' not found in source table. Available columns: {df_pd.columns.tolist()}")

# Convert relevant columns to numeric
numeric_cols = ['temp_c', 'humidity', 'wind_kph', 'PeakHourDelay_mins', 'air_quality_pm25', 'AverageSpeed_kmph', 'CongestionIndex_percent']
df_pd[numeric_cols] = df_pd[numeric_cols].apply(pd.to_numeric, errors='coerce')

# Get last row after conversion
last_row = df_pd.iloc[-1]

# Define features for ML models
features = ['hour', 'weekday', 'is_peak_hour', 'rainfall', 'rain_peak_interaction',
            'air_quality_pm25', 'humidity', 'wind_kph', 'PeakHourDelay_mins']

# Create future_df
future_df = pd.DataFrame({
    'localtime': future_times,
    'hour': [datetime.fromisoformat(t).hour for t in future_times],
    'weekday': [datetime.fromisoformat(t).weekday() for t in future_times]
})

# Add peak hour flag
future_df['is_peak_hour'] = future_df['hour'].apply(lambda h: 1 if h in [8, 9, 10, 17, 18, 19, 20] else 0)

# Simulate no rainfall
future_df['rainfall'] = 0
future_df['rain_peak_interaction'] = future_df['rainfall'] * future_df['is_peak_hour']

# Simulate dynamic values
future_df['air_quality_pm25'] = np.linspace(last_row['air_quality_pm25'], last_row['air_quality_pm25'] + 10, len(future_df))
future_df['humidity'] = np.linspace(last_row['humidity'], max(last_row['humidity'] - 10, 0), len(future_df))
future_df['wind_kph'] = np.linspace(last_row['wind_kph'], last_row['wind_kph'] + 5, len(future_df))
future_df['PeakHourDelay_mins'] = last_row['PeakHourDelay_mins']

# Dummy models for simulation (replace with actual trained models)
class DummyModel:
    def __init__(self, base):
        self.base = base
    def predict(self, X):
        return self.base + np.random.normal(0, 0.5, size=len(X))

weather_models = {
    'temp_c': DummyModel(last_row['temp_c']),
    'wind_kph': DummyModel(last_row['wind_kph'])
}
best_speed_model = DummyModel(last_row['AverageSpeed_kmph'])
best_congestion_model = DummyModel(last_row['CongestionIndex_percent'] / 100)

# Prepare feature matrix
X_future = future_df[features]

# Predict
future_temp = weather_models['temp_c'].predict(X_future)
future_wind = weather_models['wind_kph'].predict(X_future)
future_speed = best_speed_model.predict(X_future)
future_congestion = best_congestion_model.predict(X_future)

# Create forecast DataFrame
forecast_df = pd.DataFrame({
    'localtime': future_df['localtime'],
    'Predicted_temp_c': future_temp,
    'Predicted_wind_kph': future_wind,
    'Predicted_AvgSpeed_kmph': future_speed,
    'Predicted_Congestion': np.clip(future_congestion, 0, None)
})

# Display forecast
print("\n✅ 6-Hour Forecast (IST):")
print(forecast_df)

# Save to Lakehouse
spark.createDataFrame(forecast_df).write.mode("append").format("delta").saveAsTable("SmartCity_Traffic_Weather_Realtime_Gold.dbo.WeatherTrafficForecastNext6Hours_ML_Historical_current")
print("✅ Forecast saved to Lakehouse table: WeatherTrafficForecastNext6Hours")
# Save to Lakehouse
spark.createDataFrame(forecast_df).write.mode("overwrite").format("delta").saveAsTable("SmartCity_Traffic_Weather_Realtime_Gold.dbo.WeatherTrafficForecastNext6Hours_ML_Forecast")
print("✅ Forecast saved to Lakehouse table: WeatherTrafficForecastNext6Hours")



# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# MAGIC %%bash
# MAGIC git --version

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
