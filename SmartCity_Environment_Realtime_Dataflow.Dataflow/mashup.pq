[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared #"traffic_api traffic_realtime_silver" = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null]),
  #"Navigation 1" = Source{[workspaceId = "17b733fc-1594-4387-b79c-380cc4bad913"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "5f89650a-b7fc-4a88-8580-d2d133ab8c62"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "traffic_api.traffic_realtime_silver", ItemKind = "Table"]}[Data]
in
  #"Navigation 3";
shared #"weather_api weather_realtime_silver" = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null]),
  #"Navigation 1" = Source{[workspaceId = "17b733fc-1594-4387-b79c-380cc4bad913"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "5f89650a-b7fc-4a88-8580-d2d133ab8c62"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "weather_api.weather_realtime_silver", ItemKind = "Table"]}[Data]
in
  #"Navigation 3";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "SmartCity_Weather_Traffic_Realtime_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = false, ColumnSettings = [Mappings = {[SourceColumnName = "geo_point_name", DestinationColumnName = "geo_point_name"], [SourceColumnName = "location_name", DestinationColumnName = "location_name"], [SourceColumnName = "location_region", DestinationColumnName = "location_region"], [SourceColumnName = "location_country", DestinationColumnName = "location_country"], [SourceColumnName = "location_lat", DestinationColumnName = "location_lat"], [SourceColumnName = "location_lon", DestinationColumnName = "location_lon"], [SourceColumnName = "location_tz_id", DestinationColumnName = "location_tz_id"], [SourceColumnName = "localtime", DestinationColumnName = "localtime"], [SourceColumnName = "temp_c", DestinationColumnName = "temp_c"], [SourceColumnName = "condition_text", DestinationColumnName = "condition_text"], [SourceColumnName = "wind_kph", DestinationColumnName = "wind_kph"], [SourceColumnName = "humidity", DestinationColumnName = "humidity"], [SourceColumnName = "air_quality_co", DestinationColumnName = "air_quality_co"], [SourceColumnName = "air_quality_no2", DestinationColumnName = "air_quality_no2"], [SourceColumnName = "air_quality_pm25", DestinationColumnName = "air_quality_pm25"], [SourceColumnName = "air_quality_pm10", DestinationColumnName = "air_quality_pm10"], [SourceColumnName = "timestamp_millis", DestinationColumnName = "timestamp_millis"], [SourceColumnName = "AverageSpeed_kmph", DestinationColumnName = "AverageSpeed_kmph"], [SourceColumnName = "CongestionIndex_percent", DestinationColumnName = "CongestionIndex_percent"], [SourceColumnName = "PeakHourDelay_mins", DestinationColumnName = "PeakHourDelay_mins"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared SmartCity_Weather_Traffic_Realtime = let
  Source = Table.NestedJoin(#"weather_api weather_realtime_silver", {"geo_point_name", "localtime"}, #"traffic_api traffic_realtime_silver", {"City", "dateTime"}, "traffic_api traffic_realtime_silver", JoinKind.Inner),
  #"Expanded traffic_api traffic_realtime_silver 1" = Table.ExpandTableColumn(Source, "traffic_api traffic_realtime_silver", {"AverageSpeed_kmph", "CongestionIndex_percent", "PeakHourDelay_mins"}, {"AverageSpeed_kmph", "CongestionIndex_percent", "PeakHourDelay_mins"}),
  #"Reordered columns" = Table.ReorderColumns(#"Expanded traffic_api traffic_realtime_silver 1", {"geo_point_name", "location_name", "location_region", "location_country", "location_lat", "location_lon", "location_tz_id", "localtime", "temp_c", "condition_text", "wind_kph", "humidity", "air_quality_co", "air_quality_no2", "air_quality_pm25", "air_quality_pm10", "AverageSpeed_kmph", "CongestionIndex_percent", "PeakHourDelay_mins", "timestamp_millis"})
in
  #"Reordered columns";
shared DefaultDestination = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  #"Navigation 1" = Source{[workspaceId = "17b733fc-1594-4387-b79c-380cc4bad913"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "a31e291b-059a-4453-bb21-0d608c35bda8"]}[Data]
in
  #"Navigation 2";
shared SmartCity_Weather_Traffic_Realtime_DataDestination = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "17b733fc-1594-4387-b79c-380cc4bad913"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "a31e291b-059a-4453-bb21-0d608c35bda8"]}[Data],
  TableNavigation = Navigation_2{[Id = "SmartCIty_Traffic_Weather_Realtime", ItemKind = "Table"]}[Data]
in
  TableNavigation;
