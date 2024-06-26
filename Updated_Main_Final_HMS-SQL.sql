USE [master]
GO
/****** Object:  Database [dbHMS]    Script Date: 6/12/2024 6:10:51 PM ******/
CREATE DATABASE [dbHMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbHMS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\dbHMS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'dbHMS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\dbHMS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [dbHMS] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dbHMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [dbHMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [dbHMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [dbHMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [dbHMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [dbHMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [dbHMS] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [dbHMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [dbHMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [dbHMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [dbHMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [dbHMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [dbHMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [dbHMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [dbHMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [dbHMS] SET  ENABLE_BROKER 
GO
ALTER DATABASE [dbHMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [dbHMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [dbHMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [dbHMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [dbHMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [dbHMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [dbHMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [dbHMS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [dbHMS] SET  MULTI_USER 
GO
ALTER DATABASE [dbHMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [dbHMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [dbHMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [dbHMS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [dbHMS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [dbHMS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [dbHMS] SET QUERY_STORE = OFF
GO
USE [dbHMS]
GO
/****** Object:  UserDefinedFunction [dbo].[GetFunID]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[GetFunID](@raw int)
returns numeric(18,0)
as
begin
	declare @result numeric(18,0)
	set @result = RIGHT('00'+convert(varchar,datepart(YY,GETDATE())),2)
				+ RIGHT('00'+convert(varchar,datepart(MM,GETDATE())),2)
				+ RIGHT('00'+convert(varchar,datepart(DD,GETDATE())),2)
				+ (select RIGHT('00000'+ CONVERT(nvarchar,@raw % 10000),5))
	return @result
end
GO
/****** Object:  Table [dbo].[Appointments]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appointments](
	[AppointmentID] [numeric](18, 0) NOT NULL,
	[PatientID] [numeric](18, 0) NULL,
	[Doctor_ID] [numeric](18, 0) NULL,
	[AppointmentDate] [datetime] NULL,
	[Reason] [nvarchar](255) NULL,
	[Status] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AppointmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DBErrors]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBErrors](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [varchar](max) NULL,
	[ErrorMessage] [varchar](max) NULL,
	[ErrorDateTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctor]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctor](
	[Doctor_ID] [numeric](18, 0) NOT NULL,
	[Doctor_Name] [varchar](50) NULL,
	[Doctor_Specialization] [varchar](50) NULL,
	[Doctor_Contact] [varchar](12) NULL,
	[CreatedBy] [numeric](18, 0) NULL,
	[CreatedOn] [date] NULL,
	[UpdatedBy] [numeric](18, 0) NULL,
	[UpdatedOn] [date] NULL,
	[DeletedBy] [numeric](18, 0) NULL,
	[DeletedOn] [date] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Doctor_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[PatientID] [numeric](18, 0) NOT NULL,
	[PatientName] [varchar](50) NOT NULL,
	[Age] [numeric](18, 0) NOT NULL,
	[Gender] [varchar](12) NOT NULL,
	[Address] [varchar](500) NOT NULL,
	[CreatedBy] [numeric](18, 0) NULL,
	[CreatedOn] [date] NULL,
	[UpdatedBy] [numeric](18, 0) NULL,
	[UpdatedOn] [date] NULL,
	[DeletedBy] [numeric](18, 0) NULL,
	[DeletedOn] [date] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTokenMaster]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTokenMaster](
	[TokenId] [int] IDENTITY(1,1) NOT NULL,
	[CoachingName] [varchar](50) NULL,
	[AuthToken] [nvarchar](250) NULL,
	[IssuedOn] [datetime] NULL,
	[ExpiresOn] [datetime] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[TokenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Doctor] ADD  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[Doctor] ADD  DEFAULT (getdate()) FOR [DeletedOn]
GO
ALTER TABLE [dbo].[Doctor] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Patient] ADD  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[Patient] ADD  DEFAULT (getdate()) FOR [DeletedOn]
GO
ALTER TABLE [dbo].[Patient] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[tblTokenMaster] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Doctor] FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Doctor]
GO
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Patient]
GO
/****** Object:  StoredProcedure [dbo].[Insert_Appointments]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Insert_Appointments]
    @AppointmentID numeric(18,0),
    @PatientID numeric(18,0),
    @DoctorID numeric(18,0),
    @AppointmentDate DATETIME,
    @Reason NVARCHAR(255),
	 @Status NVARCHAR(255)
AS
BEGIN
    INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, AppointmentDate, Reason, Status )
    VALUES (@AppointmentID, @PatientID, @DoctorID, @AppointmentDate, @Reason , @Status );
    
    -- Return the ID of the newly scheduled appointment
    SELECT SCOPE_IDENTITY() AS NewAppointmentID;
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteDoctor]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteDoctor]
    @Doctor_ID numeric(18,0)
AS
BEGIN
    -- Start a transaction to ensure data integrity
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Delete related appointments first to avoid foreign key constraints
        DELETE FROM Appointments
        WHERE Doctor_ID = @Doctor_ID;
        
        -- Now delete the patient record
        DELETE FROM Doctor
        WHERE Doctor_ID = @Doctor_ID;
        
        -- If everything is successful, commit the transaction
        COMMIT TRANSACTION;
        
        PRINT 'Doctor Deleted successfully.';
    END TRY
    BEGIN CATCH
        -- If an error occurs, roll back the transaction
        ROLLBACK TRANSACTION;
        
        -- Return the error message
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_DeletePatient]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DeletePatient]
    @PatientID numeric(18,0)
AS
BEGIN
    -- Start a transaction to ensure data integrity
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Delete related appointments first to avoid foreign key constraints
        DELETE FROM Appointments
        WHERE PatientID = @PatientID;
        
        -- Now delete the patient record
        DELETE FROM Patient
        WHERE PatientID = @PatientID;
        
        -- If everything is successful, commit the transaction
        COMMIT TRANSACTION;
        
        PRINT 'Patient deleted successfully.';
    END TRY
    BEGIN CATCH
        -- If an error occurs, roll back the transaction
        ROLLBACK TRANSACTION;
        
        -- Return the error message
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetDoctors]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetDoctors]
@Doctor_ID numeric(18,0),
@ErrorMgs varchar(500) out
as
begin
begin try
	set @ErrorMgs = ''

		select * FROM [dbHMS].[dbo].[Doctor]
		  where IsActive = 1 and
		  Doctor_ID in ( case when @Doctor_ID is null or @Doctor_ID = 0 then Doctor_ID else @Doctor_ID end)
	end try
	begin catch
		set @ErrorMgs = 'ErrorMessage :'  + ERROR_MESSAGE()

		
		INSERT INTO dbo.DBErrors
			VALUES
		  (SUSER_SNAME(),
		   ERROR_NUMBER(),
		   ERROR_STATE(),
		   ERROR_SEVERITY(),
		   ERROR_LINE(),
		   ERROR_PROCEDURE(),
		   ERROR_MESSAGE(),
		   GETDATE());

	end catch
  end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetPatients]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetPatients]
@PatientID numeric(18,0),
@ErrorMgs varchar(500) out
as
begin
begin try
	set @ErrorMgs = ''

		select * FROM [dbHMS].[dbo].[Patient]
		  where IsActive = 1 and
		  PatientID in ( case when @PatientID is null or @PatientID = 0 then PatientID else @PatientID end)
	end try
	begin catch
		set @ErrorMgs = 'ErrorMessage :'  + ERROR_MESSAGE()

		
		INSERT INTO dbo.DBErrors
			VALUES
		  (SUSER_SNAME(),
		   ERROR_NUMBER(),
		   ERROR_STATE(),
		   ERROR_SEVERITY(),
		   ERROR_LINE(),
		   ERROR_PROCEDURE(),
		   ERROR_MESSAGE(),
		   GETDATE());

	end catch
  end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTokenMaster]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_GetTokenMaster]
@CoachingName varchar(50)  = null,
@ErrorMgs varchar(500) out
as
begin
--exec usp_GetTokenMaster 'Bhavsar',''
	set @ErrorMgs = ''
	begin try
		set nocount on;
		select top 1 
			TM.TokenId as Id,
			TM.CoachingName as Name,
			TM.AuthToken,
			TM.IssuedOn,
			TM.ExpiresOn,
			TM.IsActive
		from dbo.tblTokenMaster TM
		where TM.CoachingName in (case when @CoachingName is null or @CoachingName = ''then TM.CoachingName else @CoachingName end)
		and TM.IsActive = 1
	end try
	begin catch
		set @ErrorMgs = 'ErrorMessage :' + ERROR_MESSAGE();

		INSERT INTO dbo.DBErrors
			VALUES
		  (SUSER_SNAME(),
		   ERROR_NUMBER(),
		   ERROR_STATE(),
		   ERROR_SEVERITY(),
		   ERROR_LINE(),
		   ERROR_PROCEDURE(),
		   ERROR_MESSAGE(),
		   GETDATE());
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetValidateToken]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetValidateToken]
@AuthToken varchar(100),
@result bit out,
@ErrorMgs varchar(500) out
as
begin
	begin try
		set nocount on;
	
		Declare @raw int = 0
		set @result = 0
		set @ErrorMgs = ''
		select @raw = count(*) from dbo.tblTokenMaster where IsActive = 1 and AuthToken = @AuthToken
		if(@raw > 0)
		begin
			select @raw = count(*) from dbo.tblTokenMaster where IsActive = 1 and AuthToken = @AuthToken and ExpiresOn >= GETDATE() 
			if(@raw	> 0)
			begin
				set @result = 1
				set @ErrorMgs = ''
			end
			else
			begin
				set @ErrorMgs = 'App Key is Expired,Please contact to Administrator.'
			end
		end
		else
		begin
			set @ErrorMgs = 'App Key is not valid,Please provide correct Information.'
		end
	end try
	begin catch
		set @ErrorMgs = 'ErrorMessage :' + ERROR_MESSAGE();

		INSERT INTO dbo.DBErrors
			VALUES
		  (SUSER_SNAME(),
		   ERROR_NUMBER(),
		   ERROR_STATE(),
		   ERROR_SEVERITY(),
		   ERROR_LINE(),
		   ERROR_PROCEDURE(),
		   ERROR_MESSAGE(),
		   GETDATE());
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertDoctor]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_InsertDoctor]
	@Doctor_ID NUMERIC(18,0),
    @Doctor_Name VARCHAR(50),
    @Doctor_Specialization VARCHAR(50),
    @Doctor_Contact VARCHAR(12),
    @CreatedBy NUMERIC(18,0),
	@ErrorMgs Varchar(500) out


As
Begin

	Begin try
		Declare @row int = 0
		begin
			
			select @row = count(*) from dbo.Doctor
			select @Doctor_ID = dbo.GetFunID(@row)

			INSERT INTO dbo.Doctor(Doctor_ID,Doctor_Name,Doctor_Specialization,Doctor_Contact, CreatedBy)
			 VALUES (@Doctor_ID,@Doctor_Name,@Doctor_Specialization,@Doctor_Contact, @CreatedBy);
			
			set @ErrorMgs = 'Successfully Insert Doctor detail, ID :- ' + cast(@Doctor_ID as varchar(20))
		end
	end try
	begin catch
		set @ErrorMgs = 'ErrorMessage :'  + ERROR_MESSAGE()

		
		INSERT INTO dbo.DBErrors
			VALUES
		  (SUSER_SNAME(),
		   ERROR_NUMBER(),
		   ERROR_STATE(),
		   ERROR_SEVERITY(),
		   ERROR_LINE(),
		   ERROR_PROCEDURE(),
		   ERROR_MESSAGE(),
		   GETDATE());
		

	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPatient]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_InsertPatient]
	@PatientID NUMERIC(18,0),
    @PatientName VARCHAR(50),
    @Age VARCHAR(12),
    @Gender VARCHAR(12),
	@Address varchar(255),
    @CreatedBy NUMERIC(18,0),
	@ErrorMgs Varchar(500) out


As
Begin

	Begin try
		Declare @row int = 0
		begin
			
			select @row = count(*) from dbo.Patient
			select @PatientID = dbo.GetFunID(@row)

			INSERT INTO dbo.Patient(PatientID,PatientName,Age,Gender,Address,CreatedBy)
			 VALUES (@PatientID,@PatientName,@Age,@Gender,@Address, @CreatedBy);
			
			set @ErrorMgs = 'Successfully Insert Patient detail, ID :- ' + cast(@PatientID as varchar(20))
		end
	end try
	begin catch
		set @ErrorMgs = 'ErrorMessage :'  + ERROR_MESSAGE()

		
		INSERT INTO dbo.DBErrors
			VALUES
		  (SUSER_SNAME(),
		   ERROR_NUMBER(),
		   ERROR_STATE(),
		   ERROR_SEVERITY(),
		   ERROR_LINE(),
		   ERROR_PROCEDURE(),
		   ERROR_MESSAGE(),
		   GETDATE());
		

	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateDoctor]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateDoctor]
    @Doctor_ID numeric(18,0),
    @Doctor_Name NVARCHAR(50),
    @Doctor_Specialization NVARCHAR(50),
    @Doctor_Contact VARCHAR(12)
 
AS
BEGIN
    UPDATE Doctor
    SET Doctor_Name = @Doctor_Name,
        Doctor_Specialization = @Doctor_Specialization,
        Doctor_Contact = @Doctor_Contact

    WHERE Doctor_ID = @Doctor_ID;
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdatePatient]    Script Date: 6/12/2024 6:10:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdatePatient]
    @PatientID numeric(18,0),
    @PatientName NVARCHAR(50),
    @Age NVARCHAR(50),
    @Gender NVARCHAR(10),
    @Address NVARCHAR(255)
   
AS
BEGIN
    UPDATE Patient
    SET PatientName = @PatientName,
        Age = @Age,
        Gender = @Gender,
        Address = @Address
    WHERE PatientID = @PatientID;
END;
GO
USE [master]
GO
ALTER DATABASE [dbHMS] SET  READ_WRITE 
GO
