using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_MA
{
    public class TestDetail_Dac : IDisposable
    {
        public void Dispose()
        {
        }


        /// <summary>
        /// Test List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetTestList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_TEST_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// Test Unit
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet InitControls_Unit(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_TEST_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// Test Method Modal
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalTestMethodList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_TEST_R03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// Test Save Master
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveTestDetail_master(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_TEST_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }


        /// <summary>
        /// Test Save Method
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dictionary"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveTestDetail_Method(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_TEST_U02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// Test Save Unit
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dictionary"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveTestDetail_Unit(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_TEST_U03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }


        /// <summary>
        /// Test 상세 Method
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetTestDataDtl_Method(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_TEST_R04";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// Unit Modal
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalUnitList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_TEST_R05";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
    }
}
