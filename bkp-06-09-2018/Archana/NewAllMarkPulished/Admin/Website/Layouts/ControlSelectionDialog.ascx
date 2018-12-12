<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ControlSelectionDialog.ascx.cs" Inherits="AbleCommerce.Admin.Website.Layouts.ControlSelectionDialog" %>
<div class="controlSection">
    <div class="header">
        <asp:Label ID="CaptionLabel" runat="server" Text="Select Controls" EnableViewState="false"/>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="ControlSelectionAjax" runat="server" >
            <ContentTemplate>
                <asp:GridView ID="SelectedControlsList" runat="server" 
                    OnRowCommand="SelectedControls_RowCommand" 
                    OnDataBound="SelectedControls_DataBound" 
                    AutoGenerateColumns="false" 
                    SkinID="PagedList"
                    GridLines="Horizontal"
                    ShowHeader="false">
                    <Columns>
                        <asp:TemplateField >
                            <ItemStyle VerticalAlign="Top" HorizontalAlign="Left"/>
                            <ItemTemplate>
                                <strong><cb:ToolTipLabel ID="Name" runat="server" Text='<%# Eval("DisplayName")%>' ToolTip='<%#Eval("Summary")%>' EnableViewState="false"></cb:ToolTipLabel></strong>
                                <br />
                                <asp:Repeater ID="ParamsRepeater" runat="server" DataSource='<%# Eval("Params") %>' EnableViewState="false">
                                    <ItemTemplate>
                                        <asp:Label ID="ParamName" runat="server" Text='<%# Eval("Name") %>' EnableViewState="false" CssClass="helpText" Visible='<%# !string.IsNullOrEmpty(Eval("CustomValue").ToString()) %>'></asp:Label>
                                        <asp:Label ID="Delimiter" runat="server" Text=":" EnableViewState="false" CssClass="helpText" Visible='<%# !string.IsNullOrEmpty(Eval("CustomValue").ToString()) %>'></asp:Label>
                                        <asp:Label ID="CustomValue" runat="server" Text='<%# Eval("CustomValue") %>' EnableViewState="false" CssClass="helpText" Visible='<%# !string.IsNullOrEmpty(Eval("CustomValue").ToString()) %>'></asp:Label>
                                        <asp:Literal ID="LineBreak" runat="server" Text="<br />" EnableViewState="false" Visible='<%# !string.IsNullOrEmpty(Eval("CustomValue").ToString()) %>'></asp:Literal>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle VerticalAlign="Top" HorizontalAlign="Right" Width="150px"/>
                            <ItemTemplate>
                                <asp:ImageButton ID="Edit" runat="server" ToolTip="Edit Parameters" CommandName="Do_Edit" CommandArgument='<%# Eval("InstanceId") %>' SkinID="EditIcon" CausesValidation="false" Visible='<%# IsEditIconVisible(Eval("Name"))%>'/>
                                <asp:ImageButton ID="Up" runat="server" ToolTip="Move Up" CommandName="Do_Up" CommandArgument='<%#Eval("InstanceId")%>' SkinID="UpIcon" CausesValidation="false" EnableViewState="true"/>
                                <asp:ImageButton ID="Down" runat="server" ToolTip="Move Down" CommandName="Do_Down" CommandArgument='<%# Eval("InstanceId") %>' SkinID="DownIcon" CausesValidation="false" />
                                <asp:ImageButton ID="Copy" runat="server" ToolTip="Duplicate/Copy" CommandName="Do_Copy" CommandArgument='<%# Eval("InstanceId") %>' SkinID="CopyIcon" CausesValidation="false" OnClientClick='<%# Eval("DisplayName", "return confirm(\"Adding the same control more than once can possibly break a page if the control is not built with the requisite ability. Are you sure you want to add a copy of {0} control? \")") %>' />
                                <asp:ImageButton ID="Delete" runat="server" ToolTip="Delete" CommandName="Do_Delete" CommandArgument='<%# Eval("InstanceId") %>' SkinID="DeleteIcon" CausesValidation="false" OnClientClick="return confirm('Are you sure you want to remove this control?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>                
                <div style="text-align:right"><asp:Button ID="AddControlButton" runat="server" Text="Add Controls" SkinID="AddButton" OnClick="AddControlButton_Click" CausesValidation="false" EnableViewState="false"/></div>
                <asp:HiddenField ID="HiddenSelectedControls" runat="server" />
                <asp:HiddenField ID="DummyTarget" runat="server" />
                <asp:Panel ID="AddControlPopup" runat="server"  Style="display:none;width:450px" CssClass="modalPopup">
                    <asp:Panel ID="AddDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                        <asp:Localize ID="AddDialogCaption" runat="server" Text="Select from available Controls" EnableViewState="false"></asp:Localize>
                    </asp:Panel>
                    <asp:PlaceHolder ID="ControlList" runat="server" Visible="false">
                        <table>
                            <trd>
                                <td>
                                    <p><asp:Literal ID="ControlHelpText" runat="server" Text="Select from the available controls, hover mouse over the control names for a brief description." EnableViewState="false"></asp:Literal></p>
                                </td>
                            </trd>
                            <tr>
                                <td>
                                    <div style="max-height:300px;overflow:auto;">
                                        <asp:CheckBoxList ID="AvailableControls" runat="server" DataTextField="DisplayName" DataValueField="Name"/>
                                        <asp:Label ID="NoControlsMessage" runat="server" Text="No more controls are available for selection. All controls for this section are already added." SkinID="WarnCondition" Visible="false" EnableViewState="false"></asp:Label>
                                    </div>
                                </td>    
                            </tr>
                            <tr>
                                <td align="center">
                                    <asp:Button ID="AddButton" runat="server" Text="Add Controls" SkinID="SaveButton" OnClick="AddContorlButton_Click" CausesValidation="false"/>
                                    <asp:Button ID="CancelAddButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" EnableViewState="false"/>
                                </td>
                            </tr>
                        </table>
                    </asp:PlaceHolder>
                </asp:Panel>
                <ajaxToolkit:ModalPopupExtender ID="ControlSelectionPopup" runat="server" 
                    TargetControlID="DummyTarget"
                    PopupControlID="AddControlPopup" 
                    BackgroundCssClass="modalBackground"                         
                    CancelControlID="CancelAddButton" 
                    DropShadow="false"
                    PopupDragHandleControlID="AddDialogHeader" />
                <asp:HiddenField ID="DummyTarget2" runat="server" />
                <asp:Panel ID="ParamSelectionPopup" runat="server"  Style="display:none;width:650px" CssClass="modalPopup">
                    <asp:Panel ID="ParamSelectionHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                        <asp:Localize ID="ParamSelectionCaption" runat="server" Text="Select from available parameters" EnableViewState="false"></asp:Localize>
                    </asp:Panel>
                    <asp:PlaceHolder ID="ParamList" runat="server" Visible="false">
                        <table cellpadding="5" cellspacing="0">
                            <tr>
                                <td>
                                    <p>Customize the control parameters as desired. Please make sure you are going to provide a valid value for the parameter, as invalid values can break your webpages. Leave the parameter custom value empty if you want to keep using default value.</p>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:HiddenField ID="HiddenControlName" runat="server" />
                                    <div style="max-height:300px;overflow:auto;">
                                        <asp:GridView ID="ParamsGrid" runat="server" 
                                            AutoGenerateColumns="False"                                         
                                            DataKeyNames="Name"
                                            SkinID="PagedList"
                                            HeaderStyle-CssClass="fieldHeader"
                                            Width="100%">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Parameter">
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="Name" runat="server" Text='<%# Eval("Name")%>' SkinID="FieldHeader" ></asp:Label>
                                                        <br />
                                                        <asp:Label ID="Summary" runat="server" Text='<%# Eval("Summary")%>' CssClass="helpText"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField >
                                                <asp:TemplateField HeaderText="Default Value">
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="DefaultValue" runat="server" Text='<%# Eval("DefaultValue")%>' ></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Custom Value">
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="CustomValue" runat="server" Text='<%#Eval("CustomValue")%>' Columns="20" MaxLength="100"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </td>    
                            </tr>
                            <tr>
                                <td align="center">
                                    <asp:Button ID="SaveParamsButton" runat="server" Text="Update Parameters" SkinID="SaveButton" OnClick="SaveParamsButton_Click" CausesValidation="false"/>
                                    <asp:Button ID="CancelParamsButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" EnableViewState="false"/>
                                </td>
                            </tr>
                        </table>
                    </asp:PlaceHolder>
                </asp:Panel>
                <ajaxToolkit:ModalPopupExtender ID="ParamsPopup" runat="server" 
                    TargetControlID="DummyTarget2"
                    PopupControlID="ParamSelectionPopup" 
                    BackgroundCssClass="modalBackground"                         
                    CancelControlID="CancelParamsButton" 
                    DropShadow="false"
                    PopupDragHandleControlID="ParamSelectionHeader" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>

