using CBKLMS.Biz.UI_CM;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for UserLogin_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class UserLogin_Service : System.Web.Services.WebService {

    UserLogin_Biz userlogin_biz = new UserLogin_Biz();

    public UserLogin_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// 로그인 리스트
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetLogDataList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = userlogin_biz.GetLogDataList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    
}
