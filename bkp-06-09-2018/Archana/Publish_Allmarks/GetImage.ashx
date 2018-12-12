<%@ WebHandler Language="C#" Class="AbleCommerce.GetImage" %>
/* -------------- LIST OF PARAMETERS ----------------- */
/* - path -> URL encoded image path parameter. Represents the fully qualified image path. For example ~/Assets/ProductImages/abc.jpg
 * - height -> the desired height of the image
 * - width -> the desired width of the image
 * - maxHeight -> maximum height allowed for the desired image
 * - maxWidth -> maximum width allowed for the desired image
 * - productId -> Id of the product 
 * - moniker -> Product Image moniker value will be available for additional images only. So, for standard, thumbnail and icon images we can assume monikers 'standard', 'thumbnail', 'icon'. 
 * - resize = standard //re-size to the dimensions defined for standard image in store settings
 * - resize = thumbnail //re-size to the dimensions defined for thumbnail image in store settings
 * - resize = icon //re-size to the dimensions defined for icon image in store settings
 * - resize = custom //re-size to the given custom dimensions 
 * - maintainAspectRatio
 * - quality -> quality for re-sized images, value can be between 20 and 100 ( only applicable for jpg/jpeg type)
 * - optionList -> comma seperated list of option choice Id's for a product variant, its needed to select the variant image of the product
 */
/* --------------------------------------------------- */
/* --------------------- NOTES ------------------------*/
/* - If both 'height' and 'width' parameter are 0, no resizing should be done. Just return the default image.
 * - If one of the parameter is given, the other one should be calculated proportionally.
 * - If current height and width of the image matches the new desired height and width just return the default image.
 * - If new height exceeds the maxHeight or new width exceed the maxWidth they should be forced to the max values.
 * - If an exception or error occurs during processing/resizing a 500 error must be returned.
 * - The default for 'resize' will be custom. If resize is one of standard, thumbnail, or icon the height and width parameters given in URL will be ignored. 
 * - If both image path and ProductId are given then image path will take precedence. ProductId will work only in conjunction with a given moniker. 
 * - Consider maxHeight and maxWidth parameters when no height and width are specified but original image size exceeds the max. 
/* --------------------- NOTES ------------------------*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CommerceBuilder.Utility;
using System.IO;
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using System.Drawing.Imaging;
using CommerceBuilder.Products;
using CommerceBuilder.DomainModel;
using CommerceBuilder.Stores;

namespace AbleCommerce
{
    /// <summary>
    /// Summary description for GetImage
    /// </summary>
    public class GetImage : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            HttpRequest request = context.Request;
            HttpResponse response = context.Response;
              
            string path = request.QueryString["path"];
            if (!string.IsNullOrEmpty(path))
            {
                path = HttpUtility.UrlDecode(path);
                // VALIDATE PATH
                if (!Regex.IsMatch(path, "\\A(?:^(?:(?!\\.\\.|\\\\|:|<|>).)*$)\\z"))
                {
                    // path seems invalid
                    response.Clear();
                    throw new HttpException(404, "Requested resource was not found.");
                }

                try
                {
                    path = context.Server.MapPath(path);
                }
                catch
                {
                    response.Clear();
                    throw new HttpException(404, "Requested resource was not found.");
                }
            }
            
            int productId = AlwaysConvert.ToInt(request.QueryString["productid"]);
            string optionList = request.QueryString["optionList"];
            string moniker = request.QueryString["moniker"];
            bool maintainAspectRatio = AlwaysConvert.ToBool(request.QueryString["maintainAspectRatio"], false);
                
            // default values
            string resize = "custom";
            int desiredHeight = 0;
            int desiredWidth = 0;
            int maxHeight = 0;
            int maxWidth = 0;
            long quality = 80;
            bool requireHeightWidthCalculation = false;

            // check if the provided path is invalid, throw 404
            if (!string.IsNullOrEmpty(path))
            {
                if (!FileHelper.IsExtensionValid(path, AbleContext.Current.Store.Settings.FileExt_Assets) || !File.Exists(path))
                {
                    response.Clear();
                    throw new HttpException(404, "Requested resource was not found.");
                }
            }
                    
            // only consider product id if path is not provided
            else if (productId > 0)
            {                    
                Product product = EntityLoader.Load<Product>(productId);
                if (product == null)
                {
                    response.Clear();
                    throw new HttpException(404, "Requested resource was not found.");
                }
                
                if(!string.IsNullOrEmpty(optionList))
                {
                    requireHeightWidthCalculation = true;
                    ProductVariant variant = ProductVariantDataSource.LoadForOptionList(product.Id, optionList);
                    if (variant != null)
                    {
                        if (moniker == "thumbnail") path = context.Server.MapPath(variant.ThumbnailUrl);
                        else if (moniker == "icon") path = context.Server.MapPath(variant.IconUrl);
                        else path = context.Server.MapPath(variant.ImageUrl);
                    }
                }
                else if (!string.IsNullOrEmpty(moniker))
                {
                    moniker = moniker.Trim().ToLowerInvariant();
                    
                    // check if we need to load the standard images or additional images
                    // for standard, thumbnail and icon images we can assume monikers 'standard', 'thumbnail', 'icon'. 
                    if (moniker == "standard") path = context.Server.MapPath(product.ImageUrl);
                    else if (moniker == "thumbnail") path = context.Server.MapPath(product.ThumbnailUrl);
                    else if (moniker == "icon") path = context.Server.MapPath(product.IconUrl);
                    // we need to serve image based upon the moniker value, get the image url for given moniker
                    else
                    {
                        requireHeightWidthCalculation = true;

                        // load path using moniker
                        ProductImage productImage = AbleContext.Container.Resolve<IProductImageRepository>().LoadForMoniker(productId, moniker);
                        if (productImage == null)
                        {
                            // not a valid request, no path or productId provided
                            response.Clear();
                            throw new HttpException(404, "Requested resource was not found.");
                        }

                        path = context.Server.MapPath(productImage.ImageUrl);
                    }
                }
                
                // check if path is valid and image exists
                if (string.IsNullOrEmpty(path) || !FileHelper.IsExtensionValid(path, AbleContext.Current.Store.Settings.FileExt_Assets) || !File.Exists(path))
                {
                    response.Clear();
                    throw new HttpException(404, "Requested resource was not found.");
                }
            }
            else
            {
                // not a valid request, no path or productId provided
                response.Clear();
                throw new HttpException(404, "Requested resource was not found.");
            }

            try
            { 
                // check if we need to calculate desired height and width
                if (requireHeightWidthCalculation || productId == 0)
                {
                    // check if the resize parameter is specified
                    string tempResize = request.QueryString["resize"];
                    if (!string.IsNullOrEmpty(tempResize))
                    {
                        tempResize = tempResize.Trim().ToLowerInvariant();
                        StoreSettingsManager settings = AbleContext.Current.Store.Settings;
                        if (tempResize == "standard")
                        {
                            resize = tempResize;
                            desiredHeight = settings.StandardImageHeight;
                            desiredWidth = settings.StandardImageWidth;
                        }
                        else if (tempResize == "thumbnail")
                        {
                            resize = tempResize;
                            desiredHeight = settings.ThumbnailImageHeight;
                            desiredWidth = settings.ThumbnailImageWidth;
                        }
                        else if (tempResize == "icon")
                        {
                            resize = tempResize;
                            desiredHeight = settings.IconImageHeight;
                            desiredWidth = settings.IconImageWidth;
                        }
                    }

                    // if its not standard resize use the provided width and height
                    if (resize == "custom")
                    {
                        desiredHeight = AlwaysConvert.ToInt(request.QueryString["height"]);
                        desiredWidth = AlwaysConvert.ToInt(request.QueryString["width"]);
                        maxHeight = AlwaysConvert.ToInt(request.QueryString["maxHeight"]);
                        maxWidth = AlwaysConvert.ToInt(request.QueryString["maxWidth"]);
                    }

                    if (desiredHeight < 0) desiredHeight = 0;
                    if (desiredWidth < 0) desiredWidth = 0;
                    if (maxHeight < 0) maxHeight = 0;
                    if (maxWidth < 0) maxWidth = 0;

                    // If new height exceeds the maxHeight or new width exceed the maxWidth they should be forced to the max values. 
                    if (maxHeight > 0 && desiredHeight > maxHeight) desiredHeight = maxHeight;
                    if (maxWidth > 0 && desiredWidth > maxWidth) desiredWidth = maxWidth;
                }
                
                if(!string.IsNullOrEmpty(request.QueryString["quality"]))
                {
                    quality = AlwaysConvert.ToLong(request.QueryString["quality"], 80);
                    
                    // check if value is valid 
                    if (quality < 20 || quality > 100) quality = 80;
                }
                 

                // serve image request 
                ServeImage(response, path, desiredHeight, desiredWidth, maxHeight, maxWidth, maintainAspectRatio, quality);
            }   
            catch (Exception ex)
            {
                // log the error
                Logger.Warn("An error occured while processing the image, " + ex.Message, ex);

                // If an exception or error occurs during processing/resizing a 500 error must be returned 
                response.Clear();
                throw new HttpException(500, "Internal Server Error.", ex);
            }
        }


        private void ServeImage(HttpResponse response, string path, int desiredHeight, int desiredWidth, int maxHeight, int maxWidth, bool maintainAspectRatio, long quality)
        {   
            string cleanExtension = Path.GetExtension(path.Replace(" ", string.Empty)).ToLowerInvariant();
            if (cleanExtension.StartsWith(".")) cleanExtension = cleanExtension.Substring(1);
            string contentType = "image/" + cleanExtension;
            
            // check if a height or width is specified
            if (desiredHeight > 0 || desiredWidth > 0 || maxHeight > 0 || maxWidth > 0)
            {
                // check the original height, widths
                using (System.Drawing.Image originalImage = System.Drawing.Image.FromFile(path))
                {
                    int originalHeight = originalImage.Height;
                    int originalWidth = originalImage.Width;

                    // If new width, height parameters are zero, while maxHeight and maxWidth not zero, we must ensure that maxHeight and maxWidth values are respected in the returned image
                    // If the current image has height or width greater than maxHeight or maxWidth then resize is necessary. 
                    if (desiredHeight == 0 && originalHeight > maxHeight)
                    {
                        desiredHeight = maxHeight;
                        maintainAspectRatio = true;
                    }

                    if (desiredWidth == 0 && originalWidth > maxWidth)
                    {
                        desiredWidth = maxWidth;
                        maintainAspectRatio = true;
                    }

                    // If one of the width/height parameter is given, the other one should be calculated proportionally. 
                    if (desiredHeight > 0 && desiredWidth == 0)
                    {
                        decimal ratio = (decimal)((decimal)desiredHeight / (decimal)originalHeight);
                        desiredWidth = (int)Math.Round((ratio * originalWidth), 0);
                        maintainAspectRatio = true;
                    }

                    if (desiredWidth > 0 && desiredHeight == 0)
                    {
                        decimal ratio = (decimal)((decimal)desiredWidth / (decimal)originalWidth);
                        desiredHeight = (int)Math.Round((ratio * originalHeight), 0);
                        maintainAspectRatio = true;
                    }

                    // f current height and width of the image matches the new desired height and width just return the default image 
                    if ((desiredHeight == originalHeight && desiredWidth == originalWidth)
                        ||( desiredHeight == 0 && desiredWidth == 0))
                    {
                        response.ContentType = contentType;
                        response.WriteFile(path);
                        response.Flush();
                        return;
                    }

                    // resize the image
                    // GET RESIZE DIMENSIONS
                    int resizeWidth, resizeHeight;
                    FileHelper.GetResizeInfo(originalImage.Width, originalImage.Height, desiredWidth, desiredHeight, maintainAspectRatio, out resizeWidth, out resizeHeight);

                    // GENERATE IMAGE OF APPROPRIATE SIZE
                    using (System.Drawing.Image resizedImage = FileHelper.GetResizedImage(originalImage, resizeWidth, resizeHeight))
                    {
                        if (resizedImage != null)
                        {
                            response.ContentType = contentType;
                            switch (cleanExtension)
                            {
                                case "png":
                                    // PNG output requires a seekable stream
                                    using (MemoryStream seekableStream = new MemoryStream())
                                    {
                                        resizedImage.Save(seekableStream,ImageFormat.Png);
                                        seekableStream.WriteTo(response.OutputStream);
                                    }
                                    break;
                                case "gif":
                                    resizedImage.Save(response.OutputStream, ImageFormat.Gif);
                                    break;
                                case "bmp":
                                    resizedImage.Save(response.OutputStream, ImageFormat.Bmp);
                                    break;
                                default:
                                    // default is jpg format
                                    // Create a parameter collection
                                    EncoderParameters codecParameters = new EncoderParameters(1);

                                    // Fill the only parameter                                    
                                    codecParameters.Param[0] = new EncoderParameter(Encoder.Quality, quality);

                                    // Get the codec info
                                    ImageCodecInfo codecInfo = FindEncoder(ImageFormat.Jpeg);

                                    // Save the image
                                    resizedImage.Save(response.OutputStream, codecInfo, codecParameters);
                                    break;
                            }
                            if (response.IsClientConnected)
                            {
                                response.Flush();
                            }
                            return;
                        }
                    }
                }       
            }
            else
            {
                // If both 'height' and 'width' parameter are 0, no resizing should be done. Just return the default image 
                response.ContentType = contentType;
                response.WriteFile(path);
                if (response.IsClientConnected)
                {
                    response.Flush();
                }
                return;
            }
        }
        
        
        private static ImageCodecInfo FindEncoder(ImageFormat fmt)
        {
            ImageCodecInfo[] infoArray1 = ImageCodecInfo.GetImageEncoders();
            ImageCodecInfo[] infoArray2 = infoArray1;
            for (int num1 = 0; num1 < infoArray2.Length; num1++)
            {
                ImageCodecInfo info1 = infoArray2[num1];
                if (info1.FormatID.Equals(fmt.Guid))
                {
                    return info1;
                }
            }
            return null;
        }

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }
    }
}