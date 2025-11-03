# Project Smart City Quest: Showcasing "Best Use of Real-Time Intelligence (RTI)" with Microsoft Fabric

The project aims at gathering the Weather and Traffic data for selective 5 cities in realtime and reporting in realtime how these parameters are changing every hour. It then shows the correlation between the traffic speed & congestion with weather KPIs like temperature, AQI etc. Also, it has the feature to predict and forecast weather and traffic KPIs for next 6 hours.

## Logical Architecture

![Smart City Logical Architecture](https://github.com/user-attachments/assets/03ded6c7-eb8c-4626-9b9f-6a2c33df434d)

## High level flow

![Smart City Quest High Level Flow](https://github.com/user-attachments/assets/341923bc-7a97-4e9f-88a0-273d669522b1)

## Project Demo


## Project Components & Setup

### Environments

### Dev Workspace
<hr style="border: 0.2px solid #ccc;" />
Prerequiste to setup:
- Must have a Microsoft Fabric license (Pro or higher, or Fabric Capacity SKU like F8, F16, etc.).
- Need to be part of a Microsoft 365 tenant with Fabric enabled.
- Need permissions to create workspaces (need to Contributor or Admin)

Steps to create workspace

- Go to: https://app.fabric.microsoft.com
- Sign in with the organizational Microsoft 365 account
- On the left navigation bar, click Workspaces (folder icon)
- Can see a list of existing workspaces (if any)
- Click the ➕ New workspace button (top right)
- Create a workspace panel will open.
  - Name: Choose a unique name FabricHackathon2025Dev
  - Description: (Optional) Add a short description for team clarity.
  - Advanced settings:
    - Licensing mode: Choose one:
    - Pro: Uses Power BI Pro licenses for small-scale workspaces.
    - Premium / Fabric capacity: Choose this to enable Fabric workloads (Lakehouse, Eventstream, etc.).
    - Assign Fabric capacity:
    - Choose the available capacity (e.g., F64 – East US)
      - This is required to use Lakehouse, Eventstream, Eventhouse, etc.
- Add members
  - Can add members and assign roles:
    - Admin: Full control over workspace.
    - Member: Can edit and publish items.
    - Contributor: Can add and manage data items.
    - Viewer: Read-only access.
- Click on save
Created workspace will appear in the workspace list.
Once created, click on "Workspacec" left-hand navigation and select the created workspace. This is where all the components you're going to create appears. Shown below is the dev workspace of the projet.

<img width="957" height="415" alt="image" src="https://github.com/user-attachments/assets/6d529c7e-f8d9-49b0-9fb2-730593450c15" />

#### Lakehouses
---
- In the workspace created in above steps, click on a new item from top navigation → Lakehouse
- Give it a name, like SmartCity_Traffic_Weather_Realtime_Bronze , SmartCity_Traffic_Weather_Realtime_Silver, SmartCity_Traffic_Weather_Realtime_Gold
- This lakehouse will serve as both the streaming data destination and additionally the storage layer
- From the workspace UI, click any lakehouse to see its details

Shown below is one of the Lakehouse in the projet.

<img width="959" height="415" alt="image" src="https://github.com/user-attachments/assets/9dc4fb44-2c47-414c-b584-407b3b1d9ff1" />


#### Eventhouses
---
- In the workspace created earlier, create a new item → Eventhouse
  - This provides the queryable streaming database in KQL
- In the Eventhouse, can see a default KQL database created.

Shown below is one of the event house in the project.

<img width="959" height="414" alt="image" src="https://github.com/user-attachments/assets/18808821-2422-4b57-8b7b-f0978d3236e7" />

#### Event Stream
---
- In the workspace, create a new item → In the Real-Time Hub, create a new Eventstream
  - Configure the source
    - Choose a custom endpoint
    - give the name to the source
    - click on Add
- The processed events are be connected to two destinations: Eventhouse and lakehouse
- Connect the event stream to lakehouse
  - As shown in the digram below, follow the steps to add lake house as destination:
    - On the Eventstream canvas, click Add destination → choose Lakehouse
    - Configure:
      - Destination name – SmartCity_Traffic_Realtime_LakeHouse
      - Select the Bronze lakehouse
        - create a new delta table for bronze
        - Input data format (JSON, Avro, CSV) for the incoming events
    - Publish the Eventstream. Once Active/Ingesting, can monitor status and verify via Data preview

 <img width="960" height="411" alt="image" src="https://github.com/user-attachments/assets/f558c879-4a94-4ddf-b23e-cada8eeba6bb" />

Shown below is one of the event streams created in the project.

<img width="959" height="415" alt="image" src="https://github.com/user-attachments/assets/e9b5349e-955c-476e-b951-3f99d684baeb" />

- Validation and Monitoring
  - In the Eventstream canvas, can see the status of source(s) and destination(s) (e.g., Ingesting, Active)
  - Use Data preview + Data insights tabs to check throughput and errors
  - In Lakehouse, open the table to verify rows are arriving
  - In Eventhouse, open KQL database and run queries to view data arrival.

#### Notebooks
---
- In workspace created earlier, click New item → Notebook
- Give the notebook a name like Realtimetraffic_ingestion or weatherapi_refreshrun
- Write python (or pyspark) code to perform the desired task, such as notebooks in the project fetch the traffic information realtime through tomtom traffic api. Realtime traffic details are then sent to Eventstream by connecting the Eventhub of Realtime_traffic_tomtom Eventstream
- Once Eventstream executes, traffic data is sent to Bronze Lakehouse
- Similarly have written the code to fetch information through weatherapi

Following diagram shows where to find notebooks once created, in the workspace UI:

<img width="959" height="389" alt="image" src="https://github.com/user-attachments/assets/3586bb36-160d-4787-9625-fe94e1ab5261" />

Clicking on any notebook takes to following screen:

<img width="959" height="413" alt="image" src="https://github.com/user-attachments/assets/9f0dd9b8-4ae4-462e-939c-ff314eb31a27" />

#### Orchestration Pipeline
---
Pipeline created to orchestrate notebooks execution for data ingestion, silver layer curation, forecast ML models and dataflow execution for preparing gold lakehouse. 

Following are the steps to setup pipeline:
- In workspace created earlier, click New item → Pipelin
- Give the pipeline a meaningful name such as "SmartCity_Traffic_Realtime_Pipeline"
- In the pipeline canvas, add relevant activities required to perform the funcion. For example, for this project following activities are in the pipeline:
  - Notebook: to invoke event hubs to bring data from weather & traffic API, through event stream and running forecast ML model
  - Copy data: to prepare Silver lakehouse tables with unique datasets
  - Data flow: to invoke dataflow gen2 for transformations to prepare gold lakehouse
  - Office 365 Email: to send email notifications on success or failure of the pipeline

Below diagram shows the pipeline canvas:

<img width="959" height="414" alt="image" src="https://github.com/user-attachments/assets/9f2880d7-690a-4500-a331-881ac9174ce1" />

#### Gold Lakehouse
---
Dataflow gen2 activity named "SmartCity_Traffic_Realtime_Gold_Dataflow" in the data factory pipeline "SmartCity_Traffic_Realtime_Pipeline" triggers merge operation of the datasets in silver layer. While merging the dataset, data of only selective fields is being stored in the gold lakehouse table "SmartCIty_Traffic_Weather_Realtime". Data from this lakehouse is used to report important KPIs on Power Bi dashboard and for ML model notebook to forecast. Shown below is the lakehouse table view:

<img width="959" height="415" alt="image" src="https://github.com/user-attachments/assets/7338e082-4d6a-4696-b6fd-28834095047b" />

#### Power Bi Dashboard
---
Power Bi dashboard has several reports, built on the data from Gold lakehouse. Few of those reports are:
- 6-hour Weather & Traffic Forecast: provides short-term, localized predictions about weather and road conditions over the next six hours which are ideal for travel, logistics, and real-time decision-making
- 6-hour Wind & speed Forecast: provides a short-term prediction of wind conditions—direction, intensity, and gusts—for the next six hours. It’s especially useful for aviation, marine operations, logistics, outdoor events, and real-time traffic or safety planning
- Weather & Air Quality Insights: provide a combined view of atmospheric conditions (weather) and pollution levels (air quality), helping users understand not just what the weather will be but how healthy and safe the air will be to breathe or operate in
- Correlation KPIs (weather, AQI & Traffic): these reveal how environmental and atmospheric factors affect mobility, safety, and pollution. These Correlation KPIs help identify why certain traffic or air conditions occur and how to predict or manage them better

Below diagram gives a glimpse of the dashboard:

<img width="959" height="412" alt="image" src="https://github.com/user-attachments/assets/88a78d4c-b1b5-4ac0-b032-a7217a6d1308" />

#### Deployment Pipeline
---
