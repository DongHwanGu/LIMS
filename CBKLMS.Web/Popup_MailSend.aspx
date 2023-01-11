<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Popup_MailSend.aspx.cs" Inherits="Popup_MailSend" validateRequest="false"
 %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <script src="http://cdnjs.cloudflare.com/ajax/libs/respond.js/1.4.2/respond.js"></script>
    <%--<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>--%>

    <%--/****************************************************************************************************************************************/--%>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <link href="/Common/HtmlEdit/summernote.css" rel="stylesheet" />
    
    <script src="/Scripts/jquery-1.10.2.min.js"></script>
    <script src="/Scripts/bootstrap.min.js"></script>
    <script src="/Common/summernote/jquery-ui.min.js"></script>
    <script src="/Common/HtmlEdit/summernote-ext-print.js"></script>
    <script src="/Common/HtmlEdit/summernote.js"></script>
    <script src="/Common/HtmlEdit/summernote.min.js"></script>
    <script src="/Common/summernote/bootstrap-filestyle.min.js"></script>
    <script src="/Common/summernote/jquery.form.min.js"></script>
    <script>
        $(document).ready(function () {
            // HTML 에디터
            $('#summernote').summernote({
                height: 285,   //set editable area's height
                codemirror: { // codemirror options
                    theme: 'monokai',
                },
                defaultFontName: 'Malgun Gothic',
                toolbar: [
                            ['style', ['style']],
                            ['fontsize', ['fontsize']],
                            ['font', ['bold', 'italic', 'underline', 'clear']],
                            //['fontname', ['fontname']],
                            ['color', ['color']],
                            ['para', ['ul', 'ol', 'paragraph']],
                            ['height', ['height']],
                            ['table', ['table']],
                            ['insert', ['link', 'picture']],
                            //['view', ['fullscreen', 'codeview']],
                            //['help', ['help']],
                            ['misc', ['print']]
                ],
            });

            $('#summernote').summernote('code', $('#hidsummernote').val());
        });


        // 메일 전송 전 텍스트 값 확인
        function MailSendCheck() {
            var strTo = $.trim($('#txtemail_to').val().replaceAll(';', ''));
            if (strTo == '') {
                alert('받는분 주소를 입력해 주세요.');
                return false;
            }
            if ($('#hidfrom').val() == '') {
                alert('보내는분 주소 정보가 없습니다. 관리자에게 문의해 주세요.');
                return false;
            }

            $('#hidsummernote').val($('#summernote').summernote('code'))

            $('#btnSend').addClass('hidden');

            return true;
        }

        // 전송 후
        function callme_callback() {
            switch (parent.mailsend_obj.page) {
                case "Mail_Quotation":
                    parent.$('#ddlstatus_cd').val('84');
                    
                    parent.GetRegisterList();
                    parent.GetQuotationFileList();
                    parent.GetReportCloseList();
                    break;
                case "Mail_Register_IN":
                    break;
                case "Mail_ReportClose":
                    parent.$('#ddlmaster_status_cd').val('11');
                    parent.$('#div_invoice').removeClass('hidden');
                    parent.GetReportCloseList();
                    break;
                default:
                    break;
            }

            parent.mailsend_obj.thismodal.modal('hide');
        }
    </script>
</head>
<body style="height:660px; background-color:#fafafa !important; ">
    <form id="form1" runat="server">
        <div class="col-md-12 form-horizontal">
            <div class="form-group">
                <label for="txtemail_to" class="col-md-2 col-xs-2 control-label">To.</label>
                <div class="col-md-10 col-xs-10">
                    <asp:HiddenField ID="hidfrom" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hidsummernote" runat="server" ClientIDMode="Static" />
                    <asp:TextBox runat="server" CssClass="form-control input-sm " ID="txtemail_to" ClientIDMode="Static" />
                </div>
            </div>
            <div class="form-group">
                <label for="txtemail_cc" class="col-md-2 col-xs-2 control-label">CC.</label>
                <div class="col-md-10 col-xs-10">
                    <asp:TextBox runat="server" CssClass="form-control input-sm " ID="txtemail_cc" ClientIDMode="Static" />
                </div>
            </div>
            <div class="form-group">
                <label for="txtsubject" class="col-md-2 col-xs-2 control-label">Subject.</label>
                <div class="col-md-10 col-xs-10">
                    <asp:TextBox runat="server" CssClass="form-control input-sm " ID="txtsubject" ClientIDMode="Static" />
                </div>
            </div>
            <div class="form-group">
                <asp:FileUpload runat="server" ID="ctlupload_list" CssClass="filestyle" data-buttontext="Find file" ClientIDMode="Static" AllowMultiple="true" />
            </div>
            <div class="form-group" style="margin-bottom:0px;">
                <div id="summernote"></div>
            </div>
            <div class="form-group">
                <asp:ListBox runat="server" CssClass="form-control input-sm" style="height:45px;" id="ctlattach_list" ClientIDMode="Static">
                </asp:ListBox>
            </div>
            <div class="form-group text-center">
                <asp:Button Text="Mail Send" runat="server" CssClass="btn btn-success" ID="btnSend" Style="width: 100%;" OnClick="btnSend_Click" OnClientClick="return MailSendCheck();" />
            </div>
        </div>
    </form>
</body>
</html>
