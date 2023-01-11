<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="User.aspx.cs" Inherits="UI_CM_User" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_CM/User_Service.asmx/";
        //======================================================
        // Note - 변수
        //======================================================
        var grd_Master_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var columnFilters = {};
        function filter(item) {
            for (var columnId in columnFilters) {
                if (item[columnId] == null) {
                    return false;
                }
                else {
                    if (item[columnId] != undefined && columnId != undefined && columnFilters[columnId] != "" && item[columnId].toString().toLowerCase().indexOf(columnFilters[columnId]) == -1) {
                        // 요부분 바꿔야함.
                        var c = grd_Master_List.grid.getColumns()[grd_Master_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Master_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Master_List_checkbox.getColumnDefinition(),
                { id: "NEW_YN", name: "Alert", field: "NEW_YN", cssClass: "cell-align-center", width: 60, sortable: true, formatter: GDH_TextAlertColor },
                { id: "USER_NM", name: "User Nm", field: "USER_NM", cssClass: "cell-align-left", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "USER_ENM", name: "User ENm", field: "USER_ENM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "LOGIN_ID", name: "Login Id", field: "LOGIN_ID", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "EMAIL", name: "E-Mail", field: "EMAIL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DEPT_CD1_NM", name: "Dept Nm 1", field: "DEPT_CD1_NM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DEPT_CD2_NM", name: "Dept Nm 2", field: "DEPT_CD2_NM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DEPT_CD3_NM", name: "Dept Nm 3", field: "DEPT_CD3_NM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DUTY_CD_KOR_NM", name: "Position Kr", field: "DUTY_CD_KOR_NM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "ROLE_ID_NM", name: "Role (CBKLMS)", field: "ROLE_ID_NM", cssClass: "cell-align-center", width: 120, sortable: true },
                { id: "CBKLMS_USER_GB_NM", name: "User Gb", field: "CBKLMS_USER_GB_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "CBKLMS_USER_TEAM_NM", name: "Team", field: "CBKLMS_USER_TEAM_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "CBKLMS_REMARK", name: "Remark (CBKLMS)", field: "CBKLMS_REMARK", cssClass: "cell-align-left", width: 300, sortable: true },
            ]
        };

        //======================================================
        // Note - 그리드 셋팅.
        //======================================================
        function grid_init() {
            //-------------------------------------------------------
            // 마스터 코드정의
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Master_List.grid = new Slick.Grid("#grd_Master_List", grd_Master_List.dataView, grd_Master_List.columns, grd_Master_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Master_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Master_List.grid.registerPlugin(grd_Master_List_checkbox);
            grd_Master_List.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Master_List.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Master_List.dataView.refresh();
                    $("#lblTotal").text(grd_Master_List.grid.getDataLength());//로우 토탈 건수
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Master_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Master_List.grid.render();
            });
            grd_Master_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_Master_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Master_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Master_List.grid.updateRowCount();
                grd_Master_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Master_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Master_List.grid.invalidateRows(args.rows);
                grd_Master_List.grid.render();
            });

            // Note - 클릭이벤트
            grd_Master_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                        GetUserDataDtl(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    GetUserDataDtl(row);
                    $('#ulTabs li:eq(1) a').tab('show');
                }
            });


            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            // 저장버튼
            $('#btnSave').click(function () {
                SaveUserData();
            });
            $('#btnSearch').click(function () {
                GetUserList();
            });
            $('#ddluser_gb').change(function () {
                if ($(this).val() == '04' || $(this).val() == '05') {
                    $('#ddluser_team').val('');
                    $('#ddluser_team').attr('disabled', false);
                } else {
                    $('#ddluser_team').val('');
                    $('#ddluser_team').attr('disabled', true);
                }
                
            });
            // 초반 조회
            grid_init();
            InitControls();
            GetUserList();
        })

        //======================================================
        // Note - 초반 컨트롤 값 셋팅.
        //======================================================
        function InitControls() {

            // Role Set
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "InitControls_Role",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);
                    var options = "<option value=''>" + "None...." + "</option>";
                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        for (var i = 0; i < jsonData.result.length; i++) {
                            options += "<option value='" + jsonData.result[i].ROLE_ID + "'>" + jsonData.result[i].ROLE_NM + "</option>";
                        }

                        $('#ddlrole_id').empty();
                        $('#ddlrole_id').append(options);
                    }
                },
                beforeSend: function () {
                    $('.wrap-loading').removeClass('display-none');
                },
                complete: function () {
                    $('.wrap-loading').addClass('display-none');
                },
                error: function (request, status, error) {
                    fn_error(request.responseText);
                }
            });

            $('#ddluser_gb').empty();
            $('#ddluser_gb').append(GetCMCODE_Level_New({ cd_major: "0102", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddluser_team').empty();
            $('#ddluser_team').append(GetCMCODE_Level_New({ cd_major: "0101", cd_level: '11', IsEmpty: true, Text: "ALL" }));
        }

    //======================================================
    // Note - 프로그램 상세.
    //======================================================
    function GetUserDataDtl(row) {
        $('#txtuser_id').val(row.USER_ID);
        $('#txtuser_nm').val(row.USER_NM);
        $('#txtuser_enm').val(row.USER_ENM);
        $('#txtemail').val(row.EMAIL);
        $('#txtdept1').val(row.DEPT_CD1_NM);
        $('#txtdept2').val(row.DEPT_CD2_NM);
        $('#txtdept3').val(row.DEPT_CD3_NM);
        $('#txtuser_gb').val(row.USER_GB_NM);
        $('#txtduty_cd_kr').val(row.DUTY_CD_KOR_NM);
        $('#txtduty_cd').val(row.DUTY_CD_NM);

        $('#ddlrole_id').val(row.CBKLMS_ROLE_ID);
        $('#txtremark').val(row.CBKLMS_REMARK);
        $('#ddluser_gb').val(row.CBKLMS_USER_GB);
        $('#ddluser_team').val(row.CBKLMS_USER_TEAM);

        if (row.CBKLMS_USER_GB == '04' || row.CBKLMS_USER_GB == '05') {
            $('#ddluser_team').attr('disabled', false);
        } else {
            $('#ddluser_team').attr('disabled', true);
        }
    }

    //======================================================
    // Note - 프로그램 저장.
    //======================================================
    function SaveUserData() {
        var Gparam = {
                IV_SELECT_USER_ID: $('#txtuser_id').val(),
                IV_ROLE_ID: $('#ddlrole_id').val(),
                IV_USER_GB: $('#ddluser_gb').val(),
                IV_USER_TEAM: $('#ddluser_team').val(),
                IV_REMARK: $('#txtremark').val(),
                IV_USER_ID: '<%= this.CkUserId %>'
        };
        if (Gparam.IV_SELECT_USER_ID == '') {
            fn_info('[ User Id ] Please enter...');
            return;
        }
            if (Gparam.IV_ROLE_ID == '') {
                fn_info('[ Role Id ] Please enter...');
                return;
            }
            if (Gparam.IV_USER_GB == '') {
                fn_info('[ User Gb ] Please enter...');
                return;
            }

            $.ajax({
                url: ServiceUrl + "SaveUserData",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ulTabs li:eq(0) a').tab('show');
                        GetUserList();
                    }
                    else {
                        fn_error(result.OV_RTN_MSG);
                    }
                },
                beforeSend: function () {
                    $('.wrap-loading').removeClass('display-none');
                },
                complete: function () {
                    $('.wrap-loading').addClass('display-none');
                },
                error: function (request, status, error) {
                    fn_error("Error Message:" + request.responseText);
                }
            });
        }

        //======================================================
        // Note - 프로그램 리스트
        //======================================================
        function GetUserList() {
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
        };
        $.ajax({
            url: ServiceUrl + "GetUserList",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({ "Gparam": Gparam }),
            dataType: "json",
            success: function (response) {
                fn_ClearGrid(grd_Master_List);

                // Note - Json개체 변환
                var jsonData = $.parseJSON(response.d);

                // Note - Json개체 생성 유무 확인
                if (jsonData != null) {
                    // Note - Customer Information
                    grd_Master_List.dataView.beginUpdate();
                    grd_Master_List.dataView.setItems(jsonData.result);
                    grd_Master_List.dataView.setFilter(filter);
                    grd_Master_List.dataView.endUpdate();
                    grd_Master_List.grid.render();

                    $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수
                }
            },
            beforeSend: function () {
                $('.wrap-loading').removeClass('display-none');
            },
            complete: function () {
                $('.wrap-loading').addClass('display-none');
            },
            error: function (request, status, error) {
                fn_error(request.responseText);
            }
        });
    }

    </script>

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
                    <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>

                </div>
                <div class="panel-body form-horizontal">
                    <%--form-group--%>
                    <div class="col-xs-12 layout_dtl_page">
                        <fieldset class="scheduler-border ">
                            <legend class="scheduler-border">User information</legend>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtuser_id" class="control-label">■ User Id</label>
                                <input type="text" class="form-control input-sm" id="txtuser_id" name="txtuser_id" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtuser_nm" class="control-label">■ User Nm</label>
                                <input type="text" class="form-control input-sm" id="txtuser_nm" name="txtuser_nm" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtuser_enm" class="control-label">■ User ENm</label>
                                <input type="text" class="form-control input-sm" id="txtuser_enm" name="txtuser_enm" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtemail" class="control-label">■ eMail</label>
                                <input type="text" class="form-control input-sm" id="txtemail" name="txtemail" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtdept1" class="control-label">■ Dept 1</label>
                                <input type="text" class="form-control input-sm" id="txtdept1" name="txtdept1" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtdept2" class="control-label">■ Dept 2</label>
                                <input type="text" class="form-control input-sm" id="txtdept2" name="txtdept2" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtdept3" class="control-label">■ Dept 3</label>
                                <input type="text" class="form-control input-sm" id="txtdept3" name="txtdept3" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtuser_gb" class="control-label">■ Employee type</label>
                                <input type="text" class="form-control input-sm" id="txtuser_gb" name="txtuser_gb" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtduty_cd_kr" class="control-label">■ Position Kr</label>
                                <input type="text" class="form-control input-sm" id="txtduty_cd_kr" name="txtduty_cd_kr" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtduty_cd" class="control-label">■ Position En</label>
                                <input type="text" class="form-control input-sm" id="txtduty_cd" name="txtduty_cd" readonly="readonly" />
                            </div>
                        </fieldset>
                        <fieldset class="scheduler-border ">
                            <legend class="scheduler-border">User Data</legend>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="ddlrole_id" class="control-label lbl_Vali">■ Role Id</label>
                                <asp:DropDownList ID="ddlrole_id" runat="server" name="ddlrole_id" CssClass="form-control input-sm" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="ddlrole_id" class="control-label lbl_Vali">■ User Gb</label>
                                <asp:DropDownList ID="ddluser_gb" runat="server" name="ddluser_gb" CssClass="form-control input-sm" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="ddlrole_id" class="control-label">■ Team</label>
                                <asp:DropDownList ID="ddluser_team" runat="server" name="ddluser_team" CssClass="form-control input-sm" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtremark" class="control-label">■ Remark</label>
                                <input type="text" class="form-control input-sm" id="txtremark" name="txtremark" />
                            </div>
                        </fieldset>
                    </div>

                </div>
            </div>
        </div>
    </div>

</asp:Content>

