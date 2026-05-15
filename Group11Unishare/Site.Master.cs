using System;
using System.Web;
using System.Web.UI;

namespace Group11Unishare
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear all user sessions
            Session.Clear();
            Session.Abandon();

            // Clear authentication cookies
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            // Redirect back to login
            Response.Redirect("Login.aspx");
        }
    }
}