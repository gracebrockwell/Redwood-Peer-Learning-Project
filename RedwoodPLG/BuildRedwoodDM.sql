--Build Redwood DM
IF NOT EXISTS(SELECT * FROM sys.databases
				WHERE name = N'RedwoodDM')
	CREATE DATABASE RedwoodDM