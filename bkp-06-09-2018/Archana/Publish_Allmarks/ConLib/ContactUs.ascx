<%@ Control Language="C#" AutoEventWireup="True" CodeFile="ContactUs.ascx.cs" Inherits="AbleCommerce.ConLib.ContactUs" %>
<%--
<conlib>
<summary>A Standard Contact Us control containing an send contact us email form.</summary>
<param name="EnableCaptcha" default="false">Indicates whether the captcha input field is enabled for protection from spamming.</param>
<param name="Subject" default="New Contact Message">Default email subject for the contact us email message.</param>
<param name="SendTo" default="">Single or a comma separated list of email addresses, use the format like 'info@ourstore.com,sales@ourstore.com' to specify email addresses. If no value is specified store default email address will be used.</param>
<param name="EnableConfirmationEmail" default="false">Indicates whether the confirmation email is enabled. If true then a confirmation email will be sent back to customer.</param>
<param name="ConfirmationEmailTemplateId" default="0">If confirmation email is enabled, the email template will be used to generate confirmation email.</param>
</conlib>
--%>

<asp:UpdatePanel ID="AjaxContactPanel" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:Panel ID="ContactFormPanel" runat="server" CssClass="ContactFormPanel">
            <div class="row">

                <div class="col-sm-6 col-md-3 col-md-offset-1 col-xs-12">
                    
                    <div class="Info_Form">
                               
                        <asp:TextBox ID="FirstName" runat="server" CssClass="form-control" ValidationGroup="ContactUs" placeholder="Full Name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" ControlToValidate="FirstName" Display="Dynamic" Required="true" 
                            ErrorMessage="Full Name is required" Text="*" ValidationGroup="ContactUs"></asp:RequiredFieldValidator>
                   
                      <%-- <asp:TextBox ID="LastName" runat="server" CssClass="form-control NoneElement" ValidationGroup="ContactUs" placeholder="Last Name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" ControlToValidate="LastName" Display="Dynamic" Required="true" 
                            ErrorMessage="Last name is required" Text="*" ValidationGroup="ContactUs"></asp:RequiredFieldValidator>
                  --%>
                         <asp:TextBox ID="LastName" runat="server" CssClass="form-control" ValidationGroup="ContactUs" placeholder="Last Name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" ControlToValidate="LastName" Display="Dynamic" Required="true" 
                            ErrorMessage="Last name is required" Text="*"></asp:RequiredFieldValidator>

                        <%-- <asp:TextBox ID="Company" runat="server" ValidationGroup="ContactUs" CssClass="form-control" placeholder="Company (optional)"></asp:TextBox> --%>
                         <asp:TextBox ID="Company" runat="server" CssClass="form-control" placeholder="Company (optional)"></asp:TextBox>
                
                   
                        <asp:TextBox ID="Email" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="Email"></asp:TextBox>
                        <cb:EmailAddressValidator ID="EmailAddressValid" runat="server" ControlToValidate="Email" Display="Dynamic" Required="true" 
                            ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" ValidationGroup="ContactUs"></cb:EmailAddressValidator>
                   
                        <asp:TextBox ID="Phone" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="Phone"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="PhoneRequired" runat="server" ControlToValidate="Phone"
                            ErrorMessage="Phone is Required" ValidationGroup="ContactUs">*</asp:RequiredFieldValidator>
                   
              
                        <asp:TextBox ID="Comments" runat="server" TextMode="MultiLine" CssClass="form-control"
                        ValidationGroup="ContactUs" placeholder="Message"></asp:TextBox>
                        
                        <asp:RequiredFieldValidator ID="CommentsValidator" runat="server" ControlToValidate="Comments"
                        ErrorMessage="Message is required" ToolTip="Message is required" Display="Dynamic"
                        Text="*" EnableViewState="False" ValidationGroup="ContactUs"></asp:RequiredFieldValidator>
                           
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
                                
                        <span class="upperArrow">
                            <asp:Button ID="Submit" runat="server" Text="SEND QUESTION" OnClick="Submit_Click" ValidationGroup="ContactUs" />
                        </span>
                   
                        
                    </div> 
                    <asp:ValidationSummary ID="ContactValidationSummary" runat="server" EnableViewState="false" 
                            ValidationGroup="ContactUs" />  
                </div>

                <div class="col-sm-6 col-md-4 col-xs-12">
                    <div class="MapOuter">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3386.171249791653!2d115.8508419151607!3d-31.929107681236324!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2a32bab348067d05%3A0xc308a9de689291e9!2s314+Charles+St%2C+North+Perth+WA+6006!5e0!3m2!1sen!2sau!4v1475798548528" width="100%" height="280" frameborder="0" style="border:0" allowfullscreen></iframe>
                        <script type="text/javascript">
                            //File Upload response from the server
                            Dropzone.options.dropzoneForm = {
                                maxFiles: null,
                                maxFilesize: 9, // MB
                                url: "ContactUs.aspx",
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
                                                url: "ContactUs.aspx/RemoveFile",
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
                        <div class="Upload_section">
                            
                            <div class="dropzone" id="dropzoneForm">
                                <div class="fallback">
                                    <input name="file" type="file" multiple />
                                    <input type="submit" value="Upload" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12 col-md-3 col-xs-12">
                    <div class="contact_detail_Outer">
                    <h3>Address</h3>
                    <p>314 Charles Street <br> North Perth, WA 6006</p>
                    <!-- Add Gap -->
                    <div class="AddGap">&nbsp;</div>
                    <!-- Add Gap -->
                    <div class="Email_info"><span class="Head">Email:</span><span class="Email_body"> sales@allmark.com.au</span></div>
                    <div class="Email_info"><span class="Head">Phone:</span><span class="Email_body"> 08 9328 3977</span></div>
                    <!-- Add Gap -->
                    <div class="AddGap">&nbsp;</div>
                    <!-- Add Gap -->
                    <div class="timeInfo">
                        <h3>Our Opening Hours:</h3>
                        <p>Monday - Thursday 8:30am to 5:00pm</p>
                        <p>Friday 8:30am to 3:00pm</p>
                    </div>
                    </div>
                </div>
                
            </div>
        </asp:Panel>
        <asp:Panel runat="server" ID="MessagePanel" Visible="false" CssClass="confirmationMessageStatus">
            <asp:Label runat="server" ID="SuccessMessage" CssClass="goodCondition" Text="Thank you for contacting us. Your message has been submitted. If needed, we will contact you at the email address you have provided."></asp:Label>
            <asp:Label runat="server" ID="FailureMessage" CssClass="errorCondition" Text="We are experiencing some problems at this time and can not process your request. Please try again later after some time."></asp:Label>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>
