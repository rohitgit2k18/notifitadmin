use [Allmark-AbleCommerce-Test]

UPDATE ac_Stores
SET NextOrderId = 3557
WHERE StoreId = 1;

SET IDENTITY_INSERT dbo.ac_CustomUrls ON
INSERT INTO dbo.ac_CustomUrls(CustomUrlId, StoreId, CatalogNodeId, CatalogNodeTypeId, Url, LoweredUrl)
VALUES(2,	1,	10,	2,	'ContactUs.aspx','contactus.aspx'),
(3,	1,	13,	2,	'default.aspx',	'default.aspx'),
(4,	1,	2,	2,	'FAQ.aspx',	'faq.aspx'),
(5,	1,	4,	2,	'TermsConditions.aspx',	'termsconditions.aspx'),
(6,	1,	1,	2,	'AboutUs.aspx',	'aboutus.aspx');
SET IDENTITY_INSERT dbo.ac_CustomUrls OFF

SET IDENTITY_INSERT dbo.ac_StoreSettings ON
INSERT INTO dbo.ac_StoreSettings(StoreSettingId, StoreId, FieldName, FieldValue)
VALUES(1,	1, 'ProductReviewEnabled',	'2'),
(2,	1,	'ProductReviewApproval',	'3'),
(3,	1,	'ProductReviewImageVerification',	'3'),
(4,	1,	'ProductReviewEmailVerification',	'1'),
(5,	1,	'PageViewTrackingEnabled',	'True'),
(6,	1,	'PageViewTrackingSaveArchive',	'False'),
(7,	1,	'PageViewTrackingDays',	'7'),
(8,	1,	'StoreTheme', ''),
(11,	1,	'ProductPurchasingDisabled',	'False'),
(12,	1,	'MerchantPasswordMinLength',	'8'),
(13,	1,	'MerchantPasswordRequireUpper',	'True'),
(14,	1,	'MerchantPasswordRequireLower',	'True'),
(15,	1,	'MerchantPasswordRequireNonAlpha',	'True'),
(16,	1,	'MerchantPasswordMaxAge',	'30'),
(17,	1,	'MerchantPasswordHistoryCount',	'4'),
(18,	1,	'MerchantPasswordHistoryDays',	'10'),
(19,	1,	'MerchantPasswordMaxAttempts',	'6'),
(20,	1,	'MerchantPasswordLockoutPeriod',	'30'),
(21,	1,	'MerchantPasswordInactivePeriod',	'3'),
(22,	1,	'CustomerPasswordMinLength',	'6'),
(23,	1,	'CustomerPasswordRequireUpper',	'True'),
(24,	1,	'CustomerPasswordRequireLower',	'True'),
(25,	1,	'CustomerPasswordRequireNonAlpha',	'True'),
(26,	1,	'CustomerPasswordMaxAge',	'0'),
(27,	1,	'CustomerPasswordHistoryCount',	'0'),
(28,	1,	'CustomerPasswordMaxAttempts',	'6'),
(29,	1,	'CustomerPasswordLockoutPeriod',	'30'),
(30,	1,	'BaseCurrencyId',	'1'),
(31,	1,	'IconImageSize',	'50'),
(32,	1,	'ThumbnailImageSize',	'120'),
(33,	1,	'StandardImageSize',	'500'),
(34,	1,	'ImageSkuLookupEnabled',	'False'),
(35,	1,	'OptionThumbnailHeight',	'80'),
(36,	1,	'OptionThumbnailWidth',	'120'),
(37,	1,	'OptionThumbnailColumns',	'2'),
(38,	1,	'ProductReviewEmailVerificationTemplate',	'0'),
(39,	1,	'ProductReviewTermsAndConditions', ''),
(40,	1,	'VolumeDiscountMode',	'0'),
(41,	1,	'Store_TimeZoneCode',	'8'),
(42,	1,	'Store_TimeZoneOffset',	'8'),
(43,	1,	'SiteDisclaimerMessage', ''),	
(44,	1,	'EnableInventory',	'True'),
(45,	1,	'InventoryDisplayDetails',	'True'),
(46,	1,	'InventoryInStockMessage',	'{0} units available'),
(47,	1,	'InventoryOutOfStockMessage',	'The product is currently out of stock, current quantity is {0}.'), 
(48,	1,	'CheckoutTermsAndConditions', ''),
(49,	1,	'OrderMinimumAmount',	'0'),
(50,	1,	'OrderMaximumAmount',	'0'),
(51,	1,	'AnonymousUserLifespan',	'30'),
(52,	1,	'AnonymousAffiliateUserLifespan',	'30'),
(53,	1,	'GiftCertificateDaysToExpire',	'0'),
(54,	1,	'PostalCodeCountries',	'US,CA'),
(55,	1,	'FileExt_Assets',	'gif, jpg, png'),
(56,	1,	'FileExt_Themes',	'gif, jpg, png, skin, css, htm, html'),
(57,	1,	'FileExt_DigitalGoods',	'zip'),
(58,	1,	'Email_DefaultAddress',	'a3ecb33eed319cc65d58c0d4e042cac4@inbound.postmarkapp.com'),
(59,	1,	'Email_SubscriptionAddress',	'info@yourdomain.xyz'),
(60,	1,	'ProductTellAFriendEmailTemplateId',	'14'),
(61,	1,	'AbandonedBasketAlertEmailTemplateId',	'17'),
(62,	1,	'WebpagesDefaultLayout',	'~/Layouts/LeftSidebar.master'),
(63,	1,	'CategoriesDefaultLayout',	'~/Layouts/Category.master'),
(64,	1,	'ProductsDefaultLayout',	'~/Layouts/Product.master'),
(65,	1,	'CategoryWebpageId',	'3'),
(66,	1,	'ProductWebpageId',	'7'),
(67,	1,	'EnableCustomerOrderNotes',	'True'),
(68,	1,	'ProductReviewReminderEmailTemplate',	'29'),
(69,	1,	'EnableShipToMultipleAddresses',	'True'),
(70,	1,	'ROPaymentReminderEmailTemplateId',	'30'),
(71,	1,	'ROExpirationReminderEmailTemplateId',	'31'),
(72,	1,	'ROSubscriptionExpiredEmailTemplateId',	'32'),
(73,	1,	'ROSubscriptionEnrollmentEmailTemplateId',	'33'),
(74,	1,	'ROSubscriptionCancellationEmailTemplateId',	'34'),
(75,	1,	'ROSubscriptionUpdatedEmailTemplateId',	'35'),
(76,	1,	'EnablePartialPaymentCheckouts',	'False'),
(77,	1,	'ContactUsConfirmationEmailTemplateId',	'36'),
(78,	1,	'AffiliateRegistrationEmailTemplateId',	'37'),
(79,	1,	'InventoryRestockNotificationEmailTemplateId',	'38'),
(80,	1,	'Store_StoreUrl',	'http://allmark-public.redisstest.com.au/'),
(81,	1,	'IconImageWidth',	'50'),
(82,	1,	'IconImageHeight',	'50'),
(83,	1,	'ThumbnailImageWidth',	'260'),
(84,	1,	'ThumbnailImageHeight',	'380'),
(85,	1,	'StandardImageWidth',	'800'),
(86,	1,	'StandardImageHeight',	'800'),
(87,	1,	'InventoryAvailabilityMessage',	'More stock is expected on {0}.'),
(88,	1,	'InventoryRestockNotificationLink',	'Notify me when this is available'),
(89,	1,	'AcceptOrdersWithInvalidPayment',	'False'),
(90,	1,	'EnableOnePageCheckout',	'False'),
(91,	1,	'AllowAnonymousCheckout',	'True'),
(92,	1,	'AllowAnonymousCheckoutForDigitalGoods',	'False'),
(93,	1,	'EnableShipMessage',	'False'),
(94,	1,	'WishlistsEnabled',	'True'),
(95,	1,	'RestrictStoreAccess',	'0'),
(96,	1,	'WishlistSearchEnabled',	'False'),
(97,	1,	'MinimumSearchLength',	'1'),
(98,	1,	'PopularSearchThreshold',	'3'),
(99,	1,	'CategorySearchDisplayLimit',	'0'),
(100,	1,	'EnablePaymentProfilesStorage',	'False'),
(101,	1,	'EnableWysiwygEditor',	'True'),
(102,	1,	'Email_SmtpServer',	'mail.redisoftsol.com.au'),
(103,	1,	'Email_SmtpPort',	'25'),
(104,	1,	'Email_EnableSSL',	'False'),
(105,	1,	'Email_SmtpUserName',	'sender@redisoftsol.com.au'),
(106,	1,	'Email_SmtpPassword',	'Letsgo.123'),
(107,	1,	'Email_SmtpRequiresAuthentication',	'True'),
(108,	1,	'SubscriptionRequestExpirationDays',	'7'),
(109,	1,	'DefaultEmailListId',	'0'),
(110,	1,	'ProductTellAFriendCaptcha',	'False'),
(111,	1,	'SSLEnabled	False', ''),
(112,	1,	'SSLUnencryptedUri', ''),	
(113,	1,	'SSLEncryptedUri', ''),	
(114,	1,	'MobileStoreDomain', ''),	
(115,	1,	'PaymentLifespan',	'0'),
(116,	1,	'EnableCreditCardStorage',	'True'),
(117,	1,	'ProductReviewSubmittedEmailTemplateId',	'39');
SET IDENTITY_INSERT dbo.ac_StoreSettings OFF

SET IDENTITY_INSERT [dbo].[ac_Webpages] ON 
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (1, 1, N'Category Grid (Deep Item Display)', N'Displays products for the selected category and all of it''s sub-categories. Items are displayed in a grid format with breadcrumb links, sorting, page navigation, and sub-category link options.', N'[[ConLib:CategoryGridPage Cols="3" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="True" DefaultCaption="Catalog" ShowSummary="False" ShowDescription="False"]]', NULL, N'Category Grid (Deep Item Display)', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (2, 1, N'Category Details Page', N'Displays categories, products, webpages, and links for only the selected category.  Items are displayed in a left-aligned, row format, with descriptions and images.', N'[[ConLib:CategoryDetailsPage DefaultCaption="Catalog" DefaultCategorySummary="Welcome to our store." PagingLinksLocation="BOTTOM" ShowSummary="True" ShowDescription="False"]]', NULL, N'Category Details Page', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (3, 1, N'Category Grid 2 (Shallow Item Display)', N'Displays products for only the selected category.  Items are displayed in a grid format with breadcrumb links, sorting, page navigation, and sub-category link options.', N'[[ConLib:CategoryGridPage2 Cols="4" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="False" DefaultCaption="Catalog" ShowSummary="False" ShowDescription="True"]]', NULL, N'Category Grid 2 (Shallow Item Display)', N'~/Layouts/OneColumn.master', NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (4, 1, N'Category Grid 3 (Deep Item Display) With Add To Basket', N'Displays products for the selected category and all of it''s sub-categories. Items are displayed in a grid format, each with a quantity box so user can purchase multiple items with one click.  Includes breadcrumb links, sorting, page navigation, and sub-cat', N'[[ConLib:CategoryGridPage3 Cols="3" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="True" DefaultCaption="Catalog" ShowSummary="False" ShowDescription="False"]]', NULL, N'Category Grid 3 (Deep Item Display) With Add To Basket', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (5, 1, N'Category Grid 4 (Shallow Item Display) With Category Data', N'Displays categories, products, webpages, and links for only the selected category.  Items are displayed in a grid format with breadcrumb links, sorting, and page navigation.', N'[[ConLib:CategoryGridPage4 Cols="3" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="False" DefaultCaption="Catalog" ShowSummary="True" ShowDescription="True"]]', NULL, N'Category Grid 4 (Shallow Item Display) With Category Data', N'~/Layouts/OneColumn.master', NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (6, 1, N'Category List', N'Displays products for only the selected category.  Items are displayed in a row format with columns for SKU, manufacturer, and pricing.  Includes breadcrumb links, sorting, page navigation, and sub-category link options.', N'[[ConLib:CategoryListPage PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="True" DefaultCaption="Catalog" PageSize="20" ShowSummary="False" ShowDescription="False"]]', NULL, N'Category List', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (7, 1, N'Basic Product', N'A product display page that shows the basic product details.', N'[[ConLib:ProductPage OptionsView="DROPDOWN" ShowVariantThumbnail="False" ShowAddAndUpdateButtons="False" ShowPartNumber="False" GTINName="GTIN" ShowGTIN="False" DisplayBreadCrumbs="True"]]', NULL, N'Basic Product', N'~/Layouts/OneColumn.master', NULL, 0, 2, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (8, 1, N'Product with Options Grid', N'A product display page that shows all variants of a product in a grid layout.  This display page should not be used with products having more than 8 options.', N'[[ConLib:ProductPage OptionsView="TABULAR" ShowVariantThumbnail="False" ShowAddAndUpdateButtons="False" ShowPartNumber="False" GTINName="GTIN" ShowGTIN="False" DisplayBreadCrumbs="True"]]', NULL, N'Product with Options Grid', NULL, NULL, 0, 2, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (10, 1, N'Contact Us', N'Standard contact us page.', N'<span style="font-size: 10px;">[[ConLib:ContactUs EnableCaptcha="False" EnableConfirmationEmail="True" ConfirmationEmailTemplateId="0" Subject="New Contact Message" SendTo=""]]</span>', NULL, N'Contact Us', N'~/Layouts/OneColumn.master', NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (11, 1, N'Product Display in Rows', N'A product display page that shows the product details in rows.', N'[[ConLib:ProductRow OptionsView="DROPDOWN" ShowVariantThumbnail="False" ShowAddAndUpdateButtons="False" ShowPartNumber="False" GTINName="GTIN" ShowGTIN="False" DisplayBreadCrumbs="True"]]', NULL, N'Product Display in Rows', NULL, NULL, 0, 2, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (12, 1, N'Article Listing', N'A category page that displays webpages of a category with summary description in a row format.', N'[[ConLib:ArticleListing DefaultCaption="Blog" DefaultCategorySummary="Welcome to our store blog." PagingLinksLocation="BOTTOM" ShowSummary="True" ShowDescription="False" DisplayBreadCrumbs="True" DefaultPageSize="5"]]', NULL, N'Article Listing', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (13, 1, N'Home', N'sdasdasdas', N'<span>[[ConLib:CategoryGridPageHome Cols="3" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="False" DefaultCaption="Catalog" ShowSummary="True" ShowDescription="True"]]</span>', NULL, N'Home', N'~/Layouts/OneColumn.master', NULL, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (15, 1, N'Category Grid 5 (Shallow Item Display) With Category Data', N'Displays categories, products, webpages, and links for only the selected category.  Items are displayed in a grid format with breadcrumb links, sorting, and page navigation.', N'[[ConLib:CategoryGridPage5 Cols="3" PagingLinksLocation="BOTTOM" DisplayBreadCrumbs="False" DefaultCaption="Catalog" ShowSummary="False" ShowDescription="True"]]', NULL, N'Category Grid 5 (Shallow Item Display) With Category Data', N'~/Layouts/OneColumn.master', NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (16, 1, N'FAQ', N'<h1>WE ARE ALLMARK&nbsp;</h1>
<h2>Ask us anything</h2>', N'<span style="font-size: 10px;">[[ConLib:FAQ EnableCaptcha="False" EnableConfirmationEmail="True" ConfirmationEmailTemplateId="0" Subject="New Contact Message" SendTo=""]]</span>', NULL, N'FAQ', N'~/Layouts/OneColumn.master', NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (17, 1, N'Terms & Conditions', NULL, N'<div class="pageHeader">
<h1>Terms &amp; Conditions</h1>
</div>
<div class="content">
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer in eleifend libero. Sed quis velit congue, posuere purus et, consectetur arcu. Aliquam eu eros ut velit pellentesque condimentum id eu ex. Phasellus vulputate mattis nulla, eget varius tellus placerat quis. Integer interdum pellentesque efficitur. Donec varius ligula non erat tincidunt consectetur et nec odio. Aenean pharetra ex neque, ut blandit sapien placerat quis. Sed rhoncus lacus non magna commodo, nec posuere est porta. Pellentesque vel consequat nibh.</p>
<p>In vel condimentum odio. Donec bibendum ultrices arcu, id elementum tortor venenatis ut. Curabitur sem erat, scelerisque at ipsum sit amet, euismod dignissim eros. Fusce tempus sagittis mauris, sed consectetur nunc imperdiet eu. Sed fringilla, ipsum a porta fringilla, purus massa rutrum urna, eget vulputate quam neque quis purus. Nulla quis leo sem. Sed aliquet lectus sit amet mauris tincidunt scelerisque. Morbi vel ipsum arcu.</p>
<p>Duis et volutpat sem. Vestibulum venenatis erat ut augue convallis, in tristique nulla blandit. Fusce lacinia fermentum mauris, non blandit erat. Curabitur porttitor dui nisi, sed ullamcorper dui pulvinar vitae. Nam ultrices velit id sem luctus maximus. Etiam ut urna placerat, mattis massa sed, rhoncus nulla. Fusce dapibus lorem metus, in dictum dui tempor nec.</p>
<p>Vivamus sem orci, interdum sit amet sodales ac, lacinia non tellus. Quisque eu tincidunt nunc, in lobortis est. Duis magna nisl, vulputate quis tincidunt a, convallis nec velit. Nullam non velit lacinia, scelerisque nisi a, mattis libero. In ullamcorper in nulla vitae sodales. Nam mauris arcu, malesuada vitae neque porta, viverra viverra eros. Maecenas dignissim, arcu in cursus feugiat, nibh leo sagittis leo, eget dictum magna velit vel est. Nulla sit amet ornare augue. Mauris imperdiet odio in quam interdum, in ornare nisl scelerisque. Nulla lectus sem, hendrerit non ligula in, pellentesque tempor enim. Curabitur vel quam augue. Aliquam non vehicula est.</p>
<p>Proin vulputate nunc at dolor suscipit tempor non ut tellus. Ut vulputate lectus ac volutpat pharetra. Curabitur aliquet, massa ut mollis vestibulum, tellus urna porta elit, in sagittis justo elit ultrices augue. Donec vitae neque feugiat, ultricies justo nec, vehicula orci. Fusce et posuere quam. Pellentesque lacinia bibendum magna, sit amet viverra metus. Mauris enim eros, accumsan non erat vel, efficitur imperdiet nisi. Vivamus sem eros, vehicula sed vehicula sit amet, semper eget augue. Maecenas ornare diam leo, luctus blandit nulla interdum et. Aliquam a dui vel orci commodo maximus quis eget augue. Ut vel justo eu felis dapibus volutpat. Vestibulum interdum velit in rutrum congue. Aliquam erat volutpat. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</p>
</div>', NULL, N'Terms & Conditions', N'~/Layouts/OneColumn.master', NULL, 0, 0, N'Terms & Conditions', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ac_Webpages] ([WebpageId], [StoreId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [Layout], [Theme], [VisibilityId], [WebpageTypeId], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [PublishedBy], [PublishDate]) VALUES (18, 1, N'About Us', NULL, N'<div class="pageHeader">
<h1>About Us</h1>
</div>
<div class="content">
<p>Allmark is an in-house manufacturer. We offer you direct from the factory prices and clear information right from the source. We have the equipment, expertise and experience to provide you with the custom products you need.</p>
<br /><br />
<p>Rely on us for fast service and quality workmanship</p>
<br /><br />
<p>ABN 65 008 735 96</p>
</div>', NULL, N'Copy of Terms & Conditions', N'~/Layouts/OneColumn.master', NULL, 0, 0, N'About Us', NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[ac_Webpages] OFF

SET IDENTITY_INSERT dbo.ac_Categories ON
UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 126;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 14;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 17;

UPDATE ac_Categories
SET WebpageId = 15,
	Summary = 'INDUSTRIAL ENGRAVING. PRINT, MARKING AND IDENTIFICATION',
	Description = 'Rely on us for fast service and quality workmanship',
	ThumbnailUrl = '~/Assets/Images/home-computer.png'
WHERE CategoryId = 1;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 7;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 169;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 171;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 172;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 173;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 199;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 213;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 230;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 223;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 242;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 253;

UPDATE ac_Categories
SET WebpageId = 15
WHERE CategoryId = 249;
SET IDENTITY_INSERT dbo.ac_Categories OFF

INSERT [dbo].[ac_CatalogNodes] (CategoryId, CatalogNodeId, CatalogNodeTypeId, OrderBy)
VALUES(1, 13, 2, 12);

SET IDENTITY_INSERT dbo.ac_Users ON
INSERT [dbo].[ac_Users] (UserId, StoreId, UserName, LoweredUserName, Email, LoweredEmail, AffiliateId, AffiliateReferralDate, PrimaryWishlistId, PayPalId, PasswordQuestion, PasswordAnswer, IsApproved, IsAnonymous, IsLockedOut, CreateDate, LastActivityDate, LastLoginDate, LastPasswordChangedDate, LastLockoutDate, FailedPasswordAttemptCount, FailedPasswordAttemptWindowStart, FailedPasswordAnswerAttemptCount, FailedPasswordAnswerAttemptWindowStart, TaxExemptionType, TaxExemptionReference, Comment)
VALUES(3578582, 1, 'allmark-admin@redisoftware.com.au', 'allmark-admin@redisoftware.com.au', 'allmark-admin@redisoftware.com.au', 'allmark-admin@redisoftware.com.au', NULL, NULL, 1037, NULL, NULL, NULL, 1, 0, 0, '2016-10-04 00:40:53.013', '2017-06-23 01:19:35.740', '2017-06-23 01:19:35.537', '2017-06-16 01:23:12.280', NULL, 0, NULL, 0, NULL, 0, NULL, 'Y3EqNLB1ngFG');
SET IDENTITY_INSERT dbo.ac_Users OFF

INSERT [dbo].[ac_UserPasswords] (UserId, PasswordNumber, Password, PasswordFormat, CreateDate, ForceExpiration)
VALUES(3578582, 1, '1iKbEfkaZL6RGiMcSt/HLCb5dEVVRXCf', 'SHA1', '2017-06-16 01:23:12.280', 0);

INSERT [dbo].[ac_UserGroups] (UserId, GroupId, SubscriptionId)
VALUES (3578582, 1, NULL);