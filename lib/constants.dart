class Constants {
  // For Text Resizing Optimization of large Font Sizes
  static const List<double> stdFontSizes = [1536, 1292, 1086, 914, 768, 646, 456, 322, 272, 228, 192, 162, 136, 114, 96, 84, 72, 60, 48, 36, 30, 24, 21, 18, 16, 14, 12, 11, 10, 9, 8, 7, 6];

  //GUI internal keys
  static const databaseUpdateKey = "__database_update__";

  //TODO: Change these to what the FCB calls them

  //Most crucial flight variables (from Kalman filter)
  static const altitude = "altitude";
  static const verticalSpeed = "v_speed";
  static const acceleration = "acceleration";

  //raw sensor data
  static const accelerometerX = "accel_x";
  static const accelerometerY = "accel_y";
  static const accelerometerZ = "accel_z";

  static const gyroX = "gyro_x";
  static const gyroY = "gyro_y";
  static const gyroZ = "gyro_z";

  static const magnetometerX = "mag_x";
  static const magnetometerY = "max_y";
  static const magnetometerZ = "max_z";

  static const barometer1Pressure = "baro_1";
  static const barometer2Pressure = "baro_2";
  static const pressureReference = "pressure_ref";

  //Orientation
  static const roll = "roll";
  static const pitch = "pitch";
  static const yaw = "yaw";

  static const qX = "q_x";
  static const qY = "q_y";
  static const qZ = "q_z";
  static const qW = "q_w";

  static const angleVertical = "angle_vertical";

  //GPS Data
  static const latitude = "fcb_latitude";
  static const longitude = "fcb_longitude";
  static const gpsAltitude = "gps_alt";
  static const gpsTime = "gps_time";
  static const groundSpeed = "ground_speed";
  static const courseOverGround = "course_over_ground";
  static const gpsSatellites = "gps_sats";

  //Ground station data
  static const groundStationLongitude = "ground_station_longitude";
  static const groundStationLatitude = "ground_station_latitude";
  static const groundStationAltitude = "ground_station_altitude";
  static const groundStationPressure = "ground_station_pressure";
  static const groundStationTemperature = "ground_station_temperature";

  //FCB State stuff
  static const fcbState = "fcb_state_text";
  static const fcbStateNumber = "fcb_state_number";
  static const pyroContinuity = "pyro_continuity";
  static const pyroFireStatus = "pyro_status";
  static const flashUsage = "flash_usage";
  static const softwareVersion = "software_version";
  static const serialNumber = "board_serial_number";
  static const timestampMs = "time_stamp_ms";
  static const callsign = "callsign";
  static const bluetoothConnection = "ble_client";

  //Misc
  static const batteryVoltage = "battery_voltage";
  static const temperature = "temperature";
  static const groundElevation = "ground_elevation";
  static const groundTemperature = "ground_temperature";
  static const pitotPressure = "pitot_pressure";
}
