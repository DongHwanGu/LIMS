using CBKLMS.Dac;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Biz
{
    public class SiteMaster_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 프로그램 리스트 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetMainMenuList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;

            using (SiteMaster_Dac dac = new SiteMaster_Dac())
            {
                ds = dac.GetMainMenuList(dicParam);
            }

            return ds;
        }

        #region 페이지명 가져오기
        /// <summary>
        /// 페이지명 가져오기
        /// </summary>
        /// <param name="cd_major"></param>
        /// <param name="cd_level"></param>
        /// <returns></returns>
        public DataSet fn_SetProgramLink(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;

            using (SiteMaster_Dac dac = new SiteMaster_Dac())
            {
                ds = dac.fn_SetProgramLink(dicParam);
            }

            return ds;
        }
        #endregion

        /// <summary>
        /// 메인 페이지 데이터
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetMainPageData(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;

            using (SiteMaster_Dac dac = new SiteMaster_Dac())
            {
                ds = dac.GetMainPageData(dicParam);
            }

            return ds;
        }
    }
}
