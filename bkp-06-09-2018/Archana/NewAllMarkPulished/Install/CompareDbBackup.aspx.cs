using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AbleCommerce.Install
{
    public partial class CompareDbBackup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void CompareButton_Click(object sender, EventArgs e)
        {
            StringBuilder log = new StringBuilder();
            StringBuilder differences1 = new StringBuilder();
            StringBuilder differences2 = new StringBuilder();

            SortedDictionary<string, List<string>> firstDic = BreakupSQLFile(FirstBackup);
            SortedDictionary<string, List<string>> secondDic = BreakupSQLFile(SecondBackup);

            var tableKeys = firstDic.Keys;
            foreach (var key in tableKeys)
            {
                if (!secondDic.Keys.Contains(key))
                {
                    // log an error
                    log.AppendLine("2nd backup file is missing records for table " + key);
                    continue;
                }

                List<string> file1Lines = firstDic[key];
                List<string> file2Lines = secondDic[key];


                IEnumerable<String> inFirstNotInSecond = file1Lines.Except(file2Lines);
                IEnumerable<String> inSecondNotInFirst = file2Lines.Except(file1Lines);
                                
                foreach (string line in inFirstNotInSecond)
                {
                    differences1.AppendLine(line);
                    differences1.AppendLine();
                }
                    
                int count = 0;
                foreach (string line in inSecondNotInFirst)
                {
                    if (count == 0)
                    {
                        differences2.AppendLine("-- <[ac_" + key + "]>");
                        differences2.AppendLine("SET IDENTITY_INSERT [ac_" + key + "] ON;");
                        differences2.AppendLine();
                    }
                    differences2.AppendLine(line);
                    differences2.AppendLine();

                    count++;
                }

                if (count > 0)
                {
                    differences2.AppendLine("SET IDENTITY_INSERT [ac_" + key + "] OFF;");
                    differences2.AppendLine("-- </[ac_" + key + "]>");
                    differences2.AppendLine();
                }
            }

            StringBuilder differences = new StringBuilder();
            differences.AppendLine("-- UNIQUE RECORDS IN FIRST FILE");
            differences.AppendLine("----------------------");
            differences.AppendLine(differences1.ToString());

            differences.AppendLine().AppendLine();
            differences.AppendLine("-- UNIQUE RECORDS IN SECOND FILE");
            differences.AppendLine("----------------------");
            differences.AppendLine(differences2.ToString());

            results.Text = differences.ToString();
            results.Visible = true;

        }

        protected IEnumerable<string> ReadUploadedFileContents(FileUpload fu)
        {
            IList<string> lines = new List<string>();
            if (fu.HasFile)
            {
                StreamReader reader = new StreamReader(fu.FileContent);
                do
                {
                    string textLine = reader.ReadLine();

                    lines.Add(textLine);

                } while (reader.Peek() != -1);
                reader.Close();
            }

            return lines;
        }

        protected string GetUploadedFileText(FileUpload fu)
        {
            StringBuilder contents = new StringBuilder();
            if (fu.HasFile)
            {
                StreamReader reader = new StreamReader(fu.FileContent);
                do
                {
                    contents.AppendLine(reader.ReadLine());
                } while (reader.Peek() != -1);
                reader.Close();
            }

            return contents.ToString();
        }

        protected SortedDictionary<string, List<string>> BreakupSQLFile(FileUpload fu)
        {
            // create a dictionary of all matches 
            SortedDictionary<string, List<string>> tableRecords = new SortedDictionary<string, List<string>>();

            try
            {
                string fileContents = GetUploadedFileText(fu);
                Regex regexObj = new Regex(@"SET IDENTITY_INSERT \[ac_(.*?)\] ON;(.*?)SET IDENTITY_INSERT \[ac_(.*?)\] OFF;", RegexOptions.Singleline | RegexOptions.Multiline);
                var matches = regexObj.Matches(fileContents);
                foreach (Match match in matches)
                {
                    // populate the dictionary
                    tableRecords.Add(match.Groups[1].Value, FixLineBreaks(match.Groups[2].Value));
                }
            }
            catch (ArgumentException ex)
            {
                // Syntax error in the regular expression
                results.Text += "\r\n" + ex.Message;
                results.Visible = true;
            }

            return tableRecords;
        }


        protected List<string> FixLineBreaks(string input)
        {
            List<string> fixedContents = new List<string>();
            try
            {
                Regex regexObj = new Regex(@"INSERT INTO \[(.*?)\] \((.*?)\).*?VALUES \((.*?)\)", RegexOptions.Singleline | RegexOptions.Multiline);

                var matches = regexObj.Matches(input);

                // create a dictionary of all matches 
                SortedDictionary<string, string> tableRecords = new SortedDictionary<string, string>();
                foreach (Match match in matches)
                {
                    // populate the dictionary
                    string line = string.Format("INSERT INTO [{0}] ( {1} ) VALUES ( {2} )", match.Groups[1].Value, match.Groups[2].Value, match.Groups[3].Value);
                    fixedContents.Add(line);
                }
            }
            catch (ArgumentException ex)
            {
                // Syntax error in the regular expression
                results.Text += "\r\n" + ex.Message;
                results.Visible = true;
            }

            return fixedContents;
        }
    }
}