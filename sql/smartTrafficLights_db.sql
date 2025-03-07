CREATE DATABASE IF NOT EXISTS SmartTrafficLights;
USE SmartTrafficLights;

-- 1. Intersections Table
CREATE TABLE IF NOT EXISTS Intersection (
    intersectionId INT AUTO_INCREMENT PRIMARY KEY,
    intersectionName VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    latitude DECIMAL(10,8) NOT NULL CHECK (latitude BETWEEN -90 AND 90),
    longitude DECIMAL(11,8) NOT NULL CHECK (longitude BETWEEN -180 AND 180)
);

-- 2. Traffic Lights Table
CREATE TABLE IF NOT EXISTS TrafficLight (
    lightId INT AUTO_INCREMENT PRIMARY KEY,
    intersectionId INT NOT NULL,
    status ENUM('Red', 'Yellow', 'Green') NOT NULL,
    greenDuration INT NOT NULL CHECK (greenDuration > 0),
    orangeDuration INT NOT NULL CHECK (orangeDuration > 0),
    redDuration INT NOT NULL CHECK (redDuration > 0),
    lightType ENUM('Standard', 'Pedestrian', 'Cyclist') NOT NULL, 
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (intersectionId) REFERENCES Intersection(intersectionId) ON DELETE CASCADE
);

-- 3. Traffic Sensors Table
CREATE TABLE IF NOT EXISTS TrafficSensor (
    sensorId INT AUTO_INCREMENT PRIMARY KEY,
    trafficLightId INT NOT NULL,
    sensorType VARCHAR(50) NOT NULL,
    lastDataTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    FOREIGN KEY (trafficLightId) REFERENCES TrafficLight(lightId) ON DELETE CASCADE
);

-- 4. Traffic Data Table
CREATE TABLE IF NOT EXISTS TrafficData (
    dataId INT AUTO_INCREMENT PRIMARY KEY,
    sensorId INT NOT NULL,
    trafficDensity INT NOT NULL CHECK (trafficDensity >= 0),
    averageSpeed FLOAT(5,2) CHECK (averageSpeed >= 0),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensorId) REFERENCES TrafficSensor(sensorId) ON DELETE CASCADE
);

-- 5. AI Traffic Predictions Table
CREATE TABLE IF NOT EXISTS AI_TrafficPrediction (
    predictionId INT AUTO_INCREMENT PRIMARY KEY,
    trafficLightId INT NOT NULL,
    predictedCongestionLevel ENUM('Low', 'Medium', 'High') NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trafficLightId) REFERENCES TrafficLight(lightId) ON DELETE CASCADE
);

-- 6. Emergency Vehicles Table
CREATE TABLE IF NOT EXISTS EmergencyVehicle (
    emergencyId INT AUTO_INCREMENT PRIMARY KEY,
    vehicleType VARCHAR(20) NOT NULL,
    sensorId INT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensorId) REFERENCES TrafficSensor(sensorId) ON DELETE CASCADE
);

-- 7. Weather Conditions Table
CREATE TABLE IF NOT EXISTS WeatherConditions (
    weatherId INT AUTO_INCREMENT PRIMARY KEY,
    trafficLightId INT NOT NULL,
    temperature FLOAT(5,2) NOT NULL,
    humidity FLOAT(5,2) CHECK (humidity BETWEEN 0 AND 100),
    rainIntensity ENUM('None', 'Light', 'Heavy') NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trafficLightId) REFERENCES TrafficLight(lightId) ON DELETE CASCADE
);

-- 8. Pedestrian Detections Table
CREATE TABLE IF NOT EXISTS PedestrianDetection (
    pedDetectionId INT AUTO_INCREMENT PRIMARY KEY,
    sensorId INT NOT NULL,
    pedCount INT NOT NULL CHECK (pedCount >= 0),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensorId) REFERENCES TrafficSensor(sensorId) ON DELETE CASCADE
);

-- 9. Cyclist Detections Table
CREATE TABLE IF NOT EXISTS CyclistDetection (
    cycDetectionId INT AUTO_INCREMENT PRIMARY KEY,
    sensorId INT NOT NULL,
    cycCount INT NOT NULL CHECK (cycCount >= 0),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensorId) REFERENCES TrafficSensor(sensorId) ON DELETE CASCADE
);

-- 10. Vehicle Detections Table
CREATE TABLE IF NOT EXISTS VehicleDetection (
    vehicleDetectionId INT AUTO_INCREMENT PRIMARY KEY,
    sensorId INT NOT NULL,
    vehicleCount INT NOT NULL CHECK (vehicleCount >= 0),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensorId) REFERENCES TrafficSensor(sensorId) ON DELETE CASCADE
);

-- 11. Real-Time Synchronization Table
CREATE TABLE IF NOT EXISTS RealTimeSynchronization (
    syncId INT AUTO_INCREMENT PRIMARY KEY,
    light1Id INT NOT NULL,
    light2Id INT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (light1Id) REFERENCES TrafficLight(lightId) ON DELETE CASCADE,
    FOREIGN KEY (light2Id) REFERENCES TrafficLight(lightId) ON DELETE CASCADE
);

-- 12. User Role Table
CREATE TABLE IF NOT EXISTS UserRole (
    roleId INT AUTO_INCREMENT PRIMARY KEY,
    roleName VARCHAR(50) UNIQUE NOT NULL,
    roleDescription VARCHAR(100)
);

-- 13. Users Table (Updated to reference UserRole)
CREATE TABLE IF NOT EXISTS User (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    birthDate DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    passwordHash TEXT NOT NULL,
    roleId INT UNIQUE, -- 1:1 Relationship with UserRole
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (roleId) REFERENCES UserRole(roleId) ON DELETE SET NULL
);

-- 14. User Actions Log Table
CREATE TABLE IF NOT EXISTS UserActionLog (
    logId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    actionType VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES User(userId) ON DELETE CASCADE
);
