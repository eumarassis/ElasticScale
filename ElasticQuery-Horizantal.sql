CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Azure$123';

CREATE DATABASE SCOPED CREDENTIAL ElasticDBQueryCred
WITH IDENTITY = 'Contoso',
SECRET = 'Azure$123';


CREATE EXTERNAL DATA SOURCE MyElasticDBQueryDataSrc WITH
  (TYPE = SHARD_MAP_MANAGER,
  LOCATION = 'cloudshopeumardb.database.windows.net',
  DATABASE_NAME = 'ShardMapManagerDatabase',
  CREDENTIAL = ElasticDBQueryCred,
  SHARD_MAP_NAME = 'ElasticScaleWithEF'
) ;

--drop EXTERNAL TABLE [dbo].[Blogs]

CREATE EXTERNAL TABLE [dbo].[Blogs]
( 
	[BlogId] INT           NOT NULL,
    [Name]   NVARCHAR (MAX) NULL,
    [Url]    NVARCHAR (MAX) NULL
)
WITH
( DATA_SOURCE = MyElasticDBQueryDataSrc,
  DISTRIBUTION =  ROUND_ROBIN
) ;


select * from [dbo].[Blogs]