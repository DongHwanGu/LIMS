<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Role_Program.aspx.cs" Inherits="UI_CM_Role_Program" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_CM/Role_Program_Service.asmx/";
        //======================================================
        // Note - 변수
        //======================================================
        var grd_Role_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Role_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: default_options,
            columns: [
                grd_Role_List_checkbox.getColumnDefinition(),
                { id: "ROLE_ID", name: "Role Id", field: "ROLE_ID", cssClass: "cell-align-center", width: 100, sortable: false },
                { id: "ROLE_NM", name: "Role Nm", field: "ROLE_NM", cssClass: "cell-align-left", width: 150, sortable: false },
                { id: "USE_YN", name: "Use Yn", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: false },
                { id: "ROLE_DESC", name: "Desc", field: "ROLE_DESC", cssClass: "cell-align-left", width: 150, sortable: false },
                { id: "ACTIVE_CNT", name: "Cnt", field: "ACTIVE_CNT", cssClass: "cell-align-center", width: 80, sortable: false }
            ]
        };
        var grd_RleAndProgram_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_RleAndProgram_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: default_options,
            columns: [
                grd_RleAndProgram_List_checkbox.getColumnDefinition(),
                { id: "PROGRAM_ID", name: "Program Id", field: "PROGRAM_ID", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "PROGRAM_NM", name: "Program Nm", field: "PROGRAM_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "PROGRAM_LVL", name: "Level", field: "PROGRAM_LVL", cssClass: "cell-align-center", width: 50, sortable: true },
                { id: "UP_PROGRAM_ID", name: "Up_Program Id", field: "UP_PROGRAM_ID", cssClass: "cell-align-center", width: 90, sortable: true },
                { id: "ROLE_ID", name: "Role Id", field: "ROLE_ID", cssClass: "cell-align-center", width: 90, sortable: true },
                { id: "USE_YN", name: "Use Yn", field: "USE_YN", cssClass: "cell-align-center", width: 90, sortable: true }
            ]
        };

        var grd_Modal_Program_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Modal_Program_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: default_options,
            columns: [
                grd_Modal_Program_List_checkbox.getColumnDefinition(),
                { id: "PROGRAM_ID", name: "Program Id", field: "PROGRAM_ID", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "PROGRAM_NM", name: "Program Nm", field: "PROGRAM_NM", cssClass: "cell-align-left", width: 400, sortable: true },
                { id: "PROGRAM_LVL", name: "Level", field: "PROGRAM_LVL", cssClass: "cell-align-center", width: 50, sortable: true },
                { id: "UP_PROGRAM_ID", name: "Up_Program Id", field: "UP_PROGRAM_ID", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "PROGRAM_VIEW", name: "Veiw (aspx)", field: "PROGRAM_VIEW", cssClass: "cell-align-center", width: 120, sortable: true },
                { id: "PROGRAM_CONTROLLER", name: "Veiw (Directory)", field: "PROGRAM_CONTROLLER", cssClass: "cell-align-center", width: 120, sortable: true }
            ]
        };

        //======================================================
        // Note - 그리드 설정을 정의한다.
        //======================================================
        function grid_init() {
            //-------------------------------------------------------
            // 마스터 코드정의
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Role_List.grid = new Slick.Grid("#grd_Role_List", grd_Role_List.dataView, grd_Role_List.columns, grd_Role_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Role_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Role_List.grid.registerPlugin(grd_Role_List_checkbox);
            grd_Role_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Role_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Role_List.grid.updateRowCount();
                grd_Role_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Role_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Role_List.grid.invalidateRows(args.rows);
                grd_Role_List.grid.render();
            });

            // Note - 클릭이벤트
            grd_Role_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_Role_List.grid.getDataItem(args.row);
                if (row != null) {
                    SetRoleData(row);
                }
            });
            // Note - 더블클릭이벤트
            grd_Role_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Role_List.grid.getDataItem(args.row);
                if (row != null) {
                    SetRoleData(row);
                }
            });

            grd_Role_List.grid.init();

            //-------------------------------------------------------
            // Sub 코드정의
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_RleAndProgram_List.grid = new Slick.Grid("#grd_RleAndProgram_List", grd_RleAndProgram_List.dataView, grd_RleAndProgram_List.columns, grd_RleAndProgram_List.options);
            // Note - Row 선택시 배경색 반전
            grd_RleAndProgram_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_RleAndProgram_List.grid.registerPlugin(grd_RleAndProgram_List_checkbox);
            grd_RleAndProgram_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_RleAndProgram_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_RleAndProgram_List.grid.updateRowCount();
                grd_RleAndProgram_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_RleAndProgram_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_RleAndProgram_List.grid.invalidateRows(args.rows);
                grd_RleAndProgram_List.grid.render();
            });

            // Note - 클릭이벤트
            grd_RleAndProgram_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_RleAndProgram_List.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                        SetCmcodeData('Sub', row);
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_RleAndProgram_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_RleAndProgram_List.grid.getDataItem(args.row);
                if (row != null) {
                    SetCmcodeData('Sub', row);
                }
            });

            grd_RleAndProgram_List.grid.init();

            //-------------------------------------------------------
            // Modal Program List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Modal_Program_List.grid = new Slick.Grid("#grd_Modal_Program_List", grd_Modal_Program_List.dataView, grd_Modal_Program_List.columns, grd_Modal_Program_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Modal_Program_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Modal_Program_List.grid.registerPlugin(grd_Modal_Program_List_checkbox);
            grd_Modal_Program_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Modal_Program_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Modal_Program_List.grid.updateRowCount();
                grd_Modal_Program_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Modal_Program_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Modal_Program_List.grid.invalidateRows(args.rows);
                grd_Modal_Program_List.grid.render();
            });

            // Note - 클릭이벤트
            grd_Modal_Program_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_Modal_Program_List.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                        SetCmcodeData('Sub', row);
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Modal_Program_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Modal_Program_List.grid.getDataItem(args.row);
                if (row != null) {
                    SetCmcodeData('Sub', row);
                }
            });

            grd_Modal_Program_List.grid.init();
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(document).ready(function () {
            fn_ClearControls($('#detail'));

            grid_init();
            GetRoleList();
            // 버튼 이벤트
            $('#btnSearch').click(function () {
                GetRoleList();
                fn_ClearGrid(grd_RleAndProgram_List);
            });
            $('#btnRoleAdd').click(function () {
                grd_Role_List.grid.setSelectedRows([]);
                $('#txtrole_id').val('');
                $('#txtrole_nm').val('');
                $('#ddlUse_YN').val('Y');
                $('#txtrole_desc').val('');
                fn_ClearGrid(grd_RleAndProgram_List);
            });

            $('#btnRoleSave').click(function () {
                SaveRoleData();
            });
            $('#btnRoleProgramAdd').click(function () {
                GetModalProgramList();
            });
            $('#btnRoleProgramSave').click(function () {
                SaveModalProgramList();
            });
            $('#btnRoleProgramDelete').click(function () {
                DeleteModalProgramList();
            });

            $('#modalProgram').on('shown.bs.modal', function (e) { grd_Modal_Program_List.grid.resizeCanvas(); });
        });

        //======================================================
        // Note - 권한별 프로그램을 삭제 합니다.
        //======================================================
        function DeleteModalProgramList() {
            var row = grd_Role_List.grid.getSelectedRows()[0];
            var programDatas = [];

            if (grd_RleAndProgram_List.grid.getSelectedRows().length == 0) {
                fn_info('Do not delete the data.');
                return;
            }
            else {
                var gridData = grd_RleAndProgram_List.grid.getSelectedRows();

                for (var i = 0; i < gridData.length; i++) {
                    var program_id = grd_RleAndProgram_List.grid.getDataItem(gridData[i])["PROGRAM_ID"];

                    programDatas[i] = {
                        IV_PROGRAM_ID: program_id,
                        IV_ROLE_ID: $('#txtrole_id').val()
                    };
                }

                $.ajax({
                    url: ServiceUrl + "DeleteModalProgramList",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ "programDatas": programDatas }),
                    dataType: "json",
                    success: function (response) {
                        var result = response.d;

                        if (result.OV_RTN_CODE == "0") {
                            //선택된 checkbox 선택 취소
                            grd_RleAndProgram_List.grid.setSelectedRows([]);
                            // 다시 조회
                            grd_Role_List.grid.setSelectedRows([row]);
                            SetRoleData(grd_Role_List.grid.getDataItem(row));
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
        }

        //======================================================
        // Note - 모달 프로그램 리스트 저장
        //======================================================
        function SaveModalProgramList() {
            var row = grd_Role_List.grid.getSelectedRows()[0];

            var programDatas = [];

            if (grd_Modal_Program_List.grid.getSelectedRows().length == 0) {
                fn_info('Do not Save the data.');
                return;
            }
            else {
                var gridData = grd_Modal_Program_List.grid.getSelectedRows();

                for (var i = 0; i < gridData.length; i++) {
                    var program_id = grd_Modal_Program_List.grid.getDataItem(gridData[i])["PROGRAM_ID"];

                    programDatas[i] = {
                        IV_ROLE_ID: $('#txtrole_id').val(),
                        IV_PROGRAM_ID: program_id,
                        IV_USER_ID:'<%= this.CkUserId %>'
                    };
                }

                $.ajax({
                    url: ServiceUrl + "SaveModalProgramList",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ "programDatas": programDatas }),
                    dataType: "json",
                    success: function (response) {
                        var result = response.d;

                        if (result.OV_RTN_CODE == "0") {
                            //선택된 checkbox 선택 취소
                            grd_Modal_Program_List.grid.setSelectedRows([]);
                            $('#modalProgram').modal('hide');

                            // 다시 조회
                            grd_Role_List.grid.setSelectedRows([row]);
                            SetRoleData(grd_Role_List.grid.getDataItem(row));
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
        }

        //======================================================
        // Note - 모달 프로그램 리스트
        //======================================================
        function GetModalProgramList() {
            var Gparam = {
                IV_ROLE_ID: $('#txtrole_id').val()
            };

            if ($('#txtrole_id').val() == '') {
                fn_info('This Role has not been checked.');
                return;
            }

            $('#modalProgram').modal();

            $.ajax({
                url: ServiceUrl + "GetModalProgramList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ 'Gparam': Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Modal_Program_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Modal_Program_List.dataView.beginUpdate();
                        grd_Modal_Program_List.dataView.setItems(jsonData.result);
                        grd_Modal_Program_List.dataView.endUpdate();
                        grd_Modal_Program_List.grid.render();
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

        //======================================================
        // Note - 권한 정보 디테일
        //======================================================
        function SetRoleData(row) {
            $('#btnSaveAs').removeClass('hidden');

            $('#txtrole_id').val(row.ROLE_ID);
            $('#txtrole_nm').val(row.ROLE_NM);
            document.getElementById("<%= ddlUse_YN.ClientID%>").value = row.USE_YN;
            $('#txtrole_desc').val(row.ROLE_DESC);

            GetRoleProgramList(row.ROLE_ID);
        }

        //======================================================
        // Note - 권한에 따른 프로그램 리스트
        //======================================================
        function GetRoleProgramList(role_id) {
            var Gparam = {
                IV_ROLE_ID: role_id
            };

            $.ajax({
                url: ServiceUrl + "GetRoleProgramList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ 'Gparam': Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_RleAndProgram_List);
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_RleAndProgram_List.dataView.beginUpdate();
                        grd_RleAndProgram_List.dataView.setItems(jsonData.result);
                        grd_RleAndProgram_List.dataView.endUpdate();
                        grd_RleAndProgram_List.grid.render();
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

        //======================================================
        // Note - 권한 저장.
        //======================================================
        function SaveRoleData() {
            var roleData = {
                IV_ROLE_ID: $('#txtrole_id').val(),
                IV_ROLE_NM: $('#txtrole_nm').val(),
                IV_USE_YN: document.getElementById("<%= ddlUse_YN.ClientID%>").value,
                IV_ROLE_DESC: $('#txtrole_desc').val(),
                IV_USER_ID: '<%= this.CkUserId %>'
            };

            if (roleData.IV_ROLE_NM == '') {
                fn_info('[ Role NM ] Please enter...');
                return;
            }

            $.ajax({
                url: ServiceUrl + "SaveRoleData",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ 'roleData': roleData }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#txtrole_id').val('');
                        $('#txtrole_nm').val('');
                        $('#ddlUse_YN').val('Y');
                        $('#txtrole_desc').val('');

                        GetRoleList();
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
                    fn_error(request.responseText);
                }
            });
        }

        //======================================================
        // Note - 권한 리스트
        //======================================================
        function GetRoleList() {
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GerRoleList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Role_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Role_List.dataView.beginUpdate();
                        grd_Role_List.dataView.setItems(jsonData.result);
                        grd_Role_List.dataView.endUpdate();
                        grd_Role_List.grid.render();

                        if (grd_Role_List.grid.getDataLength() > 0) {
                            grd_Role_List.grid.setSelectedRows([0]);
                            SetRoleData(grd_Role_List.grid.getDataItem(0));
                        }
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

    <div class="panel panel-default">
        <div class="panel-heading form-horizontal">
            <button type="button" class="btn btn-primary btn-sm" data-toggle="confirmation" data-popout="true" id="btnSearch">
                <span class="glyphicon glyphicon glyphicon-search"></span>&nbsp;Search
            </button>
        </div>
        <div class="panel-body pdd0">
            <div class="layout_dtl_page mgn_T15">
                <div class="col-md-6 col-xs-12">
                    <fieldset class="scheduler-border" >
                        <legend class="scheduler-border">Role Settings</legend>
                        <div class="form-group text-right" style="margin-bottom: 25px;">
                        </div>
                        <div style="border: 1px solid #ddd;">
                            <div id="grd_Role_List" style="height: 338px;" class=""></div>
                        </div>
                        <div class="form-group text-right mgn_T15">
                            <button type="button" class="btn btn-default btn-sm" id="btnRoleAdd">
                                <span class="glyphicon glyphicon-plus"></span>&nbsp;Add
                            </button>
                            <button type="button" class="btn btn-success btn-sm" id="btnRoleSave">
                                <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                            </button>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="txtrole_id" class="control-label">■ Role Id</label>
                            <input type="text" class="form-control input-sm " id="txtrole_id" name="txtrole_id" disabled="disabled" />
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="txtrole_nm" class="control-label lbl_Vali ">■ Role Nm</label>
                            <input type="text" class="form-control input-sm " id="txtrole_nm" name="txtrole_nm" />
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="ddlUse_YN" class="control-label">■ Use Yn</label>
                            <asp:DropDownList ID="ddlUse_YN" runat="server" name="ddlUse_YN" CssClass="form-control input-sm" ClientIDMode="Static">
                                <asp:ListItem Text="Y" Value="Y" />
                                <asp:ListItem Text="N" Value="N" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="txtrole_desc" class="control-label">■ Desc</label>
                            <input type="text" class="form-control input-sm " id="txtrole_desc" name="txtrole_desc" />
                        </div>

                    </fieldset>
                </div>
                <div class="col-md-6 col-xs-12">
                    <fieldset class="scheduler-border">
                        <legend class="scheduler-border">Role-Specific Programs</legend>
                        <div class="form-group text-right" style="margin-bottom: 25px;">
                            <button type="button" class="btn btn-default btn-sm" id="btnRoleProgramAdd">
                                <span class="glyphicon glyphicon-plus"></span>&nbsp;Add
                            </button>
                            <button type="button" class="btn btn-danger btn-sm" data-toggle="confirmation" data-popout="true" id="btnRoleProgramDelete">
                                <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Delete
                            </button>
                        </div>
                        <div style="border: 1px solid #ddd;">
                            <div id="grd_RleAndProgram_List" style="height: 660px;" class=""></div>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
    </div>

    <%--***********************************************************************************************/
/* Role 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalProgram" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Program List</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnRoleProgramSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <div id="grd_Modal_Program_List" style="height: 600px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
</asp:Content>

