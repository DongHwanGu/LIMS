using CBKLMS.Biz.UI_CM;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SiteMaster : MasterPage
{
    Role_Program_Biz role_program_biz = new Role_Program_Biz();

    private const string AntiXsrfTokenKey = "__AntiXsrfToken";
    private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
    private string _antiXsrfTokenValue;
    public string MasterPageName { get; set; }

    protected void Page_Init(object sender, EventArgs e)
    {
        // The code below helps to protect against XSRF attacks
        var requestCookie = Request.Cookies[AntiXsrfTokenKey];
        Guid requestCookieGuidValue;
        if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
        {
            // Use the Anti-XSRF token from the cookie
            _antiXsrfTokenValue = requestCookie.Value;
            Page.ViewStateUserKey = _antiXsrfTokenValue;
        }
        else
        {
            // Generate a new Anti-XSRF token and save to the cookie
            _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
            Page.ViewStateUserKey = _antiXsrfTokenValue;

            var responseCookie = new HttpCookie(AntiXsrfTokenKey)
            {
                HttpOnly = true,
                Value = _antiXsrfTokenValue
            };
            if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
            {
                responseCookie.Secure = true;
            }
            Response.Cookies.Set(responseCookie);
        }

        Page.PreLoad += master_Page_PreLoad;
    }

    protected void master_Page_PreLoad(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Set Anti-XSRF token
            ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
            ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
        }
        else
        {
            // Validate the Anti-XSRF token
            if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
            {
                throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
            }
        }
    }

    protected void Unnamed_LoggingOut(object sender, LoginCancelEventArgs e)
    {
        Context.GetOwinContext().Authentication.SignOut();
    }

    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        // 페이지 로드
        if (!Page.IsPostBack)
        {
            // 운영 서버가 아니면.
            if (!IntertekConfig.DB_CONNECT.Equals(DB_CONNECT_ENUM.Real))
            {
                lblDataBase.Text = " T";
            }
            else
            {
                lblDataBase.Text = "";
            }
            /// 파일명 추출 및 권한이 있는지 판단
            SetPageName();
        }

    }

    /// <summary>
    /// 파일명 추출 및 권한이 있는지 판단
    /// </summary>
    private void SetPageName()
    {
        string pageName = this.Request.Url.ToString();

        if (pageName.IndexOf("SiteMain") == -1
            && pageName.IndexOf("CM_UserProfile") == -1)
        {
            // 파일명 추출
            pageName = pageName.Substring(pageName.LastIndexOf('/') + 1);
            MasterPageName = pageName.Split('?')[0];

            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam.Add("IV_ROLE_ID", CookieRoaster.GetCookie("CBKLMS_UserCookies", "CBKLMS_ROLE_ID"));

            var dt = role_program_biz.GetRoleProgramList(dicParam).Tables[0];

            bool roleConf = false;
            // 해당 페이지가 권한이 되는지를 판단.
            if (dt != null && dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (dt.Rows[i]["PROGRAM_VIEW"].ToString().IndexOf(MasterPageName) > -1)
                    {
                        roleConf = true;
                    }
                }

                if (roleConf == false)
                {
                    Response.Redirect("~/Login.aspx");
                }
            }
            else
            {
                Response.Redirect("~/Login.aspx");
            }

        }
    } 
}