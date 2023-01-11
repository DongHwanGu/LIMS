using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UI_TodoList_TodoList : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        txtreg_no.Text = Request.QueryString["reg_no"];
    }
}