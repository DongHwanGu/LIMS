using IntertekBase;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Printing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Management;
using IntertekBase.GDH_Print;
using GenCode128;
using System.Runtime.InteropServices;
using Microsoft.Win32.SafeHandles;
using System.Drawing.Imaging;
using System.Data;
using Microsoft.Reporting.WebForms;


public partial class UI_Register_Register_IN : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            
        }
        
    }

    protected void btnGenrate_Click(object sender, EventArgs e)
    {
        try
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseWindow", "PrintContent()", true);
        }
        catch (Exception ex)
        {
            throw;
        }

    }

}