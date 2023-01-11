<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TotoListPopup.aspx.cs" Inherits="UI_TodoList_TotoListPopup" %>

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
            alert($('#txtreg_no').val())
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:TextBox runat="server" ID="txtreg_no" CssClass="form-control input-sm" ClientIDMode="Static" />

            <ul class="nav nav-tabs" id="ulTabs">
                <li class="active"><a href="#list" data-toggle="tab" aria-expanded="true">List</a></li>
                <li class=""><a href="#detail" data-toggle="tab" aria-expanded="true">Detail</a></li>
            </ul>
            <div id="myTabContent" class="tab-content">
                <%--리스트--%>
                <div class="tab-pane fade active in" id="list">
                    <div class="panel panel-default">
                        <div class="panel-heading form-horizontal">
                            <div class="panel_serch">
                            </div>
                            <button type="button" class="btn btn-default btn-sm" id="btnAdd1">
                                <span class="glyphicon glyphicon-plus"></span>&nbsp;Add
                            </button>
                            <button type="button" class="btn btn-primary btn-sm" data-toggle="confirmation" data-popout="true" id="btnSearch">
                                <span class="glyphicon glyphicon glyphicon-search"></span>&nbsp;Search
                            </button>
                        </div>
                        <div class="panel-body pdd0">
                            <div id="grd_Master_List" style="height: 690px;" class="grd_height_size"></div>
                            <p class="panel-body-List-cnt">
                                Total :
                        <label id="lblTotal"></label>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="detail">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <button type="button" class="btn btn-default btn-sm" id="btnAdd2">
                                <span class="glyphicon glyphicon-plus"></span>&nbsp;Add
                            </button>
                            <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnSaveAs">
                                <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save As
                            </button>
                            <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnSave">
                                <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                            </button>

                        </div>
                        <div class="panel-body form-horizontal">
                            <%--form-group--%>
                            <div class="col-xs-12 layout_dtl_page">
                                <div class="form-group col-md-3 col-xs-12">
                                    <label for="txttest_id" class="control-label">■ Test ID</label>
                                    <input type="text" class="form-control input-sm" id="txttest_id" name="txttest_id" readonly="readonly" />
                                </div>
                                <div class="form-group col-md-3 col-xs-12">
                                    <label for="txttest_nm" class="control-label lbl_Vali">■ 시험항목명</label>
                                    <input type="text" class="form-control input-sm" id="txttest_nm" name="txttest_nm" />
                                </div>
                                <div class="form-group col-md-3 col-xs-12">
                                    <label for="txttest_enm" class="control-label lbl_Vali">■ 시험항목명(EN)</label>
                                    <input type="text" class="form-control input-sm" id="txttest_enm" name="txttest_enm" />
                                </div>
                                <div class="form-group col-md-3 col-xs-12">
                                    <label for="ddluse_yn" class="control-label">■ 사용</label>
                                    <asp:DropDownList ID="ddluse_yn" runat="server" name="ddluse_yn" CssClass="form-control input-sm" ClientIDMode="Static">
                                        <asp:ListItem Text="Y" Value="Y" />
                                        <asp:ListItem Text="N" Value="N" />
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group col-md-3 col-xs-12 hidden">
                                    <label for="ddlunit_id" class="control-label">■ Unit</label>
                                    <asp:DropDownList ID="ddlunit_id" runat="server" name="ddlunit_id" CssClass="form-control input-sm" ClientIDMode="Static">
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group col-md-12 col-xs-12">
                                    <label for="txtremark" class="control-label">■ 비고</label>
                                    <input type="text" class="form-control input-sm" id="txtremark" name="txtremark" />
                                </div>
                                <div class="clearfix"></div>
                                <%--<fieldset class="scheduler-border " style="margin:10px !important;">
                            <legend class="scheduler-border mgn_B5">시험 방법</legend>
                            
                        </fieldset>--%>
                                <div class="col-xs-12 mgn_T15">
                                    <ul class="nav nav-tabs" style="border-bottom: none;" id="ulTabs2">
                                        <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">UNIT 관리</a></li>
                                        <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="true">시험방법</a></li>
                                    </ul>
                                    <div id="myTabContent2" class="tab-content " style="border: 1px solid #ddd; padding: 15px;">
                                        <div class="tab-pane fade active in mgn0" id="tab_1">
                                            <div style="border: 1px solid #ddd;">
                                                <div class="text-right mgn_B5 mgn_T10">
                                                    <button type="button" class="btn btn-default btn-sm" id="btnUnitAdd" style="min-width: 1px;">
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                    </button>
                                                    <button type="button" class="btn btn-danger btn-sm" id="btnUnitDelete" style="min-width: 1px;">
                                                        <span class="glyphicon glyphicon-trash"></span>
                                                    </button>
                                                </div>
                                                <div id="grd_Unit_List" style="height: 150px; border-top: 2px solid #555" class=""></div>
                                            </div>
                                        </div>
                                        <div class="tab-pane fade  in mgn0" id="tab_2">
                                            <div style="border: 1px solid #ddd;">
                                                <div class="text-right mgn_B5 mgn_T10">
                                                    <button type="button" class="btn btn-default btn-sm" id="btnTestMethodAdd" style="min-width: 1px;">
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                    </button>
                                                    <button type="button" class="btn btn-danger btn-sm" id="btnTestMethodDelete" style="min-width: 1px;">
                                                        <span class="glyphicon glyphicon-trash"></span>
                                                    </button>
                                                </div>
                                                <div id="grd_TestMethod_List" style="height: 150px; border-top: 2px solid #555" class=""></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
