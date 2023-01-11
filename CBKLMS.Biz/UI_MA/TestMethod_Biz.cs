using CBKLMS.Dac.UI_MA;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CBKLMS.Biz.UI_MA
{
    public class TestMethod_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 시험방법 리스트
        /// </summary>
        /// <returns></returns>
        public DataSet GetTestMethodList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (TestMethod_Dac dac = new TestMethod_Dac())
            {
                ds = dac.GetTestMethodList(dicParam);
            }
            return ds;
        }


        /// <summary>
        /// 시험방법 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveTestMethodData(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                using (TestMethod_Dac dac = new TestMethod_Dac())
                {
                    result = dac.SaveTestMethodData(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;
                }

                // Note - Commit
                scope.Complete();
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
