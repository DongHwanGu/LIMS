using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;

namespace IntertekBase
{
    public class ShowMessage
    {
        #region Alert Message
        public static void AlertMessage(string message)
        {
            Page page = HttpContext.Current.Handler as Page;
            string s = "<SCRIPT language='javascript'>alert('" + message.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";

            ClientScriptManager cs = page.ClientScript;
            cs.RegisterClientScriptBlock(page.GetType(), s, s.ToString());
        }
        #endregion
    }
}
