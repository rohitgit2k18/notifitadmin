SET QUOTED_IDENTIFIER ON

GO

/*------------------------------ TABLE SCRIPTS ---------------------------------*/

CREATE TABLE ac_Addresses ( 
	AddressId INT IDENTITY NOT NULL,
	UserId INT NOT NULL,
	Nickname NVARCHAR(100) NULL,
	FirstName NVARCHAR(30) NULL,
	LastName NVARCHAR(50) NULL,
	Company NVARCHAR(50) NULL,
	Address1 NVARCHAR(255) NULL,
	Address2 NVARCHAR(255) NULL,
	City NVARCHAR(50) NULL,
	Province NVARCHAR(50) NULL,
	PostalCode NVARCHAR(15) NULL,
	CountryCode CHAR(2) NULL,
	Phone NVARCHAR(50) NULL,
	Fax NVARCHAR(50) NULL,
	Email NVARCHAR(255) NULL,
	Residence BIT NOT NULL,
	Validated BIT NOT NULL,
	IsBilling BIT DEFAULT 0 NOT NULL
	CONSTRAINT [ac_Addresses_PK] PRIMARY KEY CLUSTERED ([AddressId] ASC))   

GO

CREATE TABLE ac_Affiliates ( 
	AffiliateId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	PayeeName NVARCHAR(100) NULL,
	FirstName NVARCHAR(30) NULL,
	LastName NVARCHAR(50) NULL,
	Company NVARCHAR(50) NULL,
	Address1 NVARCHAR(100) NULL,
	Address2 NVARCHAR(100) NULL,
	City NVARCHAR(50) NULL,
	Province NVARCHAR(50) NULL,
	PostalCode NVARCHAR(15) NULL,
	CountryCode CHAR(2) NULL,
	PhoneNumber NVARCHAR(50) NULL,
	FaxNumber NVARCHAR(50) NULL,
	MobileNumber NVARCHAR(50) NULL,
	WebsiteUrl NVARCHAR(255) NULL,
	Email NVARCHAR(255) NULL,
	CommissionRate DECIMAL(9,4) NOT NULL,
	CommissionIsPercent BIT NOT NULL,
	CommissionOnTotal BIT NOT NULL,
	ReferralPeriodId TINYINT NOT NULL,
	ReferralDays SMALLINT NOT NULL,
	GroupId INT NULL,
	PRIMARY KEY(AffiliateId))   

GO

CREATE TABLE ac_AuditEvents ( 
	AuditEventId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	EventDate DATETIME NOT NULL,
	EventTypeId INT NOT NULL,
	Successful BIT NOT NULL,
	UserId INT NULL,
	RelatedId INT NULL,
	RemoteIP VARCHAR(39) NULL,
	Comment NVARCHAR(MAX) NULL,
	PRIMARY KEY(AuditEventId))   

GO

CREATE TABLE ac_BannedIPs ( 
	BannedIPId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	IPRangeStart bigint NOT NULL,
	IPRangeEnd bigint NOT NULL,
	Comment NVARCHAR(100) NULL,
	PRIMARY KEY(BannedIPId))   

GO

CREATE TABLE ac_BasketCoupons (
	BasketCouponId INT IDENTITY NOT NULL, 
	BasketId INT NOT NULL,
	CouponId INT NOT NULL,
	AppliedDate DATETIME NOT NULL,
	PRIMARY KEY(BasketCouponId))   

GO

CREATE TABLE ac_BasketItemInputs ( 
	BasketItemInputId INT IDENTITY NOT NULL,
	BasketItemId INT NOT NULL,
	InputFieldId INT NOT NULL,
	InputValue NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY(BasketItemInputId))   

GO

CREATE TABLE ac_BasketItems ( 
	BasketItemId INT IDENTITY NOT NULL,
	ParentItemId INT NOT NULL,
	BasketId INT NOT NULL,
	BasketShipmentId INT NULL,
	ProductId INT NULL,
	OptionList VARCHAR(500) NULL,
	TaxCodeId INT NULL,
	Name NVARCHAR(255) NOT NULL,
	Sku NVARCHAR(100) NULL,
	Price DECIMAL(12,4) NOT NULL,
	[Weight] DECIMAL(12,4) NOT NULL,
	Quantity SMALLINT NOT NULL,
	LineMessage NVARCHAR(500) NULL,
	OrderItemTypeId SMALLINT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	WrapStyleId INT NULL,
	GiftMessage NVARCHAR(500) NULL,
	WishlistItemId INT NULL,
	ShippableId TINYINT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	TaxRate DECIMAL(12,4) NOT NULL,
	TaxAmount DECIMAL(12,4) NOT NULL,
	KitList VARCHAR(500) NULL,
	CustomFields NVARCHAR(MAX) NULL,
	IsSubscription BIT DEFAULT 0 NOT NULL,
	Frequency SMALLINT DEFAULT 0 NOT NULL,
	FrequencyUnitId TINYINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(BasketItemId))   

GO

CREATE TABLE ac_Baskets ( 
	BasketId INT IDENTITY NOT NULL,
	UserId INT NOT NULL,
	ContentHash NVARCHAR(32) NULL,
	PRIMARY KEY(BasketId))
GO

CREATE TABLE ac_BasketShipments ( 
	BasketShipmentId INT IDENTITY NOT NULL,
	BasketId INT NOT NULL,
	WarehouseId INT NULL,
	ShipMethodId INT NULL,
	AddressId INT NULL,
	ShipMessage NVARCHAR(255) NULL,
	PRIMARY KEY(BasketShipmentId))   

GO

CREATE TABLE ac_CatalogNodes ( 
	Id INT IDENTITY NOT NULL,
	CategoryId INT NOT NULL,
	CatalogNodeId INT NOT NULL,
	CatalogNodeTypeId TINYINT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(Id))   

GO

CREATE TABLE ac_Categories ( 
	CategoryId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	ParentId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	Summary NVARCHAR(MAX) NULL,
	Description NVARCHAR(MAX) NULL,
	ThumbnailUrl VARCHAR(255) NULL,
	ThumbnailAltText NVARCHAR(255) NULL,
	WebpageId INT NULL,
	VisibilityId TINYINT NOT NULL,
	Title NVARCHAR(100) NULL,
	HtmlHead NVARCHAR(MAX) NULL,
	MetaDescription NVARCHAR(1000) NULL,
	MetaKeywords NVARCHAR(1000) NULL,
	PRIMARY KEY(CategoryId))   

GO

CREATE TABLE ac_CategoryParents ( 
	Id INT IDENTITY NOT NULL,
	CategoryId INT NOT NULL,
	ParentId INT NOT NULL,
	ParentLevel TINYINT NOT NULL,
	ParentNumber TINYINT NOT NULL,
	PRIMARY KEY(Id))   

GO

CREATE TABLE ac_CategoryVolumeDiscounts ( 
	CategoryId INT NOT NULL,
	VolumeDiscountId INT NOT NULL,
	PRIMARY KEY(CategoryId,VolumeDiscountId))   
GO

CREATE TABLE ac_Countries ( 
	CountryCode CHAR(2) NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	AddressFormat NVARCHAR(255) NULL,
	PRIMARY KEY(CountryCode))   
GO

CREATE TABLE ac_CouponCombos (
    CouponComboId INT IDENTITY NOT NULL,
	CouponId INT NOT NULL,
	ComboCouponId INT NOT NULL,
	PRIMARY KEY(CouponComboId))   

GO

CREATE TABLE ac_CouponGroups ( 
	CouponId INT NOT NULL,
	GroupId INT NOT NULL,
	PRIMARY KEY(CouponId,GroupId))   

GO

CREATE TABLE ac_CouponProducts ( 
	CouponId INT NOT NULL,
	ProductId INT NOT NULL,
	PRIMARY KEY(CouponId, ProductId))   
GO

CREATE TABLE ac_Coupons ( 
	CouponId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	CouponTypeId TINYINT NULL,
	Name NVARCHAR(100) NOT NULL,
	CouponCode NVARCHAR(50) NOT NULL,
	DiscountAmount DECIMAL(12,4) NOT NULL,
	IsPercent BIT NOT NULL,
	MaxValue DECIMAL(12,4) NOT NULL,
	MinPurchase DECIMAL(12,4) NOT NULL,
	MinQuantity SMALLINT NOT NULL,
	MaxQuantity SMALLINT NOT NULL,
	QuantityInterval SMALLINT NOT NULL,
	MaxUses SMALLINT NOT NULL,
	MaxUsesPerCustomer SMALLINT NOT NULL,
	StartDate DATETIME NULL,
	EndDate DATETIME NULL,
	ProductRuleId TINYINT NOT NULL,
	AllowCombine BIT NOT NULL,
	PRIMARY KEY(CouponId))   

GO

CREATE TABLE ac_CouponShipMethods ( 
	CouponId INT NOT NULL,
	ShipMethodId INT NOT NULL,
	PRIMARY KEY(ShipMethodId,CouponId))   

GO

CREATE TABLE ac_Currencies ( 
	CurrencyId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	CurrencySymbol NVARCHAR(40) NULL,
	DecimalDigits INT NOT NULL,
	DecimalSeparator NVARCHAR(4) NULL,
	GroupSeparator NVARCHAR(4) NULL,
	GroupSizes VARCHAR(8) NULL,
	NegativePattern TINYINT NOT NULL,
	NegativeSign VARCHAR(4) NULL,
	PositivePattern TINYINT NOT NULL,
	ISOCode VARCHAR(3) NOT NULL,
	ISOCodePattern TINYINT NULL,
	ExchangeRate DECIMAL(12,4) DEFAULT 1 NOT NULL,
	AutoUpdate BIT NOT NULL,
	LastUpdate DATETIME NULL,
	PRIMARY KEY(CurrencyId))   

GO

CREATE TABLE ac_CustomFields ( 
	CustomFieldId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	TableName NVARCHAR(50) NOT NULL,
	ForeignKeyId INT NOT NULL,
	FieldName NVARCHAR(255) NOT NULL,
	FieldValue NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY(CustomFieldId))   
GO

CREATE TABLE ac_CustomUrls(
	CustomUrlId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	CatalogNodeId INT NOT NULL,
	CatalogNodeTypeId TINYINT NOT NULL,
	Url NVARCHAR(300) NOT NULL,
	LoweredUrl NVARCHAR(300) NOT NULL,
	PRIMARY KEY(CustomUrlId))
GO

CREATE TABLE ac_DigitalGoods ( 
	DigitalGoodId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	FileName NVARCHAR(100) NULL,
	FileSize bigint NOT NULL,
	MaxDownloads TINYINT NULL,
	DownloadTimeout NVARCHAR(15) NULL,
	ActivationTimeout NVARCHAR(15) NULL,
	MediaKey NVARCHAR(100) NULL,
	ServerFileName VARCHAR(255) NULL,
	EnableSerialKeys BIT NOT NULL,
	SerialKeyProviderId VARCHAR(255) NULL,
	SerialKeyConfigData NVARCHAR(MAX) NULL,
	ActivationModeId TINYINT NOT NULL,
	ActivationEmailId INT NULL,
	FulfillmentModeId TINYINT NOT NULL,
	FulfillmentEmailId INT NULL,
	ReadmeId INT NULL,
	LicenseAgreementId INT NULL,
	LicenseAgreementModeId TINYINT NOT NULL,
	PRIMARY KEY(DigitalGoodId))   

GO

CREATE TABLE ac_DigitalGoodGroups ( 
	DigitalGoodGroupId int IDENTITY(1,1) NOT NULL,
	DigitalGoodId INT NOT NULL,
	GroupId INT NOT NULL,
	PRIMARY KEY(DigitalGoodGroupId))   

GO

CREATE TABLE ac_Downloads ( 
	DownloadId INT IDENTITY NOT NULL,
	OrderItemDigitalGoodId INT NOT NULL,
	DownloadDate DATETIME NOT NULL,
	RemoteAddr NVARCHAR(39) NOT NULL,
	UserAgent NVARCHAR(255) NOT NULL,
	Referrer NVARCHAR(255) NOT NULL,
	PRIMARY KEY(DownloadId))   

GO

CREATE TABLE ac_EmailLists ( 
	EmailListId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	Description NVARCHAR(255) NULL,
	IsPublic BIT NOT NULL,
	SignupRuleId SMALLINT NOT NULL,
	SignupEmailTemplateId INT NULL,
	LastSendDate DATETIME NULL,
	PRIMARY KEY(EmailListId))   
GO

CREATE TABLE ac_EmailListSignups ( 
	EmailListSignupId INT IDENTITY NOT NULL,
	EmailListId INT NOT NULL,
	Email NVARCHAR(255) NOT NULL,
	SignupDate DATETIME NOT NULL,
	PRIMARY KEY(EmailListSignupId))   

GO

CREATE TABLE ac_EmailListUsers (
	EmailListUserId INT IDENTITY NOT NULL, 
	EmailListId INT NOT NULL,
	Email NVARCHAR(255) NOT NULL,
	SignupDate DATETIME NOT NULL,
	SignupIP VARCHAR(39) NULL,
	LastSendDate DATETIME NULL,
	FailureCount SMALLINT NOT NULL,
	PRIMARY KEY(EmailListUserId))   

GO

CREATE TABLE ac_EmailTemplates ( 
	EmailTemplateId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	ToAddress NVARCHAR(255) NOT NULL,
	FromAddress NVARCHAR(255) NOT NULL,
	ReplyToAddress NVARCHAR(255) NULL,
	CCList NVARCHAR(255) NULL,
	BCCList NVARCHAR(255) NULL,
	[Subject] NVARCHAR(255) NULL,
	ContentFileName NVARCHAR(100) NULL,
	IsHTML BIT NOT NULL,
	PRIMARY KEY(EmailTemplateId))   

GO

CREATE TABLE ac_EmailTemplateTriggers (
    EmailTemplateTriggerId INT IDENTITY NOT NULL, 
	EmailTemplateId INT NOT NULL,
	StoreEventId INT NOT NULL,
	PRIMARY KEY(EmailTemplateTriggerId))   
	
GO

CREATE TABLE ac_ErrorMessages ( 
	ErrorMessageId INT IDENTITY NOT NULL,
	EntryDate DATETIME NOT NULL,
	StoreId INT NOT NULL,
	MessageSeverityId TINYINT NOT NULL,
	[Text] NVARCHAR(500) NOT NULL,
	DebugData NVARCHAR(MAX) NULL,  
	PRIMARY KEY(ErrorMessageId))
	
GO

CREATE TABLE ac_GiftCertificates ( 
	GiftCertificateId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NULL,
	SerialNumber NVARCHAR(40) NOT NULL,
	CreatedBy INT NOT NULL,
	CreateDate DATETIME NOT NULL,
	OrderItemId INT NULL,
	ExpirationDate DATETIME NULL,
	Balance DECIMAL(12,4) NOT NULL,
	PRIMARY KEY(GiftCertificateId))   

GO

CREATE TABLE ac_GiftCertificateTransactions ( 
	GiftCertificateTransactionId INT IDENTITY NOT NULL,
	GiftCertificateId INT NOT NULL,
	OrderId INT NULL,
	TransactionDate DATETIME NOT NULL,
	Amount DECIMAL(12,4) NOT NULL,
	[Description] NVARCHAR(255) NULL,
	PRIMARY KEY(GiftCertificateTransactionId))   

GO

CREATE TABLE ac_GroupRoles( 
	GroupId INT NOT NULL,
	RoleId INT NOT NULL,  
	PRIMARY KEY(GroupId,RoleId))

GO

CREATE TABLE ac_Groups( 
	GroupId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255) NULL,
	IsReadOnly BIT NOT NULL,
	PRIMARY KEY(GroupId))

GO

CREATE TABLE ac_InputChoices ( 
	InputChoiceId INT IDENTITY NOT NULL,
	InputFieldId INT NOT NULL,
	ChoiceText NVARCHAR(100) NOT NULL,
	ChoiceValue NVARCHAR(100) NULL,
	IsSelected BIT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(InputChoiceId))   

GO

CREATE TABLE ac_InputFields( 
	InputFieldId INT IDENTITY NOT NULL,
	ProductTemplateId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	UserPrompt NVARCHAR(255) NOT NULL,
	InputTypeId SMALLINT NOT NULL,
	[Rows] TINYINT NOT NULL,
	[Columns] TINYINT NOT NULL,
	MaxLength SMALLINT NOT NULL,
	IsRequired BIT NOT NULL,
	RequiredMessage NVARCHAR(200) NULL,
	IsMerchantField BIT NOT NULL,
	PersistWithOrder BIT NOT NULL,
	PromptCssClass NVARCHAR(100) NULL,
	ControlCssClass NVARCHAR(100) NULL,
	AdditionalData NVARCHAR(255) NULL,
	UseShopBy BIT DEFAULT 0 NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(InputFieldId))

GO

CREATE TABLE ac_KitComponents( 
	KitComponentId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	UserPrompt NVARCHAR(255) NULL,
	InputTypeId SMALLINT NOT NULL,
	[Columns] TINYINT NOT NULL,
	HeaderOption NVARCHAR(100) NULL,
	PRIMARY KEY(KitComponentId))

GO

CREATE TABLE ac_KitProducts( 
	KitProductId INT IDENTITY NOT NULL,
	KitComponentId INT NOT NULL,
	ProductId INT NOT NULL,
	OptionList VARCHAR(255) NULL,
	Name NVARCHAR(255) NOT NULL,
	Quantity SMALLINT NOT NULL,
	Price DECIMAL(12,4) NOT NULL,
	PriceModeId TINYINT NOT NULL,
	[Weight] DECIMAL(12,4) NOT NULL,
	WeightModeId TINYINT NOT NULL,
	IsSelected BIT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(KitProductId))

GO

CREATE TABLE ac_Kits( 
	ProductId INT NOT NULL,
	ItemizeDisplay BIT NOT NULL,
	PRIMARY KEY(ProductId))

GO

CREATE TABLE ac_Languages(
	Id INT IDENTITY NOT NULL,
	Name NVARCHAR(255) NOT NULL,
	Culture NVARCHAR(255) NULL,
	IsActive BIT DEFAULT 0 NOT NULL,
	PRIMARY KEY(Id))

GO

CREATE TABLE ac_LanguageStrings(
	Id INT IDENTITY NOT NULL,
	LanguageId INT NOT NULL,
	ResourceName NVARCHAR(255) NULL,
	Translation NVARCHAR(MAX) NULL,
	PRIMARY KEY(Id))

GO

CREATE TABLE ac_LicenseAgreements( 
	LicenseAgreementId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	DisplayName NVARCHAR(100) NOT NULL,
	AgreementText NVARCHAR(MAX) NOT NULL,
	IsHTML BIT NOT NULL,
	PRIMARY KEY(LicenseAgreementId))

GO

CREATE TABLE ac_Links( 
	LinkId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	TargetUrl VARCHAR(255) NOT NULL,
	TargetWindow VARCHAR(40) NULL,
	Summary NVARCHAR(MAX) NULL,
	[Description] NVARCHAR(MAX) NULL,
	ThumbnailUrl VARCHAR(255) NULL,
	ThumbnailAltText NVARCHAR(255) NULL,
	DisplayPage VARCHAR(100) NULL,
	Theme VARCHAR(100) NULL,
	VisibilityId TINYINT NOT NULL,
	HtmlHead NVARCHAR(MAX) NULL,
	MetaDescription NVARCHAR(1000) NULL,
	MetaKeywords NVARCHAR(1000) NULL,
	PRIMARY KEY(LinkId))

GO

CREATE TABLE ac_Manufacturers( 
	ManufacturerId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(255) NOT NULL,
	PRIMARY KEY(ManufacturerId))

GO

CREATE TABLE ac_OptionChoices ( 
	OptionChoiceId INT IDENTITY NOT NULL,
	OptionId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	ThumbnailUrl VARCHAR(255) NULL,
	ImageUrl VARCHAR(255) NULL,
	PriceModifier DECIMAL(10,2) NULL,
	MsrpModifier DECIMAL(10,2) NULL,
	CogsModifier DECIMAL(10,2) NULL,
	WeightModifier DECIMAL(10,2) NULL,
	SkuModifier NVARCHAR(20) NULL,
	Selected BIT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(OptionChoiceId))   

GO

CREATE TABLE ac_Options( 
	OptionId INT IDENTITY NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	HeaderText NVARCHAR(100) NULL,
	ShowThumbnails BIT NOT NULL,
	ThumbnailColumns TINYINT NOT NULL,
	ThumbnailWidth SMALLINT NOT NULL,
	ThumbnailHeight SMALLINT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	PRIMARY KEY(OptionId))

GO

CREATE TABLE ac_OrderCoupons(
	OrderCouponId INT IDENTITY NOT NULL, 
	OrderId INT NOT NULL,
	CouponCode NVARCHAR(50) NOT NULL,
	PRIMARY KEY(OrderCouponId))

GO

CREATE TABLE ac_OrderItemDigitalGoods( 
	OrderItemDigitalGoodId INT IDENTITY NOT NULL,
	OrderItemId INT NOT NULL,
	DigitalGoodId INT NULL,
	Name NVARCHAR(100) NULL,
	ActivationDate DATETIME NULL,
	DownloadDate DATETIME NULL,
	SerialKeyData NVARCHAR(MAX) NULL,
	PRIMARY KEY(OrderItemDigitalGoodId))

GO

CREATE TABLE ac_OrderItemInputs( 
	OrderItemInputId INT IDENTITY NOT NULL,
	OrderItemId INT NOT NULL,
	IsMerchantField BIT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	InputValue NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY(OrderItemInputId))

GO

CREATE TABLE ac_OrderItems( 
	OrderItemId INT IDENTITY NOT NULL,
	OrderId INT NOT NULL,
	ParentItemId INT NULL,
	OrderItemTypeId SMALLINT NOT NULL,
	ShippableId TINYINT NOT NULL,
	OrderShipmentId INT NULL,
	ProductId INT NULL,
	Name NVARCHAR(255) NOT NULL,
	OptionList VARCHAR(500) NULL,
	VariantName NVARCHAR(500) NULL,
	Sku NVARCHAR(100) NULL,
	Price DECIMAL(12,4) NOT NULL,
	[Weight] DECIMAL(12,4) NOT NULL,
	CostOfGoods DECIMAL(12,4) NOT NULL,
	Quantity SMALLINT NOT NULL,
	LineMessage NVARCHAR(500) NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	GiftMessage NVARCHAR(500) NULL,
	TaxCodeId INT NULL,
	WrapStyleId INT NULL,
	WishlistItemId INT NULL,
	InventoryStatusId SMALLINT NOT NULL,
	TaxRate DECIMAL(12,4) NOT NULL,
	TaxAmount DECIMAL(12,4) NOT NULL,
	KitList VARCHAR(500) NULL,
	CustomFields NVARCHAR(MAX) NULL,
	IsSubscription BIT DEFAULT 0 NOT NULL,
	Frequency SMALLINT DEFAULT 0 NOT NULL,
	FrequencyUnitId TINYINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(OrderItemId))

GO

CREATE TABLE ac_OrderNotes( 
	OrderNoteId INT IDENTITY NOT NULL,
	OrderId INT NOT NULL,
	UserId INT NULL,
	CreatedDate DATETIME NOT NULL,
	Comment NVARCHAR(MAX) NOT NULL,
	IsRead BIT DEFAULT 1 NOT NULL,
	NoteTypeId TINYINT NOT NULL,
	CONSTRAINT [ac_OrderNotes_PK] PRIMARY KEY CLUSTERED ([OrderNoteId] ASC))

GO

CREATE TABLE ac_Orders( 
	OrderId INT IDENTITY NOT NULL,
	OrderNumber INT NOT NULL,
	OrderDate DATETIME NOT NULL,
	StoreId INT NOT NULL,
	UserId INT NULL,
	AffiliateId INT NULL,
	BillToFirstName NVARCHAR(30) NULL,
	BillToLastName NVARCHAR(50) NULL,
	BillToCompany NVARCHAR(50) NULL,
	BillToAddress1 NVARCHAR(255) NULL,
	BillToAddress2 NVARCHAR(255) NULL,
	BillToCity NVARCHAR(50) NULL,
	BillToProvince NVARCHAR(50) NULL,
	BillToPostalCode NVARCHAR(15) NULL,
	BillToCountryCode CHAR(2) NULL,
	BillToPhone NVARCHAR(50) NULL,
	BillToFax NVARCHAR(50) NULL,
	BillToEmail NVARCHAR(255) NULL,
	ProductSubtotal DECIMAL(12,4) NOT NULL,
	TotalCharges DECIMAL(12,4) NOT NULL,
	TotalPayments DECIMAL(12,4) NOT NULL,
	OrderStatusId INT NOT NULL,
	Exported BIT NOT NULL,
	RemoteIP VARCHAR(39) NULL,
	Referrer NVARCHAR(255) NULL,
	GoogleOrderNumber NVARCHAR(50) NULL,
	PaymentStatusId TINYINT NOT NULL,
	ShipmentStatusId TINYINT NOT NULL,
	TaxExemptionType INT NOT NULL,
	TaxExemptionReference NVARCHAR(200) NULL,
	IsSubscriptionGenerated BIT DEFAULT 0 NOT NULL,
	CONSTRAINT [ac_Orders_PK] PRIMARY KEY CLUSTERED ([OrderId] ASC))

GO

CREATE TABLE ac_OrderShipments( 
	OrderShipmentId INT IDENTITY NOT NULL,
	OrderId INT NOT NULL,
	WarehouseId INT NULL,
	ShipToFirstName NVARCHAR(30) NULL,
	ShipToLastName NVARCHAR(50) NULL,
	ShipToCompany NVARCHAR(50) NULL,
	ShipToAddress1 NVARCHAR(255) NULL,
	ShipToAddress2 NVARCHAR(255) NULL,
	ShipToCity NVARCHAR(50) NULL,
	ShipToProvince NVARCHAR(50) NULL,
	ShipToPostalCode NVARCHAR(15) NULL,
	ShipToCountryCode CHAR(2) NULL,
	ShipToPhone NVARCHAR(50) NULL,
	ShipToFax NVARCHAR(50) NULL,
	ShipToEmail NVARCHAR(255) NULL,
	ShipToResidence BIT NULL,
	ShipMethodId INT NULL,
	ShipMethodName NVARCHAR(255) NULL,
	ShipMessage NVARCHAR(255) NULL,
	ShipDate DATETIME NULL,
	ShipStationId INT NULL,
	ProviderShipmentNumber NVARCHAR(18) NULL,
	CONSTRAINT [ac_OrderShipments_PK] PRIMARY KEY CLUSTERED ([OrderShipmentId] ASC))

GO

CREATE TABLE ac_OrderStatusActions(
	OrderStatusActionId INT IDENTITY NOT NULL, 
	OrderStatusId INT NOT NULL,
	OrderActionId SMALLINT NOT NULL,
	PRIMARY KEY(OrderStatusActionId))

GO

CREATE TABLE ac_OrderStatusEmails( 
	OrderStatusId INT NOT NULL,
	EmailTemplateId INT NOT NULL,
	PRIMARY KEY(EmailTemplateId,OrderStatusId))

GO

CREATE TABLE ac_OrderStatuses( 
	OrderStatusId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	DisplayName NVARCHAR(100) NULL,
	InventoryActionId SMALLINT NOT NULL,
	IsActive BIT NOT NULL,
	IsValid BIT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(OrderStatusId))

GO

CREATE TABLE ac_OrderStatusTriggers( 
	OrderStatusTriggerId INT IDENTITY NOT NULL,
	StoreEventId INT NOT NULL,
	OrderStatusId INT NOT NULL,
	PRIMARY KEY(OrderStatusTriggerId))

GO

CREATE TABLE ac_PageViews( 
	PageViewId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	ActivityDate DATETIME NOT NULL,
	RemoteIP VARCHAR(39) NOT NULL,
	RequestMethod NVARCHAR(4) NOT NULL,
	UserId INT NOT NULL,
	UriStem NVARCHAR(255) NOT NULL,
	UriQuery NVARCHAR(255) NULL,
	TimeTaken INT NOT NULL,
	UserAgent NVARCHAR(255) NULL,
	Referrer NVARCHAR(255) NULL,
	CatalogNodeId INT NULL,
	CatalogNodeTypeId TINYINT NULL,
	Browser NVARCHAR(150) NOT NULL,
	BrowserName NVARCHAR(100) NOT NULL,
	BrowserPlatform NVARCHAR(40) NOT NULL,
	BrowserVersion NVARCHAR(40) NOT NULL,
	AffiliateId INT NOT NULL,
	PRIMARY KEY(PageViewId))

GO

CREATE TABLE ac_PaymentGateways( 
	PaymentGatewayId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	ClassId VARCHAR(255) NOT NULL,
	ConfigData NVARCHAR(MAX) NULL,
	ReCrypt BIT NOT NULL,
	PRIMARY KEY(PaymentGatewayId))

GO

CREATE TABLE ac_PaymentMethodGroups( 
	PaymentMethodId INT NOT NULL,
	GroupId INT NOT NULL,
	PRIMARY KEY(PaymentMethodId,GroupId))

GO

CREATE TABLE ac_PaymentMethods( 
	PaymentMethodId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	PaymentInstrumentId SMALLINT NOT NULL,
	PaymentGatewayId INT NULL,
	AllowSubscriptions BIT DEFAULT 0 NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(PaymentMethodId))

GO

CREATE TABLE ac_Payments( 
	PaymentId INT IDENTITY NOT NULL,
	OrderId INT NOT NULL,
	SubscriptionId INT NULL,
	PaymentMethodId INT NULL,
	PaymentMethodName NVARCHAR(100) NULL,
	ReferenceNumber NVARCHAR(50) NULL,
	Amount DECIMAL(12,4) NOT NULL,
	CurrencyCode NVARCHAR(3) NOT NULL,
	PaymentDate DATETIME NOT NULL,
	PaymentStatusId SMALLINT NOT NULL,
	PaymentStatusReason NVARCHAR(255) NULL,
	CompletedDate DATETIME NULL,
	EncryptedAccountData NVARCHAR(MAX) NULL,
	ReCrypt BIT NOT NULL,
	IsSubscriptionFollowup BIT DEFAULT 0 NOT NULL,
	GatewayPaymentProfileId INT NULL,
	PRIMARY KEY(PaymentId))

GO

CREATE TABLE ac_ProductAssets( 
	ProductAssetId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	AssetUrl NVARCHAR(255) NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(ProductAssetId)) 

GO

CREATE TABLE ac_ProductCustomFields(
	ProductFieldId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	IsUserDefined BIT NOT NULL,
	IsVisible BIT NOT NULL,
	FieldName NVARCHAR(100) NOT NULL,
	FieldValue NVARCHAR(MAX) NULL,
	PRIMARY KEY(ProductFieldId))  

GO

CREATE TABLE ac_ProductDigitalGoods(
	ProductDigitalGoodId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	OptionList VARCHAR(255) NULL,
	DigitalGoodId INT NOT NULL,  
	PRIMARY KEY(ProductDigitalGoodId))
GO

CREATE TABLE ac_ProductImages( 
	ProductImageId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	ImageUrl VARCHAR(255) NOT NULL,
	ImageAltText NVARCHAR(100) NULL,
	Moniker NVARCHAR(255) NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(ProductImageId))

GO

CREATE TABLE ac_ProductKitComponents(
	ProductKitComponentId INT IDENTITY NOT NULL,  
	ProductId INT NOT NULL,
	KitComponentId INT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(ProductKitComponentId))

GO

CREATE TABLE ac_ProductOptions(
	ProductOptionId INT IDENTITY NOT NULL, 
	ProductId INT NOT NULL,
	OptionId INT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(ProductOptionId))  

GO

CREATE TABLE ac_ProductReviews( 
	ProductReviewId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	ReviewerProfileId INT NOT NULL,
	ReviewDate DATETIME NOT NULL,
	Rating TINYINT NOT NULL,
	ReviewTitle NVARCHAR(100) NOT NULL,
	ReviewBody NVARCHAR(MAX) NOT NULL,
	IsApproved BIT NOT NULL,
	PRIMARY KEY(ProductReviewId))

GO

CREATE TABLE ac_Products( 
	ProductId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(255) NOT NULL,
	Price DECIMAL(12,4) NOT NULL,
	CostOfGoods DECIMAL(12,4) NOT NULL,
	MSRP DECIMAL(12,4) NOT NULL,
	[Weight] DECIMAL(12,4) NOT NULL,
	[Length] DECIMAL(12,4) NOT NULL,
	Width DECIMAL(12,4) NOT NULL,
	Height DECIMAL(12,4) NOT NULL,
	ManufacturerId INT NULL,
	Sku NVARCHAR(40) NULL,
	ModelNumber NVARCHAR(40) NULL,
	WebpageId INT NULL,	
	TaxCodeId INT NULL,
	ShippableId TINYINT DEFAULT 0 NOT NULL,
	WarehouseId INT NULL,
	InventoryModeId TINYINT NOT NULL,
	InStock INT NOT NULL,
	AvailabilityDate DATETIME NULL,
	InStockWarningLevel INT NOT NULL,
	ThumbnailUrl VARCHAR(255) NULL,
	ThumbnailAltText NVARCHAR(255) NULL,
	ImageUrl VARCHAR(255) NULL,
	ImageAltText NVARCHAR(255) NULL,
	Summary NVARCHAR(MAX) NULL,
	[Description] NVARCHAR(MAX) NULL,
	ExtendedDescription NVARCHAR(MAX) NULL,
	VendorId INT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsFeatured BIT NOT NULL,
	IsProhibited BIT NOT NULL,
	AllowReviews BIT NOT NULL,
	AllowBackorder BIT NOT NULL,
	WrapGroupId INT NULL,
	ExcludeFromFeed BIT NOT NULL,
	DisablePurchase BIT NOT NULL,
	MinQuantity SMALLINT NOT NULL,
	MaxQuantity SMALLINT NOT NULL,
	VisibilityId TINYINT NOT NULL,
	IconUrl VARCHAR(255) NULL,
	IconAltText NVARCHAR(255) NULL,
	IsGiftCertificate BIT NOT NULL,
	UseVariablePrice BIT NOT NULL,
	MinimumPrice DECIMAL(10,2) NULL,
	MaximumPrice DECIMAL(10,2) NULL,
	HandlingCharges DECIMAL(10,2) NULL,
	HidePrice BIT NOT NULL,
	EnableGroups BIT DEFAULT 0 NOT NULL,
	Title NVARCHAR(100) NULL,
	HtmlHead NVARCHAR(MAX) NULL,
	MetaDescription NVARCHAR(1000) NULL,
	MetaKeywords NVARCHAR(1000) NULL,
	SearchKeywords NVARCHAR(MAX) NULL,
	GTIN NVARCHAR(30) NULL,
	GoogleCategory NVARCHAR(300) NULL,
	Condition NVARCHAR(20) NULL,
	Gender NVARCHAR(10) NULL,
	AgeGroup NVARCHAR(10) NULL,
	Color NVARCHAR(20) NULL,
	Size NVARCHAR(20) NULL,
	AdwordsGrouping NVARCHAR(50) NULL,
	AdwordsLabels NVARCHAR(256) NULL,
	ExcludedDestination NVARCHAR(20) NULL,
	AdwordsRedirect NVARCHAR(256) NULL,
	PublishFeedAsVariants BIT DEFAULT 0 NOT NULL,
	TIC int NULL,
	EnableRestockNotifications BIT DEFAULT 0 NOT NULL,
	OrderBy DECIMAL(10,2) DEFAULT 0 NOT NULL,	
	RowVersion INT DEFAULT 1 NOT NULL,
	CONSTRAINT [ac_Products_PK] PRIMARY KEY CLUSTERED ([ProductId] ASC))  

GO

CREATE TABLE ac_ProductTemplateFields( 
	ProductTemplateFieldId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	InputFieldId INT NOT NULL,
	InputValue NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY(ProductTemplateFieldId))

GO

CREATE TABLE ac_ProductTemplates( 
	ProductTemplateId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	PRIMARY KEY(ProductTemplateId))

GO

CREATE TABLE ac_ProductVariants( 
	ProductVariantId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	Option1 INT NOT NULL,
	Option2 INT NOT NULL,
	Option3 INT NOT NULL,
	Option4 INT NOT NULL,
	Option5 INT NOT NULL,
	Option6 INT NOT NULL,
	Option7 INT NOT NULL,
	Option8 INT NOT NULL,
	VariantName NVARCHAR(500) NULL,
	Sku NVARCHAR(100) NULL,
	GTIN NVARCHAR(30) NULL,
	Price DECIMAL(12,4) NULL,
	MSRP DECIMAL(12,4) NULL,
	ModelNumber NVARCHAR(40) NULL,
	[Length] DECIMAL(12,4) NULL,
	Width DECIMAL(12,4) NULL,
	Height DECIMAL(12,4) NULL,
	HandlingCharges DECIMAL(10,2) NULL,
	PriceModeId TINYINT NOT NULL,
	[Weight] DECIMAL(12,4) NULL,
	WeightModeId TINYINT NOT NULL,
	CostOfGoods DECIMAL(12,4) NULL,
	InStock INT NOT NULL,
	AvailabilityDate DATETIME NULL,
	InStockWarningLevel INT NOT NULL,
	ImageUrl VARCHAR(255) NULL,
	ThumbnailUrl VARCHAR(255) NULL,
	IconUrl VARCHAR(255) NULL,
	Available BIT NOT NULL,
	RowVersion INT DEFAULT 1 NOT NULL,
	PRIMARY KEY(ProductVariantId))

GO

CREATE TABLE ac_ProductVolumeDiscounts( 
	ProductId INT NOT NULL,
	VolumeDiscountId INT NOT NULL,
	PRIMARY KEY(ProductId,VolumeDiscountId))

GO

CREATE TABLE ac_Provinces( 
	ProvinceId INT IDENTITY NOT NULL,
	CountryCode CHAR(2) NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	LoweredName NVARCHAR(50) NOT NULL,
	ProvinceCode NVARCHAR(10) NULL,
	PRIMARY KEY(ProvinceId))

GO

CREATE TABLE ac_Readmes( 
	ReadmeId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	DisplayName NVARCHAR(100) NOT NULL,
	ReadmeText NVARCHAR(MAX) NOT NULL,
	IsHTML BIT NOT NULL,
	PRIMARY KEY(ReadmeId))  

GO

CREATE TABLE ac_Redirects  (
	RedirectId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	SourceUrl  NVARCHAR(255) NOT NULL,
	LoweredSourceUrl  NVARCHAR(255) NOT NULL,
	TargetUrl NVARCHAR(255) NOT NULL,
	UseRegEx BIT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastVisitedDate DATETIME NULL,
	VisitCount INT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(RedirectId))
GO

CREATE TABLE ac_RelatedProducts (
	RelatedProductId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	ChildProductId INT NOT NULL,  
	PRIMARY KEY(RelatedProductId))
GO

CREATE TABLE ac_ReviewerProfiles( 
	ReviewerProfileId INT IDENTITY NOT NULL,
	Email NVARCHAR(255) NOT NULL,
	DisplayName NVARCHAR(100) NOT NULL,
	Location NVARCHAR(50) NULL,
	EmailVerified BIT NOT NULL,
	EmailVerificationCode UNIQUEIDENTIFIER NULL,
	PRIMARY KEY(ReviewerProfileId))

GO

CREATE TABLE ac_Roles(
	RoleId INT IDENTITY NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	LoweredName NVARCHAR(100) NOT NULL,
	PRIMARY KEY(RoleId))

GO

CREATE TABLE ac_SearchHistory(
	Id INT IDENTITY(1,1) NOT NULL,
	SearchTerm NVARCHAR(200) NOT NULL,
	UserId INT NULL,
	SearchDate DATETIME NOT NULL,
	PRIMARY KEY(Id))

GO

CREATE TABLE ac_SerialKeys( 
	SerialKeyId INT IDENTITY NOT NULL,
	DigitalGoodId INT NOT NULL,
	SerialKeyData NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY(SerialKeyId))

GO

CREATE TABLE ac_ShipGateways( 
	ShipGatewayId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	ClassId VARCHAR(255) NOT NULL,
	ConfigData NVARCHAR(MAX) NULL,
	ReCrypt BIT NOT NULL,
	[Enabled] BIT NOT NULL,
	PRIMARY KEY(ShipGatewayId))
GO

CREATE TABLE ac_ShipMethodGroups( 
	ShipMethodId INT NOT NULL,
	GroupId INT NOT NULL,
	PRIMARY KEY(GroupId, ShipMethodId))

GO

CREATE TABLE ac_ShipMethods( 
	ShipMethodId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	ShipMethodTypeId SMALLINT NOT NULL,
	Name NVARCHAR(255) NOT NULL,
	Surcharge DECIMAL(12,4) NOT NULL,
	ShipGatewayId INT NULL,
	ServiceCode NVARCHAR(255) NULL,
	MinPurchase DECIMAL(12,4) NOT NULL,
	MaxPurchase DECIMAL(12,4) NOT NULL,
	SurchargeIsVisible BIT NOT NULL,
	SurchargeModeId TINYINT NOT NULL,
	TaxCodeId INT NULL,
	SurchargeTaxCodeId INT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(ShipMethodId))

CREATE TABLE ac_ProductProductTemplates( 
	ProductId INT NOT NULL,
	ProductTemplateId INT NOT NULL,
	PRIMARY KEY(ProductId,ProductTemplateId))

GO

CREATE TABLE ac_ShipMethodShipZones( 
	ShipMethodId INT NOT NULL,
	ShipZoneId INT NOT NULL,
	PRIMARY KEY(ShipMethodId,ShipZoneId))

GO

CREATE TABLE ac_ShipMethodWarehouses( 
	ShipMethodId INT NOT NULL,
	WarehouseId INT NOT NULL,
	PRIMARY KEY(ShipMethodId, WarehouseId))

GO

CREATE TABLE ac_ShipRateMatrix ( 
	ShipRateMatrixId INT IDENTITY NOT NULL,
	ShipMethodId INT NOT NULL,
	RangeStart DECIMAL(12,4) NULL,
	RangeEnd DECIMAL(12,4) NULL,
	Rate DECIMAL(12,4) NOT NULL,
	IsPercent BIT DEFAULT 0 NOT NULL,
	PRIMARY KEY(ShipRateMatrixId))

GO

CREATE TABLE ac_ShipZoneCountries( 
	ShipZoneId INT NOT NULL,
	CountryCode CHAR(2) NOT NULL,
	PRIMARY KEY(ShipZoneId,CountryCode))

GO

CREATE TABLE ac_ShipZoneProvinces(
	ShipZoneId INT NOT NULL,
	ProvinceId INT NOT NULL,
	PRIMARY KEY(ProvinceId,ShipZoneId))

GO

CREATE TABLE ac_ShipZones( 
	ShipZoneId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(255) NOT NULL,
	CountryRuleId TINYINT NOT NULL,
	ProvinceRuleId TINYINT NOT NULL,
	PostalCodeFilter NVARCHAR(450) NULL,
	ExcludePostalCodeFilter NVARCHAR(500) NULL,
	UsePCPM BIT NOT NULL,
	PRIMARY KEY(ShipZoneId))

GO

CREATE TABLE ac_SpecialGroups( 
	SpecialId INT NOT NULL,
	GroupId INT NOT NULL,
	PRIMARY KEY(SpecialId, GroupId))

GO

CREATE TABLE ac_Specials( 
	SpecialId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	Price DECIMAL(12,4) NOT NULL,
	StartDate DATETIME NULL,
	EndDate DATETIME NULL,
	PRIMARY KEY(SpecialId))
GO

CREATE TABLE ac_Stores( 
	StoreId INT IDENTITY NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	ApplicationName NVARCHAR(255) NOT NULL,
	LoweredApplicationName NVARCHAR(255) NOT NULL,
	LicenseKey VARCHAR(MAX) NULL,
	DefaultWarehouseId INT NULL,
	NextOrderId INT DEFAULT 1 NOT NULL,
	OrderIdIncrement SMALLINT DEFAULT 1 NOT NULL,
	WeightUnitId SMALLINT NOT NULL,
	MeasurementUnitId SMALLINT NOT NULL,
	PRIMARY KEY(StoreId))

GO

CREATE TABLE ac_StoreSettings( 
	StoreSettingId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	FieldName NVARCHAR(255) NOT NULL,
	FieldValue NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY(StoreSettingId))

GO

CREATE TABLE ac_SubscriptionPlans( 
	ProductId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	NumberOfPayments SMALLINT NOT NULL,
	PaymentFrequency SMALLINT NOT NULL,
	PaymentFrequencyUnitId TINYINT NOT NULL,
	RecurringCharge DECIMAL(9,2) NOT NULL,
	RecurringChargeModeId TINYINT DEFAULT 2 NOT NULL,
	RecurringChargeSpecified BIT NOT NULL,
	GroupId INT NULL,
	TaxCodeId INT NULL,
	IsOptional BIT DEFAULT 0 NOT NULL,
	Description NVARCHAR(255) NULL,
	OneTimeCharge DECIMAL(9,2) NULL,
	OneTimeChargeModeId TINYINT NOT NULL,
	OptionalPaymentFrequencies NVARCHAR(255) NULL,
	PaymentFrequencyTypeId TINYINT NULL,
	RepeatDiscounts BIT DEFAULT 0 NOT NULL,
	OneTimeChargeTaxCodeId INT NULL,
	PRIMARY KEY(ProductId))

GO

CREATE TABLE ac_Subscriptions( 
	SubscriptionId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	Quantity SMALLINT NOT NULL,
	NumberOfPayments SMALLINT NOT NULL,
	UserId INT NOT NULL,
	OrderItemId INT NULL,
	TransactionId INT NULL,
	IsActive BIT NOT NULL,
	ExpirationDate DATETIME NULL,
	ExpirationAlertDate DATETIME NULL,
	ExpiredAlertDate DATETIME NULL,
	NextOrderDueDate DATETIME NULL,
	LastOrderDueDate DATETIME NULL,
	GroupId INT NULL,
	PaymentFrequency SMALLINT NULL,
	PaymentFrequencyUnitId TINYINT NULL,
	BasePrice DECIMAL(9,2) NOT NULL,
	BaseTaxCodeId INT NULL,
	RecurringCharge DECIMAL(9,2) NOT NULL,
	RecurringChargeModeId TINYINT DEFAULT 2 NOT NULL,
	RecurringChargeSpecified BIT NOT NULL,
	RecurringTaxCodeId INT NULL,
	RepeatDiscounts BIT DEFAULT 0 NOT NULL,
	IsLegacy BIT DEFAULT 1 NOT NULL,
	PaymentProcessingTypeId SMALLINT NOT NULL DEFAULT 0,
	PaymentMethodId INT NULL,
	GatewayPaymentProfileId INT NULL,
	ProcessingStatusId SMALLINT NOT NULL DEFAULT 0,
	ProcessingStatusMessage NVARCHAR(256) NULL,
	BillToFirstName NVARCHAR(30) NULL,
	BillToLastName NVARCHAR(50) NULL,
	BillToCompany NVARCHAR(50) NULL,
	BillToAddress1 NVARCHAR(255) NULL,
	BillToAddress2 NVARCHAR(255) NULL,
	BillToCity NVARCHAR(50) NULL,
	BillToProvince NVARCHAR(50) NULL,
	BillToPostalCode NVARCHAR(15) NULL,
	BillToCountryCode CHAR(2) NULL,
	BillToPhone NVARCHAR(50) NULL,
	BillToFax NVARCHAR(50) NULL,
	BillToEmail NVARCHAR(255) NULL,
	BillToResidence BIT DEFAULT 0 NOT NULL,
	ShipToFirstName NVARCHAR(30) NULL,
	ShipToLastName NVARCHAR(50) NULL,
	ShipToCompany NVARCHAR(50) NULL,
	ShipToAddress1 NVARCHAR(255) NULL,
	ShipToAddress2 NVARCHAR(255) NULL,
	ShipToCity NVARCHAR(50) NULL,
	ShipToProvince NVARCHAR(50) NULL,
	ShipToPostalCode NVARCHAR(15) NULL,
	ShipToCountryCode CHAR(2) NULL,
	ShipToPhone NVARCHAR(50) NULL,
	ShipToFax NVARCHAR(50) NULL,
	ShipToEmail NVARCHAR(255) NULL,
	ShipToResidence BIT DEFAULT 0 NOT NULL
	PRIMARY KEY(SubscriptionId))   

GO

CREATE TABLE ac_TaxCodes( 
	TaxCodeId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	PRIMARY KEY(TaxCodeId))

GO

CREATE TABLE ac_TaxGateways( 
	TaxGatewayId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	ClassId VARCHAR(255) NOT NULL,
	ConfigData NVARCHAR(MAX) NULL,
	ReCrypt BIT NOT NULL,
	PRIMARY KEY(TaxGatewayId))

GO

CREATE TABLE ac_TaxRuleGroups( 
	TaxRuleId INT NOT NULL,
	GroupId INT NOT NULL,
	PRIMARY KEY(TaxRuleId,GroupId))

GO

CREATE TABLE ac_TaxRules( 
	TaxRuleId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	TaxRate DECIMAL(9,4) NOT NULL,
	UseBillingAddress BIT NOT NULL,
	GroupRuleId TINYINT NOT NULL,
	TaxCodeId INT NULL,
	Priority SMALLINT NOT NULL,
	RoundingRuleId TINYINT NOT NULL,
	UsePerItemTax BIT NOT NULL,
	PRIMARY KEY(TaxRuleId))
GO

CREATE TABLE ac_TaxRuleShipZones(
	TaxRuleId INT NOT NULL,
	ShipZoneId INT NOT NULL,
	PRIMARY KEY(TaxRuleId,ShipZoneId))  

GO

CREATE TABLE ac_TaxRuleTaxCodes( 
	TaxRuleId INT NOT NULL,
	TaxCodeId INT NOT NULL,
	PRIMARY KEY(TaxRuleId,TaxCodeId))

GO

CREATE TABLE ac_TrackingNumbers( 
	TrackingNumberId INT IDENTITY NOT NULL,
	OrderShipmentId INT NOT NULL,
	ShipGatewayId INT NULL,
	TrackingNumberData NVARCHAR(100) NOT NULL,
	PRIMARY KEY(TrackingNumberId))

GO

CREATE TABLE ac_LabelImages( 
	LabelImageId INT IDENTITY NOT NULL,
	OrderShipmentId INT NOT NULL,
	ShipGatewayId INT NULL,
	LabelImageData VARCHAR(MAX) NOT NULL,
	PRIMARY KEY(LabelImageId))

GO

CREATE TABLE ac_Transactions( 
	TransactionId INT IDENTITY NOT NULL,
	TransactionTypeId SMALLINT NOT NULL,
	PaymentId INT NOT NULL,
	PaymentGatewayId INT NULL,
	ProviderTransactionId NVARCHAR(50) NULL,
	TransactionDate DATETIME NOT NULL,
	Amount DECIMAL(12,4) NOT NULL,
	TransactionStatusId SMALLINT NOT NULL,
	ResponseCode NVARCHAR(50) NULL,
	ResponseMessage NVARCHAR(255) NULL,
	AuthorizationCode NVARCHAR(255) NULL,
	AVSResultCode VARCHAR(16) NULL,
	CVVResultCode VARCHAR(16) NULL,
	CAVResultCode VARCHAR(16) NULL,
	RemoteIP VARCHAR(39) NULL,
	Referrer NVARCHAR(255) NULL,
	AdditionalData NVARCHAR(255) NULL,
	PRIMARY KEY(TransactionId))

GO

CREATE TABLE ac_UpsellProducts (
	UpsellProductId INT IDENTITY NOT NULL, 
	ProductId INT NOT NULL,
	ChildProductId INT NOT NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(UpsellProductId))
GO

CREATE TABLE ac_UserGroups(
	UserGroupId INT IDENTITY NOT NULL, 
	UserId INT NOT NULL,
	GroupId INT NOT NULL,
	SubscriptionId INT NULL,
	PRIMARY KEY(UserGroupId))  

GO

CREATE TABLE ac_UserPasswords(
	UserPasswordId INT IDENTITY NOT NULL, 
	UserId INT NOT NULL,
	PasswordNumber TINYINT NOT NULL,
	[Password] NVARCHAR(255) NOT NULL,
	PasswordFormat NVARCHAR(10) NULL,
	CreateDate DATETIME NOT NULL,
	ForceExpiration BIT NOT NULL,
	PRIMARY KEY(UserPasswordId))

GO
  
CREATE TABLE ac_Users( 
	UserId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	UserName NVARCHAR(255) NOT NULL,
	LoweredUserName NVARCHAR(255) NOT NULL,
	Email NVARCHAR(255) NULL,
	LoweredEmail NVARCHAR(255) NULL,
	AffiliateId INT NULL,
	AffiliateReferralDate DATETIME NULL,
	PrimaryWishlistId INT NULL,
	PayPalId NVARCHAR(50) NULL,
	PasswordQuestion NVARCHAR(255) NULL,
	PasswordAnswer NVARCHAR(255) NULL,
	IsApproved BIT NOT NULL,
	IsAnonymous BIT NOT NULL,
	IsLockedOut BIT NOT NULL,
	CreateDate DATETIME NOT NULL,
	LastActivityDate DATETIME NULL,
	LastLoginDate DATETIME NULL,
	LastPasswordChangedDate DATETIME NULL,
	LastLockoutDate DATETIME NULL,
	FailedPasswordAttemptCount INT NOT NULL,
	FailedPasswordAttemptWindowStart DATETIME NULL,
	FailedPasswordAnswerAttemptCount INT NOT NULL,
	FailedPasswordAnswerAttemptWindowStart DATETIME NULL,
	TaxExemptionType INT NOT NULL,
	TaxExemptionReference NVARCHAR(200) NULL,
	Comment NVARCHAR(MAX) NULL,
	CONSTRAINT [ac_Users_PK] PRIMARY KEY CLUSTERED ([UserId] ASC))
GO

CREATE TABLE ac_UserSettings( 
	UserSettingId INT IDENTITY NOT NULL,
	UserId INT NOT NULL,
	FieldName NVARCHAR(255) NOT NULL,
	FieldValue NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY(UserSettingId))   

GO

CREATE TABLE ac_VendorGroups( 
	VendorId INT NOT NULL,
	GroupId INT NOT NULL,
	PRIMARY KEY(GroupId,VendorId))

GO

CREATE TABLE ac_Vendors( 
	VendorId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	Email NVARCHAR(255) NULL,
	PRIMARY KEY(VendorId))   

GO

CREATE TABLE ac_VolumeDiscountGroups( 
	VolumeDiscountId INT NOT NULL,
	GroupId INT NOT NULL,
	PRIMARY KEY(GroupId,VolumeDiscountId))   

GO

CREATE TABLE ac_VolumeDiscountLevels( 
	VolumeDiscountLevelId INT IDENTITY NOT NULL,
	VolumeDiscountId INT NOT NULL,
	MinValue DECIMAL(12,4) NOT NULL,
	MaxValue DECIMAL(12,4) NOT NULL,
	DiscountAmount DECIMAL(12,4) NOT NULL,
	IsPercent BIT NOT NULL,
	PRIMARY KEY(VolumeDiscountLevelId))   

GO

CREATE TABLE ac_VolumeDiscounts( 
	VolumeDiscountId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	IsValueBased BIT NOT NULL,
	IsGlobal BIT NOT NULL,
	PRIMARY KEY(VolumeDiscountId))   

GO

CREATE TABLE ac_Warehouses( 
	WarehouseId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	Address1 NVARCHAR(255) NULL,
	Address2 NVARCHAR(255) NULL,
	City NVARCHAR(50) NULL,
	Province NVARCHAR(50) NULL,
	PostalCode NVARCHAR(15) NULL,
	CountryCode CHAR(2) NULL,
	Phone NVARCHAR(50) NULL,
	Fax NVARCHAR(50) NULL,
	Email NVARCHAR(255) NULL,
	PRIMARY KEY(WarehouseId))   
GO

CREATE TABLE ac_Webpages( 
	WebpageId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(100) NULL,
	Summary NVARCHAR(MAX) NULL,
	[Description] NVARCHAR(MAX) NULL,
	ThumbnailUrl VARCHAR(255) NULL,
	ThumbnailAltText NVARCHAR(255) NULL,
	Layout VARCHAR(100) NULL,
	Theme VARCHAR(100) NULL,
	VisibilityId TINYINT NOT NULL,
	WebpageTypeId TINYINT NOT NULL,
	Title NVARCHAR(100) NULL,
	HtmlHead NVARCHAR(MAX) NULL,
	MetaDescription NVARCHAR(1000) NULL,
	MetaKeywords NVARCHAR(1000) NULL,
	PublishedBy NVARCHAR(150) NULL,
	PublishDate DATETIME NULL,
	PRIMARY KEY(WebpageId))   

GO

CREATE TABLE ac_WishlistItemInputs( 
	WishlistItemInputId INT IDENTITY NOT NULL,
	WishlistItemId INT NOT NULL,
	InputFieldId INT NOT NULL,
	InputValue NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY(WishlistItemInputId))   

GO

CREATE TABLE ac_WishlistItems(
	WishlistItemId INT IDENTITY NOT NULL,
	WishlistId INT NOT NULL,
	ProductId INT NOT NULL,
	OptionList VARCHAR(500) NULL,
	KitList VARCHAR(500) NULL,
	Price DECIMAL(12,4) NULL,
	LineMessage NVARCHAR(500) NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	Desired SMALLINT NOT NULL,
	Received SMALLINT NOT NULL,
	Priority TINYINT NOT NULL,
	IsSubscription BIT DEFAULT 0 NOT NULL,
	Frequency SMALLINT DEFAULT 0 NOT NULL,
	FrequencyUnitId TINYINT DEFAULT 0 NOT NULL,
	Comment NVARCHAR(MAX) NULL,
	PRIMARY KEY(WishlistItemId)) 

GO

CREATE TABLE ac_Wishlists( 
	WishlistId INT IDENTITY NOT NULL,
	UserId INT NOT NULL,
	Name NVARCHAR(50) NULL,
	ViewPassword NVARCHAR(50) NULL,
	IsPublic BIT DEFAULT 0 NOT NULL,
	ViewCode UNIQUEIDENTIFIER DEFAULT newsequentialid() NOT NULL,
	PRIMARY KEY(WishlistId)) 

GO

CREATE TABLE ac_WrapGroups( 
	WrapGroupId INT IDENTITY NOT NULL,
	StoreId INT NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	PRIMARY KEY(WrapGroupId))   

GO
  
CREATE TABLE ac_WrapStyles( 
	WrapStyleId INT IDENTITY NOT NULL,
	WrapGroupId INT NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	TaxCodeId INT NULL,
	Price DECIMAL(12,4) NOT NULL,
	ThumbnailUrl VARCHAR(255) NULL,
	ImageUrl VARCHAR(255) NULL,
	OrderBy SMALLINT DEFAULT 0 NOT NULL,
	PRIMARY KEY(WrapStyleId))   

GO

 CREATE TABLE ac_ReviewReminders(
	ReviewReminderId int IDENTITY(1,1) NOT NULL,
	UserId int NOT NULL,
	ProductId int NOT NULL,
	PRIMARY KEY(ReviewReminderId))

GO

CREATE TABLE ac_ProductGroups(
	ProductGroupId int IDENTITY(1,1) NOT NULL,
	ProductId int NOT NULL,
	GroupId int NOT NULL,
	PRIMARY KEY(ProductGroupId))

GO

CREATE TABLE ac_SubscriptionOrders(
	SubscriptionOrderId int IDENTITY(1,1) NOT NULL,
	SubscriptionId int NOT NULL,
	OrderId int NOT NULL,
	IsPrimary BIT DEFAULT 0 NOT NULL,
	OrderDueDate DATETIME NOT NULL,
	PaymentAlertDate DATETIME NULL,
	PRIMARY KEY(SubscriptionOrderId))
GO

CREATE TABLE ac_GatewayPaymentProfiles(
	GatewayPaymentProfileId int IDENTITY(1,1) NOT NULL,
	UserId int NOT NULL,
	NameOnCard nvarchar(255) NULL,
	GatewayIdentifier nvarchar(255) NULL,
	CustomerProfileId nvarchar(255) NULL,
	PaymentProfileId nvarchar(255) NULL,
	ReferenceNumber nvarchar(255) NULL,
	PaymentMethodName nvarchar(255) NULL,
	InstrumentTypeId SMALLINT DEFAULT 0 NOT NULL, 
	Expiry DATETIME NULL,
	PRIMARY KEY(GatewayPaymentProfileId))
GO

CREATE TABLE ac_RestockNotify ( 
	RestockNotifyId INT IDENTITY NOT NULL,
	ProductId INT NOT NULL,
	ProductVariantId INT NULL,
	Email NVARCHAR(255) NOT NULL,
	LastSentDate DATETIME NULL,
	PRIMARY KEY(RestockNotifyId)) 
GO

/*------------------------------ FOREIGN KEY CONSTRAINTS ---------------------------------*/

ALTER TABLE ac_Redirects
	ADD CONSTRAINT ac_Stores_ac_Redirects_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_CustomUrls
	ADD CONSTRAINT ac_CustomUrls_ac_Stores_FK FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE CASCADE
   
GO

CREATE INDEX ac_ShipZones_IX1 ON ac_ShipZones (
	PostalCodeFilter)  

GO


ALTER TABLE ac_ProductProductTemplates
	ADD CONSTRAINT ac_Products_ac_ProductProductTemplates_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ProductProductTemplates
	ADD CONSTRAINT ac_ProductTemplates_ac_ProductProductTemplates_FK1 FOREIGN KEY (
		ProductTemplateId)
	 REFERENCES ac_ProductTemplates (
		ProductTemplateId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Kits
	ADD CONSTRAINT ac_Products_ac_Kits_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_TaxRuleGroups
	ADD CONSTRAINT ac_TaxRules_ac_TaxRuleGroups_FK1 FOREIGN KEY (
		TaxRuleId)
	 REFERENCES ac_TaxRules (
		TaxRuleId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_TaxRuleGroups
	ADD CONSTRAINT ac_Groups_ac_TaxRuleGroups_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_TaxRuleShipZones
	ADD CONSTRAINT ac_ShipZones_ac_TaxRuleShipZones_FK1 FOREIGN KEY (
		ShipZoneId)
	 REFERENCES ac_ShipZones (
		ShipZoneId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_TaxRuleShipZones
	ADD CONSTRAINT ac_TaxRules_ac_TaxRuleShipZones_FK1 FOREIGN KEY (
		TaxRuleId)
	 REFERENCES ac_TaxRules (
		TaxRuleId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ProductCustomFields
	ADD CONSTRAINT ac_Products_ac_ProductCustomFields_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ProductOptions
	ADD CONSTRAINT ac_Products_ac_ProductOptions_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ProductOptions
	ADD CONSTRAINT ac_Options_ac_ProductOptions_FK1 FOREIGN KEY (
		OptionId)
	 REFERENCES ac_Options (
		OptionId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ProductDigitalGoods
	ADD CONSTRAINT ac_Products_ac_DigitalGoods_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ProductDigitalGoods
	ADD CONSTRAINT ac_DigitalGoods_ac_ProductDigitalGoods_FK1 FOREIGN KEY (
		DigitalGoodId)
	 REFERENCES ac_DigitalGoods (
		DigitalGoodId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_GroupRoles
	ADD CONSTRAINT ac_Groups_ac_GroupRoles_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_GroupRoles
	ADD CONSTRAINT ac_Roles_ac_GroupRoles_FK1 FOREIGN KEY (
		RoleId)
	 REFERENCES ac_Roles (
		RoleId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_RelatedProducts
	ADD CONSTRAINT ac_Products_ac_RelatedProducts_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_RelatedProducts
	ADD CONSTRAINT ac_Products_ac_RelatedProducts_FK2 FOREIGN KEY (
		ChildProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_ErrorMessages
	ADD CONSTRAINT ac_Stores_ac_ErrorMessages_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Subscriptions
	ADD CONSTRAINT ac_Users_ac_Subscriptions_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Subscriptions
	ADD CONSTRAINT ac_SubscriptionPlans_ac_Subscriptions_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_SubscriptionPlans (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_Subscriptions
	ADD CONSTRAINT ac_OrderItems_ac_Subscriptions_FK1 FOREIGN KEY (
		OrderItemId)
	 REFERENCES ac_OrderItems (
		OrderItemId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Subscriptions
	ADD CONSTRAINT ac_Transactions_ac_Subscriptions_FK1 FOREIGN KEY (
		TransactionId)
	 REFERENCES ac_Transactions (
		TransactionId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_SubscriptionPlans
	ADD CONSTRAINT ac_Products_ac_SubscriptionPlans_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_SubscriptionPlans
	ADD CONSTRAINT ac_Groups_ac_SubscriptionPlans_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_SubscriptionPlans
	ADD CONSTRAINT ac_TaxCodes_ac_SubscriptionPlans_FK1 FOREIGN KEY (
		TaxCodeId)
	 REFERENCES ac_TaxCodes (
		TaxCodeId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_WrapStyles
	ADD CONSTRAINT ac_TaxCodes_ac_WrapStyles_FK1 FOREIGN KEY (
		TaxCodeId)
	 REFERENCES ac_TaxCodes (
		TaxCodeId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_WrapStyles
	ADD CONSTRAINT ac_WrapGroups_ac_WrapStyles_FK1 FOREIGN KEY (
		WrapGroupId)
	 REFERENCES ac_WrapGroups (
		WrapGroupId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_WrapGroups
	ADD CONSTRAINT ac_Stores_ac_WrapGroups_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Wishlists
	ADD CONSTRAINT ac_Users_ac_Wishlists_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_WishlistItems
	ADD CONSTRAINT ac_Products_ac_WishlistItems_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_WishlistItems
	ADD CONSTRAINT ac_Wishlists_ac_WishlistItems_FK1 FOREIGN KEY (
		WishlistId)
	 REFERENCES ac_Wishlists (
		WishlistId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_WishlistItemInputs
	ADD CONSTRAINT ac_InputFields_ac_WishlistItemInputs_FK1 FOREIGN KEY (
		InputFieldId)
	 REFERENCES ac_InputFields (
		InputFieldId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_WishlistItemInputs
	ADD CONSTRAINT ac_WishlistItems_ac_WishlistItemInputs_FK1 FOREIGN KEY (
		WishlistItemId)
	 REFERENCES ac_WishlistItems (
		WishlistItemId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Webpages
	ADD CONSTRAINT ac_Stores_ac_Webpages_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Warehouses
	ADD CONSTRAINT ac_Countries_ac_Warehouses_FK1 FOREIGN KEY (
		CountryCode)
	 REFERENCES ac_Countries (
		CountryCode) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Warehouses
	ADD CONSTRAINT ac_Stores_ac_Warehouses_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_VolumeDiscounts
	ADD CONSTRAINT ac_Stores_ac_Discounts_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_VolumeDiscountGroups
	ADD CONSTRAINT ac_Groups_ac_VolumeDiscountGroups_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_VolumeDiscountGroups
	ADD CONSTRAINT ac_VolumeDiscounts_ac_VolumeDiscountGroups_FK1 FOREIGN KEY (
		VolumeDiscountId)
	 REFERENCES ac_VolumeDiscounts (
		VolumeDiscountId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_VolumeDiscountLevels
	ADD CONSTRAINT ac_Discounts_ac_DiscountMatrix_FK1 FOREIGN KEY (
		VolumeDiscountId)
	 REFERENCES ac_VolumeDiscounts (
		VolumeDiscountId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Vendors
	ADD CONSTRAINT ac_Stores_ac_Vendors_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_UserSettings
	ADD CONSTRAINT ac_Users_ac_UserSettings_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Users
	ADD CONSTRAINT ac_Affiliates_ac_Users_FK1 FOREIGN KEY (
		AffiliateId)
	 REFERENCES ac_Affiliates (
		AffiliateId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Users
	ADD CONSTRAINT ac_Stores_ac_Users_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_UserGroups
	ADD CONSTRAINT ac_Groups_ac_UserGroups_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_UserGroups
	ADD CONSTRAINT ac_Users_ac_UserGroups_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_UserGroups
	ADD CONSTRAINT ac_Subscriptions_ac_UserGroups_FK1 FOREIGN KEY (
		SubscriptionId)
	 REFERENCES ac_Subscriptions (
		SubscriptionId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_UserPasswords
	ADD CONSTRAINT ac_Users_ac_UserPasswords_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Transactions
	ADD CONSTRAINT ac_PaymentGateways_ac_Transactions_FK1 FOREIGN KEY (
		PaymentGatewayId)
	 REFERENCES ac_PaymentGateways (
		PaymentGatewayId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Transactions
	ADD CONSTRAINT ac_Payments_ac_Transactions_FK1 FOREIGN KEY (
		PaymentId)
	 REFERENCES ac_Payments (
		PaymentId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_TrackingNumbers
	ADD CONSTRAINT ac_Shipments_ac_Tracking_FK1 FOREIGN KEY (
		OrderShipmentId)
	 REFERENCES ac_OrderShipments (
		OrderShipmentId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_TrackingNumbers
	ADD CONSTRAINT ac_ShipGateways_ac_Tracking_FK1 FOREIGN KEY (
		ShipGatewayId)
	 REFERENCES ac_ShipGateways (
		ShipGatewayId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_LabelImages
	ADD CONSTRAINT ac_Shipments_ac_LabelImages_FK1 FOREIGN KEY (
		OrderShipmentId)
	 REFERENCES ac_OrderShipments (
		OrderShipmentId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_LabelImages
	ADD CONSTRAINT ac_ShipGateways_ac_LabelImages_FK1 FOREIGN KEY (
		ShipGatewayId)
	 REFERENCES ac_ShipGateways (
		ShipGatewayId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_TaxRuleTaxCodes
	ADD CONSTRAINT ac_TaxCodes_ac_TaxRuleTaxCodeAssn_FK1 FOREIGN KEY (
		TaxCodeId)
	 REFERENCES ac_TaxCodes (
		TaxCodeId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_TaxRuleTaxCodes
	ADD CONSTRAINT ac_TaxRules_ac_TaxRuleTaxCodeAssn_FK1 FOREIGN KEY (
		TaxRuleId)
	 REFERENCES ac_TaxRules (
		TaxRuleId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_TaxRules
	ADD CONSTRAINT ac_Stores_ac_TaxRules_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_TaxGateways
	ADD CONSTRAINT ac_Stores_ac_TaxGateways_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_TaxCodes
	ADD CONSTRAINT ac_Stores_ac_TaxCodes_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_StoreSettings
	ADD CONSTRAINT ac_Stores_ac_StoreSettings_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Specials
	ADD CONSTRAINT ac_Products_ac_Specials_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId)  

GO


ALTER TABLE ac_Specials nocheck constraint ac_Products_ac_Specials_FK1 

GO


ALTER TABLE ac_SpecialGroups
	ADD CONSTRAINT ac_Groups_ac_SpecialGroups_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_SpecialGroups
	ADD CONSTRAINT ac_Specials_ac_SpecialGroups_FK1 FOREIGN KEY (
		SpecialId)
	 REFERENCES ac_Specials (
		SpecialId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ShipZones
	ADD CONSTRAINT ac_Stores_ac_ShipZones_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_ShipZoneProvinces
	ADD CONSTRAINT ac_Provinces_ac_ShipZoneProvinces_FK1 FOREIGN KEY (
		ProvinceId)
	 REFERENCES ac_Provinces (
		ProvinceId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ShipZoneProvinces
	ADD CONSTRAINT ac_ShipZones_ac_ShipZoneProvinces_FK1 FOREIGN KEY (
		ShipZoneId)
	 REFERENCES ac_ShipZones (
		ShipZoneId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ShipZoneCountries
	ADD CONSTRAINT ac_Countries_ac_ShipZoneCountries_FK1 FOREIGN KEY (
		CountryCode)
	 REFERENCES ac_Countries (
		CountryCode) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ShipZoneCountries
	ADD CONSTRAINT ac_ShipZones_ac_ShipZoneCountries_FK1 FOREIGN KEY (
		ShipZoneId)
	 REFERENCES ac_ShipZones (
		ShipZoneId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ShipRateMatrix
	ADD CONSTRAINT ac_ShipMethods_ac_ShipMatrix_FK1 FOREIGN KEY (
		ShipMethodId)
	 REFERENCES ac_ShipMethods (
		ShipMethodId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ShipMethodWarehouses
	ADD CONSTRAINT ac_ShipMethods_ac_ShipMethodWarehouses_FK1 FOREIGN KEY (
		ShipMethodId)
	 REFERENCES ac_ShipMethods (
		ShipMethodId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ShipMethodWarehouses
	ADD CONSTRAINT ac_Warehouses_ac_ShipMethodWarehouses_FK1 FOREIGN KEY (
		WarehouseId)
	 REFERENCES ac_Warehouses (
		WarehouseId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ShipMethodShipZones
	ADD CONSTRAINT ac_ShipMethods_ac_ShipMethodShipZones_FK1 FOREIGN KEY (
		ShipMethodId)
	 REFERENCES ac_ShipMethods (
		ShipMethodId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ShipMethodShipZones
	ADD CONSTRAINT ac_ShipZones_ac_ShipMethodShipZones_FK1 FOREIGN KEY (
		ShipZoneId)
	 REFERENCES ac_ShipZones (
		ShipZoneId) ON UPDATE NO ACTION ON DELETE CASCADE 

GO


ALTER TABLE ac_ShipMethods
	ADD CONSTRAINT ac_ShipGateways_ac_ShipMethods_FK1 FOREIGN KEY (
		ShipGatewayId)
	 REFERENCES ac_ShipGateways (
		ShipGatewayId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ShipMethods
	ADD CONSTRAINT ac_Stores_ac_ShipMethods_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_ShipMethods
	ADD CONSTRAINT ac_TaxCodes_ac_ShipMethods_FK1 FOREIGN KEY (
		TaxCodeId)
	 REFERENCES ac_TaxCodes (
		TaxCodeId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_ShipMethodGroups
	ADD CONSTRAINT ac_Groups_ac_ShipMethodGroups_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_ShipMethodGroups
	ADD CONSTRAINT ac_ShipMethods_ac_ShipMethodGroups_FK1 FOREIGN KEY (
		ShipMethodId)
	 REFERENCES ac_ShipMethods (
		ShipMethodId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_ShipGateways
	ADD CONSTRAINT ac_Stores_ac_ShipGateways_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_VendorGroups
	ADD CONSTRAINT ac_Groups_ac_VendorGroups_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_VendorGroups
	ADD CONSTRAINT ac_Vendors_ac_VendorGroups_FK1 FOREIGN KEY (
		VendorId)
	 REFERENCES ac_Vendors (
		VendorId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Groups
	ADD CONSTRAINT ac_Stores_ac_Groups_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Readmes
	ADD CONSTRAINT ac_Stores_ac_Readmes_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Provinces
	ADD CONSTRAINT ac_Countries_ac_Provinces_FK1 FOREIGN KEY (
		CountryCode)
	 REFERENCES ac_Countries (
		CountryCode) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ProductVolumeDiscounts
	ADD CONSTRAINT ac_Products_ac_ProductDiscountAssn_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ProductVolumeDiscounts
	ADD CONSTRAINT ac_Discounts_ac_ProductDiscountAssn_FK1 FOREIGN KEY (
		VolumeDiscountId)
	 REFERENCES ac_VolumeDiscounts (
		VolumeDiscountId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ProductVariants
	ADD CONSTRAINT ac_Products_ac_ProductVariations_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_ProductTemplates
	ADD CONSTRAINT ac_Stores_ac_ProductTemplates_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Products
	ADD CONSTRAINT ac_Manufacturers_ac_Products_FK1 FOREIGN KEY (
		ManufacturerId)
	 REFERENCES ac_Manufacturers (
		ManufacturerId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Products
	ADD CONSTRAINT ac_Stores_ac_Products_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_Products
	ADD CONSTRAINT ac_Webpages_ac_Products_FK1 FOREIGN KEY (
		WebpageId)
	 REFERENCES ac_Webpages (
		WebpageId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Products
	ADD CONSTRAINT ac_TaxCodes_ac_Products_FK1 FOREIGN KEY (
		TaxCodeId)
	 REFERENCES ac_TaxCodes (
		TaxCodeId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Products
	ADD CONSTRAINT ac_Vendors_ac_Products_FK1 FOREIGN KEY (
		VendorId)
	 REFERENCES ac_Vendors (
		VendorId) ON UPDATE NO ACTION ON DELETE SET NULL

GO

ALTER TABLE ac_Products
	ADD CONSTRAINT ac_Warehouses_ac_Products_FK1 FOREIGN KEY (
		WarehouseId)
	 REFERENCES ac_Warehouses (
		WarehouseId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_Products
	ADD CONSTRAINT ac_WrapGroups_ac_Products_FK1 FOREIGN KEY (
		WrapGroupId)
	 REFERENCES ac_WrapGroups (
		WrapGroupId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_ProductReviews
	ADD CONSTRAINT ac_Products_ac_ProductReviews_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_ProductReviews
	ADD CONSTRAINT ac_ReviewerProfiles_ac_ProductReviews_FK1 FOREIGN KEY (
		ReviewerProfileId)
	 REFERENCES ac_ReviewerProfiles (
		ReviewerProfileId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ProductKitComponents
	ADD CONSTRAINT ac_KitComponents_ac_ProductKitComponents_FK1 FOREIGN KEY (
		KitComponentId)
	 REFERENCES ac_KitComponents (
		KitComponentId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ProductKitComponents
	ADD CONSTRAINT ac_Products_ac_ProductKitComponents_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ProductImages
	ADD CONSTRAINT ac_Products_ac_ProductImages_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ProductTemplateFields
	ADD CONSTRAINT ac_InputFields_ac_ProductTemplateFields_FK1 FOREIGN KEY (
		InputFieldId)
	 REFERENCES ac_InputFields (
		InputFieldId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_ProductTemplateFields
	ADD CONSTRAINT ac_Products_ac_ProductTemplateFields_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_ProductAssets
	ADD CONSTRAINT ac_Products_ac_ProductAssets_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Payments
	ADD CONSTRAINT ac_Orders_ac_Payments_FK1 FOREIGN KEY (
		OrderId)
	 REFERENCES ac_Orders (
		OrderId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_Payments
	ADD CONSTRAINT ac_PaymentMethods_ac_Payments_FK1 FOREIGN KEY (
		PaymentMethodId)
	 REFERENCES ac_PaymentMethods (
		PaymentMethodId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Payments
	ADD CONSTRAINT ac_Subscriptions_ac_Payments_FK1 FOREIGN KEY (
		SubscriptionId)
	 REFERENCES ac_Subscriptions (
		SubscriptionId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_PaymentMethods
	ADD CONSTRAINT ac_PaymentGateways_ac_PaymentMethods_FK1 FOREIGN KEY (
		PaymentGatewayId)
	 REFERENCES ac_PaymentGateways (
		PaymentGatewayId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_PaymentMethods
	ADD CONSTRAINT ac_Stores_ac_PaymentMethods_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_PaymentMethodGroups
	ADD CONSTRAINT ac_PaymentMethods_ac_PaymentMethodsGroups_FK1 FOREIGN KEY (
		PaymentMethodId)
	 REFERENCES ac_PaymentMethods (
		PaymentMethodId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_PaymentMethodGroups
	ADD CONSTRAINT ac_Groups_ac_PaymentMethodGroups_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_PaymentGateways
	ADD CONSTRAINT ac_Stores_ac_PaymentGateways_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_PageViews
	ADD CONSTRAINT ac_Stores_ac_PageViews_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_PageViews
	ADD CONSTRAINT ac_Users_ac_PageViews_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId)  

GO


ALTER TABLE ac_PageViews nocheck constraint ac_Users_ac_PageViews_FK1 

GO


ALTER TABLE ac_OrderStatusTriggers
	ADD CONSTRAINT ac_OrderStatuses_ac_OrderStatusTriggers_FK1 FOREIGN KEY (
		OrderStatusId)
	 REFERENCES ac_OrderStatuses (
		OrderStatusId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_OrderStatuses
	ADD CONSTRAINT ac_Stores_ac_OrderStatuses_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_OrderStatusEmails
	ADD CONSTRAINT ac_Emails_ac_OrderStatusEmails_FK1 FOREIGN KEY (
		EmailTemplateId)
	 REFERENCES ac_EmailTemplates (
		EmailTemplateId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_OrderStatusEmails
	ADD CONSTRAINT ac_OrderStatuses_ac_OrderStatusEmails_FK1 FOREIGN KEY (
		OrderStatusId)
	 REFERENCES ac_OrderStatuses (
		OrderStatusId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_OrderStatusActions
	ADD CONSTRAINT ac_OrderStatuses_ac_OrderStatusActions_FK1 FOREIGN KEY (
		OrderStatusId)
	 REFERENCES ac_OrderStatuses (
		OrderStatusId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_OrderShipments
	ADD CONSTRAINT ac_Orders_ac_Shipments_FK1 FOREIGN KEY (
		OrderId)
	 REFERENCES ac_Orders (
		OrderId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_OrderShipments
	ADD CONSTRAINT ac_ShipMethods_ac_OrderShipments_FK1 FOREIGN KEY (
		ShipMethodId)
	 REFERENCES ac_ShipMethods (
		ShipMethodId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_OrderShipments
	ADD CONSTRAINT ac_Warehouses_ac_Shipments_FK1 FOREIGN KEY (
		WarehouseId)
	 REFERENCES ac_Warehouses (
		WarehouseId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_Orders
	ADD CONSTRAINT ac_Affiliates_ac_Orders_FK1 FOREIGN KEY (
		AffiliateId)
	 REFERENCES ac_Affiliates (
		AffiliateId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Orders
	ADD CONSTRAINT ac_OrderStatuses_ac_Orders_FK1 FOREIGN KEY (
		OrderStatusId)
	 REFERENCES ac_OrderStatuses (
		OrderStatusId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_Orders
	ADD CONSTRAINT ac_Stores_ac_Orders_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_Orders
	ADD CONSTRAINT ac_Users_ac_Orders_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_OrderNotes
	ADD CONSTRAINT ac_Orders_ac_OrderNotes_FK1 FOREIGN KEY (
		OrderId)
	 REFERENCES ac_Orders (
		OrderId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_OrderNotes
	ADD CONSTRAINT ac_Users_ac_OrderNotes_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_OrderItems
	ADD CONSTRAINT ac_Orders_ac_OrderItems_FK1 FOREIGN KEY (
		OrderId)
	 REFERENCES ac_Orders (
		OrderId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_OrderItems
	ADD CONSTRAINT ac_OrderShipments_ac_OrderItems_FK1 FOREIGN KEY (
		OrderShipmentId)
	 REFERENCES ac_OrderShipments (
		OrderShipmentId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_OrderItems
	ADD CONSTRAINT ac_Products_ac_OrderItems_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_OrderItems
	ADD CONSTRAINT ac_TaxCodes_ac_OrderItems_FK1 FOREIGN KEY (
		TaxCodeId)
	 REFERENCES ac_TaxCodes (
		TaxCodeId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_OrderItems
	ADD CONSTRAINT ac_WishlistItems_ac_OrderItems_FK1 FOREIGN KEY (
		WishlistItemId)
	 REFERENCES ac_WishlistItems (
		WishlistItemId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_OrderItems
	ADD CONSTRAINT ac_WrapStyles_ac_OrderItems_FK1 FOREIGN KEY (
		WrapStyleId)
	 REFERENCES ac_WrapStyles (
		WrapStyleId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_OrderItemInputs
	ADD CONSTRAINT ac_OrderItems_ac_OrderItemInputs_FK1 FOREIGN KEY (
		OrderItemId)
	 REFERENCES ac_OrderItems (
		OrderItemId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_OrderItemDigitalGoods
	ADD CONSTRAINT ac_OrderItemDigitalGoods_ac_DigitalGoods_FK1 FOREIGN KEY (
		DigitalGoodId)
	 REFERENCES ac_DigitalGoods (
		DigitalGoodId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_OrderItemDigitalGoods
	ADD CONSTRAINT ac_OrderItems_ac_OrderItemDigitalGoods_FK1 FOREIGN KEY (
		OrderItemId)
	 REFERENCES ac_OrderItems (
		OrderItemId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_OrderCoupons
	ADD CONSTRAINT ac_Orders_ac_OrderCoupons_FK1 FOREIGN KEY (
		OrderId)
	 REFERENCES ac_Orders (
		OrderId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Manufacturers
	ADD CONSTRAINT ac_Stores_ac_Manufacturers_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Links
	ADD CONSTRAINT ac_Stores_ac_Links_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_SerialKeys
	ADD CONSTRAINT ac_DigitalGoods_ac_SerialKeys_FK1 FOREIGN KEY (
		DigitalGoodId)
	 REFERENCES ac_DigitalGoods (
		DigitalGoodId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_LicenseAgreements
	ADD CONSTRAINT ac_Stores_ac_LicenseAgreements_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_KitProducts
	ADD CONSTRAINT ac_KitComponents_ac_KitProduct_FK1 FOREIGN KEY (
		KitComponentId)
	 REFERENCES ac_KitComponents (
		KitComponentId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_KitComponents
	ADD CONSTRAINT ac_Stores_ac_KitComponents_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_InputFields
	ADD CONSTRAINT ac_ProductTemplates_ac_InputFields_FK1 FOREIGN KEY (
		ProductTemplateId)
	 REFERENCES ac_ProductTemplates (
		ProductTemplateId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_InputChoices
	ADD CONSTRAINT ac_InputFields_ac_InputChoices_FK1 FOREIGN KEY (
		InputFieldId)
	 REFERENCES ac_InputFields (
		InputFieldId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_GiftCertificateTransactions
	ADD CONSTRAINT ac_GiftCertificates_ac_GiftCertificateTransactions_FK1 FOREIGN KEY (
		GiftCertificateId)
	 REFERENCES ac_GiftCertificates (
		GiftCertificateId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_GiftCertificateTransactions
	ADD CONSTRAINT ac_Orders_ac_GiftCertificateTransactions_FK1 FOREIGN KEY (
		OrderId)
	 REFERENCES ac_Orders (
		OrderId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_GiftCertificates
	ADD CONSTRAINT ac_Stores_ac_GiftCertificates_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_GiftCertificates
	ADD CONSTRAINT ac_OrderItems_ac_GiftCertificates_FK1 FOREIGN KEY (
		OrderItemId)
	 REFERENCES ac_OrderItems (
		OrderItemId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_EmailTemplateTriggers
	ADD CONSTRAINT ac_Emails_ac_EmailEventAssn_FK1 FOREIGN KEY (
		EmailTemplateId)
	 REFERENCES ac_EmailTemplates (
		EmailTemplateId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_EmailTemplates
	ADD CONSTRAINT ac_Stores_ac_Emails_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_EmailListUsers
	ADD CONSTRAINT ac_EmailLists_ac_EmailListUsers_FK1 FOREIGN KEY (
		EmailListId)
	 REFERENCES ac_EmailLists (
		EmailListId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_EmailListSignups
	ADD CONSTRAINT ac_EmailLists_ac_EmailListSignups_FK1 FOREIGN KEY (
		EmailListId)
	 REFERENCES ac_EmailLists (
		EmailListId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_EmailLists
	ADD CONSTRAINT ac_Stores_ac_EmailLists_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Downloads
	ADD CONSTRAINT ac_OrderFiles_ac_Downloads_FK1 FOREIGN KEY (
		OrderItemDigitalGoodId)
	 REFERENCES ac_OrderItemDigitalGoods (
		OrderItemDigitalGoodId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_DigitalGoods
	ADD CONSTRAINT ac_Readmes_ac_DigitalGoods_FK1 FOREIGN KEY (
		ReadmeId)
	 REFERENCES ac_Readmes (
		ReadmeId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_DigitalGoods
	ADD CONSTRAINT ac_LicenseAgreements_ac_DigitalGoods_FK1 FOREIGN KEY (
		LicenseAgreementId)
	 REFERENCES ac_LicenseAgreements (
		LicenseAgreementId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_DigitalGoods
	ADD CONSTRAINT ac_Stores_ac_DigitalGoods_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_CustomFields
	ADD CONSTRAINT ac_Stores_ac_CustomFields_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Currencies
	ADD CONSTRAINT ac_Stores_ac_Currencies_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_CouponShipMethods
	ADD CONSTRAINT ac_Coupons_ac_CouponShipMethods_FK1 FOREIGN KEY (
		CouponId)
	 REFERENCES ac_Coupons (
		CouponId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_CouponShipMethods
	ADD CONSTRAINT ac_ShipMethods_ac_CouponShipMethods_FK1 FOREIGN KEY (
		ShipMethodId)
	 REFERENCES ac_ShipMethods (
		ShipMethodId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Coupons
	ADD CONSTRAINT ac_Stores_ac_Coupons_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_CouponGroups
	ADD CONSTRAINT ac_Coupons_ac_CouponGroups_FK1 FOREIGN KEY (
		CouponId)
	 REFERENCES ac_Coupons (
		CouponId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_CouponGroups
	ADD CONSTRAINT ac_Groups_ac_CouponGroups_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_CouponProducts
	ADD CONSTRAINT ac_Coupons_ac_CouponProductAssn_FK1 FOREIGN KEY (
		CouponId)
	 REFERENCES ac_Coupons (
		CouponId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_CouponProducts
	ADD CONSTRAINT ac_Products_ac_CouponProductAssn_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_CouponCombos
	ADD CONSTRAINT ac_Coupons_ac_CouponCombos_FK1 FOREIGN KEY (
		CouponId)
	 REFERENCES ac_Coupons (
		CouponId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_CouponCombos
	ADD CONSTRAINT ac_Coupons_ac_CouponCombos_FK2 FOREIGN KEY (
		ComboCouponId)
	 REFERENCES ac_Coupons (
		CouponId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_Countries
	ADD CONSTRAINT ac_Stores_ac_Countries_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_CategoryVolumeDiscounts
	ADD CONSTRAINT ac_Categories_ac_CategoryDiscountAssn_FK1 FOREIGN KEY (
		CategoryId)
	 REFERENCES ac_Categories (
		CategoryId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_CategoryVolumeDiscounts
	ADD CONSTRAINT ac_Discounts_ac_CategoryDiscountAssn_FK1 FOREIGN KEY (
		VolumeDiscountId)
	 REFERENCES ac_VolumeDiscounts (
		VolumeDiscountId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_CategoryParents
	ADD CONSTRAINT ac_Categories_ac_CategoryParents_FK1 FOREIGN KEY (
		CategoryId)
	 REFERENCES ac_Categories (
		CategoryId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Categories
	ADD CONSTRAINT ac_Stores_ac_Categories_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_Categories
	ADD CONSTRAINT ac_Webpages_ac_Categories_FK1 FOREIGN KEY (
		WebpageId)
	 REFERENCES ac_Webpages (
		WebpageId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_BasketShipments
	ADD CONSTRAINT ac_Addresses_ac_BasketShipments_FK1 FOREIGN KEY (
		AddressId)
	 REFERENCES ac_Addresses (
		AddressId) ON UPDATE NO ACTION ON DELETE SET NULL  

GO

ALTER TABLE ac_BasketShipments
	ADD CONSTRAINT ac_Baskets_ac_BasketShipments_FK1 FOREIGN KEY (
		BasketId)
	 REFERENCES ac_Baskets (
		BasketId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_BasketShipments
	ADD CONSTRAINT ac_ShipMethods_ac_BasketShipments_FK1 FOREIGN KEY (
		ShipMethodId)
	 REFERENCES ac_ShipMethods (
		ShipMethodId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_BasketShipments
	ADD CONSTRAINT ac_Warehouses_ac_BasketShipments_FK1 FOREIGN KEY (
		WarehouseId)
	 REFERENCES ac_Warehouses (
		WarehouseId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Baskets
	ADD CONSTRAINT ac_Users_ac_Baskets_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_BasketItems
	ADD CONSTRAINT ac_Baskets_ac_BasketItems_FK1 FOREIGN KEY (
		BasketId)
	 REFERENCES ac_Baskets (
		BasketId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_BasketItems
	ADD CONSTRAINT ac_Products_ac_BasketItems_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId)  

GO


ALTER TABLE ac_BasketItems nocheck constraint ac_Products_ac_BasketItems_FK1 

GO

ALTER TABLE ac_BasketItems
	ADD CONSTRAINT ac_TaxCodes_ac_BasketItems_FK1 FOREIGN KEY (
		TaxCodeId)
	 REFERENCES ac_TaxCodes (
		TaxCodeId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_BasketItems
	ADD CONSTRAINT ac_WishlistItems_ac_BasketItems_FK1 FOREIGN KEY (
		WishlistItemId)
	 REFERENCES ac_WishlistItems (
		WishlistItemId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_BasketItems
	ADD CONSTRAINT ac_WrapStyles_ac_BasketItems_FK1 FOREIGN KEY (
		WrapStyleId)
	 REFERENCES ac_WrapStyles (
		WrapStyleId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_BasketItemInputs
	ADD CONSTRAINT ac_BasketItems_ac_BasketItemInputs_FK1 FOREIGN KEY (
		BasketItemId)
	 REFERENCES ac_BasketItems (
		BasketItemId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_BasketItemInputs
	ADD CONSTRAINT ac_InputFields_ac_BasketItemInputs_FK1 FOREIGN KEY (
		InputFieldId)
	 REFERENCES ac_InputFields (
		InputFieldId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_BasketCoupons
	ADD CONSTRAINT ac_Baskets_ac_BasketCoupons_FK1 FOREIGN KEY (
		BasketId)
	 REFERENCES ac_Baskets (
		BasketId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_BasketCoupons
	ADD CONSTRAINT ac_Coupons_ac_OrderCouponAssn_FK1 FOREIGN KEY (
		CouponId)
	 REFERENCES ac_Coupons (
		CouponId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_BannedIPs
	ADD CONSTRAINT ac_Stores_ac_BannedIPs_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_AuditEvents
	ADD CONSTRAINT ac_Users_ac_Auditlog_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_AuditEvents
	ADD CONSTRAINT ac_Stores_ac_AuditEvents_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO


ALTER TABLE ac_OptionChoices
	ADD CONSTRAINT ac_ProductAttributes_ac_AttributeOptions_FK1 FOREIGN KEY (
		OptionId)
	 REFERENCES ac_Options (
		OptionId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_Affiliates
	ADD CONSTRAINT ac_Stores_ac_Affiliates_FK1 FOREIGN KEY (
		StoreId)
	 REFERENCES ac_Stores (
		StoreId) ON UPDATE NO ACTION ON DELETE NO ACTION  

GO

ALTER TABLE ac_Affiliates
	ADD CONSTRAINT ac_Groups_ac_Affiliates_FK1 FOREIGN KEY (
		GroupId)
	 REFERENCES ac_Groups (
		GroupId) ON UPDATE NO ACTION ON DELETE set NULL  

GO


ALTER TABLE ac_Addresses
	ADD CONSTRAINT ac_Countries_ac_Addresses_FK1 FOREIGN KEY (
		CountryCode)
	 REFERENCES ac_Countries (
		CountryCode) ON UPDATE NO ACTION ON DELETE set NULL  

GO

ALTER TABLE ac_Addresses
	ADD CONSTRAINT ac_Users_ac_Addresses_FK1 FOREIGN KEY (
		UserId)
	 REFERENCES ac_Users (
		UserId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_UpsellProducts
	ADD CONSTRAINT ac_Products_ac_UpsellProducts_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO


ALTER TABLE ac_LanguageStrings
	ADD CONSTRAINT ac_LanguageStrings_ac_Languages_FK1 FOREIGN KEY (
		LanguageId)
	 REFERENCES ac_Languages (
		Id) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_SearchHistory
	ADD CONSTRAINT ac_Users_ac_SearchHistory_FK1 FOREIGN KEY (UserId)
	 REFERENCES ac_Users (UserId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_ReviewReminders
ADD CONSTRAINT FK_ac_ReviewReminders_ac_Users FOREIGN KEY (UserId)
REFERENCES ac_Users (UserId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_ReviewReminders
ADD CONSTRAINT FK_ac_ReviewReminders_ac_Products FOREIGN KEY (ProductId)
REFERENCES ac_Products (ProductId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_ProductGroups
ADD CONSTRAINT FK_ac_ProductGroups_ac_Products FOREIGN KEY (ProductId)
REFERENCES ac_Products (ProductId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_ProductGroups
ADD CONSTRAINT FK_ac_ProductGroups_ac_Groups FOREIGN KEY (GroupId)
REFERENCES ac_Groups (GroupId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_SubscriptionOrders
ADD CONSTRAINT FK_ac_SubscriptionOrders_ac_Subscriptions FOREIGN KEY (SubscriptionId)
REFERENCES ac_Subscriptions (SubscriptionId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_SubscriptionOrders
ADD CONSTRAINT FK_ac_SubscriptionOrders_ac_Orders FOREIGN KEY (OrderId)
REFERENCES ac_Orders (OrderId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_GatewayPaymentProfiles
	ADD CONSTRAINT FK_ac_GatewayPaymentProfiles_ac_Users FOREIGN KEY (UserId)
	REFERENCES ac_Users (UserId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_Subscriptions ADD CONSTRAINT ac_PaymentMethods_ac_Subscriptions_FK1 FOREIGN KEY (PaymentMethodId)
	 REFERENCES ac_PaymentMethods (PaymentMethodId) ON UPDATE NO ACTION ON DELETE SET NULL

GO

ALTER TABLE ac_Subscriptions ADD CONSTRAINT ac_GatewayPaymentProfiles_ac_Subscriptions_FK1 FOREIGN KEY (GatewayPaymentProfileId)
	 REFERENCES ac_GatewayPaymentProfiles (GatewayPaymentProfileId) ON UPDATE NO ACTION ON DELETE NO ACTION

GO

ALTER TABLE ac_Subscriptions ADD CONSTRAINT ac_TaxCodes_ac_Subscriptions_FK1 FOREIGN KEY (BaseTaxCodeId)
	 REFERENCES ac_TaxCodes (TaxCodeId) ON UPDATE NO ACTION ON DELETE SET NULL

GO

ALTER TABLE ac_Subscriptions ADD CONSTRAINT ac_TaxCodes_ac_Subscriptions_FK2 FOREIGN KEY (RecurringTaxCodeId)
	 REFERENCES ac_TaxCodes (TaxCodeId) ON UPDATE NO ACTION ON DELETE NO ACTION

GO


ALTER TABLE ac_DigitalGoodGroups
ADD CONSTRAINT FK_ac_DigitalGoodGroups_ac_DigitalGoods FOREIGN KEY (DigitalGoodId)
REFERENCES ac_DigitalGoods (DigitalGoodId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_DigitalGoodGroups
ADD CONSTRAINT FK_ac_DigitalGoodGroups_ac_Groups FOREIGN KEY (GroupId)
REFERENCES ac_Groups (GroupId) ON UPDATE NO ACTION ON DELETE CASCADE

GO

ALTER TABLE ac_RestockNotify
	ADD CONSTRAINT ac_Products_ac_RestockNotify_FK1 FOREIGN KEY (
		ProductId)
	 REFERENCES ac_Products (
		ProductId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

ALTER TABLE ac_RestockNotify
	ADD CONSTRAINT ac_ProductVariants_ac_RestockNotify_FK1 FOREIGN KEY (
		ProductVariantId)
	 REFERENCES ac_ProductVariants (
		ProductVariantId) ON UPDATE NO ACTION ON DELETE CASCADE  

GO

/* -------------------------------- UNIQUE INDEXES -------------------------------------- */

CREATE UNIQUE INDEX ac_Redirects_IX1 ON ac_Redirects (LoweredSourceUrl)

GO

CREATE UNIQUE INDEX ac_CustomUrls_IX1 ON ac_CustomUrls (CatalogNodeId,CatalogNodeTypeId)

GO

CREATE UNIQUE INDEX ac_CustomUrls_IX2 ON ac_CustomUrls (LoweredUrl)

GO

CREATE UNIQUE INDEX ac_ReviewerProfiles_IX1 ON ac_ReviewerProfiles (Email)

GO

CREATE UNIQUE INDEX ac_Orders_IXOrderNumber ON ac_Orders (OrderNumber)

GO

CREATE UNIQUE INDEX IX_ac_ReviewReminders_Unique ON ac_ReviewReminders (UserId, ProductId)

GO

CREATE UNIQUE INDEX IX_ac_ProductGroups_Unique ON ac_ProductGroups (ProductId, GroupId)

GO

/* --------------------------- UNIQUE INDEXES FOR COMPOSITE COLUMNS------------------------------- */

CREATE UNIQUE INDEX ac_BasketCoupons_CK ON ac_BasketCoupons (BasketId, CouponId)

GO

CREATE UNIQUE INDEX ac_EmailListUsers_CK ON ac_EmailListUsers (EmailListId, Email)

GO

CREATE UNIQUE INDEX ac_ProductKitComponents_CK ON ac_ProductKitComponents (ProductId, KitComponentId)

GO

CREATE UNIQUE INDEX ac_ProductOptions_CK ON ac_ProductOptions (ProductId, OptionId)

GO

CREATE UNIQUE INDEX ac_RelatedProducts_CK ON ac_RelatedProducts (ProductId, ChildProductId)

GO

CREATE UNIQUE INDEX ac_UpsellProducts_CK ON ac_UpsellProducts (ProductId, ChildProductId)

GO

CREATE UNIQUE INDEX ac_UserGroups_CK ON ac_UserGroups (UserId, GroupId)

GO

CREATE UNIQUE INDEX ac_UserPasswords_CK ON ac_UserPasswords (UserId, PasswordNumber)

GO

CREATE UNIQUE INDEX ac_CouponCombos_CK ON ac_CouponCombos (CouponId, ComboCouponId)

GO

CREATE UNIQUE INDEX ac_EmailTemplateTriggers_CK ON ac_EmailTemplateTriggers (EmailTemplateId, StoreEventId)

GO

CREATE UNIQUE INDEX ac_OrderCoupons_CK ON ac_OrderCoupons (OrderId, CouponCode)

GO

CREATE UNIQUE INDEX ac_OrderStatusActions_CK ON ac_OrderStatusActions (OrderStatusId, OrderActionId)

GO

CREATE UNIQUE INDEX ac_OrderStatusTriggers_CK ON ac_OrderStatusTriggers (StoreEventId, OrderStatusId)

GO

/* ------------------------------- STORED PROCEEDURES ------------------------------------ */
/* Create procedure/function acsp_MergeUserGroupMembers.                                      */
/* MERGES MEMBERS OF SOURCE GROUP TO TARGET GROUP                                             */
CREATE PROCEDURE acsp_MergeUserGroupMembers
	@sourceGroupId int,
	@targetGroupId int
AS
BEGIN
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
END

GO

/*------------------------------ INDEXES ---------------------------------*/

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

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_PageViews_IX2' AND object_id = OBJECT_ID('ac_PageViews'))
DROP INDEX ac_PageViews_IX2 ON ac_PageViews

CREATE INDEX ac_PageViews_IX2 ON ac_PageViews
(
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

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'ac_Users_IX2' AND object_id = OBJECT_ID('ac_Users'))
DROP INDEX ac_Users_IX2 ON ac_Users

CREATE INDEX ac_Users_IX2 ON ac_Users
(
	[LoweredEmail] ASC
)
GO

CREATE INDEX ac_SearchHistory_IX1 ON ac_SearchHistory (SearchTerm)

GO

--CREATE NON CLUSTERED INDEXES FOR ALL FOREIGN KEY REFERENCES IN THE DATABASE

DECLARE @sql nvarchar(max);
SET @sql = '';
SELECT @sql = @sql +
'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''['
+ tab.[name]
+ ']'') AND name = N''IX_'
+ cols.[name]
+ ''') '
+ 'CREATE NONCLUSTERED INDEX [IX_'
+ cols.[name]
+ '] ON ['
+ tab.[name]
+ ']( ['
+ cols.[name]
+ '] ASC ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY];'
FROM sys.foreign_keys keys
INNER JOIN sys.foreign_key_columns keyCols
 ON keys.object_id = keyCols.constraint_object_id
INNER JOIN sys.columns cols
 ON keyCols.parent_object_id = cols.object_id
 AND keyCols.parent_column_id = cols.column_id
INNER JOIN sys.tables tab
 ON keyCols.parent_object_id = tab.object_id
 WHERE tab.[name] LIKE 'ac_%' AND tab.[name] + '.' + cols.[name] NOT IN ('ac_PageViews.StoreId', 'ac_Orders.StoreId', 'ac_Orders.UserId', 'ac_OrderItems.OrderId', 'ac_OrderNotes.OrderId', 'ac_OrderShipments.OrderId', 'ac_Payments.OrderId', 'ac_Products.StoreId', 'ac_Products.ManufacturerId')
ORDER BY tab.[name], cols.[name]
exec sp_executesql @sql


/*------------------------------ DEFAULT DATA ---------------------------------*/

-- <[ac_Stores]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_Stores] ON;

INSERT INTO [ac_Stores] ([StoreId], [Name], [ApplicationName], [LoweredApplicationName], [DefaultWarehouseId], [NextOrderId], [OrderIdIncrement], [WeightUnitId], [MeasurementUnitId]) 
	VALUES ( 1, 'Default', '/', '/', 1, 1, 1, 0, 0 );

SET IDENTITY_INSERT [ac_Stores] OFF;

-- </[ac_Stores]>

GO

-- <[ac_StoreSettings]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_StoreSettings] ON;

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 1, 1, 'ProductReviewEnabled', '2' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 2, 1, 'ProductReviewApproval', '3' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 3, 1, 'ProductReviewImageVerification', '3' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 4, 1, 'ProductReviewEmailVerification', '1' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 5, 1, 'PageViewTrackingEnabled', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 6, 1, 'PageViewTrackingSaveArchive', 'False' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 7, 1, 'PageViewTrackingDays', '7' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 8, 1, 'StoreTheme', 'Bootstrap_Responsive' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 11, 1, 'ProductPurchasingDisabled', 'False' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 12, 1, 'MerchantPasswordMinLength', '8' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 13, 1, 'MerchantPasswordRequireUpper', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 14, 1, 'MerchantPasswordRequireLower', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 15, 1, 'MerchantPasswordRequireNonAlpha', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 16, 1, 'MerchantPasswordMaxAge', '30' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 17, 1, 'MerchantPasswordHistoryCount', '4' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 18, 1, 'MerchantPasswordHistoryDays', '10' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 19, 1, 'MerchantPasswordMaxAttempts', '6' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 20, 1, 'MerchantPasswordLockoutPeriod', '30' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 21, 1, 'MerchantPasswordInactivePeriod', '3' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 22, 1, 'CustomerPasswordMinLength', '6' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 23, 1, 'CustomerPasswordRequireUpper', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 24, 1, 'CustomerPasswordRequireLower', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 25, 1, 'CustomerPasswordRequireNonAlpha', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 26, 1, 'CustomerPasswordMaxAge', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 27, 1, 'CustomerPasswordHistoryCount', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 28, 1, 'CustomerPasswordMaxAttempts', '6' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 29, 1, 'CustomerPasswordLockoutPeriod', '30' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 30, 1, 'BaseCurrencyId', '1' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 31, 1, 'IconImageSize', '50' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 32, 1, 'ThumbnailImageSize', '120' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 33, 1, 'StandardImageSize', '500' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 34, 1, 'ImageSkuLookupEnabled', 'False' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 35, 1, 'OptionThumbnailHeight', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 36, 1, 'OptionThumbnailWidth', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 37, 1, 'OptionThumbnailColumns', '2' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 38, 1, 'ProductReviewEmailVerificationTemplate', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 39, 1, 'ProductReviewTermsAndConditions', '' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 40, 1, 'VolumeDiscountMode', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 41, 1, 'Store_TimeZoneCode', '' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 42, 1, 'Store_TimeZoneOffset', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 43, 1, 'SiteDisclaimerMessage', '' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 44, 1, 'EnableInventory', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 45, 1, 'InventoryDisplayDetails', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 46, 1, 'InventoryInStockMessage', '{0} units available');

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 47, 1, 'InventoryOutOfStockMessage', 'The product is currently out of stock, current quantity is {0}. ' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 48, 1, 'CheckoutTermsAndConditions', '' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 49, 1, 'OrderMinimumAmount', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 50, 1, 'OrderMaximumAmount', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 51, 1, 'AnonymousUserLifespan', '30' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 52, 1, 'AnonymousAffiliateUserLifespan', '30' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 53, 1, 'GiftCertificateDaysToExpire', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 54, 1, 'PostalCodeCountries', 'US,CA' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 55, 1, 'FileExt_Assets', 'gif, jpg, png' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 56, 1, 'FileExt_Themes', 'gif, jpg, png, skin, css, htm, html' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 57, 1, 'FileExt_DigitalGoods', 'zip' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 58, 1, 'Email_DefaultAddress', 'info@yourdomain.xyz' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 59, 1, 'Email_SubscriptionAddress', 'info@yourdomain.xyz' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 60, 1, 'ProductTellAFriendEmailTemplateId', '14' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 61, 1, 'AbandonedBasketAlertEmailTemplateId', '17' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 62, 1, 'WebpagesDefaultLayout', '~/Layouts/LeftSidebar.master' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 63, 1, 'CategoriesDefaultLayout', '~/Layouts/Category.master' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 64, 1, 'ProductsDefaultLayout', '~/Layouts/Product.master' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 65, 1, 'CategoryWebpageId', '1' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 66, 1, 'ProductWebpageId', '7' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 67, 1, 'EnableCustomerOrderNotes', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 68, 1, 'ProductReviewReminderEmailTemplate', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 69, 1, 'EnableShipToMultipleAddresses', 'True' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 70, 1, 'ROPaymentReminderEmailTemplateId', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 71, 1, 'ROExpirationReminderEmailTemplateId', '0' 
	);

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 72, 1, 'ROSubscriptionExpiredEmailTemplateId', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 73, 1, 'ROSubscriptionEnrollmentEmailTemplateId', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 74, 1, 'ROSubscriptionCancellationEmailTemplateId', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 75, 1, 'ROSubscriptionUpdatedEmailTemplateId', '0' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 76, 1, 'EnablePartialPaymentCheckouts', 'False' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 77, 1, 'ContactUsConfirmationEmailTemplateId', '25' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 78, 1, 'AffiliateRegistrationEmailTemplateId', '26' );

INSERT INTO [ac_StoreSettings] ([StoreSettingId], [StoreId], [FieldName], [FieldValue]) 
	VALUES ( 79, 1, 'InventoryRestockNotificationEmailTemplateId', '27' );

SET IDENTITY_INSERT [ac_StoreSettings] OFF;

-- </[ac_StoreSettings]>

GO

-- <[ac_AuditEvents]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_AuditEvents] ON;

INSERT INTO [ac_AuditEvents] ([AuditEventId], [StoreId], [EventDate], [EventTypeId], [Successful]) 
	VALUES ( 1, 1, GetUtcDate(), 1000, 1 );

SET IDENTITY_INSERT [ac_AuditEvents] OFF;

-- </[ac_AuditEvents]>

GO

-- <[ac_Roles]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_Roles] ON;

INSERT INTO [ac_Roles] ([RoleId], [Name], [LoweredName]) 
	VALUES ( 1, 'System', 'system' );

INSERT INTO [ac_Roles] ([RoleId], [Name], [LoweredName]) 
	VALUES ( 2, 'Admin', 'admin' );

INSERT INTO [ac_Roles] ([RoleId], [Name], [LoweredName]) 
	VALUES ( 3, 'Manage Catalog', 'manage catalog' );

INSERT INTO [ac_Roles] ([RoleId], [Name], [LoweredName]) 
	VALUES ( 4, 'Manage Orders', 'manage orders' );

INSERT INTO [ac_Roles] ([RoleId], [Name], [LoweredName]) 
	VALUES ( 5, 'Manage Website', 'manage website' );

INSERT INTO [ac_Roles] ([RoleId], [Name], [LoweredName]) 
	VALUES ( 6, 'View Reports', 'view reports' );

INSERT INTO [ac_Roles] ([RoleId], [Name], [LoweredName]) 
	VALUES ( 7, 'Junior Admin', 'junior admin' );

INSERT INTO [ac_Roles] ([RoleId], [Name], [LoweredName]) 
	VALUES ( 8, 'Authorized User', 'authorized user' );

INSERT INTO [ac_Roles] ([RoleId], [Name], [LoweredName]) 
	VALUES ( 9, 'Web API Access', 'web api access' );

SET IDENTITY_INSERT [ac_Roles] OFF;

-- </[ac_Roles]>

GO

-- <[ac_Groups]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_Groups] ON;

INSERT INTO [ac_Groups] ([GroupId], [StoreId], [Name], [IsReadOnly]) 
	VALUES ( 1, 1, 'Super Users', 1 );

INSERT INTO [ac_Groups] ([GroupId], [StoreId], [Name], [IsReadOnly]) 
	VALUES ( 2, 1, 'Admins', 0 );

INSERT INTO [ac_Groups] ([GroupId], [StoreId], [Name], [IsReadOnly]) 
	VALUES ( 3, 1, 'Catalog Admins', 0 );

INSERT INTO [ac_Groups] ([GroupId], [StoreId], [Name], [IsReadOnly]) 
	VALUES ( 4, 1, 'Order Admins', 0 );

INSERT INTO [ac_Groups] ([GroupId], [StoreId], [Name], [IsReadOnly]) 
	VALUES ( 5, 1, 'Website Admins', 0 );

INSERT INTO [ac_Groups] ([GroupId], [StoreId], [Name], [IsReadOnly]) 
	VALUES ( 6, 1, 'Report Admins', 0 );

INSERT INTO [ac_Groups] ([GroupId], [StoreId], [Name], [IsReadOnly]) 
	VALUES ( 7, 1, 'Junior Admins', 0 );

INSERT INTO [ac_Groups] ([GroupId], [StoreId], [Name], [IsReadOnly]) 
	VALUES ( 8, 1, '_Default_', 1 );

INSERT INTO [ac_Groups] ([GroupId], [StoreId], [Name], [IsReadOnly]) 
	VALUES ( 9, 1, 'Web API Users', 0 );

SET IDENTITY_INSERT [ac_Groups] OFF;

-- </[ac_Groups]>

GO

-- <[ac_GroupRoles]>

SET NOCOUNT ON;

INSERT INTO [ac_GroupRoles] ([GroupId], [RoleId]) 
	VALUES ( 1, 1 );

INSERT INTO [ac_GroupRoles] ([GroupId], [RoleId]) 
	VALUES ( 2, 2 );

INSERT INTO [ac_GroupRoles] ([GroupId], [RoleId]) 
	VALUES ( 3, 3 );

INSERT INTO [ac_GroupRoles] ([GroupId], [RoleId]) 
	VALUES ( 4, 4 );

INSERT INTO [ac_GroupRoles] ([GroupId], [RoleId]) 
	VALUES ( 5, 5 );

INSERT INTO [ac_GroupRoles] ([GroupId], [RoleId]) 
	VALUES ( 6, 6 );

INSERT INTO [ac_GroupRoles] ([GroupId], [RoleId]) 
	VALUES ( 7, 7 );

INSERT INTO [ac_GroupRoles] ([GroupId], [RoleId]) 
	VALUES ( 8, 8 );

INSERT INTO [ac_GroupRoles] ([GroupId], [RoleId]) 
	VALUES ( 9, 9 );

-- </[ac_GroupRoles]>

GO

-- <[ac_Users]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_Users] ON;

INSERT INTO [ac_Users] ([UserId], [StoreId], [UserName], [LoweredUserName], [Email], [LoweredEmail], [IsApproved], [IsAnonymous], [IsLockedOut], [CreateDate], [LastActivityDate], [FailedPasswordAttemptCount], [FailedPasswordAnswerAttemptCount], [TaxExemptionType])
	VALUES ( 1, 1, 'admin', 'admin', 'admin@sample.xyz', 'admin@sample.xyz', 1, 0, 0, GetUtcDate(), GetUtcDate(), 0, 0, 0 )

SET IDENTITY_INSERT [ac_Users] OFF;

-- </[ac_Users]>

GO

-- <[ac_UserGroups]>

SET NOCOUNT ON;

INSERT INTO [ac_UserGroups] ([UserId], [GroupId]) 
	VALUES ( 1, 1 );

-- </[ac_UserGroups]>

GO

-- <[ac_Currencies]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_Currencies] ON;

INSERT INTO [ac_Currencies] ([CurrencyId], [StoreId], [Name], [CurrencySymbol], [DecimalDigits], [DecimalSeparator], [GroupSeparator], [GroupSizes], [NegativePattern], [NegativeSign], [PositivePattern], [ISOCode], [ISOCodePattern], [ExchangeRate], [AutoUpdate], [LastUpdate]) 
	VALUES ( 1, 1, 'US Dollar', '$', 2, '.', ',', '3', 1, '-', 0, 'USD', 0, 1.0000, 0, GetUtcDate() );

SET IDENTITY_INSERT [ac_Currencies] OFF;

-- </[ac_Currencies]>

GO

-- <[ac_Countries]>

SET NOCOUNT ON;

INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AD', 1, 'Andorra', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AE', 1, 'United Arab Emirates', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AF', 1, 'Afghanistan', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AG', 1, 'Antigua and Barbuda', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AI', 1, 'Anguilla', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AL', 1, 'Albania', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AM', 1, 'Armenia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AN', 1, 'Netherlands Antilles', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AO', 1, 'Angola', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AQ', 1, 'Antarctica', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AR', 1, 'Argentina', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AS', 1, 'American Samoa', '[Company]
[Name]
[Address1]
[Address2]
[City_U], AS [PostalCode]
UNITED STATES')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AT', 1, 'Austria', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] [Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AU', 1, 'Australia', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [Province_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AW', 1, 'Aruba', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AX', 1, 'Aland Islands', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('AZ', 1, 'Azerbaijan', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] [Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BA', 1, 'Bosnia and Herzegovina', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BB', 1, 'Barbados', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BD', 1, 'Bangladesh', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BE', 1, 'Belgium', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BF', 1, 'Burkina Faso', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BG', 1, 'Bulgaria', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BH', 1, 'Bahrain', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BI', 1, 'Burundi', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BJ', 1, 'Benin', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BL', 1, 'Saint Barthelemy', '[Company]
[Name]
[Address1_U]
[Address2_U]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BM', 1, 'Bermuda', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BN', 1, 'Brunei Darussalam', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BO', 1, 'Bolivia', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BR', 1, 'Brazil', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [Province_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BS', 1, 'Bahamas', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode]
[City_U] [Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BT', 1, 'Bhutan', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BW', 1, 'Botswana', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BY', 1, 'Belarus', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('BZ', 1, 'Belize', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CA', 1, 'Canada', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [Province_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CC', 1, 'Cocos (Keeling) Islands', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [Province_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CD', 1, 'Congo - Kinshasa', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CF', 1, 'Central African Republic', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CG', 1, 'Congo - Brazzaville', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CH', 1, 'Switzerland', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CI', 1, 'Cote d''Ivoire', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CK', 1, 'Cook Islands', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CL', 1, 'Chile', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CM', 1, 'Cameroon', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CN', 1, 'China', '[Company]
[Name]
[Address1]
[Address2] [City_U]
[PostalCode] [Province_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CO', 1, 'Colombia', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CR', 1, 'Costa Rica', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CU', 1, 'Cuba', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CV', 1, 'Cape Verde', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CX', 1, 'Christmas Island', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [Province_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CY', 1, 'Cyprus', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('CZ', 1, 'Czech Republic', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('DE', 1, 'Germany', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('DJ', 1, 'Djibouti', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('DK', 1, 'Denmark', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('DM', 1, 'Dominica', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('DO', 1, 'Dominican Republic', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('DZ', 1, 'Algeria', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('EC', 1, 'Ecuador', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('EE', 1, 'Estonia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('EG', 1, 'Egypt', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('EH', 1, 'Western Sahara', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ER', 1, 'Eritrea', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ES', 1, 'Spain', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ET', 1, 'Ethiopia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('FI', 1, 'Finland', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('FJ', 1, 'Fiji', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('FK', 1, 'Falkland Islands', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('FM', 1, 'Micronesia', '[Company]
[Name]
[Address1]
[Address2]
[City_U], FM [PostalCode]
UNITED STATES')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('FO', 1, 'Faroe Islands', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('FR', 1, 'France', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GA', 1, 'Gabon', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GB', 1, 'United Kingdom', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GD', 1, 'Grenada', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GE', 1, 'Georgia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GF', 1, 'French Guiana', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GG', 1, 'Guernsey', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GH', 1, 'Ghana', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GI', 1, 'Gibraltar', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GL', 1, 'Greenland', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GM', 1, 'Gambia', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GN', 1, 'Guinea', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GP', 1, 'Guadeloupe', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GQ', 1, 'Equatorial Guinea', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GR', 1, 'Greece', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GT', 1, 'Guatemala', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GU', 1, 'Guam', '[Company]
[Name]
[Address1]
[Address2]
[City_U], GU [PostalCode]
UNITED STATES')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GW', 1, 'Guinea-bissau', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('GY', 1, 'Guyana', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('HK', 1, 'Hong Kong', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('HN', 1, 'Honduras', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('HR', 1, 'Croatia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('HT', 1, 'Haiti', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('HU', 1, 'Hungary', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ID', 1, 'Indonesia', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('IE', 1, 'Ireland', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('IL', 1, 'Israel', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('IM', 1, 'Isle of Man', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('IN', 1, 'India', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
GO
print 'Processed 100 total records'
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('IQ', 1, 'Iraq', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [Province_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('IR', 1, 'Iran', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('IS', 1, 'Iceland', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('IT', 1, 'Italy', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] [Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('JE', 1, 'Jersey', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('JM', 1, 'Jamaica', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('JO', 1, 'Jordan', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('JP', 1, 'Japan', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode] [Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KE', 1, 'Kenya', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KG', 1, 'Kyrgyzstan', '[Company]
[Name]
[PostalCode] [City_U]
[Address1]
[Address2]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KH', 1, 'Cambodia', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KI', 1, 'Kiribati', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KM', 1, 'Comoros', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KN', 1, 'Saint Kitts and Nevis', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KP', 1, 'Korea, North', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KR', 1, 'Korea, South', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KW', 1, 'Kuwait', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KY', 1, 'Cayman Islands', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('KZ', 1, 'Kazakhstan', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]
[PostalCode]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LA', 1, 'Laos', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LB', 1, 'Lebanon', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LC', 1, 'Saint Lucia', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LI', 1, 'Liechtenstein', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LK', 1, 'Sri Lanka', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LR', 1, 'Liberia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LS', 1, 'Lesotho', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LT', 1, 'Lithuania', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LU', 1, 'Luxembourg', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LV', 1, 'Latvia', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('LY', 1, 'Libya', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MA', 1, 'Morocco', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MC', 1, 'Monaco', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MD', 1, 'Moldova', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ME', 1, 'Montenegro', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MF', 1, 'Saint Martin', '[Company]
[Name]
[Address1_U]
[Address2_U]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MG', 1, 'Madagascar', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MH', 1, 'Marshall Islands', '[Company]
[Name]
[Address1]
[Address2]
[City_U], MH [PostalCode]
UNITED STATES')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MK', 1, 'Macedonia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ML', 1, 'Mali', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MM', 1, 'Myanmar', '[Company]
[Name]
[Address1]
[Address2]
[City_U], [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MN', 1, 'Mongolia', '[Company]
[Name]
[Address1]
[Address2]
[City_U], [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MO', 1, 'Macao', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MP', 1, 'Northern Mariana Islands', '[Company]
[Name]
[Address1]
[Address2]
[City_U], MP [PostalCode]
UNITED STATES')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MQ', 1, 'Martinique', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MR', 1, 'Mauritania', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MS', 1, 'Montserrat', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MT', 1, 'Malta', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MU', 1, 'Mauritius', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MV', 1, 'Maldives', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MW', 1, 'Malawi', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MX', 1, 'Mexico', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U], [Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MY', 1, 'Malaysia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('MZ', 1, 'Mozambique', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NA', 1, 'Namibia', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NC', 1, 'New Caledonia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NE', 1, 'Niger', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NF', 1, 'Norfolk Island', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [Province_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NG', 1, 'Nigeria', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NI', 1, 'Nicaragua', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NL', 1, 'Netherlands', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NO', 1, 'Norway', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NP', 1, 'Nepal', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NR', 1, 'Nauru', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NU', 1, 'Niue', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('NZ', 1, 'New Zealand', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('OM', 1, 'Oman', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PA', 1, 'Panama', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PE', 1, 'Peru', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PF', 1, 'French Polynesia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PG', 1, 'Papua New Guinea', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode] [Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PH', 1, 'Philippines', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PK', 1, 'Pakistan', '[Company]
[Name]
[Address1]
[Address2]
[City_U]-[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PL', 1, 'Poland', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PM', 1, 'Saint Pierre and Miquelon', '[Company]
[Name]
[Address1_U]
[Address2_U]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PN', 1, 'Pitcairn', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PR', 1, 'Puerto Rico', '[Company]
[Name]
[Address1]
[Address2]
[City_U], PR [PostalCode]
UNITED STATES')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PS', 1, 'Palestinian Territory', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PT', 1, 'Portugal', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PW', 1, 'Palau', '[Company]
[Name]
[Address1]
[Address2]
[City_U], PW [PostalCode]
UNITED STATES')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('PY', 1, 'Paraguay', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('QA', 1, 'Qatar', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('RE', 1, 'Reunion', '[Company]
[Name]
[Address1_U]
[Address2_U]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('RO', 1, 'Romania', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('RS', 1, 'Serbia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('RU', 1, 'Russian Federation', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]
[PostalCode]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('RW', 1, 'Rwanda', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SA', 1, 'Saudi Arabia', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SB', 1, 'Solomon Islands', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SC', 1, 'Seychelles', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SD', 1, 'Sudan', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SE', 1, 'Sweden', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SG', 1, 'Singapore', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SH', 1, 'Saint Helena', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SI', 1, 'Slovenia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SJ', 1, 'Svalbard and Jan Mayen', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SK', 1, 'Slovakia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SL', 1, 'Sierra Leone', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SM', 1, 'San Marino', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SN', 1, 'Senegal', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SO', 1, 'Somalia', '[Company]
[Name]
[Address1_U]
[Address2_U]
[City_U], [Province_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SR', 1, 'Suriname', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
GO
print 'Processed 200 total records'
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ST', 1, 'Sao Tome and Principe', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SV', 1, 'El Salvador', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] 
[Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SY', 1, 'Syria', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('SZ', 1, 'Swaziland', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TC', 1, 'Turks and Caicos Islands', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TD', 1, 'Chad', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TG', 1, 'Togo', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TH', 1, 'Thailand', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TJ', 1, 'Tajikistan', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TK', 1, 'Tokelau', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TL', 1, 'Timor-leste', '[Company]
[Name]
[Address1]
[Address2]
[City_U] 
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TM', 1, 'Turkmenistan', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TN', 1, 'Tunisia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TO', 1, 'Tonga', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TR', 1, 'Turkey', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TT', 1, 'Trinidad and Tobago', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TV', 1, 'Tuvalu', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TW', 1, 'Taiwan', '[Company]
[Name]
[Address1]
[Address2]
[City_U], [Province_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('TZ', 1, 'Tanzania', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('UA', 1, 'Ukraine', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('UG', 1, 'Uganda', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('US', 1, 'United States', '[Company]
[Name]
[Address1]
[Address2]
[City_U], [Province_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('UY', 1, 'Uruguay', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U] [Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('UZ', 1, 'Uzbekistan', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]
[PostalCode]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('VA', 1, 'Vatican City (Holy See)', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('VC', 1, 'Saint Vincent', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('VE', 1, 'Venezuela', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode], [Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('VG', 1, 'Virgin Islands, British', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('VI', 1, 'Virgin Islands, U.S.', '[Company]
[Name]
[Address1]
[Address2]
[City_U], VI [PostalCode]
UNITED STATES')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('VN', 1, 'Viet Nam', '[Company]
[Name]
[Address1]
[Address2]
[City_U] [PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('VU', 1, 'Vanuatu', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('WF', 1, 'Wallis and Futuna', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('WS', 1, 'Samoa', '[Company]
[Name]
[Address1_U]
[Address2_U]
[City_U], WS [PostalCode]
UNITED STATES')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('YE', 1, 'Yemen', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Province_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('YT', 1, 'Mayotte', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ZA', 1, 'South Africa', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[PostalCode]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ZM', 1, 'Zambia', '[Company]
[Name]
[Address1]
[Address2]
[PostalCode] [City_U]
[Country_U]')
INSERT INTO [ac_Countries] ([CountryCode], [StoreId], [Name], [AddressFormat]) VALUES ('ZW', 1, 'Zimbabwe', '[Company]
[Name]
[Address1]
[Address2]
[City_U]
[Province_U]
[Country_U]')

-- </[ac_Countries]>

GO

-- <[ac_Provinces]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_Provinces] ON;

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 1, 'CA', 'Alberta', 'alberta', 'AB' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 2, 'CA', 'British Columbia', 'british columbia', 'BC' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 3, 'CA', 'Manitoba', 'manitoba', 'MB' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 4, 'CA', 'New Brunswick', 'new brunswick', 'NB' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 5, 'CA', 'Newfoundland and Labrador', 'newfoundland and labrador', 'NL' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 6, 'CA', 'Northwest Territories', 'northwest territories', 'NT' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 7, 'CA', 'Nova Scotia', 'nova scotia', 'NS' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 8, 'CA', 'Nunavut', 'nunavut', 'NU' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 9, 'CA', 'Ontario', 'ontario', 'ON' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 10, 'CA', 'Prince Edward Island', 'prince edward island', 'PE' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 11, 'CA', 'Quebec', 'quebec', 'QC' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 12, 'CA', 'Saskatchewan', 'saskatchewan', 'SK' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 13, 'CA', 'Yukon', 'yukon', 'YT' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 14, 'MX', 'Aguascalientes', 'aguascalientes', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 15, 'MX', 'Baja California', 'baja california', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 16, 'MX', 'Baja California Sur', 'baja california sur', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 17, 'MX', 'Campeche', 'campeche', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 18, 'MX', 'Coahuila', 'coahuila', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 19, 'MX', 'Colima', 'colima', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 20, 'MX', 'Chiapas', 'chiapas', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 21, 'MX', 'Chihuahua', 'chihuahua', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 22, 'MX', 'Distrito Federal', 'distrito federal', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 23, 'MX', 'Durango', 'durango', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 24, 'MX', 'Guanajuato', 'guanajuato', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 25, 'MX', 'Guerrero', 'guerrero', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 26, 'MX', 'Hidalgo', 'hidalgo', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 27, 'MX', 'Jalisco', 'jalisco', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 28, 'MX', 'Mexico', 'mexico', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 29, 'MX', 'Michoacan', 'michoacan', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 30, 'MX', 'Morelos', 'morelos', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 31, 'MX', 'Nayarit', 'nayarit', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 32, 'MX', 'Nuevo Leon', 'nuevo leon', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 33, 'MX', 'Oaxaca', 'oaxaca', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 34, 'MX', 'Puebla', 'puebla', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 35, 'MX', 'Queretaro', 'queretaro', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 36, 'MX', 'Quintana Roo', 'quintana roo', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 37, 'MX', 'San Luis Potosi', 'san luis potosi', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 38, 'MX', 'Sinaloa', 'sinaloa', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 39, 'MX', 'Sonora', 'sonora', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 40, 'MX', 'Tabasco', 'tabasco', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 41, 'MX', 'Tamaulipas', 'tamaulipas', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 42, 'MX', 'Tlaxcala', 'tlaxcala', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 43, 'MX', 'Veracruz', 'veracruz', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 44, 'MX', 'Yucatan', 'yucatan', NULL );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 45, 'MX', 'Zacatecas', 'zacatecas', 'ZAC' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 46, 'US', 'Alabama', 'alabama', 'AL' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 47, 'US', 'Alaska', 'alaska', 'AK' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 48, 'US', 'Arizona', 'arizona', 'AZ' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 49, 'US', 'Arkansas', 'arkansas', 'AR' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 50, 'US', 'California', 'california', 'CA' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 51, 'US', 'Colorado', 'colorado', 'CO' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 52, 'US', 'Connecticut', 'connecticut', 'CT' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 53, 'US', 'Delaware', 'delaware', 'DE' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 54, 'US', 'District of Columbia', 'district of columbia', 'DC' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 55, 'US', 'Florida', 'florida', 'FL' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 56, 'US', 'Georgia', 'georgia', 'GA' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 57, 'US', 'Hawaii', 'hawaii', 'HI' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 58, 'US', 'Idaho', 'idaho', 'ID' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 59, 'US', 'Illinois', 'illinois', 'IL' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 60, 'US', 'Indiana', 'indiana', 'IN' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 61, 'US', 'Iowa', 'iowa', 'IA' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 62, 'US', 'Kansas', 'kansas', 'KS' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 63, 'US', 'Kentucky', 'kentucky', 'KY' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 64, 'US', 'Louisiana', 'louisiana', 'LA' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 65, 'US', 'Maine', 'maine', 'ME' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 66, 'US', 'Maryland', 'maryland', 'MD' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 67, 'US', 'Massachusetts', 'massachusetts', 'MA' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 68, 'US', 'Michigan', 'michigan', 'MI' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 69, 'US', 'Minnesota', 'minnesota', 'MN' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 70, 'US', 'Mississippi', 'mississippi', 'MS' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 71, 'US', 'Missouri', 'missouri', 'MO' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 72, 'US', 'Montana', 'montana', 'MT' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 73, 'US', 'Nebraska', 'nebraska', 'NE' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 74, 'US', 'Nevada', 'nevada', 'NV' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 75, 'US', 'New Hampshire', 'new hampshire', 'NH' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 76, 'US', 'New Jersey', 'new jersey', 'NJ' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 77, 'US', 'New Mexico', 'new mexico', 'NM' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 78, 'US', 'New York', 'new york', 'NY' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 79, 'US', 'North Carolina', 'north carolina', 'NC' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 80, 'US', 'North Dakota', 'north dakota', 'ND' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 81, 'US', 'Ohio', 'ohio', 'OH' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 82, 'US', 'Oklahoma', 'oklahoma', 'OK' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 83, 'US', 'Oregon', 'oregon', 'OR' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 84, 'US', 'Pennsylvania', 'pennsylvania', 'PA' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 85, 'US', 'Rhode Island', 'rhode island', 'RI' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 86, 'US', 'South Carolina', 'south carolina', 'SC' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 87, 'US', 'South Dakota', 'south dakota', 'SD' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 88, 'US', 'Tennessee', 'tennessee', 'TN' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 89, 'US', 'Texas', 'texas', 'TX' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 90, 'US', 'Utah', 'utah', 'UT' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 91, 'US', 'Vermont', 'vermont', 'VT' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 92, 'US', 'Virginia', 'virginia', 'VA' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 93, 'US', 'Washington', 'washington', 'WA' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 94, 'US', 'West Virginia', 'west virginia', 'WV' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 95, 'US', 'Wisconsin', 'wisconsin', 'WI' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 96, 'US', 'Wyoming', 'wyoming', 'WY' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 97, 'US', 'American Samoa', 'american samoa', 'AS' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 98, 'US', 'Guam', 'guam', 'GU' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 99, 'US', 'Puerto Rico', 'puerto rico', 'PR' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 100, 'US', 'Virgin Islands', 'virgin islands', 'VI' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 101, 'US', 'Armed Forces Americas', 'armed forces americas', 'AA' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 102, 'US', 'Armed Forces Europe', 'armed forces europe', 'AE' );

INSERT INTO [ac_Provinces] ([ProvinceId], [CountryCode], [Name], [LoweredName], [ProvinceCode]) 
	VALUES ( 103, 'US', 'Armed Forces Pacific', 'armed forces pacific', 'AP' );

SET IDENTITY_INSERT [ac_Provinces] OFF;

-- </[ac_Provinces]>

GO

-- <[ac_Warehouses]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_Warehouses] ON;

INSERT INTO [ac_Warehouses] ( [WarehouseId], [StoreId], [Name], [CountryCode] )
	VALUES ( 1, 1, 'Default Warehouse', 'US' );

SET IDENTITY_INSERT [ac_Warehouses] OFF;

-- </[ac_Warehouses]>

GO

-- <[ac_OrderStatuses]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_OrderStatuses] ON;

INSERT INTO [ac_OrderStatuses] ([OrderStatusId], [StoreId], [Name], [DisplayName], [InventoryActionId], [IsActive], [IsValid], [OrderBy]) 
	VALUES ( 1, 1, 'Payment Pending', 'Payment Pending', 0, 0, 1, 1 );

INSERT INTO [ac_OrderStatuses] ([OrderStatusId], [StoreId], [Name], [DisplayName], [InventoryActionId], [IsActive], [IsValid], [OrderBy]) 
	VALUES ( 2, 1, 'Shipment Pending', 'Shipment Pending', 1, 1, 1, 2 );

INSERT INTO [ac_OrderStatuses] ([OrderStatusId], [StoreId], [Name], [DisplayName], [InventoryActionId], [IsActive], [IsValid], [OrderBy]) 
	VALUES ( 3, 1, 'Completed', 'Completed', 1, 1, 1, 3 );

INSERT INTO [ac_OrderStatuses] ([OrderStatusId], [StoreId], [Name], [DisplayName], [InventoryActionId], [IsActive], [IsValid], [OrderBy]) 
	VALUES ( 4, 1, 'Problem', 'Payment Pending', 2, 0, 1, 4 );

INSERT INTO [ac_OrderStatuses] ([OrderStatusId], [StoreId], [Name], [DisplayName], [InventoryActionId], [IsActive], [IsValid], [OrderBy]) 
	VALUES ( 5, 1, 'Cancelled', 'Cancelled', 2, 0, 0, 5 );

INSERT INTO [ac_OrderStatuses] ([OrderStatusId], [StoreId], [Name], [DisplayName], [InventoryActionId], [IsActive], [IsValid], [OrderBy]) 
	VALUES ( 6, 1, 'Fraud', 'Cancelled', 0, 0, 0, 6 );

SET IDENTITY_INSERT [ac_OrderStatuses] OFF;

-- </[ac_OrderStatuses]>

GO

-- <[ac_OrderStatusTriggers]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_OrderStatusTriggers] ON;

INSERT INTO [ac_OrderStatusTriggers] ([OrderStatusTriggerId], [StoreEventId], [OrderStatusId]) 
	VALUES ( 1, 100, 1 );

INSERT INTO [ac_OrderStatusTriggers] ([OrderStatusTriggerId], [StoreEventId], [OrderStatusId]) 
	VALUES ( 2, 102, 4 );

INSERT INTO [ac_OrderStatusTriggers] ([OrderStatusTriggerId], [StoreEventId], [OrderStatusId]) 
	VALUES ( 3, 105, 4 );

INSERT INTO [ac_OrderStatusTriggers] ([OrderStatusTriggerId], [StoreEventId], [OrderStatusId]) 
	VALUES ( 4, 106, 2 );

INSERT INTO [ac_OrderStatusTriggers] ([OrderStatusTriggerId], [StoreEventId], [OrderStatusId]) 
	VALUES ( 5, 109, 3 );

INSERT INTO [ac_OrderStatusTriggers] ([OrderStatusTriggerId], [StoreEventId], [OrderStatusId]) 
	VALUES ( 6, 117, 3 );

INSERT INTO [ac_OrderStatusTriggers] ([OrderStatusTriggerId], [StoreEventId], [OrderStatusId]) 
	VALUES ( 7, 115, 5 );

SET IDENTITY_INSERT [ac_OrderStatusTriggers] OFF;

-- </[ac_OrderStatusTriggers]>

GO

-- <[ac_PaymentMethods]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_PaymentMethods] ON;

INSERT INTO [ac_PaymentMethods] ([PaymentMethodId], [StoreId], [Name], [PaymentInstrumentId], [PaymentGatewayId], [OrderBy]) 
	VALUES ( 1, 1, 'Visa', 1, NULL, 1 );

INSERT INTO [ac_PaymentMethods] ([PaymentMethodId], [StoreId], [Name], [PaymentInstrumentId], [PaymentGatewayId], [OrderBy]) 
	VALUES ( 2, 1, 'MasterCard', 2, NULL, 2 );

INSERT INTO [ac_PaymentMethods] ([PaymentMethodId], [StoreId], [Name], [PaymentInstrumentId], [PaymentGatewayId], [OrderBy]) 
	VALUES ( 3, 1, 'American Express', 4, NULL, 3 );

INSERT INTO [ac_PaymentMethods] ([PaymentMethodId], [StoreId], [Name], [PaymentInstrumentId], [PaymentGatewayId], [OrderBy]) 
	VALUES ( 4, 1, 'Discover', 3, NULL, 4 );

INSERT INTO [ac_PaymentMethods] ([PaymentMethodId], [StoreId], [Name], [PaymentInstrumentId], [PaymentGatewayId], [OrderBy]) 
	VALUES ( 5, 1, 'PayPal', 7, NULL, 5 );

SET IDENTITY_INSERT [ac_PaymentMethods] OFF;

-- </[ac_PaymentMethods]>

GO

-- <[ac_TaxCodes]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_TaxCodes] ON;

INSERT INTO [ac_TaxCodes] ([TaxCodeId], [StoreId], [Name]) 
	VALUES ( 1, 1, 'Taxable' );

SET IDENTITY_INSERT [ac_TaxCodes] OFF;

-- </[ac_TaxCodes]>

GO

-- <[ac_ShipZones]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_ShipZones] ON;

INSERT INTO [ac_ShipZones] ([ShipZoneId], [StoreId], [Name], [CountryRuleId], [ProvinceRuleId], [PostalCodeFilter], [UsePCPM]) 
	VALUES ( 1, 1, 'Contiguous US', 1, 1, NULL, 0 );

INSERT INTO [ac_ShipZones] ([ShipZoneId], [StoreId], [Name], [CountryRuleId], [ProvinceRuleId], [PostalCodeFilter], [UsePCPM]) 
	VALUES ( 2, 1, 'Alaska and Hawaii', 1, 1, NULL, 0 );

SET IDENTITY_INSERT [ac_ShipZones] OFF;

-- </[ac_ShipZones]>

GO

-- <[ac_ShipZoneCountries]>

SET NOCOUNT ON;

INSERT INTO [ac_ShipZoneCountries] ([ShipZoneId], [CountryCode]) 
	VALUES ( 1, 'US' );

INSERT INTO [ac_ShipZoneCountries] ([ShipZoneId], [CountryCode]) 
	VALUES ( 2, 'US' );

-- </[ac_ShipZoneCountries]>

GO

-- <[ac_ShipZoneProvinces]>

SET NOCOUNT ON;

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 46, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 47, 2 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 48, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 49, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 50, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 51, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 52, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 53, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 54, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 55, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 56, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 57, 2 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 58, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 59, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 60, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 61, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 62, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 63, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 64, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 65, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 66, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 67, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 68, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 69, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 70, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 71, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 72, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 73, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 74, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 75, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 76, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 77, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 78, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 79, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 80, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 81, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 82, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 83, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 84, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 85, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 86, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 87, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 88, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 89, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 90, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 91, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 92, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 93, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 94, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 95, 1 );

INSERT INTO [ac_ShipZoneProvinces] ([ProvinceId], [ShipZoneId]) 
	VALUES ( 96, 1 );

-- </[ac_ShipZoneProvinces]>

GO

-- <[ac_EmailTemplates]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_EmailTemplates] ON;

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 1, 1, 'Customer Order Notification', 'customer', 'merchant', NULL, NULL, NULL, 'Confirmation - Order Number $order.OrderNumber', 'Customer Order Notification.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 3, 1, 'Lost Password', 'customer', 'merchant', NULL, NULL, NULL, 'Password Reset Request at $store.Name', 'Lost Password.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 4, 1, 'Low Inventory', 'merchant', 'merchant', NULL, NULL, NULL, 'Low Inventory Warning for $store.Name', 'Low Inventory.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 5, 1, 'Vendor Notification', 'vendor', 'merchant', NULL, NULL, NULL, 'Packing Slip - Shipment Notification for $store.Name', 'Vendor Notification.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 6, 1, 'Gift Certificate Validated', 'customer', 'merchant', NULL, NULL, NULL, 'Gift Certificate Validated for Order Number $order.OrderNumber', 'Gift Certificate Validated.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 7, 1, 'Order Shipped Partial', 'customer', 'merchant', NULL, NULL, NULL, 'Part of your order has shipped from $store.Name', 'Order Shipped Partial.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 8, 1, 'Order Shipped', 'customer', 'merchant', NULL, NULL, NULL, 'Your order has shipped from $store.Name', 'Order Shipped.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 9, 1, 'Product Review Verification', 'customer', 'merchant', NULL, NULL, NULL, 'Product Review Verfication', 'Product Review Verification.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 10, 1, 'Email List Signup With Verification', 'customer', 'merchant', NULL, NULL, NULL, 'Activation required to join $list.Name', 'Email List Signup With Verification.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 11, 1, 'Email List Signup Notification Only', 'customer', 'merchant', NULL, NULL, NULL, 'Thank you for joining $list.Name', 'Email List Signup Notification Only.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 12, 1, 'ESD File Activated', 'customer', 'merchant', NULL, NULL, NULL, 'Your digital good is available for download', 'ESD File Activated.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 13, 1, 'License Key Fulfilled', 'customer', 'merchant', NULL, NULL, NULL, 'Your License key for $orderItemDigitalGood.DigitalGood.Name is fulfilled', 'License Key Fulfilled.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 14, 1, 'Send Product To Friend', 'customer', 'merchant', NULL, NULL, NULL, '${fromName} wants you to see this item at $store.Name', 'Send Product To Friend.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 15, 1, 'Note Added By Customer', 'merchant', 'merchant', NULL, NULL, NULL, 'Customer added a note to Order Number $order.OrderNumber', 'Note Added By Customer.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 16, 1, 'Note Added By Merchant', 'customer', 'merchant', NULL, NULL, NULL, '$store.Name has added a message to your Order Number $order.OrderNumber', 'Note Added By Merchant.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 17, 1, 'Abandoned Basket Alert', 'customer', 'merchant', NULL, NULL, NULL, 'May we help you with your order?', 'Abandoned Basket Alert.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML]) 
	VALUES ( 18, 1, 'Products Review Reminder', 'customer', 'merchant', NULL, NULL, NULL, 'Invitation to Review Your Recent Purchase', 'Products Review Reminder.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 19, 1, 'Subscription Payment Reminder', 'customer', 'merchant', NULL, NULL, NULL, 'Subscription Pending Payment Reminder', 'Subscription Payment Reminder.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 20, 1, 'Subscription Expiration Notification', 'customer', 'merchant', NULL, NULL, NULL, 'Subscription Expiration Notification', 'Subscription Expiration Notification.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 21, 1, 'Subscription Expired', 'customer', 'merchant', NULL, NULL, NULL, 'Subscription Expired', 'Subscription Expired.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 22, 1, 'Subscription Enrollment', 'customer', 'merchant', NULL, NULL, NULL, 'Your subscription for $subscription.Name has been started', 'Subscription Enrollment.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 23, 1, 'Subscription Cancellation Notice', 'customer', 'merchant', NULL, NULL, NULL, 'Subscription Cancellation Notice($subscription.Name)', 'Subscription Cancellation Notice.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 24, 1, 'Subscription Updated', 'customer', 'merchant', NULL, NULL, NULL, 'Your subscription for $subscription.Name has been updated', 'Subscription Updated.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 25, 1, 'Contact Us Confirmation', 'customer', 'merchant', NULL, NULL, NULL, 'Thank you for contacting us', 'Contact Us Confirmation.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 26, 1, 'Affiliate Registration', 'customer', 'merchant', NULL, NULL, NULL, 'Welcome to our affiliate program', 'Affiliate Registration.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 27, 1, 'Restock Notification', 'recipient', 'merchant', NULL, NULL, NULL, 'Product Back in Stock', 'Restock Notification.html', 1 );

INSERT INTO [ac_EmailTemplates] ([EmailTemplateId], [StoreId], [Name], [ToAddress], [FromAddress], [ReplyToAddress], [CCList], [BCCList], [Subject], [ContentFileName], [IsHTML])
	VALUES ( 28, 1, 'Product Review Added By Customer', 'merchant', 'merchant', NULL, NULL, NULL, 'Customer submitted a product review', 'Product Review Submitted.html', 1 );

SET IDENTITY_INSERT [ac_EmailTemplates] OFF;

-- </[ac_EmailTemplates]>

GO

-- <[ac_EmailTemplateTriggers]>

SET NOCOUNT ON;

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 1, 100 );

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 3, 200 );

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 4, 300 );

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 5, 106 );

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 5, 117 );

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 6, 116 );

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 7, 110 );

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 8, 109 );
	
INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 15, 113 );

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 16, 112 );

INSERT INTO [ac_EmailTemplateTriggers] ([EmailTemplateId], [StoreEventId]) 
	VALUES ( 28, 600 );

-- </[ac_EmailTemplateTriggers]>

GO

-- <[ac_ProductTemplates]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_ProductTemplates] ON;

INSERT INTO [ac_ProductTemplates] ([ProductTemplateId], [StoreId], [Name]) 
	VALUES ( 1, 1, 'Book' );

INSERT INTO [ac_ProductTemplates] ([ProductTemplateId], [StoreId], [Name]) 
	VALUES ( 2, 1, 'Movie' );

INSERT INTO [ac_ProductTemplates] ([ProductTemplateId], [StoreId], [Name]) 
	VALUES ( 3, 1, 'TV' );

INSERT INTO [ac_ProductTemplates] ([ProductTemplateId], [StoreId], [Name]) 
	VALUES ( 4, 1, 'Personalized' );

SET IDENTITY_INSERT [ac_ProductTemplates] OFF;

-- </[ac_ProductTemplates]>

GO

-- <[ac_InputFields]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_InputFields] ON;

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 1, 1, 'Author', 'Author:', 2, 0, 0, 0, 0, NULL, 1, 0, 1, 0 );

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 2, 1, 'ISBN', 'ISBN:', 2, 0, 0, 0, 0, NULL, 1, 0, 2, 0 );

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 3, 2, 'Director', 'Director:', 2, 0, 0, 0, 0, NULL, 1, 0, 1, 0 );

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 4, 2, 'Actors', 'Actors:', 2, 0, 0, 0, 0, NULL, 1, 0, 2, 0 );

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 5, 2, 'Rating', 'Rating:', 4, 0, 0, 0, 0, NULL, 1, 0, 3, 0 );

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 13, 3, 'Model', 'Model', 2, 0, 0, 0, 0, NULL, 1, 0, 1, 0 );

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 14, 3, 'Description', 'Description', 2, 0, 0, 0, 0, NULL, 1, 0, 2, 0 );

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 15, 3, 'Resolution', 'Resolution', 2, 0, 0, 0, 0, NULL, 1, 0, 3, 0 );

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 16, 3, 'Includes', 'Includes', 8, 0, 0, 0, 0, NULL, 1, 0, 4, 0 );

INSERT INTO [ac_InputFields] ([InputFieldId], [ProductTemplateId], [Name], [UserPrompt], [InputTypeId], [Rows], [Columns], [MaxLength], [IsRequired], [RequiredMessage], [IsMerchantField], [UseShopBy], [OrderBy], [PersistWithOrder]) 
	VALUES ( 17, 4, 'Personalization', 'Enter the recipients name below: (30 char max)', 2, 0, 30, 30, 0, NULL, 0, 0, 1, 0 );

SET IDENTITY_INSERT [ac_InputFields] OFF;

-- </[ac_InputFields]>

GO

-- <[ac_InputChoices]>

SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_InputChoices] ON;

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 1, 5, 'G', NULL, 0, 1 );

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 2, 5, 'PG', NULL, 0, 2 );

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 3, 5, 'PG-13', NULL, 0, 3 );

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 4, 5, 'R', NULL, 0, 4 );

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 16, 16, 'Integrated pedestal stand and 20W integrated speaker system', NULL, 0, 1 );

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 17, 16, 'NTSC and ATSC (HDTV) tuners', NULL, 0, 2 );

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 18, 16, '2 HDMI inputs', NULL, 0, 3 );

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 19, 16, '2 component video', NULL, 0, 4 );

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 20, 16, '3 composite video', NULL, 0, 5 );

INSERT INTO [ac_InputChoices] ([InputChoiceId], [InputFieldId], [ChoiceText], [ChoiceValue], [IsSelected], [OrderBy]) 
	VALUES ( 21, 16, '3 S-Video connection', NULL, 0, 6 );

SET IDENTITY_INSERT [ac_InputChoices] OFF;

-- </[ac_InputChoices]>

GO

-- <[ac_Webpages]>
SET NOCOUNT ON;
SET IDENTITY_INSERT [ac_Webpages] ON;

INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (1, 1, N'Category Grid (Deep Item Display)', N'Displays products for the selected category and all of it''s sub-categories. Items are displayed in a grid format with breadcrumb links, sorting, page navigation, and sub-category link options.', N'[[ConLib:CategoryGridPage Cols="3" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="True" DefaultCaption="Catalog" ShowSummary="False" ShowDescription="False"]]', NULL, NULL, NULL, NULL, 0, 1)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (2, 1, N'Category Details Page', N'Displays categories, products, webpages, and links for only the selected category.  Items are displayed in a left-aligned, row format, with descriptions and images.', N'[[ConLib:CategoryDetailsPage DefaultCaption="Catalog" DefaultCategorySummary="Welcome to our store." PagingLinksLocation="BOTTOM" ShowSummary="True" ShowDescription="False"]]', NULL, NULL, NULL, NULL, 0, 1)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (3, 1, N'Category Grid 2 (Shallow Item Display)', N'Displays products for only the selected category.  Items are displayed in a grid format with breadcrumb links, sorting, page navigation, and sub-category link options.', N'[[ConLib:CategoryGridPage2 Cols="3" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="True" DefaultCaption="Catalog" ShowSummary="False" ShowDescription="False"]]', NULL, NULL, NULL, NULL, 0, 1)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (4, 1, N'Category Grid 3 (Deep Item Display) With Add To Basket', N'Displays products for the selected category and all of it''s sub-categories. Items are displayed in a grid format, each with a quantity box so user can purchase multiple items with one click.  Includes breadcrumb links, sorting, page navigation, and sub-cat', N'[[ConLib:CategoryGridPage3 Cols="3" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="True" DefaultCaption="Catalog" ShowSummary="False" ShowDescription="False"]]', NULL, NULL, NULL, NULL, 0, 1)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (5, 1, N'Category Grid 4 (Shallow Item Display) With Category Data', N'Displays categories, products, webpages, and links for only the selected category.  Items are displayed in a grid format with breadcrumb links, sorting, and page navigation.', N'[[ConLib:CategoryGridPage4 Cols="3" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="True" DefaultCaption="Catalog" ShowSummary="False" ShowDescription="True"]]', NULL, NULL, NULL, NULL, 0, 1)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (6, 1, N'Category List', N'Displays products for only the selected category.  Items are displayed in a row format with columns for SKU, manufacturer, and pricing.  Includes breadcrumb links, sorting, page navigation, and sub-category link options.', N'[[ConLib:CategoryListPage PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="True" DefaultCaption="Catalog" PageSize="20" ShowSummary="False" ShowDescription="False"]]', NULL, NULL, NULL, NULL, 0, 1)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (7, 1, N'Basic Product', N'A product display page that shows the basic product details.', N'[[ConLib:ProductPage OptionsView="DROPDOWN" ShowVariantThumbnail="False" ShowAddAndUpdateButtons="False" ShowPartNumber="False" GTINName="GTIN" ShowGTIN="False" DisplayBreadCrumbs="True"]]', NULL, NULL, NULL, NULL, 0, 2)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (8, 1, N'Product with Options Grid', N'A product display page that shows all variants of a product in a grid layout.  This display page should not be used with products having more than 8 options.', N'[[ConLib:ProductPage OptionsView="TABULAR" ShowVariantThumbnail="False" ShowAddAndUpdateButtons="False" ShowPartNumber="False" GTINName="GTIN" ShowGTIN="False" DisplayBreadCrumbs="True"]]', NULL, NULL, NULL, NULL, 0, 2)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (9, 1, N'Home Page', N'Home page.', N'<p>Hello and welcome to your store! To edit this text, log in to the merchant administration. From the menu bar, select Website &gt; Webpages. Then you can edit the Home Page to modify this content.</p>
[[ConLib:FeaturedProductsGrid IncludeOutOfStockItems="False" Caption="Featured Products" MaxItems="4" Columns="2"]]', NULL, NULL, N'~/Layouts/LeftSidebar.master', NULL, 0, 0)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (10, 1, N'Contact Us', N'Standard contact us page.', N'<h2>Contact Us</h2>  [[ConLib:ContactUs EnableCaptcha="False" EnableConfirmationEmail="True" ConfirmationEmailTemplateId="0" Subject="New Contact Message" SendTo=""]] <br /><p>Need help placing your order or have a question about an order you placed? You can call us toll free at 1-800-555-0199. </p><p>Our Business Address Is:<br />123 Anywhere Lane<br />Corona, CA 92882 </p>
<p>To edit this text, log in to the merchant administration. From the menu bar, select Website &gt; Webpages. Then you can edit the Contact Us page to modify this content.</p> ', NULL, NULL, N'~/Layouts/OneColumn.master', NULL, 0, 0)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [MetaDescription], [MetaKeywords]) VALUES (11, 1, N'Product Display in Rows', N'A product display page that shows the product details in rows.', N'[[ConLib:ProductRow OptionsView="DROPDOWN" ShowVariantThumbnail="False" ShowAddAndUpdateButtons="False" ShowPartNumber="False" GTINName="GTIN" ShowGTIN="False" DisplayBreadCrumbs="True"]]', NULL, NULL, NULL, NULL, 0, 2, NULL, NULL)
INSERT INTO [ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId]) VALUES (12, 1, N'Article Listing', N'A category page that displays webpages of a category with summary description in a row format.', N'[[ConLib:ArticleListing DefaultCaption="Blog" DefaultCategorySummary="Welcome to our store blog." PagingLinksLocation="BOTTOM" ShowSummary="True" ShowDescription="False" DisplayBreadCrumbs="True" DefaultPageSize="5"]]', NULL, NULL, NULL, NULL, 0, 1)
SET IDENTITY_INSERT [ac_Webpages] OFF

SET IDENTITY_INSERT [ac_CustomUrls] ON
INSERT INTO [ac_CustomUrls] ([CustomUrlId], [StoreId], [CatalogNodeId], [CatalogNodeTypeId], [Url], [LoweredUrl]) VALUES (1, 1, 9, 2, N'Default.aspx', N'default.aspx')
INSERT INTO [ac_CustomUrls] ([CustomUrlId], [StoreId], [CatalogNodeId], [CatalogNodeTypeId], [Url], [LoweredUrl]) VALUES (2, 1, 10, 2, N'ContactUs.aspx', N'contactus.aspx')
SET IDENTITY_INSERT [ac_CustomUrls] OFF

-- </[ac_Webpages]>