<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Popup_FileUpload.aspx.cs" Inherits="Popup_FileUpload" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/respond.js/1.4.2/respond.js"></script>
    <%--<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>--%>

    <%--/****************************************************************************************************************************************/--%>
    <script src="/Scripts/jquery-1.10.2.min.js"></script>
    <script src="/Scripts/bootstrap.min.js"></script>
    <script src="/Scripts/jquery-ui.min.js"></script>
    <script src="/Scripts/Site.js"></script>

    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <link href="/Content/Site.css" rel="stylesheet" />

    <!-- Bootstrap -->
    <script src="/Scripts/bootstrap-filestyle.min.js"></script>

    <script>
        $(document).ready(function () {
            // 멀티 체크
            if (parent.fileupload_obj.multi == true) {
                $('#file_list').attr('Multiple', 'Multiple');
            }
            else {
                $('#file_list').removeAttr('Multiple');
            }
        });

        // 업로드 후
        function callme_callback() {
            switch (parent.fileupload_obj.page) {
                case "Register_IN":
                    var Gparam = { file_nm: '<%= return_nm %>', file_url: '<%= return_url %>' }
                    parent.fileUploadBinding(Gparam);
                    break;
                case "Register_IN_Sample":
                    parent.fileUploadBinding_Sample($.parseJSON('<%= this.return_fileList %>'));
                    break;
                case "DataInput_Test":
                    parent.fileUploadBinding_Test();
                    break;
                case "Announcement":
                    parent.fileUploadBinding_file($.parseJSON('<%= this.return_fileList %>'));
                    break;
                case "Invoice":
                    var Gparam = { file_nm: '<%= return_nm %>', file_url: '<%= return_url %>' }
                    parent.fileUploadBinding(Gparam);
                    break;
                default:
                    break;
            }

            parent.fileupload_obj.filemodal.modal('hide');
        }

        // 파일의 정보를 가져와 뿌려준다.
        function fileinfo() {
            var files = $('#file_list')[0].files;

            var mb = 0;
            for (var i = 0; i < files.length; i++) {
                $('#lblfile_cnt').text(files.length);
                mb += files[i].size;
            }

            mb = (mb / 1024000);

            $('#lblfile_mb').text(mb.toFixed(2));
        }

        function SendCheck() {
            if (parseFloat($('#lblfile_mb').text()) > 4) {
                alert("파일은 최대 4MB 이하만 업로드 하시기 바랍니다.");
                return false;
            }
            $('#btnSend').addClass('hidden');
        }
    </script>
</head>
<body style="background-color: #fafafa; overflow:hidden; font-family:'Malgun Gothic';" >
    
    <form id="form1" runat="server">
        <asp:ScriptManager EnablePartialRendering="true"
            ID="ScriptManager1" runat="server">
        </asp:ScriptManager>

        <div class="col-md-12">
            <div class="form-group">
                <span><b>업로드 불가 : </b>.tiff</span><br />
                <span style="color: red;"><b>파일은 최대 4MB 이하만 업로드 하시기 바랍니다.</b></span><br />
                <span>Total File Cnt :
                    <label id="lblfile_cnt"></label>
                    &nbsp;개</span><br />
                <span>Total File MB :
                    <label id="lblfile_mb"></label>
                    &nbsp;MB</span>
            </div>
            <div class="form-group">
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <asp:FileUpload runat="server" ID="file_list" CssClass="filestyle" data-buttontext="Find file" ClientIDMode="Static" onchange="fileinfo();" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="form-group text-center">
                <asp:Button Text="File Send" runat="server" CssClass="btn btn-success" ID="btnSend" Style="width: 100%;" OnClientClick="return SendCheck();" OnClick="btnSend_Click" />
            </div>
        </div>
    </form>
</body>
</html>
