<%@ Page Title="Install AbleCommerce (Step 2 of 2)" Language="C#" MasterPageFile="~/Install/Install.Master" AutoEventWireup="true" CodeFile="Configure2.aspx.cs" Inherits="AbleCommerce.Install.Configure2" %>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <h1><asp:Localize ID="PageCaption" runat="server" Text="Install AbleCommerce {0} (Step 2 of 2)" /></h1>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="validationSummary" />
    <asp:Panel ID="FormPanel" runat="server">
        <p>To prepare your installation, please fill out the fields below as completely as possible.  Then click the "Install" button at the bottom of the form.  Once the install process is completed, you will be provided a link to the merchant administration of your new store!</p>
        <table cellpadding="5" cellspacing="0" class="inputBox">
            <tr>
                <th align="right" nowrap valign="top">
                    <asp:Label ID="StoreNameLabel" runat="server" Text="Store Name:"></asp:Label>
                </th>
                <td valign="top">
                    <asp:TextBox ID="StoreName" runat="Server" Width="200px" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="StoreNameRequired" runat="server" ControlToValidate="StoreName"
                        ErrorMessage="Store name is required." Display="Dynamic" Text="*" CssClass="requiredField"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th align="right" nowrap>
                    <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email" Text="Admin Email:"></asp:Label>
                </th>
                <td align="left">
                    <asp:TextBox ID="Email" runat="server" Width="200px" MaxLength="200"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email"
                        ErrorMessage="Email address is required." Display="Dynamic" Text="*" CssClass="requiredField"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="EmailValidator" runat="server" Display="Dynamic" 
                        ControlToValidate="Email" ValidationExpression="\S+@\S+\.\S+" ErrorMessage="The email address is not properly formatted." 
                        Text="*" CssClass="requiredField"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <th align="right" nowrap>
                    <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" Text="Password:"></asp:Label>
                </th>
                <td align="left">
                    <asp:TextBox ID="Password" runat="server" TextMode="Password" Columns="20" MaxLength="30"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                        ErrorMessage="Password is required." Text="*" CssClass="requiredField"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th align="right" nowrap>
                    <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword" Text="Retype:"></asp:Label>
                </th>
                <td align="left">
                    <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" Columns="20" MaxLength="30"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                        ErrorMessage="You must retype the password." Text="*" CssClass="requiredField"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
                        ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="You did not retype the password correctly."
                        Text="*" CssClass="requiredField"></asp:CompareValidator>
                </td>
            </tr>
        </table>
        <div class="sectionHeader">
            <h2><asp:Localize ID="StoreAddressCaption" runat="server" Text="Store Address" SkinID="PageCaption"></asp:Localize></h2>
        </div>
        <table cellpadding="4" cellspacing="0" class="inputBox">
            <tr>
                <th align="right" nowrap>
                    <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:"></asp:Label><br />
                </th>
                <td valign="top">
                    <asp:TextBox ID="Address1" runat="server"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="AddressRequired" runat="server" ControlToValidate="Address1"
                            Display="Dynamic" ErrorMessage="Address is required." CssClass="requiredField">*</asp:RequiredFieldValidator>
                </td>
                <th align="right" nowrap>
                    <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:"></asp:Label><br />
                </th>
                <td valign="top">
                    <asp:TextBox ID="Address2" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th align="right" nowrap>
                    <asp:Label ID="CityLabel" runat="server" Text="City:"></asp:Label><br />
                </th>
                <td valign="top">
                    <asp:TextBox ID="City" runat="server"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="CityRequired" runat="server" ControlToValidate="City"
                            Display="Dynamic" ErrorMessage="City is required." CssClass="requiredField">*</asp:RequiredFieldValidator>
                </td>
                <th align="right" nowrap>
                    <asp:Label ID="ProvinceLabel" runat="server" Text="State:"></asp:Label><br />
                </th>
                <td valign="top">
                    <asp:TextBox ID="Province" runat="server"></asp:TextBox><span class="requiredField">*</span>
                    <cb:RequiredRegularExpressionValidator ID="ProvinceRequired" CssClass="requiredField" runat="server" Display="Dynamic" Required="true" ErrorMessage="Please provide a valid two letter US state code (in capital letters)." Text="*" ControlToValidate="Province" ValidationExpression="AL|AK|AZ|AR|CA|CO|CT|DE|DC|FL|GA|HI|ID|IL|IN|IA|KS|KY|LA|ME|MD|MA|MI|MN|MS|MO|MT|NE|NV|NH|NJ|NM|NY|NC|ND|OH|OK|OR|PA|RI|SC|SD|TN|TX|UT|VT|VA|WA|WV|WI|WY" />
                </td>
            </tr>
            <tr>
                <th align="right" nowrap>
                    <asp:Label ID="PostalCodeLabel" runat="server" Text="Zip/Postal Code:"></asp:Label><br />
                </th>
                <td valign="top">
                    <asp:TextBox ID="PostalCode" runat="server"></asp:TextBox><span class="requiredField">*</span>
                    <cb:RequiredRegularExpressionValidator ID="PostalCodeRequired" CssClass="requiredField" runat="server" Display="Dynamic" Required="true" ErrorMessage="You must enter a valid US ZIP (#####)." Text="*" ControlToValidate="PostalCode" ValidationExpression="\d{5}" />
                </td>
                <th align="right" nowrap>
                    <asp:Label ID="CountryCodeLabel" runat="server" Text="Country:"></asp:Label><br />
                </th>
                <td valign="top">
                    <asp:DropDownList ID="Country" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Country_SelectedIndexChanged">
                        <asp:ListItem Value="US" Text="United States" />
                        <asp:ListItem Value="CA" Text="Canada" />
                        <asp:ListItem Value="" Text="------" />
                        <asp:ListItem Value="AF" Text="Afghanistan" />
                        <asp:ListItem Value="AX" Text="&#197;land Islands" />
                        <asp:ListItem Value="AL" Text="Albania" />
                        <asp:ListItem Value="DZ" Text="Algeria" />
                        <asp:ListItem Value="AS" Text="American Samoa" />
                        <asp:ListItem Value="AD" Text="Andorra" />
                        <asp:ListItem Value="AO" Text="Angola" />
                        <asp:ListItem Value="AI" Text="Anguilla" />
                        <asp:ListItem Value="AQ" Text="Antarctica" />
                        <asp:ListItem Value="AG" Text="Antigua and Barbuda" />
                        <asp:ListItem Value="AR" Text="Argentina" />
                        <asp:ListItem Value="AM" Text="Armenia" />
                        <asp:ListItem Value="AW" Text="Aruba" />
                        <asp:ListItem Value="AU" Text="Australia" />
                        <asp:ListItem Value="AT" Text="Austria" />
                        <asp:ListItem Value="AZ" Text="Azerbaijan" />
                        <asp:ListItem Value="BS" Text="Bahamas" />
                        <asp:ListItem Value="BH" Text="Bahrain" />
                        <asp:ListItem Value="BD" Text="Bangladesh" />
                        <asp:ListItem Value="BB" Text="Barbados" />
                        <asp:ListItem Value="BY" Text="Belarus" />
                        <asp:ListItem Value="BE" Text="Belgium" />
                        <asp:ListItem Value="BZ" Text="Belize" />
                        <asp:ListItem Value="BJ" Text="Benin" />
                        <asp:ListItem Value="BM" Text="Bermuda" />
                        <asp:ListItem Value="BT" Text="Bhutan" />
                        <asp:ListItem Value="BO" Text="Bolivia" />
                        <asp:ListItem Value="BA" Text="Bosnia and Herzegovina" />
                        <asp:ListItem Value="BW" Text="Botswana" />
                        <asp:ListItem Value="BV" Text="Bouvet Island" />
                        <asp:ListItem Value="BR" Text="Brazil" />
                        <asp:ListItem Value="BN" Text="Brunei Darussalam" />
                        <asp:ListItem Value="BG" Text="Bulgaria" />
                        <asp:ListItem Value="BF" Text="Burkina Faso" />
                        <asp:ListItem Value="BI" Text="Burundi" />
                        <asp:ListItem Value="KH" Text="Cambodia" />
                        <asp:ListItem Value="CM" Text="Cameroon" />
                        <asp:ListItem Value="CA" Text="Canada" />
                        <asp:ListItem Value="CV" Text="Cape Verde" />
                        <asp:ListItem Value="KY" Text="Cayman Islands" />
                        <asp:ListItem Value="CF" Text="Central African Republic" />
                        <asp:ListItem Value="TD" Text="Chad" />
                        <asp:ListItem Value="CL" Text="Chile" />
                        <asp:ListItem Value="CN" Text="China" />
                        <asp:ListItem Value="CX" Text="Christmas Island" />
                        <asp:ListItem Value="CC" Text="Cocos (Keeling) Islands" />
                        <asp:ListItem Value="CO" Text="Colombia" />
                        <asp:ListItem Value="KM" Text="Comoros" />
                        <asp:ListItem Value="CG" Text="Congo - Brazzaville" />
                        <asp:ListItem Value="CD" Text="Congo - Kinshasa" />
                        <asp:ListItem Value="CK" Text="Cook Islands" />
                        <asp:ListItem Value="CR" Text="Costa Rica" />
                        <asp:ListItem Value="CI" Text="Cote d'Ivoire" />
                        <asp:ListItem Value="HR" Text="Croatia" />
                        <asp:ListItem Value="CU" Text="Cuba" />
                        <asp:ListItem Value="CY" Text="Cyprus" />
                        <asp:ListItem Value="CZ" Text="Czech Republic" />
                        <asp:ListItem Value="DK" Text="Denmark" />
                        <asp:ListItem Value="DJ" Text="Djibouti" />
                        <asp:ListItem Value="DM" Text="Dominica" />
                        <asp:ListItem Value="DO" Text="Dominican Republic" />
                        <asp:ListItem Value="EC" Text="Ecuador" />
                        <asp:ListItem Value="EG" Text="Egypt" />
                        <asp:ListItem Value="SV" Text="El Salvador" />
                        <asp:ListItem Value="GQ" Text="Equatorial Guinea" />
                        <asp:ListItem Value="ER" Text="Eritrea" />
                        <asp:ListItem Value="EE" Text="Estonia" />
                        <asp:ListItem Value="ET" Text="Ethiopia" />
                        <asp:ListItem Value="FK" Text="Falkland Islands" />
                        <asp:ListItem Value="FO" Text="Faroe Islands" />
                        <asp:ListItem Value="FJ" Text="Fiji" />
                        <asp:ListItem Value="FI" Text="Finland" />
                        <asp:ListItem Value="FR" Text="France" />
                        <asp:ListItem Value="GF" Text="French Guiana" />
                        <asp:ListItem Value="PF" Text="French Polynesia" />
                        <asp:ListItem Value="GA" Text="Gabon" />
                        <asp:ListItem Value="GM" Text="Gambia" />
                        <asp:ListItem Value="GE" Text="Georgia" />
                        <asp:ListItem Value="DE" Text="Germany" />
                        <asp:ListItem Value="GH" Text="Ghana" />
                        <asp:ListItem Value="GI" Text="Gibraltar" />
                        <asp:ListItem Value="GR" Text="Greece" />
                        <asp:ListItem Value="GL" Text="Greenland" />
                        <asp:ListItem Value="GD" Text="Grenada" />
                        <asp:ListItem Value="GP" Text="Guadeloupe" />
                        <asp:ListItem Value="GU" Text="Guam" />
                        <asp:ListItem Value="GT" Text="Guatemala" />
                        <asp:ListItem Value="GN" Text="Guinea" />
                        <asp:ListItem Value="GW" Text="Guinea-bissau" />
                        <asp:ListItem Value="GY" Text="Guyana" />
                        <asp:ListItem Value="HT" Text="Haiti" />
                        <asp:ListItem Value="HN" Text="Honduras" />
                        <asp:ListItem Value="HK" Text="Hong Kong" />
                        <asp:ListItem Value="HU" Text="Hungary" />
                        <asp:ListItem Value="IS" Text="Iceland" />
                        <asp:ListItem Value="IN" Text="India" />
                        <asp:ListItem Value="ID" Text="Indonesia" />
                        <asp:ListItem Value="IR" Text="Iran" />
                        <asp:ListItem Value="IQ" Text="Iraq" />
                        <asp:ListItem Value="IE" Text="Ireland" />
                        <asp:ListItem Value="IL" Text="Israel" />
                        <asp:ListItem Value="IT" Text="Italy" />
                        <asp:ListItem Value="JM" Text="Jamaica" />
                        <asp:ListItem Value="JP" Text="Japan" />
                        <asp:ListItem Value="JO" Text="Jordan" />
                        <asp:ListItem Value="KZ" Text="Kazakhstan" />
                        <asp:ListItem Value="KE" Text="Kenya" />
                        <asp:ListItem Value="KI" Text="Kiribati" />
                        <asp:ListItem Value="KP" Text="Korea, North" />
                        <asp:ListItem Value="KR" Text="Korea, South" />
                        <asp:ListItem Value="KW" Text="Kuwait" />
                        <asp:ListItem Value="KG" Text="Kyrgyzstan" />
                        <asp:ListItem Value="LA" Text="Laos" />
                        <asp:ListItem Value="LV" Text="Latvia" />
                        <asp:ListItem Value="LB" Text="Lebanon" />
                        <asp:ListItem Value="LS" Text="Lesotho" />
                        <asp:ListItem Value="LR" Text="Liberia" />
                        <asp:ListItem Value="LY" Text="Libya" />
                        <asp:ListItem Value="LI" Text="Liechtenstein" />
                        <asp:ListItem Value="LT" Text="Lithuania" />
                        <asp:ListItem Value="LU" Text="Luxembourg" />
                        <asp:ListItem Value="MO" Text="Macao" />
                        <asp:ListItem Value="MK" Text="Macedonia" />
                        <asp:ListItem Value="MG" Text="Madagascar" />
                        <asp:ListItem Value="MW" Text="Malawi" />
                        <asp:ListItem Value="MY" Text="Malaysia" />
                        <asp:ListItem Value="MV" Text="Maldives" />
                        <asp:ListItem Value="ML" Text="Mali" />
                        <asp:ListItem Value="MT" Text="Malta" />
                        <asp:ListItem Value="MH" Text="Marshall Islands" />
                        <asp:ListItem Value="MQ" Text="Martinique" />
                        <asp:ListItem Value="MR" Text="Mauritania" />
                        <asp:ListItem Value="MU" Text="Mauritius" />
                        <asp:ListItem Value="YT" Text="Mayotte" />
                        <asp:ListItem Value="MX" Text="Mexico" />
                        <asp:ListItem Value="FM" Text="Micronesia" />
                        <asp:ListItem Value="MD" Text="Moldova" />
                        <asp:ListItem Value="MC" Text="Monaco" />
                        <asp:ListItem Value="MN" Text="Mongolia" />
                        <asp:ListItem Value="MS" Text="Montserrat" />
                        <asp:ListItem Value="MA" Text="Morocco" />
                        <asp:ListItem Value="MZ" Text="Mozambique" />
                        <asp:ListItem Value="MM" Text="Myanmar" />
                        <asp:ListItem Value="NA" Text="Namibia" />
                        <asp:ListItem Value="NR" Text="Nauru" />
                        <asp:ListItem Value="NP" Text="Nepal" />
                        <asp:ListItem Value="NL" Text="Netherlands" />
                        <asp:ListItem Value="AN" Text="Netherlands Antilles" />
                        <asp:ListItem Value="NC" Text="New Caledonia" />
                        <asp:ListItem Value="NZ" Text="New Zealand" />
                        <asp:ListItem Value="NI" Text="Nicaragua" />
                        <asp:ListItem Value="NE" Text="Niger" />
                        <asp:ListItem Value="NG" Text="Nigeria" />
                        <asp:ListItem Value="NU" Text="Niue" />
                        <asp:ListItem Value="NF" Text="Norfolk Island" />
                        <asp:ListItem Value="MP" Text="Northern Mariana Islands" />
                        <asp:ListItem Value="NO" Text="Norway" />
                        <asp:ListItem Value="OM" Text="Oman" />
                        <asp:ListItem Value="PK" Text="Pakistan" />
                        <asp:ListItem Value="PW" Text="Palau" />
                        <asp:ListItem Value="PA" Text="Panama" />
                        <asp:ListItem Value="PG" Text="Papua New Guinea" />
                        <asp:ListItem Value="PY" Text="Paraguay" />
                        <asp:ListItem Value="PE" Text="Peru" />
                        <asp:ListItem Value="PH" Text="Philippines" />
                        <asp:ListItem Value="PN" Text="Pitcairn" />
                        <asp:ListItem Value="PL" Text="Poland" />
                        <asp:ListItem Value="PT" Text="Portugal" />
                        <asp:ListItem Value="PR" Text="Puerto Rico" />
                        <asp:ListItem Value="QA" Text="Qatar" />
                        <asp:ListItem Value="RE" Text="Reunion" />
                        <asp:ListItem Value="RO" Text="Romania" />
                        <asp:ListItem Value="RU" Text="Russian Federation" />
                        <asp:ListItem Value="RW" Text="Rwanda" />
                        <asp:ListItem Value="SH" Text="Saint Helena" />
                        <asp:ListItem Value="KN" Text="Saint Kitts and Nevis" />
                        <asp:ListItem Value="LC" Text="Saint Lucia" />
                        <asp:ListItem Value="PM" Text="Saint Pierre and Miquelon" />
                        <asp:ListItem Value="VC" Text="Saint Vincent" />
                        <asp:ListItem Value="WS" Text="Samoa" />
                        <asp:ListItem Value="SM" Text="San Marino" />
                        <asp:ListItem Value="ST" Text="Sao Tome and Principe" />
                        <asp:ListItem Value="SA" Text="Saudi Arabia" />
                        <asp:ListItem Value="SN" Text="Senegal" />
                        <asp:ListItem Value="RS" Text="Serbia" />
                        <asp:ListItem Value="SC" Text="Seychelles" />
                        <asp:ListItem Value="SL" Text="Sierra Leone" />
                        <asp:ListItem Value="SG" Text="Singapore" />
                        <asp:ListItem Value="SK" Text="Slovakia" />
                        <asp:ListItem Value="SI" Text="Slovenia" />
                        <asp:ListItem Value="SB" Text="Solomon Islands" />
                        <asp:ListItem Value="SO" Text="Somalia" />
                        <asp:ListItem Value="ZA" Text="South Africa" />
                        <asp:ListItem Value="ES" Text="Spain" />
                        <asp:ListItem Value="LK" Text="Sri Lanka" />
                        <asp:ListItem Value="SD" Text="Sudan" />
                        <asp:ListItem Value="SR" Text="Suriname" />
                        <asp:ListItem Value="SJ" Text="Svalbard and Jan Mayen" />
                        <asp:ListItem Value="SZ" Text="Swaziland" />
                        <asp:ListItem Value="SE" Text="Sweden" />
                        <asp:ListItem Value="CH" Text="Switzerland" />
                        <asp:ListItem Value="SY" Text="Syria" />
                        <asp:ListItem Value="TW" Text="Taiwan" />
                        <asp:ListItem Value="TJ" Text="Tajikistan" />
                        <asp:ListItem Value="TZ" Text="Tanzania" />
                        <asp:ListItem Value="TH" Text="Thailand" />
                        <asp:ListItem Value="TL" Text="Timor-leste" />
                        <asp:ListItem Value="TG" Text="Togo" />
                        <asp:ListItem Value="TK" Text="Tokelau" />
                        <asp:ListItem Value="TO" Text="Tonga" />
                        <asp:ListItem Value="TT" Text="Trinidad and Tobago" />
                        <asp:ListItem Value="TN" Text="Tunisia" />
                        <asp:ListItem Value="TR" Text="Turkey" />
                        <asp:ListItem Value="TM" Text="Turkmenistan" />
                        <asp:ListItem Value="TC" Text="Turks and Caicos Islands" />
                        <asp:ListItem Value="TV" Text="Tuvalu" />
                        <asp:ListItem Value="UG" Text="Uganda" />
                        <asp:ListItem Value="UA" Text="Ukraine" />
                        <asp:ListItem Value="AE" Text="United Arab Emirates" />
                        <asp:ListItem Value="GB" Text="United Kingdom" />
                        <asp:ListItem Value="UY" Text="Uruguay" />
                        <asp:ListItem Value="UZ" Text="Uzbekistan" />
                        <asp:ListItem Value="VU" Text="Vanuatu" />
                        <asp:ListItem Value="VA" Text="Vatican City (Holy See)" />
                        <asp:ListItem Value="VE" Text="Venezuela" />
                        <asp:ListItem Value="VN" Text="Viet Nam" />
                        <asp:ListItem Value="VG" Text="Virgin Islands, British" />
                        <asp:ListItem Value="VI" Text="Virgin Islands, U.S." />
                        <asp:ListItem Value="WF" Text="Wallis and Futuna" />
                        <asp:ListItem Value="EH" Text="Western Sahara" />
                        <asp:ListItem Value="YE" Text="Yemen" />
                        <asp:ListItem Value="ZM" Text="Zambia" />
                        <asp:ListItem Value="ZW" Text="Zimbabwe" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="CountryCodeValidator1" runat="server" ControlToValidate="Country"
                            Display="Dynamic" ErrorMessage="Country is required." CssClass="requiredField"><span class="requiredField">*</span></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th align="right" nowrap>
                    <asp:Label ID="PhoneLabel" runat="server" Text="Phone:"></asp:Label><br />
                </th>
                <td valign="top">
                    <asp:TextBox ID="Phone" runat="server"></asp:TextBox>
                </td>
                <th align="right" nowrap>
                    <asp:Label ID="FaxLabel" runat="server" Text="Fax:"></asp:Label><br />
                </th>
                <td valign="top">
                    <asp:TextBox ID="Fax" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th align="right" nowrap>
                    <asp:Label ID="StoreEmailLabel" runat="server" AssociatedControlID="StoreEmail" Text="Store Email:"></asp:Label>
                </th>
                <td align="left">
                    <asp:TextBox ID="StoreEmail" runat="server" MaxLength="200"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" Display="Dynamic" 
                        ControlToValidate="StoreEmail" ValidationExpression="\S+@\S+\.\S+" ErrorMessage="The store email address is not properly formatted." 
                        Text="*" CssClass="requiredField"><span class="requiredField">*</span></asp:RegularExpressionValidator>
                </td>
            </tr>
        </table>        
        <div class="sectionHeader">
            <h2><asp:Localize ID="SampleDataCaption" runat="server" Text="Sample Data"></asp:Localize></h2>
        </div>
        <table cellpadding="4" cellspacing="0">
            <tr>
                <th align="right" nowrap>
                    <asp:Label ID="IncludeSampleDataLabel" runat="server" Text="Include Sample Data:" AssociatedControlID="IncludeSampleData"></asp:Label>
                </th>
                <td align="left">
                    <asp:CheckBox ID="IncludeSampleData" runat="server" Checked="true" />
                    <asp:Localize ID="SampleDataHelpText" runat="server" Text="Check this box to include additional data such as sample product catalog."></asp:Localize>
                </td>
            </tr>
        </table>
        <div class="buttonPanel">
            <asp:Button ID="InstallButton" runat="server" Text="Complete Install" OnClientClick="return ExecuteInstall();" OnClick="InstallButton_Click" CssClass="button" />
        </div>
    </asp:Panel>
    <div id="progressPanel" class="progressPanel">
        <div class="sectionHeader"><h2>Initializing Data</h2></div>  
        <p>Please be patient as this may take a few moments...</p>
        <img src="installing.gif" alt="" />
    </div>
    <asp:Placeholder ID="InstallCompletePanel" runat="server" Visible="false">
        <div class="sectionHeader"><h2><asp:Localize ID="InstallCompleteCaption" runat="server" Text="Installation Complete" /></h2></div>
        <asp:PlaceHolder ID="InstallSucceededPanel" runat="server">
            <p><asp:Localize ID="InstallCompleteText" runat="server" Text="The installation process is complete.  Remove the 'Install' folder from your store directory for security purposes."></asp:Localize></p>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="InstallErrorPanel" runat="server" Visible="false">
            <p><asp:Localize ID="InstallErrorText" runat="server" Text="The errors below occurred while trying to install sample data."></asp:Localize></p>
            <asp:Literal ID="InstallErrorList" runat="server"></asp:Literal>
        </asp:PlaceHolder>
        <div class="buttonPanel">
            <asp:Button ID="ContinueButton" runat="server" Text="Access Merchant Administration" OnClientClick="window.location.href='../Admin/Default.aspx';return false;" CssClass="button" />
        </div>
    </asp:Placeholder>
    <script type="text/javascript">
        function ExecuteInstall() {
            if (Page_ClientValidate()) {
                document.getElementById('progressPanel').style.display = "block";
                document.getElementById('<%=FormPanel.ClientID%>').style.display = "none";
                return true;
            }
            return false;
        }
    </script>
</asp:Content>