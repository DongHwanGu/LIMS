using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_CM
{
    public class Holiday_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 휴일 리스트 조회
        /// </summary>
        /// <returns></returns>
        public DataSet GetHoliDayList()
        {
            DataSet ds = null;
            string sql = "USP_CM_HOLIDAY_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(null, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
    }
}
