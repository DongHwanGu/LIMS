using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_CM
{
    public class CommonCode_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 마스터 코드 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetMasterCodeList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_COMMONCONDE_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(null, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 서브 리스트
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetSubCodeList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_COMMONCONDE_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 코드 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveCmcodeData(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_CM_COMMONCONDE_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }
    }
}
