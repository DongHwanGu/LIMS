using System;
using System.Web;
using System.Web.UI;
using System.Text;
using System.Collections;
using System.IO;
using System.Data;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Net.Mail;

using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Runtime.Serialization.Formatters.Binary;
using IntertekBase;

namespace IntertekBase
{
    /// <summary>
    /// Email을 발송합니다.<para></para>
    /// - 작  성  자 : (totoropia@gmail.com) <para></para>
    /// - 최초작성일 : 2011년 04월 05일<para></para>
    /// - 최초수정자 : <para></para>
    /// - 최초수정일 : <para></para>
    /// - 주요변경로그 <para></para>
    /// </summary>
    public class MailManager
    {
        /// <summary>
        /// 메일 발송 타입 설정
        /// </summary>
        public enum MailBodyType
        {
            Text = 1,
            Html = 2
        }

        /// <summary>
        /// 메일 중요도
        /// </summary>
        public enum MailPrioritys
        {
            Hight = 0,
            Normal = 1,
            Low = 2
        }

        /// <summary>
        /// 웹에서 지정한 데이타로 엑셀을 만들어 다운로드 합니다.<para></para>
        /// </summary>
        public MailManager() { }

        #region == 메일 발송 ==

        #region == 간편보내기  첨부파일 없음. ==

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"</param>
        /// <param name="mailTo">받는 Email 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType)
        {
            // 받는 메일 주소
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            return SendMail(mailFrom, strArrMailTo, null, mailSubject, mailBody, mailBodyType, MailPrioritys.Normal, null, null);
        }


        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"</param>
        /// <param name="mailTo">받는 Email 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys)
        {
            // 받는 메일 주소
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            return SendMail(mailFrom, strArrMailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, null, null);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"</param>
        /// <param name="mailTo">받는 Email, 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailCC">참조 Email, 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType)
        {
            // 받는 메일 주소
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            // 참조 메일 주소
            string[] strArrMailCC = StringManager.Split(mailCC, ";");

            return SendMail(mailFrom, strArrMailTo, strArrMailCC, mailSubject, mailBody, mailBodyType, MailPrioritys.Normal, null, null);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"</param>
        /// <param name="mailTo">받는 Email, 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailCC">참조 Email, 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys)
        {
            // 받는 메일 주소
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            // 참조 메일 주소
            string[] strArrMailCC = StringManager.Split(mailCC, ";");

            return SendMail(mailFrom, strArrMailTo, strArrMailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, null, null);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"</param>
        /// <param name="mailTo">받는 Email, String배열로 넘깁니다.</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType)
        {
            return SendMail(mailFrom, mailTo, null, mailSubject, mailBody, mailBodyType, MailPrioritys.Normal, null, null);
        }


        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"</param>
        /// <param name="mailTo">받는 Email, String배열로 넘깁니다.</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys)
        {
            return SendMail(mailFrom, mailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, null, null);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"</param>
        /// <param name="mailTo">받는 Email, String배열로 넘깁니다.</param>
        /// <param name="mailCC">참조 Email, String배열로 넘깁니다.</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string[] mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType)
        {
            return SendMail(mailFrom, mailTo, mailCC, mailSubject, mailBody, mailBodyType, MailPrioritys.Normal, null, null);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"</param>
        /// <param name="mailTo">받는 Email, String배열로 넘깁니다.</param>
        /// <param name="mailCC">참조 Email, String배열로 넘깁니다.</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string[] mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys)
        {
            return SendMail(mailFrom, mailTo, mailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, null, null);
        }

        #endregion == 간편보내기 첨부파일 없음. ==

        #region == 메일 보내기 첨부파일 있음 파일업로드 객체 ==

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <param name="fileUpload">파일업로드객체를 지정하면 파일업로드 객체에 있는 파일을 첨부하여 보낸다.</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, FileUpload fileUpload)
        {
            // 받는 메일 주소
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            return SendMail(mailFrom, strArrMailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, fileUpload, null);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email, 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailCC">참조 Email, 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <param name="fileUpload">파일업로드객체를 지정하면 파일업로드 객체에 있는 파일을 첨부하여 보낸다.</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, FileUpload fileUpload)
        {
            // 받는 메일 주소
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            // 참조 메일 주소
            string[] strArrMailCC = StringManager.Split(mailCC, ";");

            return SendMail(mailFrom, strArrMailTo, strArrMailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, fileUpload, null);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email, String배열로 넘깁니다.</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <param name="fileUpload">파일업로드객체를 지정하면 파일업로드 객체에 있는 파일을 첨부하여 보낸다.</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, FileUpload fileUpload)
        {
            return SendMail(mailFrom, mailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, fileUpload, null);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email, String배열로 넘깁니다.</param>
        /// <param name="mailCC">참조 Email, String배열로 넘깁니다.</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <param name="fileUpload">파일업로드객체를 지정하면 파일업로드 객체에 있는 파일을 첨부하여 보낸다.</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string[] mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, FileUpload fileUpload)
        {
            return SendMail(mailFrom, mailTo, mailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, fileUpload, null);
        }

        #endregion == 메일 보내기 첨부파일 있음  파일업로드 객체  ==

        #region == 메일 보내기 첨부파일 있음 파일경로 지정 ==

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <param name="attachmentFiles">첨부할 파일명 Full경로를 지정합니다. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, string attachmentFiles)
        {
            // 받는 메일 주소
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            return SendMail(mailFrom, strArrMailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, null, attachmentFiles);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email, 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailCC">참조 Email, 여러사람을 보낼때는 ";"로 구분합니다. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <param name="attachmentFiles">첨부할 파일명 Full경로를 지정합니다. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, string attachmentFiles)
        {
            // 받는 메일 주소
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            // 참조 메일 주소
            string[] strArrMailCC = StringManager.Split(mailCC, ";");

            return SendMail(mailFrom, strArrMailTo, strArrMailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, null, attachmentFiles);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email, String배열로 넘깁니다.</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <param name="attachmentFiles">첨부할 파일명 Full경로를 지정합니다. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, string attachmentFiles)
        {
            return SendMail(mailFrom, mailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, null, attachmentFiles);
        }

        /// <summary>
        /// 메일을 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2011.04.05<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 :  <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email, String배열로 넘깁니다.</param>
        /// <param name="mailCC">참조 Email, String배열로 넘깁니다.</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">본문</param>
        /// <param name="mailBodyType">본문형식</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <param name="attachmentFiles">첨부할 파일명 Full경로를 지정합니다. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string[] mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, string attachmentFiles)
        {
            return SendMail(mailFrom, mailTo, mailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, null, attachmentFiles);
        }

        #endregion == 메일 보내기 첨부파일 있음  파일경로 지정  ==

        /// <summary>
        /// 입력된 정보를 메일로 발송한다.<para></para>
        /// 메일본문의 형식을 선택할 수 있으며, 첨부파일을 보낼 수 있다.<para></para>
        /// - 작  성  자 :  (kys@noeplus.co.kr) (주)네오플러스<para></para>
        /// - 최초작성일 : 2010.12.24<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// - 작업  내용 : <para></para>
        /// Web.Config에 "SmtpClient:Host"항목을 추가 하고 보내는 메일서버를 설정합니다.<para></para>
        /// Web.Config에 "SmtpClient:Port"항목을 추가 하고 SMTP에서 사용하는 Port를 지정합니다. 기본은 포트는 "21"입니다.<para></para>
        /// </summary>
        /// <param name="mailFrom">보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"</param>
        /// <param name="mailTo">받는 Email주소 String[]</param>
        /// <param name="mailCC">참조 Email주소 String[]</param>
        /// <param name="mailSubject">메일 제목</param>
        /// <param name="mailBody">메일 내용</param>
        /// <param name="mailBodyType">메일 내용 HTML여부</param>
        /// <param name="mailPrioritys">메일 중요도</param>
        /// <param name="fileUpload">파일업로드객체를 지정하면 파일업로드 객체에 있는 파일을 첨부하여 보낸다.</param>
        /// <param name="attachmentFiles">첨부할 파일명 Full경로를 지정합니다. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom,  // 보내는 Email ex)"kys@.co.kr" 또는 이름을 표시하고자 하면 "kys@.co.kr|"
                                    string[] mailTo,  // 받는 Email 주소 배열
                                    string[] mailCC,  // 참조 Email 주소 배열
                                    string mailSubject, // 메일 제목
                                    string mailBody,    // 메일 본문
                                    MailBodyType mailBodyType,  // 메일 타입 HTML, Text
                                    MailPrioritys mailPrioritys,  // 메일 중요도
                                    FileUpload fileUpload,      // 첨부할 파일이 있는 파일업로드 객체
                                    string attachmentFiles)     // 첨부팔 파일 Full경로
        {

            #region == 메일기본 객체 선언 ==
            MailMessage oMailMessage = null; // 메일메세지 객체 선언
            SmtpClient oSmtpMail = null;     // 메일SMTP 객체 선언
            bool bReturn = false;            // 메일발송여부 반환 값 선언
            #endregion == 메일기본 객체 선언 ==

            #region == FileUpload객체를 사용할때 변수 ==
            string strFileName = string.Empty;      // 순수한 파일명
            string strFullfileName = string.Empty;  // 전체경로 및 파일명
            FileInfo objFile = null;                // 파일객체
            #endregion == FileUpload객체를 사용할때 변수 ==

            try
            {
                #region == 기본 메일 객체 생성 & 메일 주소 설정 ==

                // 메세지 객체 생성
                oMailMessage = new MailMessage();

                // 메일주소|표시이름
                string[] strArrMailFrom = StringManager.Split(mailFrom, "|");

                if (strArrMailFrom.Length == 1)
                {
                    // 보내는 Email 주소 
                    oMailMessage.From = new MailAddress(mailFrom);
                }
                else
                {
                    oMailMessage.From = new MailAddress(strArrMailFrom[0], strArrMailFrom[1]);
                }

                // 받는 메일 주소
                if (mailTo.Length > 0)
                {
                    for (int i = 0; i < mailTo.Length; i++)
                    {
                        // 받는 Email 주소
                        oMailMessage.To.Add(mailTo[i]);
                    }
                }
                else
                {
                    throw new ApplicationException("받는 Email주소를 입력하여 주십시오.");
                }

                // 참조 Email 주소
                if (mailCC != null && mailCC.Length > 0)
                {
                    for (int i = 0; i < mailCC.Length; i++)
                    {
                        // 참조 Email 주소
                        oMailMessage.CC.Add(mailCC[i]);
                    }
                }

                // 메일 제목
                oMailMessage.Subject = mailSubject;

                // 메일 내용
                oMailMessage.Body = mailBody;

                // 메일 내용 HTML여부 
                oMailMessage.IsBodyHtml = mailBodyType.Equals(MailBodyType.Html) ? true : false;

                #endregion == 기본 메일 객체 생성 & 메일 주소 설정 ==

                #region == 메일 중요도 지정 ==

                // 메일 중요도를 지정합니다.
                MailPriority mailPriority = MailPriority.Normal;
                switch (mailPrioritys)
                {
                    case MailPrioritys.Hight:
                        mailPriority = MailPriority.High;
                        break;

                    case MailPrioritys.Normal:
                        mailPriority = MailPriority.Normal;
                        break;

                    case MailPrioritys.Low:
                        mailPriority = MailPriority.Low;
                        break;

                    default:
                        mailPriority = MailPriority.Normal;
                        break;
                }

                // MailPriority.High; // 메일 중요도                
                oMailMessage.Priority = mailPriority;

                #endregion == 메일 중요도 지정 ==

                #region == FileUpload객체로 첨부파일 추가 ==

                // 파입업로드 객체에 파일을 지정하였다면 
                // 파일을 업로드 하고 첨부 파일에 추가 합니다.
                if (fileUpload != null)
                {
                    if (fileUpload.HasFile)
                    {
                        // 전체경로 및 파일명
                        strFullfileName = System.Web.HttpContext.Current.Server.MapPath(fileUpload.FileName);

                        // 순수파일명
                        strFileName = fileUpload.FileName;

                        // 파일을 저장한다.
                        fileUpload.SaveAs(strFullfileName);

                        // fullfileName : 첨부파일의 전체 경로
                        Attachment oAttachment = new Attachment(strFullfileName);

                        // fileName : 메일에서 보이게 되는 첨부파일명
                        oAttachment.Name = strFileName;

                        // 메세지에 파일을 첨부한다.
                        oMailMessage.Attachments.Add(oAttachment);
                    }
                }

                #endregion == FileUpload객체로 첨부파일 추가 ==

                #region == 지정한 파일로 첨부파일 추가 ==

                // 첨부할 파일이 있으면 
                if (!String.IsNullOrEmpty(attachmentFiles))
                {
                    // 파일객체가 정확한지 체크 합니다.
                    FileInfo oAttachFile = new FileInfo(@attachmentFiles);

                    // 파일이 있는지 체크 합니다.
                    if (oAttachFile.Exists)
                    {
                        // 첨부파일 객체 생성
                        Attachment oAttachment = new Attachment(attachmentFiles);

                        // 첨부파일명 지정
                        oAttachment.Name = oAttachFile.Name;

                        // 메세지에 첨부파일 추가
                        oMailMessage.Attachments.Add(oAttachment);
                    }
                    else
                    {
                        throw new ApplicationException("첨부할 파일이 존재 하지 않습니다.");
                    }
                }

                #endregion == 지정한 파일로 첨부파일 추가 ==

                #region == SMPT객체 생성 및 Host, Port 지정 ==

                // SMTP메일 객체 생성
                oSmtpMail = new SmtpClient();

                string strSmtpClientHost = string.Empty;

                if (ConfigurationManager.AppSettings["SmtpClient:Host"].ToString().Length > 0)
                {
                    strSmtpClientHost = ConfigurationManager.AppSettings["SmtpClient:Host"].ToString();
                }
                else
                {
                    bReturn = false;
                }

                // SMTP메일 서버를 설정
                oSmtpMail.Host = strSmtpClientHost;

                // SMTP메일서버의 포트 설정
                if (ConfigurationManager.AppSettings["SmtpClient:Port"].ToString().Length > 0)
                {
                    oSmtpMail.Port = Convert.ToInt32(ConfigurationManager.AppSettings["SmtpClient:Port"].ToString());
                }

                // 메일발송 합니다.
                oSmtpMail.Send(oMailMessage);

                #endregion == SMPT객체 생성 및 Host, Port 지정 ==

                bReturn = true;

            }
            finally
            {
                // 메세지 객체를 해제합니다.
                oMailMessage.Dispose();

                // 파일을 업로드하며 바로 보냈다면 파일을 지웁니다.
                if (!String.IsNullOrEmpty(strFullfileName))
                {
                    // 파일을 찾아서 지워준다. 서버에 올린 파일은 더이상 필요 없다.
                    objFile = new FileInfo(@strFullfileName);

                    if (objFile.Exists)
                    {
                        objFile.Delete();
                    }
                }
            }

            return bReturn;

        }

        #endregion == 메일 발송 ==
        
        public bool SendMail(Page page, string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, HttpFileCollection fileUpload, string sFilePath)
        {
            return MailSend(page, mailFrom, mailTo, mailCC, mailBCC,
                                     mailSubject, mailBody, mailBodyType, fileUpload, sFilePath);
        }

        public bool SendMail(Page page, string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, HttpFileCollection fileUpload)
        {
            return MailSend(page, mailFrom, mailTo, mailCC, mailBCC,
                                     mailSubject, mailBody, mailBodyType, fileUpload, "");
        }

        #region 복수 첨부파일 메일발송 - Dasom.Jeong
        /// <summary>
        /// SendMail - to, cc, bcc, 첨부파일 가능
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email (배열)</param>
        /// <param name="mailCC">참조 (배열)</param>
        /// <param name="mailBCC">숨은 참조 (배열)</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">내용</param>
        /// <param name="mailBodyType">Html 0r Text</param>
        /// <param name="fileUpload">첨부파일</param> 
        /// <returns></returns>
        public bool MailSend(Page page, string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, HttpFileCollection fileUpload, string sFilePath)
        {

            #region == 메일기본 객체 선언 ==
            MailMessage oMailMessage = null; // 메일메세지 객체 선언
            SmtpClient oSmtpMail = null;     // 메일SMTP 객체 선언
            bool bReturn = false;            // 메일발송여부 반환 값 선언
            #endregion == 메일기본 객체 선언 ==

            #region == FileUpload객체를 사용할때 변수 ==
            string strFileName = string.Empty;      // 순수한 파일명
            string strFullfileName = string.Empty;  // 전체경로 및 파일명
            FileInfo objFile = null;                // 파일객체

            string[] removeFileName = new string[fileUpload.Count];
            #endregion == FileUpload객체를 사용할때 변수 ==

            try
            {
                #region == 기본 메일 객체 생성 & 메일 주소 설정 ==

                // 메세지 객체 생성
                oMailMessage = new MailMessage();

                // 메일주소|표시이름
                string[] strArrMailFrom = StringManager.Split(mailFrom, "|");

                if (strArrMailFrom.Length == 1)
                {
                    // 보내는 Email 주소 
                    oMailMessage.From = new MailAddress(mailFrom);
                }
                else
                {
                    oMailMessage.From = new MailAddress(strArrMailFrom[0], strArrMailFrom[1]);
                }

                // 받는 메일 주소
                if (mailTo.Length > 0)
                {
                    for (int i = 0; i < mailTo.Length; i++)
                    {
                        //mailTo[i] = "heloise.jeong@intertek.com";  // 06-13 임시 : 모든 받는 사람은 정혜진 차장으로 세팅
                        if (mailTo[i] != "")
                        {
                            // 받는 Email 주소
                            oMailMessage.To.Add(mailTo[i]);
                        }
                    }
                }
                else
                {
                    throw new ApplicationException("받는 Email주소를 입력하여 주십시오.");
                    //ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert('받는 Email 주소를 입력하여 주세요.'); window.returnValue = 'true';", true);
                    return false;
                }

                // 참조 Email 주소 
                if (mailCC != null && mailCC.Length > 0)
                {
                    for (int i = 0; i < mailCC.Length; i++)
                    {
                        //mailCC[i] = "heloise.jeong@intertek.com";  // 06-13 임시 : 모든 받는 사람은 정혜진 차장으로 세팅
                        if (mailCC[i] != "")
                        {
                            // 참조 Email 주소
                            oMailMessage.CC.Add(mailCC[i]);
                        }
                    }
                }

                // 숨은 참조 Email 주소
                if (mailBCC != null && mailBCC.Length > 0)
                {          
                    for (int i = 0; i < mailBCC.Length; i++)
                    {
                        //mailBCC[i] = "heloise.jeong@intertek.com";  // 06-13 임시 : 모든 받는 사람은 정혜진 차장으로 세팅
                        if (mailBCC[i] != "")
                        {
                            // 숨은 참조 Email 주소
                            oMailMessage.Bcc.Add(mailBCC[i]);
                        }
                    }
                }


                // 메일 제목
                if (mailSubject != "")
                {
                    oMailMessage.Subject = mailSubject;
                }
                else
                {
                    throw new ApplicationException("메일 제목을 입력하세요.");
                    //ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert('받는 Email 주소를 입력하여 주세요.'); window.returnValue = 'true';", true);
                    return false;
                }

                // 메일 내용
                if (mailBody != "")
                {
                    oMailMessage.Body = mailBody;
                }
                else
                {
                    throw new ApplicationException("메일 내용을 입력하세요.");
                    //ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert('받는 Email 주소를 입력하여 주세요.'); window.returnValue = 'true';", true);
                    return false;
                }

                // 메일 내용 HTML여부 
                oMailMessage.IsBodyHtml = mailBodyType.Equals(MailBodyType.Html) ? true : false;

                #endregion == 기본 메일 객체 생성 & 메일 주소 설정 ==


                #region == FileUpload객체로 첨부파일 추가 ==

                //기본파일
                if (sFilePath != "")
                {
                    FileInfo fFile = new FileInfo(sFilePath);

                    strFullfileName = sFilePath;

                    strFileName = Path.GetFileName(sFilePath);

                    Attachment oAttachment = new Attachment(strFullfileName);

                    // fileName : 메일에서 보이게 되는 첨부파일명
                    oAttachment.Name = strFileName;

                    // 메세지에 파일을 첨부한다.
                    oMailMessage.Attachments.Add(oAttachment);
                }

                // 파입업로드 객체에 파일을 지정하였다면 
                // 파일을 업로드 하고 첨부 파일에 추가 합니다.
                if (fileUpload != null)
                {

                    if (fileUpload.Count > 0)
                    {
                        for (int i = 0; i < fileUpload.Count; i++)
                        {
                            HttpPostedFile hpf = fileUpload[i];
                            if (hpf.ContentLength > 0)
                            {
                                strFullfileName = System.Web.HttpContext.Current.Server.MapPath("~/Uploads/") + System.IO.Path.GetFileName(hpf.FileName);

                                hpf.SaveAs(strFullfileName);

                                strFileName = System.IO.Path.GetFileName(hpf.FileName);

                                Attachment oAttachment = new Attachment(strFullfileName);

                                // fileName : 메일에서 보이게 되는 첨부파일명
                                oAttachment.Name = strFileName;

                                // 메세지에 파일을 첨부한다.
                                oMailMessage.Attachments.Add(oAttachment);
                                removeFileName[i] = strFullfileName;
                            }
                        }

                    }
                }

                #endregion == FileUpload객체로 첨부파일 추가 ==


                #region == SMPT객체 생성 및 Host, Port 지정 ==

                // SMTP메일 객체 생성
                oSmtpMail = new SmtpClient();

                string strSmtpClientHost = string.Empty;

                if (ConfigurationManager.AppSettings["smtpServer"].ToString().Length > 0)
                {
                    strSmtpClientHost = ConfigurationManager.AppSettings["smtpServer"].ToString();
                }
                else
                {
                    bReturn = false;
                }

                // SMTP메일 서버를 설정
                oSmtpMail.Host = strSmtpClientHost;

                // SMTP메일서버의 포트 설정
                if (ConfigurationManager.AppSettings["smtpPort"].ToString().Length > 0)
                {
                    oSmtpMail.Port = Convert.ToInt32(ConfigurationManager.AppSettings["smtpPort"].ToString());
                }

                // 메일발송 합니다.
                oSmtpMail.Send(oMailMessage);

                #endregion == SMPT객체 생성 및 Host, Port 지정 ==

                bReturn = true;

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert(\"" + ex.Message + "\"); window.returnValue = 'true';", true);
            }
            finally
            {
                // 메세지 객체를 해제합니다.
                oMailMessage.Dispose();

                if (removeFileName != null)
                {
                    for (int i = 0; i < removeFileName.Length; i++)
                    {
                        // 파일을 업로드하며 바로 보냈다면 파일을 지웁니다.
                        if (!String.IsNullOrEmpty(removeFileName[i]))
                        {
                            // 파일을 찾아서 지워준다. 서버에 올린 파일은 더이상 필요 없다.
                            objFile = new FileInfo(@removeFileName[i]);

                            if (objFile.Exists)
                            {
                                objFile.Delete();
                            }
                        }
                    }
                }
            }
            //if(bReturn == false)
            //    ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert('사용자 메일 발송이 실패하였습니다. 관리자에게 문의하세요.'); window.returnValue = 'true'; self.close();", true);

            return bReturn;
        }

        #endregion

        #region Biz 단에서 메일 보내기 : 구동환 1;
        // Biz 단에서 메일 보내기 : 구동환
        public IntertekResult SendMail(string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, string[] fileUpload)
        {
            return MailSend(mailFrom, mailTo, mailCC, mailBCC,
                                     mailSubject, mailBody, mailBodyType, fileUpload);
        }
        /// <summary>
        /// SendMail - to, cc, bcc, 첨부파일 가능
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email (배열)</param>
        /// <param name="mailCC">참조 (배열)</param>
        /// <param name="mailBCC">숨은 참조 (배열)</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">내용</param>
        /// <param name="mailBodyType">Html 0r Text</param>
        /// <param name="fileUpload">첨부파일</param> 
        /// <returns></returns>
        public IntertekResult MailSend(string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, string[] fileUpload)
        {
            IntertekResult result = new IntertekResult();

            #region == 메일기본 객체 선언 ==
            MailMessage oMailMessage = null; // 메일메세지 객체 선언
            SmtpClient oSmtpMail = null;     // 메일SMTP 객체 선언
            #endregion == 메일기본 객체 선언 ==

            #region == FileUpload객체를 사용할때 변수 ==
            string strFileName = string.Empty;      // 순수한 파일명
            string strFullfileName = string.Empty;  // 전체경로 및 파일명

            string[] removeFileName = new string[fileUpload.Length];
            #endregion == FileUpload객체를 사용할때 변수 ==

            try
            {
                #region == 기본 메일 객체 생성 & 메일 주소 설정 ==
                // 메세지 객체 생성
                oMailMessage = new MailMessage();

                // 메일주소|표시이름
                string[] strArrMailFrom = StringManager.Split(mailFrom, "|");

                if (strArrMailFrom.Length == 1)
                {
                    // 보내는 Email 주소 
                    oMailMessage.From = new MailAddress(mailFrom);
                }
                else
                {
                    oMailMessage.From = new MailAddress(strArrMailFrom[0], strArrMailFrom[1]);
                }

                // 받는 메일 주소
                if (mailTo.Length > 0)
                {
                    for (int i = 0; i < mailTo.Length; i++)
                    {
                        if (mailTo[i].Trim() != "")
                        {
                            // 받는 Email 주소
                            oMailMessage.To.Add(mailTo[i].Trim());
                        }
                    }
                }

                // 참조 Email 주소 
                if (mailCC != null && mailCC.Length > 0)
                {
                    for (int i = 0; i < mailCC.Length; i++)
                    {
                        if (mailCC[i].Trim() != "")
                        {
                            // 참조 Email 주소
                            oMailMessage.CC.Add(mailCC[i].Trim());
                        }
                    }
                }

                // 숨은 참조 Email 주소
                if (mailBCC != null && mailBCC.Length > 0)
                {
                    for (int i = 0; i < mailBCC.Length; i++)
                    {
                        if (mailBCC[i].Trim() != "")
                        {
                            // 숨은 참조 Email 주소
                            oMailMessage.Bcc.Add(mailBCC[i].Trim());
                        }
                    }
                }

                // 메일 내용 HTML여부 
                oMailMessage.IsBodyHtml = mailBodyType.Equals(MailBodyType.Html) ? true : false;
                oMailMessage.Subject = mailSubject;
                oMailMessage.Body = mailBody;

                #endregion == 기본 메일 객체 생성 & 메일 주소 설정 ==


                #region == FileUpload객체로 첨부파일 추가 ==
                //// 파입업로드 객체에 파일을 지정하였다면 
                //// 파일을 업로드 하고 첨부 파일에 추가 합니다.
                //if (fileUpload != null)
                //{

                //    if (fileUpload.Count > 0)
                //    {
                //        for (int i = 0; i < fileUpload.Count; i++)
                //        {
                //            HttpPostedFile hpf = fileUpload[i];
                //            if (hpf.ContentLength > 0)
                //            {
                //                strFullfileName = System.Web.HttpContext.Current.Server.MapPath("~/Uploads/") + System.IO.Path.GetFileName(hpf.FileName);

                //                hpf.SaveAs(strFullfileName);

                //                strFileName = System.IO.Path.GetFileName(hpf.FileName);

                //                Attachment oAttachment = new Attachment(strFullfileName);

                //                // fileName : 메일에서 보이게 되는 첨부파일명
                //                oAttachment.Name = strFileName;

                //                // 메세지에 파일을 첨부한다.
                //                oMailMessage.Attachments.Add(oAttachment);
                //                removeFileName[i] = strFullfileName;
                //            }
                //        }

                //    }
                //}

                #endregion == FileUpload객체로 첨부파일 추가 ==

                #region == SMPT객체 생성 및 Host, Port 지정 ==
                // SMTP메일 객체 생성
                oSmtpMail = new SmtpClient();

                // SMTP메일 서버를 설정
                oSmtpMail.Host = IntertekConfig.smtpServer;
                oSmtpMail.Port = IntertekConfig.smtpPort;

                // 메일발송 합니다.
                oSmtpMail.Send(oMailMessage);
                #endregion == SMPT객체 생성 및 Host, Port 지정 ==

                result.OV_RTN_CODE = 0;
                result.OV_RTN_MSG = "발송 성공";
            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = "발송 실패 : " + ex.Message;
            }
            finally
            {
                // 메세지 객체를 해제합니다.
                oMailMessage.Dispose();
            }

            return result;
        }
        #endregion


        #region Biz 단에서 메일 보내기 : 구동환 2 (첨부파일);
        // Biz 단에서 메일 보내기 : 구동환
        public IntertekResult SendMail_AttachFile(string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, Attachment[] oAttachments)
        {
            return MailSend_AttachFile(mailFrom, mailTo, mailCC, mailBCC,
                                     mailSubject, mailBody, mailBodyType, oAttachments);
        }
        /// <summary>
        /// SendMail - to, cc, bcc, 첨부파일 가능
        /// </summary>
        /// <param name="mailFrom">보내는 Email</param>
        /// <param name="mailTo">받는 Email (배열)</param>
        /// <param name="mailCC">참조 (배열)</param>
        /// <param name="mailBCC">숨은 참조 (배열)</param>
        /// <param name="mailSubject">제목</param>
        /// <param name="mailBody">내용</param>
        /// <param name="mailBodyType">Html 0r Text</param>
        /// <param name="fileUpload">첨부파일</param> 
        /// <returns></returns>
        public IntertekResult MailSend_AttachFile(string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, Attachment[] oAttachments)
        {
            IntertekResult result = new IntertekResult();

            #region == 메일기본 객체 선언 ==
            MailMessage oMailMessage = null; // 메일메세지 객체 선언
            SmtpClient oSmtpMail = null;     // 메일SMTP 객체 선언
            #endregion == 메일기본 객체 선언 ==

            #region == FileUpload객체를 사용할때 변수 ==
            string strFileName = string.Empty;      // 순수한 파일명
            string strFullfileName = string.Empty;  // 전체경로 및 파일명
            FileInfo objFile = null;                // 파일객체

            #endregion == FileUpload객체를 사용할때 변수 ==

            try
            {
                #region == 기본 메일 객체 생성 & 메일 주소 설정 ==

                // 메세지 객체 생성
                oMailMessage = new MailMessage();

                // 메일주소|표시이름
                string[] strArrMailFrom = StringManager.Split(mailFrom, "|");

                if (strArrMailFrom.Length == 1)
                {
                    // 보내는 Email 주소 
                    oMailMessage.From = new MailAddress(mailFrom.Trim());
                }
                else
                {
                    oMailMessage.From = new MailAddress(strArrMailFrom[0], strArrMailFrom[1]);
                }

                // 받는 메일 주소
                if (mailTo.Length > 0)
                {
                    for (int i = 0; i < mailTo.Length; i++)
                    {
                        if (mailTo[i].Trim() != "")
                        {
                            // 받는 Email 주소
                            oMailMessage.To.Add(mailTo[i].Trim());
                        }
                    }
                }
                else
                {
                    throw new ApplicationException("받는 Email주소를 입력하여 주십시오.");
                }

                // 참조 Email 주소 
                if (mailCC != null && mailCC.Length > 0)
                {
                    for (int i = 0; i < mailCC.Length; i++)
                    {
                        if (mailCC[i].Trim() != "")
                        {
                            // 참조 Email 주소
                            oMailMessage.CC.Add(mailCC[i].Trim());
                        }
                    }
                }

                // 숨은 참조 Email 주소
                if (mailBCC != null && mailBCC.Length > 0)
                {          
                    for (int i = 0; i < mailBCC.Length; i++)
                    {
                        if (mailBCC[i].Trim() != "")
                        {
                            // 숨은 참조 Email 주소
                            oMailMessage.Bcc.Add(mailBCC[i].Trim());
                        }
                    }
                }


                // 메일 제목
                if (mailSubject != "")
                {
                    oMailMessage.Subject = mailSubject;
                }
                else
                {
                    throw new ApplicationException("메일 제목을 입력하세요.");
                }

                // 메일 내용
                if (mailBody != "")
                {
                    oMailMessage.Body = mailBody;
                }
                else
                {
                    throw new ApplicationException("메일 내용을 입력하세요.");
                }

                // 메일 내용 HTML여부 
                oMailMessage.IsBodyHtml = mailBodyType.Equals(MailBodyType.Html) ? true : false;

                #endregion == 기본 메일 객체 생성 & 메일 주소 설정 ==


                #region == FileUpload객체로 첨부파일 추가 ==

                ////기본파일
                //if (sFilePath != "")
                //{
                //    FileInfo fFile = new FileInfo(sFilePath);

                //    strFullfileName = sFilePath;

                //    strFileName = Path.GetFileName(sFilePath);

                //    Attachment oAttachment = new Attachment(strFullfileName);

                //    // fileName : 메일에서 보이게 되는 첨부파일명
                //    oAttachment.Name = strFileName;

                //    // 메세지에 파일을 첨부한다.
                //    oMailMessage.Attachments.Add(oAttachment);
                //}

                // 파입업로드 객체에 파일을 지정하였다면 
                // 파일을 업로드 하고 첨부 파일에 추가 합니다.
                if (oAttachments != null)
                {
                    for (int i = 0; i < oAttachments.Length; i++)
                    {
                        // 메세지에 파일을 첨부한다.
                        oMailMessage.Attachments.Add(oAttachments[i]);
                    }
                }

                #endregion == FileUpload객체로 첨부파일 추가 ==


                #region == SMPT객체 생성 및 Host, Port 지정 ==
                // SMTP메일 객체 생성
                oSmtpMail = new SmtpClient();

                // SMTP메일 서버를 설정
                oSmtpMail.Host = IntertekConfig.smtpServer;
                oSmtpMail.Port = IntertekConfig.smtpPort;

                // 메일발송 합니다.
                oSmtpMail.Send(oMailMessage);
                #endregion == SMPT객체 생성 및 Host, Port 지정 ==

                result.OV_RTN_CODE = 0;
                result.OV_RTN_MSG = "발송 성공";

            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = "발송 실패 : " + ex.Message;
            }
            finally
            {
                // 메세지 객체를 해제합니다.
                oMailMessage.Dispose();
            }

            return result;
        }

        #endregion

    }
}