using CBKLMS.Dac.UI_CM;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Biz.UI_CM
{
    public class Holiday_Biz : IDisposable
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
            using (Holiday_Dac dac = new Holiday_Dac())
            {
                ds = dac.GetHoliDayList();
            }
            return ds;
        }
    }
}
