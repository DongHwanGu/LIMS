<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CommonCode.aspx.cs" Inherits="UI_CM_CommonCode" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_CM/CommonCode_Service.asmx/";
        //======================================================
        // Note - 변수
        //======================================================
        var grd_Master_Code_checkbox = new Slick.CheckboxSelectColumn({
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
                        var c = grd_Master_Code.grid.getColumns()[grd_Master_Code.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Master_Code = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Master_Code_checkbox.getColumnDefinition(),
                { id: "CD_MAJOR", name: "Cd Major", field: "CD_MAJOR", cssClass: "cell-align-center", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CD_MINOR", name: "Cd Minor", field: "CD_MINOR", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_FNAME", name: "Cd Fname", field: "CD_FNAME", cssClass: "cell-align-left", width: 300, sortable: true },
                { id: "CD_FR_MINOR", name: "Fr Minor", field: "CD_FR_MINOR", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_ORDER", name: "Seq", field: "CD_ORDER", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_SNAME", name: "Cd SName", field: "CD_SNAME", cssClass: "cell-align-left", width: 300, sortable: true },
                { id: "CD_USE_YN", name: "User Yn", field: "CD_USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_SE_MINOR", name: "Se Minor", field: "CD_SE_MINOR", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_LEVEL", name: "Cd Level", field: "CD_LEVEL", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_REF1", name: "Ref 1", field: "CD_REF1", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_REF2", name: "Ref 2", field: "CD_REF2", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_REF3", name: "Ref 3", field: "CD_REF3", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_REF4", name: "Ref 4", field: "CD_REF4", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_PROPERTY", name: "Property", field: "CD_PROPERTY", cssClass: "cell-align-center", width: 100, sortable: true }
            ]
        };
        var grd_Sub_Code_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var columnFilters_sub = {};
        function filter_sub(item) {
            for (var columnId in columnFilters_sub) {
                if (item[columnId] == null) {
                    return false;
                }
                else {
                    if (item[columnId] != undefined && columnId != undefined && columnFilters_sub[columnId] != "" && item[columnId].toString().toLowerCase().indexOf(columnFilters_sub[columnId]) == -1) {
                        // 요부분 바꿔야함.
                        var c = grd_Sub_Code.grid.getColumns()[grd_Sub_Code.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters_sub[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Sub_Code = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Sub_Code_checkbox.getColumnDefinition(),
                { id: "CD_MAJOR", name: "Cd Major", field: "CD_MAJOR", cssClass: "cell-align-center", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CD_MINOR", name: "Cd Minor", field: "CD_MINOR", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_FNAME", name: "Cd Fname", field: "CD_FNAME", cssClass: "cell-align-left", width: 300, sortable: true },
                { id: "CD_FR_MINOR", name: "Fr Minor", field: "CD_FR_MINOR", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_ORDER", name: "Seq", field: "CD_ORDER", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_SNAME", name: "Cd SName", field: "CD_SNAME", cssClass: "cell-align-left", width: 300, sortable: true },
                { id: "CD_USE_YN", name: "User Yn", field: "CD_USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_SE_MINOR", name: "Se Minor", field: "CD_SE_MINOR", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_LEVEL", name: "Cd Level", field: "CD_LEVEL", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_REF1", name: "Ref 1", field: "CD_REF1", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_REF2", name: "Ref 2", field: "CD_REF2", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_REF3", name: "Ref 3", field: "CD_REF3", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_REF4", name: "Ref 4", field: "CD_REF4", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CD_PROPERTY", name: "Property", field: "CD_PROPERTY", cssClass: "cell-align-center", width: 100, sortable: true }
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
            grd_Master_Code.grid = new Slick.Grid("#grd_Master_Code", grd_Master_Code.dataView, grd_Master_Code.columns, grd_Master_Code.options);
            // Note - Row 선택시 배경색 반전
            grd_Master_Code.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Master_Code.grid.registerPlugin(grd_Master_Code_checkbox);
            grd_Master_Code.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Master_Code.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Master_Code.dataView.refresh();
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Master_Code.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Master_Code.grid.render();
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Master_Code.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Master_Code.grid.updateRowCount();
                grd_Master_Code.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Master_Code.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Master_Code.grid.invalidateRows(args.rows);
                grd_Master_Code.grid.render();
            });

            // Note - 클릭이벤트
            grd_Master_Code.grid.onClick.subscribe(function (e, args) {
                var row = grd_Master_Code.grid.getDataItem(args.row);
                if (row != null) {
                    GetSubCodeList(row);
                }
                if (args.cell == '1') {
                    if (row != null) {
                        SetCmcodeData('Master', row);

                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_Code.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_Code.grid.getDataItem(args.row);
                if (row != null) {
                    SetCmcodeData('Master', row);
                }
            });

            grd_Master_Code.grid.init();

            //-------------------------------------------------------
            // Sub 코드정의
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Sub_Code.grid = new Slick.Grid("#grd_Sub_Code", grd_Sub_Code.dataView, grd_Sub_Code.columns, grd_Sub_Code.options);
            // Note - Row 선택시 배경색 반전
            grd_Sub_Code.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Sub_Code.grid.registerPlugin(grd_Sub_Code_checkbox);
            grd_Sub_Code.grid.setSelectedRows([]);


            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Sub_Code.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters_sub[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Sub_Code.dataView.refresh();
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Sub_Code.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters_sub[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Sub_Code.grid.render();
            });


            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Sub_Code.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Sub_Code.grid.updateRowCount();
                grd_Sub_Code.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Sub_Code.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Sub_Code.grid.invalidateRows(args.rows);
                grd_Sub_Code.grid.render();
            });

            // Note - 클릭이벤트
            grd_Sub_Code.grid.onClick.subscribe(function (e, args) {
                var row = grd_Sub_Code.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                        SetCmcodeData('Sub', row);
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Sub_Code.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Sub_Code.grid.getDataItem(args.row);
                if (row != null) {
                    SetCmcodeData('Sub', row);
                }
            });

            grd_Sub_Code.grid.init();
        }
        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(document).ready(function () {
            fn_ClearControls($('#detail'));
            $('#txtcd_order').val('1');

            grid_init();
            GetMasterCodeList();

            fn_ClearControls($('#detail'));
            $('#txtcd_order').val('1');
            // 버튼 이벤트
            $('#btnAdd1, #btnAdd2').click(function () {
                fn_ClearControls($('#detail'));
                $('#ulTabs li:eq(1) a').tab('show');
                $('#txtcd_order').val('1');
            });
            $('#btnSave').click(function () {
                SaveCmcodeData();
            });
        });
        //======================================================
        // Note - 코드 저장
        //======================================================
        function SaveCmcodeData() {
            var Gparam = {
                IV_CD_MAJOR: $('#txtcd_major').val(),
                IV_CD_MINOR: $('#txtcd_minor').val(),
                IV_CD_USE_YN: document.getElementById("<%= ddlUse_YN.ClientID%>").value,
                IV_CD_FNAME: $('#txtcd_fname').val(),
                IV_CD_SNAME: $('#txtcd_sname').val(),
                IV_CD_FR_MINOR: $('#txtcd_fr_minor').val(),
                IV_CD_SE_MINOR: $('#txtcd_se_minor').val(),
                IV_CD_LEVEL: $('#txtcd_level').val(),
                IV_CD_ORDER: $('#txtcd_order').val(),
                IV_CD_REF1: $('#txtcd_ref1').val(),
                IV_CD_REF2: $('#txtcd_ref2').val(),
                IV_CD_REF3: $('#txtcd_ref3').val(),
                IV_CD_REF4: $('#txtcd_ref4').val(),
                IV_CD_PROPERTY: $('#txtcd_property').val(),
                IV_USER_ID: '<%= this.CkUserId %>'
            };
            if (Gparam.IV_CD_MAJOR == '') {
                fn_info('[ Cd Major ] Please enter...');
                return;
            }
            if (Gparam.IV_CD_MINOR == '') {
                fn_info('[ Cd Minor ] Please enter...');
                return;
            }
            if (Gparam.IV_CD_FNAME == '') {
                fn_info('[ Cd Fname ] Please enter...');
                return;
            }
            if (Gparam.IV_CD_SNAME == '') {
                fn_info('[ Cd Sname ] Please enter...');
                return;
            }
            if (Gparam.IV_CD_LEVEL == '') {
                fn_info('[ Cd Level ] Please enter...');
                return;
            }
            if (Gparam.IV_CD_ORDER == '') {
                fn_info('[ Seq ] Please enter...');
                return;
            }

            $.ajax({
                url: ServiceUrl + "SaveCmcodeData",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        fn_info('Save Success.');

                        GetMasterCodeList();
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
        // Note - 상세정보 바인딩
        //======================================================
        function SetCmcodeData(callGb, row) {
            $('#ulTabs li:eq(1) a').tab('show');
            fn_ClearControls($('#detail'));

            $('#txtcd_major').val(row.CD_MAJOR);
            $('#txtcd_minor').val(row.CD_MINOR);
            document.getElementById("<%= ddlUse_YN.ClientID%>").value = row.CD_USE_YN;
            $('#txtcd_fname').val(row.CD_FNAME);
            $('#txtcd_sname').val(row.CD_SNAME);
            $('#txtcd_fr_minor').val(row.CD_FR_MINOR);
            $('#txtcd_se_minor').val(row.CD_SE_MINOR);
            $('#txtcd_level').val(row.CD_LEVEL);
            $('#txtcd_order').val(row.CD_ORDER);
            $('#txtcd_ref1').val(row.CD_REF1);
            $('#txtcd_ref2').val(row.CD_REF2);
            $('#txtcd_ref3').val(row.CD_REF3);
            $('#txtcd_ref4').val(row.CD_REF4);
            $('#txtcd_property').val(row.CD_PROPERTY);
        }

        //======================================================
        // Note - 마스터 코드 가져오기.
        //======================================================
        function GetMasterCodeList() {
            var Gparam = {
                IV_USER_ID : '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetMasterCodeList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ 'Gparam': Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Master_Code);
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Master_Code.dataView.beginUpdate();
                        grd_Master_Code.dataView.setItems(jsonData.result);
                        grd_Master_Code.dataView.setFilter(filter);
                        grd_Master_Code.dataView.endUpdate();
                        grd_Master_Code.grid.render();

                        grd_Master_Code.grid.setSelectedRows([0]);
                        GetSubCodeList(grd_Master_Code.grid.getDataItem(0));
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
        // Note - Sub 코드 가져오기.
        //======================================================
        function GetSubCodeList(row) {
            if (row == null) {
                return;
            }
            var Gparam = {
                IV_CD_MAJOR: row.CD_MAJOR
            };

            $.ajax({
                url: ServiceUrl + "GetSubCodeList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ 'Gparam': Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Sub_Code);
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Sub_Code.dataView.beginUpdate();
                        grd_Sub_Code.dataView.setItems(jsonData.result);
                        grd_Sub_Code.dataView.setFilter(filter_sub);
                        grd_Sub_Code.dataView.endUpdate();
                        grd_Sub_Code.grid.render();
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
                    <button type="button" class="btn btn-default btn-sm" id="btnAdd1">
                        <span class="glyphicon glyphicon-plus"></span>&nbsp;Add
                    </button>
                    <button type="button" class="btn btn-primary btn-sm" data-toggle="confirmation" data-popout="true" id="btnSearch">
                        <span class="glyphicon glyphicon glyphicon-search"></span>&nbsp;Search
                    </button>
                </div>
                <div class="col-md-6 col-xs-12">
                    <fieldset class="scheduler-border" style="margin: 10px 0 0 0 !important;">
                        <legend class="scheduler-border">Master Code</legend>
                        <div style="border: 1px solid #ddd;">
                            <div id="grd_Master_Code" style="height: 630px;" class="grd_height_size"></div>
                            <p class="panel-body-List-cnt">
                                Total :
                                <label id="lblTotal"></label>
                            </p>
                        </div>
                    </fieldset>
                </div>
                <div class="col-md-6 col-xs-12">
                    <fieldset class="scheduler-border" style="margin: 10px 0 0 0 !important;">
                        <legend class="scheduler-border">Sub Code</legend>
                        <div style="border: 1px solid #ddd;">
                            <div id="grd_Sub_Code" style="height: 630px;" class="grd_height_size"></div>
                            <p class="panel-body-List-cnt">
                                Total :
                                <label id="lblTotal_Sub"></label>
                            </p>
                        </div>
                    </fieldset>
                </div>
            </div>
    </div>
    <div class="tab-pane fade" id="detail">
        <div class="panel panel-default">
            <div class="panel-heading">
                <button type="button" class="btn btn-default btn-sm" id="btnAdd2">
                    <span class="glyphicon glyphicon-plus"></span>&nbsp;Add
                </button>
                <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnSave">
                    <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                </button>
            </div>
            <div class="panel-body form-horizontal">
                <%--form-group--%>
                <div class="col-md-12">
                    <fieldset class="scheduler-border ">
                        <legend class="scheduler-border">Master data</legend>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_major" class="control-label lbl_Vali">■ Cd Major</label>
                            <input type="text" class="form-control input-sm " id="txtcd_major" name="txtcd_major" maxlength="4"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_minor" class="control-label lbl_Vali">■ Cd Minor</label>
                            <input type="text" class="form-control input-sm " id="txtcd_minor" name="txtcd_minor" maxlength="2"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="ddlUse_YN" class="control-label ">■ User Yn</label>
                            <asp:DropDownList ID="ddlUse_YN" runat="server" name="ddlUse_YN" CssClass="form-control input-sm">
                                <asp:ListItem Text="Y" Value="Y" />
                                <asp:ListItem Text="N" Value="N" />
                            </asp:DropDownList>
                        </div>
                        <div class="clearfix"></div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_fname" class="control-label lbl_Vali ">■ Cd Fname</label>
                            <input type="text" class="form-control input-sm " id="txtcd_fname" name="txtcd_fname" maxlength="500"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_sname" class="control-label lbl_Vali">■ Cd Sname</label>
                            <input type="text" class="form-control input-sm" id="txtcd_sname" name="txtcd_sname" maxlength="500"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_fr_minor" class="control-label ">■ Fr Minor</label>
                            <input type="text" class="form-control input-sm" id="txtcd_fr_minor" name="txtcd_fr_minor" maxlength="2"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_se_minor" class="control-label ">■ Se Minor</label>
                            <input type="text" class="form-control input-sm" id="txtcd_se_minor" name="txtcd_se_minor" maxlength="2"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="ddlUse_YN" class="control-label lbl_Vali">■ Cd Level</label>
                            <input type="text" class="form-control input-sm " id="txtcd_level" name="txtcd_level" maxlength="2"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_order" class="control-label lbl_Vali">Seq</label>
                            <input type="number" class="form-control input-sm" id="txtcd_order" name="txtcd_order" max="999"/>
                        </div>
                        <div class="clearfix"></div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_ref1" class="control-label ">Ref 1</label>
                            <input type="text" class="form-control input-sm" id="txtcd_ref1" name="txtcd_ref1" maxlength="40"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_ref2" class="control-label ">Ref 2</label>
                            <input type="text" class="form-control input-sm" id="txtcd_ref2" name="txtcd_ref2" maxlength="40"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_ref3" class="control-label ">Ref 3</label>
                            <input type="text" class="form-control input-sm" id="txtcd_ref3" name="txtcd_ref3" maxlength="40"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_ref4" class="control-label ">Ref 4</label>
                            <input type="text" class="form-control input-sm" id="txtcd_ref4" name="txtcd_ref4" maxlength="40"/>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcd_property" class="control-label ">Property</label>
                            <input type="text" class="form-control input-sm" id="txtcd_property" name="txtcd_property" maxlength="100"/>
                        </div>
                    </fieldset>
                </div>

            </div>
        </div>
    </div>

    </div>
</asp:Content>

