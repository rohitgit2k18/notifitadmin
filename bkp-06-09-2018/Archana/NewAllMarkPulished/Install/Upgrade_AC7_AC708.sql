/****** Database changes from AC703 to AC708 Script Date: 4/18/2014  ******/

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

GO

/**************************/
/* AC03 TO AC704 UPGRADE  */
/**************************/

/* REMOVE DEPRECATED KEYS FROM STORE SETTINGS */
DELETE FROM ac_StoreSettings
WHERE FieldName IN ('GoogleBase_FeedDataPath', 'ShoppingCom_FeedDataPath', 'YahooShopping_FeedDataPath')

GO

/* MAKE SURE ac_ShipZones.ExcludePostalCodeFilter FIELD EXISTS, ALLOW NULLS */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_ShipZones' AND COLUMN_NAME = 'ExcludePostalCodeFilter')
BEGIN
	ALTER TABLE ac_ShipZones ADD ExcludePostalCodeFilter nvarchar(255) NULL	
END

GO

/* ADD UsePerItemTax FIELD IN ac_TaxRules */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_TaxRules' AND COLUMN_NAME = 'UsePerItemTax')
BEGIN
	ALTER TABLE ac_TaxRules ADD UsePerItemTax bit
END

GO

UPDATE ac_TaxRules SET UsePerItemTax = 0 WHERE UsePerItemTax IS NULL

GO

ALTER TABLE ac_TaxRules ALTER COLUMN UsePerItemTax bit not null

GO

/* ADD ASSOCIATION FOR PRODUCTS AND PRODUCTTEMPLATES */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ac_ProductProductTemplates')
BEGIN
create table "ac_ProductProductTemplates" ( 
	"ProductId" int not null,
	"ProductTemplateId" int not null);
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_ProductProductTemplates'
AND CONSTRAINT_NAME = 'ac_ProductProductTemplates_PK')
BEGIN
alter table "ac_ProductProductTemplates"
	add constraint "ac_ProductProductTemplates_PK" primary key ("ProductId", "ProductTemplateId")   
END

GO

/* COPY LEGACY PRODUCTTEMPLATE DATA */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_Products' AND COLUMN_NAME = 'ProductTemplateId')
BEGIN
	exec('INSERT INTO ac_ProductProductTemplates (ProductId, ProductTemplateId) SELECT ProductId, ProductTemplateId FROM ac_Products WHERE ProductTemplateId IS NOT NULL AND ProductTemplateId > 0')
END

GO

/* Add foreign key constraints to table "ac_ProductProductTemplates".                         */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_ProductProductTemplates'
AND CONSTRAINT_NAME = 'ac_Products_ac_ProductProductTemplates_FK1')
BEGIN
alter table "ac_ProductProductTemplates"
	add constraint "ac_Products_ac_ProductProductTemplates_FK1" foreign key (
		"ProductId")
	 references "ac_Products" (
		"ProductId") on update no action on delete cascade  
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_ProductProductTemplates'
AND CONSTRAINT_NAME = 'ac_ProductTemplates_ac_ProductProductTemplates_FK1')
BEGIN
alter table "ac_ProductProductTemplates"
	add constraint "ac_ProductTemplates_ac_ProductProductTemplates_FK1" foreign key (
		"ProductTemplateId")
	 references "ac_ProductTemplates" (
		"ProductTemplateId") on update no action on delete cascade  
END

GO

/* DROP DEPRECATED ac_Products.ProductTemplateId CONSTRAINT */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_Products'
AND CONSTRAINT_NAME = 'ac_ProductTemplates_ac_Products_FK1')
BEGIN
alter table "ac_Products"
	drop constraint "ac_ProductTemplates_ac_Products_FK1"
END

GO

/* DROP DEPRECATED ac_Products.ProductTemplateId FIELD */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_Products' AND COLUMN_NAME = 'ProductTemplateId')
BEGIN
	ALTER TABLE ac_Products DROP COLUMN ProductTemplateId
END

GO

/* DROP acsp_MergeUserGroupMembers PROCEDURE IF IT EXISTS */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
	WHERE ROUTINE_NAME = 'acsp_MergeUserGroupMembers') 
BEGIN
	DROP PROC acsp_MergeUserGroupMembers
END

GO
	
/* ADD acsp_MergeUserGroupMembers PROCEDURE */
create procedure acsp_MergeUserGroupMembers
	@sourceGroupId int,
	@targetGroupId int
as
begin
	/* BUILD TEMP TABLE FOR SOURCE GROUP */
	SELECT UG.UserId, UG.GroupId, S.SubscriptionId, S.ExpirationDate
	INTO #sourceGroup
	FROM ac_UserGroups AS UG LEFT JOIN ac_Subscriptions AS S
	ON UG.SubscriptionId = S.SubscriptionId
	WHERE UG.GroupId = @sourceGroupId;

	/* BUILD TEMP TABLE FOR TARGET GROUP */
	SELECT UG.UserId, UG.GroupId, S.SubscriptionId, S.ExpirationDate
	INTO #targetGroup
	FROM ac_UserGroups AS UG LEFT JOIN ac_Subscriptions AS S
	ON UG.SubscriptionId = S.SubscriptionId
	WHERE UG.GroupId = @targetGroupId;

	/* IF BOTH ASSIGNMENTS HAVE NULL EXPRIATIONS, FAVOR TARGET GROUP */
	DELETE #sourceGroup
	FROM #sourceGroup INNER JOIN #targetGroup ON #sourceGroup.UserId = #targetGroup.UserId
	WHERE #sourceGroup.ExpirationDate IS NULL AND #targetGroup.ExpirationDate IS NULL;

	/* IF SOURCE GROUP EXPIRES BEFORE TARGET GROUP, FAVOR TARGET GROUP */
	DELETE #sourceGroup
	FROM #sourceGroup INNER JOIN #targetGroup ON #sourceGroup.UserId = #targetGroup.UserId
	WHERE #sourceGroup.ExpirationDate IS NOT NULL 
	AND (#targetGroup.ExpirationDate IS NULL OR #sourceGroup.ExpirationDate < #targetGroup.ExpirationDate);

	/* IF SOURCE GROUP EXPIRES AFTER TARGET GROUP, FAVOR SOURCE GROUP */
	DELETE #targetGroup
	FROM #targetGroup INNER JOIN #sourceGroup ON #targetGroup.UserId = #sourceGroup.UserId
	WHERE #targetGroup.ExpirationDate IS NOT NULL 
	AND (#sourceGroup.ExpirationDate IS NULL OR #targetGroup.ExpirationDate < #sourceGroup.ExpirationDate);

	/* ANY RECORD NOT APPEARING IN SOURCEGROUP TEMP TABLE SHOULD BE REMOVED */
	DELETE FROM ac_UserGroups
	WHERE UserId NOT IN (SELECT UserId FROM #sourceGroup)
	AND GroupID = @sourceGroupId;

	/* ANY RECORD NOT APPEARING IN TARGETGROUP TEMP TABLE SHOULD BE REMOVED */
	DELETE FROM ac_UserGroups
	WHERE UserId NOT IN (SELECT UserId FROM #targetGroup)
	AND GroupID = @targetGroupId;

	/* RENUMBER ALL SOURCE GROUP RECORDS TO TO TARGET GROUP */
	UPDATE ac_UserGroups
	SET GroupId = @targetGroupId
	WHERE GroupId = @sourceGroupId;

	/* DROP TEMP TABLES */
	DROP TABLE #sourceGroup;
	DROP TABLE #targetGroup;
end

GO

/* ADD EnableSerialKeys COLUMN TO ac_DigitalGoods */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_DigitalGoods' AND COLUMN_NAME = 'EnableSerialKeys')
BEGIN
	ALTER TABLE ac_DigitalGoods ADD EnableSerialKeys bit
END

GO

UPDATE ac_DigitalGoods SET EnableSerialKeys = 1 WHERE EnableSerialKeys IS NULL AND SerialKeyProviderId IS NOT NULL

GO

UPDATE ac_DigitalGoods SET EnableSerialKeys = 0 WHERE EnableSerialKeys IS NULL

GO

ALTER TABLE ac_DigitalGoods ALTER COLUMN EnableSerialKeys bit not null

GO

/* ADD Group_Id TO ac_Subscriptions (allow nulls) */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_Subscriptions' AND COLUMN_NAME = 'GroupId')
BEGIN
	ALTER TABLE ac_Subscriptions ADD GroupId int;
	/* POPULATE THE GROUP ID ONLY ONCE WHEN THE FIELD IS CREATED */
	EXEC('UPDATE S SET S.GroupId = SP.GroupId FROM ac_Subscriptions S INNER JOIN ac_SubscriptionPlans SP ON S.ProductId = SP.ProductId');
END

GO

/* ADD ForceExpiration TO ac_UserPasswords */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_UserPasswords' AND COLUMN_NAME = 'ForceExpiration')
BEGIN
	ALTER TABLE ac_UserPasswords ADD ForceExpiration bit null;
	EXEC('UPDATE ac_UserPasswords SET ForceExpiration = 0 WHERE ForceExpiration IS NULL');
	ALTER TABLE ac_UserPasswords ALTER COLUMN ForceExpiration bit not null;
END

GO

/* ADD IsMerchantField TO ac_OrderItemInputs */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_OrderItemInputs' AND COLUMN_NAME = 'IsMerchantField')
BEGIN
	ALTER TABLE ac_OrderItemInputs ADD IsMerchantField bit null;
	EXEC('UPDATE ac_OrderItemInputs SET IsMerchantField = 0 WHERE IsMerchantField IS NULL');
	ALTER TABLE ac_OrderItemInputs ALTER COLUMN IsMerchantField bit not null;
END

GO

/* ADD PersistWithOrder TO ac_InputFields */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_InputFields' AND COLUMN_NAME = 'PersistWithOrder')
BEGIN
	ALTER TABLE ac_InputFields ADD PersistWithOrder bit null;
	EXEC('UPDATE ac_InputFields SET PersistWithOrder = 0 WHERE PersistWithOrder IS NULL');
	ALTER TABLE ac_InputFields ALTER COLUMN PersistWithOrder bit not null;
END

GO

/* ADD PromptCssClass TO ac_InputFields */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_InputFields' AND COLUMN_NAME = 'PromptCssClass')
BEGIN
	ALTER TABLE ac_InputFields ADD PromptCssClass nvarchar(100)
END

GO

/* ADD ControlCssClass TO ac_InputFields */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_InputFields' AND COLUMN_NAME = 'ControlCssClass')
BEGIN
	ALTER TABLE ac_InputFields ADD ControlCssClass nvarchar(100)
END

GO

/* ADD AdditionalData TO ac_InputFields */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_InputFields' AND COLUMN_NAME = 'AdditionalData')
BEGIN
	ALTER TABLE ac_InputFields ADD AdditionalData nvarchar(255)
END

GO

/* ADD TaxCodeId TO ac_SubscriptionPlans */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_SubscriptionPlans' AND COLUMN_NAME = 'TaxCodeId')
BEGIN
	ALTER TABLE ac_SubscriptionPlans ADD TaxCodeId int null
END

GO

/* ADD CONSTRAINTS FOR SUBSRIPTIONPLAN TAXCODE */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_SubscriptionPlans'
AND CONSTRAINT_NAME = 'ac_TaxCodes_ac_SubscriptionPlans_FK1')
BEGIN
	ALTER TABLE ac_SubscriptionPlans ADD CONSTRAINT "ac_TaxCodes_ac_SubscriptionPlans_FK1"
	FOREIGN KEY ("TaxCodeId") REFERENCES "ac_TaxCodes" ("TaxCodeId")
	ON UPDATE NO ACTION ON DELETE SET NULL
END

GO

/**************************/
/* AC04 TO AC705 UPGRADE  */
/**************************/

/* REMOVE DEPRECATED CONSTRAINTS FROM TAX RULES */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_TaxRules'
AND CONSTRAINT_NAME = 'ac_Countries_ac_TaxRules_FK1')
BEGIN
	exec('ALTER TABLE ac_TaxRules DROP CONSTRAINT ac_Countries_ac_TaxRules_FK1');
END

GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_TaxRules'
AND CONSTRAINT_NAME = 'ac_Provinces_ac_TaxRules_FK1')
BEGIN
	exec('ALTER TABLE ac_TaxRules DROP CONSTRAINT ac_Provinces_ac_TaxRules_FK1');
END

GO

/* REMOVE DEPRECATED FIELDS FROM TAX RULES */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_TaxRules' AND COLUMN_NAME = 'CountryCode')
BEGIN
	exec('ALTER TABLE ac_TaxRules DROP COLUMN CountryCode');
END

GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_TaxRules' AND COLUMN_NAME = 'ProvinceId')
BEGIN
	exec('ALTER TABLE ac_TaxRules DROP COLUMN ProvinceId');
END

GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_TaxRules' AND COLUMN_NAME = 'PostalCodeFilter')
BEGIN
	exec('ALTER TABLE ac_TaxRules DROP COLUMN PostalCodeFilter');
END

GO

/* ADD UsePCPM FIELD TO SHIPZONES */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_ShipZones' AND COLUMN_NAME = 'UsePCPM')
BEGIN
	exec('ALTER TABLE ac_ShipZones ADD UsePCPM bit');
	exec('UPDATE ac_ShipZones SET UsePCPM = 1 WHERE ShipZoneId IN
		(SELECT ShipZoneId FROM ac_ShipZones 
		WHERE PostalCodeFilter LIKE ''%,%''
		OR PostalCodeFilter LIKE ''@%''
		OR PostalCodeFilter LIKE ''%*%''
		OR ExcludePostalCodeFilter LIKE ''%,%''
		OR ExcludePostalCodeFilter LIKE ''@%''
		OR ExcludePostalCodeFilter LIKE ''%*%'')');
	exec('UPDATE ac_ShipZones SET UsePCPM = 0 WHERE ShipZoneId NOT IN
		(SELECT ShipZoneId FROM ac_ShipZones 
		WHERE PostalCodeFilter LIKE ''%,%''
		OR PostalCodeFilter LIKE ''@%''
		OR PostalCodeFilter LIKE ''%*%''
		OR ExcludePostalCodeFilter LIKE ''%,%''
		OR ExcludePostalCodeFilter LIKE ''@%''
		OR ExcludePostalCodeFilter LIKE ''%*%'')');
	exec('UPDATE ac_ShipZones SET UsePCPM = 0 WHERE UsePCPM IS NULL');
	exec('ALTER TABLE ac_ShipZones ALTER COLUMN UsePCPM bit not null');
END

GO

/* ADD INDEX TO SHIPZONES */
IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'ac_ShipZones_IX1')
	CREATE INDEX "ac_ShipZones_IX1" ON "ac_ShipZones" ("PostalCodeFilter")

GO

/* ADD ReferralPeriodId FIELD TO ac_Affiliates */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_Affiliates' AND COLUMN_NAME = 'ReferralPeriodId')
BEGIN
	exec('ALTER TABLE ac_Affiliates ADD ReferralPeriodId tinyint');
	exec('UPDATE ac_Affiliates SET ReferralPeriodId = 0 WHERE ReferralPeriodId IS NULL');
	exec('UPDATE ac_Affiliates SET ReferralPeriodId = 3 WHERE ReferralDays = 0 AND ReferralPeriodId = 0');
	exec('ALTER TABLE ac_Affiliates ALTER COLUMN ReferralPeriodId tinyint not null');
END

GO

/* ADD SurchargeTaxCodeId FIELD TO ac_ShipMethods */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_ShipMethods' AND COLUMN_NAME = 'SurchargeTaxCodeId')
BEGIN
	exec('ALTER TABLE ac_ShipMethods ADD SurchargeTaxCodeId int null');
END

GO

/* BEGIN UPGRADES TO AFFILIATES TABLES */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_Users' AND COLUMN_NAME = 'ReferringAffiliateId')
BEGIN
	exec('ALTER TABLE ac_Users DROP COLUMN ReferringAffiliateId');
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_Affiliates' AND COLUMN_NAME = 'GroupId')
BEGIN
	exec('ALTER TABLE ac_Affiliates ADD GroupId int null');
END

GO

/* ADD CONSTRAINTS FOR Affiliates */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_Affiliates'
AND CONSTRAINT_NAME = 'ac_Groups_ac_Affiliates_FK1')
BEGIN
	ALTER TABLE ac_Affiliates ADD CONSTRAINT "ac_Groups_ac_Affiliates_FK1"
	FOREIGN KEY ("GroupId") REFERENCES "ac_Groups" ("GroupId")
	ON UPDATE NO ACTION ON DELETE SET NULL
END

GO

/**************************/
/* AC05 TO AC706 UPGRADE  */
/**************************/

/* MAKE SURE WE HAVE ENOUGH SPACE FOR LARGE FILE SIZES */
ALTER TABLE ac_DigitalGoods
ALTER COLUMN FileSize bigint not null;

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ac_Redirects')
BEGIN
create table "ac_Redirects"  (
	"RedirectId" int identity not null,
	"StoreId" int not null,
	"SourceUrl"  nvarchar(255) not null,
	"LoweredSourceUrl"  nvarchar(255) not null,
	"TargetUrl" nvarchar(255) not null,
	"UseRegEx" bit not null,
	"CreatedDate" datetime not null,
	"LastVisitedDate" datetime null,
	"VisitCount" int null,
	"OrderBy" smallint default 0 not null,
	constraint "ac_Redirects_PK" primary key nonclustered ("RedirectId" ASC))
END

GO

/* Add foreign key constraints to table "ac_Redirects".                            */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_Redirects'
AND CONSTRAINT_NAME = 'ac_Stores_ac_Redirects_FK1')
BEGIN
alter table "ac_Redirects"
	add constraint "ac_Stores_ac_Redirects_FK1" foreign key (
		"StoreId")
	 references "ac_Stores" (
		"StoreId") on update no action on delete no action  
END

GO

IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'ac_Redirects_IX1')
BEGIN
create unique index "ac_Redirects_IX1" on "ac_Redirects" ("LoweredSourceUrl")
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ac_CustomUrls')
BEGIN
create table "ac_CustomUrls"(
	"CustomUrlId" int identity not null,
	"StoreId" int not null,
	"CatalogNodeId" int not null,
	"CatalogNodeTypeId" tinyint not null,
	"Url" nvarchar(300) not null,
	"LoweredUrl" nvarchar(300) not null,
	constraint "ac_CustomUrls_PK" primary key nonclustered ("CustomUrlId" ASC))
END

GO

/* Add StoreId foreign key constraints to table "ac_CustomUrls".                            */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_CustomUrls'
AND CONSTRAINT_NAME = 'ac_CustomUrls_ac_Stores_FK')
BEGIN
alter table "ac_CustomUrls"
	add constraint "ac_CustomUrls_ac_Stores_FK" foreign key (
		"StoreId")
	 references "ac_Stores" (
		"StoreId") on update no action on delete cascade
END

GO

IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'ac_CustomUrls_IX1')
BEGIN
create unique index "ac_CustomUrls_IX1" on "ac_CustomUrls" ("CatalogNodeId","CatalogNodeTypeId")
END

GO

IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'ac_CustomUrls_IX2')
BEGIN
create unique index "ac_CustomUrls_IX2" on "ac_CustomUrls" ("LoweredUrl")
END

GO

/**************************/
/* AC06 TO AC707 UPGRADE  */
/**************************/


/********************/
/* [ac_OrderNotes]  */
/********************/

/* IN CASE OF UPGRADE FROM 7.0.6 ADD MISSING IsRead COLUMN */
IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'IsRead' and Object_ID = Object_ID(N'ac_OrderNotes'))
BEGIN
	ALTER TABLE ac_OrderNotes ADD IsRead bit NOT NULL DEFAULT 1
END

GO

/**************************/
/* AC07 TO AC708 UPGRADE  */
/**************************/


/********************/
/* [ac_Addresses]  */
/********************/

/* ADD IS BILLING COLUMN TO ADDRESSES DEFAULT VALUE FALSE */
ALTER TABLE [ac_Addresses]
ADD [IsBilling] [bit] NOT NULL DEFAULT(0)

GO

/* MARK THE PRIMARY ADDRESSES */
UPDATE ac_Addresses SET IsBilling = 1 
Where AddressId IN 
(SELECT AddressId FROM 
ac_Addresses INNER JOIN ac_Users 
ON ac_Addresses.AddressId = ac_Users.PrimaryAddressId)

GO

/********************/
/* ac_BasketItems   */
/********************/
ALTER TABLE ac_BasketItems ALTER COLUMN ProductId [int] NULL

GO

ALTER TABLE ac_BasketItems ALTER COLUMN OptionList [varchar](500) NULL

GO

ALTER TABLE ac_BasketItems ALTER COLUMN [LineMessage] [nvarchar](500) NULL

GO

ALTER TABLE ac_BasketItems ALTER COLUMN [GiftMessage] [nvarchar](500) NULL

GO

ALTER TABLE ac_BasketItems ALTER COLUMN [KitList] [varchar](500) NULL

GO

/* 1. ADD NEW FIELD  */
ALTER TABLE [ac_BasketItems]
ADD [CreatedDate] [DATETIME] NULL

GO

/* 2. POPULATE VALUE, COPY FROM  LasstModifiedDate TO CreatedDate TO MAKE SURE WE DO NOT HAVE ANY NULL*/
UPDATE B1 SET B1.CreatedDate = B2.LastModifiedDate
FROM ac_BasketItems B1 INNER JOIN ac_BasketItems B2 ON B1.BasketItemId = B2.BasketItemId

GO

/*3. CONVERT IT TO NOT NULL */
ALTER TABLE ac_BasketItems ALTER COLUMN [CreatedDate] [DATETIME] NOT NULL

GO

/********************/
/* ac_BasketShipments   */
/********************/

/* MODIFY ac_Addresses_ac_BasketShipments_FK1 TO UPDATE ON DELETE ACTION */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_BasketShipments' 
AND CONSTRAINT_NAME = 'ac_Addresses_ac_BasketShipments_FK1')
BEGIN
alter table "ac_BasketShipments"
	drop constraint ac_Addresses_ac_BasketShipments_FK1
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_BasketShipments'
AND CONSTRAINT_NAME = 'ac_Addresses_ac_BasketShipments_FK1')
BEGIN
ALTER TABLE ac_BasketShipments
	ADD CONSTRAINT ac_Addresses_ac_BasketShipments_FK1 FOREIGN KEY (
		AddressId)
	 REFERENCES ac_Addresses (
		AddressId) ON UPDATE NO ACTION ON DELETE SET NULL

END

GO

/********************/
/* [ac_CatalogNodes]   */
/********************/
/* DROP EXISTING PK IDENTITY CONSTRAINTS */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_CatalogNodes'
AND CONSTRAINT_NAME = 'ac_CatalogNodes_PK')
BEGIN
	ALTER TABLE "ac_CatalogNodes" DROP CONSTRAINT "ac_CatalogNodes_PK"
END

GO

/* ADD IDENTITY COLUMN */
Alter TABLE ac_CatalogNodes
ADD [Id] [int] IDENTITY(1,1) NOT NULL

GO

Alter Table "ac_CatalogNodes" ADD CONSTRAINT "ac_CatalogNodes_PK" PRIMARY KEY ("Id")

GO

/* DROP DEPRECATED CONSTRAINTS */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_CatalogNodes' 
AND CONSTRAINT_NAME = 'ac_Categories_ac_CatalogNodes_FK1')
BEGIN
alter table "ac_CatalogNodes"
	drop constraint ac_Categories_ac_CatalogNodes_FK1
END

GO

/********************/
/* [ac_Categories]   */
/********************/
/* ADD COLUMNS */
ALTER TABLE [ac_Categories]
ADD [WebpageId] [int] NULL

GO

IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'Title' and Object_ID = Object_ID(N'ac_Categories'))
BEGIN
	ALTER TABLE [ac_Categories]
	ADD [Title] [nvarchar](100) NULL
END

GO

IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'HtmlHead' and Object_ID = Object_ID(N'ac_Categories'))
BEGIN
	ALTER TABLE [ac_Categories]
	ADD [HtmlHead] [nvarchar](MAX) NULL
END

ALTER TABLE [ac_Categories]
ADD [MetaDescription] [nvarchar](1000) NULL

GO

ALTER TABLE [ac_Categories]
ADD [MetaKeywords] [nvarchar](1000) NULL

GO

/* DROP COLUMNS*/
ALTER TABLE [ac_Categories]
DROP COLUMN [DisplayPage]

GO

ALTER TABLE [ac_Categories]
DROP COLUMN [Theme]

GO


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_Categories'
AND CONSTRAINT_NAME = 'ac_Webpages_ac_Categories_FK1')
BEGIN
ALTER TABLE ac_Categories
	ADD CONSTRAINT ac_Webpages_ac_Categories_FK1 FOREIGN KEY (
		WebpageId)
	 REFERENCES ac_Webpages (
		WebpageId) ON UPDATE NO ACTION ON DELETE set NULL  

END

GO

/* HtmlHead is back in GoldR5 */
/* ALTER TABLE [ac_Categories] */
/* DROP COLUMN [HtmlHead] */
/* GO */

/**************************/
/* [ac_CategoryParents]   */
/**************************/
/* DROP EXISTING PK IDENTITY CONSTRAINTS */
ALTER TABLE "ac_CategoryParents" DROP CONSTRAINT "ac_CategoryParents_PK"

GO

/* ADD NEW IDENTITY COLUMN */
Alter Table ac_CategoryParents
Add [Id] [int] IDENTITY(1,1) NOT NULL

GO

Alter Table "ac_CategoryParents" ADD CONSTRAINT "ac_CategoryParents_PK" PRIMARY KEY ("Id")

GO

/* 
CONVERT ParentLevel , ParentNumber  TO NOT NULL 
*/
UPDATE ac_CategoryParents SET ParentLevel = 0 
WHERE ParentLevel IS NULL

GO

ALTER TABLE ac_CategoryParents ALTER COLUMN [ParentLevel] [tinyint] NOT NULL

GO

UPDATE ac_CategoryParents SET ParentNumber = 0 
WHERE ParentNumber IS NULL

GO

ALTER TABLE ac_CategoryParents ALTER COLUMN [ParentNumber] [tinyint] NOT NULL

GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_CategoryParents'
AND CONSTRAINT_NAME = 'ac_Categories_ac_CategoryAssn_FK1')
BEGIN
alter table "ac_CategoryParents"
	drop constraint "ac_Categories_ac_CategoryAssn_FK1"
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_CategoryParents'
AND CONSTRAINT_NAME = 'ac_Categories_ac_CategoryParents_FK1')
BEGIN
ALTER TABLE "ac_CategoryParents"
	ADD CONSTRAINT ac_Categories_ac_CategoryParents_FK1 FOREIGN KEY (
		CategoryId)
	 REFERENCES ac_Categories (
		CategoryId) ON UPDATE NO ACTION ON DELETE CASCADE  
END

GO


/**************************/
/* [ac_ErrorMessages]   */
/**************************/

ALTER TABLE ac_ErrorMessages ALTER COLUMN [Text] [nvarchar](500) NOT NULL

GO

/**************************/
/* [ac_Links]   */
/**************************/
/* ADD COLUMNS */

ALTER TABLE [ac_Links]
ADD [MetaDescription] [nvarchar](1000) NULL

GO

ALTER TABLE [ac_Links]
ADD [MetaKeywords] [nvarchar](1000) NULL

GO

IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'HtmlHead' and Object_ID = Object_ID(N'ac_Links'))
BEGIN
	ALTER TABLE [ac_Links]
	ADD [HtmlHead] [nvarchar](MAX) NULL
END

/* HtmlHead is back in GoldR5 */
/* ALTER TABLE [ac_Links] */
/* DROP COLUMN [HtmlHead] */
/* GO */

/**************************/
/* [ac_OrderItems]   */
/**************************/
ALTER TABLE ac_OrderItems ALTER COLUMN [OptionList] [varchar](500) NULL

GO

ALTER TABLE ac_OrderItems ALTER COLUMN [LineMessage] [nvarchar](500) NULL

GO

ALTER TABLE ac_OrderItems ALTER COLUMN [GiftMessage] [nvarchar](500) NULL

GO

ALTER TABLE ac_OrderItems ALTER COLUMN [KitList] [varchar](500) NULL

GO

/**************************/
/* [ac_Orders]   */
/**************************/

ALTER TABLE ac_Orders ALTER COLUMN [BillToCountryCode] [char](2)NULL

GO

/**************************/
/* [ac_OrderShipments]   */
/**************************/

ALTER TABLE ac_OrderShipments ALTER COLUMN [ShipToCountryCode] [char](2) NULL

GO


/**************************/
/* [ac_PageViews]   */
/**************************/
/* DROP INDEX */
IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_PageViews_IX1' AND object_id = OBJECT_ID('ac_PageViews'))
BEGIN
	DROP INDEX [ac_PageViews_IX1] ON ac_PageViews
END

GO

ALTER TABLE ac_PageViews ALTER COLUMN CatalogNodeTypeId [TINYINT] NULL

GO

/* ADD INDEX AGAIN */
CREATE INDEX ac_PageViews_IX1 ON ac_PageViews
(
	[StoreId] ASC,
	[CatalogNodeTypeId] ASC,
	[ActivityDate] ASC
)

GO

/**************************/
/* [ac_ProductImages]   */
/**************************/
ALTER TABLE [ac_ProductImages]
ADD [Moniker] [varchar](255) NULL

GO

/**************************/
/* [ac_Products]   */
/**************************/
/* ADD COLUMNS */

ALTER TABLE [ac_Products]
ADD [WebpageId] [int] NULL

GO

IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'Title' and Object_ID = Object_ID(N'ac_Products'))
BEGIN
	ALTER TABLE [ac_Products]
	ADD [Title] [nvarchar](100) NULL
END

GO

IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'HtmlHead' and Object_ID = Object_ID(N'ac_Products'))
BEGIN
	ALTER TABLE [ac_Products]
	ADD [HtmlHead] [nvarchar](MAX) NULL
END

ALTER TABLE [ac_Products]
ADD [MetaDescription] [nvarchar](1000) NULL

GO

ALTER TABLE [ac_Products]
ADD [MetaKeywords] [nvarchar](1000) NULL

GO

ALTER TABLE [ac_Products]
ADD GTIN NVARCHAR(30) NULL

GO

ALTER TABLE [ac_Products]
ADD GoogleCategory NVARCHAR(300) NULL

GO

ALTER TABLE [ac_Products]
ADD Condition NVARCHAR(20) NULL

GO

ALTER TABLE [ac_Products]
ADD Gender NVARCHAR(10) NULL

GO

ALTER TABLE [ac_Products]
ADD AgeGroup NVARCHAR(10) NULL

GO

ALTER TABLE [ac_Products]
ADD Color NVARCHAR(20) NULL

GO

ALTER TABLE [ac_Products]
ADD Size NVARCHAR(20) NULL

GO

ALTER TABLE [ac_Products]
ADD AdwordsGrouping NVARCHAR(50) NULL

GO

ALTER TABLE [ac_Products]
ADD AdwordsLabels NVARCHAR(256) NULL

GO

ALTER TABLE [ac_Products]
ADD AdwordsRedirect NVARCHAR(256) NULL

GO

/* ADDED FOR GOLD R5 */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_Products' AND COLUMN_NAME = 'PublishFeedAsVariants')
BEGIN
	ALTER TABLE [ac_Products] ADD PublishFeedAsVariants BIT DEFAULT 0 NOT NULL
END

GO

ALTER TABLE [ac_Products]
ADD RowVersion INT DEFAULT 1 NOT NULL

GO

/* SHOULD BE NOT NULL */
ALTER TABLE [ac_Products]
ADD OrderBy DECIMAL(10,2) NULL

GO

/* POPULATE DEFAULT VALUE TO OrderBy, TO MAKE SURE WE DO NOT HAVE A NULL VALUE */
UPDATE ac_Products SET OrderBy = 0 WHERE OrderBy IS NULL

GO

/* CONVERT OrderBy TO NOT NULL */
ALTER TABLE ac_Products ALTER COLUMN OrderBy DECIMAL(10,2) NOT NULL

GO

/* SearchKeywords are back in Gold R5 so we no longer need data transfer */
/* TRANSFER DATA */
/* COPY FROM SearchKeywords TO MetaKeywords */
/* UPDATE P1 SET P1.MetaKeywords = P2.SearchKeywords */
/* FROM ac_Products P1 INNER JOIN ac_Products P2 ON P1.ProductId = P2.ProductId */
/* GO */

/* DROP COLUMNS*/
ALTER TABLE [ac_Products]
DROP COLUMN [DisplayPage]

GO

/* HtmlHead is back in GoldR5 */
/* ALTER TABLE [ac_Products] */
/* DROP COLUMN [HtmlHead] */
/*GO */

ALTER TABLE [ac_Products]
DROP COLUMN [Theme]

GO

/* Ensure VendorId Column Integrity */
UPDATE ac_Products SET VendorId = null WHERE VendorId = 0

GO

/* MODIFY ac_Vendors_ac_Products_FK1 TO UPDATE ON DELETE ACTION */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_Products' 
AND CONSTRAINT_NAME = 'ac_Vendors_ac_Products_FK1')
BEGIN
alter table "ac_Products"
	drop constraint ac_Vendors_ac_Products_FK1
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_Products'
AND CONSTRAINT_NAME = 'ac_Vendors_ac_Products_FK1')
BEGIN
ALTER TABLE ac_Products
	ADD CONSTRAINT ac_Vendors_ac_Products_FK1 FOREIGN KEY (
		VendorId)
	 REFERENCES ac_Vendors (
		VendorId) ON UPDATE NO ACTION ON DELETE SET NULL

END

GO

/* SearchKeywords are back in Gold R5 so we no longer need to drop the column */
/* ALTER TABLE [ac_Products] */
/* DROP COLUMN [SearchKeywords] */
/* GO */

/**************************/
/* [ac_ProductVariants]   */
/**************************/

ALTER TABLE [ac_ProductVariants]
ADD [RowVersion] [int] DEFAULT 1 NOT NULL

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_ProductVariants' AND COLUMN_NAME = 'GTIN')
BEGIN
	ALTER TABLE [ac_ProductVariants] ADD GTIN NVARCHAR(30) NULL
END

GO

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_ProductVariants' AND COLUMN_NAME = 'ImageUrl')
BEGIN
	ALTER TABLE [ac_ProductVariants] ADD ImageUrl VARCHAR(255) NULL
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_ProductVariants' AND COLUMN_NAME = 'ThumbnailUrl')
BEGIN
	ALTER TABLE [ac_ProductVariants] ADD ThumbnailUrl VARCHAR(255) NULL
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_ProductVariants' AND COLUMN_NAME = 'IconUrl')
BEGIN
	ALTER TABLE [ac_ProductVariants] ADD IconUrl VARCHAR(255) NULL
END


GO

ALTER TABLE [ac_ProductVariants] 
ADD MSRP DECIMAL(12,4) NULL

GO

/**************************/
/* [ac_OptionChoices]   */
/**************************/

ALTER TABLE [ac_OptionChoices] 
ADD MsrpModifier DECIMAL(10,2) NULL

GO

/**************************/
/* [ac_ShipZones]   */
/**************************/

ALTER TABLE ac_ShipZones ALTER COLUMN [PostalCodeFilter] [nvarchar](450) NULL

GO

ALTER TABLE ac_ShipZones ALTER COLUMN [ExcludePostalCodeFilter] [nvarchar](500) NULL

GO

/**************************/
/* [ac_Users]   */
/**************************/

/* WE HAVE ALREADY TRANSFERED DATA TO ac_Addresses.IsBilling,  DROP PrimaryAddressId COLUMN FROM USERS TABLE*/
ALTER TABLE [ac_Users]
DROP COLUMN [PrimaryAddressId]

GO

/* ESTABLISH NEW FIELDS FOR TAX EXEMPTION */
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ac_Users' AND COLUMN_NAME = 'TaxExemptionType') 
BEGIN 
ALTER TABLE ac_Users ADD TaxExemptionType int null; 
EXEC('UPDATE ac_Users SET TaxExemptionType = 0 WHERE TaxExemptionType IS NULL'); 
ALTER TABLE ac_Users ALTER COLUMN TaxExemptionType int not null; 
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ac_Users' AND COLUMN_NAME = 'TaxExemptionReference') 
BEGIN 
ALTER TABLE ac_Users ADD TaxExemptionReference nvarchar(200) NULL;
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ac_Orders' AND COLUMN_NAME = 'TaxExemptionType') 
BEGIN 
ALTER TABLE ac_Orders ADD TaxExemptionType int null; 
EXEC('UPDATE ac_Orders SET TaxExemptionType = 0 WHERE TaxExemptionType IS NULL'); 
ALTER TABLE ac_Orders ALTER COLUMN TaxExemptionType int not null; 
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ac_Orders' AND COLUMN_NAME = 'TaxExemptionReference') 
BEGIN 
ALTER TABLE ac_Orders ADD TaxExemptionReference nvarchar(200) NULL	
END

GO

/* MIGRATE GROUP LEVEL TAX EXEMPTION TO USER */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ac_Groups' AND COLUMN_NAME = 'IsTaxExempt') 
BEGIN 
UPDATE ac_Users SET TaxExemptionType = 17 
WHERE UserId IN (SELECT UG.UserId FROM ac_Groups AS G INNER JOIN ac_UserGroups AS UG ON G.GroupId = UG.GroupId WHERE G.IsTaxExempt = 1) AND TaxExemptionType = 0;
ALTER TABLE ac_Groups DROP COLUMN IsTaxExempt
END

GO

/**************************/
/* [ac_Webpages]   */
/**************************/

ALTER TABLE [ac_Webpages]
ADD [Layout] [varchar](100) NULL

GO

/* SHOULD BE NOT NULL FILED */
ALTER TABLE [ac_Webpages]
ADD [WebpageTypeId] [tinyint] NULL

GO

/* POPULATE DEFAULT VALUE, SET TYPE TO "Content" FOR WebpageTypeId  */
UPDATE ac_Webpages SET WebpageTypeId = 0 
WHERE  WebpageTypeId IS NULL

GO

/* CONVERT WebpageTypeId TO NOT NULL */
ALTER TABLE ac_Webpages ALTER COLUMN [WebpageTypeId] [tinyint] NOT NULL

GO

IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'Title' and Object_ID = Object_ID(N'ac_Webpages'))
BEGIN
	ALTER TABLE [ac_Webpages]
	ADD [Title] [nvarchar](100) NULL
END

GO

IF NOT EXISTS(SELECT * FROM SYS.COLUMNS WHERE Name = N'HtmlHead' and Object_ID = Object_ID(N'ac_Webpages'))
BEGIN
	ALTER TABLE [ac_Webpages]
	ADD [HtmlHead] [nvarchar](MAX) NULL
END

ALTER TABLE [ac_Webpages]
ADD [MetaDescription] [nvarchar](1000) NULL

GO

ALTER TABLE [ac_Webpages]
ADD [MetaKeywords] [nvarchar](1000) NULL

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ac_Webpages' AND COLUMN_NAME = 'PublishedBy')
BEGIN
	ALTER TABLE [ac_Webpages] ADD PublishedBy NVARCHAR(150) NULL
END

ALTER TABLE [ac_Webpages] 
ADD PublishDate DATETIME NULL

GO

/* DROP COLUMNS*/
ALTER TABLE [ac_Webpages]
DROP COLUMN [DisplayPage]

GO

/* HtmlHead is back in GoldR5 */
/* ALTER TABLE [ac_Webpages] */
/* DROP COLUMN [HtmlHead] */
/* GO */

/**************************/
/* [ac_Wishlist]   */
/**************************/


ALTER TABLE [ac_Wishlists] ADD IsPublic BIT DEFAULT 0 NOT NULL

GO

ALTER TABLE [ac_Wishlists] ADD ViewCode UNIQUEIDENTIFIER DEFAULT newsequentialid() NOT NULL

GO

/**************************/
/* [ac_WishlistItems]   */
/**************************/
ALTER TABLE ac_WishlistItems ALTER COLUMN [OptionList] [varchar](500) NULL

GO

ALTER TABLE ac_WishlistItems ALTER COLUMN [KitList] [varchar](500) NULL

GO

ALTER TABLE ac_WishlistItems ALTER COLUMN [LineMessage] [nvarchar](500) NULL

GO



/*********************/
/* ADD NEW TABLES    */
/*********************/
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ac_Languages')
BEGIN
CREATE TABLE ac_Languages(
	Id INT IDENTITY NOT NULL,
	Name NVARCHAR(255) NOT NULL,
	Culture NVARCHAR(255) NULL,
	IsActive BIT DEFAULT 0 NOT NULL,
	PRIMARY KEY(Id))

END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ac_LanguageStrings')
BEGIN
CREATE TABLE ac_LanguageStrings(
	Id INT IDENTITY NOT NULL,
	LanguageId INT NOT NULL,
	ResourceName NVARCHAR(255) NULL,
	Translation NVARCHAR(MAX) NULL,
	PRIMARY KEY(Id))

END

GO


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_LanguageStrings' AND CONSTRAINT_NAME = 'ac_LanguageStrings_ac_Languages_FK1')
BEGIN
ALTER TABLE ac_LanguageStrings
	ADD CONSTRAINT ac_LanguageStrings_ac_Languages_FK1 FOREIGN KEY (
		LanguageId)
	 REFERENCES ac_Languages (
		Id) ON UPDATE NO ACTION ON DELETE CASCADE

END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ac_SearchHistory')
BEGIN
CREATE TABLE [ac_SearchHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SearchTerm] [nvarchar](200) NOT NULL,
	[UserId] [int] NULL,
	[SearchDate] [datetime] NOT NULL,
	PRIMARY KEY(Id))
END

GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_SearchHistory' AND CONSTRAINT_NAME = 'ac_Users_ac_SearchHistory_FK1')
BEGIN
ALTER TABLE ac_SearchHistory
	ADD CONSTRAINT ac_Users_ac_SearchHistory_FK1 FOREIGN KEY (UserId)
	 REFERENCES ac_Users (UserId) ON UPDATE NO ACTION ON DELETE CASCADE
END

GO

/***************************************************************/
/* UPGRADE OLD SAMLPE DATA AND ADD INDEX FOR REVIEWER PROFILES */
/***************************************************************/

UPDATE ac_ReviewerProfiles SET Email = 'sara@sample.xyz', DisplayName = 'Sara' WHERE ReviewerProfileId = 1 AND Email = '';
UPDATE ac_ReviewerProfiles SET Email = 'katie@sample.xyz', DisplayName = 'Katie' WHERE ReviewerProfileId = 2 AND Email = 'katie@ablecommerce.com';
UPDATE ac_ReviewerProfiles SET Email = 'joe@sample.xyz', DisplayName = 'Joe' WHERE ReviewerProfileId = 3 AND Email = 'joe@ablecommerce.com';
UPDATE ac_ReviewerProfiles SET Email = 'katy@sample.xyz', DisplayName = 'Katy' WHERE ReviewerProfileId = 4 AND Email = 'katie@ablecommerce.com';
UPDATE ac_ReviewerProfiles SET Email = 'jim@sample.xyz', DisplayName = 'James' WHERE ReviewerProfileId = 5 AND Email = 'jim@ablecommerce.com';
CREATE UNIQUE INDEX ac_ReviewerProfiles_IX1 ON ac_ReviewerProfiles (Email)

GO

/****************************/
/* USE UPDATED TAX PROVIDER */
/****************************/

UPDATE ac_TaxGateways SET ClassId = 'CommerceBuilder.Services.Taxes.AbleCommerce.AbleCommerceTax, CommerceBuilder'
WHERE ClassId = 'CommerceBuilder.Taxes.Providers.AbleCommerce.AbleCommerceTax, CommerceBuilder.AbleCommerceTax'

GO

/***************************/
/* DROP UN-USED TABLES    */
/***************************/

/* DROP FORIEGN KEY CONSTRAINTS */
ALTER TABLE "ac_UserPersonalization" DROP CONSTRAINT "ac_Paths_ac_UserPersonalization_FK1"

GO

ALTER TABLE "ac_SharedPersonalization" DROP CONSTRAINT "ac_Paths_ac_SharedPersonalization_FK1"

GO

ALTER TABLE "ac_PersonalizationPaths" DROP CONSTRAINT "ac_PersonalizationPaths_PK"

GO

ALTER TABLE "ac_PersonalizationPaths" DROP CONSTRAINT "ac_Stores_ac_Paths_FK1"

GO

/* DROP TABLES */
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='ac_IPLocations') 
DROP TABLE ac_IPLocations

GO

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='ac_PersonalizationPaths') 
DROP TABLE ac_PersonalizationPaths

GO

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='ac_Profiles') 
DROP TABLE ac_Profiles

GO

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='ac_SharedPersonalization') 
DROP TABLE ac_SharedPersonalization

GO

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='ac_UpsOrigin') 
DROP TABLE ac_UpsOrigin

GO

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='ac_UserPersonalization') 
DROP TABLE ac_UserPersonalization

GO

/***************************/
/* ENSURE INDEXES          */
/***************************/

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_CatalogNodes_IX1' AND object_id = OBJECT_ID('ac_CatalogNodes'))
DROP INDEX ac_CatalogNodes_IX1 ON ac_CatalogNodes

CREATE INDEX ac_CatalogNodes_IX1 ON ac_CatalogNodes
(
	[CatalogNodeTypeId] ASC,
	[CategoryId] ASC,
	[CatalogNodeId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_CatalogNodes_IX2' AND object_id = OBJECT_ID('ac_CatalogNodes'))
DROP INDEX ac_CatalogNodes_IX2 ON ac_CatalogNodes

CREATE INDEX ac_CatalogNodes_IX2 ON ac_CatalogNodes
(
	[CategoryId] ASC,
	[CatalogNodeId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_CatalogNodes_IX3' AND object_id = OBJECT_ID('ac_CatalogNodes'))
DROP INDEX ac_CatalogNodes_IX3 ON ac_CatalogNodes

CREATE INDEX ac_CatalogNodes_IX3 ON ac_CatalogNodes 
(
	[CategoryId] ASC,
	[OrderBy] ASC
)
INCLUDE
(
	[Id],
	[CatalogNodeId],
	[CatalogNodeTypeId]
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_CatalogNodes_IX4' AND object_id = OBJECT_ID('ac_CatalogNodes'))
DROP INDEX ac_CatalogNodes_IX4 ON ac_CatalogNodes

CREATE INDEX ac_CatalogNodes_IX4 ON [ac_CatalogNodes] 
(
	[CatalogNodeTypeId] ASC,
	[CatalogNodeId] ASC,
	[CategoryId] ASC
)
INCLUDE
(
	[Id]
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_PageViews_IX1' AND object_id = OBJECT_ID('ac_PageViews'))
DROP INDEX ac_PageViews_IX1 ON ac_PageViews

CREATE INDEX ac_PageViews_IX1 ON ac_PageViews
(
	[StoreId] ASC,
	[CatalogNodeTypeId] ASC,
	[ActivityDate] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Orders_IX1' AND object_id = OBJECT_ID('ac_Orders'))
DROP INDEX ac_Orders_IX1 ON ac_Orders

CREATE INDEX ac_Orders_IX1 ON ac_Orders 
(
	[StoreId] ASC,
	[OrderDate] ASC
)
INCLUDE
(
	[OrderId],
	[OrderNumber],
	[UserId],
	[AffiliateId],
	[BillToFirstName],
	[BillToLastName],
	[BillToCompany],
	[BillToAddress1],
	[BillToAddress2],
	[BillToCity],
	[BillToProvince],
	[BillToPostalCode],
	[BillToCountryCode],
	[BillToPhone],
	[BillToFax],
	[BillToEmail],
	[ProductSubtotal],
	[TotalCharges],
	[TotalPayments],
	[OrderStatusId],
	[Exported],
	[RemoteIP],
	[Referrer],
	[GoogleOrderNumber],
	[PaymentStatusId],
	[ShipmentStatusId],
	[TaxExemptionType],
	[TaxExemptionReference]
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Orders_IX2' AND object_id = OBJECT_ID('ac_Orders'))
DROP INDEX ac_Orders_IX2 ON ac_Orders

CREATE INDEX ac_Orders_IX2 ON ac_Orders
(
	[UserId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Orders_IX3' AND object_id = OBJECT_ID('ac_Orders'))
DROP INDEX ac_Orders_IX3 ON ac_Orders

CREATE INDEX ac_Orders_IX3 ON ac_Orders 
(
	[StoreId] ASC,
	[OrderNumber] ASC
)
INCLUDE
(
	[OrderId]
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_OrderItems_IX1' AND object_id = OBJECT_ID('ac_OrderItems'))
DROP INDEX ac_OrderItems_IX1 ON ac_OrderItems

CREATE INDEX  ac_OrderItems_IX1 ON ac_OrderItems
(
	[OrderId] ASC,
	[OrderBy] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_OrderItems_IX2' AND object_id = OBJECT_ID('ac_OrderItems'))
DROP INDEX ac_OrderItems_IX2 ON ac_OrderItems

CREATE INDEX ac_OrderItems_IX2 ON ac_OrderItems
(
	[OrderItemTypeId] ASC,
	[ProductId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_OrderItems_IX3' AND object_id = OBJECT_ID('ac_OrderItems'))
DROP INDEX ac_OrderItems_IX3 ON ac_OrderItems

CREATE INDEX ac_OrderItems_IX3 ON [ac_OrderItems] 
(
	[OrderItemTypeId] ASC,
	[OrderItemId] ASC,
	[ProductId] ASC
)
INCLUDE
(
	[Quantity]
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_OrderNotes_IX1' AND object_id = OBJECT_ID('ac_OrderNotes'))
DROP INDEX ac_OrderNotes_IX1 ON ac_OrderNotes

CREATE INDEX ac_OrderNotes_IX1 ON ac_OrderNotes
(
	[OrderId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_OrderShipments_IX1' AND object_id = OBJECT_ID('ac_OrderShipments'))
DROP INDEX ac_OrderShipments_IX1 ON ac_OrderShipments

CREATE INDEX ac_OrderShipments_IX1 on ac_OrderShipments
(
	[OrderId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Payments_IX1' AND object_id = OBJECT_ID('ac_Payments'))
DROP INDEX ac_Payments_IX1 ON ac_Payments

CREATE INDEX ac_Payments_IX1 ON ac_Payments
(
	[OrderId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Products_IX1' AND object_id = OBJECT_ID('ac_Products'))
DROP INDEX ac_Products_IX1 ON ac_Products

CREATE INDEX ac_Products_IX1 ON ac_Products
(
	[VisibilityId] ASC,
	[ProductId] ASC,
	[StoreId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Products_IX2' AND object_id = OBJECT_ID('ac_Products'))
DROP INDEX ac_Products_IX2 ON ac_Products

CREATE INDEX ac_Products_IX2 ON ac_Products
(
	[StoreId] ASC,
	[VisibilityId] ASC,
	[ManufacturerId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Products_IX3' AND object_id = OBJECT_ID('ac_Products'))
DROP INDEX ac_Products_IX3 ON ac_Products

CREATE INDEX ac_Products_IX3 ON ac_Products
(
	[ProductId] ASC,
	[VisibilityId] ASC,
	[Name] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Products_IX4' AND object_id = OBJECT_ID('ac_Products'))
DROP INDEX ac_Products_IX4 ON ac_Products

CREATE INDEX ac_Products_IX4 ON ac_Products
(
	[StoreId] ASC,
	[VisibilityId] ASC,
	[Name] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Products_IX5' AND object_id = OBJECT_ID('ac_Products'))
DROP INDEX ac_Products_IX5 ON ac_Products

CREATE INDEX ac_Products_IX5 ON ac_Products
(
	[IsGiftCertificate] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Products_IX6' AND object_id = OBJECT_ID('ac_Products'))
DROP INDEX ac_Products_IX6 ON ac_Products

CREATE INDEX ac_Products_IX6 ON ac_Products
(
	[ManufacturerId] ASC,
	[ProductId] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Products_IX7' AND object_id = OBJECT_ID('ac_Products'))
DROP INDEX ac_Products_IX7 ON ac_Products

CREATE INDEX ac_Products_IX7 ON ac_Products
(
	[InventoryModeId] ASC,
	[InStock] ASC,
	[InStockWarningLevel] ASC
)

GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Users_IX1' AND object_id = OBJECT_ID('ac_Users'))
DROP INDEX ac_Users_IX1 ON ac_Users

CREATE INDEX ac_Users_IX1 ON ac_Users
(
	[LoweredUserName] ASC
)

GO

/* migrate FedEx configurations */
UPDATE ac_ShipGateways SET ClassId='AblePlugins.FedEx.FedExProvider, AblePlugins.FedEx'
WHERE ClassId='CommerceBuilder.Shipping.Providers.FedExWS.FedExWS, CommerceBuilder.FedExWS'
OR ClassId='CommerceBuilder.Shipping.Providers.FedEx.FedEx, CommerceBuilder.FedEx'
GO

/* clean up old dirty data */
DELETE FROM ac_Kits WHERE ProductId IN (SELECT DISTINCT K.ProductId FROM ac_Kits K LEFT JOIN ac_Products P ON K.ProductId=P.ProductId WHERE P.ProductId IS NULL)
GO

DELETE FROM ac_ProductKitComponents WHERE ProductId IN (SELECT DISTINCT PKC.ProductId FROM ac_ProductKitComponents PKC LEFT JOIN ac_Products P ON PKC.ProductId=P.ProductId WHERE P.ProductId IS NULL)
GO

INSERT INTO ac_Kits (ProductId, ItemizeDisplay)
SELECT DISTINCT PKC.ProductId, 0 AS ItemizeDisplay FROM ac_ProductKitComponents PKC LEFT JOIN ac_Kits K ON PKC.ProductId = K.ProductId WHERE K.ProductId IS NULL
GO

DELETE CP FROM ac_CategoryParents CP LEFT JOIN ac_Categories C
ON CP.ParentId = C.CategoryId
WHERE CP.ParentId > 0 AND C.CategoryId IS NULL;
GO

DELETE CN FROM ac_CatalogNodes CN LEFT JOIN ac_Categories C
ON CN.CategoryId = C.CategoryId
WHERE CN.CategoryId > 0 AND C.CategoryId IS NULL
GO
