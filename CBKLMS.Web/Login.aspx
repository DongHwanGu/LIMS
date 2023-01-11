<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <title>CBKLMS</title>

    <!-- Bootstrap -->
    <link href="/Common/gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="/Common/gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <!-- NProgress -->
    <%--<link href="/Common/gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet" />--%>
    <!-- Animate.css -->
    <link href="/Common/gentelella-master/vendors/animate.css/animate.min.css" rel="stylesheet" />

    <!-- Custom Theme Style -->
    <link href="/Common/gentelella-master/build/css/custom.css" rel="stylesheet" />
    <link href="/Content/Site.css" rel="stylesheet" />
    <script src="Scripts/jquery-1.10.2.min.js"></script>
      <script>
          /***************************************************/
          // Page Load 
          /***************************************************/
          $(document).ready(function () {
              
          });

          // Login 값 체크 후 서버 호출.
          function LoginCheck() {
              var id = $('#txtLoginId_login').val().trim();
              var pw = $('#txtPassword_login').val();

              if (id == '') {
                  alert('아이디를 입력하여 주십시오.');
                  //$("#loginfrm .row").effect("shake");
                  return false;
              }
              else if (pw == '') {
                  alert('비밀번호를 입력하여 주십시오.');
                  //$("#loginfrm .row").effect("shake");
                  return false;
              }
          }
    </script>
</head>
<body class="login" 
    style="
        background-image: url('/Common/Images/Login/Testing_Lab.jpg');
        background-repeat: no-repeat;
        background-attachment: fixed;
        background-size: 100% 100%;
    "
>
    <div>
        <a class="hiddenanchor" id="signup"></a>
        <a class="hiddenanchor" id="signin"></a>

        <div class="login_wrapper" >
            <div class="animate form login_form" style="border:2px solid #fafafa; padding:15px;">
                <section class="login_content">
                    <form runat="server">
                        <h1 style="font-weight:bold;">e-Works_CBK</h1>
                        <div>
                            <input type="text" class="form-control" placeholder="ID" required="" runat="server" id="txtLoginId_login" />
                        </div>
                        <div>
                            <input type="password" class="form-control" placeholder="Password" required="" runat="server" id="txtPassword_login" />
                        </div>
                        <div>
                            <input runat="server" type="checkbox" id="chkID" /> <label for="chkID" style="color:white">Remember Me</label>
                        </div>
                        <div>
                            <asp:Button ID="btnLoginButton" CssClass="btn btn-success submit" Text="Login" style="margin:15px 0 0 0; border:none; width: 100%; font-weight:bold; background:#fdc501; font-size:1.3em; color:#010101;" runat="server"
                                OnClientClick="return LoginCheck();" OnClick="btnLoginButton_Click" />
                        </div>
                    </form>
                </section>
            </div>
        </div>
    </div>
</body>
</html>
