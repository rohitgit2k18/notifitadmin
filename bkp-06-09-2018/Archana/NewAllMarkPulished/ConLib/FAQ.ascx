<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FAQ.ascx.cs" Inherits="AbleCommerce.ConLib.FAQ" %>
<asp:UpdatePanel ID="AjaxFAQPanel" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:Panel ID="FAQFormPanel" runat="server" CssClass="ContactFormPanel">
            <div id="faqPage" class="row">
                    <%--<div class="section-wrapper">
                    <div class="col-md-6">
	                    <div class="section">
		                    <div class="pageHeader">
	                            <div class="section">
                                    <div class="content">
                                        <h1>WE ARE ALLMARK</h1>
		                            </div>
                                </div>
                                <div class="section">
                                    <div class="content sub-title">
		                                Ask us anything
		                            </div>
                                </div>
		                    </div>
	                    </div>
                    </div>
                    <div class="col-md-6 text-center">
                        <div class="section">
                            <div class="content">
                                <img src="/Assets/Images/faq-logo.png" class="display-img" alt="Allmark">
		                    </div>
                        </div>
                    </div>
                </div>--%>
                <div class="col-md-6 col-xs-12 faq-list">
                    <h2>FREQUENTLY ASKED QUESTIONS</h2>
                    <br><br>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer0">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            Why should we choose Allmark ?
                        </p>

                        <p class="collapse faqanswer faqanswer0">
                            At Allmark we treat our clients logo as if it were our own. From Customer Service, Account Executives to Artwork and Production Departments, we all work toward the same goal - DO NOT COMPROMISE. <br /><br />
                            We have created a fantastic bond with out network of suppliers and decorators. Near enough is not good enough when it comes to your image. Let us demonstrate this for you on your next promotional campaign.
                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer1">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            What is the process for ordering my promotional products ?
                        </p>

                        <p class="collapse faqanswer faqanswer1">
                            Browse our site and Submit Quotation for selected products OR call one of our promotional specialists to discuss your requirements. View quote and decide on which products you would like. Samples can be arranged if you are unsure. Send us a fax or email outlining your order. If you have an event date for these products, please let us know on placement of the order. Review order confirmation that is emailed directly to you & sign and fax it back to us. <br /><br />
                            Email us your artwork and sign of on artwork proof that will be emailed or faxed to you and fax it back to our office Sit back and let Allmark go for it. We will produce your items with the utmost professionalism and care, on time, every time. How long will it take for my order to be delivered? The lead times to produce your promotional items can vary. Most locally stocked and decorated items will take approximately 2 weeks. We have turned orders around in as little as 2 days to meet our client’s deadlines. If it is URGENT then it is URGENT we won’t make you feel silly for asking. If we say we can do it on time then we will climb over mountains to get it to you. That’s our PROMISE!
                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer2">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            What artwork requirements do you have ?
                        </p>

                        <p class="collapse faqanswer faqanswer2">
                            In a perfect world... Please supply artwork in Vector format as an EPS created in PC or MAC. All fonts to be embedded. Process and offset printing to be supplied in Tiff or Photoshop file to size (3mm bleed on mouse mats) with minimum of 300 dpi. <br /><br />
                            In a less than perfect world... Send us what you have. We have our own in-house artwork department which can do amazing things with what we receive. Don’t lose sleep if you can’t get us the above art requirements. <br /><br />
                            We can work with Jpeg, Tiff, BMP, Corel Draw-V9, Illustrator, PDF, Word, Publisher, Photoshop <br /><br />
                            We can create Vector line art from bitmapped images. This is mostly done for free however; complicated logos requiring a complex redraw may incur a small artwork fee. This will be relayed to you prior to commencement. <br /><br />
                            Typesetting, layout, design and art proofing are also included in our service. Most of our competitors charge additional for these tasks.
                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer3">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            What form of Payments do you accept ?
                        </p>

                        <p class="collapse faqanswer faqanswer3">
                            We accept all major credit cards. Visa, MasterCard, American Express and Diners Card. We also accept payment by form of EFT, and cheque.
                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer4">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            Will you match a competitor’s quote?
                        </p>

                        <p class="collapse faqanswer faqanswer4">
                            Not always. At Allmark, we pride ourselves as being one of the most competitive promotional suppliers in the country. We do not put excessively high markups on our products and services.<br /><br />
                            Of course we will work with you if you have budget restraints and come to a mutually beneficial compromise. If you have a quote, we will more often than not be able to better it on an apples to apples basis. Some of our competitors will compromise quality of materials to give you a better price. Allmark will not.
                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer5">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            Privacy Policy
                        </p>

                        <p class="collapse faqanswer faqanswer5">
                            Allmark is dedicated to keeping your details private. Any information, we collect in relation to you, is kept strictly secured. We do not pass on/sell/swap any of your personal details with anyone. We use this information to identify your orders; that's all. Allmark uses cookies to maintain a shopping cart and to request a quote for your shopping cart. Cookies sent to your computer from Allmark only last while you’re browsing our website. We do not store persistent cookies on your computer. <br /><br />
                            Whenever you use our web site, or any other web site, the computer on which the web pages are stored (the Web server) needs to know the network address of your computer so that it can send the requested web pages to your Internet browser. The unique network address of your computer is called its "IP address," and is sent automatically each time you access any Internet site. From a computer's IP address, it is possible to determine the general geographic location of that computer, but otherwise it is anonymous. <br /><br />
                            We do not keep a record of the IP addresses from which users access our site except where you have specifically provided us with information about yourself, in which case we also record your IP address for security purposes. An example of this would be when you are approving a quote or making a payment. After completing the relevant form provided, your IP address will be stored along with a transaction number that allows us to track your request.
                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer6">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            Security Policy
                        </p>

                        <p class="collapse faqanswer faqanswer6">
                            When paying online for your Allmark order, your financial details are passed through a secure server using the latest 128-bit SSL (secure sockets layer) encryption technology.128-bit SSL encryption is approximated to take at least one trillion years to break, and is the industry standard. If you have any questions regarding our security policy, please contact us (crm@crm.allmark.com.au).
                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer7">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            Customer Service
                        </p>

                        <p class="collapse faqanswer faqanswer7">
                            Allmark is committed to providing exceptional customer service and quality products.  Please contact us for a competitive price on the products displayed on our website.

                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer8">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            Shipping and Delivery Policy
                        </p>

                        <p class="collapse faqanswer faqanswer8">
                            We deliver products Australia wide through various shipping companies.  We will provide shipping costs along with your custom quotation.
                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer9">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            Refund Policy
                        </p>

                        <p class="collapse faqanswer faqanswer9">
                            Please choose carefully. We do not normally give refunds if you simply change your mind or make a wrong decision. You can choose between a refund, exchange or credit where goods are faulty, have been wrongly described, are different to the product purchased on the website or doesn't do what it is supposed to do.
                        </p>
                    </div>
                    <div class="faqblock">
                        <p data-toggle="collapse" class="faqquestion" href=".faqanswer10">
                            <span class="icon-faq glyphicon glyphicon-chevron-right"></span>
                            Transaction Currency
                        </p>

                        <p class="collapse faqanswer faqanswer10">
                            All transactions will be processed in AUD.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-xs-12  contact-col">
                    <!-- Carasouel Image Slider -->
                    <div class="content carousel-wrapper image-carousel">
                        <div id="carousel-image-generic" class="carousel slide" data-ride="carousel">
                            <!-- Indicators -->
                            <ol class="carousel-indicators">
                                <li data-target="#carousel-image-generic" data-slide-to="0" class=""></li>
                                <li data-target="#carousel-image-generic" data-slide-to="1" class="active"></li>
                            </ol>

                            <!-- Wrapper for slides -->
                            <div class="carousel-inner" role="listbox">
                                <div class="item">
                                    <img src="../Assets/Images/laser-1.jpg" />
                                </div>
                                <div class="item active">
                                    <img src="../Assets/Images/laser-2.jpg" />
                                </div>
                            </div>
                            <!-- Left and right controls -->
                            <a class="left carousel-control" href="#carousel-image-generic" role="button" data-slide="prev">
                            <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                            <span class="sr-only">Previous</span>
                            </a>
                            <a class="right carousel-control" href="#carousel-image-generic" role="button" data-slide="next">
                            <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                            <span class="sr-only">Next</span>
                            </a>
                        </div>
                    </div>
                    <!-- Enquiry Form -->
                    
                    <!--<div class="col-md-12">
                        <h2>Enquiry Form</h2>
                    </div>
                    <table class="inputForm">
                        <tr>
                            <td colspan="2"></td>
                        </tr>
                        <tr>
                            <td class="col-md-12">
                                <div class="col-md-6 nopadding">
                                    <asp:TextBox ID="FirstName" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="First Name"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" ControlToValidate="FirstName" Display="Dynamic" Required="true"
                                        ErrorMessage="First name is required" Text="*" ValidationGroup="ContactUs"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-md-6 nopadding">
                                    <asp:TextBox ID="LastName" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="Last Name"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" ControlToValidate="LastName" Display="Dynamic" Required="true"
                                        ErrorMessage="Last name is required" Text="*" ValidationGroup="ContactUs"></asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="col-md-12">
                                <asp:TextBox ID="Company" runat="server" ValidationGroup="ContactUs" CssClass="form-control" placeholder="Company (optional)"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="col-md-12">
                                <div class="col-md-6 nopadding">
                                    <asp:TextBox ID="Email" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="Email"></asp:TextBox>
                                    <cb:EmailAddressValidator ID="EmailAddressValid" runat="server" ControlToValidate="Email" Display="Dynamic" Required="true"
                                        ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" ValidationGroup="ContactUs"></cb:EmailAddressValidator>
                                </div>
                                <div class="col-md-6 nopadding">
                                    <asp:TextBox ID="Phone" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="Phone Number"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="PhoneRequired" runat="server" ControlToValidate="Phone"
                                        ErrorMessage="Phone is Required" ValidationGroup="ContactUs">*</asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="col-md-12">
                                <asp:TextBox ID="Comments" runat="server" Height="170px" TextMode="MultiLine" CssClass="form-control"
                                    ValidationGroup="ContactUs" placeholder="Comment"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="CommentsValidator" runat="server" ControlToValidate="Comments"
                                    ErrorMessage="Message is required" ToolTip="Message is required" Display="Dynamic"
                                    Text="*" EnableViewState="False" ValidationGroup="ContactUs"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Panel ID="CaptchaPanel" runat="server">
                                    <table class="inputForm">
                                        <tr>
                                            <td>
                                                <asp:TextBox ID="CaptchaInput" runat="server" CssClass="form-control" EnableViewState="False"
                                                    ValidationGroup="ContactUs"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="CaptchaRequired" runat="server" ControlToValidate="CaptchaInput"
                                                    ErrorMessage="You must enter the verification number" ToolTip="You must enter the number in the image."
                                                    Display="Dynamic" Text="*" EnableViewState="False" ValidationGroup="ContactUs"></asp:RequiredFieldValidator><br />
                                                <asp:PlaceHolder ID="phCaptchaValidators" runat="server" EnableViewState="false"></asp:PlaceHolder>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:PlaceHolder ID="trCaptchaImage" runat="server">
                                                    <div align="center">
                                                        <div align="left" style="width: 300px">
                                                            <asp:Label ID="CaptchaImageLabel" runat="server" Text="Verification Number:" AssociatedControlID="CaptchaImage"
                                                                SkinID="FieldHeader" CssClass="rowHeader" EnableViewState="False"></asp:Label><br />
                                                            <cb:CaptchaImage ID="CaptchaImage" runat="server" Height="70px" Width="250px" EnableViewState="False" /><br />
                                                            <asp:LinkButton ID="ChangeImageLink" runat="server" Text="different image" CausesValidation="false"
                                                                OnClick="ChangeImageLink_Click" EnableViewState="False"></asp:LinkButton><br />
                                                        </div>
                                                    </div>
                                                </asp:PlaceHolder>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <script type="text/javascript">
                                    //File Upload response from the server
                                    Dropzone.options.dropzoneForm = {
                                        maxFiles: null,
                                        maxFilesize: 9, // MB
                                        url: "FAQ.aspx",
                                        init: function () {
                                            this.on("maxfilesexceeded", function (data) {
                                                var res = eval('(' + data.xhr.responseText + ')');
                                            });
                                            this.on("addedfile", function (file) {
                                                // Create the remove button
                                                var removeButton = Dropzone.createElement("<button>Remove file</button>");
                                                // Capture the Dropzone instance as closure.
                                                var _this = this;
                                                // Listen to the click event
                                                removeButton.addEventListener("click", function (e) {
                                                    // Make sure the button click doesn't submit the form:
                                                    e.preventDefault();
                                                    e.stopPropagation();
                                                    // Remove the file preview.
                                                    _this.removeFile(file);
                                                    // If you want to the delete the file on the server as well,
                                                    // you can do the AJAX request here.
                                                    $.ajax({
                                                        type: "POST",
                                                        url: "FAQ.aspx/RemoveFile",
                                                        data: JSON.stringify({ 'name': file.name }),
                                                        contentType: "application/json; charset=utf-8",
                                                        dataType: "json",
                                                        success: function (msg) {
                                                        }
                                                    });
                                                });
                                                // Add the button to the file preview element.
                                                file.previewElement.appendChild(removeButton);
                                            });
                                        }
                                    };
   
   
                                </script>
                                Max Fileupload size: 9mb
                                <div  class="dropzone" id="dropzoneForm">
                                    <div class="fallback">
                                        <input name="file" type="file" multiple />
                                        <input type="submit" value="Upload" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="Submit" runat="server" Text="SEND QUESTION" OnClick="Submit_Click" ValidationGroup="ContactUs" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ValidationSummary ID="ContactValidationSummary" runat="server" EnableViewState="false"
                                    ValidationGroup="ContactUs" />
                            </td>
                        </tr>
                    </table>-->
                </div>
            </div>
        </asp:Panel>
        <asp:Panel runat="server" ID="MessagePanel" Visible="false" CssClass="confirmationMessageStatus">
            <asp:Label runat="server" ID="SuccessMessage" CssClass="goodCondition" Text="Thank you for contacting us. Your message has been submitted. If needed, we will contact you at the email address you have provided."></asp:Label>
            <asp:Label runat="server" ID="FailureMessage" CssClass="errorCondition" Text="We are experiencing some problems at this time and can not process your request. Please try again later after some time."></asp:Label>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>