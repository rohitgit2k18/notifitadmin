using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace FriendFitService
{
    public class mailservice
    {
        string SiteURL = ConfigurationManager.AppSettings["SiteURL"];
        public Tuple<string, bool> SendMail(string EmailPath, string Email)
        {
            try
            {

                SmtpClient smtp = new SmtpClient();
                MailMessage mail = new MailMessage();



                var lnkHref = "<html><body><a href='" + EmailPath + "'>Click</a></body></html>";

                //var lnkHref = "<a href='/ResetPassword/Account?Email="+ Email +"'>Click To Register</a>";
                string body = "Test " + lnkHref;

                AlternateView htmlView = AlternateView.CreateAlternateViewFromString(body, System.Text.Encoding.UTF8, "text/html");


                mail.To.Add(Email);
                mail.From = new MailAddress("pro.virendrakumar029@gmail.com");
                //mail.CC.Add(new MailAddress(""));


                smtp.Host = "smtp.gmail.com";
                smtp.Port = 587;
                mail.Subject = "Verification";

                mail.AlternateViews.Add(htmlView);



                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new System.Net.NetworkCredential("pro.virendrakumar029@gmail.com", "9336100753");


                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtp.Send(mail);
                return Tuple.Create<string, bool>("Mail Sent to email : " + "toemail" + "", true);

            }
            catch (Exception ex)
            {
                return Tuple.Create<string, bool>(ex.Message, true);
            }

        }

        public Tuple<string, bool> SendOTP(string otp, string Email)
        {
            try
            {

                SmtpClient smtp = new SmtpClient();
                MailMessage mail = new MailMessage();

                var lnkHref = "<html><body><p>Hi, This is One Time Password for Registering to E-learning :" + otp + "</p></body></html>";

                //var lnkHref = "<a href='/ResetPassword/Account?Email="+ Email +"'>Click To Register</a>";
                string body = "Test " + lnkHref;

                AlternateView htmlView = AlternateView.CreateAlternateViewFromString(body, System.Text.Encoding.UTF8, "text/html");


                mail.To.Add(Email);
                mail.From = new MailAddress("pro.virendrakumar029@gmail.com");
                //mail.CC.Add(new MailAddress(""));


                smtp.Host = "smtp.gmail.com";
                smtp.Port = 587;
                mail.Subject = "One Time Password : Elearning";

                mail.AlternateViews.Add(htmlView);



                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new System.Net.NetworkCredential("pro.virendrakumar029@gmail.com", "9336100753");


                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtp.Send(mail);
                return Tuple.Create<string, bool>("Mail Sent to email : " + "toemail" + "", true);

            }
            catch (Exception ex)
            {
                return Tuple.Create<string, bool>(ex.Message, true);
            }

        }
        public Tuple<string, bool> SendMailForgot(string Email)
        {
            try
            {

                SmtpClient smtp = new SmtpClient();
                MailMessage mail = new MailMessage();



                var lnkHref = "<html><body><a href="+SiteURL+"/Login/Forget?Email=" + Email + "'>Click For Reset Password</a></body></html>";

                //var lnkHref = "<a href='/ResetPassword/Account?Email="+ Email +"'>Click To Register</a>";
                string body = "For update password" + lnkHref;

                AlternateView htmlView = AlternateView.CreateAlternateViewFromString(body, System.Text.Encoding.UTF8, "text/html");


                mail.To.Add(Email);
                mail.From = new MailAddress("testifiedemail@gmail.com");
                //mail.CC.Add(new MailAddress(""));
                smtp.Host = "smtp.gmail.com";
                smtp.Port = 587;
                mail.Subject = "Verification";
                mail.AlternateViews.Add(htmlView);
                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new System.Net.NetworkCredential("testifiedemail@gmail.com", "testifiedpassword@hackfree");


                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtp.Send(mail);
                return Tuple.Create<string, bool>("Mail Sent to email : " + "toemail" + "", true);

            }
            catch (Exception ex)
            {
                return Tuple.Create<string, bool>(ex.Message, true);
            }
        }
    }
}
