using CBKLMS.Biz.UI_TodoList;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for TodoList_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class TodoList_Service : System.Web.Services.WebService {

    TodoList_Biz todolist_biz = new TodoList_Biz();

    public TodoList_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// 마스터 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetTotoList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = todolist_biz.GetTotoList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    
}
