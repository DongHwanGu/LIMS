using CBKLMS.Dac;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Biz
{
    public class Login_Biz : IDisposable
    {
        public void Dispose()
        {
        }


        /// <summary>
        /// 로그인 사용자 가져오기.
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetLoginUser(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;

            using (Login_Dac dac = new Login_Dac())
            {
                ds = dac.GetLoginUser(dicParam);
            }

            return ds;
        }

    }
}
