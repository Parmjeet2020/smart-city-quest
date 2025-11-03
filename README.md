# Project Smart City Quest: Showcasing "Best Use of Real-Time Intelligence (RTI)" with Microsoft Fabric
***
The project aims at gathering the Weather and Traffic data for selective 5 cities in realtime and reporting in realtime how these parameters are changing every hour. It then shows the correlation between the traffic speed & congestion with weather KPIs like temperature, AQI etc. Also, it has the feature to predict and forecast weather and traffic KPIs for next 6 hours.

## Logical Architecture
***
![Smart City Logical Architecture](https://github.com/user-attachments/assets/03ded6c7-eb8c-4626-9b9f-6a2c33df434d)

## High level flow
***
![Smart City Quest High Level Flow](https://github.com/user-attachments/assets/341923bc-7a97-4e9f-88a0-273d669522b1)

## Project Demo
***

## Project Components & Setup
***
### Environments

### Dev Workspace
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

#### Eventhouses

#### Notebooks

#### Gold Lakehouse

#### Power Bi Dashboard

#### Orchestration Pipeline

#### Deployment Pipeline
