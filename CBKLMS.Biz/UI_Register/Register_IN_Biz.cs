using CBKLMS.Dac;
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
    public class Register_IN_Biz : IDisposable
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
            using (Register_IN_Dac dac = new Register_IN_Dac())
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
            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                ds = dac.GetRegisterDetail(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 모달 : 업체리스트
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalCustomerList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                ds = dac.GetModalCustomerList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 모달 : 담당자 리스트
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalContactList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                ds = dac.GetModalContactList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 모달 : 패키지 테스트 리스트
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalPackageTestList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                ds = dac.GetModalPackageTestList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 모달 : 패키지 및 테스트 저장시 디테일 가져오기.
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataTable SaveModalPackageTestList_GetDetail(List<Dictionary<string, object>> listGparam)
        {
            DataSet ds = null;
            DataTable dt = null;

            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                Dictionary<string, object> dicParam = new Dictionary<string, object>();
                dicParam.Add("IV_TEST_PACKAGE_ID", 0);
                dicParam.Add("IV_TEST_PACKAGE_TYPE", "Package");
                dicParam.Add("IV_CUST_ID", 0);
                dicParam.Add("IV_UNIT_ID", 0);
                dicParam.Add("IV_METHOD_ID", 0);
                dicParam.Add("IV_USER_ID", "");

                ds = dac.SaveModalPackageTestList_GetDetail(dicParam);

                for (int i = 0; i < listGparam.Count; i++)
			    {
			        dt = dac.SaveModalPackageTestList_GetDetail(listGparam[i]).Tables[0];

                    foreach (DataRow dr in dt.Rows)
                    {
                        //dr["id"] = ds.Tables[0].Rows.Count + 1;
                        ds.Tables[0].ImportRow(dr);
                    }
			    }
            }

            DataView dv = ds.Tables[0].DefaultView;
            dv.Sort = "SORT_GB asc, TEST_PACKAGE_TYPE desc, PACKAGE_NM asc, TEST_NM asc";
            
            return dv.ToTable();
        }

        /// <summary>
        /// 모달 : 유저 리스트
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalUserList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                ds = dac.GetModalUserList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 모달 : 시험방법 금액 가져오기.
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet SetTestPackageGrid_MethodAmt(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                ds = dac.SetTestPackageGrid_MethodAmt(dicParam);
            }
            return ds;
        }


        /// <summary>
        /// 환율 가져오기
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetCurrency_Amt(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                ds = dac.GetCurrency_Amt(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 샘플 바코드 가져오기
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet SetRegister_IN_Sample_Barcode(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                ds = dac.SetRegister_IN_Sample_Barcode(dicParam);
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
        public IntertekBase.IntertekResult SaveStepOne(ref IntertekBase.IntertekResult result
                                                    , Dictionary<string, object> dicParam
                                                    , List<Dictionary<string, object>> listFile
                                                    , List<Dictionary<string, object>> listCustomer
                                                    , List<Dictionary<string, object>> listContact)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                string req_num = "";
                // 마스터 저장
                using (Register_IN_Dac dac = new Register_IN_Dac())
                {
                    result = dac.SaveStepOne_master(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;

                    req_num = result.OV_RTN_MSG;
                }

                // 마스터 파일 저장
                for (int i = 0; i < listFile.Count; i++)
                {
                    using (Register_IN_Dac dac = new Register_IN_Dac())
                    {
                        listFile[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveStepOne_file(ref result, listFile[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 고객 저장
                for (int i = 0; i < listCustomer.Count; i++)
                {
                    using (Register_IN_Dac dac = new Register_IN_Dac())
                    {
                        listCustomer[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveStepOne_customer(ref result, listCustomer[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 담당자 저장
                for (int i = 0; i < listContact.Count; i++)
                {
                    using (Register_IN_Dac dac = new Register_IN_Dac())
                    {
                        listContact[i]["IV_REQ_NUM"] = req_num;

                        result = dac.SaveStepOne_contact(ref result, listContact[i]);
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
        /// Register IN Save 2
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepTwo(ref IntertekBase.IntertekResult result
                                                    , List<Dictionary<string, object>> listReqSample
                                                    , List<Dictionary<string, object>> listReqSample_file
                                                    , List<Dictionary<string, object>> listReqTest
                                                    , List<Dictionary<string, object>> listReqSampleTest)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                // 삭제 후 저장
                using (Register_IN_Dac dac = new Register_IN_Dac())
                {
                    Dictionary<string, object> dicParam = new Dictionary<string, object>();
                    dicParam.Add("IV_REQ_NUM", listReqSample[0]["IV_REQ_NUM"]);
                    result = dac.SaveStepTwo_Delete(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;
                }

                // 시료 저장
                for (int i = 0; i < listReqSample.Count; i++)
                {
                    using (Register_IN_Dac dac = new Register_IN_Dac())
                    {
                        result = dac.SaveStepTwo_Sample(ref result, listReqSample[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 시료 파일 저장
                for (int i = 0; i < listReqSample_file.Count; i++)
                {
                    using (Register_IN_Dac dac = new Register_IN_Dac())
                    {
                        result = dac.SaveStepTwo_file(ref result, listReqSample_file[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 시험 항목 저장
                for (int i = 0; i < listReqTest.Count; i++)
                {
                    using (Register_IN_Dac dac = new Register_IN_Dac())
                    {
                        result = dac.SaveStepTwo_Test(ref result, listReqTest[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // 시료별 항목 저장
                for (int i = 0; i < listReqSampleTest.Count; i++)
                {
                    using (Register_IN_Dac dac = new Register_IN_Dac())
                    {
                        result = dac.SaveStepTwo_SampleTest(ref result, listReqSampleTest[i]);
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
        /// 증명서 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekResult SaveRegisterFinish(ref IntertekResult result, Dictionary<string, object> dicParam)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                using (Register_IN_Dac dac = new Register_IN_Dac())
                {
                    result = dac.SaveRegisterFinish_Set(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;
                }

                // Note - Commit
                scope.Complete();
                // 트랜젝션을 끊어준다.
                if (scope != null) scope.Dispose();

                // 메일전송이 있을경우.
                if (dicParam["IV_BTN_GB"].ToString().Equals("준비중."))
                {
                    #region 메일 전송
                    // 메일 전송 진행
                    using (Register_IN_Dac dac = new Register_IN_Dac())
                    {
                        var mailDt = dac.SaveRegisterFinish_Get(dicParam).Tables[0];

                        for (int i = 0; i < mailDt.Rows.Count; i++)
                        {
                            // 메일 보내기 / 로그
                            DataRow dr = mailDt.Rows[i];
                            string mail_subject = MailReplace(dr["MAIL_SUBJECT"].ToString(), dr, "");
                            string mail_body = MailReplace(dr["MAIL_BODY"].ToString(), dr, "");

                            var mailResult = IntertekFunction.SendMail(dr["SEND_MAIL"].ToString()
                                                                     , dr["RECEIVE_MAIL"].ToString()
                                                                     , ""
                                                                     , ""
                                                                     , mail_subject
                                                                     , mail_body
                                                                     , "");
                            // 메일 로그 남기기 
                            using (Common_Dac comdac = new Common_Dac())
                            {
                                Dictionary<string, object> mailDic = new Dictionary<string, object>();
                                mailDic.Add("IV_MAIL_GB", "01");
                                mailDic.Add("IV_MAIL_CD", "A1");
                                mailDic.Add("IV_SEND_USER_ID", dr["SEND_USER_ID"].ToString());
                                mailDic.Add("IV_SEND_NM", dr["SEND_USER_NM"].ToString());
                                mailDic.Add("IV_SEND_EMAIL", dr["SEND_MAIL"].ToString());
                                mailDic.Add("IV_RECEIVE_USER_ID", dr["RECEIVE_USER_ID"].ToString());
                                mailDic.Add("IV_RECEIVE_NM", dr["RECEIVE_USER_NM"].ToString());
                                mailDic.Add("IV_RECEIVE_EMAIL", dr["RECEIVE_MAIL"].ToString());
                                mailDic.Add("IV_TITLE", mail_subject);
                                mailDic.Add("IV_CONTENTS", mail_body);
                                mailDic.Add("IV_MAIL_KEYS", dicParam["IV_REQ_NUM"]);
                                mailDic.Add("IV_RETURN_CODE", mailResult.OV_RTN_CODE);
                                mailDic.Add("IV_RETURN_MSG", mailResult.OV_RTN_MSG);

                                comdac.SendMailLog(ref mailResult, mailDic);
                            }
                        }
                    }
                    #endregion
                }
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
        ///  메일내용 변경하기.
        /// </summary>
        /// <param name="p"></param>
        /// <param name="dr"></param>
        /// <returns></returns>
        private string MailReplace(string desc, DataRow dr, string hr_remark)
        {
            desc = desc.Replace("[증명서타입]", dr["CERTI_GB_NM"].ToString());
            desc = desc.Replace("[받는사람]", dr["RECEIVE_USER_NM"].ToString());
            desc = desc.Replace("[받는사람직함]", dr["RECEIVE_DUTY_CD_KOR"].ToString());
            desc = desc.Replace("[보내는사람]", dr["SEND_USER_NM"].ToString());
            desc = desc.Replace("[보내는사람직함]", dr["SEND_DUTY_CD_KOR"].ToString());
            desc = desc.Replace("[HR코멘트]", hr_remark);
            desc = desc.Replace("[링크]", "<a href='" + IntertekConfig.GetERPLinkPath() + "'> 여기 </a>");
            desc = desc.Replace("[상태]", dr["STATUS_CD_NM"].ToString());

            return desc;
        }


        /// <summary>
        /// Register IN Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveSampleFileList(ref IntertekBase.IntertekResult result
                                                    , Dictionary<string, object> dicParam
                                                    , List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                string req_num = "";
                // 마스터 저장
                using (Register_IN_Dac dac = new Register_IN_Dac())
                {
                    result = dac.SaveSampleFileList_master(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;

                    req_num = result.OV_RTN_MSG;
                }

                // 마스터 파일 저장
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (Register_IN_Dac dac = new Register_IN_Dac())
                    {
                        result = dac.SaveSampleFileList_file(ref result, listDic[i]);
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
        /// 접수 메일 가져오기
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet Init_Mail_Register_IN(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Register_IN_Dac dac = new Register_IN_Dac())
            {
                ds = dac.Init_Mail_Register_IN(dicParam);
            }
            return ds;
        }

    }
}
