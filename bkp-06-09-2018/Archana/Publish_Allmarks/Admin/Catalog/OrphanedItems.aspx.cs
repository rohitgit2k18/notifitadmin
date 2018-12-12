namespace AbleCommerce.Admin.Catalog
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using NHibernate;
    using NHibernate.Criterion;

    public partial class OrphanedItems : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        // ******** START ==== VARIABLES USED TO TRACK ORPHANED IMAGES
        List<ImageFileItem> imageFiles = new List<ImageFileItem>();
        String imagesFolderPath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets\\ProductImages");
        List<String> associatedImages = new List<string>();
        // ******** END   ==== VARIABLES USED TO TRACK ORPHANED IMAGES

        protected String GetIdFieldName(object obj)
        {
            if (obj is Product)
            {
                return "ProductId";
            }
            else if (obj is Link)
            {
                return "LinkId";
            }
            else if (obj is Category)
            {
                return "CategoryId";
            }

            return "ProductId";
        }

        protected void CGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                if (CGrid.DataSourceID == "ProductsDs")
                {
                    int productId = AlwaysConvert.ToInt(e.CommandArgument);
                    Product product = ProductDataSource.Load(productId);
                    if (product != null)
                    {
                        product.Delete();
                    }
                }
                else if (CGrid.DataSourceID == "LinkDs")
                {
                    int linkId = AlwaysConvert.ToInt(e.CommandArgument);
                    Link link = LinkDataSource.Load(linkId);
                    if (link != null)
                    {
                        link.Delete();
                    }
                }
                else if (CGrid.DataSourceID == "CategoryDs")
                {
                    int cId = AlwaysConvert.ToInt(e.CommandArgument);
                    Category cat = CategoryDataSource.Load(cId);
                    if (cat != null)
                    {
                        cat.Delete();
                    }
                }

                CGrid.DataBind();
            }
        }

        protected String GetEditUrl(object obj)
        {
            if (obj is Product)
            {
                Product p = (Product)obj;
                return String.Format("~/Admin/Products/EditProduct.aspx?ProductId={0}", p.Id);
            }
            else if (obj is Link)
            {
                Link l = (Link)obj;
                return String.Format("~/Admin/Catalog/EditLink.aspx?LinkId={0}", l.Id);
            }
            else
            {
                Category c = (Category)obj;
                return String.Format("~/Admin/Catalog/EditCategory.aspx?CategoryId={0}", c.Id);
            }
        }

        protected void CatalogItemTypeList_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedIndex = AlwaysConvert.ToInt(CatalogItemTypeList.SelectedValue);
            //DEFAULT VISIBILITY
            CatalogItemsPanel.Visible = (selectedIndex != 5);
            ImagesPanel.Visible = (selectedIndex == 5);

            switch (selectedIndex)
            {
                case 1: CGrid.DataSourceID = "CategoryDs"; break;
                case 2: CGrid.DataSourceID = "ProductsDs"; break;
                case 4: CGrid.DataSourceID = "LinksDs"; break;
                case 5:
                    // DISPLAY IMAGES GRID AND DELETE BUTTON
                    ImagesPanel.Visible = true;
                    ImageFilesGrid.DataBind();

                    // HIDE THE CATALOG ITEMS PANEL
                    CatalogItemsPanel.Visible = false;
                    break;
                default: CGrid.DataSourceID = "ProductsDs"; break;
            }
        }

        //**************************************//
        //*** CODE TO HANDLE ORPHANED IMAGES ***//
        //**************************************//

        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.ImageLookupHoverPanel.IsCallback)
            {
                // IT IS A CALL BACK FROM ImageLookupHoverPanel
                this.ProcessCallback();
                return;
            }

            // IF WE HAVE TO SHOW ORPHANED IMAGES 
            if (Page.IsPostBack && AlwaysConvert.ToInt(CatalogItemTypeList.SelectedValue) == 5)
            {
                InitOrphanedImagesDs();
            }
        }

        private void ProcessCallback()
        {
            String imageName = Request.QueryString["ImageName"];
            String imagePath = System.IO.Path.Combine("../../Assets/ProductImages", imageName);
            imagePath = imagePath.Replace("\\", "/");
            imagePath = Page.ResolveUrl(imagePath);

            Response.Clear();
            Response.Write("<div class=\"section\">\r\n");
            Response.Write("<div class=\"header\"><h2>" + imageName.Replace(" ", "&nbsp;") + "</h2></div>\r\n");
            Response.Write("<div class=\"content\" >\r\n");
            Response.Write("<img src=\"" + imagePath + "\" alt=\"Loading...\">");
            Response.Write("</div>");
            Response.Write("</div>");
            Response.End();
        }

        private void InitOrphanedImagesDs()
        {
            InitAssociatedImageUrls();
            CollectImagesInformation(imagesFolderPath);
            ImageFilesGrid.DataSource = imageFiles;
        }

        private void CollectImagesInformation(String dirPath)
        {
            // CREATE A LIST OF IMAGES ( RECURSIVELY COLLECT ALL FILES)
            //GET DIRECTORIES
            string[] directories = System.IO.Directory.GetDirectories(dirPath);
            foreach (string dir in directories)
            {
                System.IO.DirectoryInfo dirInfo = new System.IO.DirectoryInfo(dir);
                if (dirInfo.Name != ".svn")
                {
                    CollectImagesInformation(dirInfo.FullName);
                }
            }

            // GET FILES AT ROOT OF THIS DIRECTORY
            AddFiles(dirPath);
        }

        /// <summary>
        /// Prepare list of used images
        /// Many be associated with products, as thumbnail, icon, or std. images
        /// or as additional images 
        /// or to option swathces
        /// </summary>
        private void InitAssociatedImageUrls()
        {
            associatedImages = new List<string>();

            // ADD PRODUCT IMAGES
            ICriteria criteria = NHibernateHelper.CreateCriteria<Product>();
            criteria.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
            criteria.Add(Restrictions.Disjunction()
                .Add(Restrictions.Like("ImageUrl", "~/Assets/ProductImages/%"))
                .Add(Restrictions.Like("ThumbnailUrl", "~/Assets/ProductImages/%"))
                .Add(Restrictions.Like("IconUrl", "~/Assets/ProductImages/%")));

            IList<Product> products = ProductDataSource.LoadForCriteria(criteria);
            foreach (Product product in products)
            {
                if (product.ImageUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(product.ImageUrl);
                if (product.ThumbnailUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(product.ThumbnailUrl);
                if (product.IconUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(product.IconUrl);
            }

            // ADDITIONAL IMAGES
            ICriteria imageCriteria = NHibernateHelper.CreateCriteria<ProductImage>();
            imageCriteria.Add(Restrictions.Like("ImageUrl", "~/Assets/ProductImages/%"));
            IList<ProductImage> images = ProductImageDataSource.LoadForCriteria(imageCriteria);
            foreach (ProductImage image in images)
            {
                associatedImages.Add(image.ImageUrl);
            }

            // OPTION SWATCHES
            ICriteria choicesCriteria = NHibernateHelper.CreateCriteria<OptionChoice>();
            choicesCriteria.Add(Restrictions.Disjunction()
                .Add(Restrictions.Like("ImageUrl", "~/Assets/ProductImages/%"))
                .Add(Restrictions.Like("ThumbnailUrl", "~/Assets/ProductImages/%")));

            IList<OptionChoice> choices = OptionChoiceDataSource.LoadForCriteria(choicesCriteria);
            foreach (OptionChoice choice in choices)
            {
                if (choice.ImageUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(choice.ImageUrl);
                if (choice.ThumbnailUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(choice.ThumbnailUrl);
            }

            // ADD CATEGORY IMAGES
            ICriteria categoryCriteria = NHibernateHelper.CreateCriteria<Category>();
            categoryCriteria.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
            categoryCriteria.Add(Restrictions.Like("ThumbnailUrl", "~/Assets/ProductImages/%"));
            IList<Category> categories = CategoryDataSource.LoadForCriteria(categoryCriteria);
            foreach (Category category in categories)
            {
                if (category.ThumbnailUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(category.ThumbnailUrl);
            }

            // ADD LINK IMAGES
            ICriteria linksCriteria = NHibernateHelper.CreateCriteria<Link>();
            linksCriteria.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
            linksCriteria.Add(Restrictions.Like("ThumbnailUrl", "~/Assets/ProductImages/%"));
            IList<Link> links = LinkDataSource.LoadForCriteria(linksCriteria);
            foreach (Link link in links)
            {
                if (link.ThumbnailUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(link.ThumbnailUrl);
            }

            // ADD GIFT WRAPING IMAGES        
            ICriteria wrapstylesCriteria = NHibernateHelper.CreateCriteria<WrapStyle>();
            wrapstylesCriteria.Add(Restrictions.Like("ImageUrl", "~/Assets/ProductImages/%"));

            IList<WrapStyle> wrapStyles = WrapStyleDataSource.LoadForCriteria(wrapstylesCriteria);
            foreach (WrapStyle ws in wrapStyles)
            {
                if (ws.ImageUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(ws.ImageUrl);
                if (ws.ThumbnailUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(ws.ThumbnailUrl);
            }

            // ADD VARIANT IMAGES
            ICriteria variantsCriteria = NHibernateHelper.CreateCriteria<ProductVariant>();
            criteria.Add(Restrictions.Disjunction()
                .Add(Restrictions.Like("ImageUrl", "~/Assets/ProductImages/%"))
                .Add(Restrictions.Like("ThumbnailUrl", "~/Assets/ProductImages/%"))
                .Add(Restrictions.Like("IconUrl", "~/Assets/ProductImages/%")));

            int variantsCount = ProductVariantDataSource.CountForCriteria(variantsCriteria.Clone() as ICriteria);
            int maxVariantsToCache = 500;
            // avoid loading all variants at same time
            for (int index = 0; index < variantsCount; index += maxVariantsToCache)
            {
                variantsCriteria.SetMaxResults(maxVariantsToCache);
                variantsCriteria.SetFirstResult(index);
                IList<ProductVariant> productVariants = ProductVariantDataSource.LoadForCriteria(variantsCriteria);
                foreach (ProductVariant productVariant in productVariants)
                {
                    if (productVariant.ImageUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(productVariant.ImageUrl);
                    if (productVariant.ThumbnailUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(productVariant.ThumbnailUrl);
                    if (productVariant.IconUrl.StartsWith("~/Assets/ProductImages/")) associatedImages.Add(productVariant.IconUrl);
                }
            }
        }

        private void AddFiles(String dirPath)
        {
            //GET FILES
            string[] files = System.IO.Directory.GetFiles(dirPath);
            foreach (string file in files)
            {
                System.IO.FileInfo fileInfo = new System.IO.FileInfo(System.IO.Path.Combine(dirPath, file));
                if (fileInfo.Exists)
                {
                    String fileName = fileInfo.Name;

                    // ADD THE RELATIVE PATH INFORMATION
                    if (dirPath != imagesFolderPath)
                    {
                        fileName = System.IO.Path.Combine(dirPath.Substring(imagesFolderPath.Length + 1), fileName);
                        fileName = fileName.Replace("\\", "/");
                    }

                    // CHECK IF IT IS ASSOCIATED WITH SOME PRODUCT OR OTHER CATALOG ITEM
                    if (IsAssociatedImage(System.IO.Path.Combine("~/Assets/ProductImages/", fileName)))
                    {
                        continue;
                    }

                    ImageFileItem dgFileItem = new ImageFileItem(fileName, fileInfo.Extension, fileInfo.Length);

                    // DIMENTIONS
                    System.Drawing.Image thisImage = null;
                    try
                    {
                        thisImage = System.Drawing.Image.FromFile(fileInfo.FullName);
                        dgFileItem.Dimensions = string.Format("({0}w X {1}h)", thisImage.Width, thisImage.Height);
                    }
                    catch
                    {
                        dgFileItem.Dimensions = String.Empty;
                    }
                    finally
                    {
                        if (thisImage != null)
                        {
                            thisImage.Dispose();
                            thisImage = null;
                        }
                    }

                    imageFiles.Add(dgFileItem);
                }
            }
        }

        private bool IsAssociatedImage(String filePath)
        {
            foreach (String imageUrl in associatedImages)
            {
                if (imageUrl == filePath) return true;
            }
            return false;
        }

        protected string GetFileSize(long fileSize)
        {
            if (fileSize < 1024) return fileSize.ToString();
            decimal tempSize = fileSize / 1024;
            if (tempSize < 1024) return string.Format("{0:0.#}kb", tempSize);
            tempSize = tempSize / 1024;
            return string.Format("{0:F1}mb", tempSize);
        }


        [Serializable]
        public class ImageFileItem
        {
            private string _Name;
            private String _FileItemType;
            private long _Size; // In KB's        
            String _Dimensions = string.Empty;

            /// <summary>
            /// File Size
            /// </summary>
            public long Size
            {
                get { return _Size; }
                set { _Size = value; }
            }

            /// <summary>
            /// Width and Height
            /// </summary>
            public String Dimensions
            {
                get { return _Dimensions; }
                set { _Dimensions = value; }
            }

            public string Name
            {
                get { return _Name; }
            }
            public String FileItemType
            {
                get { return _FileItemType; }
            }
            public ImageFileItem(string name, String fileItemType, long size)
            {
                _Name = name;
                _FileItemType = fileItemType;
                _Size = size;
            }
        }

        protected void ImageFilesGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            ImageFilesGrid.PageIndex = e.NewPageIndex;
            ImageFilesGrid.DataBind();
        }

        protected void DeleteButton_Click(object sender, EventArgs e)
        {
            List<String> messages = new List<string>();
            // Looping through all the rows in the GridView
            foreach (GridViewRow row in ImageFilesGrid.Rows)
            {
                CheckBox checkbox = (CheckBox)row.FindControl("DeleteCheckbox");
                if ((checkbox != null) && (checkbox.Checked))
                {
                    String fileName = ImageFilesGrid.DataKeys[row.RowIndex].Value.ToString();
                    if (!String.IsNullOrEmpty(fileName))
                    {
                        if (!DeleteFile(fileName))
                        {
                            // DELETE FAILS, LOG FILE NAME FOR ERROR MESSAGE
                            messages.Add(fileName);
                        }
                    }
                }
            }
            ImageFilesGrid.DataBind();
            MessagePanel.Visible = (messages.Count > 0);
            if (messages.Count > 0) PopulateMessages(messages);
        }

        protected void PopulateMessages(List<string> messages)
        {
            Messages.Items.Clear();
            if (messages == null) return;
            foreach (string message in messages)
            {
                Messages.Items.Add(message);
            }
        }



        // delete image file
        private bool DeleteFile(String fileName)
        {
            // FIND THE FILE IN LIST
            for (int i = 0; i < imageFiles.Count; i++)
            {
                if (imageFiles[i].Name == fileName)
                {
                    String filePath = System.IO.Path.Combine(imagesFolderPath, fileName);
                    if (System.IO.File.Exists(filePath))
                    {
                        Exception testException = FileHelper.CanWriteExistingFile(filePath);
                        if (testException == null)
                        {
                            System.IO.File.Delete(filePath);
                            imageFiles.RemoveAt(i);
                            return true;
                        }
                        else return false;
                    }
                    else return false;
                }
            }
            return false;
        }
    }
}