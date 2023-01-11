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
    public class TestDetail_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// Test List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetTestList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (TestDetail_Dac dac = new TestDetail_Dac())
            {
                ds = dac.GetTestList(dicParam);
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
            using (TestDetail_Dac dac = new TestDetail_Dac())
            {
                ds = dac.InitControls_Unit(dicParam);
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
            using (TestDetail_Dac dac = new TestDetail_Dac())
            {
                ds = dac.GetModalTestMethodList(dicParam);
            }
            return ds;
        }


        /// <summary>
        /// Test Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveTestDetail(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam
            , List<Dictionary<string, object>> listUnit
            , List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                string test_id = "";
                // 마스터 저장
                using (TestDetail_Dac dac = new TestDetail_Dac())
                {
                    result = dac.SaveTestDetail_master(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;

                    test_id = result.OV_RTN_MSG;
                }

                // Unit 저장
                for (int i = 0; i < listUnit.Count; i++)
                {
                    using (TestDetail_Dac dac = new TestDetail_Dac())
                    {
                        listUnit[i]["IV_TEST_ID"] = test_id;

                        result = dac.SaveTestDetail_Unit(ref result, listUnit[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // TestMethod 저장
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (TestDetail_Dac dac = new TestDetail_Dac())
                    {
                        listDic[i]["IV_TEST_ID"] = test_id;

                        result = dac.SaveTestDetail_Method(ref result, listDic[i]);
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


        /// <summary>
        /// Test 상세 Method
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetTestDataDtl_Method(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (TestDetail_Dac dac = new TestDetail_Dac())
            {
                ds = dac.GetTestDataDtl_Method(dicParam);
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
            using (TestDetail_Dac dac = new TestDetail_Dac())
            {
                ds = dac.GetModalUnitList(dicParam);
            }
            return ds;
        }
    }
}
