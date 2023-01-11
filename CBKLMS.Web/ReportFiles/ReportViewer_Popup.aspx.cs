using CBKLMS.Biz.UI_Register;
using GenCode128;
using IntertekBase;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ReportFiles_ReportViewer_Popup : System.Web.UI.Page
{
    public string SetRegister_IN_Sample_Barcode_guid = "";

    public string page = "";
    public string key = "";
    
    List<string> listKey = new List<string>();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            page = Request.QueryString["page"];
            key = Request.QueryString["key"];

            listKey = key.ToString().Split(',').ToList();

            InitControls();
        }
    }

    /// <summary>
    /// 페이지 초기 가져오기
    /// </summary>
    private void InitControls()
    {
        try
        {
            string path = "";
            switch (page)
            {
                case "Register_IN_Sample_Barcode":
                    path = "ReportFiles/HR/HR_Form/LeaveHoli/" + page + ".rdlc";
                    SetRegister_IN_Sample_Barcode(path);
                    break;
                default:
                    break;
            }

        }
        catch (Exception ex)
        {
            ShowMessage.AlertMessage(ex.Message);
        }
    }

    private void SetRegister_IN_Sample_Barcode(string path)
    {
        DataSet ds = null;

        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam.Add("IV_REQ_NUM", listKey[0].ToString());
        dicParam.Add("IV_SAMPLE_ID", listKey[1].ToString());

        using (Register_IN_Biz biz = new Register_IN_Biz())
        {
            ds = biz.SetRegister_IN_Sample_Barcode(dicParam);
        }

        ReportViewer1.PageCountMode = PageCountMode.Actual;
        ReportViewer1.LocalReport.EnableExternalImages = true;

        ReportDataSource RDS1 = new ReportDataSource("DataSet1", ds.Tables[0]);

        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(RDS1);

        ReportViewer1.LocalReport.Refresh();

        ds.Dispose();
    }

    private string SetRegister_IN_Sample_Barcode_path()
    {

        #region 이미지 그리기

        string barCode = "*CBK19100001*";

        System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();

        using (Bitmap bitMap = new Bitmap(370, 215))
        {
            using (Graphics graphics = Graphics.FromImage(bitMap))
            {
                Font All_Font = new Font("Dotum", 9, FontStyle.Regular);

                StringFormat left_strFormat = new StringFormat();
                left_strFormat.Alignment = StringAlignment.Near;
                left_strFormat.LineAlignment = StringAlignment.Center;

                StringFormat center_strFormat = new StringFormat();
                center_strFormat.Alignment = StringAlignment.Center;
                center_strFormat.LineAlignment = StringAlignment.Center;

                int All_X = 5;
                int All_Y = 5;
                int All_Width = 350;
                int All_Height = 205;
                int table_height = 22;
                Rectangle All_Rec = new Rectangle(All_X, All_Y, All_Width, All_Height);
                graphics.DrawRectangle(Pens.Black, All_Rec);


                #region 첫째줄
                Rectangle table_tr1_td1 = new Rectangle(All_X, All_Y, 70, table_height);
                graphics.DrawString("의뢰자", All_Font, Brushes.Black, table_tr1_td1, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr1_td1);

                Rectangle table_tr1_td2 = new Rectangle((All_X + 70), All_Y, 130, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr1_td2, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr1_td2);

                Rectangle table_tr1_td3 = new Rectangle((All_X + 70 + 130), All_Y, 70, table_height);
                graphics.DrawString("시료처리", All_Font, Brushes.Black, table_tr1_td3, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr1_td3);

                Rectangle table_tr1_td4 = new Rectangle((All_X + 70 + 130 + 70), All_Y, 80, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr1_td4, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr1_td4);
                #endregion

                #region 둘째줄
                Rectangle table_tr2_td1 = new Rectangle(All_X, (All_Y + table_height), 70, table_height);
                graphics.DrawString("시료번호", All_Font, Brushes.Black, table_tr2_td1, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr2_td1);

                Rectangle table_tr2_td2 = new Rectangle((All_X + 70), (All_Y + table_height), 130, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr2_td2, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr2_td2);

                Rectangle table_tr2_td3 = new Rectangle((All_X + 70 + 130), (All_Y + table_height), 70, table_height);
                graphics.DrawString("분석번호", All_Font, Brushes.Black, table_tr2_td3, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr2_td3);

                Rectangle table_tr2_td4 = new Rectangle((All_X + 70 + 130 + 70), (All_Y + table_height), 80, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr2_td4, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr2_td4);
                #endregion

                #region 셋째줄
                Rectangle table_tr3_td1 = new Rectangle(All_X, (All_Y + (table_height * 2)), 70, table_height);
                graphics.DrawString("광종", All_Font, Brushes.Black, table_tr3_td1, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr3_td1);

                Rectangle table_tr3_td2 = new Rectangle((All_X + 70), (All_Y + (table_height * 2)), 130, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr3_td2, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr3_td2);

                Rectangle table_tr3_td3 = new Rectangle((All_X + 70 + 130), (All_Y + (table_height * 2)), 70, table_height);
                graphics.DrawString("접수일자", All_Font, Brushes.Black, table_tr3_td3, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr3_td3);

                Rectangle table_tr3_td4 = new Rectangle((All_X + 70 + 130 + 70), (All_Y + (table_height * 2)), 80, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr3_td4, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr3_td4);
                #endregion

                #region 넷째줄
                Rectangle table_tr4_td1 = new Rectangle(All_X, (All_Y + table_height * 3), 70, table_height);
                graphics.DrawString("담당자", All_Font, Brushes.Black, table_tr4_td1, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr4_td1);

                Rectangle table_tr4_td2 = new Rectangle((All_X + 70), (All_Y + table_height * 3), 130, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr4_td2, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr4_td2);

                Rectangle table_tr4_td3 = new Rectangle((All_X + 70 + 130), (All_Y + table_height * 3), 70, table_height);
                graphics.DrawString("발급예정", All_Font, Brushes.Black, table_tr4_td3, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr4_td3);

                Rectangle table_tr4_td4 = new Rectangle((All_X + 70 + 130 + 70), (All_Y + table_height * 3), 80, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr4_td4, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr4_td4);
                #endregion

                #region 다섯줄
                Rectangle table_tr5_td1 = new Rectangle(All_X, (All_Y + table_height * 4), 70, table_height);
                graphics.DrawString("특이사항", All_Font, Brushes.Black, table_tr5_td1, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr5_td1);

                Rectangle table_tr5_td2 = new Rectangle((All_X + 70), (All_Y + table_height * 4), 280, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr5_td2, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr5_td2);
                #endregion

                #region 여섯줄
                Rectangle table_tr6_td1 = new Rectangle(All_X, (All_Y + table_height * 5), 70, table_height);
                graphics.DrawString("분석항목", All_Font, Brushes.Black, table_tr6_td1, center_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr6_td1);

                Rectangle table_tr6_td2 = new Rectangle((All_X + 70), (All_Y + table_height * 5), 280, table_height);
                graphics.DrawString("", All_Font, Brushes.Black, table_tr6_td2, left_strFormat);
                graphics.DrawRectangle(Pens.Black, table_tr6_td2);
                #endregion


                #region 바코드 부분
                //바코드 부분
                int Barcode_X = 30;
                int Barcode_Y = 148;
                int Barcode_Width = 200;
                int Barcode_Height = 25;
                
                // 바코드 부분
                Rectangle barcode_rec = new Rectangle(Barcode_X, Barcode_Y, Barcode_Width, Barcode_Height);
                System.Drawing.Image barcode_img = Code128Rendering.MakeBarcodeImage(barCode, 1, true);
                SetRegister_IN_Sample_Barcode_guid = Guid.NewGuid().ToString();
                string barCode_path = "C:\\CBKLMS_Temp\\" + SetRegister_IN_Sample_Barcode_guid + ".jpg";
                barcode_img.Save(barCode_path);
                graphics.DrawImage(barcode_img, barcode_rec);
                //graphics.DrawRectangle(Pens.Black, barcode_rec); 
                #endregion

                #region 바코드 텍스트
                Rectangle barcode_text_rec = new Rectangle(All_X, 188, 350, 20);
                graphics.DrawString(barCode, All_Font, Brushes.Black, barcode_text_rec, center_strFormat);
                #endregion

            }
            using (MemoryStream ms = new MemoryStream())
            {
                bitMap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                // Save to disk
                //string fileName = "C:\\image.jpg";
                //bitMap.Save(fileName, ImageFormat.Png);

                byte[] byteImage = ms.ToArray();

                Convert.ToBase64String(byteImage);
                imgBarCode.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(byteImage);
            }
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseWindow", "PrintContent()", true);
        }
        #endregion

        return "file:///C:/CBKLMS_Temp/" + SetRegister_IN_Sample_Barcode_guid + ".jpg";
    }
}