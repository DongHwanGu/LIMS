using CBKLMS.Biz.UI_Register;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for Register_Out_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Register_Out_Service : System.Web.Services.WebService {

    Register_Out_Biz register_out_biz = new Register_Out_Biz();


    public Register_Out_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// 마스터 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetRegisterList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = register_out_biz.GetRegisterList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 마스터 상세 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetRegisterDetail(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var ds = register_out_biz.GetRegisterDetail(dicParam);

        string[] tableNames = { "FILE_LIST", "CUSTOMER_LIST", "CONTACT_LIST", "SAMPLE_LIST", "SAMPLE_FILE_LIST", "TEST_LIST", "SMAPLE_TEST_LIST" };
        return JSONHelper.GetJSONString(ds, tableNames);
    }

    /// <summary>
    /// 가접수 진행
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveRegisterFirst(object pm_req, object[] pm_req_file, object[] pm_req_customer, object[] pm_req_contact,
                                            object[] pm_req_sample, object[] pm_req_sample_file, object[] pm_req_test, object[] pm_req_sample_test
                                            )
    {
        IntertekResult result = new IntertekResult();

        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)pm_req;

        List<Dictionary<string, object>> listFile = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listCustomer = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listContact = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listReqSample = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listReqSample_file = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listReqTest = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listReqSampleTest = new List<Dictionary<string, object>>();

        try
        {
            for (int i = 0; i < pm_req_file.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)pm_req_file[i];
                listFile.Add(dicAdd);
            }

            for (int i = 0; i < pm_req_customer.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)pm_req_customer[i];
                listCustomer.Add(dicAdd);
            }

            for (int i = 0; i < pm_req_contact.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)pm_req_contact[i];
                listContact.Add(dicAdd);
            }

            for (int i = 0; i < pm_req_sample.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)pm_req_sample[i];
                listReqSample.Add(dicAdd);
            }

            for (int i = 0; i < pm_req_sample_file.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)pm_req_sample_file[i];
                listReqSample_file.Add(dicAdd);
            }

            for (int i = 0; i < pm_req_test.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)pm_req_test[i];
                listReqTest.Add(dicAdd);
            }

            for (int i = 0; i < pm_req_sample_test.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)pm_req_sample_test[i];
                listReqSampleTest.Add(dicAdd);
            }

            result = register_out_biz.SaveRegisterFirst(ref result, dicParam, listFile, listCustomer, listContact,
                                                                    listReqSample, listReqSample_file, listReqTest, listReqSampleTest
                );
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }
}
