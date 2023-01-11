using DataAccess;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_CM
{
    public class UserLogin_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 유저 리스트
        /// </summary>
        /// <returns></returns>
        public DataSet GetLogDataList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_USER_LOGIN_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 로그인 로그 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekResult SaveLoginLog(ref IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_CM_USER_LOGIN_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }
    }
}
