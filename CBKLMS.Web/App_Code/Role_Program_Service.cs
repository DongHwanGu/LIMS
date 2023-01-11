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
/// Summary description for Role_Program_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Role_Program_Service : System.Web.Services.WebService {

    public Role_Program_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    Role_Program_Biz role_program_biz = new Role_Program_Biz();

    /// <summary>
    /// 권한 조회
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GerRoleList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = role_program_biz.GerRoleList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 권한 조회
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetRoleProgramList(object Gparam)
    {
        DataTable dt = new DataTable();

        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        DataTable programDt = role_program_biz.GetRoleProgramList(dicParam).Tables[0];
        if (programDt != null && programDt.Rows.Count > 0)
        {
            dt = IntertekFunction.ProgramListSort(programDt);
        }

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 권한 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveRoleData(object roleData)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)roleData;

            result = role_program_biz.SaveRoleData(ref result, dicParam);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// Modal Program 조회
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetModalProgramList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = role_program_biz.GetModalProgramList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 권한에 따른 프로그램 리스트 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveModalProgramList(object[] programDatas)
    {
        IntertekResult result = new IntertekResult();
        List<Dictionary<string, object>> listDic = new List<Dictionary<string, object>>();

        try
        {
            for (int i = 0; i < programDatas.Count(); i++)
            {
                listDic.Add((Dictionary<string, object>)programDatas[i]);
            }

            result = role_program_biz.SaveModalProgramList(ref result, listDic);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }


    /// <summary>
    /// 권한에 따른 프로그램 리스트 삭제
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult DeleteModalProgramList(object[] programDatas)
    {
        IntertekResult result = new IntertekResult();
        List<Dictionary<string, object>> listDic = new List<Dictionary<string, object>>();

        try
        {
            for (int i = 0; i < programDatas.Count(); i++)
            {
                listDic.Add((Dictionary<string, object>)programDatas[i]);
            }

            result = role_program_biz.DeleteModalProgramList(ref result, listDic);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }
}
