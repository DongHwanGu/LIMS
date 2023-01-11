using CBKLMS.Dac.UI_CM;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CBKLMS.Biz.UI_CM
{
    public class Announcement_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 마스터 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetAnnouncement(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Announcement_Dac dac = new Announcement_Dac())
            {
                ds = dac.GetAnnouncement(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 마스터 상세 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetAnnouncementDtl(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Announcement_Dac dac = new Announcement_Dac())
            {
                ds = dac.GetAnnouncementDtl(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 결과검토 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveAnnouncement(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                string notice_id = "";
                using (Announcement_Dac dac = new Announcement_Dac())
                {
                    result = dac.SaveAnnouncement_Master(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;
                }

                notice_id = result.OV_RTN_MSG;

                for (int i = 0; i < listDic.Count; i++)
                {
                    using (Announcement_Dac dac = new Announcement_Dac())
                    {
                        listDic[i]["IV_NOTICE_ID"] = notice_id;

                        result = dac.SaveAnnouncement_Files(ref result, listDic[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }
              
                // Note - Commit
                scope.Complete();
                // 트랜젝션을 끊어준다.
                if (scope != null) scope.Dispose();
            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = ex.Message;
            }
            finally
            {
                // Note - 트렌젝션을 닫는다.
                if (scope != null) scope.Dispose();
            }

            return result;
        }
    }
}
