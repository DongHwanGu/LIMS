using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac
{
    public class Login_Dac : IDisposable
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
            string sql = "USP_CM_LOGIN_SELECT";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }

            return ds;
        }
    }
}
