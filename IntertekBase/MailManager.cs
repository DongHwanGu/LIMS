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
    /// Email�� �߼��մϴ�.<para></para>
    /// - ��  ��  �� : (totoropia@gmail.com) <para></para>
    /// - �����ۼ��� : 2011�� 04�� 05��<para></para>
    /// - ���ʼ����� : <para></para>
    /// - ���ʼ����� : <para></para>
    /// - �ֿ亯��α� <para></para>
    /// </summary>
    public class MailManager
    {
        /// <summary>
        /// ���� �߼� Ÿ�� ����
        /// </summary>
        public enum MailBodyType
        {
            Text = 1,
            Html = 2
        }

        /// <summary>
        /// ���� �߿䵵
        /// </summary>
        public enum MailPrioritys
        {
            Hight = 0,
            Normal = 1,
            Low = 2
        }

        /// <summary>
        /// ������ ������ ����Ÿ�� ������ ����� �ٿ�ε� �մϴ�.<para></para>
        /// </summary>
        public MailManager() { }

        #region == ���� �߼� ==

        #region == ��������  ÷������ ����. ==

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"</param>
        /// <param name="mailTo">�޴� Email ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType)
        {
            // �޴� ���� �ּ�
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            return SendMail(mailFrom, strArrMailTo, null, mailSubject, mailBody, mailBodyType, MailPrioritys.Normal, null, null);
        }


        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"</param>
        /// <param name="mailTo">�޴� Email ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys)
        {
            // �޴� ���� �ּ�
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            return SendMail(mailFrom, strArrMailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, null, null);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"</param>
        /// <param name="mailTo">�޴� Email, ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailCC">���� Email, ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType)
        {
            // �޴� ���� �ּ�
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            // ���� ���� �ּ�
            string[] strArrMailCC = StringManager.Split(mailCC, ";");

            return SendMail(mailFrom, strArrMailTo, strArrMailCC, mailSubject, mailBody, mailBodyType, MailPrioritys.Normal, null, null);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"</param>
        /// <param name="mailTo">�޴� Email, ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailCC">���� Email, ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys)
        {
            // �޴� ���� �ּ�
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            // ���� ���� �ּ�
            string[] strArrMailCC = StringManager.Split(mailCC, ";");

            return SendMail(mailFrom, strArrMailTo, strArrMailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, null, null);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"</param>
        /// <param name="mailTo">�޴� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType)
        {
            return SendMail(mailFrom, mailTo, null, mailSubject, mailBody, mailBodyType, MailPrioritys.Normal, null, null);
        }


        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"</param>
        /// <param name="mailTo">�޴� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys)
        {
            return SendMail(mailFrom, mailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, null, null);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"</param>
        /// <param name="mailTo">�޴� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailCC">���� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string[] mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType)
        {
            return SendMail(mailFrom, mailTo, mailCC, mailSubject, mailBody, mailBodyType, MailPrioritys.Normal, null, null);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"</param>
        /// <param name="mailTo">�޴� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailCC">���� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string[] mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys)
        {
            return SendMail(mailFrom, mailTo, mailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, null, null);
        }

        #endregion == �������� ÷������ ����. ==

        #region == ���� ������ ÷������ ���� ���Ͼ��ε� ��ü ==

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <param name="fileUpload">���Ͼ��ε尴ü�� �����ϸ� ���Ͼ��ε� ��ü�� �ִ� ������ ÷���Ͽ� ������.</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, FileUpload fileUpload)
        {
            // �޴� ���� �ּ�
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            return SendMail(mailFrom, strArrMailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, fileUpload, null);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email, ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailCC">���� Email, ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <param name="fileUpload">���Ͼ��ε尴ü�� �����ϸ� ���Ͼ��ε� ��ü�� �ִ� ������ ÷���Ͽ� ������.</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, FileUpload fileUpload)
        {
            // �޴� ���� �ּ�
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            // ���� ���� �ּ�
            string[] strArrMailCC = StringManager.Split(mailCC, ";");

            return SendMail(mailFrom, strArrMailTo, strArrMailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, fileUpload, null);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <param name="fileUpload">���Ͼ��ε尴ü�� �����ϸ� ���Ͼ��ε� ��ü�� �ִ� ������ ÷���Ͽ� ������.</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, FileUpload fileUpload)
        {
            return SendMail(mailFrom, mailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, fileUpload, null);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailCC">���� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <param name="fileUpload">���Ͼ��ε尴ü�� �����ϸ� ���Ͼ��ε� ��ü�� �ִ� ������ ÷���Ͽ� ������.</param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string[] mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, FileUpload fileUpload)
        {
            return SendMail(mailFrom, mailTo, mailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, fileUpload, null);
        }

        #endregion == ���� ������ ÷������ ����  ���Ͼ��ε� ��ü  ==

        #region == ���� ������ ÷������ ���� ���ϰ�� ���� ==

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <param name="attachmentFiles">÷���� ���ϸ� Full��θ� �����մϴ�. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, string attachmentFiles)
        {
            // �޴� ���� �ּ�
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            return SendMail(mailFrom, strArrMailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, null, attachmentFiles);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email, ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailCC">���� Email, ��������� �������� ";"�� �����մϴ�. ex) kys@.co.kr;testuser@.co.kr </param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <param name="attachmentFiles">÷���� ���ϸ� Full��θ� �����մϴ�. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string mailTo, string mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, string attachmentFiles)
        {
            // �޴� ���� �ּ�
            string[] strArrMailTo = StringManager.Split(mailTo, ";");

            // ���� ���� �ּ�
            string[] strArrMailCC = StringManager.Split(mailCC, ";");

            return SendMail(mailFrom, strArrMailTo, strArrMailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, null, attachmentFiles);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <param name="attachmentFiles">÷���� ���ϸ� Full��θ� �����մϴ�. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, string attachmentFiles)
        {
            return SendMail(mailFrom, mailTo, null, mailSubject, mailBody, mailBodyType, mailPrioritys, null, attachmentFiles);
        }

        /// <summary>
        /// ������ �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2011.04.05<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� :  <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailCC">���� Email, String�迭�� �ѱ�ϴ�.</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">��������</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <param name="attachmentFiles">÷���� ���ϸ� Full��θ� �����մϴ�. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom, string[] mailTo, string[] mailCC, string mailSubject, string mailBody, MailBodyType mailBodyType, MailPrioritys mailPrioritys, string attachmentFiles)
        {
            return SendMail(mailFrom, mailTo, mailCC, mailSubject, mailBody, mailBodyType, mailPrioritys, null, attachmentFiles);
        }

        #endregion == ���� ������ ÷������ ����  ���ϰ�� ����  ==

        /// <summary>
        /// �Էµ� ������ ���Ϸ� �߼��Ѵ�.<para></para>
        /// ���Ϻ����� ������ ������ �� ������, ÷�������� ���� �� �ִ�.<para></para>
        /// - ��  ��  �� :  (kys@noeplus.co.kr) (��)�׿��÷���<para></para>
        /// - �����ۼ��� : 2010.12.24<para></para>
        /// - ���ʼ����� : <para></para>
        /// - ���ʼ����� : <para></para>
        /// - �ֿ亯��α� <para></para>
        /// - �۾�  ���� : <para></para>
        /// Web.Config�� "SmtpClient:Host"�׸��� �߰� �ϰ� ������ ���ϼ����� �����մϴ�.<para></para>
        /// Web.Config�� "SmtpClient:Port"�׸��� �߰� �ϰ� SMTP���� ����ϴ� Port�� �����մϴ�. �⺻�� ��Ʈ�� "21"�Դϴ�.<para></para>
        /// </summary>
        /// <param name="mailFrom">������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"</param>
        /// <param name="mailTo">�޴� Email�ּ� String[]</param>
        /// <param name="mailCC">���� Email�ּ� String[]</param>
        /// <param name="mailSubject">���� ����</param>
        /// <param name="mailBody">���� ����</param>
        /// <param name="mailBodyType">���� ���� HTML����</param>
        /// <param name="mailPrioritys">���� �߿䵵</param>
        /// <param name="fileUpload">���Ͼ��ε尴ü�� �����ϸ� ���Ͼ��ε� ��ü�� �ִ� ������ ÷���Ͽ� ������.</param>
        /// <param name="attachmentFiles">÷���� ���ϸ� Full��θ� �����մϴ�. ex) C:\Test\Test.doc </param>
        /// <returns></returns>
        public static bool SendMail(string mailFrom,  // ������ Email ex)"kys@.co.kr" �Ǵ� �̸��� ǥ���ϰ��� �ϸ� "kys@.co.kr|"
                                    string[] mailTo,  // �޴� Email �ּ� �迭
                                    string[] mailCC,  // ���� Email �ּ� �迭
                                    string mailSubject, // ���� ����
                                    string mailBody,    // ���� ����
                                    MailBodyType mailBodyType,  // ���� Ÿ�� HTML, Text
                                    MailPrioritys mailPrioritys,  // ���� �߿䵵
                                    FileUpload fileUpload,      // ÷���� ������ �ִ� ���Ͼ��ε� ��ü
                                    string attachmentFiles)     // ÷���� ���� Full���
        {

            #region == ���ϱ⺻ ��ü ���� ==
            MailMessage oMailMessage = null; // ���ϸ޼��� ��ü ����
            SmtpClient oSmtpMail = null;     // ����SMTP ��ü ����
            bool bReturn = false;            // ���Ϲ߼ۿ��� ��ȯ �� ����
            #endregion == ���ϱ⺻ ��ü ���� ==

            #region == FileUpload��ü�� ����Ҷ� ���� ==
            string strFileName = string.Empty;      // ������ ���ϸ�
            string strFullfileName = string.Empty;  // ��ü��� �� ���ϸ�
            FileInfo objFile = null;                // ���ϰ�ü
            #endregion == FileUpload��ü�� ����Ҷ� ���� ==

            try
            {
                #region == �⺻ ���� ��ü ���� & ���� �ּ� ���� ==

                // �޼��� ��ü ����
                oMailMessage = new MailMessage();

                // �����ּ�|ǥ���̸�
                string[] strArrMailFrom = StringManager.Split(mailFrom, "|");

                if (strArrMailFrom.Length == 1)
                {
                    // ������ Email �ּ� 
                    oMailMessage.From = new MailAddress(mailFrom);
                }
                else
                {
                    oMailMessage.From = new MailAddress(strArrMailFrom[0], strArrMailFrom[1]);
                }

                // �޴� ���� �ּ�
                if (mailTo.Length > 0)
                {
                    for (int i = 0; i < mailTo.Length; i++)
                    {
                        // �޴� Email �ּ�
                        oMailMessage.To.Add(mailTo[i]);
                    }
                }
                else
                {
                    throw new ApplicationException("�޴� Email�ּҸ� �Է��Ͽ� �ֽʽÿ�.");
                }

                // ���� Email �ּ�
                if (mailCC != null && mailCC.Length > 0)
                {
                    for (int i = 0; i < mailCC.Length; i++)
                    {
                        // ���� Email �ּ�
                        oMailMessage.CC.Add(mailCC[i]);
                    }
                }

                // ���� ����
                oMailMessage.Subject = mailSubject;

                // ���� ����
                oMailMessage.Body = mailBody;

                // ���� ���� HTML���� 
                oMailMessage.IsBodyHtml = mailBodyType.Equals(MailBodyType.Html) ? true : false;

                #endregion == �⺻ ���� ��ü ���� & ���� �ּ� ���� ==

                #region == ���� �߿䵵 ���� ==

                // ���� �߿䵵�� �����մϴ�.
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

                // MailPriority.High; // ���� �߿䵵                
                oMailMessage.Priority = mailPriority;

                #endregion == ���� �߿䵵 ���� ==

                #region == FileUpload��ü�� ÷������ �߰� ==

                // ���Ծ��ε� ��ü�� ������ �����Ͽ��ٸ� 
                // ������ ���ε� �ϰ� ÷�� ���Ͽ� �߰� �մϴ�.
                if (fileUpload != null)
                {
                    if (fileUpload.HasFile)
                    {
                        // ��ü��� �� ���ϸ�
                        strFullfileName = System.Web.HttpContext.Current.Server.MapPath(fileUpload.FileName);

                        // �������ϸ�
                        strFileName = fileUpload.FileName;

                        // ������ �����Ѵ�.
                        fileUpload.SaveAs(strFullfileName);

                        // fullfileName : ÷�������� ��ü ���
                        Attachment oAttachment = new Attachment(strFullfileName);

                        // fileName : ���Ͽ��� ���̰� �Ǵ� ÷�����ϸ�
                        oAttachment.Name = strFileName;

                        // �޼����� ������ ÷���Ѵ�.
                        oMailMessage.Attachments.Add(oAttachment);
                    }
                }

                #endregion == FileUpload��ü�� ÷������ �߰� ==

                #region == ������ ���Ϸ� ÷������ �߰� ==

                // ÷���� ������ ������ 
                if (!String.IsNullOrEmpty(attachmentFiles))
                {
                    // ���ϰ�ü�� ��Ȯ���� üũ �մϴ�.
                    FileInfo oAttachFile = new FileInfo(@attachmentFiles);

                    // ������ �ִ��� üũ �մϴ�.
                    if (oAttachFile.Exists)
                    {
                        // ÷������ ��ü ����
                        Attachment oAttachment = new Attachment(attachmentFiles);

                        // ÷�����ϸ� ����
                        oAttachment.Name = oAttachFile.Name;

                        // �޼����� ÷������ �߰�
                        oMailMessage.Attachments.Add(oAttachment);
                    }
                    else
                    {
                        throw new ApplicationException("÷���� ������ ���� ���� �ʽ��ϴ�.");
                    }
                }

                #endregion == ������ ���Ϸ� ÷������ �߰� ==

                #region == SMPT��ü ���� �� Host, Port ���� ==

                // SMTP���� ��ü ����
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

                // SMTP���� ������ ����
                oSmtpMail.Host = strSmtpClientHost;

                // SMTP���ϼ����� ��Ʈ ����
                if (ConfigurationManager.AppSettings["SmtpClient:Port"].ToString().Length > 0)
                {
                    oSmtpMail.Port = Convert.ToInt32(ConfigurationManager.AppSettings["SmtpClient:Port"].ToString());
                }

                // ���Ϲ߼� �մϴ�.
                oSmtpMail.Send(oMailMessage);

                #endregion == SMPT��ü ���� �� Host, Port ���� ==

                bReturn = true;

            }
            finally
            {
                // �޼��� ��ü�� �����մϴ�.
                oMailMessage.Dispose();

                // ������ ���ε��ϸ� �ٷ� ���´ٸ� ������ ����ϴ�.
                if (!String.IsNullOrEmpty(strFullfileName))
                {
                    // ������ ã�Ƽ� �����ش�. ������ �ø� ������ ���̻� �ʿ� ����.
                    objFile = new FileInfo(@strFullfileName);

                    if (objFile.Exists)
                    {
                        objFile.Delete();
                    }
                }
            }

            return bReturn;

        }

        #endregion == ���� �߼� ==
        
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

        #region ���� ÷������ ���Ϲ߼� - Dasom.Jeong
        /// <summary>
        /// SendMail - to, cc, bcc, ÷������ ����
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email (�迭)</param>
        /// <param name="mailCC">���� (�迭)</param>
        /// <param name="mailBCC">���� ���� (�迭)</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">Html 0r Text</param>
        /// <param name="fileUpload">÷������</param> 
        /// <returns></returns>
        public bool MailSend(Page page, string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, HttpFileCollection fileUpload, string sFilePath)
        {

            #region == ���ϱ⺻ ��ü ���� ==
            MailMessage oMailMessage = null; // ���ϸ޼��� ��ü ����
            SmtpClient oSmtpMail = null;     // ����SMTP ��ü ����
            bool bReturn = false;            // ���Ϲ߼ۿ��� ��ȯ �� ����
            #endregion == ���ϱ⺻ ��ü ���� ==

            #region == FileUpload��ü�� ����Ҷ� ���� ==
            string strFileName = string.Empty;      // ������ ���ϸ�
            string strFullfileName = string.Empty;  // ��ü��� �� ���ϸ�
            FileInfo objFile = null;                // ���ϰ�ü

            string[] removeFileName = new string[fileUpload.Count];
            #endregion == FileUpload��ü�� ����Ҷ� ���� ==

            try
            {
                #region == �⺻ ���� ��ü ���� & ���� �ּ� ���� ==

                // �޼��� ��ü ����
                oMailMessage = new MailMessage();

                // �����ּ�|ǥ���̸�
                string[] strArrMailFrom = StringManager.Split(mailFrom, "|");

                if (strArrMailFrom.Length == 1)
                {
                    // ������ Email �ּ� 
                    oMailMessage.From = new MailAddress(mailFrom);
                }
                else
                {
                    oMailMessage.From = new MailAddress(strArrMailFrom[0], strArrMailFrom[1]);
                }

                // �޴� ���� �ּ�
                if (mailTo.Length > 0)
                {
                    for (int i = 0; i < mailTo.Length; i++)
                    {
                        //mailTo[i] = "heloise.jeong@intertek.com";  // 06-13 �ӽ� : ��� �޴� ����� ������ �������� ����
                        if (mailTo[i] != "")
                        {
                            // �޴� Email �ּ�
                            oMailMessage.To.Add(mailTo[i]);
                        }
                    }
                }
                else
                {
                    throw new ApplicationException("�޴� Email�ּҸ� �Է��Ͽ� �ֽʽÿ�.");
                    //ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert('�޴� Email �ּҸ� �Է��Ͽ� �ּ���.'); window.returnValue = 'true';", true);
                    return false;
                }

                // ���� Email �ּ� 
                if (mailCC != null && mailCC.Length > 0)
                {
                    for (int i = 0; i < mailCC.Length; i++)
                    {
                        //mailCC[i] = "heloise.jeong@intertek.com";  // 06-13 �ӽ� : ��� �޴� ����� ������ �������� ����
                        if (mailCC[i] != "")
                        {
                            // ���� Email �ּ�
                            oMailMessage.CC.Add(mailCC[i]);
                        }
                    }
                }

                // ���� ���� Email �ּ�
                if (mailBCC != null && mailBCC.Length > 0)
                {          
                    for (int i = 0; i < mailBCC.Length; i++)
                    {
                        //mailBCC[i] = "heloise.jeong@intertek.com";  // 06-13 �ӽ� : ��� �޴� ����� ������ �������� ����
                        if (mailBCC[i] != "")
                        {
                            // ���� ���� Email �ּ�
                            oMailMessage.Bcc.Add(mailBCC[i]);
                        }
                    }
                }


                // ���� ����
                if (mailSubject != "")
                {
                    oMailMessage.Subject = mailSubject;
                }
                else
                {
                    throw new ApplicationException("���� ������ �Է��ϼ���.");
                    //ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert('�޴� Email �ּҸ� �Է��Ͽ� �ּ���.'); window.returnValue = 'true';", true);
                    return false;
                }

                // ���� ����
                if (mailBody != "")
                {
                    oMailMessage.Body = mailBody;
                }
                else
                {
                    throw new ApplicationException("���� ������ �Է��ϼ���.");
                    //ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert('�޴� Email �ּҸ� �Է��Ͽ� �ּ���.'); window.returnValue = 'true';", true);
                    return false;
                }

                // ���� ���� HTML���� 
                oMailMessage.IsBodyHtml = mailBodyType.Equals(MailBodyType.Html) ? true : false;

                #endregion == �⺻ ���� ��ü ���� & ���� �ּ� ���� ==


                #region == FileUpload��ü�� ÷������ �߰� ==

                //�⺻����
                if (sFilePath != "")
                {
                    FileInfo fFile = new FileInfo(sFilePath);

                    strFullfileName = sFilePath;

                    strFileName = Path.GetFileName(sFilePath);

                    Attachment oAttachment = new Attachment(strFullfileName);

                    // fileName : ���Ͽ��� ���̰� �Ǵ� ÷�����ϸ�
                    oAttachment.Name = strFileName;

                    // �޼����� ������ ÷���Ѵ�.
                    oMailMessage.Attachments.Add(oAttachment);
                }

                // ���Ծ��ε� ��ü�� ������ �����Ͽ��ٸ� 
                // ������ ���ε� �ϰ� ÷�� ���Ͽ� �߰� �մϴ�.
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

                                // fileName : ���Ͽ��� ���̰� �Ǵ� ÷�����ϸ�
                                oAttachment.Name = strFileName;

                                // �޼����� ������ ÷���Ѵ�.
                                oMailMessage.Attachments.Add(oAttachment);
                                removeFileName[i] = strFullfileName;
                            }
                        }

                    }
                }

                #endregion == FileUpload��ü�� ÷������ �߰� ==


                #region == SMPT��ü ���� �� Host, Port ���� ==

                // SMTP���� ��ü ����
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

                // SMTP���� ������ ����
                oSmtpMail.Host = strSmtpClientHost;

                // SMTP���ϼ����� ��Ʈ ����
                if (ConfigurationManager.AppSettings["smtpPort"].ToString().Length > 0)
                {
                    oSmtpMail.Port = Convert.ToInt32(ConfigurationManager.AppSettings["smtpPort"].ToString());
                }

                // ���Ϲ߼� �մϴ�.
                oSmtpMail.Send(oMailMessage);

                #endregion == SMPT��ü ���� �� Host, Port ���� ==

                bReturn = true;

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert(\"" + ex.Message + "\"); window.returnValue = 'true';", true);
            }
            finally
            {
                // �޼��� ��ü�� �����մϴ�.
                oMailMessage.Dispose();

                if (removeFileName != null)
                {
                    for (int i = 0; i < removeFileName.Length; i++)
                    {
                        // ������ ���ε��ϸ� �ٷ� ���´ٸ� ������ ����ϴ�.
                        if (!String.IsNullOrEmpty(removeFileName[i]))
                        {
                            // ������ ã�Ƽ� �����ش�. ������ �ø� ������ ���̻� �ʿ� ����.
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
            //    ScriptManager.RegisterStartupScript(page, GetType(), "err_sendMail", "alert('����� ���� �߼��� �����Ͽ����ϴ�. �����ڿ��� �����ϼ���.'); window.returnValue = 'true'; self.close();", true);

            return bReturn;
        }

        #endregion

        #region Biz �ܿ��� ���� ������ : ����ȯ 1;
        // Biz �ܿ��� ���� ������ : ����ȯ
        public IntertekResult SendMail(string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, string[] fileUpload)
        {
            return MailSend(mailFrom, mailTo, mailCC, mailBCC,
                                     mailSubject, mailBody, mailBodyType, fileUpload);
        }
        /// <summary>
        /// SendMail - to, cc, bcc, ÷������ ����
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email (�迭)</param>
        /// <param name="mailCC">���� (�迭)</param>
        /// <param name="mailBCC">���� ���� (�迭)</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">Html 0r Text</param>
        /// <param name="fileUpload">÷������</param> 
        /// <returns></returns>
        public IntertekResult MailSend(string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, string[] fileUpload)
        {
            IntertekResult result = new IntertekResult();

            #region == ���ϱ⺻ ��ü ���� ==
            MailMessage oMailMessage = null; // ���ϸ޼��� ��ü ����
            SmtpClient oSmtpMail = null;     // ����SMTP ��ü ����
            #endregion == ���ϱ⺻ ��ü ���� ==

            #region == FileUpload��ü�� ����Ҷ� ���� ==
            string strFileName = string.Empty;      // ������ ���ϸ�
            string strFullfileName = string.Empty;  // ��ü��� �� ���ϸ�

            string[] removeFileName = new string[fileUpload.Length];
            #endregion == FileUpload��ü�� ����Ҷ� ���� ==

            try
            {
                #region == �⺻ ���� ��ü ���� & ���� �ּ� ���� ==
                // �޼��� ��ü ����
                oMailMessage = new MailMessage();

                // �����ּ�|ǥ���̸�
                string[] strArrMailFrom = StringManager.Split(mailFrom, "|");

                if (strArrMailFrom.Length == 1)
                {
                    // ������ Email �ּ� 
                    oMailMessage.From = new MailAddress(mailFrom);
                }
                else
                {
                    oMailMessage.From = new MailAddress(strArrMailFrom[0], strArrMailFrom[1]);
                }

                // �޴� ���� �ּ�
                if (mailTo.Length > 0)
                {
                    for (int i = 0; i < mailTo.Length; i++)
                    {
                        if (mailTo[i].Trim() != "")
                        {
                            // �޴� Email �ּ�
                            oMailMessage.To.Add(mailTo[i].Trim());
                        }
                    }
                }

                // ���� Email �ּ� 
                if (mailCC != null && mailCC.Length > 0)
                {
                    for (int i = 0; i < mailCC.Length; i++)
                    {
                        if (mailCC[i].Trim() != "")
                        {
                            // ���� Email �ּ�
                            oMailMessage.CC.Add(mailCC[i].Trim());
                        }
                    }
                }

                // ���� ���� Email �ּ�
                if (mailBCC != null && mailBCC.Length > 0)
                {
                    for (int i = 0; i < mailBCC.Length; i++)
                    {
                        if (mailBCC[i].Trim() != "")
                        {
                            // ���� ���� Email �ּ�
                            oMailMessage.Bcc.Add(mailBCC[i].Trim());
                        }
                    }
                }

                // ���� ���� HTML���� 
                oMailMessage.IsBodyHtml = mailBodyType.Equals(MailBodyType.Html) ? true : false;
                oMailMessage.Subject = mailSubject;
                oMailMessage.Body = mailBody;

                #endregion == �⺻ ���� ��ü ���� & ���� �ּ� ���� ==


                #region == FileUpload��ü�� ÷������ �߰� ==
                //// ���Ծ��ε� ��ü�� ������ �����Ͽ��ٸ� 
                //// ������ ���ε� �ϰ� ÷�� ���Ͽ� �߰� �մϴ�.
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

                //                // fileName : ���Ͽ��� ���̰� �Ǵ� ÷�����ϸ�
                //                oAttachment.Name = strFileName;

                //                // �޼����� ������ ÷���Ѵ�.
                //                oMailMessage.Attachments.Add(oAttachment);
                //                removeFileName[i] = strFullfileName;
                //            }
                //        }

                //    }
                //}

                #endregion == FileUpload��ü�� ÷������ �߰� ==

                #region == SMPT��ü ���� �� Host, Port ���� ==
                // SMTP���� ��ü ����
                oSmtpMail = new SmtpClient();

                // SMTP���� ������ ����
                oSmtpMail.Host = IntertekConfig.smtpServer;
                oSmtpMail.Port = IntertekConfig.smtpPort;

                // ���Ϲ߼� �մϴ�.
                oSmtpMail.Send(oMailMessage);
                #endregion == SMPT��ü ���� �� Host, Port ���� ==

                result.OV_RTN_CODE = 0;
                result.OV_RTN_MSG = "�߼� ����";
            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = "�߼� ���� : " + ex.Message;
            }
            finally
            {
                // �޼��� ��ü�� �����մϴ�.
                oMailMessage.Dispose();
            }

            return result;
        }
        #endregion


        #region Biz �ܿ��� ���� ������ : ����ȯ 2 (÷������);
        // Biz �ܿ��� ���� ������ : ����ȯ
        public IntertekResult SendMail_AttachFile(string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, Attachment[] oAttachments)
        {
            return MailSend_AttachFile(mailFrom, mailTo, mailCC, mailBCC,
                                     mailSubject, mailBody, mailBodyType, oAttachments);
        }
        /// <summary>
        /// SendMail - to, cc, bcc, ÷������ ����
        /// </summary>
        /// <param name="mailFrom">������ Email</param>
        /// <param name="mailTo">�޴� Email (�迭)</param>
        /// <param name="mailCC">���� (�迭)</param>
        /// <param name="mailBCC">���� ���� (�迭)</param>
        /// <param name="mailSubject">����</param>
        /// <param name="mailBody">����</param>
        /// <param name="mailBodyType">Html 0r Text</param>
        /// <param name="fileUpload">÷������</param> 
        /// <returns></returns>
        public IntertekResult MailSend_AttachFile(string mailFrom, string[] mailTo, string[] mailCC, string[] mailBCC,
                                    string mailSubject, string mailBody, MailBodyType mailBodyType, Attachment[] oAttachments)
        {
            IntertekResult result = new IntertekResult();

            #region == ���ϱ⺻ ��ü ���� ==
            MailMessage oMailMessage = null; // ���ϸ޼��� ��ü ����
            SmtpClient oSmtpMail = null;     // ����SMTP ��ü ����
            #endregion == ���ϱ⺻ ��ü ���� ==

            #region == FileUpload��ü�� ����Ҷ� ���� ==
            string strFileName = string.Empty;      // ������ ���ϸ�
            string strFullfileName = string.Empty;  // ��ü��� �� ���ϸ�
            FileInfo objFile = null;                // ���ϰ�ü

            #endregion == FileUpload��ü�� ����Ҷ� ���� ==

            try
            {
                #region == �⺻ ���� ��ü ���� & ���� �ּ� ���� ==

                // �޼��� ��ü ����
                oMailMessage = new MailMessage();

                // �����ּ�|ǥ���̸�
                string[] strArrMailFrom = StringManager.Split(mailFrom, "|");

                if (strArrMailFrom.Length == 1)
                {
                    // ������ Email �ּ� 
                    oMailMessage.From = new MailAddress(mailFrom.Trim());
                }
                else
                {
                    oMailMessage.From = new MailAddress(strArrMailFrom[0], strArrMailFrom[1]);
                }

                // �޴� ���� �ּ�
                if (mailTo.Length > 0)
                {
                    for (int i = 0; i < mailTo.Length; i++)
                    {
                        if (mailTo[i].Trim() != "")
                        {
                            // �޴� Email �ּ�
                            oMailMessage.To.Add(mailTo[i].Trim());
                        }
                    }
                }
                else
                {
                    throw new ApplicationException("�޴� Email�ּҸ� �Է��Ͽ� �ֽʽÿ�.");
                }

                // ���� Email �ּ� 
                if (mailCC != null && mailCC.Length > 0)
                {
                    for (int i = 0; i < mailCC.Length; i++)
                    {
                        if (mailCC[i].Trim() != "")
                        {
                            // ���� Email �ּ�
                            oMailMessage.CC.Add(mailCC[i].Trim());
                        }
                    }
                }

                // ���� ���� Email �ּ�
                if (mailBCC != null && mailBCC.Length > 0)
                {          
                    for (int i = 0; i < mailBCC.Length; i++)
                    {
                        if (mailBCC[i].Trim() != "")
                        {
                            // ���� ���� Email �ּ�
                            oMailMessage.Bcc.Add(mailBCC[i].Trim());
                        }
                    }
                }


                // ���� ����
                if (mailSubject != "")
                {
                    oMailMessage.Subject = mailSubject;
                }
                else
                {
                    throw new ApplicationException("���� ������ �Է��ϼ���.");
                }

                // ���� ����
                if (mailBody != "")
                {
                    oMailMessage.Body = mailBody;
                }
                else
                {
                    throw new ApplicationException("���� ������ �Է��ϼ���.");
                }

                // ���� ���� HTML���� 
                oMailMessage.IsBodyHtml = mailBodyType.Equals(MailBodyType.Html) ? true : false;

                #endregion == �⺻ ���� ��ü ���� & ���� �ּ� ���� ==


                #region == FileUpload��ü�� ÷������ �߰� ==

                ////�⺻����
                //if (sFilePath != "")
                //{
                //    FileInfo fFile = new FileInfo(sFilePath);

                //    strFullfileName = sFilePath;

                //    strFileName = Path.GetFileName(sFilePath);

                //    Attachment oAttachment = new Attachment(strFullfileName);

                //    // fileName : ���Ͽ��� ���̰� �Ǵ� ÷�����ϸ�
                //    oAttachment.Name = strFileName;

                //    // �޼����� ������ ÷���Ѵ�.
                //    oMailMessage.Attachments.Add(oAttachment);
                //}

                // ���Ծ��ε� ��ü�� ������ �����Ͽ��ٸ� 
                // ������ ���ε� �ϰ� ÷�� ���Ͽ� �߰� �մϴ�.
                if (oAttachments != null)
                {
                    for (int i = 0; i < oAttachments.Length; i++)
                    {
                        // �޼����� ������ ÷���Ѵ�.
                        oMailMessage.Attachments.Add(oAttachments[i]);
                    }
                }

                #endregion == FileUpload��ü�� ÷������ �߰� ==


                #region == SMPT��ü ���� �� Host, Port ���� ==
                // SMTP���� ��ü ����
                oSmtpMail = new SmtpClient();

                // SMTP���� ������ ����
                oSmtpMail.Host = IntertekConfig.smtpServer;
                oSmtpMail.Port = IntertekConfig.smtpPort;

                // ���Ϲ߼� �մϴ�.
                oSmtpMail.Send(oMailMessage);
                #endregion == SMPT��ü ���� �� Host, Port ���� ==

                result.OV_RTN_CODE = 0;
                result.OV_RTN_MSG = "�߼� ����";

            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = "�߼� ���� : " + ex.Message;
            }
            finally
            {
                // �޼��� ��ü�� �����մϴ�.
                oMailMessage.Dispose();
            }

            return result;
        }

        #endregion

    }
}