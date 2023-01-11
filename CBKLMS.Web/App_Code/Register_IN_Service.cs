using CBKLMS.Biz.UI_Register;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for Register_IN_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Register_IN_Service : System.Web.Services.WebService {


    Register_IN_Biz register_in_biz = new Register_IN_Biz();

    public Register_IN_Service () {

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

        var dt = register_in_biz.GetRegisterList(dicParam).Tables[0];

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

        var ds = register_in_biz.GetRegisterDetail(dicParam);

        string[] tableNames = { "FILE_LIST", "CUSTOMER_LIST", "CONTACT_LIST", "SAMPLE_LIST", "SAMPLE_FILE_LIST", "TEST_LIST", "SMAPLE_TEST_LIST" };
        return JSONHelper.GetJSONString(ds, tableNames);
    }

    /// <summary>
    /// 모달 : 업체리스트
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetModalCustomerList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = register_in_biz.GetModalCustomerList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 모달 : 담당자 리스트
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetModalContactList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = register_in_biz.GetModalContactList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 모달 : 패키지 테스트 리스트
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetModalPackageTestList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = register_in_biz.GetModalPackageTestList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 모달 : 패키지 및 테스트 저장시 디테일 가져오기.
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string SaveModalPackageTestList_GetDetail(object[] Gparam)
    {
        // Package
        List<Dictionary<string, object>> listGparam = new List<Dictionary<string, object>>();
        for (int i = 0; i < Gparam.Count(); i++)
        {
            Dictionary<string, object> dicAdd = new Dictionary<string, object>();
            dicAdd = (Dictionary<string, object>)Gparam[i];
            listGparam.Add(dicAdd);
        }

        var dt = register_in_biz.SaveModalPackageTestList_GetDetail(listGparam);

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 모달 : 유저리스트
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetModalUserList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = register_in_biz.GetModalUserList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }


    /// <summary>
    /// 시험방법 금액가져오기
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string SetTestPackageGrid_MethodAmt(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = register_in_biz.SetTestPackageGrid_MethodAmt(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 환율 가져오기.
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetCurrency_Amt(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = register_in_biz.GetCurrency_Amt(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Step One
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveStepOne(object pm_req, object[] pm_req_file, object[] pm_req_customer, object[] pm_req_contact)
    {
        IntertekResult result = new IntertekResult();

        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)pm_req;

        List<Dictionary<string, object>> listFile = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listCustomer = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listContact = new List<Dictionary<string, object>>();

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

            result = register_in_biz.SaveStepOne(ref result, dicParam, listFile, listCustomer, listContact);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// Step Two
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveStepTwo(object[] pm_req_sample, object[] pm_req_sample_file, object[] pm_req_test, object[] pm_req_sample_test)
    {
        IntertekResult result = new IntertekResult();

        List<Dictionary<string, object>> listReqSample = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listReqSample_file = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listReqTest = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listReqSampleTest = new List<Dictionary<string, object>>();

        try
        {
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

            result = register_in_biz.SaveStepTwo(ref result, listReqSample, listReqSample_file, listReqTest, listReqSampleTest);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// 접수완료 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveRegisterFinish(object Gparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            result = register_in_biz.SaveRegisterFinish(ref result, dicParam);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }


    /// <summary>
    /// 사진 다시 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveSampleFileList(object Gparam, object[] arrGparam)
    {
        IntertekResult result = new IntertekResult();
        
        List<Dictionary<string, object>> listDic = new List<Dictionary<string, object>>();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            for (int i = 0; i < arrGparam.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)arrGparam[i];
                listDic.Add(dicAdd);
            }

            result = register_in_biz.SaveSampleFileList(ref result, dicParam, listDic);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

}
