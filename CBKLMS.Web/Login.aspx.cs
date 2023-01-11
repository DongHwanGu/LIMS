using CBKLMS.Biz;
using CBKLMS.Biz.UI_CM;
using IntertekBase;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;

public partial class Login : System.Web.UI.Page
{
    Login_Biz login_biz = new Login_Biz();
    UserLogin_Biz userlogin_biz = new UserLogin_Biz();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // 같은 브라우저에서 로그아웃 하지 않고 
            // 재로그인 할 경우 : 쿠키 값 삭제
            Session.RemoveAll();
            //CookieRoaster.RemoveCookie("UserCookies");

            // 최초만 실행 사용안함.
            #region 사용자 ID 기억하기 (체크박스처리)
            HttpCookie cookies;
            cookies = CookieRoaster.GetCookie("CBKLMS_CHK_LOGIN");

            if (cookies != null)
            {
                string idCookieID;
                string idCookiePW;
                idCookieID = CookieRoaster.GetCookie("CBKLMS_CHK_LOGIN", "CBKLMS_CHK_LOGIN_ID");
                idCookiePW = CookieRoaster.GetCookie("CBKLMS_CHK_LOGIN", "CBKLMS_CHK_LOGIN_PW");
                if (idCookieID != null)
                {
                    chkID.Checked = true;
                    //txtUSER_ID.Text = idCookie;
                    txtLoginId_login.Value = idCookieID;
                    txtPassword_login.Value = idCookiePW;
                }
                else
                {
                    txtLoginId_login.Value = string.Empty;
                }
            }
            #endregion
        }

        this.Page.Title = IntertekConfig.DB_CONNECT.Equals(DB_CONNECT_ENUM.Real) ? "[ e-Works_CBK ]" : "[ e-Works_CBK Test ]";
    }

    /// <summary>
    /// 로그인 실행
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnLoginButton_Click(object sender, EventArgs e)
    {
        try
        {
            #region WebService 처리. 데이터 베이스 서버링크로 변경.
            //String callUrl = "http://localhost:49536/WebService/Common_Login_Service.asmx/GetLogDataList";
            //    String[] data = new String[2];
            //    data[0] = txtLoginId_login.Value.ToString().Trim().ToLower();         // id
            //    data[1] = txtPassword_login.Value.ToString();          // pw
             
            //    String postData = String.Format("id={0}&pw={1}", data[0], data[1]);
            
            //    HttpWebRequest httpWebRequest = (HttpWebRequest) WebRequest.Create(callUrl);
            //    // 인코딩 UTF-8
            //    byte[] sendData = UTF8Encoding.UTF8.GetBytes(postData);
            //    httpWebRequest.ContentType = "application/x-www-form-urlencoded; charset=UTF-8";
            //    httpWebRequest.Method = "POST";
            //    httpWebRequest.ContentLength = sendData.Length;
            //    Stream requestStream = httpWebRequest.GetRequestStream();
            //    requestStream.Write(sendData, 0, sendData.Length);
            //    requestStream.Close();
            //    HttpWebResponse httpWebResponse = (HttpWebResponse) httpWebRequest.GetResponse();
            //    StreamReader streamReader = new StreamReader(httpWebResponse.GetResponseStream(), Encoding.GetEncoding("UTF-8"));   
            //    string strResponseData = streamReader.ReadToEnd();

            //    // xml 파싱 
            //    XDocument doc = XDocument.Parse(strResponseData);
            //    JArray jarray = JArray.Parse(doc.Root.Value);
            //    //JObject jObject = JObject.Parse(doc.Root.Value);
            //    //JToken jUser = jObject["result"];

            //     // To convert JSON text contained in string json into an XML node
            //    streamReader.Close();
            //    httpWebResponse.Close();
            
            //    // 사용자 존재0
            //    if (jarray != null && jarray.Count > 0)
            //    {
            //        if (jarray.Count > 1)
            //        {
            //            ShowMessage.AlertMessage("사용자가 2이상 존재합니다. 관리자에게 문의해 주세요.");
            //            return;
            //        }

            //        var dr = jarray[0]; 
	        #endregion
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam.Add("IV_LOGIN_ID", txtLoginId_login.Value.ToString().Trim().ToLower());
            //dicParam.Add("IV_LOGIN_PW", txtPassword_login.Value.ToString());
            dicParam.Add("IV_LOGIN_PW", IntertekFunction.GetHashCode(txtPassword_login.Value.ToString()));

            var result = login_biz.GetLoginUser(dicParam).Tables[0];

                // 사용자 존재
                if (result != null && result.Rows.Count > 0)
                {
                    if (result.Rows.Count > 1)
                    {
                        ShowMessage.AlertMessage("사용자가 2이상 존재합니다. 관리자에게 문의해 주세요.");
                        return;
                    }

                    DataRow dr = result.Rows[0];

                #region 권한에 따른 메인화면 설정
                string userMainPage = "";
                switch (dr["ROLE_ID"].ToString())
                {
                    //case "100000": // ERP MASTER
                    //    UserInfo.USER_MAIN_URL = "/Main/ERP_Main.aspx";
                    //    break;
                    //case "100001": // IT
                    //    UserInfo.USER_MAIN_URL = "/Main/IT_Main.aspx";
                    //    break;
                    default:
                        userMainPage = "/Main/SiteMain.aspx";
                        break;
                }
                #endregion

                #region 세션 설정
                Page page = HttpContext.Current.Handler as Page;
                page.Session["CBKLMS_SESSION_USER_ID"] = dr["USER_ID"].ToString();
                #endregion

                #region 쿠키 설정
                Dictionary<string, string> UserCookies = new Dictionary<string, string>()
                    {
                        { "USER_ID", dr["USER_ID"].ToString() },
                        { "USER_NM", dr["USER_NM"].ToString() },
                        { "LOGIN_ID", dr["LOGIN_ID"].ToString() },
                        { "EMAIL", dr["EMAIL"].ToString() },
                        { "TEL", dr["TEL"].ToString() },
                        { "ENTER_DT", dr["ENTER_DT"].ToString() },
                        { "USER_GB", dr["USER_GB"].ToString() },
                        { "DEPT_CD1", dr["DEPT_CD1"].ToString() },
                        { "DEPT_CD2", dr["DEPT_CD2"].ToString() },
                        { "DEPT_CD3", dr["DEPT_CD3"].ToString() },
                        { "STATUS_CD", dr["STATUS_CD"].ToString() },
                        { "DUTY_CD", dr["DUTY_CD"].ToString() },
                        { "ROLE_ID", dr["ROLE_ID"].ToString() },
                        { "OFFICE_ID", dr["OFFICE_ID"].ToString() },
                        { "USER_ENM", dr["USER_ENM"].ToString() },
                        { "REMARK", dr["REMARK"].ToString() },
                        { "LEAVE_CNT", dr["LEAVE_CNT"].ToString() },
                        { "USER_PIC", dr["USER_PIC"].ToString() },
                        { "USER_MAIN_URL", userMainPage },
                        { "CBKLMS_ROLE_ID", dr["CBKLMS_ROLE_ID"].ToString() },
                    };
                CookieRoaster.SetCookie("CBKLMS_UserCookies", UserCookies);

                //// id, name, 권한, 기관코드, 부서코드 ...
                if (chkID.Checked)
                {
                    // 쿠키 생성
                    Dictionary<string, string> rememberIdCookies = new Dictionary<string, string>();
                    rememberIdCookies.Add("CBKLMS_CHK_LOGIN_ID", txtLoginId_login.Value);
                    rememberIdCookies.Add("CBKLMS_CHK_LOGIN_PW", txtPassword_login.Value);
                    CookieRoaster.SetCookie("CBKLMS_CHK_LOGIN", rememberIdCookies);
                }
                else
                {
                    // 쿠키 삭제
                    CookieRoaster.RemoveCookie("CBKLMS_CHK_LOGIN");
                }
                #endregion

                #region 로그인 로그 쌓기
                // 로칼 테스트 할때는 안쌓이게
                if (!Request.ServerVariables["REMOTE_ADDR"].ToString().Equals("::1"))
                {
                    Dictionary<string, object> dicLogin = new Dictionary<string, object>();
                    dicLogin.Add("IV_LOGIN_USER_ID", dr["USER_ID"].ToString());
                    dicLogin.Add("IV_LOGIN_IP", Request.ServerVariables["REMOTE_ADDR"].ToString());
                    dicLogin.Add("IV_BROWSER_TYPE", Request.Browser.Browser);
                    dicLogin.Add("IV_BROWSER_VER", Request.Browser.Version);
                    dicLogin.Add("IV_TOTAL_INFO", Request.UserAgent);

                    IntertekResult logResult = new IntertekResult();
                    logResult = userlogin_biz.SaveLoginLog(ref logResult, dicLogin);
                }
                #endregion


                Response.Redirect(CookieRoaster.GetCookie("CBKLMS_UserCookies", "USER_MAIN_URL"), false);

            }
            else
            {
                ShowMessage.AlertMessage("사용자 암호가 틀립니다.");
            }
        }
        catch (Exception ex)
        {
            ShowMessage.AlertMessage(ex.Message);
        }
        //ShowMessage.AlertMessage(txtLoginId.Value + "/" + txtPassword.Value);
    }
}