namespace AbleCommerce.Admin.Dashboard
{
    using System;
    using System.IO;
    using System.Reflection;
    using System.Text;
    using CommerceBuilder.Common;
    using CommerceBuilder.Types;
    using CommerceBuilder.Utility;

    public partial class HelpAbout : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Version version = AbleContext.Current.Version;
            string releaseLabel = AbleContext.Current.ReleaseLabel;
            Caption.Text = string.Format(Caption.Text, releaseLabel + " (build " + version.Revision.ToString() + ")");

            // BUILD DICTIONARY OF DLLS
            SortableCollection<FileVersionInfo> fileVersions = new SortableCollection<FileVersionInfo>();
            string binPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "bin");
            DirectoryInfo di = new DirectoryInfo(binPath);
            FileInfo[] files = di.GetFiles("*.dll");
            foreach (FileInfo file in files)
            {
                try
                {
                    Assembly a = Assembly.LoadFile(file.FullName);
                    fileVersions.Add(new FileVersionInfo(a.GetName().Name, a.GetName().Version.ToString()));
                }
                catch { }
            }
            fileVersions.Sort("Name");

            // LIST BUILD NUMBERS
            StringBuilder sb = new StringBuilder();
            sb.Append("AbleCommerce for ASP.NET\r\n");
            sb.Append("VERSION: " + version.ToString() + "\r\n");
            sb.Append("Release Label: " + releaseLabel + "\r\n");

            // ADD DATABASE INFORMATION
            IDatabaseFactory databaseFactory = AbleContext.Current.DatabaseFactory;
            string databaseDialect = databaseFactory.Configuration.GetProperty("dialect");
            sb.Append("DATABASE: " + databaseDialect + "\r\n");
            sb.Append(".NET CLR v" + System.Environment.Version.ToString() + "\r\n");
            sb.Append("ASP.NET TRUST: " + HttpContextHelper.AspNetTrustLevel.ToString() + "\r\n\r\n");

            // APPEND DLL VERSIONS
            foreach (FileVersionInfo f in fileVersions)
            {
                sb.Append(f.Name + ": " + f.Version + "\r\n");
            }
            DllVersions.Text = sb.ToString();
        }

        public class FileVersionInfo : IComparable
        {
            public string Name { get; private set; }
            public string Version { get; private set; }
            public FileVersionInfo(string name, string version)
            {
                this.Name = name;
                this.Version = version;
            }
            public int CompareTo(object obj)
            {
                return this.Name.CompareTo(((FileVersionInfo)obj).Name);
            }
        }
    }
}