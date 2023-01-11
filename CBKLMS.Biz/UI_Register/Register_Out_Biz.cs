using CBKLMS.Dac.UI_Register;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CBKLMS.Biz.UI_Register
{
    public class Register_Out_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 마스터 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetRegisterList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_Out_Dac dac = new Register_Out_Dac())
            {
                ds = dac.GetRegisterList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 마스터 상세 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetRegisterDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_Out_Dac dac = new Register_Out_Dac())
            {
                ds = dac.GetRegisterDetail(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// Register IN Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveRegisterFirst(ref IntertekBase.IntertekResult result
                                                    , Dictionary<string, object> dicParam
                                                    , List<Dictionary<string, object>> listFile
                                                    , List<Dictionary<string, object>> listCustomer
                                                    , List<Dictionary<string, object>> listContact
                                                    , List<Dictionary<string, object>> listReqSample
                                                    , List<Dictionary<string, object>> listReqSample_file
                                                    , List<Dictionary<string, object>> listReqTest
                                                    , List<Dictionary<string, object>> listReqSampleTest)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                string req_num = "";
                // 마스터 저장
                using (Register_Out_Dac dac = new Register_Out_Dac())
                {
                    result = dac.SaveRegisterFirst_master(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;

                    req_num = result.OV_RTN_MSG;
                }

                // 마스터 파일 저장
                for (int i = 0; i < listFile.Count; i++)
                {
                    using (Register_Out_Dac dac = new Register_Out_Dac())
                    {
                        listFile[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveRegisterFirst_file(ref result, listFile[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 고객 저장
                for (int i = 0; i < listCustomer.Count; i++)
                {
                    using (Register_Out_Dac dac = new Register_Out_Dac())
                    {
                        listCustomer[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveRegisterFirst_customer(ref result, listCustomer[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 담당자 저장
                for (int i = 0; i < listContact.Count; i++)
                {
                    using (Register_Out_Dac dac = new Register_Out_Dac())
                    {
                        listContact[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveRegisterFirst_contact(ref result, listContact[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 시료 저장
                for (int i = 0; i < listReqSample.Count; i++)
                {
                    using (Register_Out_Dac dac = new Register_Out_Dac())
                    {
                        listReqSample[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveRegisterFirst_Sample(ref result, listReqSample[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 시료 파일 저장
                for (int i = 0; i < listReqSample_file.Count; i++)
                {
                    using (Register_Out_Dac dac = new Register_Out_Dac())
                    {
                        listReqSample_file[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveRegisterFirst_Sample_file(ref result, listReqSample_file[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 시험 항목 저장
                for (int i = 0; i < listReqTest.Count; i++)
                {
                    using (Register_Out_Dac dac = new Register_Out_Dac())
                    {
                        listReqTest[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveRegisterFirst_Test(ref result, listReqTest[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 시료별 항목 저장
                for (int i = 0; i < listReqSampleTest.Count; i++)
                {
                    using (Register_Out_Dac dac = new Register_Out_Dac())
                    {
                        listReqSampleTest[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveRegisterFirst_SampleTest(ref result, listReqSampleTest[i]);
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
