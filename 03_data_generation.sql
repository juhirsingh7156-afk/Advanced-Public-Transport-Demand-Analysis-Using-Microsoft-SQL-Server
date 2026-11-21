
USE AdvancedTransportDB;
GO

INSERT INTO dbo.Routes
(
    RouteCode, RouteName, Origin,
    Destination, VehicleCapacity, BaseFare
)
VALUES
('R101','Station-Hinjewadi','Pune Station','Hinjewadi',50,25),
('R102','Swargate-Kothrud','Swargate','Kothrud',45,20),
('R103','Hadapsar-Shivajinagar','Hadapsar','Shivajinagar',50,25),
('R104','Wakad-Pimpri','Wakad','Pimpri',40,15),
('R105','Katraj-Deccan','Katraj','Deccan',45,20),
('R106','Baner-Station','Baner','Pune Station',50,25),
('R107','Viman Nagar-Swargate','Viman Nagar','Swargate',40,20),
('R108','Nigdi-Hadapsar','Nigdi','Hadapsar',50,30);
GO

INSERT INTO dbo.TimePeriods
VALUES
(1,'Early Morning','05:00','08:00'),
(2,'Morning Peak','08:00','11:00'),
(3,'Afternoon','11:00','16:00'),
(4,'Evening Peak','16:00','21:00');
GO

INSERT INTO dbo.Vehicles
(
    VehicleNumber, VehicleType, VehicleCapacity
)
VALUES
('MH12-1001','Standard Bus',50),
('MH12-1002','Standard Bus',45),
('MH12-1003','Electric Bus',50),
('MH12-1004','Mini Bus',40),
('MH12-1005','Standard Bus',45),
('MH12-1006','Electric Bus',50),
('MH12-1007','Mini Bus',40),
('MH12-1008','Standard Bus',50);
GO
