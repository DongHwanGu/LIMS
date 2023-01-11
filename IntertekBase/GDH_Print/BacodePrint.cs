using Microsoft.Win32.SafeHandles;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Printing;
using System.Drawing.Text;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace IntertekBase.GDH_Print
{
    public class BacodePrint
    {
         [DllImport("gdi32.dll")]
        private static extern IntPtr AddFontMemResourceEx(IntPtr pbFont, uint cbFont, IntPtr pdv, [In] ref uint pcFonts);

        private BarcodeModel bacodeModel;
        public BacodePrint()
        {

        }

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern SafeFileHandle CreateFile(string lpFileName, FileAccess dwDesiredAccess,
        uint dwShareMode, IntPtr lpSecurityAttributes, FileMode dwCreationDisposition,
        uint dwFlagsAndAttributes, IntPtr hTemplateFile);

        public void printTest_get()
        {

            //string s = "^XA^LH30,30\n^FO20,10^ADN,90,50^AD^FDHello World^FS\n^XZ";

            //PrintDialog pd = new PrintDialog();
            //pd.PrinterSettings = new PrinterSettings();
            //if (DialogResult.OK == pd.ShowDialog(this))
            //{
            //    RawPrinterHelper.SendStringToPrinter(pd.PrinterSettings.PrinterName, s);
            //}


            //using (WindowsImpersonationContext WIC = WindowsIdentity.Impersonate(IntPtr.Zero))
            //{
            //    try
            //    {
            //        // Thread is now running under the process identity.
            //        // Any resource access here uses the process identity.
            //        //Page.ClientScript.RegisterClientScriptBlock(GetType(),"Impression", "window.print()", true);
            //        PrintDocument pd = new PrintDocument();
            //        pd.DefaultPageSettings.Margins.Left = 30;
            //        pd.DefaultPageSettings.Margins.Top = 10;
            //        pd.DefaultPageSettings.Margins.Right = 10;
            //        pd.DefaultPageSettings.Margins.Bottom = 10;
            //        pd.OriginAtMargins = true;
            //        pd.PrintPage += pd_PrintPage;
            //        // Set the printer name.
            //        //pd.PrinterSettings.PrinterName = "\\NS5\hpoffice
            //        pd.PrinterSettings.PrinterName = "ZDesigner GX420d";
            //        //ZDesigner GK420t
            //        //pd.PrinterSettings.PrinterName = "FX ApeosPort-V C3376 PCL 6";

            //        pd.Print();
            //    }
            //    catch (Exception ex)
            //    {
            //        var aa = ex.Message;
            //    }
            //    finally
            //    {
            //        // Resume impersonation
            //        WIC.Undo();
            //    }
            //}
            
        }

        public void PrintTest(BarcodeModel barcodeInfo)
        {
            //this.bacodeModel = barcodeInfo;

            ////프린트 도큐먼트 생성
            //PrintDocument pd = new PrintDocument();
            //pd.PrinterSettings.PrinterName = "GeniezipPrinter";
            //pd.PrintPage += pd_PrintPage;
            //pd.Print();
        }

        void pd_PrintPage(object sender, PrintPageEventArgs ev)
        {
            #region Location


            int START_X_POINT = 10;
            int START_Y_POINT = 10;
            int TotalWidth = 360;
            int TotalHeight = 270;

            int 컨텐츠총너비 = TotalWidth;
            //int 컨텐츠2너비 = 187;  //364 -5-5-5 = 174
            //int 컨텐츠여백너비 = 5; // 5 a 5 a 5
            //int 컨텐츠3 = 123; //370 -5 -5

            //int 컨텐츠3_1 = 93; //370 -5 -5
            //int 컨텐츠3_2 = 184; //370 -5 -5
            // int 컨텐츠3_3 = 93; //370 -5 -5

            int 높이1 = 30;
            int 높이2 = 40;
            int 높이3 = 30;
            //int 높이4 = 40;
            int 높이5 = 40;
            int 높이8 = 80;

            int 렉_X_POINT = START_X_POINT;
            int 렉_Y_POINT = START_Y_POINT;
            int 렉번호너비 = TotalWidth;
            int 렉번호높이 = 높이5;

            int 첫줄_X_POINT = START_X_POINT;
            int 첫줄_Y_POINT = 10 + 렉_Y_POINT + 렉번호높이;
            int 첫줄너비 = 컨텐츠총너비;
            int 첫줄높이 = 높이1;


            int 둘째줄_X_POINT = START_X_POINT;
            int 둘째줄_Y_POINT = 2 + 첫줄_Y_POINT + 첫줄높이;
            int 둘째줄너비 = 컨텐츠총너비;
            int 둘째줄높이 = 높이1;

            int 셋째줄_X_POINT = START_X_POINT;
            int 셋째줄_Y_POINT = 2 + 둘째줄_Y_POINT + 둘째줄높이;
            int 셋째줄너비 = 컨텐츠총너비;
            int 셋째줄높이 = 높이2;

            int 네째줄_X_POINT = START_X_POINT;
            int 네째줄_Y_POINT = 4 + 셋째줄_Y_POINT + 셋째줄높이;
            int 네째줄너비 = 컨텐츠총너비;
            int 네째줄높이 = 높이1;

            int 바코드_X_POINT = START_X_POINT;
            int 바코드_Y_POINT = 2 + 네째줄_Y_POINT + 네째줄높이;
            int 바코드너비 = 컨텐츠총너비;
            int 바코드높이 = 높이8;

            int 바코드번호_X_POINT = START_X_POINT;
            int 바코드번호_Y_POINT = 5 + 바코드_Y_POINT + 바코드높이 - 30;
            int 바코드번호너비 = 컨텐츠총너비;
            int 바코드번호높이 = 높이3;

            #endregion

            #region LayOut

            Rectangle 전체레이아웃 = new Rectangle(START_X_POINT,
                                                    START_Y_POINT,
                                                    TotalWidth,
                                                    TotalHeight);

            #endregion

            string defualtFontName = "Times New Roman";

            #region StringFormats

            StringFormat leftStringFormat = new StringFormat();
            leftStringFormat.Alignment = StringAlignment.Near;
            leftStringFormat.LineAlignment = StringAlignment.Center;

            StringFormat leftTopStringFormat = new StringFormat();
            leftStringFormat.Alignment = StringAlignment.Near;
            leftStringFormat.LineAlignment = StringAlignment.Near;

            StringFormat rightStringFormat = new StringFormat();
            rightStringFormat.Alignment = StringAlignment.Far;
            rightStringFormat.LineAlignment = StringAlignment.Center;

            StringFormat centerStringFormat = new StringFormat();
            centerStringFormat.Alignment = StringAlignment.Center;
            centerStringFormat.LineAlignment = StringAlignment.Center;

            #endregion

            //ev.Graphics.DrawRectangle(Pens.Gray, 전체레이아웃);
            //ev.Graphics.DrawRectangle(Pens.Black,첫줄_레이아웃);
            //ev.Graphics.DrawRectangle(Pens.Black,둘째줄_레이아웃);
            //ev.Graphics.DrawRectangle(Pens.Black,셋째줄_레이아웃);
            //ev.Graphics.DrawRectangle(Pens.Black,네째줄_레이아웃);
            //ev.Graphics.DrawRectangle(Pens.Black,바코드_레이아웃);
            //ev.Graphics.DrawRectangle(Pens.Black,바코드번호_레이아웃);

            ev.Graphics.DrawString(bacodeModel.RackNumber,

                new Font(defualtFontName, 32, FontStyle.Bold),
                        Brushes.Black,
                        new Rectangle(렉_X_POINT, 렉_Y_POINT, 렉번호너비, 렉번호높이),
                        centerStringFormat);

            ev.Graphics.DrawString(bacodeModel.ItemNM.Length > 45 ? bacodeModel.ItemNM.Substring(0, 45) + "..." : bacodeModel.ItemNM,
                new Font(defualtFontName, 13),
                Brushes.Black,
                new Rectangle(첫줄_X_POINT, 첫줄_Y_POINT, 첫줄너비, 첫줄높이),
                leftTopStringFormat);
            //오류입고 메모가 있을경우

            if (!string.IsNullOrEmpty(bacodeModel.Cancel_cd_Memo))
            {
                ev.Graphics.DrawString("E/I > " + bacodeModel.Cancel_cd_Memo,
                new Font(defualtFontName, 10),
                Brushes.Black,
                new Rectangle(둘째줄_X_POINT, 둘째줄_Y_POINT, 둘째줄너비, 둘째줄높이),
                leftStringFormat);
            }
            else
            {
                ev.Graphics.DrawString(bacodeModel.ItemOption1 + "/" + bacodeModel.ItemOption2,
                                    new Font(defualtFontName, 13),
                                    Brushes.Black,
                                    new Rectangle(둘째줄_X_POINT,  둘째줄_Y_POINT,
                                    둘째줄너비,
                                    둘째줄높이),
                                    centerStringFormat);
            }


            //  오류입고일경우
            if (!string.IsNullOrEmpty(bacodeModel.Cancle_CD))
            {
                ev.Graphics.DrawString(bacodeModel.CustENM,
                                        new Font(defualtFontName, 20, FontStyle.Bold),
                                        Brushes.Black,
                                        new Rectangle(셋째줄_X_POINT, 셋째줄_Y_POINT, 셋째줄너비, 셋째줄높이),
                                        leftStringFormat);

                ev.Graphics.DrawString("(" + bacodeModel.Cancle_CD + ")",
                                        new Font(defualtFontName,
                                        10,
                                        FontStyle.Italic),
                                        Brushes.Black,
                                        new Rectangle(셋째줄_X_POINT, 셋째줄_Y_POINT, 셋째줄너비, 셋째줄높이),
                                        rightStringFormat);
            }
            else
            {
                ev.Graphics.DrawString(bacodeModel.CustENM,
                                        new Font(defualtFontName, 20, FontStyle.Bold),
                                        Brushes.Black,
                                        new Rectangle(셋째줄_X_POINT, 셋째줄_Y_POINT, 셋째줄너비, 셋째줄높이),
                                        centerStringFormat);
            }
            ev.Graphics.DrawString(bacodeModel.GZID + " " + bacodeModel.Cust_Contry,
                                    new Font(defualtFontName, 15, FontStyle.Bold),
                                    Brushes.Black,
                                    new Rectangle(네째줄_X_POINT, 네째줄_Y_POINT, 네째줄너비, 네째줄높이), 
                                    leftStringFormat);
            ev.Graphics.DrawString(bacodeModel.EnterDT,
                                    new Font(defualtFontName, 10, FontStyle.Bold),
                                    Brushes.Black,
                                    new Rectangle(네째줄_X_POINT, 네째줄_Y_POINT, 네째줄너비, 네째줄높이),
                                    rightStringFormat);
            ev.Graphics.DrawString(bacodeModel.BarCode,
                                    new Font(CargoPrivateFontCollection(), 30),
                                    Brushes.Black,
                                    new Rectangle(바코드_X_POINT, 바코드_Y_POINT, 바코드너비, 바코드높이),
                                    centerStringFormat);
            ev.Graphics.DrawString(bacodeModel.BarCodeNumber,
                                    new Font(defualtFontName, 15, FontStyle.Bold),
                                    Brushes.Black,
                                    new Rectangle(바코드번호_X_POINT, 바코드번호_Y_POINT, 바코드번호너비, 바코드번호높이),
                                    centerStringFormat);
        }

        private static FontFamily CargoPrivateFontCollection()
        {
            // Create the byte array and get its length

            byte[] fontArray = IntertekBase.Properties.Resources.CODE39_1;
            int dataLength = IntertekBase.Properties.Resources.CODE39_1.Length;


            // ASSIGN MEMORY AND COPY  BYTE[] ON THAT MEMORY ADDRESS
            IntPtr ptrData = Marshal.AllocCoTaskMem(dataLength);
            Marshal.Copy(fontArray, 0, ptrData, dataLength);


            uint cFonts = 0;
            AddFontMemResourceEx(ptrData, (uint)fontArray.Length, IntPtr.Zero, ref cFonts);

            PrivateFontCollection pfc = new PrivateFontCollection();
            //PASS THE FONT TO THE  PRIVATEFONTCOLLECTION OBJECT
            pfc.AddMemoryFont(ptrData, dataLength);

            //FREE THE  "UNSAFE" MEMORY
            Marshal.FreeCoTaskMem(ptrData);

            return pfc.Families[0];
        }
    }
}
