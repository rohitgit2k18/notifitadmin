<%@ Page Title="CSS Editor" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="CSSEditor.aspx.cs" Inherits="AbleCommerce.Admin.Website.Themes.CSSEditor" %>
<%@ Register src="CSSBorder.ascx" tagname="CSSBorder" tagprefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <link type="text/css" rel="Stylesheet" href="../../../Scripts/colorpicker/colorpicker.css" />
    <script src="../../../Scripts/colorpicker/colorpicker.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var previous;
        $(document).ready(function () {
            $('.cssEditor').each(function () {
                $('input[type=text], select, textarea', this).each(function () {
                    $(this).data("_intialData", this.value);
                });
            });
            previous = $('#<%=StyleList.ClientID %>').val();
            $('#<%=StyleList.ClientID %>').change(function () {
                var hasChanges = false;
                $('.cssEditor').each(function () {
                    $('input[type=text], select, textarea', this).each(function () {
                        if (this.value != $(this).data('_intialData')) {
                            hasChanges = true;
                        }
                    });

                })
                if (!hasChanges || confirm("You have unsaved changes! Discard unsaved changes and continue?")) {
                    setTimeout('__doPostBack(\'<%=StyleList.UniqueID %>\',\'\')', 0);
                }
                else {
                    $(this).val(previous);
                }
            });
        });
    
        $(document).ready(function () {
            $(".Multiple").ColorPicker({ onSubmit: function (hsb, hex, rgb, el) {
                    $(el).val("#"+hex);
                    $(el).ColorPickerHide();
                },
                onBeforeShow: function () {
                    $(this).ColorPickerSetColor(this.value);
                }
            });
        });
    </script>
    <div class="pageHeader">
	    <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Edit Theme {0}"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="SaveCssEditorButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveCssEditorButton_Click" />
                 <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
                <asp:Button ID="CancelCssEditorButton" runat="server" Text="Cancel" SkinID="CancelButton"  OnClick="CancelCssEditorButton_Click" />
            </div>
        </div>
    </div>
    <cb:Notification ID="CssEditorMessage" runat="server" SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
    <div class="searchPanel">
        <div class="EditorWarningMessage">
            <p><asp:Localize ID="WarningMessageText" runat="server" Text="<b>Warning:</b> Making changes through this theme editor will modify the style.css file. If you have changed the style.css file outside of AbleCommerce, then you should not use this editor, as it may overwrite any changes that have been previously made."></asp:Localize></p>
        </div>
        <table class="inputForm">
            <tr>
                <th>
                    <asp:Label ID="StyleListLabel" runat="server" Text="Choose Style: " EnableViewState="false" SkinID="FieldHeader"></asp:Label>
                </th>
                <td>
                    <asp:DropDownList ID="StyleList" runat="server" DataSourceID="StyleDS" 
                            DataTextField="DisplayName" DataValueField="StyleName" 
                            onselectedindexchanged="StyleList_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:XmlDataSource ID="StyleDS" runat="server" DataFile="~/App_Data/Styles.xml" XPath="/Styles/*"></asp:XmlDataSource>
                </td>
            </tr>
            <tr id="trStyleSelector" runat="server">
                <th>
                    <asp:Localize ID="StyleSelectorLabel" runat="server" EnableViewState="false" Text="Style Selector: "></asp:Localize>
                </th>
                <td>
                    <asp:Literal ID="StyleName" runat="server" EnableViewState="false"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Literal ID="StyleDescription" runat="server"></asp:Literal>
                </td>
            </tr>
        </table>
    </div>
    <asp:Panel ID="CssEditorPanel" runat="server" CssClass="cssEditor">
        <div class="grid_6 alpha">
            <div class="leftColumn">
                <div class="section">
                    <div class="header">
                        <h2><asp:Localize ID="FontLabel" runat="server" EnableViewState="false">Font</asp:Localize></h2>
                    </div>
                    <div class="content">
                        <table class="inputForm">
                            <tr>
                                <th><asp:Localize ID="ColorLabel" runat="server" EnableViewState="false">Color:</asp:Localize></th>
                                <td><asp:TextBox ID="Color_Style" runat="server" CssClass="Multiple"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="FontFamilyLabel" runat="server" EnableViewState="false">Font Family:</asp:Localize></th>
                                <td><asp:TextBox ID="FontFamily_Style" runat="server"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="FontSizeLabel" runat="server" EnableViewState="false">Font Size:</asp:Localize></th>
                                <td><asp:TextBox ID="FontSize_Style" runat="server" Width="65"></asp:TextBox></td>
                            </tr>
                            <tr>
					            <th><asp:Localize ID="FontStyleLabel" runat="server" EnableViewState="false">Font Style:</asp:Localize></th>
                                <td>
                                    <asp:DropDownList ID="FontStyle_Style" runat="server">
                                        <asp:ListItem Text="" Value=""></asp:ListItem>
                                        <asp:ListItem Text="normal" Value="normal"></asp:ListItem>
                                        <asp:ListItem Text="italic" Value="italic"></asp:ListItem>
                                        <asp:ListItem Text="oblique" Value="oblique"></asp:ListItem>
                                        <asp:ListItem Text="inherit" Value="inherit"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
					            <th><asp:Localize ID="FontWeightLabel" runat="server" EnableViewState="false">Font Weight:</asp:Localize></th>
                                <td>
                                    <asp:DropDownList ID="FontWeight_Style" runat="server">
                                        <asp:ListItem Text="" Value=""></asp:ListItem>
                                        <asp:ListItem Text="normal" Value="normal"></asp:ListItem>
                                        <asp:ListItem Text="bold" Value="bold"></asp:ListItem>
                                        <asp:ListItem Text="bolder" Value="bolder"></asp:ListItem>
                                        <asp:ListItem Text="inherit" Value="inherit"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="section">
                    <div class="header">
                        <asp:Localize ID="PaddingLabel" runat="server" EnableViewState="false">Paddings</asp:Localize>
                    </div>
                    <div class="content">
                        <table class="inputForm">
                            <tr>
                                <th><asp:Localize ID="PaddingTopLabel" runat="server" EnableViewState="false">Top:</asp:Localize></th>
                                <td><asp:TextBox ID="PaddingTop_Style" runat="server" Width="60"></asp:TextBox></td>
                                <th><asp:Localize ID="PaddingRightLabel" runat="server" EnableViewState="false">Right:</asp:Localize></th>
                                <td><asp:TextBox ID="PaddingRight_Style" runat="server" Width="60"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="PaddingBottomLabel" runat="server" EnableViewState="false">Bottom:</asp:Localize></th>
                                <td><asp:TextBox ID="PaddingBottom_Style" runat="server" Width="60"></asp:TextBox></td>
                                <th><asp:Localize ID="PaddingLeftLabel" runat="server" EnableViewState="false">Left:</asp:Localize></th>
                                <td><asp:TextBox ID="PaddingLeft_Style" runat="server" Width="60"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="PaddingAllLabel" runat="server" EnableViewState="false">All:</asp:Localize></th>
                                <td colspan="3"><asp:TextBox ID="PaddingAll_Style" runat="server" Width="60"></asp:TextBox></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="section">
                    <div class="header">
                        <asp:Localize ID="MarginLabel" runat="server" EnableViewState="false">Margins</asp:Localize>
                    </div>
                    <div class="content">
                        <table class="inputForm">
                            <tr>
                                <th><asp:Localize ID="MarginTopLabel" runat="server" EnableViewState="false">Top:</asp:Localize></th>
                                <td><asp:TextBox ID="MarginTop_Style" runat="server" Width="60"></asp:TextBox></td>
                                <th><asp:Localize ID="MarginRightLabel" runat="server" EnableViewState="false">Right:</asp:Localize></th>
                                <td><asp:TextBox ID="MarginRight_Style" runat="server" Width="60"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="MarginBottomLabel" runat="server" EnableViewState="false">Bottom:</asp:Localize></th>
                                <td><asp:TextBox ID="MarginBottom_Style" runat="server" Width="60"></asp:TextBox></td>
                                <th><asp:Localize ID="MarginLeftLabel" runat="server" EnableViewState="false">Left:</asp:Localize></th>
                                <td><asp:TextBox ID="MarginLeft_Style" runat="server" Width="60"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="MarginAllLabel" runat="server" EnableViewState="false">All:</asp:Localize></th>
                                <td colspan="3"><asp:TextBox ID="MarginAll_Style" runat="server" Width="60"></asp:TextBox></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="grid_6 omega">
            <div class="rightColumn">
                <div class="section">
                    <div class="header">
                        <asp:Localize ID="BackgroundLabel" runat="server" EnableViewState="false">Background</asp:Localize>
                    </div>
                    <div class="content">
                        <table class="inputForm">
                            <tr>
                                <th><asp:Localize ID="BackgroundColorLabel" runat="server" EnableViewState="false">Color:</asp:Localize></th>
                                <td><asp:TextBox ID="BackgroundColor_Style" runat="server" CssClass="Multiple"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="BackgroundImageLabel" runat="server" EnableViewState="false">Image:</asp:Localize></th>
                                <td><asp:TextBox ID="BackgroundImage_Style" runat="server" Width="230"></asp:TextBox>&nbsp;<asp:ImageButton ID="BrowseBackgroundImageUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" /></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="BackgroundRepeaterLabel" runat="server" EnableViewState="false">Repeat:</asp:Localize></th>
                                <td>
                                    <asp:DropDownList ID="BackgroundRepeat_Style" runat="server" Width="80">
                                        <asp:ListItem Text="" Value=""></asp:ListItem>
                                        <asp:ListItem Text="repeat" Value="repeat"></asp:ListItem>
                                        <asp:ListItem Text="repeat-x" Value="repeat-x"></asp:ListItem>
                                        <asp:ListItem Text="repeat-y" Value="repeat-y"></asp:ListItem>
                                        <asp:ListItem Text="no-repeat" Value="no-repeat"></asp:ListItem>
                                        <asp:ListItem Text="inherit" Value="inherit"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="BackgroundScrollLabel" runat="server" EnableViewState="false">Scrolling:</asp:Localize></th>
                                <td>
                                    <asp:DropDownList ID="BackgroundAttachment_Style" runat="server" Width="80">
                                        <asp:ListItem Text="" Value=""></asp:ListItem>
                                        <asp:ListItem Text="scroll" Value="scroll"></asp:ListItem>
                                        <asp:ListItem Text="fixed" Value="fixed"></asp:ListItem>
                                        <asp:ListItem Text="inherit" Value="inherit"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="section">
                    <div class="header">
                        <asp:Localize ID="BordersLabel" runat="server" EnableViewState="false">Borders</asp:Localize>
                    </div>
                    <div class="content">
                        <table class="inputForm">
                            <tr>
                                <th><asp:Localize ID="BorderAllLabel" runat="server" EnableViewState="false">All:</asp:Localize></th>
                                <td><uc1:CSSBorder ID="AllCSSBorder" runat="server" /></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="BorderTopLabel" runat="server" EnableViewState="false">Top:</asp:Localize></th>
                                <td><uc1:CSSBorder ID="TopCSSBorder" runat="server" /></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="BorderBottomLabel" runat="server" EnableViewState="false">Bottom:</asp:Localize></th>
                                <td><uc1:CSSBorder ID="BottomCSSBorder" runat="server" /></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="BorderLeftLabel" runat="server" EnableViewState="false">Left:</asp:Localize></th>
                                <td><uc1:CSSBorder ID="LeftCSSBorder" runat="server" /></td>
                            </tr>
                            <tr>
                                <th><asp:Localize ID="BorderRightLabel" runat="server" EnableViewState="false">Right:</asp:Localize></th>
                                <td><uc1:CSSBorder ID="RightCSSBorder" runat="server" /></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="section">
                    <div class="header">
                        <asp:Localize ID="PositionLabel" runat="server" EnableViewState="false">Position</asp:Localize>
                    </div>
                    <div class="content">
                        <table class="inputForm">
                            <tr>
                                <th><asp:Localize ID="HeightLabel" runat="server" EnableViewState="false">Height:</asp:Localize></th>
                                <td><asp:TextBox ID="Height_Style" runat="server" Width="60px"></asp:TextBox></td>
                                <th><asp:Localize ID="WidthLabel" runat="server" EnableViewState="false">Width:</asp:Localize></th>
                                <td><asp:TextBox ID="Width_Style" runat="server" Width="60px"></asp:TextBox></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="clear"></div>
        <div class="section">
            <div class="header">
                <asp:Localize ID="ExtraLabel" runat="server" EnableViewState="false">Extra</asp:Localize>
            </div>
            <div class="content">
                <asp:TextBox ID="ExtraCssAttributes" runat="server" TextMode="MultiLine" Height="100" Width="98%"></asp:TextBox>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel id="AdditionalStylesPanel" runat="server" Visible="false" CssClass="content">
        <asp:TextBox ID="AdditionalCSSStyles" runat="server" TextMode="MultiLine" Width="99%" Height="200"></asp:TextBox>
    </asp:Panel>
</asp:Content>