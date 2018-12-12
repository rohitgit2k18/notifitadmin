--Store
-- Custom Update

--Warehouse
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Warehouses ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Warehouses(WarehouseId, StoreId, Name, Address1, Address2, City, Province, PostalCode, CountryCode, Phone, Fax, Email)
SELECT * FROM prod_allmark.dbo.ac_Warehouses
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Warehouses OFF

--Users
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Users ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Users (UserId, StoreId, UserName, LoweredUserName, Email, LoweredEmail, AffiliateId, AffiliateReferralDate, PrimaryWishlistId, PayPalId, PasswordQuestion, PasswordAnswer, IsApproved, IsAnonymous, IsLockedOut, CreateDate, LastActivityDate, LastLoginDate, LastPasswordChangedDate, LastLockoutDate, FailedPasswordAttemptCount, FailedPasswordAttemptWindowStart, FailedPasswordAnswerAttemptCount, FailedPasswordAnswerAttemptWindowStart, TaxExemptionType, Comment)
SELECT UserId, StoreId, UserName, LoweredUserName, Email, LoweredEmail, AffiliateId, AffiliateReferralDate, PrimaryWishlistId, PayPalId, PasswordQuestion, PasswordAnswer, IsApproved, IsAnonymous, IsLockedOut, CreateDate, LastActivityDate, LastLoginDate, LastPasswordChangedDate, LastLockoutDate, FailedPasswordAttemptCount, FailedPasswordAttemptWindowStart, FailedPasswordAnswerAttemptCount, FailedPasswordAnswerAttemptWindowStart, 0, Comment FROM prod_allmark.dbo.ac_Users
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Users OFF

--UserSettings
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_UserSettings ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_UserSettings (UserSettingId, UserId, FieldName, FieldValue)
SELECT * FROM prod_allmark.dbo.ac_UserSettings
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_UserSettings OFF

--UserPasswords
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_UserPasswords (UserId, PasswordNumber, Password, PasswordFormat, CreateDate, ForceExpiration) 
SELECT UserId, PasswordNumber, Password, PasswordFormat, CreateDate, ForceExpiration FROM prod_allmark.dbo.ac_UserPasswords

--Webpages
-- Custom Update

--VolumeDiscounts
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_VolumeDiscounts ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_VolumeDiscounts (VolumeDiscountId, StoreId, Name, IsValueBased, IsGlobal)
SELECT * FROM prod_allmark.dbo.ac_VolumeDiscounts
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_VolumeDiscounts OFF

--VolumeDiscountLevels
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_VolumeDiscountLevels ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_VolumeDiscountLevels (VolumeDiscountLevelId, VolumeDiscountId, MinValue, MaxValue, DiscountAmount, IsPercent)
SELECT * FROM prod_allmark.dbo.ac_VolumeDiscountLevels
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_VolumeDiscountLevels OFF


--TaxCodes
--Leave

--StoreSettings (Allmark-AbleCommerce)
-- Custom Update

--Roles
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Roles ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Roles (RoleId, Name, LoweredName)
SELECT * FROM prod_allmark.dbo.ac_Roles
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Roles OFF

--Manufacturers
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Manufacturers ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Manufacturers (ManufacturerId, StoreId, Name)
SELECT * FROM prod_allmark.dbo.ac_Manufacturers
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Manufacturers OFF

--Options
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Options ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Options (OptionId, Name, HeaderText, ShowThumbnails, ThumbnailColumns, ThumbnailWidth, ThumbnailHeight, CreatedDate)
SELECT * FROM prod_allmark.dbo.ac_Options
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Options OFF

--OptionChoices
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_OptionChoices ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_OptionChoices (OptionChoiceId, OptionId, Name, ThumbnailUrl, ImageUrl, PriceModifier, CogsModifier, WeightModifier, SkuModifier, OrderBy, Selected)
SELECT OptionChoiceId, OptionId, Name, ThumbnailUrl, ImageUrl, PriceModifier, CogsModifier, WeightModifier, SkuModifier, OrderBy, 0 FROM prod_allmark.dbo.ac_OptionChoices
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_OptionChoices OFF

--Products
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Products ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Products (ProductId, StoreId, Name, Price, CostOfGoods, MSRP, Weight, Length, Width, Height, ManufacturerId, Sku, ModelNumber, WebpageId,
TaxCodeId, ShippableId, WarehouseId, InventoryModeId, InStock, AvailabilityDate, InStockWarningLevel, ThumbnailUrl, ThumbnailAltText, ImageUrl, ImageAltText, Summary, Description,
ExtendedDescription, VendorId, CreatedDate, LastModifiedDate, IsFeatured, IsProhibited, AllowReviews, AllowBackorder, WrapGroupId, ExcludeFromFeed, DisablePurchase, MinQuantity,
MaxQuantity,VisibilityId, IconUrl, IconAltText, IsGiftCertificate, UseVariablePrice, MinimumPrice, MaximumPrice, HandlingCharges, HidePrice, EnableGroups, Title, HtmlHead,
MetaDescription, MetaKeywords, SearchKeywords, GTIN, GoogleCategory, Condition, Gender, AgeGroup, Color, Size, AdwordsGrouping, AdwordsLabels, ExcludedDestination, AdwordsRedirect, 
PublishFeedAsVariants, TIC, EnableRestockNotifications, OrderBy, RowVersion)
SELECT ProductId, StoreId, Name, Price, CostOfGoods, MSRP, Weight, Length, Width, Height, ManufacturerId, Sku, ModelNumber, NULL,
TaxCodeId, ShippableId, WarehouseId, InventoryModeId, InStock, NULL, InStockWarningLevel, ThumbnailUrl, ThumbnailAltText, ImageUrl, ImageAltText, Summary, Description,
ExtendedDescription, VendorId, CreatedDate, LastModifiedDate, IsFeatured, IsProhibited, AllowReviews, AllowBackorder, WrapGroupId, ExcludeFromFeed, DisablePurchase, MinQuantity,
MaxQuantity,VisibilityId, IconUrl, IconAltText, IsGiftCertificate, UseVariablePrice, MinimumPrice, MaximumPrice, NULL, HidePrice, 0, NULL, HtmlHead,
NULL, NULL, SearchKeywords, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
0, NULL, 0, 0, 0 FROM prod_allmark.dbo.ac_Products
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Products OFF

--ProductVolumeDiscounts
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_ProductVolumeDiscounts (ProductId, VolumeDiscountId)
SELECT * FROM prod_allmark.dbo.ac_ProductVolumeDiscounts

--ProductOptions
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_ProductOptions (ProductId, OptionId, OrderBy)
SELECT ProductId, OptionId, OrderBy FROM prod_allmark.dbo.ac_ProductOptions

--ProductCustomFields
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_ProductCustomFields ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_ProductCustomFields (ProductFieldId, ProductId, IsUserDefined, IsVisible, FieldName, FieldValue)
SELECT * FROM prod_allmark.dbo.ac_ProductCustomFields
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_ProductCustomFields OFF

--PaymentMethods
--Leave

--PageViews
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_PageViews ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_PageViews (PageViewId, StoreId, ActivityDate, RemoteIP, RequestMethod, UserId, UriStem, UriQuery, TimeTaken, UserAgent, Referrer, CatalogNodeId, CatalogNodeTypeId, Browser, BrowserName, BrowserPlatform, BrowserVersion, AffiliateId)
SELECT * FROM prod_allmark.dbo.ac_PageViews
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_PageViews OFF

--Orders
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Orders ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Orders (OrderId, OrderNumber, OrderDate, StoreId, UserId, AffiliateId, BillToFirstName, BillToLastName, BillToAddress1, BillToAddress2, 
BillToCity, BillToProvince, BillToCountryCode, BillToPhone, BillToFax, BillToEmail, ProductSubtotal, TotalCharges, TotalPayments, OrderStatusId, Exported, RemoteIP, Referrer, 
GoogleOrderNumber, PaymentStatusId, ShipmentStatusId, TaxExemptionType, TaxExemptionReference, IsSubscriptionGenerated)
SELECT OrderId, OrderNumber, OrderDate, StoreId, UserId, AffiliateId, BillToFirstName, BillToLastName, BillToAddress1, BillToAddress2, 
BillToCity, BillToProvince, BillToCountryCode, BillToPhone, BillToFax, BillToEmail, ProductSubtotal, TotalCharges, TotalPayments, OrderStatusId, Exported, RemoteIP, Referrer, 
GoogleOrderNumber, PaymentStatusId, ShipmentStatusId, 0, NULL, 0 FROM prod_allmark.dbo.ac_Orders
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Orders OFF

--OrderStatusTriggers
--Leave

--OrderStatuses
-- Leave

--OrderShipments
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_OrderShipments ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_OrderShipments (OrderShipmentId, OrderId, WarehouseId, ShipToFirstName, ShipToLastName, ShipToCompany, ShipToAddress1, ShipToAddress2, 
ShipToCity, ShipToProvince, ShipToPostalCode, ShipToCountryCode, ShipToPhone, ShipToFax, ShipToEmail, ShipToResidence, ShipMethodId, ShipMethodName, ShipMessage, ShipDate, 
ShipStationId, ProviderShipmentNumber)
SELECT OrderShipmentId, OrderId, WarehouseId, ShipToFirstName, ShipToLastName, ShipToCompany, ShipToAddress1, ShipToAddress2, 
ShipToCity, ShipToProvince, ShipToPostalCode, ShipToCountryCode, ShipToPhone, ShipToFax, ShipToEmail, ShipToResidence, ShipMethodId, ShipMethodName, ShipMessage, ShipDate, 
NULL, NULL FROM prod_allmark.dbo.ac_OrderShipments
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_OrderShipments OFF

--OrderNotes
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_OrderNotes ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_OrderNotes (OrderNoteId, OrderId, UserId, CreatedDate, Comment, IsRead, NoteTypeId)
SELECT * FROM prod_allmark.dbo.ac_OrderNotes
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_OrderNotes OFF

--OrderItems
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_OrderItems ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_OrderItems (OrderItemId, OrderId, ParentItemId, OrderItemTypeId, ShippableId, OrderShipmentId, ProductId, Name, OptionList, 
VariantName, Sku, Price, Weight, CostOfGoods, Quantity, LineMessage, OrderBy, GiftMessage, TaxCodeId, WrapStyleId, WishlistItemId, InventoryStatusId, TaxRate, TaxAmount, KitList, CustomFields, 
IsSubscription, Frequency, FrequencyUnitId)
SELECT OrderItemId, OrderId, ParentItemId, OrderItemTypeId, ShippableId, OrderShipmentId, ProductId, Name, OptionList, 
VariantName, Sku, Price, Weight, CostOfGoods, Quantity, LineMessage, OrderBy, GiftMessage, TaxCodeId, WrapStyleId, WishlistItemId, InventoryStatusId, TaxRate, TaxAmount, KitList, CustomFields, 
0, 0, 0 FROM prod_allmark.dbo.ac_OrderItems
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_OrderItems OFF

--Groups
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Groups ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Groups (GroupId, StoreId, Name, Description, IsReadOnly)
SELECT GroupId, StoreId, Name, Description, 0 FROM prod_allmark.dbo.ac_Groups
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Groups OFF

--UserGroups
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_UserGroups (UserId, GroupId, SubscriptionId) 
SELECT UserId, GroupId, SubscriptionId FROM prod_allmark.dbo.ac_UserGroups

--GroupRoles
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_GroupRoles (GroupId, RoleId)
SELECT * FROM prod_allmark.dbo.ac_GroupRoles

--EmailTemplates
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_EmailTemplates ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_EmailTemplates (EmailTemplateId, StoreId, Name, ToAddress, FromAddress, ReplyToAddress, CCList, BCCList, Subject, ContentFileName, IsHTML)
SELECT * FROM prod_allmark.dbo.ac_EmailTemplates
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_EmailTemplates OFF

--EmailTemplateTriggers
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_EmailTemplateTriggers (EmailTemplateId, StoreEventId) 
SELECT EmailTemplateId, StoreEventId FROM prod_allmark.dbo.ac_EmailTemplateTriggers

--CustomUrls (Allmark-AbleCommerce)
-- Custom Update

--CustomFields
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_CustomFields ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_CustomFields (CustomFieldId, StoreId, TableName, ForeignKeyId, FieldName, FieldValue)
SELECT * FROM prod_allmark.dbo.ac_CustomFields
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_CustomFields OFF

--Categories
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Categories ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Categories (CategoryId, StoreId, ParentId, Name, Summary, Description, ThumbnailUrl, ThumbnailAltText, VisibilityId, HtmlHead) 
SELECT CategoryId, StoreId, ParentId, Name, Summary, Description, ThumbnailUrl, ThumbnailAltText, VisibilityId, HtmlHead FROM prod_allmark.dbo.ac_Categories
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Categories OFF

--CategoryParents
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_CategoryParents (CategoryId, ParentId, ParentLevel, ParentNumber) 
SELECT CategoryId, ParentId, ParentLevel, ParentNumber FROM prod_allmark.dbo.ac_CategoryParents

--CatalogNodes
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_CatalogNodes(CategoryId, CatalogNodeId, CatalogNodeTypeId, OrderBy)
SELECT CategoryId, CatalogNodeId, CatalogNodeTypeId, OrderBy FROM prod_allmark.dbo.ac_CatalogNodes

--Addresses
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Addresses ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Addresses (AddressId, UserId, Nickname, FirstName, LastName, Company, Address1, Address2, City, Province, PostalCode, CountryCode, Phone, Fax, Email, Residence, Validated, IsBilling) 
SELECT AddressId, UserId, Nickname, FirstName, LastName, Company, Address1, Address2, City, Province, PostalCode, CountryCode, Phone, Fax, Email, Residence, Validated, 0 FROM prod_allmark.dbo.ac_Addresses
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Addresses OFF

--Baskets
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Baskets ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_Baskets (BasketId, UserId, ContentHash)
SELECT * FROM prod_allmark.dbo.ac_Baskets
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_Baskets OFF

--BasketShipments
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_BasketShipments ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_BasketShipments(BasketShipmentId, BasketId, WarehouseId, ShipMethodId, AddressId, ShipMessage)
SELECT * FROM prod_allmark.dbo.ac_BasketShipments
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_BasketShipments OFF

--BasketItems
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_BasketItems ON
INSERT INTO [Allmark-AbleCommerce-Test].dbo.ac_BasketItems (BasketItemId, ParentItemId, BasketId, BasketShipmentId, ProductId, OptionList, TaxCodeId, Name, Sku, Price, Weight, 
Quantity, LineMessage, OrderItemTypeId, OrderBy, WrapStyleId, GiftMessage, WishlistItemId, ShippableId, CreatedDate, LastModifiedDate, TaxRate, TaxAmount, KitList, CustomFields, 
IsSubscription, Frequency, FrequencyUnitId)
SELECT BasketItemId, ParentItemId, BasketId, BasketShipmentId, ProductId, OptionList, TaxCodeId, Name, Sku, Price, Weight, 
Quantity, LineMessage, OrderItemTypeId, OrderBy, WrapStyleId, GiftMessage, WishlistItemId, ShippableId, GETDATE(), LastModifiedDate, TaxRate, TaxAmount, KitList, CustomFields, 
0, 0, 0 FROM prod_allmark.dbo.ac_BasketItems
SET IDENTITY_INSERT [Allmark-AbleCommerce-Test].dbo.ac_BasketItems OFF