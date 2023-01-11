<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportViewer_Popup.aspx.cs" Inherits="ReportFiles_ReportViewer_Popup" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <style>
        .hidden {
            display:none;
        }
        .pdf_padding {
            padding:20px;
            font-size:1.5em;
            font-weight:bold;
        }
        img {
            width:auto;
        }
    </style>
    <title></title>
    <script src="/Scripts/jquery-1.10.2.js"></script>
    <script>
        $(function () {
            //$($('#ReportViewer1_ctl05_ctl04_ctl00_Menu div')[0]).addClass('hidden');
            //$($('#ReportViewer1_ctl05_ctl04_ctl00_Menu div')[2]).addClass('hidden');
            //$($('#ReportViewer1_ctl05_ctl04_ctl00_Menu div')[1]).addClass('pdf_padding');

            IEVersionCheck();
        })

        var IEVersionCheck = function () {
            var str = '<div id="ieETCHidden" style="font-family: Verdana; font-size: 8pt; vertical-align: top; display: inline;">' +
                        '<div style="display: inline-block; font-size: 8pt; height: 30px;" class=" "><table cellspacing="0" cellpadding="0" style="display: inline;"><tbody><tr><td height="28px">' +
                            '<table title="Print" onclick="javascript:myfunction(); return false;" id="do_print" style="cursor: default;">' +
                            '<tbody><tr><td><input type="image" style="border-width: 0px; padding: 2px; height: 16px; width: 16px;" alt="Print" src="/App/Reserved.ReportViewerWebControl.axd?OpType=Resource&Version=10.0.40219.1&Name=Microsoft.Reporting.WebForms.Icons.Print.gif" title="Print"></td></tr></tbody>' +
                        '</table></td></tr></tbody></table></div>' +
                      '</div>';

            var word;
            var version = "N/A";

            var agent = navigator.userAgent.toLowerCase();
            var name = navigator.appName;

            // IE old version ( IE 10 or Lower )
            if (name == "Microsoft Internet Explorer") return;
                // IE 11
            else if (agent.search("trident") > -1) $('# _ctl05 > div').append(str);
                // 엣지.
            else if (agent.search("edge/") > -1) return;
                // 나머지
            else $('#ReportViewer1_ctl05 > div').append(str);
        };

        function myfunction() {
            var rv1 = $('#' + "ReportViewer1");
            var iDoc = rv1.parents('html');

            // Reading the report styles
            var styles = iDoc.find("head style[id$='ReportControl_styles']").html();
            if ((styles == undefined) || (styles == '')) {
                iDoc.find('head script').each(function () {
                    var cnt = $(this).html();
                    var p1 = cnt.indexOf('ReportStyles":"');
                    if (p1 > 0) {
                        p1 += 15;
                        var p2 = cnt.indexOf('"', p1);
                        styles = cnt.substr(p1, p2 - p1);
                    }
                });
            }
            if (styles == '') { alert("Cannot generate styles, Displaying without styles.."); }
            styles = '<style type="text/css">' + styles + "</style>";

            // Reading the report html
            var table = rv1.find("div[id$='_oReportDiv']");
            if (table == undefined) {
                alert("Report source not found.");
                return;
            }

            // Generating a copy of the report in a new window
            var docType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/loose.dtd">';
            var docCnt = styles + table.parent().html();
            var docHead = '<head><title>Printing ...</title><style></style></head>';
            var winAttr = "location=yes, statusbar=no, directories=no, menubar=no, titlebar=no, toolbar=no, dependent=no, width=720, height=600, resizable=yes, screenX=200, screenY=200, personalbar=no, scrollbars=yes";;
            var newWin = window.open("", "_blank", winAttr);
            writeDoc = newWin.document;
            writeDoc.open();
            writeDoc.write(docType + '<html>' + docHead + '<body onload="window.print();">' + docCnt + '<style type="text/css">img{width:100%;height:100%;}</style></body></html>');
            writeDoc.close();

            // The print event will fire as soon as the window loads
            newWin.focus();
            // uncomment to autoclose the preview window when printing is confirmed or canceled.
            //newWin.close();

           <%-- '<% if (page == "Register_IN_Sample_Barcode")
            {
                string barCode_path = "C:\\CBKLMS_Temp\\" + SetRegister_IN_Sample_Barcode_guid + ".jpg";
                // 물리파일 삭제.
                if (System.IO.File.Exists(barCode_path))
                {
                    System.IO.File.Delete(barCode_path);
                }    
            }%>'--%>
        }

        // Print function (require the reportviewer client ID)
        function printReport(report_ID) {

        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div>
            <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="370px" Height="226px" 
                SizeToReportContent="true" 
                ShowPrintButton="true">
                <LocalReport ReportPath="ReportFiles\UI_Register\Register_IN_Sample_Barcode.rdlc">
                </LocalReport>
            </rsweb:ReportViewer>
        </div>
    </form>
</body>
</html>
