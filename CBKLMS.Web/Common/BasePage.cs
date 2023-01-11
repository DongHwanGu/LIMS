using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for BasePage
/// </summary>
public class BasePage : System.Web.UI.Page
{
	public BasePage()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    protected override void OnLoad(EventArgs e)
    {
        try
        {
            if (CkUserId.Equals("100000000"))
            {
                Session["CBKLMS_SESSION_USER_ID"] = "100000000";
            }
            // 세션 아웃
            if (Session["CBKLMS_SESSION_USER_ID"] == null)
            {
                CookieRoaster.RemoveCookie("CBKLMS_UserCookies");
                Response.Redirect("~/Login.aspx");
            }

            if (!Page.IsPostBack)
            {
            }
        }
        catch (Exception ex)
        {
            ShowMessage.AlertMessage(ex.Message);
        }

        this.Page.Title = IntertekConfig.DB_CONNECT.Equals(DB_CONNECT_ENUM.Real) ? "[ e-Works_CBK ]" : "[ e-Works_CBK Test ]";
        base.OnLoad(e);
    }

    #region 쿠키 속성
    /// <summary>
    /// 사용자 id
    /// </summary>
    public string CkUserId
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_ID") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_ID");
        }
    }
    /// <summary>
    /// 사용자 명
    /// </summary>
    public string CkUserNm
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_NM") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_NM");
        }
    }
    /// <summary>
    /// 로그인 아이디
    /// </summary>
    public string CkLoginId
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "LOGIN_ID") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "LOGIN_ID");
        }
    }
    /// <summary>
    /// 이메일
    /// </summary>
    public string CkEmail
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "EMAIL") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "EMAIL");
        }
    }
    /// <summary>
    /// 이메일
    /// </summary>
    public string CkTel
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "TEL") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "TEL");
        }
    }
    /// <summary>
    /// 입사일잔
    /// </summary>
    public string CkEnterDt
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "ENTER_DT") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "ENTER_DT");
        }
    }
    /// <summary>
    /// 유저 구분
    /// </summary>
    public string CkUserGb
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_GB") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_GB");
        }
    }
    /// <summary>
    /// 부서 1
    /// </summary>
    public string CkDeptCd1
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "DEPT_CD1") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "DEPT_CD1");
        }
    }
    /// <summary>
    /// 부서 2
    /// </summary>
    public string CkDeptCd2
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "DEPT_CD2") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "DEPT_CD2");
        }
    }
    /// <summary>
    /// 부서 3
    /// </summary>
    public string CkDeptCd3
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "DEPT_CD3") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "DEPT_CD3");
        }
    }
    /// <summary>
    /// 상태
    /// </summary>
    public string CkStatusCd
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "STATUS_CD") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "STATUS_CD");
        }
    }
    /// <summary>
    /// 직책
    /// </summary>
    public string CkDutyCd
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "DUTY_CD") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "DUTY_CD");
        }
    }
    /// <summary>
    /// 권한
    /// </summary>
    public string CkRoleId
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "ROLE_ID") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "ROLE_ID");
        }
    }
    /// <summary>
    /// 오피스 아이디
    /// </summary>
    public string CkOfficeId
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "OFFICE_ID") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "OFFICE_ID");
        }
    }
    /// <summary>
    /// 영문명
    /// </summary>
    public string CkUserEnm
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_ENM") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_ENM");
        }
    }
    /// <summary>
    /// 비고
    /// </summary>
    public string CkRemark
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "REMARK") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "REMARK");
        }
    }
    /// <summary>
    /// 휴가일수
    /// </summary>
    public string CkLeaveCnt
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "LEAVE_CNT") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "LEAVE_CNT");
        }
    }
    /// <summary>
    /// 사진
    /// </summary>
    public string CkUserPic
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_PIC") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_PIC");
        }
    }
    /// <summary>
    /// 유저 화면
    /// </summary>
    public string CkUserMainUrl
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_MAIN_URL") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_MAIN_URL");
        }
    }
    /// <summary>
    /// CBKLMS Role
    /// </summary>
    public string CkCBKLMSRoleId
    {
        get
        {
            return CookieRoaster.GetCookie("CBKLMS_UserCookies", "CBKLMS_ROLE_ID") == "" ? ""
                : CookieRoaster.GetCookie("CBKLMS_UserCookies", "CBKLMS_ROLE_ID");
        }
    }
    
    #endregion
}