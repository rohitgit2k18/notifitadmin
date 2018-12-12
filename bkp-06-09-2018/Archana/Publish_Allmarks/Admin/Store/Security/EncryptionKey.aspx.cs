namespace AbleCommerce.Admin._Store.Security
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Configuration;
    using CommerceBuilder.Utility;

    public partial class _EncryptionKey : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AbleCommerce.Code.PageHelper.DisableValidationScrolling(this.Page);
            ChangeProgressTimer.Interval = 3000;
            if (!Page.IsPostBack)
            {
                // THIS WILL CONTINUE THE PROGRESS INDICATOR IF NEEDED
                // OTHERWISE THE CHANGE FORM WILL BE DISPLAYED
                UpdateProgress();
            }
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            // GENERATE PASSPHRASE FROM RANDOM TEXT AND TIMESTAMP
            string passPhrase;
            if (RandomText.Text != "DECRYPT") passPhrase = RandomText.Text + DateTime.Now.ToString("MM/dd/yyyy HHmmnnss");
            else passPhrase = string.Empty;
            byte[] newKey = EncryptionKeyManager.Instance.SetEncryptionKey(passPhrase);
            RandomText.Text = string.Empty;

            // A SMALL DELAY ENSURES THAT THE SCREEN WILL UPDATE WITH THE NEW KEY DATA
            System.Threading.Thread.Sleep(100);
            UpdateProgress();
        }

        private void BindKey()
        {
            EncryptionKey currentKey = EncryptionKeyManager.Instance.CurrentKey;
            if (currentKey != null)
            {
                // create date is stored in utc
                DateTime createDate = LocaleHelper.ToLocalTime(currentKey.CreateDate);
                if (createDate > DateTime.MinValue) LastSet.Text = createDate.ToShortDateString() + " " + createDate.ToShortTimeString();
                else LastSet.Text = "n/a";
            }
            ToggleBackupPanels(currentKey != null && EncryptionKeyManager.IsKeyValid(currentKey.KeyData));
        }

        private void ToggleBackupPanels(bool show)
        {
            BackupPanel.Visible = show;
            NoKeyNoBackupPanel.Visible = !show;
        }

        protected void ChangeProgressTimer_Tick(object sender, EventArgs e)
        {
            UpdateProgress();
        }

        protected void UpdateProgress()
        {
            int remaining = RecryptionHelper.GetRecryptionWorkload();
            if (remaining == 0)
            {
                EstimatedWorkload.Text = RecryptionHelper.EstimateRecryptionWorkload().ToString();
                ChangePanel.Visible = true;
                ChangeProgressPanel.Visible = false;
                if (Page.IsPostBack) KeyUpdatedMessage.Visible = true;
            }
            else
            {
                ChangePanel.Visible = false;
                ChangeProgressPanel.Visible = true;
                trRestartCancel.Visible = ((!Page.IsPostBack) || (RemainingWorkload.Text == remaining.ToString()));
                RemainingWorkload.Text = remaining.ToString();
                ProgressDate.Text = LocaleHelper.LocalNow.ToString("hh:mm:ss tt");
                //SPEED UP THE CHECK BECAUSE WE ARE ALMOST DONE!
                if (remaining < 10) ChangeProgressTimer.Interval = 1000;
            }
            BindKey();
        }

        protected void RestoreButton_Click(object sender, EventArgs e)
        {
            if (Request.Files.Count > 0)
            {
                try
                {
                    byte[] backupFile;
                    if (Request.Files[1].ContentLength > 0)
                    {
                        // COMBINE AC7 BACKUP PARTS
                        byte[] part1 = new byte[Request.Files[0].ContentLength];
                        byte[] part2 = new byte[Request.Files[1].ContentLength];
                        Request.Files[0].InputStream.Read(part1, 0, part1.Length);
                        Request.Files[1].InputStream.Read(part2, 0, part2.Length);
                        backupFile = CombineBackupParts(part1, part2);
                    }
                    else
                    {
                        // AC GOLD BACKUP KEY
                        backupFile = new byte[Request.Files[0].ContentLength];
                        Request.Files[0].InputStream.Read(backupFile, 0, backupFile.Length);
                    }

                    // RESTORE THE BACKUP KEY
                    EncryptionKeyManager.Instance.RestoreBackupKey(backupFile);
                    RestoredMessage.Visible = true;
                    RestoredMessage.Text = string.Format(RestoredMessage.Text, LocaleHelper.LocalNow);
                }
                catch (Exception ex)
                {
                    CustomValidator restoreValidator = new CustomValidator();
                    restoreValidator.IsValid = false;
                    restoreValidator.Text = "*";
                    restoreValidator.ErrorMessage = ex.Message;
                    restoreValidator.ValidationGroup = "Restore";
                    phRestoreValidators.Controls.Add(restoreValidator);
                }
            }
            BindKey();
        }

        protected void RestartChangeButton_Click(object sender, EventArgs e)
        {
            // RESTART THE RECRYPTION PROCESS
            RecryptionHelper.RecryptDatabase(Context.ApplicationInstance);
            UpdateProgress();
        }

        protected void CancelChangeButton_Click(object sender, EventArgs e)
        {
            RecryptionHelper.SetRecryptionFlag(false);
            UpdateProgress();
        }

        private byte[] CombineBackupParts(byte[] firstBackup, byte[] secondBackup)
        {
            // VALIDATE THE BACKUP PARTS
            if (!IsBackupPartValid(firstBackup) || !IsBackupPartValid(secondBackup) || firstBackup.Length != secondBackup.Length)
            {
                throw new InvalidOperationException("One of the backup parts is missing or has an invalid length.");
            }

            // VERIFY THE VERSIONS
            int firstVersion = (int)firstBackup[0];
            int secondVersion = (int)secondBackup[0];
            if (firstVersion != secondVersion)
            {
                throw new InvalidOperationException("The backup parts do not have matching versions.");
            }

            // VERIFY BOTH PARTS ARE PRESENT
            int firstPartNumber = (int)firstBackup[2];
            int secondPartNumber = (int)secondBackup[2];
            bool havePart1 = firstPartNumber == 1 || secondPartNumber == 1;
            bool havePart2 = firstPartNumber == 2 || secondPartNumber == 2;
            if (!havePart1 || !havePart2)
            {
                throw new InvalidOperationException("Both part 1 and part 2 are required restore a backup.");
            }

            // CHECK PARTS ARE IN RIGHT ORDER
            if (firstPartNumber == 2 && secondPartNumber == 1)
            {
                // SWAP ORDER OF BACKUP DATA
                byte[] temp = firstBackup;
                firstBackup = secondBackup;
                secondBackup = temp;
            }

            // GET THE RECONSTRUCTED KEY LENGTH
            int keyLength = (firstBackup.Length - 3) * 2;

            // CREATE AN ARRAY FOR THE RECONSTRUCTED KEY
            byte[] keyData = new byte[keyLength];

            // DETERMINE THE HALFWAY POINT FOR COPYING BACKUP DATA
            int halfLength = (keyLength / 2);

            // COPY IN THE KEY DATA
            System.Buffer.BlockCopy(firstBackup, 3, keyData, 0, halfLength);
            System.Buffer.BlockCopy(secondBackup, 3, keyData, halfLength, halfLength);

            // RETURN ENCRYPTION KEY
            return keyData;
        }

        private static bool IsBackupPartValid(byte[] backupData)
        {
            return backupData != null && (backupData.Length == 11 || backupData.Length == 19);
        }
    }
}