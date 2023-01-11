using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_MA
{
    public class TestMethod_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 유닛 리스트
        /// </summary>
        /// <returns></returns>
        public DataSet GetTestMethodList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_TEST_METHOD_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 유닛 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveTestMethodData(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_TEST_METHOD_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }
    }
}
