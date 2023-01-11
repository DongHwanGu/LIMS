using CBKLMS.Biz.UI_MA;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for CustomerContact_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CustomerContact_Service : System.Web.Services.WebService {

    CustomerContact_Biz customercontact_biz = new CustomerContact_Biz();

    public CustomerContact_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// Customer List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetCustomerContactList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = customercontact_biz.GetCustomerContactList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }


    /// <summary>
    /// Customer List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetCustContactDetail(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = customercontact_biz.GetCustContactDetail(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    
    /// <summary>
    /// Customer List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetModalCustList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = customercontact_biz.GetModalCustList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Contact 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveContactData(object Gparam, object[] CustList)
    {
        IntertekResult result = new IntertekResult();

        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        List<Dictionary<string, object>> listDic = new List<Dictionary<string, object>>();

        try
        {
            for (int i = 0; i < CustList.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)CustList[i];
                listDic.Add(dicAdd);
            }

            result = customercontact_biz.SaveContactData(ref result, dicParam, listDic);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    
}
