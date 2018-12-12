using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.UI;
using System.Xml;
using System.IO;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Website.Themes
{
    public partial class CSSEditor : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private StyleSheet _styleSheet;
        private XmlDocument _stylesDocument;
        private XmlNode _styleNode;
        private string _theme = string.Empty;
        private string _fullCurrentFileName;

        protected string FullCurrentFileName 
        {
            get 
            {
                if (string.IsNullOrEmpty(_fullCurrentFileName))
                {
                    if (_theme.ToLowerInvariant().EndsWith("responsive"))
                        _fullCurrentFileName = Server.MapPath("~/App_Themes/" + _theme + "/Custom.css");
                    else
                        _fullCurrentFileName = Server.MapPath("~/App_Themes/" + _theme + "/Style.css");
                }
                return _fullCurrentFileName;
            }
        }

        protected XmlNode StyleNode 
        {
            get 
            {
                if (_styleNode == null)
                {
                    _styleNode = _stylesDocument.DocumentElement.SelectSingleNode("/Styles/Style[@StyleName=\"" + StyleList.SelectedValue + "\"]");
                }
                return _styleNode;
            }
        }

        public string Description
        {
            get
            {
                if (StyleNode != null && StyleNode.Attributes["Description"] != null)
                    return StyleNode.Attributes["Description"].Value;
                return string.Empty;
            }
        }

        public string InnerWrapper
        {
            get
            {
                if (StyleNode != null && StyleNode.Attributes["InnerWrapper"] != null)
                    return StyleNode.Attributes["InnerWrapper"].Value;
                return string.Empty;
            }
        }

        public string DisplayName
        {
            get
            {
                if (StyleNode != null && StyleNode.Attributes["DisplayName"] != null)
                    return StyleNode.Attributes["DisplayName"].Value;
                return string.Empty;
            }
        }

        
        protected void Page_Load(object sender, EventArgs e)
        {
            _theme = Request.QueryString["t"];
            if (!File.Exists(this.FullCurrentFileName))
                Response.Redirect("Default.aspx");
            _styleSheet = new StyleSheet();
            _styleSheet.ProcessFile(this.FullCurrentFileName);
            _stylesDocument = new XmlDocument();
            _stylesDocument.Load(Server.MapPath("~/App_Data/Styles.xml"));
            AbleCommerce.Code.PageHelper.SetPickImageButton(BackgroundImage_Style, BrowseBackgroundImageUrl);
            if (!Page.IsPostBack)
            {
                StyleList.DataBind();
                BindCssEditor();
            }
        }
        
        protected void Page_PreRender(Object sender, EventArgs e)
        {
            Caption.Text = string.Format(Caption.Text, _theme);
            if (StyleList.SelectedValue == "AdditionalStyles")
            {
                trStyleSelector.Visible = false;
            }
            else
            {
                trStyleSelector.Visible = true;
                StyleName.Text = StyleList.SelectedValue;
            }
            StyleDescription.Text = this.Description;
        }

        protected void SaveCssEditorButton_Click(Object sender, EventArgs e)
        {
            SaveStyle();
            CssEditorMessage.Text = string.Format("Style saved at {0:t}.", LocaleHelper.LocalNow);
            CssEditorMessage.Visible = true;
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the style
                SaveStyle();

                // redirect away
                Response.Redirect("Default.aspx");
            }
        }

        protected void CancelCssEditorButton_Click(Object sender, EventArgs e)
        {
            //Response.Redirect("EditTheme.aspx?t=" + _theme);
            Response.Redirect("Default.aspx");
        }

        private void SaveStyle()
        {
            string styleName = StyleList.SelectedValue;
            if (styleName == "AdditionalStyles")
            {
                StyleSheet additionalStyles = new StyleSheet();
                additionalStyles.Process(AdditionalCSSStyles.Text);                
                
                // remove all existing non mapped custom styles from the style sheet
                List<string> nonMappedStyleNames = GetNonMappedStyleNames();
                foreach (string key in nonMappedStyleNames)
                {
                    _styleSheet.Styles.Remove(key);
                }
                
                foreach (string key in additionalStyles.Styles.Keys)
                {
                    if (_styleSheet.Styles.Keys.Contains(key)) _styleSheet.Styles[key] = additionalStyles.Styles[key];
                    else _styleSheet.Styles.Add(key, additionalStyles.Styles[key]);
                }
            }
            else
            {
                if (_styleSheet.Styles.ContainsKey(styleName))
                {
                    StyleSheet.Style style = _styleSheet.Styles[styleName];
                    style.Attributes = GetStyleAttributes();

                    if (!string.IsNullOrEmpty(this.InnerWrapper) && _styleSheet.Styles.ContainsKey(this.InnerWrapper))
                    {
                        StyleSheet.Style innerWrapper = _styleSheet.Styles[this.InnerWrapper];
                        innerWrapper.Attributes = GetInnerWrapperAttributes();
                    }
                }
                else
                {
                    StyleSheet.Style style = new StyleSheet.Style();
                    style.Name = styleName;
                    style.Attributes = GetStyleAttributes();
                    _styleSheet.Styles.Add(styleName, style);
                    if (!string.IsNullOrEmpty(this.InnerWrapper))
                    {
                        StyleSheet.Style innerWraper = new StyleSheet.Style();
                        innerWraper.Name = this.InnerWrapper;
                        innerWraper.Attributes = GetInnerWrapperAttributes();
                        _styleSheet.Styles.Add(this.InnerWrapper, innerWraper);
                    }
                }
            }
            File.WriteAllText(this.FullCurrentFileName, _styleSheet.ToString());
        }
        
        protected void BindCssEditor()
        {
            // CLEAR STYLE ATTRIBUTES UI
            ClearAttributesUI();
            string styleName = StyleList.SelectedValue;

            if (styleName == "AdditionalStyles")
            {
                ToggleCssEditor(false);
                AdditionalCSSStyles.Text = string.Empty;
                foreach (StyleSheet.Style style in _styleSheet.Styles.Values)
                {
                    XmlNode node = null;
                    try
                    {
                        node = _stylesDocument.DocumentElement.SelectSingleNode("/Styles/Style[@StyleName=\'" + style.Name + "\']");
                        if (node == null)
                            node = _stylesDocument.DocumentElement.SelectSingleNode("/Styles/Style[@InnerWrapper=\'" + style.Name + "\']");
                        if (node != null)
                            continue;
                    }
                    catch(Exception exp)
                    {
                        Logger.Error(exp.Message, exp);
                    }

                    AdditionalCSSStyles.Text += style.ToString();
                }
            }
            else
            {
                ToggleCssEditor(true);
                if (_styleSheet.Styles.ContainsKey(styleName))
                {
                    StyleSheet.Style style = _styleSheet.Styles[styleName];
                    StyleSheet.Style innerWrapper = null;
                    if (!string.IsNullOrEmpty(this.InnerWrapper) && _styleSheet.Styles.ContainsKey(this.InnerWrapper))
                    {
                        innerWrapper = _styleSheet.Styles[this.InnerWrapper];
                    }
                    Initialize(style, innerWrapper);
                }
            }
        }

        protected List<string> GetNonMappedStyleNames()
        {
            List<string> nonMappedStyleNames = new List<string>();
            foreach (StyleSheet.Style style in _styleSheet.Styles.Values)
            {
                XmlNode node = null;
                try
                {
                    node = _stylesDocument.DocumentElement.SelectSingleNode("/Styles/Style[@StyleName=\'" + style.Name + "\']");
                    if (node == null)
                    {
                        node = _stylesDocument.DocumentElement.SelectSingleNode("/Styles/Style[@InnerWrapper=\'" + style.Name + "\']");
                        if (!nonMappedStyleNames.Contains(style.Name)) nonMappedStyleNames.Add(style.Name);
                    }
                }
                catch
                {
                    // ignore
                }
            }

            return nonMappedStyleNames;
        }

        protected void StyleList_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindCssEditor();
        }

        protected void ToggleCssEditor(bool show) 
        {
            CssEditorPanel.Visible = show;
            AdditionalStylesPanel.Visible = !show;
        }

        #region STYLE EDITOR

        public void Initialize(StyleSheet.Style style, StyleSheet.Style innerWrapperStyle)
        {
            foreach (string attribute in style.Attributes.Keys)
            {
                switch (attribute.ToLower())
                {
                    case "background-color":
                        BackgroundColor_Style.Text = style.Attributes[attribute].Trim();
                        break;

                    case "background-image":
                        string backgroundImage = style.Attributes[attribute];
                        if (!String.IsNullOrEmpty(backgroundImage))
                            backgroundImage = backgroundImage.Replace("url(/", "~/").Replace(")", string.Empty).Trim();
                        BackgroundImage_Style.Text = backgroundImage;
                        break;

                    case "background-repeat":
                        SelectItem(BackgroundRepeat_Style, style.Attributes[attribute]);
                        break;

                    case "background-attachment":
                        SelectItem(BackgroundAttachment_Style, style.Attributes[attribute]);
                        break;

                    case "color":
                        Color_Style.Text = style.Attributes[attribute].Trim();
                        break;

                    case "font-style":
                        SelectItem(FontStyle_Style, style.Attributes[attribute]);
                        break;

                    case "font-size":
                        FontSize_Style.Text = style.Attributes[attribute];
                        break;

                    case "font-family":
                        FontFamily_Style.Text = style.Attributes[attribute];
                        break;

                    case "font-weight":
                        SelectItem(FontWeight_Style, style.Attributes[attribute]);
                        break;

                    case "border":
                        AllCSSBorder.Value = style.Attributes[attribute];
                        break;

                    case "border-top":
                        TopCSSBorder.Value = style.Attributes[attribute];
                        break;

                    case "border-bottom":
                        BottomCSSBorder.Value = style.Attributes[attribute];
                        break;

                    case "border-left":
                        LeftCSSBorder.Value = style.Attributes[attribute];
                        break;

                    case "border-right":
                        RightCSSBorder.Value = style.Attributes[attribute];
                        break;
                    case "margin":
                    case "margin-top":
                    case "margin-bottom":
                    case "margin-left":
                    case "margin-right":
                    case "padding":
                    case "padding-top":
                    case "padding-bottom":
                    case "padding-left":
                    case "padding-right":
                    case "height":
                    case "width":
                        ; // DO NOTHING, THIS WILL BE HANDLED AFTERWARDS
                        break;

                    default:
                        ExtraCssAttributes.Text += string.Format("{0}:{1};\n", attribute, style.Attributes[attribute]);
                        break;
                }
            }

            // STRIP EMPTY LINE BREAK AT THE END
            ExtraCssAttributes.Text = ExtraCssAttributes.Text.Trim();

            if (innerWrapperStyle == null && string.IsNullOrEmpty(InnerWrapper))
                innerWrapperStyle = style;

            if (innerWrapperStyle != null)
            {
                if (innerWrapperStyle.Attributes.ContainsKey("margin"))
                    MarginAll_Style.Text = innerWrapperStyle.Attributes["margin"];
                if (innerWrapperStyle.Attributes.ContainsKey("margin-top"))
                    MarginTop_Style.Text = innerWrapperStyle.Attributes["margin-top"];
                if (innerWrapperStyle.Attributes.ContainsKey("margin-bottom"))
                    MarginBottom_Style.Text = innerWrapperStyle.Attributes["margin-bottom"];
                if (innerWrapperStyle.Attributes.ContainsKey("margin-left"))
                    MarginLeft_Style.Text = innerWrapperStyle.Attributes["margin-left"];
                if (innerWrapperStyle.Attributes.ContainsKey("margin-right"))
                    MarginRight_Style.Text = innerWrapperStyle.Attributes["margin-right"];

                if (innerWrapperStyle.Attributes.ContainsKey("padding"))
                    PaddingAll_Style.Text = innerWrapperStyle.Attributes["padding"];
                if (innerWrapperStyle.Attributes.ContainsKey("padding-top"))
                    PaddingTop_Style.Text = innerWrapperStyle.Attributes["padding-top"];
                if (innerWrapperStyle.Attributes.ContainsKey("padding-bottom"))
                    PaddingBottom_Style.Text = innerWrapperStyle.Attributes["padding-bottom"];
                if (innerWrapperStyle.Attributes.ContainsKey("padding-left"))
                    PaddingLeft_Style.Text = innerWrapperStyle.Attributes["padding-left"];
                if (innerWrapperStyle.Attributes.ContainsKey("padding-right"))
                    PaddingRight_Style.Text = innerWrapperStyle.Attributes["padding-right"];

                if (innerWrapperStyle.Attributes.ContainsKey("height"))
                    Height_Style.Text = innerWrapperStyle.Attributes["height"];
                if (innerWrapperStyle.Attributes.ContainsKey("width"))
                    Width_Style.Text = innerWrapperStyle.Attributes["width"];

            }
        }

        private void SelectItem(ListControl list, string value)
        {
            list.ClearSelection();
            ListItem item = list.Items.FindByValue(value);
            if (item != null)
                item.Selected = true;
        }

        private void ClearAttributesUI()
        {
            BackgroundColor_Style.Text = string.Empty;
            BackgroundImage_Style.Text = string.Empty;
            BackgroundRepeat_Style.ClearSelection();
            BackgroundAttachment_Style.ClearSelection();
            Color_Style.Text = string.Empty;
            FontStyle_Style.ClearSelection();
            FontSize_Style.Text = string.Empty;
            FontFamily_Style.Text = string.Empty;
            FontWeight_Style.ClearSelection();
            AllCSSBorder.Value = string.Empty;
            TopCSSBorder.Value = string.Empty;
            BottomCSSBorder.Value = string.Empty;
            LeftCSSBorder.Value = string.Empty;
            RightCSSBorder.Value = string.Empty;
            MarginAll_Style.Text = string.Empty;
            MarginTop_Style.Text = string.Empty;
            MarginBottom_Style.Text = string.Empty;
            MarginLeft_Style.Text = string.Empty;
            MarginRight_Style.Text = string.Empty;

            PaddingAll_Style.Text = string.Empty;
            PaddingTop_Style.Text = string.Empty;
            PaddingBottom_Style.Text = string.Empty;
            PaddingLeft_Style.Text = string.Empty;
            PaddingRight_Style.Text = string.Empty;

            Height_Style.Text = string.Empty;
            Width_Style.Text = string.Empty;
            ExtraCssAttributes.Text = string.Empty;
            AllCSSBorder.ClearAttributesUI();
            TopCSSBorder.ClearAttributesUI();
            BottomCSSBorder.ClearAttributesUI();
            LeftCSSBorder.ClearAttributesUI();
            RightCSSBorder.ClearAttributesUI();
        }

        public Dictionary<string, string> GetStyleAttributes()
        {
            Dictionary<string, string> attributes = new Dictionary<string, string>();
            attributes.Add("background-color", BackgroundColor_Style.Text.Trim());
            string backgroundImage = string.Empty;
            if (!string.IsNullOrEmpty(BackgroundImage_Style.Text))
                backgroundImage = string.Format("url({0})", BackgroundImage_Style.Text.Replace("~/", "/").Trim());
            attributes.Add("background-image", backgroundImage);
            attributes.Add("background-repeat", BackgroundRepeat_Style.SelectedValue);
            attributes.Add("background-attachment", BackgroundAttachment_Style.SelectedValue);
            attributes.Add("color", Color_Style.Text.Trim());
            attributes.Add("font-style", FontStyle_Style.SelectedValue);
            attributes.Add("font-size", FontSize_Style.Text.Trim());
            attributes.Add("font-family", FontFamily_Style.Text.Trim());
            attributes.Add("font-weight", FontWeight_Style.SelectedValue);
            attributes.Add("border", AllCSSBorder.Value);
            attributes.Add("border-top", TopCSSBorder.Value);
            attributes.Add("border-bottom", BottomCSSBorder.Value);
            attributes.Add("border-left", LeftCSSBorder.Value);
            attributes.Add("border-right", RightCSSBorder.Value);

            if (string.IsNullOrEmpty(InnerWrapper))
            {
                attributes.Add("margin", MarginAll_Style.Text);
                attributes.Add("margin-top", MarginTop_Style.Text);
                attributes.Add("margin-bottom", MarginBottom_Style.Text);
                attributes.Add("margin-left", MarginLeft_Style.Text);
                attributes.Add("margin-right", MarginRight_Style.Text);

                attributes.Add("padding", PaddingAll_Style.Text);
                attributes.Add("padding-top", PaddingTop_Style.Text);
                attributes.Add("padding-bottom", PaddingBottom_Style.Text);
                attributes.Add("padding-left", PaddingLeft_Style.Text);
                attributes.Add("padding-right", PaddingRight_Style.Text);

                attributes.Add("height", Height_Style.Text);
                attributes.Add("width", Width_Style.Text);
            }

            string[] extraAttributes = ExtraCssAttributes.Text.Split('\n');
            if (extraAttributes != null && extraAttributes.Length > 0)
            {
                foreach (string extraAttribute in extraAttributes)
                {
                    string[] tokens = extraAttribute.Split(':');
                    if (tokens != null && tokens.Length == 2)
                    {
                        string key = tokens[0].Trim();
                        if (attributes.ContainsKey(key)) attributes[key] = tokens[1].Trim();
                        else attributes.Add(key, tokens[1].Trim());
                    }
                }
            }

            return attributes;
        }

        public Dictionary<string, string> GetInnerWrapperAttributes()
        {
                Dictionary<string, string> attributes = new Dictionary<string, string>();
                attributes.Add("margin", MarginAll_Style.Text);
                attributes.Add("margin-top", MarginTop_Style.Text);
                attributes.Add("margin-bottom", MarginBottom_Style.Text);
                attributes.Add("margin-left", MarginLeft_Style.Text);
                attributes.Add("margin-right", MarginRight_Style.Text);

                attributes.Add("padding", PaddingAll_Style.Text);
                attributes.Add("padding-top", PaddingTop_Style.Text);
                attributes.Add("padding-bottom", PaddingBottom_Style.Text);
                attributes.Add("padding-left", PaddingLeft_Style.Text);
                attributes.Add("padding-right", PaddingRight_Style.Text);

                attributes.Add("height", Height_Style.Text);
                attributes.Add("width", Width_Style.Text);
                return attributes;
        }

        #endregion
    }
}