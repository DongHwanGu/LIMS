using CBKLMS.Biz.UI_CM;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for Holiday_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Holiday_Service : System.Web.Services.WebService {

    public Holiday_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    Holiday_Biz holiday_biz = new Holiday_Biz();

    /// <summary>
    /// 휴일 리스트 조회
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetHoliDayList()
    {
        var dt = holiday_biz.GetHoliDayList().Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    
}
