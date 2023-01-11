using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_CM
{
    public class User_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 유저 리스트
        /// </summary>
        /// <returns></returns>
        public DataSet GetUserList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_USER_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(null, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// Role Setting
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet InitControls_Role(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_USER_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(null, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 유저 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveUserData(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_CM_USER_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }
    }
}
