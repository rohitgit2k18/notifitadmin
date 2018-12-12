//-----------------------------------------------------------------------
// <copyright file="GoogleFeed.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Code
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Web.Hosting;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Configuration;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Products;
    using CommerceBuilder.Services;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using NHibernate;
    using NHibernate.Criterion;

    /// <summary>
    /// Summary description for GoogleFeed
    /// </summary>
    public class GoogleFeed
    {
        /// <summary>
        /// Regular expression to determine the pattern that meets the definition of a UPC code
        /// </summary>
        /// <remarks>
        /// To set UPC use the GTIN field of product.  For legacy purposes
        /// if GTIN is not specified the SKU field is examined to see if it meets
        /// the definition of a UPC.  If so this is included in the GTIN feed field.
        /// </remarks>
        private static Regex reUPC = new Regex("^\\d{12}$");

        /// <summary>
        /// Creates the google feed
        /// </summary>
        /// <param name="feedFile">The feed file to generate</param>
        /// <param name="includeAllProducts">If true, product feed exclusion settings are ignored.</param>
        /// <param name="defaultBrand">Default brand to use if one is not set for a prodcut</param>
        /// <param name="defaultCategory">Default category to use if one is not set for a prodcut</param>
        /// <returns>True if the generation succeeds, false otherwise.</returns>
        private static bool CreateFeed(string feedFile, bool includeAllProducts, string defaultBrand, string defaultCategory)
        {
            // ensure the feed directory exists
            FileInfo fi = new FileInfo(feedFile);
            if (!fi.Directory.Exists)
            {
                try
                {
                    fi.Directory.Create();
                }
                catch (Exception ex)
                {
                    Logger.Error("Error generating Google feed: ~\\Feeds directory does not exist and could not be created.", ex);
                    return false;
                }
            }

            // write the header row to the feed file
            try
            {
                using (StreamWriter feedWriter = File.CreateText(feedFile))
                {
                    feedWriter.Write(GetHeaderRow());
                    feedWriter.Close();
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Error generating Google feed.", ex);
                return false;
            }

            try
            {
                ISession session = AbleContext.Current.Database.GetSession();
                using (StreamWriter feedWriter = File.AppendText(feedFile))
                {
                    IList<Product> products;
                    ICriteria countCriteria = NHibernateHelper.CreateCriteria<Product>()
                        .Add(Restrictions.Not(Restrictions.Eq("VisibilityId", (byte)CatalogVisibility.Private)));
                    if (!includeAllProducts)
                        countCriteria.Add(Restrictions.Eq("ExcludeFromFeed", false));
                    int count = countCriteria.SetProjection(Projections.RowCount())
                        .UniqueResult<int>();

                    int startIndex = 0;
                    while (startIndex < count)
                    {
                        // DETERMINE HOW MANY ROWS LEFT TO INCLUDE IN FEED
                        int rowsRemaining = count - startIndex;

                        // ONLY PROCESS 1000 ROWS AT A TIME
                        int maxRows = (rowsRemaining > 1000) ? 1000 : rowsRemaining;

                        // GET THE ROWS TO BE OUTPUT
                        ICriteria productCriteria = NHibernateHelper.CreateCriteria<Product>(maxRows, startIndex, string.Empty)
                            .Add(Restrictions.Not(Restrictions.Eq("VisibilityId", (byte)CatalogVisibility.Private)));
                        if (!includeAllProducts)
                            productCriteria.Add(Restrictions.Eq("ExcludeFromFeed", false));
                        products = productCriteria.List<Product>();

                        // GENERATE THE FEED DATA
                        string feedData = GetFeedData(products, defaultBrand, defaultCategory);

                        // WRITE DATA TO THE FEED FILE
                        feedWriter.Write(feedData);
                        feedWriter.Flush();

                        // REMOVE PRODUCTS FROM SESSION TO CONSERVE MEMORY
                        foreach (var product in products)
                        {
                            session.Evict(product);
                        }

                        // LOOP TO THE NEXT BLOCK OF DATA
                        startIndex += 1000;
                    }

                    // CLOSE THE FEED FILE
                    feedWriter.Close();
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Error generating Google feed.", ex);
                return false;
            }

            return true;
        }
        
        /// <summary>
        /// Task to run periodically to determine if feed must be regenerated
        /// </summary>
        /// <param name="stateInfo">the stateinfo passed from the timer</param>
        public static void FeedTimerTask(object stateInfo)
        {
            CreateFeed(false);
        }

        /// <summary>
        /// Creates the google feed
        /// </summary>
        public static void CreateFeed(bool manualFeedGeneration)
        {            
            try
            {
                // ENSURE APP IS INSTALLED
                Store store = GetInstalledStore();
                if (store != null)
                {
                    // SEE IF FEED GENERATION IS ENABLED
                    ApplicationSettings appConfig = ApplicationSettings.Instance;
                    if (appConfig.GoogleFeedInterval > 0 || manualFeedGeneration)
                    {
                        // SEE IF THE FEED IS OLD ENOUGH TO BE REGENERATED
                        int interval = (int)(60000 * appConfig.GoogleFeedInterval);
                        string googleBaseFile = HostingEnvironment.MapPath("~/Feeds/GoogleFeedData.txt");
                        FileInfo fileInfo = new FileInfo(googleBaseFile);
                        if (!fileInfo.Exists || fileInfo.LastWriteTime.AddMilliseconds(interval) < DateTime.Now)
                        {
                            CreateFeed(googleBaseFile, store.Settings.GoogleFeedIncludeAllProducts, store.Settings.GoogleFeedDefaultBrand, store.Settings.GoogleFeedDefaultCategory);
                        }
                    }
                }
            }
            catch
            {
            }
            finally
            {
                AbleContext.ReleaseInstance();
            }
        }

        /// <summary>
        /// Ensures the database has a valid store
        /// </summary>
        /// <returns>The store</returns>
        private static Store GetInstalledStore()
        {
            if (!CanGetSession()) return null;
            try
            {
                IStoreLocator locator = AbleContext.Resolve<IStoreLocator>();
                return locator.LocateCurrent();                
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// Ensures the database session is valid (app is installed)
        /// </summary>
        /// <returns>True if the database session can be retrieved without error, false otherwise.</returns>
        private static bool CanGetSession()
        {
            try
            {
                ISession session = AbleContext.Current.Database.GetSession();
            }
            catch
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// Gets the header row for the product feed
        /// </summary>
        /// <returns>The header row for the prodcut feed</returns>
        /// <remarks>The order of items in header row must match the order of items in the data output</remarks>
        private static string GetHeaderRow()
        {
            // from http://support.google.com/merchants/bin/answer.py?hl=en&answer=188494#US
            // basic product information
            StringBuilder feedLine = new StringBuilder();
            feedLine.Append("id\t");
            feedLine.Append("title\t");
            feedLine.Append("description\t");
            feedLine.Append("google_product_category\t");
            feedLine.Append("product_type\t");
            feedLine.Append("link\t");
            feedLine.Append("image_link\t");
            feedLine.Append("condition\t");

            // availability and price
            feedLine.Append("availability\t");
            feedLine.Append("price\t");

            // unique product identifiers
            feedLine.Append("brand\t");
            feedLine.Append("gtin\t");
            feedLine.Append("mpn\t");

            // apparel products
            feedLine.Append("gender\t");
            feedLine.Append("age_group\t");
            feedLine.Append("item_group_id\t"); // if its a variant 
            feedLine.Append("color\t");
            feedLine.Append("size\t");
            feedLine.Append("material\t");
            feedLine.Append("pattern\t");

            // adwords
            feedLine.Append("adwords_grouping\t");
            feedLine.Append("adwords_labels\t");
            feedLine.Append("excluded_destination\t");
            feedLine.Append("adwords_redirect\t");

            // tax and shipping
            feedLine.AppendLine("shipping_weight");
            return feedLine.ToString();
        }

        /// <summary>
        /// Gets feed data for a batch of products
        /// </summary>
        /// <param name="products">the batch of products</param>
        /// <param name="defaultBrand">Default brand to use if none is set for a product</param>
        /// <param name="defaultCategory">Default category to use if none is set for a product</param>
        /// <returns>Feed data for the batch of products</returns>
        private static string GetFeedData(IList<Product> products, string defaultBrand, string defaultCategory)
        {
            Store store = AbleContext.Current.Store;
            string storeUrl = store.StoreUrl;
            if (!storeUrl.EndsWith("/")) storeUrl += "/";
            string googleWeightUnit = GetGoogleWeightUnit(store.WeightUnit);

            using (StringWriter feedWriter = new StringWriter())
            {
                foreach (Product product in products)
                {
                    IList<Variant> variants = new List<Variant>();

                    // prepare variables that need logic applied
                    string desc = StringHelper.CleanupSpecialChars(product.Summary);
                    string condition = string.IsNullOrEmpty(product.Condition) ? "new" : product.Condition;
                    string brand = product.Manufacturer != null ? product.Manufacturer.Name : defaultBrand;
                    string modelNumber = string.IsNullOrEmpty(product.ModelNumber) ? product.Sku : product.ModelNumber; 
                    string productType = GetProductType(product);
                    string googleCategory = string.IsNullOrEmpty(product.GoogleCategory) ? defaultCategory : product.GoogleCategory;
                    
                    // check if we need to export product variants, for this we first need to check product google category.
                    // Variant-level information is required only for products in the “'Apparel & Accessories' category, 
                    // and all related subcategories. Apparel variants are only required for feeds targeting the US, UK, DE, FR, and JP. 
                    // For feeds targeting other countries, the attributes are recommended and may be required in the future.
                    bool isApparelProduct = googleCategory.Trim().StartsWith("apparel & accessories", StringComparison.InvariantCultureIgnoreCase);
                    if (isApparelProduct && product.PublishFeedAsVariants) variants = GetAvailableVariants(product);

                    // if there are variants to export
                    if (variants.Count > 0)
                    {
                        foreach (Variant variant in variants)
                        {
                            // generate the feed line
                            // basic product information (id, title, description, google_product_category, product_type, link, image_link, condition)
                            string availability = GetAvailability(product, variant);
                            string variantModelNumber = string.IsNullOrEmpty(variant.ModelNumber) ? variant.Sku : variant.ModelNumber;
                            StringBuilder feedLine = new StringBuilder();
                            feedLine.Append(variant.Id + "\t");
                            feedLine.Append(StringHelper.CleanupSpecialChars(variant.Name) + "\t");
                            feedLine.Append(desc + "\t");
                            feedLine.Append(googleCategory + "\t");
                            feedLine.Append(productType + "\t");
                            feedLine.Append(variant.Link + "\t");
                            feedLine.Append(variant.ImageUrl + "\t");
                            feedLine.Append(condition + "\t");

                            // availability and price (availability, price)
                            feedLine.Append(availability + "\t");
                            feedLine.Append(string.Format("{0:F2}", variant.Price) + "\t");

                            // unique product identifiers (brand, gtin, mpn)
                            feedLine.Append(brand + "\t");
                            feedLine.Append(variant.GTIN + "\t");
                            feedLine.Append(variantModelNumber + "\t");

                            // apparel products (gender, age_group)
                            feedLine.Append(product.Gender + "\t");
                            feedLine.Append(product.AgeGroup + "\t");

                            // variants (item_group_id, color, size, material, pattern)
                            feedLine.Append(variant.ItemGroupId + "\t");
                            feedLine.Append(variant.Color + "\t");
                            feedLine.Append(variant.Size + "\t");
                            feedLine.Append(variant.Material + "\t");
                            feedLine.Append(variant.Pattern + "\t");

                            // Adwords
                            feedLine.Append(product.AdwordsGrouping + "\t");
                            feedLine.Append(product.AdwordsLabels + "\t");
                            feedLine.Append(product.ExcludedDestination.ToString() + "\t");
                            feedLine.Append(product.AdwordsRedirect + "\t");

                            // tax and shipping (shipping_weight)
                            feedLine.Append(string.Format("{0:F2} {1}", variant.Weight, googleWeightUnit));
                            feedWriter.WriteLine(feedLine.ToString());
                        }
                    }
                    else
                    {
                        // prepare variables that need logic applied
                        string availability = GetAvailability(product);
                        string name = StringHelper.CleanupSpecialChars(product.Name);
                        string url = ResolveUrl(product.NavigateUrl, storeUrl);
                        string imgurl = product.ImageUrl;
                        if (!string.IsNullOrEmpty(imgurl) && !IsAbsoluteURL(imgurl))
                        {
                            imgurl = ResolveUrl(imgurl, storeUrl);
                        }                        
                        string gtin = product.GTIN;
                        if (string.IsNullOrEmpty(gtin))
                        {
                            // for compatibility with AC7 data check if SKU is a UPC
                            gtin = IsUpcCode(product.Sku) ? product.Sku : string.Empty;
                        }

                        // generate the feed line
                        // basic product information (id, title, description, google_product_category, product_type, link, image_link, condition)
                        StringBuilder feedLine = new StringBuilder();
                        feedLine.Append(product.Id + "\t");
                        feedLine.Append(name + "\t");
                        feedLine.Append(desc + "\t");
                        feedLine.Append(googleCategory + "\t");
                        feedLine.Append(productType + "\t");
                        feedLine.Append(url + "\t");
                        feedLine.Append(imgurl + "\t");
                        feedLine.Append(condition + "\t");

                        // availability and price (availability, price)
                        decimal price = product.Price;
                        ProductCalculator pcalculator = ProductCalculator.LoadForProduct(product.Id, 1, string.Empty, string.Empty, 0, false);
                        if(pcalculator != null) price = pcalculator.Price;
                        feedLine.Append(availability + "\t");
                        feedLine.Append(string.Format("{0:F2}", price) + "\t");

                        // unique product identifiers (brand, gtin, mpn)
                        feedLine.Append(brand + "\t");
                        feedLine.Append(gtin + "\t");
                        feedLine.Append(modelNumber + "\t");

                        // apparel products (gender, age_group)
                        feedLine.Append(product.Gender + "\t");
                        feedLine.Append(product.AgeGroup + "\t");

                        // variants (item_group_id, color, size, material, pattern)
                        feedLine.Append(string.Empty + "\t");
                        feedLine.Append(product.Color + "\t");
                        feedLine.Append(product.Size + "\t");
                        feedLine.Append(string.Empty + "\t");
                        feedLine.Append(string.Empty + "\t");

                        // Adwords
                        feedLine.Append(product.AdwordsGrouping + "\t");
                        feedLine.Append(product.AdwordsLabels + "\t");
                        feedLine.Append(product.ExcludedDestination.ToString() + "\t");
                        feedLine.Append(product.AdwordsRedirect + "\t");

                        // tax and shipping (shipping_weight)
                        feedLine.Append(string.Format("{0:F2} {1}", product.Weight, googleWeightUnit));
                        feedWriter.WriteLine(feedLine.ToString());
                    }
                }

                string returnData = feedWriter.ToString();
                feedWriter.Close();
                return returnData;
            }
        }

        /// <summary>
        /// Converts the given weight unit into the google equivalent
        /// </summary>
        /// <param name="storeUnit">the store weight unit</param>
        /// <returns>The google specific weight unit for the store</returns>
        /// <remarks>Google supports the same weight units as AC but uses 
        /// a different identifier.</remarks>
        private static string GetGoogleWeightUnit(WeightUnit storeUnit)
        {
            switch(storeUnit)
            {
                case WeightUnit.Grams: return "g";
                case WeightUnit.Kilograms: return "kg";
                case WeightUnit.Ounces: return "oz";
                default: return "lb";
            }
        }

        /// <summary>
        /// Gets the merchant category for a product
        /// </summary>
        /// <param name="product">The product</param>
        /// <returns>The merchant category for the product</returns>
        private static string GetProductType(Product product)
        {
            if (product.Categories.Count > 0)
            {
                IList<CatalogPathNode> pathNodes = CatalogDataSource.GetPath(product.Categories[0], false);
                List<string> categoryNames = new List<string>();
                foreach (CatalogPathNode node in pathNodes)
                {
                    categoryNames.Add(node.Name);
                }
                return string.Join(" > ", categoryNames.ToArray());
            }
            return string.Empty;
        }

        /// <summary>
        /// Gets the availability for a product
        /// </summary>
        /// <param name="product">The product</param>
        /// <returns>Availability for the product</returns>
        private static string GetAvailability(Product product)
        {
            return GetAvailability(product, null);
        }

        /// <summary>
        /// Gets the availability for a product
        /// </summary>
        /// <param name="product">The product</param>
        /// <param name="variant">The variant</param>
        /// <returns>Availability for the product or variant</returns>
        private static string GetAvailability(Product product, Variant variant)
        {
            string availability = "in stock";
            switch (product.InventoryMode)
            {
                case InventoryMode.None:
                    availability = "in stock";
                    break;

                case InventoryMode.Product:
                    if (product.InStock > 0)
                    {
                        availability = "in stock";
                    }
                    else
                        if (product.AllowBackorder)
                        {
                            availability = "preorder";
                        }
                        else
                        {
                            availability = "out of stock";
                        }
                    break;

                case InventoryMode.Variant:
                    availability = "in stock";
                    if (variant != null)
                    {
                        if (variant.InStock > 0)
                        {
                            availability = "in stock";
                        }
                        else
                            if (product.AllowBackorder)
                            {
                                availability = "preorder";
                            }
                            else
                            {
                                availability = "out of stock";
                            }
                    }
                    break;

                default:
                    availability = "in stock";
                    break;
            }

            return availability;
        }

        /// <summary>
        /// Determines if a test value is recognized as a UPC
        /// </summary>
        /// <param name="value">the test value</param>
        /// <returns>True if the test value is recognized as a UPC code, false otherwise.</returns>
        private static bool IsUpcCode(string value)
        {
            return reUPC.IsMatch(value);
        }

        /// <summary>
        /// Determines if a URL is absolute
        /// </summary>
        /// <param name="url">the URL</param>
        /// <returns>True if the URL is absolute, false otherwise.</returns>
        private static bool IsAbsoluteURL(string url)
        {
            if (url == null)
            {
                return false;
            }

            int colonPos = url.IndexOf(":");
            if (colonPos != -1)
            {
                string sub = url.Substring(colonPos + 1);
                if (sub.StartsWith("//"))
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// resolves a URL local to the store
        /// </summary>
        /// <param name="targetUrl">The target URL</param>
        /// <param name="storeUrl">The base store URL</param>
        /// <returns>The absolute URL for the store context</returns>
        private static string ResolveUrl(string targetUrl, string storeUrl)
        {
            if (targetUrl.StartsWith("~/"))
            {
                return storeUrl + targetUrl.Substring(2);
            }
            else
            {
                return storeUrl + targetUrl;
            }
        }

        private static IList<Variant> GetAvailableVariants(Product product)
        {
            IList<Variant> variants = new List<Variant>();
            List<Option> relatedOptions = new List<Option>();
            int lastIndex = -1, colorOptionIndex = -1, sizeOptionIndex = -1, materialOptionIndex = -1, patternOptionIndex = -1;
            Option colorOption = null, sizeOption = null, materialOption = null, patternOption = null;
            string optionListPattern = string.Empty;
            if (product.ProductOptions.Count > 0)
            {
                // check variants and options
                IList<ProductOption> options = product.ProductOptions;
                foreach (ProductOption pOption in options)
                {
                    if (!string.IsNullOrEmpty(optionListPattern)) optionListPattern += ",";
                    string optionName = pOption.Option.Name.ToLowerInvariant();

                    if (optionName == "color") { colorOption = pOption.Option; colorOptionIndex = ++lastIndex; relatedOptions.Add(colorOption); optionListPattern += "{C}"; }
                    else if (optionName == "size") { sizeOption = pOption.Option; sizeOptionIndex = ++lastIndex; relatedOptions.Add(sizeOption); optionListPattern += "{S}"; }
                    else if (optionName == "material") { materialOption = pOption.Option; materialOptionIndex = ++lastIndex; relatedOptions.Add(materialOption); optionListPattern += "{M}"; }
                    else if (optionName == "pattern") { patternOption = pOption.Option; patternOptionIndex = ++lastIndex; relatedOptions.Add(patternOption); optionListPattern += "{P}"; }
                    else optionListPattern += "0"; // fill the options list pattern with zero
                }
            }

            if (relatedOptions.Count > 0)
            {
                Store store = AbleContext.Current.Store;
                string storeUrl = store.StoreUrl;
                if (!storeUrl.EndsWith("/")) storeUrl += "/";

                // calculate all valid combinations using the option choices
                List<int[]> choiceCombinations = GetAllChoicesCombinations(relatedOptions);
                ProductVariantManager variantManager = new ProductVariantManager(product.Id);
                IList<string> imageUrlList = new List<string>(); // require to keep track of unique images for variants

                foreach (int[] choicesCombination in choiceCombinations)
                {
                    // collect the choice id values
                    int colorChoiceId = 0, sizeChoiceId = 0, materialChoiceId = 0, patternChoiceId = 0;
                    if (colorOptionIndex >= 0) colorChoiceId = choicesCombination[colorOptionIndex];
                    if (sizeOptionIndex >= 0) sizeChoiceId = choicesCombination[sizeOptionIndex];
                    if (materialOptionIndex >= 0) materialChoiceId = choicesCombination[materialOptionIndex];
                    if (patternOptionIndex >= 0) patternChoiceId = choicesCombination[patternOptionIndex];

                    // build option list, fill the color, size, material, and pattern choice id values while for rest of options fill in zero value
                    string optionList = optionListPattern;
                    optionList = optionList.Replace("{C}", colorChoiceId.ToString());
                    optionList = optionList.Replace("{S}", sizeChoiceId.ToString());
                    optionList = optionList.Replace("{M}", materialChoiceId.ToString());
                    optionList = optionList.Replace("{P}", patternChoiceId.ToString());

                    ProductVariant productVariant = variantManager.GetVariantFromOptions(optionList);
                    if (productVariant != null)
                    {   
                        // check availability 
                        if (!productVariant.Available) continue;

                        Variant variant = new Variant();
                        variant.Product = product;

                        string variantNamePart = string.Empty;
                        string variantoptionsList = string.Empty;

                        if (colorChoiceId > 0) 
                        { 
                            variant.Color = EntityLoader.Load<OptionChoice>(colorChoiceId).Name; 
                            variantNamePart += string.IsNullOrEmpty(variantNamePart) ? variant.Color : "," + variant.Color; 
                            variantoptionsList += string.IsNullOrEmpty(variantoptionsList) ? colorChoiceId.ToString() : "," + colorChoiceId.ToString(); 
                        }
                        if (sizeChoiceId > 0)
                        {
                            variant.Size = EntityLoader.Load<OptionChoice>(sizeChoiceId).Name;
                            variantNamePart += string.IsNullOrEmpty(variantNamePart) ? variant.Size : "," + variant.Size;
                            variantoptionsList += string.IsNullOrEmpty(variantoptionsList) ? sizeChoiceId.ToString() : "," + sizeChoiceId.ToString(); 
                        }
                        if (materialChoiceId > 0)
                        {
                            variant.Material = EntityLoader.Load<OptionChoice>(materialChoiceId).Name;
                            variantNamePart += string.IsNullOrEmpty(variantNamePart) ? variant.Material : "," + variant.Material;
                            variantoptionsList += string.IsNullOrEmpty(variantoptionsList) ? materialChoiceId.ToString() : "," + materialChoiceId.ToString(); 
                        }
                        if (patternChoiceId > 0)
                        {
                            variant.Pattern = EntityLoader.Load<OptionChoice>(patternChoiceId).Name;
                            variantNamePart += string.IsNullOrEmpty(variantNamePart) ? variant.Pattern : "," + variant.Pattern;
                            variantoptionsList += string.IsNullOrEmpty(variantoptionsList) ? patternChoiceId.ToString() : "," + patternChoiceId.ToString(); 
                        }

                        variant.Name = string.Format("{0} - {1}", product.Name, variantNamePart);
                        variant.Link = ResolveUrl(product.NavigateUrl, storeUrl) + string.Format("?Options={0}", variantoptionsList);

                        // WE CAN ONLY USE ALPHANUMERIC CHARACTERS FOR ID, CREATE ID VALUE USING THE APAREL OPTIONS
                        // [Product_Id]C[COLOR_CHOICE_ID]S[SIZE_CHOICE_ID]M[MATERIAL_CHOICE_ID]P[PATTERN_CHOICE_ID]
                        variant.Id = string.Format("{0}C{1}S{2}M{3}P{4}", 
                            product.Id, 
                            (colorOptionIndex > -1 ? colorChoiceId.ToString() : string.Empty), 
                            (sizeOptionIndex > -1 ? sizeChoiceId.ToString() : string.Empty),
                            (materialOptionIndex > -1 ? materialChoiceId.ToString() : string.Empty),
                            (patternOptionIndex > -1 ? patternChoiceId.ToString() : string.Empty));

                        // VERIFY UNIQUE IMAGE LINK CONSIDERING FOLLOWING GOOGLE FEED REQUIREMENTS 
                        // For products that fall under “Apparel & Accessories” and all corresponding sub-categories in feeds targeting the US, UK, DE, FR, and JP: 
                        // If you are submitting product variants that differ in ‘‘color’, or ‘pattern’, or ‘material’, 
                        // we require you to submit specific images corresponding to each of these variants. 
                        // If you do not have the correct image for the variation of the product, you may not submit that variant. 
                        // We recommend specific images for ‘size’ variants too. However, if these are not available you may submit the same image URL for items that differ in ‘size’. 
                        string imageUrl = string.Empty;
                        if(!string.IsNullOrEmpty(productVariant.ImageUrl)) imageUrl = productVariant.ImageUrl.ToLowerInvariant();
                        if (string.IsNullOrEmpty(imageUrl) && !string.IsNullOrEmpty(product.ImageUrl)) imageUrl = product.ImageUrl.ToLowerInvariant(); // use product image if no image
                        if (string.IsNullOrEmpty(imageUrl)) continue; // skip if no image 
                        if (!IsAbsoluteURL(imageUrl))
                        {
                            imageUrl = ResolveUrl(imageUrl, storeUrl);
                        }

                        // verify unique image for each combination of ‘color’, ‘pattern’, and ‘material’
                        if (imageUrlList.Contains(imageUrl))
                        {
                            bool isUniqueImage = true;
                            // MAKE SURE OTHER VARIANTS ONLY DIFFER BY SIZE, OTHERWISE SKIP THIS
                            foreach (Variant otherVariant in variants)
                            {
                                if (imageUrl == otherVariant.ImageUrl)
                                {
                                    if (!(variant.Color == otherVariant.Color &&
                                        variant.Pattern == otherVariant.Pattern &&
                                        variant.Material == otherVariant.Material &&
                                        variant.Size != otherVariant.Size))
                                    {
                                        isUniqueImage = false;
                                        break;
                                    }
                                }
                            }
                            // SKIP THIS VARIANT, AS WE DO NOT HAVE A UNIQUE IMAGE FOR THIS VARIANT AS THIS IMAGE ALREADY USED FOR ANOTHER VARIANT, WHICH DIFFERS FOR MORE THEN SIZE
                            if(!isUniqueImage) continue;
                        }
                        
                        // else add to variant image dictionary to keep track of rest of variants
                        imageUrlList.Add(imageUrl);
                        variant.ImageUrl = imageUrl;
                        
                        // use product id as item group id, this must be same for all variants of same product, but must be unique for variants of each product
                        variant.ItemGroupId = product.Id.ToString();

                        ProductCalculator productCalculator = ProductCalculator.LoadForProduct(product.Id, 1, productVariant.OptionList, string.Empty, 0);
                        variant.Weight = productCalculator.Weight;
                        variant.Price = productCalculator.Price;
                        variant.Sku = productCalculator.Sku;

                        string gtin = productVariant.GTIN;
                        if (string.IsNullOrEmpty(gtin))
                        {
                            // for compatibility with AC7 data check if SKU is a UPC
                            gtin = IsUpcCode(productVariant.Sku) ? productVariant.Sku : string.Empty;
                        }
                        variant.GTIN = gtin;
                        variant.ModelNumber = productVariant.ModelNumber;
                        variant.InStock = productVariant.InStock;
                        variants.Add(variant);
                    }
                }
            }

            return variants;
        }

        private static List<int[]> GetAllChoicesCombinations(List<Option> options)
        {
            List<int[]> combinations = new List<int[]>();
            // create choice id arrays for each option
            int[][] choiceIdArrays = new int[options.Count][];
            for(int i = 0; i < options.Count; i++)
            {
                Option option = options[i];
                int[] arr = new int[option.Choices.Count];
                for (int j = 0; j < arr.Length; j++)
                {
                    arr[j] = option.Choices[j].Id;
                }
                choiceIdArrays[i] = arr;
            }

            int[] arr1 = choiceIdArrays[0];
            foreach (int id1 in arr1)
            {
                if (choiceIdArrays.Length > 1)
                {
                    int[] arr2 = choiceIdArrays[1];
                    foreach (int id2 in arr2)
                    {
                        if (choiceIdArrays.Length > 2)
                        {
                            int[] arr3 = choiceIdArrays[2];
                            foreach (int id3 in arr3)
                            {
                                if (choiceIdArrays.Length > 3)
                                {
                                    int[] arr4 = choiceIdArrays[3];
                                    foreach (int id4 in arr4)
                                    {
                                        combinations.Add(new int[]{id1, id2, id3, id4});
                                    }
                                }
                                else combinations.Add(new int[]{id1, id2, id3});
                            }
                        }
                        else combinations.Add(new int[]{id1, id2});
                    }
                }
                else combinations.Add(new int[]{id1});
            }

            return combinations;
        }

        private class Variant
        {
            public Variant()
            {
                this.ItemGroupId = string.Empty;
                this.Name = string.Empty;
                this.Sku = string.Empty;
                this.GTIN = string.Empty;
                this.Price = 0;
                this.Weight = 0;
                this.Link = string.Empty;
                this.Color = string.Empty;
                this.Size = string.Empty;
                this.Pattern = string.Empty;
                this.Material = string.Empty;
                this.ImageUrl = string.Empty;
                this.ModelNumber = string.Empty;
                this.InStock = 0;
            }

            public Product Product { get; set; }
            public string Id { get; set; }
            public string ItemGroupId { get; set; }
            public string Name { get; set; }
            public string Sku { get; set; }
            public string GTIN { get; set; }
            public decimal Price { get; set; }
            public decimal Weight { get; set; }
            public string Color { get; set; }
            public string Size { get; set; }
            public string Material { get; set; }
            public string Pattern { get; set; }
            public string Link { get; set; }
            public string ImageUrl { get; set; }
            public string ModelNumber { get; set; }
            public int InStock { get; set; }
        }
    }
}