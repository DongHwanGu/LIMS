using CBKLMS.Dac.UI_TotoList;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Biz.UI_TodoList
{
    public class TodoList_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 마스터 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetTotoList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (TodoList_Dac dac = new TodoList_Dac())
            {
                ds = dac.GetTotoList(dicParam);
            }
            return ds;
        }

    }
}
