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

-- 2. Traffic Sensors Table
CREATE TABLE IF NOT EXISTS TrafficSensor (
    sensorId INT AUTO_INCREMENT PRIMARY KEY,
    intersectionId INT NOT NULL,
    sensorType VARCHAR(50) NOT NULL,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    FOREIGN KEY (intersectionId) REFERENCES Intersection(intersectionId) ON DELETE CASCADE
);

-- 3. Traffic Data Table
CREATE TABLE IF NOT EXISTS TrafficData (
    dataId INT AUTO_INCREMENT PRIMARY KEY,
    sensorId INT NOT NULL,
    trafficDensity INT NOT NULL CHECK (trafficDensity >= 0),
    averageSpeed FLOAT(5,2) CHECK (averageSpeed >= 0),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensorId) REFERENCES TrafficSensor(sensorId) ON DELETE CASCADE
);

-- 4. AI Traffic Predictions Table
CREATE TABLE IF NOT EXISTS AITrafficPrediction (
    predictionId INT AUTO_INCREMENT PRIMARY KEY,
    intersectionId INT NOT NULL,
    predictedCongestionLevel ENUM('Low', 'Medium', 'High') NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (intersectionId) REFERENCES Intersection(intersectionId) ON DELETE CASCADE
);

-- 5. Emergency Vehicles Table
CREATE TABLE IF NOT EXISTS EmergencyVehicle (
    emergencyId INT AUTO_INCREMENT PRIMARY KEY,
    vehicleType VARCHAR(20) NOT NULL,
    intersectionId INT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (intersectionId) REFERENCES Intersection(intersectionId) ON DELETE CASCADE
);

-- 6. Weather Conditions Table
CREATE TABLE IF NOT EXISTS WeatherCondition (
    weatherId INT AUTO_INCREMENT PRIMARY KEY,
    intersectionId INT NOT NULL,
    temperature FLOAT(5,2) NOT NULL,
    humidity FLOAT(5,2) CHECK (humidity BETWEEN 0 AND 100),
    rainIntensity ENUM('None', 'Light', 'Heavy') NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (intersectionId) REFERENCES Intersection(intersectionId) ON DELETE CASCADE
);

-- 7. Pedestrian Detections Table
CREATE TABLE IF NOT EXISTS PedestrianDetection (
    pedDetectionId INT AUTO_INCREMENT PRIMARY KEY,
    sensorId INT NOT NULL,
    pedCount INT NOT NULL CHECK (pedCount >= 0),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensorId) REFERENCES TrafficSensor(sensorId) ON DELETE CASCADE
);

-- 8. Cyclist Detections Table
CREATE TABLE IF NOT EXISTS CyclistDetection (
    cycDetectionId INT AUTO_INCREMENT PRIMARY KEY,
    sensorId INT NOT NULL,
    cycCount INT NOT NULL CHECK (cycCount >= 0),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensorId) REFERENCES TrafficSensor(sensorId) ON DELETE CASCADE
);

-- 9. Traffic Lights Table
CREATE TABLE IF NOT EXISTS TrafficLight (
    lightId INT AUTO_INCREMENT PRIMARY KEY,
    intersectionId INT NOT NULL,
    currentStatus ENUM('Red', 'Yellow', 'Green') NOT NULL,
    greenDuration INT NOT NULL CHECK (greenDuration > 0),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (intersectionId) REFERENCES Intersection(intersectionId) ON DELETE CASCADE
);

-- 10. Real-Time Synchronization Table
CREATE TABLE IF NOT EXISTS RealTimeSynchronization (
    syncId INT AUTO_INCREMENT PRIMARY KEY,
    signal1Id INT NOT NULL,
    signal2Id INT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (signal1Id) REFERENCES TrafficLight(lightId) ON DELETE CASCADE,
    FOREIGN KEY (signal2Id) REFERENCES TrafficLight(lightId) ON DELETE CASCADE
);

-- 11. Users Table
CREATE TABLE IF NOT EXISTS User (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    passwordHash TEXT NOT NULL,
    role ENUM('Admin', 'Traffic Controller', 'Operator') DEFAULT 'Traffic Controller',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. User Actions Log Table
CREATE TABLE IF NOT EXISTS UserActionLog (
    logId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    actionType VARCHAR(50) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES User(userId) ON DELETE CASCADE
);
