<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EditLanguageDialog.ascx.cs" Inherits="AbleCommerce.Admin.Localization.EditLanguageDialog" %>

<asp:UpdatePanel ID="AddLanguageAjax" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <table class="inputForm">
            <tr>
                <th nowrap>
                    <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" AssociatedControlID="Name" ToolTip="Name of the language."></cb:ToolTipLabel>
                </th>
                <td nowrap>
                    <asp:TextBox ID="Name" runat="server" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RegularExpressionValidator ID="RegExNameValidator" runat="server" ErrorMessage="Maximum length for Name is 100 characters." Text="*" ControlToValidate="Name" ValidationExpression=".{0,100}"  ValidationGroup="EditLanguage"></asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="NameValidator" runat="server" ControlToValidate="Name"
                        Display="Static" ErrorMessage="Name is required." ValidationGroup="EditLanguage" Text="*"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th valign="top" nowrap>
                    <cb:ToolTipLabel ID="CultureLabel" runat="server" Text="Culture:" AssociatedControlID="CultureList" ToolTip="Select the language specific culture code."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:ListBox ID="CultureList" runat="server" SelectionMode="Single" Rows="1">
                        <asp:ListItem Text="" Value=""></asp:ListItem>
                        <asp:ListItem Text="af-ZA. Afrikaans (South Africa)" Value="af-ZA"></asp:ListItem>
                        <asp:ListItem Text="am-ET. Amharic (Ethiopia)" Value="am-ET"></asp:ListItem>
                        <asp:ListItem Text="ar-AE. Arabic (U.A.E.)" Value="ar-AE"></asp:ListItem>
                        <asp:ListItem Text="ar-BH. Arabic (Bahrain)" Value="ar-BH"></asp:ListItem>
                        <asp:ListItem Text="ar-DZ. Arabic (Algeria)" Value="ar-DZ"></asp:ListItem>
                        <asp:ListItem Text="ar-EG. Arabic (Egypt)" Value="ar-EG"></asp:ListItem>
                        <asp:ListItem Text="ar-IQ. Arabic (Iraq)" Value="ar-IQ"></asp:ListItem>
                        <asp:ListItem Text="ar-JO. Arabic (Jordan)" Value="ar-JO"></asp:ListItem>
                        <asp:ListItem Text="ar-KW. Arabic (Kuwait)" Value="ar-KW"></asp:ListItem>
                        <asp:ListItem Text="ar-LB. Arabic (Lebanon)" Value="ar-LB"></asp:ListItem>
                        <asp:ListItem Text="ar-LY. Arabic (Libya)" Value="ar-LY"></asp:ListItem>
                        <asp:ListItem Text="ar-MA. Arabic (Morocco)" Value="ar-MA"></asp:ListItem>
                        <asp:ListItem Text="ar-OM. Arabic (Oman)" Value="ar-OM"></asp:ListItem>
                        <asp:ListItem Text="ar-QA. Arabic (Qatar)" Value="ar-QA"></asp:ListItem>
                        <asp:ListItem Text="ar-SA. Arabic (Saudi Arabia)" Value="ar-SA"></asp:ListItem>
                        <asp:ListItem Text="ar-SY. Arabic (Syria)" Value="ar-SY"></asp:ListItem>
                        <asp:ListItem Text="ar-TN. Arabic (Tunisia)" Value="ar-TN"></asp:ListItem>
                        <asp:ListItem Text="ar-YE. Arabic (Yemen)" Value="ar-YE"></asp:ListItem>
                        <asp:ListItem Text="arn-CL. Mapudungun (Chile)" Value="arn-CL"></asp:ListItem>
                        <asp:ListItem Text="as-IN. Assamese (India)" Value="as-IN"></asp:ListItem>
                        <asp:ListItem Text="az-Cyrl-AZ. Azeri (Cyrillic, Azerbaijan)" Value="az-Cyrl-AZ"></asp:ListItem>
                        <asp:ListItem Text="az-Latn-AZ. Azeri (Latin, Azerbaijan)" Value="az-Latn-AZ"></asp:ListItem>
                        <asp:ListItem Text="ba-RU. Bashkir (Russia)" Value="ba-RU"></asp:ListItem>
                        <asp:ListItem Text="be-BY. Belarusian (Belarus)" Value="be-BY"></asp:ListItem>
                        <asp:ListItem Text="bg-BG. Bulgarian (Bulgaria)" Value="bg-BG"></asp:ListItem>
                        <asp:ListItem Text="bn-BD. Bengali (Bangladesh)" Value="bn-BD"></asp:ListItem>
                        <asp:ListItem Text="bn-IN. Bengali (India)" Value="bn-IN"></asp:ListItem>
                        <asp:ListItem Text="bo-CN. Tibetan (PRC)" Value="bo-CN"></asp:ListItem>
                        <asp:ListItem Text="br-FR. Breton (France)" Value="br-FR"></asp:ListItem>
                        <asp:ListItem Text="bs-Cyrl-BA. Bosnian (Cyrillic, Bosnia and Herzegovina)" Value="bs-Cyrl-BA"></asp:ListItem>
                        <asp:ListItem Text="bs-Latn-BA. Bosnian (Latin, Bosnia and Herzegovina)" Value="bs-Latn-BA"></asp:ListItem>
                        <asp:ListItem Text="ca-ES. Catalan (Catalan)" Value="ca-ES"></asp:ListItem>
                        <asp:ListItem Text="co-FR. Corsican (France)" Value="co-FR"></asp:ListItem>
                        <asp:ListItem Text="cs-CZ. Czech (Czech Republic)" Value="cs-CZ"></asp:ListItem>
                        <asp:ListItem Text="cy-GB. Welsh (United Kingdom)" Value="cy-GB"></asp:ListItem>
                        <asp:ListItem Text="da-DK. Danish (Denmark)" Value="da-DK"></asp:ListItem>
                        <asp:ListItem Text="de-AT. German (Austria)" Value="de-AT"></asp:ListItem>
                        <asp:ListItem Text="de-CH. German (Switzerland)" Value="de-CH"></asp:ListItem>
                        <asp:ListItem Text="de-DE. German (Germany)" Value="de-DE"></asp:ListItem>
                        <asp:ListItem Text="de-LI. German (Liechtenstein)" Value="de-LI"></asp:ListItem>
                        <asp:ListItem Text="de-LU. German (Luxembourg)" Value="de-LU"></asp:ListItem>
                        <asp:ListItem Text="dsb-DE. Lower Sorbian (Germany)" Value="dsb-DE"></asp:ListItem>
                        <asp:ListItem Text="dv-MV. Divehi (Maldives)" Value="dv-MV"></asp:ListItem>
                        <asp:ListItem Text="el-GR. Greek (Greece)" Value="el-GR"></asp:ListItem>
                        <asp:ListItem Text="en-029. English (Caribbean)" Value="en-029"></asp:ListItem>
                        <asp:ListItem Text="en-AU. English (Australia)" Value="en-AU"></asp:ListItem>
                        <asp:ListItem Text="en-BZ. English (Belize)" Value="en-BZ"></asp:ListItem>
                        <asp:ListItem Text="en-CA. English (Canada)" Value="en-CA"></asp:ListItem>
                        <asp:ListItem Text="en-GB. English (United Kingdom)" Value="en-GB"></asp:ListItem>
                        <asp:ListItem Text="en-IE. English (Ireland)" Value="en-IE"></asp:ListItem>
                        <asp:ListItem Text="en-IN. English (India)" Value="en-IN"></asp:ListItem>
                        <asp:ListItem Text="en-JM. English (Jamaica)" Value="en-JM"></asp:ListItem>
                        <asp:ListItem Text="en-MY. English (Malaysia)" Value="en-MY"></asp:ListItem>
                        <asp:ListItem Text="en-NZ. English (New Zealand)" Value="en-NZ"></asp:ListItem>
                        <asp:ListItem Text="en-PH. English (Republic of the Philippines)" Value="en-PH"></asp:ListItem>
                        <asp:ListItem Text="en-SG. English (Singapore)" Value="en-SG"></asp:ListItem>
                        <asp:ListItem Text="en-TT. English (Trinidad and Tobago)" Value="en-TT"></asp:ListItem>
                        <asp:ListItem Text="en-US. English (United States)" Value="en-US"></asp:ListItem>
                        <asp:ListItem Text="en-ZA. English (South Africa)" Value="en-ZA"></asp:ListItem>
                        <asp:ListItem Text="en-ZW. English (Zimbabwe)" Value="en-ZW"></asp:ListItem>
                        <asp:ListItem Text="es-AR. Spanish (Argentina)" Value="es-AR"></asp:ListItem>
                        <asp:ListItem Text="es-BO. Spanish (Bolivia)" Value="es-BO"></asp:ListItem>
                        <asp:ListItem Text="es-CL. Spanish (Chile)" Value="es-CL"></asp:ListItem>
                        <asp:ListItem Text="es-CO. Spanish (Colombia)" Value="es-CO"></asp:ListItem>
                        <asp:ListItem Text="es-CR. Spanish (Costa Rica)" Value="es-CR"></asp:ListItem>
                        <asp:ListItem Text="es-DO. Spanish (Dominican Republic)" Value="es-DO"></asp:ListItem>
                        <asp:ListItem Text="es-EC. Spanish (Ecuador)" Value="es-EC"></asp:ListItem>
                        <asp:ListItem Text="es-ES. Spanish (Spain, International Sort)" Value="es-ES"></asp:ListItem>
                        <asp:ListItem Text="es-GT. Spanish (Guatemala)" Value="es-GT"></asp:ListItem>
                        <asp:ListItem Text="es-HN. Spanish (Honduras)" Value="es-HN"></asp:ListItem>
                        <asp:ListItem Text="es-MX. Spanish (Mexico)" Value="es-MX"></asp:ListItem>
                        <asp:ListItem Text="es-NI. Spanish (Nicaragua)" Value="es-NI"></asp:ListItem>
                        <asp:ListItem Text="es-PA. Spanish (Panama)" Value="es-PA"></asp:ListItem>
                        <asp:ListItem Text="es-PE. Spanish (Peru)" Value="es-PE"></asp:ListItem>
                        <asp:ListItem Text="es-PR. Spanish (Puerto Rico)" Value="es-PR"></asp:ListItem>
                        <asp:ListItem Text="es-PY. Spanish (Paraguay)" Value="es-PY"></asp:ListItem>
                        <asp:ListItem Text="es-SV. Spanish (El Salvador)" Value="es-SV"></asp:ListItem>
                        <asp:ListItem Text="es-US. Spanish (United States)" Value="es-US"></asp:ListItem>
                        <asp:ListItem Text="es-UY. Spanish (Uruguay)" Value="es-UY"></asp:ListItem>
                        <asp:ListItem Text="es-VE. Spanish (Bolivarian Republic of Venezuela)" Value="es-VE"></asp:ListItem>
                        <asp:ListItem Text="et-EE. Estonian (Estonia)" Value="et-EE"></asp:ListItem>
                        <asp:ListItem Text="eu-ES. Basque (Basque)" Value="eu-ES"></asp:ListItem>
                        <asp:ListItem Text="fa-IR. Persian" Value="fa-IR"></asp:ListItem>
                        <asp:ListItem Text="fi-FI. Finnish (Finland)" Value="fi-FI"></asp:ListItem>
                        <asp:ListItem Text="fil-PH. Filipino (Philippines)" Value="fil-PH"></asp:ListItem>
                        <asp:ListItem Text="fo-FO. Faroese (Faroe Islands)" Value="fo-FO"></asp:ListItem>
                        <asp:ListItem Text="fr-BE. French (Belgium)" Value="fr-BE"></asp:ListItem>
                        <asp:ListItem Text="fr-CA. French (Canada)" Value="fr-CA"></asp:ListItem>
                        <asp:ListItem Text="fr-CH. French (Switzerland)" Value="fr-CH"></asp:ListItem>
                        <asp:ListItem Text="fr-FR. French (France)" Value="fr-FR"></asp:ListItem>
                        <asp:ListItem Text="fr-LU. French (Luxembourg)" Value="fr-LU"></asp:ListItem>
                        <asp:ListItem Text="fr-MC. French (Monaco)" Value="fr-MC"></asp:ListItem>
                        <asp:ListItem Text="fy-NL. Frisian (Netherlands)" Value="fy-NL"></asp:ListItem>
                        <asp:ListItem Text="ga-IE. Irish (Ireland)" Value="ga-IE"></asp:ListItem>
                        <asp:ListItem Text="gd-GB. Scottish Gaelic (United Kingdom)" Value="gd-GB"></asp:ListItem>
                        <asp:ListItem Text="gl-ES. Galician (Galician)" Value="gl-ES"></asp:ListItem>
                        <asp:ListItem Text="gsw-FR. Alsatian (France)" Value="gsw-FR"></asp:ListItem>
                        <asp:ListItem Text="gu-IN. Gujarati (India)" Value="gu-IN"></asp:ListItem>
                        <asp:ListItem Text="ha-Latn-NG. Hausa (Latin, Nigeria)" Value="ha-Latn-NG"></asp:ListItem>
                        <asp:ListItem Text="he-IL. Hebrew (Israel)" Value="he-IL"></asp:ListItem>
                        <asp:ListItem Text="hi-IN. Hindi (India)" Value="hi-IN"></asp:ListItem>
                        <asp:ListItem Text="hr-BA. Croatian (Latin, Bosnia and Herzegovina)" Value="hr-BA"></asp:ListItem>
                        <asp:ListItem Text="hr-HR. Croatian (Croatia)" Value="hr-HR"></asp:ListItem>
                        <asp:ListItem Text="hsb-DE. Upper Sorbian (Germany)" Value="hsb-DE"></asp:ListItem>
                        <asp:ListItem Text="hu-HU. Hungarian (Hungary)" Value="hu-HU"></asp:ListItem>
                        <asp:ListItem Text="hy-AM. Armenian (Armenia)" Value="hy-AM"></asp:ListItem>
                        <asp:ListItem Text="id-ID. Indonesian (Indonesia)" Value="id-ID"></asp:ListItem>
                        <asp:ListItem Text="ig-NG. Igbo (Nigeria)" Value="ig-NG"></asp:ListItem>
                        <asp:ListItem Text="ii-CN. Yi (PRC)" Value="ii-CN"></asp:ListItem>
                        <asp:ListItem Text="is-IS. Icelandic (Iceland)" Value="is-IS"></asp:ListItem>
                        <asp:ListItem Text="it-CH. Italian (Switzerland)" Value="it-CH"></asp:ListItem>
                        <asp:ListItem Text="it-IT. Italian (Italy)" Value="it-IT"></asp:ListItem>
                        <asp:ListItem Text="iu-Cans-CA. Inuktitut (Syllabics, Canada)" Value="iu-Cans-CA"></asp:ListItem>
                        <asp:ListItem Text="iu-Latn-CA. Inuktitut (Latin, Canada)" Value="iu-Latn-CA"></asp:ListItem>
                        <asp:ListItem Text="ja-JP. Japanese (Japan)" Value="ja-JP"></asp:ListItem>
                        <asp:ListItem Text="ka-GE. Georgian (Georgia)" Value="ka-GE"></asp:ListItem>
                        <asp:ListItem Text="kk-KZ. Kazakh (Kazakhstan)" Value="kk-KZ"></asp:ListItem>
                        <asp:ListItem Text="kl-GL. Greenlandic (Greenland)" Value="kl-GL"></asp:ListItem>
                        <asp:ListItem Text="km-KH. Khmer (Cambodia)" Value="km-KH"></asp:ListItem>
                        <asp:ListItem Text="kn-IN. Kannada (India)" Value="kn-IN"></asp:ListItem>
                        <asp:ListItem Text="ko-KR. Korean (Korea)" Value="ko-KR"></asp:ListItem>
                        <asp:ListItem Text="kok-IN. Konkani (India)" Value="kok-IN"></asp:ListItem>
                        <asp:ListItem Text="ky-KG. Kyrgyz (Kyrgyzstan)" Value="ky-KG"></asp:ListItem>
                        <asp:ListItem Text="lb-LU. Luxembourgish (Luxembourg)" Value="lb-LU"></asp:ListItem>
                        <asp:ListItem Text="lo-LA. Lao (Lao P.D.R.)" Value="lo-LA"></asp:ListItem>
                        <asp:ListItem Text="lt-LT. Lithuanian (Lithuania)" Value="lt-LT"></asp:ListItem>
                        <asp:ListItem Text="lv-LV. Latvian (Latvia)" Value="lv-LV"></asp:ListItem>
                        <asp:ListItem Text="mi-NZ. Maori (New Zealand)" Value="mi-NZ"></asp:ListItem>
                        <asp:ListItem Text="mk-MK. Macedonian (Former Yugoslav Republic of Macedonia)" Value="mk-MK"></asp:ListItem>
                        <asp:ListItem Text="ml-IN. Malayalam (India)" Value="ml-IN"></asp:ListItem>
                        <asp:ListItem Text="mn-MN. Mongolian (Cyrillic, Mongolia)" Value="mn-MN"></asp:ListItem>
                        <asp:ListItem Text="mn-Mong-CN. Mongolian (Traditional Mongolian, PRC)" Value="mn-Mong-CN"></asp:ListItem>
                        <asp:ListItem Text="moh-CA. Mohawk (Mohawk)" Value="moh-CA"></asp:ListItem>
                        <asp:ListItem Text="mr-IN. Marathi (India)" Value="mr-IN"></asp:ListItem>
                        <asp:ListItem Text="ms-BN. Malay (Brunei Darussalam)" Value="ms-BN"></asp:ListItem>
                        <asp:ListItem Text="ms-MY. Malay (Malaysia)" Value="ms-MY"></asp:ListItem>
                        <asp:ListItem Text="mt-MT. Maltese (Malta)" Value="mt-MT"></asp:ListItem>
                        <asp:ListItem Text="nb-NO. Norwegian, Bokmål (Norway)" Value="nb-NO"></asp:ListItem>
                        <asp:ListItem Text="ne-NP. Nepali (Nepal)" Value="ne-NP"></asp:ListItem>
                        <asp:ListItem Text="nl-BE. Dutch (Belgium)" Value="nl-BE"></asp:ListItem>
                        <asp:ListItem Text="nl-NL. Dutch (Netherlands)" Value="nl-NL"></asp:ListItem>
                        <asp:ListItem Text="nn-NO. Norwegian, Nynorsk (Norway)" Value="nn-NO"></asp:ListItem>
                        <asp:ListItem Text="nso-ZA. Sesotho sa Leboa (South Africa)" Value="nso-ZA"></asp:ListItem>
                        <asp:ListItem Text="oc-FR. Occitan (France)" Value="oc-FR"></asp:ListItem>
                        <asp:ListItem Text="or-IN. Oriya (India)" Value="or-IN"></asp:ListItem>
                        <asp:ListItem Text="pa-IN. Punjabi (India)" Value="pa-IN"></asp:ListItem>
                        <asp:ListItem Text="pl-PL. Polish (Poland)" Value="pl-PL"></asp:ListItem>
                        <asp:ListItem Text="prs-AF. Dari (Afghanistan)" Value="prs-AF"></asp:ListItem>
                        <asp:ListItem Text="ps-AF. Pashto (Afghanistan)" Value="ps-AF"></asp:ListItem>
                        <asp:ListItem Text="pt-BR. Portuguese (Brazil)" Value="pt-BR"></asp:ListItem>
                        <asp:ListItem Text="pt-PT. Portuguese (Portugal)" Value="pt-PT"></asp:ListItem>
                        <asp:ListItem Text="qut-GT. K\u0027iche (Guatemala)" Value="qut-GT"></asp:ListItem>
                        <asp:ListItem Text="quz-BO. Quechua (Bolivia)" Value="quz-BO"></asp:ListItem>
                        <asp:ListItem Text="quz-EC. Quechua (Ecuador)" Value="quz-EC"></asp:ListItem>
                        <asp:ListItem Text="quz-PE. Quechua (Peru)" Value="quz-PE"></asp:ListItem>
                        <asp:ListItem Text="rm-CH. Romansh (Switzerland)" Value="rm-CH"></asp:ListItem>
                        <asp:ListItem Text="ro-RO. Romanian (Romania)" Value="ro-RO"></asp:ListItem>
                        <asp:ListItem Text="ru-RU. Russian (Russia)" Value="ru-RU"></asp:ListItem>
                        <asp:ListItem Text="rw-RW. Kinyarwanda (Rwanda)" Value="rw-RW"></asp:ListItem>
                        <asp:ListItem Text="sa-IN. Sanskrit (India)" Value="sa-IN"></asp:ListItem>
                        <asp:ListItem Text="sah-RU. Yakut (Russia)" Value="sah-RU"></asp:ListItem>
                        <asp:ListItem Text="se-FI. Sami, Northern (Finland)" Value="se-FI"></asp:ListItem>
                        <asp:ListItem Text="se-NO. Sami, Northern (Norway)" Value="se-NO"></asp:ListItem>
                        <asp:ListItem Text="se-SE. Sami, Northern (Sweden)" Value="se-SE"></asp:ListItem>
                        <asp:ListItem Text="si-LK. Sinhala (Sri Lanka)" Value="si-LK"></asp:ListItem>
                        <asp:ListItem Text="sk-SK. Slovak (Slovakia)" Value="sk-SK"></asp:ListItem>
                        <asp:ListItem Text="sl-SI. Slovenian (Slovenia)" Value="sl-SI"></asp:ListItem>
                        <asp:ListItem Text="sma-NO. Sami, Southern (Norway)" Value="sma-NO"></asp:ListItem>
                        <asp:ListItem Text="sma-SE. Sami, Southern (Sweden)" Value="sma-SE"></asp:ListItem>
                        <asp:ListItem Text="smj-NO. Sami, Lule (Norway)" Value="smj-NO"></asp:ListItem>
                        <asp:ListItem Text="smj-SE. Sami, Lule (Sweden)" Value="smj-SE"></asp:ListItem>
                        <asp:ListItem Text="smn-FI. Sami, Inari (Finland)" Value="smn-FI"></asp:ListItem>
                        <asp:ListItem Text="sms-FI. Sami, Skolt (Finland)" Value="sms-FI"></asp:ListItem>
                        <asp:ListItem Text="sq-AL. Albanian (Albania)" Value="sq-AL"></asp:ListItem>
                        <asp:ListItem Text="sr-Cyrl-BA. Serbian (Cyrillic, Bosnia and Herzegovina)" Value="sr-Cyrl-BA"></asp:ListItem>
                        <asp:ListItem Text="sr-Cyrl-CS. Serbian (Cyrillic, Serbia and Montenegro (Former))" Value="sr-Cyrl-CS"></asp:ListItem>
                        <asp:ListItem Text="sr-Cyrl-ME. Serbian (Cyrillic, Montenegro)" Value="sr-Cyrl-ME"></asp:ListItem>
                        <asp:ListItem Text="sr-Cyrl-RS. Serbian (Cyrillic, Serbia)" Value="sr-Cyrl-RS"></asp:ListItem>
                        <asp:ListItem Text="sr-Latn-BA. Serbian (Latin, Bosnia and Herzegovina)" Value="sr-Latn-BA"></asp:ListItem>
                        <asp:ListItem Text="sr-Latn-CS. Serbian (Latin, Serbia and Montenegro (Former))" Value="sr-Latn-CS"></asp:ListItem>
                        <asp:ListItem Text="sr-Latn-ME. Serbian (Latin, Montenegro)" Value="sr-Latn-ME"></asp:ListItem>
                        <asp:ListItem Text="sr-Latn-RS. Serbian (Latin, Serbia)" Value="sr-Latn-RS"></asp:ListItem>
                        <asp:ListItem Text="sv-FI. Swedish (Finland)" Value="sv-FI"></asp:ListItem>
                        <asp:ListItem Text="sv-SE. Swedish (Sweden)" Value="sv-SE"></asp:ListItem>
                        <asp:ListItem Text="sw-KE. Kiswahili (Kenya)" Value="sw-KE"></asp:ListItem>
                        <asp:ListItem Text="syr-SY. Syriac (Syria)" Value="syr-SY"></asp:ListItem>
                        <asp:ListItem Text="ta-IN. Tamil (India)" Value="ta-IN"></asp:ListItem>
                        <asp:ListItem Text="te-IN. Telugu (India)" Value="te-IN"></asp:ListItem>
                        <asp:ListItem Text="tg-Cyrl-TJ. Tajik (Cyrillic, Tajikistan)" Value="tg-Cyrl-TJ"></asp:ListItem>
                        <asp:ListItem Text="th-TH. Thai (Thailand)" Value="th-TH"></asp:ListItem>
                        <asp:ListItem Text="tk-TM. Turkmen (Turkmenistan)" Value="tk-TM"></asp:ListItem>
                        <asp:ListItem Text="tn-ZA. Setswana (South Africa)" Value="tn-ZA"></asp:ListItem>
                        <asp:ListItem Text="tr-TR. Turkish (Turkey)" Value="tr-TR"></asp:ListItem>
                        <asp:ListItem Text="tt-RU. Tatar (Russia)" Value="tt-RU"></asp:ListItem>
                        <asp:ListItem Text="tzm-Latn-DZ. Tamazight (Latin, Algeria)" Value="tzm-Latn-DZ"></asp:ListItem>
                        <asp:ListItem Text="ug-CN. Uyghur (PRC)" Value="ug-CN"></asp:ListItem>
                        <asp:ListItem Text="uk-UA. Ukrainian (Ukraine)" Value="uk-UA"></asp:ListItem>
                        <asp:ListItem Text="ur-PK. Urdu (Islamic Republic of Pakistan)" Value="ur-PK"></asp:ListItem>
                        <asp:ListItem Text="uz-Cyrl-UZ. Uzbek (Cyrillic, Uzbekistan)" Value="uz-Cyrl-UZ"></asp:ListItem>
                        <asp:ListItem Text="uz-Latn-UZ. Uzbek (Latin, Uzbekistan)" Value="uz-Latn-UZ"></asp:ListItem>
                        <asp:ListItem Text="vi-VN. Vietnamese (Vietnam)" Value="vi-VN"></asp:ListItem>
                        <asp:ListItem Text="wo-SN. Wolof (Senegal)" Value="wo-SN"></asp:ListItem>
                        <asp:ListItem Text="xh-ZA. isiXhosa (South Africa)" Value="xh-ZA"></asp:ListItem>
                        <asp:ListItem Text="yo-NG. Yoruba (Nigeria)" Value="yo-NG"></asp:ListItem>
                        <asp:ListItem Text="zh-CN. Chinese (Simplified, PRC)" Value="zh-CN"></asp:ListItem>
                        <asp:ListItem Text="zh-HK. Chinese (Traditional, Hong Kong S.A.R.)" Value="zh-HK"></asp:ListItem>
                        <asp:ListItem Text="zh-MO. Chinese (Traditional, Macao S.A.R.)" Value="zh-MO"></asp:ListItem>
                        <asp:ListItem Text="zh-SG. Chinese (Simplified, Singapore)" Value="zh-SG"></asp:ListItem>
                        <asp:ListItem Text="zh-TW. Chinese (Traditional, Taiwan)" Value="zh-TW"></asp:ListItem>
                        <asp:ListItem Text="zu-ZA. isiZulu (South Africa)" Value="zu-ZA"></asp:ListItem>
                    </asp:ListBox>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="validation" align="center">
                    <cb:Notification ID="SavedMessage" runat="server" SkinID="GoodCondition" EnableViewState="false" Visible="false" Text="Language {0} added."></cb:Notification>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="EditLanguage" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="SaveButton" SkinId="AdminButton" runat="server" Text="Save" OnClick="SaveButton_Click" ValidationGroup="EditLanguage" />&nbsp;
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>