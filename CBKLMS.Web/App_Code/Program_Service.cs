using CBKLMS.Biz.UI_CM;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for Program_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Program_Service : System.Web.Services.WebService {

    Program_Biz program_biz = new Program_Biz();

    public Program_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// 프로그램 리스트
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetProgramList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        DataTable dt = new DataTable();

        DataTable programDt = program_biz.GetProgramList(dicParam).Tables[0];

        if (programDt != null && programDt.Rows.Count > 0)
        {
            dt = IntertekFunction.ProgramListSort(programDt);
        }

        return JSONHelper.GetJSONString(dt, "result");
    }


    /// <summary>
    /// 프로그램 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveProgramData(object Gparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            result = program_biz.SaveProgramData(ref result, dicParam);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// 프로그램 리스트
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string InitControls_UpProgram(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = program_biz.InitControls_UpProgram(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

}
