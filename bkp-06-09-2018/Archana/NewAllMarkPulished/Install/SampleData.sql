-- <[ac_Categories]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_Categories] ON;

INSERT INTO [ac_Categories] ([CategoryId], [StoreId], [ParentId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [WebpageId], [MetaDescription], [VisibilityId]) 
	VALUES ( 1, 1, 0, 'Sample Category', 'This category features some examples of products that demonstrate key AbleCommerce features.  You may want to leave this category in your store, but change the visability to Hidden.', NULL, NULL, 'Sample Category', NULL, NULL, 0 );

INSERT INTO [ac_Categories] ([CategoryId], [StoreId], [ParentId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [WebpageId], [MetaDescription], [VisibilityId]) 
	VALUES ( 2, 1, 1, 'Computers and Electronics', NULL, NULL, NULL, 'Computers and Electronics', NULL, NULL, 0 );

INSERT INTO [ac_Categories] ([CategoryId], [StoreId], [ParentId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [WebpageId], [MetaDescription], [VisibilityId]) 
	VALUES ( 3, 1, 1, 'Accessories', NULL, NULL, NULL, 'Accessories', NULL, NULL, 0 );

INSERT INTO [ac_Categories] ([CategoryId], [StoreId], [ParentId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [WebpageId], [MetaDescription], [VisibilityId]) 
	VALUES ( 4, 1, 1, 'Gift Ideas', NULL, NULL, NULL, 'Gift Ideas', NULL, NULL, 0 );

INSERT INTO [ac_Categories] ([CategoryId], [StoreId], [ParentId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [WebpageId], [MetaDescription], [VisibilityId]) 
	VALUES ( 5, 1, 1, 'Software and Subscriptions', NULL, NULL, NULL, 'Software and Subscriptions', NULL, NULL, 0 );

INSERT INTO [ac_Categories] ([CategoryId], [StoreId], [ParentId], [Name], [Summary], [Description], [ThumbnailUrl], [ThumbnailAltText], [WebpageId], [MetaDescription], [VisibilityId]) 
	VALUES ( 6, 1, 2, 'Kit Components', 'This category holds all the compenents used to make a Kit product.  For the purpose of this demonstration, the items are not shown.', NULL, NULL, 'Kit Components', NULL, NULL, 2 );

SET IDENTITY_INSERT [ac_Categories] OFF;

-- </[ac_Categories]>

GO

-- <[ac_CategoryParents]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 1, 0, 0, 1 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 1, 1, 1, 0 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 2, 0, 0, 2 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 2, 1, 1, 1 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 2, 2, 2, 0 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 3, 0, 0, 2 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 3, 1, 1, 1 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 3, 3, 2, 0 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 4, 0, 0, 2 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 4, 1, 1, 1 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 4, 4, 2, 0 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 5, 0, 0, 2 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 5, 1, 1, 1 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 5, 5, 2, 0 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 6, 0, 0, 3 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 6, 1, 1, 2 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 6, 2, 2, 1 );

INSERT INTO [ac_CategoryParents] ([CategoryId], [ParentId], [ParentLevel], [ParentNumber]) 
	VALUES ( 6, 6, 3, 0 );


-- </[ac_CategoryParents]>

GO

-- <[ac_WrapGroups]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_WrapGroups] ON;

INSERT INTO [ac_WrapGroups] ([WrapGroupId], [StoreId], [Name]) 
	VALUES ( 1, 1, 'Sample Wraps' );

SET IDENTITY_INSERT [ac_WrapGroups] OFF;

-- </[ac_WrapGroups]>

GO

-- <[ac_WrapStyles]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_WrapStyles] ON;

INSERT INTO [ac_WrapStyles] ([WrapStyleId], [WrapGroupId], [Name], [TaxCodeId], [Price], [ThumbnailUrl], [ImageUrl], [OrderBy]) 
	VALUES ( 1, 1, 'Blue', NULL, 3.9900, '~/Assets/ProductImages/gift_box_blue_t.jpg', '~/Assets/ProductImages/gift_box_blue.jpg', 1 );

INSERT INTO [ac_WrapStyles] ([WrapStyleId], [WrapGroupId], [Name], [TaxCodeId], [Price], [ThumbnailUrl], [ImageUrl], [OrderBy]) 
	VALUES ( 2, 1, 'Red', NULL, 3.9900, '~/Assets/ProductImages/gift_box_red_t.jpg', '~/Assets/ProductImages/gift_box_red.jpg', 2 );

INSERT INTO [ac_WrapStyles] ([WrapStyleId], [WrapGroupId], [Name], [TaxCodeId], [Price], [ThumbnailUrl], [ImageUrl], [OrderBy]) 
	VALUES ( 3, 1, 'Gold', NULL, 3.9900, '~/Assets/ProductImages/gift_box_gold_t.jpg', '~/Assets/ProductImages/gift_box_gold.jpg', 3 );

SET IDENTITY_INSERT [ac_WrapStyles] OFF;

-- </[ac_WrapStyles]>

GO

-- <[ac_Manufacturers]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_Manufacturers] ON;

INSERT INTO [ac_Manufacturers] ([ManufacturerId], [StoreId], [Name]) 
	VALUES ( 1, 1, 'Sanasonic' );

INSERT INTO [ac_Manufacturers] ([ManufacturerId], [StoreId], [Name]) 
	VALUES ( 2, 1, 'Bell' );

SET IDENTITY_INSERT [ac_Manufacturers] OFF;

-- </[ac_Manufacturers]>

GO

-- <[ac_Products]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_Products] ON;

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 1, 1, 'Personalized Gift Certificate', 50.0000, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/gift_card_goldbow_t.jpg', 'Personalized Gift Certificate', '~/Assets/ProductImages/gift_card_goldbow.jpg', 'Personalized Gift Certificate', 'This product demonstrates a Gift Certificate with a few different option images.  It uses a Product Template configuration which allows the customer to add personalization.', '<p>Purchase a $50 Personalized Gift&nbsp;Certificate that can be used towards any product in&nbsp;the store.&nbsp; Your recipient will receive this beautiful gift certificate with his or her name imprinted on high quality card stock.&nbsp;</p><p>&nbsp;</p><ul><li>Select a Gift Certificate style.</li><li>Enter the name of the person who will be receiving this Gift Certificate</li><li>Add the item to your shopping cart and checkout.&nbsp;</li><li>Be sure to include the recipient''s&nbsp;name and shipping address so we''ll know where to mail the Gift Certificate.&nbsp;</li><li>When your&nbsp;order is fulfilled,&nbsp;we''ll send&nbsp;the Gift Certificate Serial number in an email so your recipent will be able to start shopping right away.&nbsp; In addition, they will receive a personalized Gift Certificate, with the color of your choice, in the mail. &nbsp;</li></ul>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/gift_card_goldbow_i.jpg', 'Personalized Gift Certificate', 1, 0, NULL, NULL, 0, 1);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 3, 1, 'Choose your own Gift Card', 0.0000, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/gift_card_vip_t.jpg', 'Choose your own Gift Card', '~/Assets/ProductImages/gift_card_vip.jpg', 'Choose your own Gift Card', 'This item demonstrates a Variable Price Gift Certificate.  The merchant can set the minimum and maximum price which can then be entered by the customer.', '<P>Purchase a Gift Card that can be used towards any product in&nbsp;the store. </P>
<UL>
<LI>Enter&nbsp;an amount&nbsp;between $10.00 and $500.00 for the value of this Gift Card.
<LI>Choose a style.&nbsp;
<LI>Add the item to your shopping cart and checkout.&nbsp; 
<LI>Be sure to include the recipient''s&nbsp;name and shipping address so we''ll know where to mail the Gift Card.&nbsp; 
<LI>When your&nbsp;order is fulfilled,&nbsp;we''ll send&nbsp;the Gift Certificate Serial number in an email so your recipent will be able to start shopping right away.&nbsp; In addition, they will receive a beautiful Gift Card in the mail. &nbsp; </LI></UL>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/gift_card_vip_i.jpg', 'Choose your own Gift Card', 1, 1, 10.00, 500.00, 0, 2);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 4, 1, 'Flat Panel Plasma TV', 1999.0000, 0.0000, 0.0000, 70.0000, 0.0000, 0.0000, 0.0000, 1, 'SN-42PX60U', NULL, NULL, NULL, 2, 1, 2, 0, 0, '~/Assets/ProductImages/plasma_tv_t.jpg', 'Flat Panel Plasma TV', '~/Assets/ProductImages/plasma_tv.jpg', 'Flat Panel Plasma TV', 'This item demonstrates the use of a Product Template.  This makes repetitive data entry easier for the merchant.', '<P style="COLOR: red"><B><FONT color=#000000>Key Features of the Sanasonic SN-42PX60U 42" Plasma Monitor</FONT></B></P>
<UL>
<LI>42" HDTV Sanasonic Plasma TV 
<LI>3,072 Shades of Gradation - Over 28 Billion Colors! 
<LI>Integrated NTSC and ATSC Tuners 
<LI>HDMI Input with HDAVI Control 
<LI>SD Memory Card Slot 
<LI>Front A/V Jacks</LI></UL>
<P>&nbsp;</P>
<P>Click the "<U><STRONG><FONT color=#000000>more details</FONT></STRONG></U>" link above for a full product description. </P>
<P>Click the "<STRONG><U>more images</U></STRONG>" link above to view some additional photographs. </P>
<P>&nbsp;</P>', '<H2>Sanasonic Plasma Technology</H2>
<P><STRONG>Deep Blacks, Bright Whites, and 29 Billion Colors</STRONG><BR>The realism of a TV''s image is strongly linked to its contrast ratio, and this plasma features a high contrast ratio of up to 10,000:1. Such a wide range from black to white means great depth and dimensionality with vibrant colors—and this plasma can display an incredible 29 billion colors for a superior picture. Deep blacks provide excellent shadow detail during dark scenes, while brilliant whites allow our plasmas to render bright scenes with vivid realism.</P>
<P>&nbsp;</P>
<P><STRONG>Receive Over-The-Air HDTV Broadcasts</STRONG><BR>Sports, movies, and original network programming are all available in high definition from many local broadcasters. Receive and view local over-the-air broadcasts on this plasma in stunning HDTV clarity using the built-in HDTV tuner. If your cable company passes through HDTV broadcasts from local broadcasters, you can decode and tune those as well.</P>
<P>&nbsp;</P>
<P><STRONG>Share Digital Photos On the Big Screen with Photo Viewer</STRONG><BR>The best images you can ever view on a Sanasonic plasma don''t have anything to do with HDTV. Share your JPEG photos taken with a&nbsp;digital camera on a Sanasonic plasma using the built-in SD card slot. Simply insert the SD card, which is about the size of a postage stamp, into the SD slot on the TV and enjoy a photo slideshow.</P>
<P>&nbsp;</P>
<P><STRONG>A Single Cable Carries High-Quality Digital Audio and Video</STRONG><BR>If you have even a moderately complicated home theater setup, you probably have a pile of tangled cables on the floor behind it. Imagine replacing all those cables with a single cable that carries both digital video and audio at the same time. With the new HDMI standard, that''s exactly what you get. The HDMI connector on this TV accepts high-quality digital video and audio via the same thin cable, allowing you to run one cable from the source to the TV.</P>
<P>&nbsp;</P>
<P><STRONG>A Cinema-Style Viewing Experience At Home</STRONG><BR>This widescreen TV features a width-to-height ratio similar to movie theater screens, providing a theater-like experience at home. View HDTV broadcasts and widescreen DVDs the way they were meant to be seen.</P>
<P>&nbsp;</P>
<P><STRONG>Crisp, Lifelike Details</STRONG><BR>HDTV broadcasts and DVDs offer more detail and better color than analog broadcasts, and it takes a high-resolution display to deliver all that picture information. The high pixel count of this plasma display provides fine detail for outstanding HDTV reproduction. More pixels also translate into less stair-stepping artifacts; curved and diagonal edges look smooth and natural.</P>
<P>&nbsp;</P>', NULL, '2015-08-20', '2016-03-01', 1, 0, 1, 1, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/plasma_tv_i.jpg', 'Flat Panel Plasma TV', 0, 0, NULL, NULL, 0, 8);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 5, 1, 'Build-your-Own Computer', 999.0000, 0.0000, 0.0000, 30.0000, 0.0000, 0.0000, 0.0000, 2, 'DSK-TOP-KIT', NULL, 11, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/computer_system2_t.jpg', 'Build-your-Own Computer', '~/Assets/ProductImages/computer_system2.jpg', 'Build-your-Own Computer', 'This is a master Kit product.   It demonstrates the ability for a user to customize a product using the optional components that a merchants specifies.  A Kit can also be used for Gift Baskets.', '<h3>Build your own computer system.&nbsp; Base price starts at $999</h3><p>Base System includes the following:</p><p>&nbsp;</p><ul><li>Intel&reg; Core&trade; 2 Duo Processor (2MB Cache,2.0GHz)</li><li>Your choice of Operating System software</li><li>Intel&reg; Graphics Media Accelerator 3000</li><li>2 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs</li><li>19 inch SE198WFP Widescreen Flat Panel Monitor</li><li>24X CD-RW/ DVD Combo Drive</li><li>McAfee SecurityCenter with anti-virus, anti-spyware, firewall, 15-months</li></ul><p>&nbsp;</p><p>&nbsp;</p><p><strong>Customize your own system</strong> by increasing speed, memory, disk space, and more!</p><p>&nbsp;</p>', NULL, NULL, '2015-08-20', '2016-03-01', 1, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/computer_system2_i.jpg', 'Build-your-Own Computer', 0, 0, NULL, NULL, 0, 1);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 6, 1, 'Intel Core 2 Duo Processor (2MB Cache,2.0GHz)', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'Intel Core 2 Duo Processor (2MB Cache,2.0GHz)', NULL, 'Intel Core 2 Duo Processor (2MB Cache,2.0GHz)', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'Intel Core 2 Duo Processor (2MB Cache,2.0GHz)', 0, 0, NULL, NULL, 0, 0);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 7, 1, 'Intel Core 2 Duo Processor (4MB Cache,2.13GHZ)', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'Intel Core 2 Duo Processor (4MB Cache,2.13GHZ)', NULL, 'Intel Core 2 Duo Processor (4MB Cache,2.13GHZ)', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'Intel Core 2 Duo Processor (4MB Cache,2.13GHZ)', 0, 0, NULL, NULL, 0, 1);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 8, 1, 'Windows Vista Home Premium', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'Windows Vista Home Premium', NULL, 'Windows Vista Home Premium', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'Windows Vista Home Premium', 0, 0, NULL, NULL, 0, 3);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 9, 1, 'Windows XP Professional', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'Windows XP Professional', NULL, 'Windows XP Professional', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'Windows XP Professional', 0, 0, NULL, NULL, 0, 4);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 10, 1, 'Intel Graphics Media Accelerator 3000', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'Intel Graphics Media Accelerator 3000', NULL, 'Intel Graphics Media Accelerator 3000', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'Intel Graphics Media Accelerator 3000', 0, 0, NULL, NULL, 0, 5);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 11, 1, 'Intel Graphics Media Accelerator 3500', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'Intel Graphics Media Accelerator 3500', NULL, 'Intel Graphics Media Accelerator 3500', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'Intel Graphics Media Accelerator 3500', 0, 0, NULL, NULL, 0, 6);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 12, 1, '2 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '2 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', NULL, '2 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '2 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', 0, 0, NULL, NULL, 0, 7);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 13, 1, '4 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '4 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', NULL, '4 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '4 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', 0, 0, NULL, NULL, 0, 8);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 14, 1, '250 GB Hard Drive (7200RPM) w/DataBurst Cache', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '250 GB Hard Drive (7200RPM) w/DataBurst Cache', NULL, '250 GB Hard Drive (7200RPM) w/DataBurst Cache', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '250 GB Hard Drive (7200RPM) w/DataBurst Cache', 0, 0, NULL, NULL, 0, 9);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 15, 1, '320 GB Hard Drive (7200RPM) w/DataBurst Cache', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '320 GB Hard Drive (7200RPM) w/DataBurst Cache', NULL, '320 GB Hard Drive (7200RPM) w/DataBurst Cache', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '320 GB Hard Drive (7200RPM) w/DataBurst Cache', 0, 0, NULL, NULL, 0, 10);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 16, 1, '19 inch SE198WFP Widescreen Flat Panel Monitor', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '19 inch SE198WFP Widescreen Flat Panel Monitor', NULL, '19 inch SE198WFP Widescreen Flat Panel Monitor', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '19 inch SE198WFP Widescreen Flat Panel Monitor', 0, 0, NULL, NULL, 0, 11);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 17, 1, '20 inch E207WFP Widescreen Digital Flat Panel', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '20 inch E207WFP Widescreen Digital Flat Panel', NULL, '20 inch E207WFP Widescreen Digital Flat Panel', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '20 inch E207WFP Widescreen Digital Flat Panel', 0, 0, NULL, NULL, 0, 12);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 18, 1, '22 inch E228WFP Widescreen Digital Flat Panel', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '22 inch E228WFP Widescreen Digital Flat Panel', NULL, '22 inch E228WFP Widescreen Digital Flat Panel', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '22 inch E228WFP Widescreen Digital Flat Panel', 0, 0, NULL, NULL, 0, 13);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 19, 1, '24X CD-RW/ DVD Combo Drive', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '24X CD-RW/ DVD Combo Drive', NULL, '24X CD-RW/ DVD Combo Drive', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '24X CD-RW/ DVD Combo Drive', 0, 0, NULL, NULL, 0, 14);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 20, 1, '8x DVD+/-RW Drive', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '8x DVD+/-RW Drive', NULL, '8x DVD+/-RW Drive', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '8x DVD+/-RW Drive', 0, 0, NULL, NULL, 0, 15);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 21, 1, 'No Floppy Drive Included', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'No Floppy Drive Included', NULL, 'No Floppy Drive Included', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'No Floppy Drive Included', 0, 0, NULL, NULL, 0, 16);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 22, 1, '13 in 1 Media Card Reader', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '13 in 1 Media Card Reader', NULL, '13 in 1 Media Card Reader', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '13 in 1 Media Card Reader', 0, 0, NULL, NULL, 0, 17);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 23, 1, 'McAfee SecurityCenter with anti-virus, anti-spyware, firewall, 15-months', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'McAfee SecurityCenter with anti-virus, anti-spyware, firewall, 15-months', NULL, 'McAfee SecurityCenter with anti-virus, anti-spyware, firewall, 15-months', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'McAfee SecurityCenter with anti-virus, anti-spyware, firewall, 15-months', 0, 0, NULL, NULL, 0, 18);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 24, 1, '1 Year In-Home Service Parts', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '1 Year In-Home Service Parts', NULL, '1 Year In-Home Service Parts', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '1 Year In-Home Service Parts', 0, 0, NULL, NULL, 0, 19);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 26, 1, 'Windows XP Home', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'Windows XP Home', NULL, 'Windows XP Home', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'Windows XP Home', 0, 0, NULL, NULL, 0, 20);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 27, 1, '500 GB Hard Drive (7200RPM) w/DataBurst Cache', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '500 GB Hard Drive (7200RPM) w/DataBurst Cache', NULL, '500 GB Hard Drive (7200RPM) w/DataBurst Cache', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '500 GB Hard Drive (7200RPM) w/DataBurst Cache', 0, 0, NULL, NULL, 0, 21);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 28, 1, '1 Year - 24x7 Phone Support', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, '1 Year - 24x7 Phone Support', NULL, '1 Year - 24x7 Phone Support', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, '1 Year - 24x7 Phone Support', 0, 0, NULL, NULL, 0, 22);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 29, 1, 'Intel  CoreTM 2 Duo Processor (4MB Cache,2.66GHz)', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'Intel  CoreTM 2 Duo Processor (4MB Cache,2.66GHz)', NULL, 'Intel  CoreTM 2 Duo Processor (4MB Cache,2.66GHz)', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'Intel  CoreTM 2 Duo Processor (4MB Cache,2.66GHz)', 0, 0, NULL, NULL, 0, 1);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 30, 1, 'ATI Radeon X1300 Pro 256MB', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'ATI Radeon X1300 Pro 256MB', NULL, 'ATI Radeon X1300 Pro 256MB', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'ATI Radeon X1300 Pro 256MB', 0, 0, NULL, NULL, 0, 23);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 31, 1, 'ATI Radeon X1300 128MB', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, NULL, 'ATI Radeon X1300 128MB', NULL, 'ATI Radeon X1300 128MB', NULL, NULL, NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 2, NULL, 'ATI Radeon X1300 128MB', 0, 0, NULL, NULL, 0, 24);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 32, 1, 'Computer Training Class', 250.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 2, 'Training-8', NULL, NULL, NULL, 0, 1, 2, 0, 0, '~/Assets/ProductImages/computer_class_t.jpg', 'Computer Training Class', '~/Assets/ProductImages/computer_class.jpg', 'Computer Training Class', 'This product features the use of option combinations (variants) with inventory tracking.  The merchant may configure individual option combinations that are not available as selections. In this example, we''ve removed July 4th from the customer''s choices. Allow Backorder is not enabled for this example.', '<P>A full day training seminar includes the basics of using a computer.&nbsp; We will show you how to operate and maintain your computer system, basic training on the popular Windows Office software tools, and setting up email and communication systems.&nbsp; </P>
<P>&nbsp;</P>
<P><STRONG>Includes</STRONG>: </P>
<UL>
<LI>8 hours of hands-on&nbsp;training&nbsp;at one of our state-of-the-art&nbsp;facilities.&nbsp; (Located in 3 major cities across the USA) 
<LI>Small class sizes; limited to a maximum of 12 seats. 
<LI>Expert computer technicians will give you a basic course covering file maintenance, office software, and email. 
<LI>One meal is included. (You will need to provide your own transportation) </LI></UL>
<P>&nbsp;</P>
<P>This course is highly recommended for the new computer user.&nbsp; Additional, advanced training courses are available. </P>
<P>&nbsp;</P>
<P><STRONG>Availability is limited, choose&nbsp;from the list of dates to reserve your seat now</STRONG>. </P>
<P>&nbsp;</P>
<P>Training is available during the months of June, July, and August.&nbsp;&nbsp;<EM>Independence day&nbsp;(July 4th)&nbsp;is not available</EM>. </P>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/computer_class_i.jpg', 'Computer Training Class', 0, 0, NULL, NULL, 0, 7);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 33, 1, 'All-in-One Printer', 199.9900, 0.0000, 0.0000, 10.0000, 0.0000, 0.0000, 0.0000, 2, 'B490', NULL, NULL, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/printer_t.jpg', 'All-in-One Printer', '~/Assets/ProductImages/printer.jpg', 'All-in-One Printer', 'This product features the ability to upsell.  When purchased, the customer will be presented with options to purchase ink cartridge, USB cable, and paper.', '<p class="grey" hasbox="2"><strong hasbox="2">All-in-One Ink Jet Printer </strong></p><p class="grey" hasbox="2">&nbsp;</p><ul><li><div class="grey" hasbox="2">Maximum Print Resolution:&nbsp; 5760 x 1440 optimized dpi</div></li><li><div class="grey" hasbox="2">Minimum Droplet Size: 2.5 picoliters</div></li><li><div class="grey" hasbox="2">Ink Type: 3-color Pigment</div></li><li><div class="grey" hasbox="2">Borderless Printing</div></li><li><div class="grey" hasbox="2">8&nbsp;x&nbsp;11 Maximum Paper Size, 4 x 6 Photo</div></li><li><div class="grey" hasbox="2">Print Speed: 1 minute, 40 seconds (4 x 6)</div></li><li><div class="grey" hasbox="2">PC Free Printing Paper</div></li><li><div class="grey" hasbox="2">USB Compatibility</div></li><li><div class="grey" hasbox="2">Windows 98, Me, 2000, XP; Mac OS 9.1 or higher, OS X 10.1 or later</div></li><li><div class="grey" hasbox="2">Size10w x 12d x 6-1/2h</div></li><li><div class="grey" hasbox="2">Print Pack:&nbsp; Ink-B490 (sold separately)</div></li><li><div class="grey" hasbox="2">Fade-resistant photos last over 100 years!</div></li><li><div class="grey" hasbox="2">Advanced Micro Piezo ink jet technology, optimized for photo printing.</div></li><li><div class="grey" hasbox="2">Manufacturers one-year limited warranty.</div></li></ul><p class="grey" hasbox="2">&nbsp;</p>', NULL, NULL, '2015-08-20', '2016-03-01', 1, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/printer_i.jpg', 'All-in-One Printer', 0, 0, NULL, NULL, 0, 4);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 34, 1, 'Color Ink Cartridge', 35.9900, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0.0000, 2, 'Ink-B490', '7Y745', NULL, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/ink_cartridge_t.jpg', 'Color Ink Cartridge', '~/Assets/ProductImages/ink_cartridge.jpg', 'Color Ink Cartridge', 'This product is used as a Upsell Product when a printer is purchased.', '<p>The High-Resolution Color Print Cartridge specifically designed for the Bell All-in-One Printer B490. It features small ink-drop size for excellent clarity and fine detail. The cartridge produces high-resolution color printouts with sharp images and brilliant photos.</p><p>&nbsp;</p><p>&nbsp;</p><ul><li>High-resolution color printouts with sharp, brilliant images</li><li>Small ink-drop size provides excellent clarity and detail</li><li>Ink produces vibrant colors</li><li>Designed specifically for the Bell All-in-One Printer B490</li></ul>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/ink_cartridge_i.jpg', 'Color Ink Cartridge', 0, 0, NULL, NULL, 0, 4);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 35, 1, 'USB 2.0 Cable', 14.9900, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0.0000, NULL, 'USB-20-', NULL, NULL, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/printer_usb_cable_t.jpg', 'USB 2.0 Cable', '~/Assets/ProductImages/printer_usb_cable.jpg', 'USB 2.0 Cable', 'This product demonstrates options with price and SKU modifiers.', '<p>This&nbsp;USB2.0 A/B device cable has been tested and certified by USB-if to meet or exceed the USB2.0 performance criteria. Connects a USB device to a USB port on a computer or hub. Backward compatible - can be used with older USB1.1 applications as well.&nbsp;</p><p>&nbsp;</p><p>All&nbsp;USB 2.0 cabling include superior foil shielding for reliable, error-free data communications. The significantly faster data transfer rates of USB 2.0 (up to 480 Mbps) make them perfect for multimedia applications. Features gold plated connectors and gold plated copper contacts for superior conductivity. The cable is manufactured with molded connectors and integral strain relief for extra durability and long life. This product is guaranteed to be free from defects in materials and workmanship for life.</p>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/printer_usb_cable_i.jpg', 'USB 2.0 Cable', 0, 0, NULL, NULL, 0, 5);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 36, 1, 'Printer Paper', 18.9500, 0.0000, 0.0000, 2.0000, 0.0000, 0.0000, 0.0000, 2, 'PP-5831', NULL, NULL, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/printerpaper_t.jpg', 'Printer Paper', '~/Assets/ProductImages/printerpaper.jpg', 'Printer Paper', 'This item is a Upsell Product to the printer.  When the printer is purchased, this product will be displayed to the user for purchase.', '<p>Print all your prized photographs and digital creations with dazzling results on the Premium Photo Paper. Cherish your memories for years to come with brilliant, high-quality photos. It boasts of a smooth, high gloss coated surface that produces fully saturated colors, smooth skin tones and strong highlights.</p><p>&nbsp;</p><ul><li>Optimized for use with all Inkjet printers</li><li>Boasts a smooth, high gloss coated surface that produces fully saturated colors, smooth skin tones and strong highlights</li><li>Includes 30 Sheets</li></ul>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/printerpaper_i.jpg', 'Printer Paper', 0, 0, NULL, NULL, 0, 6);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 37, 1, 'Free Download Sample', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 0, 0, '~/Assets/ProductImages/download_now_t.jpg', 'Free Download Sample', '~/Assets/ProductImages/download_now.jpg', 'Free Download Sample', 'This product demonstrates how to setup a free Digital Delivery.  See Digital Goods for configuration settings.', '<p>Download a free sample digital good by following the simple steps below:</p><p>&nbsp;</p><ol><li>Add the product to your shopping cart and proceed to checkout.</li><li>Enter your name and address information.</li><li>From the payment page, choose the &quot;Call Me&quot; option.</li><li>The next page,&nbsp;your order invoice, will have a download&nbsp;link. &nbsp;</li></ol><p>&nbsp;</p>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/download_now_i.jpg', 'Free Download Sample', 0, 0, NULL, NULL, 0, 1);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 38, 1, 'Digital Goods with Options', 49.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 0, 0, '~/Assets/ProductImages/software_box_t.jpg', 'Digital Goods with Options', '~/Assets/ProductImages/software_box.jpg', 'Digital Goods with Options', 'This product demonstrates how to Digital Delivery using product options.  See Digital Goods for configuration settings.', '<p>Download a digital good by following the simple steps below:</p><p>&nbsp;</p><ol><li>Choose&nbsp;a download&nbsp;option (eg. Windows or Linux)</li><li>Add the product to your shopping cart and proceed to checkout.</li><li>Enter your name and address information.</li><li>Enter your&nbsp;payment information.</li><li>Your&nbsp;order invoice will have a download*&nbsp;link.&nbsp;</li></ol><p>&nbsp;</p><p>* The download will&nbsp;not be activated until your payment is processed.&nbsp;</p><p>&nbsp;</p>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/software_box_i.jpg', 'Digital Goods with Options', 0, 0, NULL, NULL, 0, 2);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 39, 1, 'Ecommerce Magazine Subscription', 19.9500, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/stack_magazines_t.jpg', 'Ecommerce Magazine Subscription', '~/Assets/ProductImages/stack_magazines.jpg', 'Ecommerce Magazine Subscription', 'This product uses a 12-month subscription plan.  Subscriptions can have a recurring billing plan or one-time payment option.', '<p>A practical look at ecommerce shopping systems, hosted solutions, and ratings of existing applications.&nbsp;</p><p>&nbsp;</p><p>Purchase a subscription to 12 monthly issues of Ecommerce magazine.&nbsp;</p><p>Please allow 4-6 weeks for delivery of the first issue.</p>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/stack_magazines_i.jpg', 'Ecommerce Magazine Subscription', 0, 0, NULL, NULL, 0, 3);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 40, 1, 'Category 5E Cable (per foot)', 0.2500, 0.0000, 0.0000, 5.0000, 0.0000, 0.0000, 0.0000, NULL, 'CAT-5e-NET', NULL, NULL, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/cat5_mixed_t.jpg', 'Category 5E Cable (per foot)', '~/Assets/ProductImages/cat5_mixed.jpg', 'Category 5E Cable (per foot)', 'This product uses Volume discounts.  A minimum product purchase of 20 and a maximum quantity of 1000 is also used in this example.', '<p>Category 5E cable is tested to 350 MHZ and verified to Cat 5E standards.</p><p>Four twisted pairs of 24 gauge solid copper conductors.&nbsp;</p><p>&nbsp;</p><p><strong>Minimum&nbsp;purchase of&nbsp;20&nbsp;and a&nbsp;m</strong><strong>aximum purchase of&nbsp;1000 feet per order. </strong></p>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 0, NULL, 0, NULL, 0, 20, 1000, 0, '~/Assets/ProductImages/cat5_mixed_i.jpg', 'Category 5E Cable (per foot)', 0, 0, NULL, NULL, 0, 2);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 41, 1, 'AbleCommerce T-shirt', 9.9900, 0.0000, 15.9900, 1.0000, 0.0000, 0.0000, 0.0000, NULL, 'Able-grey', NULL, NULL, NULL, 1, 1, 2, 0, 0, '~/Assets/ProductImages/tshirt_grey_t.jpg', 'AbleCommerce T-shirt', '~/Assets/ProductImages/tshirt_grey.jpg', 'AbleCommerce T-shirt', 'This product demonstrates how option combinations (Variants) are used with inventory control.  It also has some gift wrap options at checkout.', '<p><strong>Get your AbleCommerce T-shirt today!</strong>&nbsp;</p><p>&nbsp;</p><p><strong>BUY 1 GET 1 FREE</strong> - use coupon code &quot;<strong>GET1FREE</strong>&quot; on final payment page.</p><p>&nbsp;</p><ul><li>Front side has the AbleCommerce trademark and logo.</li><li>Back side has the words, &quot;Software that Sells&quot;</li><li>Available sizes are shown by selecting the Gender options.</li></ul><p>&nbsp;</p><p>Stock availability is displayed and backorders are allowed.&nbsp;</p><p>&nbsp;</p><p>Gift wrap is available for an additional $3.99</p><p>&nbsp;</p>', NULL, NULL, '2015-08-20', '2016-03-01', 0, 0, 1, 1, 1, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/tshirt_grey_i.jpg', 'AbleCommerce T-shirt', 0, 0, NULL, NULL, 0, 3);

INSERT INTO [ac_Products] ([ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId], [ShippableId], [WarehouseId], [InventoryModeId], [InStock], [InStockWarningLevel], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [WrapGroupId], [ExcludeFromFeed], [MetaDescription], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IconUrl], [IconAltText], [IsGiftCertificate], [UseVariablePrice], [MinimumPrice], [MaximumPrice], [HidePrice], [OrderBy]) 
	VALUES ( 42, 1, 'Universal Remote', 19.9900, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0.0000, 1, 'UNR-625', NULL, NULL, NULL, 1, 1, 0, 0, 0, '~/Assets/ProductImages/remote_control2_t.jpg', 'Universal Remote', '~/Assets/ProductImages/remote_control2.jpg', 'Universal Remote', 'This product is used as a Upsell Product to the Plasma TV.', '<p>The&nbsp;Universal Remote&nbsp;is quick and easy to set up, and even easier to operate. It comes packed with a database of thousands of pre-programmed codes that will control hundreds of components.</p><p>&nbsp;</p><p><strong>Features and Benefits</strong></p><ul><li>Replaces up to 5 remote controls</li><li>Press one button, turns on components.</li><li>7 macro buttons (up to 20 steps each)</li><li>Device buttons light up for use in dark environments.</li></ul><p>&nbsp;</p><p>&nbsp;</p><p><strong>Specifications</strong></p><p>&nbsp;</p><ul style="margin-top: 3px"><li>Size: 8-3/4&quot; x 2-1/8&quot; x 1-1/8&quot; (L x W x H)</li><li>Weight: 6.4 oz (with batteries)</li><li>Learning Capabilities: Non-Learning Model</li><li>Memory: Non-Volatile Flash Memory: 64 KByte</li><li>Range: Range: IR (infrared): 30 - 50 feet. Approximate range will vary depending upon operational and environmental conditions</li><li>Power Supply: AAx 2 (included)</li><li>Warranty: One year parts &amp; labor</li></ul><p>&nbsp;</p>', NULL, NULL, '2015-08-20', '2016-03-01', 1, 0, 1, 0, NULL, 0, NULL, 0, 0, 0, 0, '~/Assets/ProductImages/remote_control2_i.jpg', 'Universal Remote', 0, 0, NULL, NULL, 0, 3);

INSERT INTO [ac_Products] ( [ProductId], [StoreId], [Name], [Price], [CostOfGoods], [MSRP], [Weight], [Length], [Width], [Height], [InStockWarningLevel], [ShippableId], [InventoryModeId], [InStock], [CreatedDate], [LastModifiedDate], [IsFeatured], [IsProhibited], [AllowReviews], [AllowBackorder], [ExcludeFromFeed], [DisablePurchase], [MinQuantity], [MaxQuantity], [VisibilityId], [IsGiftCertificate], [UseVariablePrice], [HidePrice], [EnableGroups], [PublishFeedAsVariants], [OrderBy], [RowVersion], [Title], [HtmlHead], [MetaDescription], [MetaKeywords], [SearchKeywords], [GTIN], [GoogleCategory], [Condition], [Gender], [AgeGroup], [Color], [Size], [AdwordsGrouping], [AdwordsLabels], [ExcludedDestination], [AdwordsRedirect], [MinimumPrice], [MaximumPrice], [HandlingCharges], [IconUrl], [IconAltText], [WrapGroupId], [AvailabilityDate], [WarehouseId], [ThumbnailUrl], [ThumbnailAltText], [ImageUrl], [ImageAltText], [Summary], [Description], [ExtendedDescription], [VendorId], [ManufacturerId], [Sku], [ModelNumber], [WebpageId], [TaxCodeId] ) 
 VALUES ( 43, 1, 'Recurring Shipments', 35.0000, 0.0000, 0.0000, 5.0000, 0.0000, 0.0000, 0.0000, 0, 1, 0, 0, '2015-08-20', '2016-03-01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.00, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'New', 'Unisex', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, '~/Assets/ProductImages/hp-inkjet-cartridges_i.jpg', NULL, NULL, NULL, 1, '~/Assets/ProductImages/hp-inkjet-cartridges_t.jpg', NULL, '~/Assets/ProductImages/hp-inkjet-cartridges.jpg', NULL, 'This is a recurring order subscription which will automatically generate new orders as the payment is coming due.', '<p><span style="font-size: small;">This is one&nbsp;example of a recurring order subscription product.&nbsp; Automate delivery of products that are reused or purchased on a regular basis.&nbsp; Like pet food, baby products, coffee, tea, filters, refills, and much more!&nbsp; </span><span style="font-size: small;">Use the subscribe and save feature to encourage your customers to signup.</span></p>
<p><span style="font-size: small;">Remove the hassle of repeat purchases or forgetting to order before you run out.&nbsp; Our easy subscription plan allows you to choose your own custom&nbsp;delivery frequency.&nbsp; We''ll send you payment reminders and you can cancel at any time.&nbsp; If you need to change your address or payment information, just login to your account and visit the Subscriptions page to make updates.</span></p>', NULL, NULL, NULL, NULL, NULL, NULL, 1 ) 

SET IDENTITY_INSERT [ac_Products] OFF;

-- </[ac_Products]>

GO

-- <[ac_Specials]>

SET IDENTITY_INSERT [ac_Specials] ON;

INSERT INTO [ac_Specials] ( [SpecialId], [ProductId], [Price] ) 
 VALUES ( 1, 41, 6.99 ) 

SET IDENTITY_INSERT [ac_Specials] OFF;

-- </[ac_Specials]>

GO

-- <[ac_Kits]>
INSERT INTO [ac_Kits] ([ProductId], [ItemizeDisplay]) 
VALUES ( 5, 0 );
GO

-- <[ac_ProductProductTemplates]>

INSERT INTO [ac_ProductProductTemplates] ([ProductId], [ProductTemplateId]) 
	VALUES ( 1, 4 );

INSERT INTO [ac_ProductProductTemplates] ([ProductId], [ProductTemplateId]) 
	VALUES ( 4, 3 );

-- </[ac_ProductProductTemplates]>

GO

-- <[ac_CatalogNodes]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 0, 1, 0, 0 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 4, 1, 1, 1 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 1, 2, 0, 0 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 1, 3, 0, 1 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 4, 3, 1, 2 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 1, 4, 0, 2 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 2, 4, 1, 8 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 1, 5, 0, 3 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 2, 5, 1, 1 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 2, 6, 0, 2 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 6, 1, 0 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 7, 1, 1 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 8, 1, 3 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 9, 1, 4 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 10, 1, 5 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 11, 1, 6 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 12, 1, 7 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 13, 1, 8 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 14, 1, 9 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 15, 1, 10 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 16, 1, 11 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 17, 1, 12 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 18, 1, 13 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 19, 1, 14 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 20, 1, 15 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 21, 1, 16 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 22, 1, 17 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 23, 1, 18 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 24, 1, 19 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 26, 1, 20 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 27, 1, 21 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 28, 1, 22 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 29, 1, 2 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 30, 1, 23 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 6, 31, 1, 24 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 3, 32, 1, 7 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 2, 33, 1, 4 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 3, 34, 1, 4 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 3, 35, 1, 5 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 3, 36, 1, 6 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 5, 37, 1, 1 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 5, 38, 1, 2 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 5, 39, 1, 3 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 3, 40, 1, 2 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 4, 41, 1, 3 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy]) 
	VALUES ( 3, 42, 1, 3 );

INSERT INTO [ac_CatalogNodes] ([CategoryId], [CatalogNodeId], [CatalogNodeTypeId], [OrderBy] ) 
	VALUES ( 5, 43, 1, 4 );

-- </[ac_CatalogNodes]>

GO

-- <[ac_Options]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_Options] ON;

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 2, 'Choose Style', 1, 0, 0, 0, '2015-03-01 19:59:04.063' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 3, 'Choose Style', 1, 0, 120, 71, '2015-03-01 16:55:49.297' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 4, 'Choose Color', 0, 0, 0, 0, '2015-03-01 18:00:09.953' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 5, 'Choose a City', 0, 0, 0, 0, '2015-03-01 16:01:28.267' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 6, 'Choose a Month', 0, 0, 0, 0, '2015-03-01 16:02:38.923' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 7, 'Choose Day', 0, 0, 0, 0, '2015-03-01 16:03:58.233' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 8, 'Choose Length', 0, 0, 0, 0, '2015-03-01 17:36:01.517' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 9, 'Choose Platform', 0, 0, 0, 0, '2015-03-01 20:53:29.173' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 10, 'Choose Color', 1, 4, 50, 50, '2015-03-01 23:43:49.720' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 11, 'Gender', 0, 0, 0, 0, '2015-03-01 16:42:34.313' );

INSERT INTO [ac_Options] ([OptionId], [Name], [ShowThumbnails], [ThumbnailColumns], [ThumbnailWidth], [ThumbnailHeight], [CreatedDate]) 
	VALUES ( 12, 'Sizes', 0, 0, 0, 0, '2015-03-01 16:42:58.187' );

SET IDENTITY_INSERT [ac_Options] OFF;

-- </[ac_Options]>

GO

-- <[ac_OptionChoices]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_OptionChoices] ON;

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 5, 2, 'Purple', '~/Assets/ProductImages/gift_card_purplebow_t.jpg', '~/Assets/ProductImages/gift_card_purplebow.jpg', NULL, NULL, NULL, NULL, 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 6, 2, 'Green', '~/Assets/ProductImages/gift_card_greenbow_t.jpg', '~/Assets/ProductImages/gift_card_greenbow.jpg', NULL, NULL, NULL, NULL, 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 7, 2, 'Gold', '~/Assets/ProductImages/gift_card_goldbow_t.jpg', '~/Assets/ProductImages/gift_card_goldbow.jpg', NULL, NULL, NULL, NULL, 0, 3 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 8, 2, 'Red', '~/Assets/ProductImages/gift_card_redbow_t.jpg', '~/Assets/ProductImages/gift_card_redbow.jpg', NULL, NULL, NULL, NULL, 0, 4 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 9, 3, 'VIP Card', '~/Assets/ProductImages/gift_card_vip_t.jpg', '~/Assets/ProductImages/gift_card_vip.jpg', NULL, NULL, NULL, NULL, 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 10, 3, 'Gift Card', '~/Assets/ProductImages/gift_card_t.jpg', '~/Assets/ProductImages/gift_card.jpg', NULL, NULL, NULL, NULL, 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 11, 4, 'Black', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 12, 4, 'White', NULL, NULL, NULL, NULL, NULL, NULL, 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 13, 4, 'Chrome', NULL, NULL, NULL, NULL, NULL, NULL, 0, 3 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 14, 5, 'Seattle', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 15, 5, 'San Diego', NULL, NULL, NULL, NULL, NULL, NULL, 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 18, 5, 'Chicago', NULL, NULL, NULL, NULL, NULL, NULL, 0, 5 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 26, 6, 'June', NULL, NULL, NULL, NULL, NULL, NULL, 0, 6 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 27, 6, 'July', NULL, NULL, NULL, NULL, NULL, NULL, 0, 7 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 28, 6, 'August', NULL, NULL, NULL, NULL, NULL, NULL, 0, 8 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 32, 7, '1', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 33, 7, '2', NULL, NULL, NULL, NULL, NULL, NULL, 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 34, 7, '3', NULL, NULL, NULL, NULL, NULL, NULL, 0, 3 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 35, 7, '4', NULL, NULL, NULL, NULL, NULL, NULL, 0, 4 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 36, 7, '5', NULL, NULL, NULL, NULL, NULL, NULL, 0, 5 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 37, 7, '6', NULL, NULL, NULL, NULL, NULL, NULL, 0, 6 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 38, 7, '7', NULL, NULL, NULL, NULL, NULL, NULL, 0, 7 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 39, 7, '8', NULL, NULL, NULL, NULL, NULL, NULL, 0, 8 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 40, 7, '9', NULL, NULL, NULL, NULL, NULL, NULL, 0, 9 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 41, 7, '10', NULL, NULL, NULL, NULL, NULL, NULL, 0, 10 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 42, 7, '11', NULL, NULL, NULL, NULL, NULL, NULL, 0, 11 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 43, 7, '12', NULL, NULL, NULL, NULL, NULL, NULL, 0, 12 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 44, 7, '13', NULL, NULL, NULL, NULL, NULL, NULL, 0, 13 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 45, 7, '14', NULL, NULL, NULL, NULL, NULL, NULL, 0, 14 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 46, 7, '15', NULL, NULL, NULL, NULL, NULL, NULL, 0, 15 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 47, 7, '16', NULL, NULL, NULL, NULL, NULL, NULL, 0, 16 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 48, 7, '17', NULL, NULL, NULL, NULL, NULL, NULL, 0, 17 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 49, 7, '18', NULL, NULL, NULL, NULL, NULL, NULL, 0, 18 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 50, 7, '19', NULL, NULL, NULL, NULL, NULL, NULL, 0, 19 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 51, 7, '20', NULL, NULL, NULL, NULL, NULL, NULL, 0, 20 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 52, 7, '21', NULL, NULL, NULL, NULL, NULL, NULL, 0, 21 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 53, 7, '22', NULL, NULL, NULL, NULL, NULL, NULL, 0, 22 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 54, 7, '23', NULL, NULL, NULL, NULL, NULL, NULL, 0, 23 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 55, 7, '24', NULL, NULL, NULL, NULL, NULL, NULL, 0, 24 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 56, 7, '25', NULL, NULL, NULL, NULL, NULL, NULL, 0, 25 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 57, 7, '26', NULL, NULL, NULL, NULL, NULL, NULL, 0, 26 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 58, 7, '27', NULL, NULL, NULL, NULL, NULL, NULL, 0, 27 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 59, 7, '28', NULL, NULL, NULL, NULL, NULL, NULL, 0, 28 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 60, 7, '29', NULL, NULL, NULL, NULL, NULL, NULL, 0, 29 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 61, 7, '30', NULL, NULL, NULL, NULL, NULL, NULL, 0, 30 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 62, 7, '31', NULL, NULL, NULL, NULL, NULL, NULL, 0, 31 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 63, 8, '6 FT', NULL, NULL, 0.00, NULL, NULL, '6', 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 64, 8, '10 FT + $5.00', NULL, NULL, 5.00, NULL, NULL, '10', 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 65, 8, '20 FT + $15.00', NULL, NULL, 15.00, NULL, NULL, '20', 0, 3 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 66, 9, 'Windows', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 67, 9, 'Linux', NULL, NULL, NULL, NULL, NULL, NULL, 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 68, 10, 'Blue', '~/Assets/ProductImages/cat5_blue_i.jpg', '~/Assets/ProductImages/cat5_blue.jpg', NULL, NULL, NULL, NULL, 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 69, 10, 'Green', '~/Assets/ProductImages/cat5_green_i.jpg', '~/Assets/ProductImages/cat5_green.jpg', NULL, NULL, NULL, NULL, 0, 3 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 70, 10, 'Red', '~/Assets/ProductImages/cat5_red_i.jpg', '~/Assets/ProductImages/cat5_red.jpg', NULL, NULL, NULL, NULL, 0, 0 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 71, 10, 'Yellow', '~/Assets/ProductImages/cat5_yellow_i.jpg', '~/Assets/ProductImages/cat5_yellow.jpg', NULL, NULL, NULL, NULL, 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 73, 8, '50 FT + $35.00', NULL, NULL, 35.00, NULL, NULL, '50', 0, 4 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 74, 11, 'Male', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 75, 11, 'Female', NULL, NULL, NULL, NULL, NULL, NULL, 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 76, 12, 'Small', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 77, 12, 'Medium', NULL, NULL, NULL, NULL, NULL, NULL, 0, 2 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 78, 12, 'Large', NULL, NULL, NULL, NULL, NULL, NULL, 0, 3 );

INSERT INTO [ac_OptionChoices] ([OptionChoiceId], [OptionId], [Name], [ThumbnailUrl], [ImageUrl], [PriceModifier], [CogsModifier], [WeightModifier], [SkuModifier], [Selected], [OrderBy]) 
	VALUES ( 79, 12, 'X-Large', NULL, NULL, NULL, NULL, NULL, NULL, 0, 4 );

SET IDENTITY_INSERT [ac_OptionChoices] OFF;

-- </[ac_OptionChoices]>

GO

-- <[ac_ProductOptions]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 1, 2, 0 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 3, 3, 1 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 4, 4, 1 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 32, 5, 1 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 32, 6, 2 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 32, 7, 3 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 35, 8, 1 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 38, 9, 1 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 40, 10, 1 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 41, 11, 1 );

INSERT INTO [ac_ProductOptions] ([ProductId], [OptionId], [OrderBy]) 
	VALUES ( 41, 12, 2 );


-- </[ac_ProductOptions]>

GO

-- <[ac_ProductVariants]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_ProductVariants] ON;

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 21, 1, 5, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 22, 1, 6, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 23, 1, 7, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 24, 1, 8, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 25, 3, 9, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 26, 3, 10, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 27, 4, 11, 0, 0, 0, 0, 0, 0, 0, 'Black', 'SN-42PX60U-BL', NULL, 0, NULL, 0, NULL, 100, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 28, 4, 12, 0, 0, 0, 0, 0, 0, 0, 'White', 'SN-42PX60U-WH', NULL, 0, NULL, 0, NULL, 150, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 29, 4, 13, 0, 0, 0, 0, 0, 0, 0, 'Chrome', 'SN-42PX60U-CR', NULL, 0, NULL, 0, NULL, 75, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 149, 32, 14, 26, 32, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 150, 32, 15, 26, 32, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 153, 32, 18, 26, 32, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 156, 32, 14, 27, 32, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 157, 32, 15, 27, 32, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 160, 32, 18, 27, 32, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 163, 32, 14, 28, 32, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 164, 32, 15, 28, 32, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 167, 32, 18, 28, 32, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 226, 32, 14, 26, 33, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 227, 32, 15, 26, 33, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 230, 32, 18, 26, 33, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 233, 32, 14, 27, 33, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 234, 32, 15, 27, 33, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 237, 32, 18, 27, 33, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 240, 32, 14, 28, 33, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 241, 32, 15, 28, 33, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 244, 32, 18, 28, 33, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 303, 32, 14, 26, 34, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 304, 32, 15, 26, 34, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 307, 32, 18, 26, 34, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 310, 32, 14, 27, 34, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 311, 32, 15, 27, 34, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 314, 32, 18, 27, 34, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 317, 32, 14, 28, 34, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 318, 32, 15, 28, 34, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 321, 32, 18, 28, 34, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 380, 32, 14, 26, 35, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 381, 32, 15, 26, 35, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 384, 32, 18, 26, 35, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 387, 32, 14, 27, 35, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 388, 32, 15, 27, 35, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 391, 32, 18, 27, 35, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 394, 32, 14, 28, 35, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 395, 32, 15, 28, 35, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 398, 32, 18, 28, 35, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 457, 32, 14, 26, 36, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 458, 32, 15, 26, 36, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 461, 32, 18, 26, 36, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 464, 32, 14, 27, 36, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 465, 32, 15, 27, 36, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 468, 32, 18, 27, 36, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 471, 32, 14, 28, 36, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 472, 32, 15, 28, 36, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 475, 32, 18, 28, 36, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 534, 32, 14, 26, 37, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 535, 32, 15, 26, 37, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 538, 32, 18, 26, 37, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 541, 32, 14, 27, 37, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 542, 32, 15, 27, 37, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 545, 32, 18, 27, 37, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 548, 32, 14, 28, 37, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 549, 32, 15, 28, 37, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 552, 32, 18, 28, 37, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 611, 32, 14, 26, 38, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 612, 32, 15, 26, 38, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 615, 32, 18, 26, 38, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 618, 32, 14, 27, 38, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 619, 32, 15, 27, 38, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 622, 32, 18, 27, 38, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 625, 32, 14, 28, 38, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 626, 32, 15, 28, 38, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 629, 32, 18, 28, 38, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 688, 32, 14, 26, 39, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 689, 32, 15, 26, 39, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 692, 32, 18, 26, 39, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 695, 32, 14, 27, 39, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 696, 32, 15, 27, 39, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 699, 32, 18, 27, 39, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 702, 32, 14, 28, 39, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 703, 32, 15, 28, 39, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 706, 32, 18, 28, 39, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 765, 32, 14, 26, 40, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 766, 32, 15, 26, 40, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 769, 32, 18, 26, 40, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 772, 32, 14, 27, 40, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 773, 32, 15, 27, 40, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 776, 32, 18, 27, 40, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 779, 32, 14, 28, 40, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 780, 32, 15, 28, 40, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 783, 32, 18, 28, 40, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 842, 32, 14, 26, 41, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 843, 32, 15, 26, 41, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 846, 32, 18, 26, 41, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 849, 32, 14, 27, 41, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 850, 32, 15, 27, 41, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 853, 32, 18, 27, 41, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 856, 32, 14, 28, 41, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 857, 32, 15, 28, 41, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 860, 32, 18, 28, 41, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 919, 32, 14, 26, 42, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 920, 32, 15, 26, 42, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 923, 32, 18, 26, 42, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 926, 32, 14, 27, 42, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 927, 32, 15, 27, 42, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 930, 32, 18, 27, 42, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 933, 32, 14, 28, 42, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 934, 32, 15, 28, 42, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 937, 32, 18, 28, 42, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 996, 32, 14, 26, 43, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 997, 32, 15, 26, 43, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1000, 32, 18, 26, 43, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1003, 32, 14, 27, 43, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1004, 32, 15, 27, 43, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1007, 32, 18, 27, 43, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1010, 32, 14, 28, 43, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1011, 32, 15, 28, 43, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1014, 32, 18, 28, 43, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1073, 32, 14, 26, 44, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1074, 32, 15, 26, 44, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1077, 32, 18, 26, 44, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1080, 32, 14, 27, 44, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1081, 32, 15, 27, 44, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1084, 32, 18, 27, 44, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1087, 32, 14, 28, 44, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1088, 32, 15, 28, 44, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1091, 32, 18, 28, 44, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1150, 32, 14, 26, 45, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1151, 32, 15, 26, 45, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1154, 32, 18, 26, 45, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1157, 32, 14, 27, 45, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1158, 32, 15, 27, 45, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1161, 32, 18, 27, 45, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1164, 32, 14, 28, 45, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1165, 32, 15, 28, 45, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1168, 32, 18, 28, 45, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1227, 32, 14, 26, 46, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1228, 32, 15, 26, 46, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1231, 32, 18, 26, 46, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1234, 32, 14, 27, 46, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1235, 32, 15, 27, 46, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1238, 32, 18, 27, 46, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1241, 32, 14, 28, 46, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1242, 32, 15, 28, 46, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1245, 32, 18, 28, 46, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1304, 32, 14, 26, 47, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1305, 32, 15, 26, 47, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1308, 32, 18, 26, 47, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1311, 32, 14, 27, 47, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1312, 32, 15, 27, 47, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1315, 32, 18, 27, 47, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1318, 32, 14, 28, 47, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1319, 32, 15, 28, 47, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1322, 32, 18, 28, 47, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1381, 32, 14, 26, 48, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1382, 32, 15, 26, 48, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1385, 32, 18, 26, 48, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1388, 32, 14, 27, 48, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1389, 32, 15, 27, 48, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1392, 32, 18, 27, 48, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1395, 32, 14, 28, 48, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1396, 32, 15, 28, 48, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1399, 32, 18, 28, 48, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1458, 32, 14, 26, 49, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1459, 32, 15, 26, 49, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1462, 32, 18, 26, 49, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1465, 32, 14, 27, 49, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1466, 32, 15, 27, 49, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1469, 32, 18, 27, 49, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1472, 32, 14, 28, 49, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1473, 32, 15, 28, 49, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1476, 32, 18, 28, 49, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1535, 32, 14, 26, 50, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1536, 32, 15, 26, 50, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1539, 32, 18, 26, 50, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1542, 32, 14, 27, 50, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1543, 32, 15, 27, 50, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1546, 32, 18, 27, 50, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1549, 32, 14, 28, 50, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1550, 32, 15, 28, 50, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1553, 32, 18, 28, 50, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1612, 32, 14, 26, 51, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1613, 32, 15, 26, 51, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1616, 32, 18, 26, 51, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1619, 32, 14, 27, 51, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1620, 32, 15, 27, 51, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1623, 32, 18, 27, 51, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1626, 32, 14, 28, 51, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1627, 32, 15, 28, 51, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1630, 32, 18, 28, 51, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1689, 32, 14, 26, 52, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1690, 32, 15, 26, 52, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1693, 32, 18, 26, 52, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1696, 32, 14, 27, 52, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1697, 32, 15, 27, 52, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1700, 32, 18, 27, 52, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1703, 32, 14, 28, 52, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1704, 32, 15, 28, 52, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1707, 32, 18, 28, 52, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1766, 32, 14, 26, 53, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1767, 32, 15, 26, 53, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1770, 32, 18, 26, 53, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1773, 32, 14, 27, 53, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1774, 32, 15, 27, 53, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1777, 32, 18, 27, 53, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1780, 32, 14, 28, 53, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1781, 32, 15, 28, 53, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1784, 32, 18, 28, 53, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1843, 32, 14, 26, 54, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1844, 32, 15, 26, 54, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1847, 32, 18, 26, 54, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1850, 32, 14, 27, 54, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1851, 32, 15, 27, 54, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1854, 32, 18, 27, 54, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1857, 32, 14, 28, 54, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1858, 32, 15, 28, 54, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1861, 32, 18, 28, 54, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1920, 32, 14, 26, 55, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1921, 32, 15, 26, 55, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1924, 32, 18, 26, 55, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1927, 32, 14, 27, 55, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1928, 32, 15, 27, 55, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1931, 32, 18, 27, 55, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1934, 32, 14, 28, 55, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1935, 32, 15, 28, 55, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1938, 32, 18, 28, 55, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1997, 32, 14, 26, 56, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 1998, 32, 15, 26, 56, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2001, 32, 18, 26, 56, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2004, 32, 14, 27, 56, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2005, 32, 15, 27, 56, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2008, 32, 18, 27, 56, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2011, 32, 14, 28, 56, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2012, 32, 15, 28, 56, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2015, 32, 18, 28, 56, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2074, 32, 14, 26, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2075, 32, 15, 26, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2078, 32, 18, 26, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2081, 32, 14, 27, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2082, 32, 15, 27, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2085, 32, 18, 27, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2088, 32, 14, 28, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2089, 32, 15, 28, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2092, 32, 18, 28, 57, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2151, 32, 14, 26, 58, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2152, 32, 15, 26, 58, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2155, 32, 18, 26, 58, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2158, 32, 14, 27, 58, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2159, 32, 15, 27, 58, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2162, 32, 18, 27, 58, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2165, 32, 14, 28, 58, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2166, 32, 15, 28, 58, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2169, 32, 18, 28, 58, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2228, 32, 14, 26, 59, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2229, 32, 15, 26, 59, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2232, 32, 18, 26, 59, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2235, 32, 14, 27, 59, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2236, 32, 15, 27, 59, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2239, 32, 18, 27, 59, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2242, 32, 14, 28, 59, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2243, 32, 15, 28, 59, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2246, 32, 18, 28, 59, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2305, 32, 14, 26, 60, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2306, 32, 15, 26, 60, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2309, 32, 18, 26, 60, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2312, 32, 14, 27, 60, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2313, 32, 15, 27, 60, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2316, 32, 18, 27, 60, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2319, 32, 14, 28, 60, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2320, 32, 15, 28, 60, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2323, 32, 18, 28, 60, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2382, 32, 14, 26, 61, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2383, 32, 15, 26, 61, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2386, 32, 18, 26, 61, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2389, 32, 14, 27, 61, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2390, 32, 15, 27, 61, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2393, 32, 18, 27, 61, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2396, 32, 14, 28, 61, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2397, 32, 15, 28, 61, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2400, 32, 18, 28, 61, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2459, 32, 14, 26, 62, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2460, 32, 15, 26, 62, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2463, 32, 18, 26, 62, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2466, 32, 14, 27, 62, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2467, 32, 15, 27, 62, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2470, 32, 18, 27, 62, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2473, 32, 14, 28, 62, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2474, 32, 15, 28, 62, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2477, 32, 18, 28, 62, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 12, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2501, 35, 63, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2502, 35, 64, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2503, 35, 65, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2504, 38, 66, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2505, 38, 67, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2506, 40, 68, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2507, 40, 69, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2508, 40, 70, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2509, 40, 71, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2511, 35, 73, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2514, 41, 74, 76, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 40, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2515, 41, 75, 76, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 40, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2516, 41, 74, 77, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 50, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2517, 41, 75, 77, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 50, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2518, 41, 74, 78, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 60, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2519, 41, 75, 78, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 60, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2520, 41, 74, 79, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 40, 0, 1 );

INSERT INTO [ac_ProductVariants] ([ProductVariantId], [ProductId], [Option1], [Option2], [Option3], [Option4], [Option5], [Option6], [Option7], [Option8], [VariantName], [Sku], [Price], [PriceModeId], [Weight], [WeightModeId], [CostOfGoods], [InStock], [InStockWarningLevel], [Available]) 
	VALUES ( 2521, 41, 75, 79, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, 0, NULL, 40, 0, 1 );

SET IDENTITY_INSERT [ac_ProductVariants] OFF;

-- </[ac_ProductVariants]>

GO

-- <[ac_KitComponents]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_KitComponents] ON;

INSERT INTO [ac_KitComponents] ([KitComponentId], [StoreId], [Name], [UserPrompt], [InputTypeId], [Columns], [HeaderOption]) 
	VALUES ( 1, 1, 'Processor', NULL, 2, 0, NULL );

INSERT INTO [ac_KitComponents] ([KitComponentId], [StoreId], [Name], [UserPrompt], [InputTypeId], [Columns], [HeaderOption]) 
	VALUES ( 2, 1, 'Operating System', NULL, 2, 0, NULL );

INSERT INTO [ac_KitComponents] ([KitComponentId], [StoreId], [Name], [UserPrompt], [InputTypeId], [Columns], [HeaderOption]) 
	VALUES ( 3, 1, 'Video Cards', NULL, 2, 0, NULL );

INSERT INTO [ac_KitComponents] ([KitComponentId], [StoreId], [Name], [UserPrompt], [InputTypeId], [Columns], [HeaderOption]) 
	VALUES ( 4, 1, 'Memory', NULL, 3, 0, NULL );

INSERT INTO [ac_KitComponents] ([KitComponentId], [StoreId], [Name], [UserPrompt], [InputTypeId], [Columns], [HeaderOption]) 
	VALUES ( 5, 1, 'Hard Drives', NULL, 2, 0, NULL );

INSERT INTO [ac_KitComponents] ([KitComponentId], [StoreId], [Name], [UserPrompt], [InputTypeId], [Columns], [HeaderOption]) 
	VALUES ( 6, 1, 'Monitors', NULL, 2, 0, NULL );

INSERT INTO [ac_KitComponents] ([KitComponentId], [StoreId], [Name], [UserPrompt], [InputTypeId], [Columns], [HeaderOption]) 
	VALUES ( 7, 1, 'CD or DVD Drive', NULL, 3, 0, NULL );

INSERT INTO [ac_KitComponents] ([KitComponentId], [StoreId], [Name], [UserPrompt], [InputTypeId], [Columns], [HeaderOption]) 
	VALUES ( 8, 1, 'Anti-Virus/Security Suite', NULL, 1, 0, NULL );

INSERT INTO [ac_KitComponents] ([KitComponentId], [StoreId], [Name], [UserPrompt], [InputTypeId], [Columns], [HeaderOption]) 
	VALUES ( 9, 1, 'Warranty and Service', NULL, 4, 0, NULL );

SET IDENTITY_INSERT [ac_KitComponents] OFF;

-- </[ac_KitComponents]>

GO

-- <[ac_ProductKitComponents]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

INSERT INTO [ac_ProductKitComponents] ([ProductId], [KitComponentId], [OrderBy]) 
	VALUES ( 5, 1, 1 );

INSERT INTO [ac_ProductKitComponents] ([ProductId], [KitComponentId], [OrderBy]) 
	VALUES ( 5, 2, 2 );

INSERT INTO [ac_ProductKitComponents] ([ProductId], [KitComponentId], [OrderBy]) 
	VALUES ( 5, 3, 3 );

INSERT INTO [ac_ProductKitComponents] ([ProductId], [KitComponentId], [OrderBy]) 
	VALUES ( 5, 4, 4 );

INSERT INTO [ac_ProductKitComponents] ([ProductId], [KitComponentId], [OrderBy]) 
	VALUES ( 5, 5, 5 );

INSERT INTO [ac_ProductKitComponents] ([ProductId], [KitComponentId], [OrderBy]) 
	VALUES ( 5, 6, 6 );

INSERT INTO [ac_ProductKitComponents] ([ProductId], [KitComponentId], [OrderBy]) 
	VALUES ( 5, 7, 7 );

INSERT INTO [ac_ProductKitComponents] ([ProductId], [KitComponentId], [OrderBy]) 
	VALUES ( 5, 8, 8 );

INSERT INTO [ac_ProductKitComponents] ([ProductId], [KitComponentId], [OrderBy]) 
	VALUES ( 5, 9, 9 );


-- </[ac_ProductKitComponents]>

GO

-- <[ac_KitProducts]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_KitProducts] ON;

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 1, 1, 6, NULL, 'Intel Core 2 Duo Processor (2MB Cache,2.0GHz)', 1, 0.0000, 0, 0.0000, 0, 1, 1 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 2, 1, 7, NULL, 'Intel Core 2 Duo Processor (4MB Cache,2.13GHZ)', 1, 150.0000, 2, 0.0000, 0, 0, 2 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 3, 2, 8, NULL, 'Windows Vista Home Premium', 1, 0.0000, 0, 0.0000, 0, 1, 1 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 4, 2, 9, NULL, 'Windows XP Professional', 1, 0.0000, 0, 0.0000, 0, 0, 2 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 5, 3, 10, NULL, 'Intel Graphics Media Accelerator 3000', 1, 0.0000, 0, 0.0000, 0, 1, 0 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 7, 4, 12, NULL, '2 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', 1, 0.0000, 0, 0.0000, 0, 1, 1 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 8, 4, 13, NULL, '4 GB Dual Channel DDR2 SDRAM at 667MHz- 2DIMMs', 1, 80.0000, 2, 0.0000, 0, 0, 2 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 9, 5, 14, NULL, '250 GB Hard Drive (7200RPM) w/DataBurst Cache', 1, 0.0000, 0, 0.0000, 0, 1, 1 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 10, 5, 15, NULL, '320 GB Hard Drive (7200RPM) w/DataBurst Cache', 1, 60.0000, 2, 0.0000, 0, 0, 2 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 11, 6, 16, NULL, '19 inch SE198WFP Widescreen Flat Panel Monitor', 1, 0.0000, 0, 0.0000, 0, 1, 1 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 12, 6, 17, NULL, '20 inch E207WFP Widescreen Digital Flat Panel', 1, 99.0000, 2, 0.0000, 0, 0, 2 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 13, 6, 18, NULL, '22 inch E228WFP Widescreen Digital Flat Panel', 1, 199.0000, 2, 0.0000, 0, 0, 3 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 14, 7, 19, NULL, '24X CD-RW/ DVD Combo Drive', 1, 0.0000, 0, 0.0000, 0, 1, 1 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 15, 7, 20, NULL, '8x DVD+/-RW Drive', 1, 39.0000, 2, 0.0000, 0, 0, 2 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 16, 8, 23, NULL, 'McAfee SecurityCenter with anti-virus, anti-spyware, firewall, 15-months', 1, 0.0000, 0, 0.0000, 0, 0, 1 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 17, 9, 24, NULL, '1 Year In-Home Service Parts', 1, 25.0000, 2, 0.0000, 0, 0, 1 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 19, 2, 26, NULL, 'Windows XP Home', 1, 0.0000, 0, 0.0000, 0, 0, 3 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 20, 5, 27, NULL, '500 GB Hard Drive (7200RPM) w/DataBurst Cache', 1, 100.0000, 2, 0.0000, 0, 0, 3 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 21, 9, 28, NULL, '1 Year - 24x7 Phone Support', 1, 69.0000, 2, 0.0000, 0, 0, 2 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 22, 1, 29, NULL, 'Intel CoreTM 2 Duo Processor (4MB Cache,2.66GHz)', 1, 199.0000, 2, 0.0000, 0, 0, 3 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 23, 3, 30, NULL, 'ATI Radeon X1300 Pro 256MB', 1, 129.0000, 2, 0.0000, 0, 0, 2 );

INSERT INTO [ac_KitProducts] ([KitProductId], [KitComponentId], [ProductId], [OptionList], [Name], [Quantity], [Price], [PriceModeId], [Weight], [WeightModeId], [IsSelected], [OrderBy]) 
	VALUES ( 24, 3, 31, NULL, 'ATI Radeon X1300 128MB', 1, 89.0000, 2, 0.0000, 0, 0, 1 );

SET IDENTITY_INSERT [ac_KitProducts] OFF;

-- </[ac_KitProducts]>

GO

-- <[ac_ReviewerProfiles]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_ReviewerProfiles] ON;

INSERT INTO [ac_ReviewerProfiles] ([ReviewerProfileId], [Email], [DisplayName], [Location], [EmailVerified], [EmailVerificationCode]) 
	VALUES ( 1, 'sara@sample.xyz', 'Sara', 'USA', 0, NULL );

INSERT INTO [ac_ReviewerProfiles] ([ReviewerProfileId], [Email], [DisplayName], [Location], [EmailVerified], [EmailVerificationCode]) 
	VALUES ( 2, 'katie@sample.xyz', 'Katie', 'Vancouver, WA', 0, NULL );

INSERT INTO [ac_ReviewerProfiles] ([ReviewerProfileId], [Email], [DisplayName], [Location], [EmailVerified], [EmailVerificationCode]) 
	VALUES ( 3, 'joe@sample.xyz', 'Joe', 'Vancouver, WA', 0, NULL );

INSERT INTO [ac_ReviewerProfiles] ([ReviewerProfileId], [Email], [DisplayName], [Location], [EmailVerified], [EmailVerificationCode]) 
	VALUES ( 4, 'katy@samlpe.xyz', 'Katy', 'Iowa', 0, NULL );

INSERT INTO [ac_ReviewerProfiles] ([ReviewerProfileId], [Email], [DisplayName], [Location], [EmailVerified], [EmailVerificationCode]) 
	VALUES ( 5, 'jim@sample.xyz', 'James', 'Seattle, WA', 0, NULL );

SET IDENTITY_INSERT [ac_ReviewerProfiles] OFF;

-- </[ac_ReviewerProfiles]>

GO

-- <[ac_ProductReviews]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_ProductReviews] ON;

INSERT INTO [ac_ProductReviews] ([ProductReviewId], [ProductId], [ReviewerProfileId], [ReviewDate], [Rating], [ReviewTitle], [ReviewBody], [IsApproved]) 
	VALUES ( 1, 4, 1, '2015-09-10 22:42:54.907', 10, 'Great value - Great Quality', 'Sanasonic introduced the SN-42PX60U with an MSRP of $2,499 but it can easily be found around $2,000 at one of several Internet retailers. 

The SN-42PX60U is not only an impressive plasma display, but it is the most affordable of the top-tier plasma televisions. Both Wamsung and Tushiba have 42" plasma televisions on the market with marginally lower prices, but they can hardly compete with the superior picture quality of the SN-42PX60U.  Bioneer''s PDP-4360HD has a very high-quality picture, but Bioneer also includes superfluous features such as a separate box which inflate the PDP-4360HD''s price to roughly $1,500 more than that of the SN-42PX60U. Perhaps the most interesting price comparison is between the SN-42PX60U and its predecessor, the SN-42PX50U. When it hit the market in 2005, the SN-42PX50U was heralded for its great value - it had an MSRP of $2,999; $500 more than the SN-42PX60U!

Like earlier Sanasonic plasma televisions, the Sanasonic SN-42PX60U has excellent black levels, contrast, color reproduction, and aesthetic appeal. There is simply no other 42" plasma television on the market today that can match both its picture quality and its price point in the market. Sanasonic was very smart to cut unneeded features from the SN-42PX60U to keep the price low while adding important new features like a second HDMI input and a front-panel composite input. This plasma television is for those HDTV buyers who demand paramount picture quality at a reasonable price.
', 1 );

INSERT INTO [ac_ProductReviews] ([ProductReviewId], [ProductId], [ReviewerProfileId], [ReviewDate], [Rating], [ReviewTitle], [ReviewBody], [IsApproved]) 
	VALUES ( 2, 39, 2, '2015-09-12 22:48:12.813', 10, 'Great ecommerce resource', 'I recently subscribed to this magazine and found it very informative.  My online sales have gone up dramatically since switching to AbleCommerce.  I discovered that AbleCommerce is one of the top-rated shopping systems reviewed in this magazine.  I would recommend a subscription to Ecommerce magazine if you want to keep up with all the online shopping news.', 1 );

INSERT INTO [ac_ProductReviews] ([ProductReviewId], [ProductId], [ReviewerProfileId], [ReviewDate], [Rating], [ReviewTitle], [ReviewBody], [IsApproved]) 
	VALUES ( 3, 33, 3, '2015-09-14 20:16:27.767', 10, 'Great buy and excellent print quality', 'When it comes to buying a computer, we all need so many different things. While there have been more perspective buyers of MP3 players and USB Flash Drives, printers have never lost their edge when making sure your needs for your computer are secure and simple. However, most printer are expensive in value, and don''t actually deliver everything in your printers'' needs. Bell knows that feeling for the consumers. For the past few decades, they''ve made the best quality printers for your everyday needs, whether it is printing up a resume, or setting up for a school project, and this one is no exception. 

The Bell All-in-One printer is a easy to use printer for all your needs and wants. This printer is easy to setup and is compatible to Windows 98, ME and XP. The printer also is simple to install. The software that comes with it makes it easy for you to print pictures as well from your digital cameras, and has red eye reduction software, so you can print your pictures with confidence. The printer works great with the any standard Inkjet cartridges that print as many as 20 pages per minute. It also shows you how much ink you have at a much more proficient level of when you need to replace or refill you cartridges. The software is easy to setup and connects with a simple USB 2.0 cable, rather than one of those bulkier ones. There is one disadvantage though. If you have an older computer that doesn''t have USB 2.0 connections, you''d have to buy a USB 2.0 card for your computer for it to work. Otherwise, you wouldn''t be able to print anything. 
All in all, the Bell All-in-One Printer is a great buy not just because of the value, but it really delivers a high level quality that other printer today don''t deliver as well. It really is worth it for anyone shopping for a new printer for their everyday needs. 
', 1 );

INSERT INTO [ac_ProductReviews] ([ProductReviewId], [ProductId], [ReviewerProfileId], [ReviewDate], [Rating], [ReviewTitle], [ReviewBody], [IsApproved]) 
	VALUES ( 4, 5, 4, '2015-09-14 20:23:01.877', 10, 'Wow - this is great', 'Not only is this a great computer system, but I can totally configure the components to meet my specific needs.  Since I''m a hard-core gamer, I needed to increase the speed and video card to play the demanding video games available today.', 1 );

INSERT INTO [ac_ProductReviews] ([ProductReviewId], [ProductId], [ReviewerProfileId], [ReviewDate], [Rating], [ReviewTitle], [ReviewBody], [IsApproved]) 
	VALUES ( 5, 42, 5, '2015-09-14 20:37:15.860', 10, 'Easy to Use and program', 'I love this remote, it''s easy to use, program, and the overall performance is excellent. I''ve used several universal remotes in the past, but this one''s outstanding. Even the shape and design makes it comfortable for you to control.', 1 );

SET IDENTITY_INSERT [ac_ProductReviews] OFF;

-- </[ac_ProductReviews]>

GO

-- <[ac_ProductImages]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_ProductImages] ON;

INSERT INTO [ac_ProductImages] ([ProductImageId], [ProductId], [ImageUrl], [ImageAltText], [OrderBy]) 
	VALUES ( 1, 4, '~/Assets/ProductImages/plasma_tv_displayed.jpg', NULL, 1 );

INSERT INTO [ac_ProductImages] ([ProductImageId], [ProductId], [ImageUrl], [ImageAltText], [OrderBy]) 
	VALUES ( 2, 4, '~/Assets/ProductImages/plasma_tv_black.jpg', NULL, 2 );

INSERT INTO [ac_ProductImages] ([ProductImageId], [ProductId], [ImageUrl], [ImageAltText], [OrderBy]) 
	VALUES ( 3, 4, '~/Assets/ProductImages/plasma_tv_displayed2.jpg', NULL, 3 );

INSERT INTO [ac_ProductImages] ([ProductImageId], [ProductId], [ImageUrl], [ImageAltText], [OrderBy]) 
	VALUES ( 5, 4, '~/Assets/ProductImages/plasma_tv_closeup.jpg', NULL, 5 );

SET IDENTITY_INSERT [ac_ProductImages] OFF;

-- </[ac_ProductImages]>

GO

-- <[ac_ProductTemplateFields]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_ProductTemplateFields] ON;

INSERT INTO [ac_ProductTemplateFields] ([ProductTemplateFieldId], [ProductId], [InputFieldId], [InputValue]) 
	VALUES ( 17, 4, 13, 'Sanasonic SN-42PX60U' );

INSERT INTO [ac_ProductTemplateFields] ([ProductTemplateFieldId], [ProductId], [InputFieldId], [InputValue]) 
	VALUES ( 18, 4, 14, '42" Plasma Television, Widescreen 16:9 Format' );

INSERT INTO [ac_ProductTemplateFields] ([ProductTemplateFieldId], [ProductId], [InputFieldId], [InputValue]) 
	VALUES ( 19, 4, 15, '1024x768 (HDTV)' );

INSERT INTO [ac_ProductTemplateFields] ([ProductTemplateFieldId], [ProductId], [InputFieldId], [InputValue]) 
	VALUES ( 20, 4, 16, 'Integrated pedestal stand and 20W integrated speaker system,NTSC and ATSC (HDTV) tuners,2 HDMI inputs,2 component video,3 composite video,3 S-Video connection' );

SET IDENTITY_INSERT [ac_ProductTemplateFields] OFF;

-- </[ac_ProductTemplateFields]>

GO

-- <[ac_UpsellProducts]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

INSERT INTO [ac_UpsellProducts] ([ProductId], [ChildProductId], [OrderBy]) 
	VALUES ( 4, 42, 1 );

INSERT INTO [ac_UpsellProducts] ([ProductId], [ChildProductId], [OrderBy]) 
	VALUES ( 5, 32, 1 );

INSERT INTO [ac_UpsellProducts] ([ProductId], [ChildProductId], [OrderBy]) 
	VALUES ( 33, 34, 1 );

INSERT INTO [ac_UpsellProducts] ([ProductId], [ChildProductId], [OrderBy]) 
	VALUES ( 33, 35, 2 );

INSERT INTO [ac_UpsellProducts] ([ProductId], [ChildProductId], [OrderBy]) 
	VALUES ( 33, 36, 3 );


-- </[ac_UpsellProducts]>

GO

-- <[ac_RelatedProducts]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

INSERT INTO [ac_RelatedProducts] ([ProductId], [OrderBy], [ChildProductId]) 
	VALUES ( 33, 2, 5 );

INSERT INTO [ac_RelatedProducts] ([ProductId], [OrderBy], [ChildProductId]) 
	VALUES ( 34, 1, 33 );

INSERT INTO [ac_RelatedProducts] ([ProductId], [OrderBy], [ChildProductId]) 
	VALUES ( 35, 1, 33 );


-- </[ac_RelatedProducts]>

GO

-- <[ac_VolumeDiscounts]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_VolumeDiscounts] ON;

INSERT INTO [ac_VolumeDiscounts] ([VolumeDiscountId], [StoreId], [Name], [IsValueBased], [IsGlobal]) 
	VALUES ( 1, 1, 'Quantity Discounts for Cable (per-foot)', 0, 0 );

SET IDENTITY_INSERT [ac_VolumeDiscounts] OFF;

-- </[ac_VolumeDiscounts]>

GO

-- <[ac_VolumeDiscountLevels]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_VolumeDiscountLevels] ON;

INSERT INTO [ac_VolumeDiscountLevels] ([VolumeDiscountLevelId], [VolumeDiscountId], [MinValue], [MaxValue], [DiscountAmount], [IsPercent]) 
	VALUES ( 2, 1, 751.0000, 1000.0000, 20.0000, 1 );

INSERT INTO [ac_VolumeDiscountLevels] ([VolumeDiscountLevelId], [VolumeDiscountId], [MinValue], [MaxValue], [DiscountAmount], [IsPercent]) 
	VALUES ( 3, 1, 501.0000, 750.0000, 15.0000, 1 );

INSERT INTO [ac_VolumeDiscountLevels] ([VolumeDiscountLevelId], [VolumeDiscountId], [MinValue], [MaxValue], [DiscountAmount], [IsPercent]) 
	VALUES ( 4, 1, 251.0000, 500.0000, 10.0000, 1 );

INSERT INTO [ac_VolumeDiscountLevels] ([VolumeDiscountLevelId], [VolumeDiscountId], [MinValue], [MaxValue], [DiscountAmount], [IsPercent]) 
	VALUES ( 5, 1, 100.0000, 250.0000, 5.0000, 1 );

SET IDENTITY_INSERT [ac_VolumeDiscountLevels] OFF;

-- </[ac_VolumeDiscountLevels]>

GO

-- <[ac_ProductVolumeDiscounts]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

INSERT INTO [ac_ProductVolumeDiscounts] ([ProductId], [VolumeDiscountId]) 
	VALUES ( 40, 1 );


-- </[ac_ProductVolumeDiscounts]>

GO

-- <[ac_LicenseAgreements]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_LicenseAgreements] ON;

INSERT INTO [ac_LicenseAgreements] ([LicenseAgreementId], [StoreId], [DisplayName], [AgreementText], [IsHTML]) 
	VALUES ( 1, 1, 'License agreement', '<p>&nbsp;</p><p><span style="font-weight: bold"><p>Sample License agreement</p></span></p><p>&nbsp;</p><ul><li>As the merchant, you&nbsp;may&nbsp;choose whether&nbsp;it is agreed to before downloading, or&nbsp;when the customer&nbsp;adds product to the shopping cart.</li><li>The license agreement may be associated to one or more downloadable files.</li></ul>', 0 );

SET IDENTITY_INSERT [ac_LicenseAgreements] OFF;

-- </[ac_LicenseAgreements]>

GO

-- <[ac_Readmes]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_Readmes] ON;

INSERT INTO [ac_Readmes] ([ReadmeId], [StoreId], [DisplayName], [ReadmeText], [IsHTML]) 
	VALUES ( 1, 1, 'Readme', '<p>&nbsp;</p><p align="left"><span style="font-weight: bold">Sample Readme</span></p><p align="left">&nbsp;</p><ul><li><div align="left">This is the sample content for a Digital Good Readme file.</div></li><li><div align="left">It can be associated to one or more downloadable files.</div></li></ul>', 0 );

SET IDENTITY_INSERT [ac_Readmes] OFF;

-- </[ac_Readmes]>

GO

-- <[ac_DigitalGoods]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_DigitalGoods] ON;

INSERT INTO [ac_DigitalGoods] ([DigitalGoodId], [StoreId], [Name], [FileName], [FileSize], [MaxDownloads], [DownloadTimeout], [ActivationTimeout], [MediaKey], [ServerFileName], [SerialKeyProviderId], [SerialKeyConfigData], [ActivationModeId], [ActivationEmailId], [FulfillmentModeId], [FulfillmentEmailId], [ReadmeId], [LicenseAgreementId], [LicenseAgreementModeId], [EnableSerialKeys]) 
	VALUES ( 1, 1, 'free sample download', 'sample.txt', 60, 10, NULL, NULL, NULL, 'sample.txt', NULL, NULL, 1, NULL, 2, NULL, 1, 1, 2, 0 );

INSERT INTO [ac_DigitalGoods] ([DigitalGoodId], [StoreId], [Name], [FileName], [FileSize], [MaxDownloads], [DownloadTimeout], [ActivationTimeout], [MediaKey], [ServerFileName], [SerialKeyProviderId], [SerialKeyConfigData], [ActivationModeId], [ActivationEmailId], [FulfillmentModeId], [FulfillmentEmailId], [ReadmeId], [LicenseAgreementId], [LicenseAgreementModeId], [EnableSerialKeys]) 
	VALUES ( 2, 1, 'sample digital good - Windows', 'sample.txt', 60, 10, NULL, NULL, NULL, 'sample.txt', NULL, NULL, 2, NULL, 2, NULL, 1, 1, 1, 0 );

INSERT INTO [ac_DigitalGoods] ([DigitalGoodId], [StoreId], [Name], [FileName], [FileSize], [MaxDownloads], [DownloadTimeout], [ActivationTimeout], [MediaKey], [ServerFileName], [SerialKeyProviderId], [SerialKeyConfigData], [ActivationModeId], [ActivationEmailId], [FulfillmentModeId], [FulfillmentEmailId], [ReadmeId], [LicenseAgreementId], [LicenseAgreementModeId], [EnableSerialKeys]) 
	VALUES ( 3, 1, 'sample digital good - Linux', 'sample.txt', 60, 10, NULL, NULL, NULL, 'sample.txt', NULL, NULL, 2, NULL, 2, NULL, 1, 1, 1, 0 );

SET IDENTITY_INSERT [ac_DigitalGoods] OFF;

-- </[ac_DigitalGoods]>

GO

-- <[ac_ProductDigitalGoods]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_ProductDigitalGoods] ON;

INSERT INTO [ac_ProductDigitalGoods] ([ProductDigitalGoodId], [ProductId], [OptionList], [DigitalGoodId]) 
	VALUES ( 1, 37, NULL, 1 );

INSERT INTO [ac_ProductDigitalGoods] ([ProductDigitalGoodId], [ProductId], [OptionList], [DigitalGoodId]) 
	VALUES ( 2, 38, '66,0,0,0,0,0,0,0', 2 );

INSERT INTO [ac_ProductDigitalGoods] ([ProductDigitalGoodId], [ProductId], [OptionList], [DigitalGoodId]) 
	VALUES ( 3, 38, '67,0,0,0,0,0,0,0', 3 );

SET IDENTITY_INSERT [ac_ProductDigitalGoods] OFF;

-- </[ac_ProductDigitalGoods]>

GO

-- <[ac_Coupons]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_Coupons] ON;

INSERT INTO [ac_Coupons] ([CouponId], [StoreId], [CouponTypeId], [Name], [CouponCode], [DiscountAmount], [IsPercent], [MaxValue], [MinPurchase], [MinQuantity], [MaxQuantity], [QuantityInterval], [MaxUses], [MaxUsesPerCustomer], [StartDate], [EndDate], [ProductRuleId], [AllowCombine]) 
	VALUES ( 1, 1, 2, 'Free shipping on computer system', '4Z2YAB', 100.0000, 1, 0.0000, 0.0000, 0, 0, 0, 0, 1, NULL, NULL, 0, 0 );

INSERT INTO [ac_Coupons] ([CouponId], [StoreId], [CouponTypeId], [Name], [CouponCode], [DiscountAmount], [IsPercent], [MaxValue], [MinPurchase], [MinQuantity], [MaxQuantity], [QuantityInterval], [MaxUses], [MaxUsesPerCustomer], [StartDate], [EndDate], [ProductRuleId], [AllowCombine]) 
	VALUES ( 2, 1, 1, 'Buy 1 Get 1 Free', 'GET1FREE', 50.0000, 1, 0.0000, 0.0000, 2, 0, 2, 0, 1, NULL, NULL, 1, 0 );

SET IDENTITY_INSERT [ac_Coupons] OFF;

-- </[ac_Coupons]>

GO

-- <[ac_CouponProducts]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

INSERT INTO [ac_CouponProducts] ([CouponId], [ProductId]) 
	VALUES ( 2, 41 );


-- </[ac_CouponProducts]>

GO

-- <[ac_ShipMethods]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_ShipMethods] ON;

INSERT INTO [ac_ShipMethods] ([ShipMethodId], [StoreId], [ShipMethodTypeId], [Name], [Surcharge], [ShipGatewayId], [ServiceCode], [MinPurchase], [MaxPurchase], [SurchargeIsVisible], [SurchargeModeId], [TaxCodeId], [OrderBy]) 
	VALUES ( 1, 1, 2, 'Shipping 20% of Order Total', 0.0000, NULL, NULL, 0.0000, 0.0000, 0, 0, NULL, 1 );

SET IDENTITY_INSERT [ac_ShipMethods] OFF;

-- </[ac_ShipMethods]>

GO

-- <[ac_ShipRateMatrix]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

SET IDENTITY_INSERT [ac_ShipRateMatrix] ON;

INSERT INTO [ac_ShipRateMatrix] ([ShipRateMatrixId], [ShipMethodId], [RangeStart], [RangeEnd], [Rate], [IsPercent]) 
	VALUES ( 1, 1, NULL, NULL, 20.0000, 1 );

SET IDENTITY_INSERT [ac_ShipRateMatrix] OFF;

-- </[ac_ShipRateMatrix]>

GO

-- <[ac_SubscriptionPlans]>

SET NOCOUNT ON;
SET DATEFORMAT ymd;

INSERT INTO [ac_SubscriptionPlans] ([ProductId], [Name], [NumberOfPayments], [PaymentFrequency], [PaymentFrequencyUnitId], [RecurringCharge], [RecurringChargeModeId], [RecurringChargeSpecified], [GroupId], [TaxCodeId], [IsOptional], [Description], [OneTimeCharge], [OneTimeChargeModeId], [OptionalPaymentFrequencies], [PaymentFrequencyTypeId], [RepeatDiscounts], [OneTimeChargeTaxCodeId])
VALUES ( 39, 'Ecommerce Magazine Subscription', 1, 12, 1, 0.00, 0, 0, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 0, NULL);

INSERT INTO [ac_SubscriptionPlans] ( [ProductId], [Name], [NumberOfPayments], [PaymentFrequency], [PaymentFrequencyUnitId], [RecurringCharge], [RecurringChargeModeId], [RecurringChargeSpecified], [IsOptional], [OneTimeChargeModeId], [RepeatDiscounts], [OneTimeChargeTaxCodeId], [OptionalPaymentFrequencies], [PaymentFrequencyTypeId], [Description], [OneTimeCharge], [GroupId], [TaxCodeId] ) 
VALUES ( 43, 'Recurring Shipments Subscription', 0, 0, 0, 0.00, 0, 0, 1, 1, 0, 1, '7,14,21,30', 1, 'Subscribe and Save', 5.00, NULL, NULL ) ;

-- </[ac_SubscriptionPlans]>

-- <[ac_StoreSettings]>

UPDATE [ac_StoreSettings] SET FieldValue = '120' WHERE FieldName = 'OptionThumbnailWidth';

UPDATE [ac_StoreSettings] SET FieldValue = '80' WHERE FieldName = 'OptionThumbnailHeight';

UPDATE [ac_StoreSettings] SET FieldValue = '2' WHERE FieldName = 'OptionThumbnailColumns';

-- </[ac_StoreSettings]>