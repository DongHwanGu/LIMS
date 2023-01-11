using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_MA
{
    public class CustomerContact_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// Customer List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetCustomerContactList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_CUSTOMER_CONTACT_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
        
        /// <summary>
        /// Customer List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetCustContactDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_CUSTOMER_CONTACT_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// Customer List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetModalCustList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_CUSTOMER_CONTACT_R03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// Package Master Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveContactData_master(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_CUSTOMER_CONTACT_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }


        /// <summary>
        /// Package Master Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveContactData_cust(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_CUSTOMER_CONTACT_U02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }


    }
}
