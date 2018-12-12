namespace AbleCommerce.Code
{
    using System.Collections;
    using System.Collections.Generic;
    using System.IO;
    using System.Text;
    using System.Web.Hosting;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.UI;

    /// <summary>
    /// Utility class for layout management.
    /// </summary>
    public class LayoutHelper
    {
        private const string REGISTER_CONTROL_PATTERN = "<%@ Register src=\"{0}\" tagname=\"{1}\" tagprefix=\"uc\" %>";
        private const string CONTROL_TAG_PATTERN = "<uc:{0} ID=\"{1}\" runat=\"server\"{2} />";

        /// <summary>
        /// Creates and saves a new layout master page.
        /// </summary>
        /// <param name="layoutPath">Path to save the layout file.</param>
        /// <param name="description">Description about the layout.</param>
        /// <param name="headerControls">List of controls to be added to the header.</param>
        /// <param name="leftControls">List of controls to be added to left sidebar</param>
        /// <param name="rightControls">List of constrols to be added to right sidebar</param>
        /// <param name="footerControls">List of controls to be added to the footer.</param>
        public static void CreateAndSave(string layoutPath, string description, IList<ConLibControl> headerControls, IList<ConLibControl> leftControls, IList<ConLibControl> rightControls, IList<ConLibControl> footerControls)
        {
            List<RegisteredControl> registeredControls = new List<RegisteredControl>();
            StringBuilder headerZoneOutput = new StringBuilder();
            StringBuilder leftSidebarControls = new StringBuilder();
            StringBuilder rightSidebarControls = new StringBuilder();
            StringBuilder footerZoneOutput = new StringBuilder();

            if (headerControls != null && headerControls.Count > 0)
            {
                foreach (ConLibControl control in headerControls)
                {
                    // REGISTER CONTROL AND ADD TAG TO HEADER
                    headerZoneOutput.AppendLine("                        " + GenerateControlTag(control, PageSection.Header, registeredControls));
                }
            }
                        
            if (rightControls != null && rightControls.Count > 0)
            {                
                foreach (ConLibControl control in rightControls)
                {
                    // REGISTER CONTROL AND ADD TAG TO SIDEBAR
                    rightSidebarControls.AppendLine("                " + GenerateControlTag(control, PageSection.RightSidebar, registeredControls));
                }
            }
                        
            if (leftControls != null && leftControls.Count > 0)
            {                
                foreach (ConLibControl control in leftControls)
                {
                    // REGISTER CONTROL AND ADD TAG TO SIDEBAR
                    leftSidebarControls.AppendLine("                " + GenerateControlTag(control, PageSection.LeftSideBar, registeredControls));
                }
            }

            if (footerControls != null && footerControls.Count > 0)
            {
                foreach (ConLibControl control in footerControls)
                {
                    // REGISTER CONTROL AND ADD TAG TO HEADER
                    footerZoneOutput.AppendLine("                        " + GenerateControlTag(control, PageSection.Footer, registeredControls));
                }
            }

            // LOAD THE LAYOUT TEMPLATE FILE CONTENTS
            string templateContents = File.ReadAllText(HostingEnvironment.MapPath("~/Layouts/Templates/Default.html"));
            StringBuilder registrationOutput = new StringBuilder();
            foreach (RegisteredControl registeredControl in registeredControls)
            {
                registrationOutput.AppendLine(registeredControl.RegisterationTag);
            }
            
            // CREATE A LIST OF PARAMETERS
            Hashtable parameters = new Hashtable();
            parameters.Add("name", Path.GetFileNameWithoutExtension(layoutPath));
            parameters.Add("description", description);
            parameters.Add("registeredControls", registrationOutput.ToString().Trim());
            parameters.Add("headerControls", headerZoneOutput.ToString().Trim());
            parameters.Add("leftControls", leftSidebarControls.ToString().Trim());
            parameters.Add("rightControls", rightSidebarControls.ToString().Trim());
            parameters.Add("footerControls", footerZoneOutput.ToString().Trim());
            
            // PROCESS THE TEMPLATE USING NEVELOCITY ENGINE
            NVelocityEngine velocityEngine = NVelocityEngine.Instance;
            string layoutContents = velocityEngine.Process(parameters, templateContents);

            // SAVE
            File.WriteAllText(layoutPath, layoutContents);
        }

        /// <summary>
        /// Register the ConLib control and generate the Tag output for specified section
        /// </summary>
        /// <param name="control">The ConLib control</param>
        /// <param name="pageSection">The page section</param>
        /// <param name="registeredControls">Already registered controls</param>
        /// <returns>Generated tag output as string</returns>
        private static string GenerateControlTag(ConLibControl control, PageSection pageSection, List<RegisteredControl> registeredControls)
        {
            string tagName = RegisterControl(control, registeredControls);
            string controlId = tagName;

            // if there are multiple instances of same control, generate the control id using number
            if (control.InstanceId.Contains("$"))
            {
                controlId = tagName + "_" + control.InstanceId.Split('$')[1];
            }

            switch (pageSection)
            {
                case PageSection.Header: controlId += "_H";
                    break;
                case PageSection.LeftSideBar: controlId += "_Left";
                    break;
                case PageSection.RightSidebar: controlId += "_Right";
                    break;
                case PageSection.Footer: controlId += "_F";
                    break;
            }

            // CHECK IF ANY PARAMETERS SPECIFIED
            string parameterString = string.Empty;
            foreach (ConLibControlParam param in control.Params)
            {
                if (!string.IsNullOrEmpty(param.CustomValue)) parameterString += string.Format(" {0}=\"{1}\"", param.Name, param.CustomValue);
            }

            return string.Format(CONTROL_TAG_PATTERN, tagName, controlId, parameterString);
        }

        /// <summary>
        /// Generates the register control tag and returns a unique tag name
        /// </summary>
        /// <param name="control">control  to register</param>
        /// <param name="registeredControls">List of existing registered controls</param>
        /// <returns>Unique tagname for this control with which it is registered</returns>
        private static string RegisterControl(ConLibControl control, List<RegisteredControl> registeredControls)
        {
            // check if its already registered, then return existing tagname
            foreach(RegisteredControl registeredControl in registeredControls)
            {
                if(registeredControl.Control.FilePath == control.FilePath) return registeredControl.TagName;
            }

            // otherwise generate tagname and look if tagname is already registered
            string tagName = control.Name;
            if (tagName.Contains("/"))
            {
                tagName = tagName.Substring(tagName.LastIndexOf("/") + 1);
            }

            int postfix = 0;
            bool tagnameIsUnique = false;
            List<string> tagNames = new List<string>();
            string testTagname = tagName;
            foreach(RegisteredControl registeredControl in registeredControls) tagNames.Add(registeredControl.TagName);
            while (!tagnameIsUnique)
            {
                tagnameIsUnique = true;
                tagnameIsUnique = !tagNames.Contains(testTagname);

                // if registered append a suffix number and look again until we find a unique name
                postfix++;
                if (!tagnameIsUnique) testTagname = tagName + postfix.ToString();
            }

            tagName = testTagname;            

            // register the control 
            string registrationTag = string.Format(REGISTER_CONTROL_PATTERN, "~/ConLib/" + control.Name + ".ascx", tagName);
            registeredControls.Add(new RegisteredControl(control, tagName, registrationTag));

            // retrun the tagname
            return tagName;
        }

        /// <summary>
        /// A utility class to hold information about a registered control
        /// </summary>
        private class RegisteredControl 
        {
            public RegisteredControl(ConLibControl control, string tagName, string registrationTag ) 
            {
                this.Control = control;
                this.TagName = tagName;
                this.RegisterationTag = registrationTag;
            }

            public ConLibControl Control { get; set; }
            public string TagName { get; set; }
            public string RegisterationTag { get; set; }
        }
    }
}