using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.UI;
using System.Text;
using System.Web.UI.WebControls.WebParts;
using System.Collections.ObjectModel;
using System.IO;
using System.Text.RegularExpressions;

namespace AbleCommerce.Admin.Website.Layouts
{
    public partial class ControlSelectionDialog : System.Web.UI.UserControl
    {
        bool _ControlSelectionPopupVisibile = false;
        bool _ParamSelectionPopupVisible = false;
        IList<ConLibControl> _AllAvailableControls = null;
        IList<ConLibControl> _SelectedControls = null;
        PageSection _PageSection = PageSection.LeftSideBar;

        #region Properties

        protected IList<ConLibControl> AllAvailableControls
        {
            get {
                if (_AllAvailableControls == null)
                {
                    switch (this.PageSection)
                    {
                        case CommerceBuilder.UI.PageSection.Header:
                            _AllAvailableControls = ConLibDataSource.LoadHeaderControls();
                            break;
                        case CommerceBuilder.UI.PageSection.Footer:
                            _AllAvailableControls = ConLibDataSource.LoadFooterControls();
                            break;
                        case CommerceBuilder.UI.PageSection.LeftSideBar:
                        case CommerceBuilder.UI.PageSection.RightSidebar:
                            _AllAvailableControls = ConLibDataSource.LoadSidebarControls();
                            break;
                    }
                }
                return _AllAvailableControls; 
            }
            set { _AllAvailableControls = value; }
        }

        /// <summary>
        /// Gets or sets the desired page section to manage control selection for.
        /// </summary>
        public PageSection PageSection 
        {
            get { return _PageSection; }
            set { _PageSection = value; }
        }

        /// <summary>
        /// Gets or sets the caption text
        /// </summary>
        public String Caption
        {
            get { return CaptionLabel.Text; }
            set { CaptionLabel.Text = value; }
        }

        /// <summary>
        /// Get the list of selected controls for internal usage
        /// </summary>
        public IList<ConLibControl> SelectedControls
        {
            get {
                if (_SelectedControls == null)
                {
                    // SELECTED CONTROLS DETAILS ARE SAVED IN HIDDEN FILED TO KEEP VIEWSTATE
                    // FORMAT: FirstControl(param1:value1;param2:value2),SecondControl,SecondControl$1(param1:value1),ThirdControl(param1:value1;param2:value2), ...
                    _SelectedControls = new List<ConLibControl>();
                    if (!string.IsNullOrEmpty(HiddenSelectedControls.Value))
                    {
                        string[] list = HiddenSelectedControls.Value.Split(',');
                        foreach (string selectedControl in list)
                        {
                            string instanceId = selectedControl;
                            string[] parameters = null;
                            ConLibControl control = null;
                            // CHECK IF ANY PARAMETERS ARE SELECTED
                            int index = selectedControl.IndexOf("(");
                            if (index > 0)
                            {
                                instanceId = selectedControl.Substring(0, index);
                                parameters = selectedControl.Substring(index + 1, selectedControl.Length - instanceId.Length - 2).Split(';');
                                control = SearchAvailableControl(instanceId, true);
                                if (control == null) continue;
                                foreach (string parameter in parameters)
                                {
                                    string[] paramDetails = parameter.Split(':');
                                    ConLibControlParam param = SearchParamByName(control.Params, paramDetails[0]);
                                    param.CustomValue = paramDetails[1];
                                }
                            }
                            else
                            {
                                control = SearchAvailableControl(instanceId, true);
                            }

                            if(control != null) _SelectedControls.Add(control);
                        }
                    }
                    else _SelectedControls.Clear();
                }

                return _SelectedControls; 
            }
        }

        #endregion

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(HiddenSelectedControls.Value)) BindSelectedControls();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // initialize the layout
                string layoutPath = Request.QueryString["name"];
                if (!string.IsNullOrEmpty(layoutPath) && File.Exists(Server.MapPath(layoutPath))) 
                {
                    string layoutContents = LayoutDataSource.LoadFileContents(layoutPath);
                    switch(this.PageSection)
                    {
                        case CommerceBuilder.UI.PageSection.Header:
                            this._SelectedControls = ParseExistingLayout(layoutContents, "PageHeader");
                            break;
                        case CommerceBuilder.UI.PageSection.LeftSideBar:
                            this._SelectedControls = ParseExistingLayout(layoutContents, "LeftSidebar");
                            break;
                        case CommerceBuilder.UI.PageSection.RightSidebar:
                            this._SelectedControls = ParseExistingLayout(layoutContents, "RightSidebar");
                            break;
                        case CommerceBuilder.UI.PageSection.Footer:
                            this._SelectedControls = ParseExistingLayout(layoutContents, "PageFooter");
                            break;
                    }
                    UpdateHiddenControlsViewState();
                }
            }
        }

        #region PreRender        

        protected void Page_PreRender(object sender, EventArgs e)
        {            
            BindSelectedControls();
            ControlList.Visible = _ControlSelectionPopupVisibile;
            ParamList.Visible = _ParamSelectionPopupVisible;
        }

        protected void BindSelectedControls()
        {
            SelectedControlsList.DataSource = SelectedControls;
            SelectedControlsList.DataBind();
        }
        #endregion

        #region Events

        protected void AddContorlButton_Click(object sender, EventArgs e)
        {
            // GET AND SAVE THE SELECTED LIST
            foreach (ListItem item in AvailableControls.Items)
            {
                if (item.Selected)
                {
                    if (!string.IsNullOrEmpty(HiddenSelectedControls.Value)) HiddenSelectedControls.Value += ",";
                    HiddenSelectedControls.Value += item.Value;
                }
            }
        }

        protected void AddControlButton_Click(object sender, EventArgs e)
        {
            // LOAD ALL AVAILABLE CONTROLS  
            IList<ConLibControl> availableControls = new List<ConLibControl>();
            IList<ConLibControl> selectedControls = this.SelectedControls;

            // FILTER ALREADY SELECTED CONTROLS
            foreach (ConLibControl control in this.AllAvailableControls)
            {
                if (!IsSelected(selectedControls, control.Name)) availableControls.Add(control);
            }

            // BIND
            _ControlSelectionPopupVisibile = true;
            AvailableControls.DataSource = availableControls;
            AvailableControls.DataBind();
            ControlSelectionPopup.Show();

            // IF NO CONTROLS AVAILABLE FOR SELECTION, DISPLAY THE MESSAGE
            NoControlsMessage.Visible = availableControls.Count == 0;
            ControlHelpText.Visible = availableControls.Count > 0;
            AddButton.Visible = availableControls.Count > 0;
        }

        protected void SaveParamsButton_Click(object sender, EventArgs e)
        {
            ConLibControl control = SearchSelectedControl(HiddenControlName.Value);
            if(control != null)
            {
                foreach (GridViewRow row in ParamsGrid.Rows)
                {
                    string paramName = string.Empty;
                    string customValue = string.Empty;
                    Label nameLabel = row.FindControl("Name") as Label;
                    if (nameLabel != null) paramName = nameLabel.Text.Trim();

                    TextBox valueTextBox = row.FindControl("CustomValue") as TextBox;
                    if (valueTextBox != null) customValue = valueTextBox.Text.Trim();

                    if (!string.IsNullOrEmpty(paramName))
                    {
                        ConLibControlParam param = SearchParamByName(control.Params, paramName);
                        param.CustomValue = customValue;
                    }
                }

                UpdateHiddenControlsViewState();
            }
        }

        protected void SelectedControls_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName.StartsWith("Do_"))
            {
                string controlInstanceId = e.CommandArgument.ToString();
                int index = controlInstanceId.IndexOf("(");
                if (index > 0) controlInstanceId = controlInstanceId.Substring(0, index);
                int numIndex = controlInstanceId.IndexOf("$");
                string controlName = controlInstanceId;
                if (numIndex > 0) controlName = controlInstanceId.Substring(0, numIndex);

                ConLibControl control = SearchSelectedControl(controlInstanceId);
                if (control != null)
                {
                    switch (e.CommandName)
                    {
                        case "Do_Edit":
                            HiddenControlName.Value = controlInstanceId;
                            ParamSelectionCaption.Text = controlInstanceId;
                            ParamsGrid.DataSource = control.Params;
                            ParamsGrid.DataBind();
                            ParamsPopup.Show();
                            _ParamSelectionPopupVisible = true;
                            break;
                        case "Do_Delete":
                            SelectedControls.Remove(control);
                            UpdateInstances(control);
                            UpdateHiddenControlsViewState();
                            break;
                        case "Do_Up":
                            int controlIndex = SelectedControls.IndexOf(control);
                            if (controlIndex > 0)
                            {
                                SelectedControls.RemoveAt(controlIndex);
                                SelectedControls.Insert(controlIndex - 1, control);
                                UpdateInstances(control);
                                UpdateHiddenControlsViewState();
                            }
                            break;
                        case "Do_Down":
                            controlIndex = SelectedControls.IndexOf(control);
                            if (controlIndex < SelectedControls.Count - 1)
                            {
                                SelectedControls.RemoveAt(controlIndex);
                                SelectedControls.Insert(controlIndex + 1, control);
                                UpdateInstances(control);
                                UpdateHiddenControlsViewState();
                            }
                            break;

                        case "Do_Copy":
                            // IDENTIFY THE CONTROL TO BE COPIED
                            string newName = controlName;
                            int count = 0;

                            // check for existing copies of this control 
                            foreach (ConLibControl selectedControl in SelectedControls)
                            {
                                if (selectedControl.Name.StartsWith(controlName)) count++;
                            }

                            // number this copy
                            if (count > 0) newName = controlName + "$" + count;
                            else newName = controlName + "$" + 1;

                            // create a duplicate control instance with new name
                            ConLibControl copy = CopyControl(control, newName, true);
                            SelectedControls.Add(copy);

                            UpdateHiddenControlsViewState();
                            break;
                    }
                }
            }
        }

        #endregion

        /// <summary>
        /// UPDATE THE HIDDEN FIELD USED TO KEEP TRACK OF SELECTION
        /// </summary>
        protected void UpdateHiddenControlsViewState()
        {
            // FORMAT: FirstControl(param1:value1;param2:value2),SecondControl,SecondControl$1(param1:value1),ThirdControl(param1:value1;param2:value2), ...
            StringBuilder controlsState = new StringBuilder();
            // GET THE EXISTING SELECTION
            foreach (ConLibControl control in SelectedControls)
            {
                if (!string.IsNullOrEmpty(controlsState.ToString())) controlsState.Append(",");
                controlsState.Append(control.InstanceId);
                StringBuilder paramState = new StringBuilder();
                foreach(ConLibControlParam param in control.Params)
                {
                    if (!string.IsNullOrEmpty(param.CustomValue))
                    {
                        if(!string.IsNullOrEmpty(paramState.ToString())) paramState.Append(";");
                        paramState.Append(param.Name + ":" + param.CustomValue);
                    }
                }

                if (!string.IsNullOrEmpty(paramState.ToString())) controlsState.Append("(" + paramState + ")");
            }

            // UPDATE HIDDEN FIELD VALUE
            HiddenSelectedControls.Value = controlsState.ToString();
        }

        

        private void UpdateInstances(ConLibControl control)
        {
            // check if there are duplicate instatnces of this control then fix the numbering
            List<ConLibControl> instances = new List<ConLibControl>();
            foreach (ConLibControl selectedControl in SelectedControls)
            {
                if (selectedControl.Name == control.Name) instances.Add(selectedControl);
            }

            if (instances.Count > 0) instances[0].InstanceId = control.Name;
            for (int i = 1; i < instances.Count; i++)
            {
                ConLibControl instance = instances[i];
                instance.InstanceId = control.Name + "$" + i;
            }
        }

        protected void SelectedControls_DataBound(object sender, EventArgs e)
        {
            if (_ControlSelectionPopupVisibile)
            {
                // ADD CONTROL DESCRIPTIONS AS TOOLTIPS FOR ITEMS
                foreach (ListItem item in AvailableControls.Items)
                {
                    ConLibControl control = SearchAvailableControl(item.Value, false);
                    if(control != null) item.Attributes["title"] = control.Summary;
                }
            }
        }

        protected bool IsSelected(IList<ConLibControl> selectedList, string controlName)
        {
            foreach (ConLibControl control in selectedList)
            {
                if (control.Name == controlName) return true;
            }

            return false;
        }

        protected ConLibControl SearchSelectedControl(string instanceId)
        {
            foreach (ConLibControl control in SelectedControls)
            {
                if (control.InstanceId == instanceId) return control;
            }

            return null;
        }


        protected ConLibControl SearchAvailableControl(string instanceId, bool createDuplicate=true)
        {
            string controlName = instanceId;
            int index = instanceId.IndexOf("$");
            if (index > 0)
            {
                controlName = instanceId.Substring(0, index);
            }

            foreach (ConLibControl control in this.AllAvailableControls)
            {
                if (control.Name == controlName)
                {
                    // return a copy of control as its a duplicate instance
                    if (index > 0 && createDuplicate) return CopyControl(control, instanceId, false);
                    else return control;
                }
            }

            return null;
        }

        /// <summary>
        /// Create a copy of some existing control instance
        /// </summary>
        /// <param name="existingControl"></param>
        /// <param name="instanceId">new instance id for newly copied control</param>
        /// <param name="copyParamValues">Indicate wheter to copy the parameter custom values</param>
        /// <returns></returns>
        protected ConLibControl CopyControl(ConLibControl existingControl, string instanceId, bool copyParamValues = false)
        {
            ConLibControl copy = new ConLibControl(existingControl.Name, existingControl.FilePath, existingControl.ClassType);
            copy.InstanceId = instanceId;
            copy.Summary = existingControl.Summary;
            copy.DisplayName = existingControl.DisplayName;

            // copy params and custom values
            copy.Params = new Collection<ConLibControlParam>();
            foreach (ConLibControlParam param in existingControl.Params)
            {
                ConLibControlParam copyParam = new ConLibControlParam(param.Name, param.DefaultValue, param.Summary);
                if(copyParamValues) copyParam.CustomValue = param.CustomValue;
                copy.Params.Add(copyParam);
            }

            return copy;
        }

        protected ConLibControlParam SearchParamByName(Collection<ConLibControlParam> allParams, string paramName)
        {
            foreach (ConLibControlParam param in allParams)
            {
                if (param.Name == paramName) return param;
            }
            return null;
        }

        protected bool IsEditIconVisible(object name)
        {
            ConLibControl control = SearchSelectedControl(name as string);
            return control.Params.Count > 0; 
        }

        protected List<ConLibControl> ParseExistingLayout(string layoutContents, string placeHolderName)
        {   
            List<ConLibControl> controls = new List<ConLibControl>();

            Match placeHolderMatch = Regex.Match(layoutContents, "<asp:ContentPlaceHolder ID=\"" + placeHolderName + "\" runat=\"server\">(.*?)</asp:ContentPlaceHolder>", RegexOptions.Singleline);
            if (placeHolderMatch.Success)
            {
                Dictionary<string, string> tagNameToControlPathDic = new Dictionary<string, string>();
                List<string> controlNames = new List<string>();

                // parse registered controls and prepare tagname to control path dictionary
                Match registerMatch = Regex.Match(layoutContents, "<%@ Register src=\"(.*?)\" tagname=\"(.*?)\" tagprefix=\"uc\" %>", RegexOptions.Singleline);
                while (registerMatch.Success)
                {
                    tagNameToControlPathDic.Add(registerMatch.Groups[2].Value, registerMatch.Groups[1].Value);
                    registerMatch = registerMatch.NextMatch();
                }


                Match controlsMatch = Regex.Match(placeHolderMatch.Groups[1].Value, "<uc:(.*?) ID=\"(.*?)\"(.*?)runat=\"server\"(.*?)/>");
                while (controlsMatch.Success)
                {
                    // TAG NAME SHOULD BE USED TO FIND THE CONTROL PATH
                    string tagName = controlsMatch.Groups[1].Value;
                    if (!tagNameToControlPathDic.Keys.Contains(tagName))
                    {
                        controlsMatch = controlsMatch.NextMatch();
                        continue; // skip non-registered controls to avoid errors
                    }

                    // determine control path and use it to identify control
                    string controlPath = tagNameToControlPathDic[tagName];
                    string controlName = controlPath.Substring(9);
                    controlName = controlName.Substring(0, controlName.Length - 5);
                    controlName = controlName.Replace("\\", "/");

                    string instanceName = controlName;
                    if (controlNames.Contains(controlName))
                    {
                        // count instanses
                        int count = 0;
                        foreach(string name in controlNames)
                        {
                            if (name == controlName) count++;
                        }
                        instanceName = controlName + "$" + count;
                    }

                    ConLibControl control = SearchAvailableControl(instanceName);
                    if (control != null)
                    {
                        string paramsPart = controlsMatch.Groups[4].Value.Trim();
                        if (!string.IsNullOrEmpty(paramsPart))
                        {
                            Match paramsMatch = Regex.Match(paramsPart, @"(\S+)=[""']?((?:.(?![""']?\s+(?:\S+)=|[>""']))+.)[""']?");
                            while (paramsMatch.Success)
                            {
                                string paramName = paramsMatch.Groups[1].Value;
                                string paramValue = paramsMatch.Groups[2].Value;
                                if (!string.IsNullOrEmpty(paramValue))
                                {
                                    if (paramValue.StartsWith("\"")) paramValue = paramValue.Substring(1);
                                    ConLibControlParam paramObject = SearchParamByName(control.Params, paramName);
                                    if (paramObject != null) paramObject.CustomValue = paramValue;
                                }
                                paramsMatch = paramsMatch.NextMatch();
                            }
                        }
                        controlNames.Add(controlName);
                        controls.Add(control);
                    }
                    controlsMatch = controlsMatch.NextMatch();
                }
            }
            return controls;
        }
    }
}