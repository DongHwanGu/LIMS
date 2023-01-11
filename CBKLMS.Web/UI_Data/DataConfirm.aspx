<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DataConfirm.aspx.cs" Inherits="UI_Data_DataConfirm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_Data/DataConfirm_Service.asmx/";
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
                { id: "REQ_CODE", name: "접수번호", field: "REQ_CODE", cssClass: "cell-align-center", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "MASTER_STATUS_CD_NM", name: "상태", field: "MASTER_STATUS_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true, formatter: GDH_StatusBackColor },
                { id: "REGISTER_DT_NM", name: "접수일", field: "REGISTER_DT_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "SERVICE_TYPE_NM", name: "접수유형", field: "SERVICE_TYPE_NM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REPORT_DUE_DT_NM", name: "발행예정일", field: "REPORT_DUE_DT_NM", cssClass: "cell-align-center", width: 120, sortable: true },
                { id: "UPD_ID_NM", name: "검토", field: "UPD_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "UPD_DT_NM", name: "검토일", field: "UPD_DT_NM", cssClass: "cell-align-center", width: 120, sortable: true },
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
                        SetDataConfirmDetail(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    SetDataConfirmDetail(row);
                    $('#ulTabs li:eq(1) a').tab('show');
                }
            });

            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수

            //-------------------------------------------------------
            // 결과입력
            //-------------------------------------------------------
            function fn_file_link(cellvalue, options, rowObject) {
                return '<a href="' + rowObject.FILE_URL + '" target="_blank" style="color:blue;">' + rowObject.FILE_NM + '</a>';
            }
            $grd_Test_Result_List = $("#grd_Test_Result_List"),
            initDateEdit = function (elem) {
                $(elem).datepicker({
                    dateFormat: "dd-M-yy",
                    autoSize: true,
                    changeYear: true,
                    changeMonth: true,
                    showButtonPanel: true,
                    showWeek: true
                });
            },
            initDateSearch = function (elem) {
                setTimeout(function () {
                    initDateEdit(elem);
                }, 100);
            };

            $grd_Test_Result_List.jqGrid({
                datatype: 'local',
                data: [],
                colNames: ["-", "시험항목", "시험방법", "검출한계", "스팩(규격)", "레퍼런스", "해당팀", "실무자", "결과", "비고", "파일"],
                colModel: [
                    { name: "SAMPLE_NM", align: "left", width: 50, fixed: true, editable: false, frozen: true },
                    { name: "TEST_PACKAGE_NM", align: "left", width: 200, fixed: true, editable: false, frozen: true },
                    { name: "METHOD_NM", align: "left", width: 200, fixed: true, editable: false, frozen: true },
                    { name: "DETECTION_LIMIT_CD", align: "left", width: 100, fixed: true, editable: false },
                    { name: "SPEC_CD", align: "left", width: 100, fixed: true, editable: false },
                    { name: "REFERENCE_CD", align: "left", width: 100, fixed: true, editable: false },
                    { name: "TEST_TEAM_NM", align: "center", width: 100, fixed: true, editable: false },
                    { name: "TEST_CONTACT_USER_ID", align: "center", width: 100, fixed: true, editable: false },
                    //{ name: "RESULT_VALUE", align: "left", width: 250, fixed: true, editable: true, edittype: "textarea", editoptions: { rows: "2" } },
                    //{ name: "RESULT_REMARK", align: "left", width: 100, fixed: true, editable: true, edittype: "textarea", editoptions: { rows: "2" } },
                    { name: "RESULT_VALUE", align: "left", width: 250, fixed: true, editable: true, edittype: "text" },
                    { name: "RESULT_REMARK", align: "left", width: 100, fixed: true, editable: true, edittype: "text" },
                    { name: "RESULT_FILE_NM", align: "left", width: 100, fixed: true, editable: false, formatter: fn_file_link }

                ],
                loadComplete: function () {
                    var ids = $(this).jqGrid('getDataIDs');
                    for (var i = 0; i < ids.length; i++) {
                        $(this).jqGrid('setCell', (i + 1), "TEST_CONTACT_USER_ID", "", { 'background-color': '#FBF9EE', 'background-image': 'none' });
                        $(this).jqGrid('setCell', (i + 1), "RESULT_VALUE", "", { 'background-color': '#FBF9EE', 'background-image': 'none' });
                        $(this).jqGrid('setCell', (i + 1), "RESULT_REMARK", "", { 'background-color': '#FBF9EE', 'background-image': 'none' });
                    }
                },
                cmTemplate: { autoResizable: true, editable: true },
                iconSet: "fontAwesome",
                autowidth: true,
                shrinkToFit: false,
                grouping: true,
                groupingView: {
                    groupField: ['SAMPLE_NM'],
                    groupColumnShow: [true],
                    //groupText: ['<b>{0} - {1} Item(s)</b>'],
                    groupCollapse: false,
                    //groupOrder: ['desc']   		
                },
                cellEdit: true,
                height: 600,
                //caption: "Test List"
            })
            //.jqGrid("navGrid")
            //.jqGrid("filterToolbar")
            .jqGrid("setFrozenColumns")
            .jqGrid("gridResize");
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            $('#btnReview, #btnApproval').click(function () {
                SaveDataConfirm(this.id);
            });
            $('#btnReviewReject, #btnApprovalReject').click(function () {
                SaveDataConfirmReject(this.id);
            });
            $('#btnSearch').click(function () {
                GetDataConfirmList();
            });

            // 초기 그리드 바인딩할때 필수..
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                ChangejQGridDesign("#grd_Test_Result_List", "");
            });
            $(document).on('focusout', '[role="gridcell"] *', function () {
                $("#grd_Test_Result_List").jqGrid('editCell', 0, 0, false);
            });

            grid_init();
            InitControls();
            // 초반 조회
            GetDataConfirmList();
        })

        //======================================================
        // Note - 초반 컨트롤 값 셋팅.
        //======================================================
        function InitControls() {
            fn_DatePicker($('#txtstart_dt_s'));
            fn_DatePicker($('#txtend_dt_s'));
            $('#txtstart_dt_s').val(fn_today(null, -1));
            $('#txtend_dt_s').val(fn_today());

            $('#ddlmasterstatus_cd_s').empty();
            $('#ddlmasterstatus_cd_s').append(GetCMCODE_Level_New({ cd_major: "0005", cd_level: '11', IsEmpty: true, Text: "ALL", Delete: '01,02,03,04,05,10,11,12,99,80,81,82,83,84,85,88,89' }));

            $('#ddlmaster_status_cd').empty();
            $('#ddlmaster_status_cd').append(GetCMCODE_Level_New({ cd_major: "0005", cd_level: '11', IsEmpty: false, Text: "" }));
        }

        //======================================================
        // Note - 반려.
        //======================================================
        function SaveDataConfirmReject(btnID) {
            var btnGb = btnID == 'btnReviewReject' ? 'Review' : 'Approval';
            var arrGparam = [];
            var dt = $('#grd_Test_Result_List').jqGrid('getGridParam', 'data');

            var Gparam = {
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_COMMENT: $('#txtcomment').val(),
                IV_BTN_GB: btnGb,
                IV_USER_ID: '<%= this.CkUserId %>'
            }

            for (var i = 0; i < dt.length; i++) {
                arrGparam.push({
                    IV_REQ_NUM: dt[i].REQ_NUM,
                    IV_SAMPLE_ID: dt[i].SAMPLE_ID,
                    IV_TEST_SEQ: dt[i].TEST_SEQ,
                    IV_RESULT_VALUE: dt[i].RESULT_VALUE == null ? '' : dt[i].RESULT_VALUE,
                    IV_RESULT_REMARK: dt[i].RESULT_REMARK == null ? '' : dt[i].RESULT_REMARK,
                    IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            $.ajax({
                url: ServiceUrl + "SaveDataConfirmReject",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam, "arrGparam": arrGparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ulTabs li:eq(0) a').tab('show');
                        GetDataConfirmList();
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
        // Note - 저장.
        //======================================================
        function SaveDataConfirm(btnID) {
            var btnGb = btnID == 'btnReview' ? 'Review' : 'Approval';
            var arrGparam = [];
            var dt = $('#grd_Test_Result_List').jqGrid('getGridParam', 'data');

            var Gparam = {
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_COMMENT: $('#txtcomment').val(),
                IV_BTN_GB: btnGb,
                IV_USER_ID: '<%= this.CkUserId %>'
            }

            for (var i = 0; i < dt.length; i++) {
                arrGparam.push({
                    IV_REQ_NUM: dt[i].REQ_NUM,
                    IV_SAMPLE_ID: dt[i].SAMPLE_ID,
                    IV_TEST_SEQ: dt[i].TEST_SEQ,
                    IV_RESULT_VALUE: dt[i].RESULT_VALUE == null ? '' : dt[i].RESULT_VALUE,
                    IV_RESULT_REMARK: dt[i].RESULT_REMARK == null ? '' : dt[i].RESULT_REMARK,
                    IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            $.ajax({
                url: ServiceUrl + "SaveDataConfirm",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam, "arrGparam": arrGparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ulTabs li:eq(0) a').tab('show');
                        GetDataConfirmList();
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
        // Note - 마스터 상세.
        //======================================================
        function SetDataConfirmDetail(row) {
            $('#btnReviewReject').addClass('hidden');
            $('#btnReview').addClass('hidden');
            $('#btnApprovalReject').addClass('hidden');
            $('#btnApproval').addClass('hidden');
            $('#divcomment').addClass('hidden');
            $('#txtcomment').val('');
            $('#divcomment_log').addClass('hidden');

            // 결과 확인
            if (row.MASTER_STATUS_CD == '06') {
                // 기책 
                if (row.CBKLMS_USER_GB == '02' || row.CBKLMS_USER_GB == '99') {
                    $('#btnReview').removeClass('hidden');
                    $('#btnReviewReject').removeClass('hidden');
                    $('#divcomment').removeClass('hidden');
                } else {
                    $('#divcomment').addClass('hidden');
                }
            }
            // 결과 검토
            if (row.MASTER_STATUS_CD == '07') {
                // 소장
                if (row.CBKLMS_USER_GB == '01' || row.CBKLMS_USER_GB == '99') {
                    $('#btnApproval').removeClass('hidden');
                    $('#btnApprovalReject').removeClass('hidden');
                    $('#divcomment').removeClass('hidden');
                } else {
                    $('#divcomment').addClass('hidden');
                }
            }
            // 반려
            if (row.MASTER_STATUS_CD == '91') {
                $('#divcomment').removeClass('hidden');
                $('#divcomment_log').removeClass('hidden');
                // 기책 
                if (row.CBKLMS_USER_GB == '02' || row.CBKLMS_USER_GB == '99') {
                    $('#btnReview').removeClass('hidden');
                    $('#btnReviewReject').removeClass('hidden');
                }
            }

            $('#txtmater_comment').val(row.MASTER_COMMENT);

            $('#hidreq_num').val(row.REQ_NUM);
            $('#hidreq_code').val(row.REQ_CODE);
            $('#txtreq_key').val(row.REQ_CODE);
            $('#ddlmaster_status_cd').val(row.MASTER_STATUS_CD);

            $('#txtregister_dt').val(row.REGISTER_DT_NM);
            $('#txtservice_type').val(row.SERVICE_TYPE_NM);
            $('#txtreport_due_dt').val(row.REPORT_DUE_DT_NM);
            $('#txtbuyer_nm').val(row.BUYER_NM);
            $('#txtvendor_nm').val(row.VENDOR_NM);
            $('#txtinertek_user_nm').val(row.INTERTEK_USER_NM);
            $('#txtreg_customer_req_remark').val(row.CUSTOMER_REQ_REMARK);

            var Gparam = {
                IV_REQ_NUM: row.REQ_NUM,
                IV_USER_ID: '<%= CkUserId %>'
            }
            $.ajax({
                url: ServiceUrl + "SetDataConfirmDetail",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        $('#grd_Test_Result_List').jqGrid('clearGridData');
                        $('#grd_Test_Result_List').jqGrid('setGridParam', { data: jsonData.result });
                        $('#grd_Test_Result_List').trigger('reloadGrid');
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
        // Note - 리스트 조회.
        //======================================================
        function GetDataConfirmList() {
            var Gparam = {
                IV_START_DT: $('#txtstart_dt_s').val().replaceAll('-', ''),
                IV_END_DT: $('#txtend_dt_s').val().replaceAll('-', ''),
                IV_MASTER_STATUS_CD: $('#ddlmasterstatus_cd_s').val(),
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetDataConfirmList",
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
                        <div class="form-group">
                            <label for="ddlstatus_s" class="col-md-1 col-xs-4 control-label">접수일</label>
                            <div class="col-md-3 col-xs-8">
                                <table style="width: 100%; text-align: center;">
                                    <tr>
                                        <td>
                                            <input type="text" class="form-control input-sm " id="txtstart_dt_s" name="txtstart_dt_s" />
                                        </td>
                                        <td style="width: 5%;">~</td>
                                        <td>
                                            <input type="text" class="form-control input-sm " id="txtend_dt_s" name="txtend_dt_s" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="ClearPhone"></div>
                            <label for="ddlmasterstatus_cd_s" class="col-md-1 col-xs-4 control-label">상태</label>
                            <div class="col-md-3 col-xs-8">
                                <asp:DropDownList ID="ddlmasterstatus_cd_s" runat="server" name="ddlmasterstatus_cd_s" CssClass="form-control input-sm" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                        </div>
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
        <%--상세--%>
        <div class="tab-pane fade" id="detail">
            <div class="panel panel-default">
                <div class="panel-heading" style="height:62px">
                    <button type="button" class="btn btn-danger btn-sm" data-toggle="confirmation" data-popout="true" id="btnReviewReject">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;반려
                    </button>
                    <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnReview">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;결과 검토
                    </button>
                    <button type="button" class="btn btn-danger btn-sm" data-toggle="confirmation" data-popout="true" id="btnApprovalReject">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;반려
                    </button>
                    <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnApproval">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;결과 승인
                    </button>
                </div>
                <div class="panel-body form-horizontal">

                    <div class="col-xs-12 layout_dtl_page">
                        <!-- Tab panes -->
                        <div class="tab-content" style="background-color: #fafafa;">
                            <div id="divcomment" class="alert alert-dismissible alert-primary" style="background:#EFF4F7; border:1px solid #ddd">
                                <button type="button" class="close" data-dismiss="alert">&times;</button>
                                <label for="ddlstatus_cd" class="control-label ">■ Comment (Write)</label>
                                <input type="text" class="form-control input-sm" id="txtcomment" name="txtcomment" />
                            </div>
                            <div id="divcomment_log" class="alert alert-dismissible alert-primary" style="background: #fafafa; border: 1px solid #ddd">
                                <button type="button" class="close" data-dismiss="alert">&times;</button>
                                <label for="txtmater_comment" class="control-label ">■ Comment (View)</label>
                                <input type="text" class="form-control input-sm" id="txtmater_comment" name="txtreq_key" readonly="readonly" />
                            </div>
                            <fieldset class="scheduler-border">
                                <legend class="scheduler-border">마스터 정보</legend>
                                <div class="form-group col-md-3 col-xs-12">
                                    <label for="txtreq_key" class="control-label ">■ 접수 번호</label>
                                    <input type="hidden" id="hidreq_num" />
                                    <input type="hidden" id="hidreq_code" />
                                    <input type="hidden" id="hidtest_team" />
                                    <input type="text" class="form-control input-sm" id="txtreq_key" name="txtreq_key" readonly="readonly" />
                                </div>
                                <div class="form-group col-md-3 col-xs-12">
                                    <label for="ddlstatus_cd" class="control-label ">■ 상태</label>
                                    <asp:DropDownList ID="ddlmaster_status_cd" runat="server" name="ddlmaster_status_cd" CssClass="form-control input-sm" ClientIDMode="Static" disabled="disabled">
                                    </asp:DropDownList>
                                </div>
                            </fieldset>

                            <%--접수 및 등록--%>
                            <fieldset class="scheduler-border">
                                <legend class="scheduler-border">정보</legend>
                                <div class="table-responsive">
                                    <table class="GDH_table" style="width: 1227px; border-top: 2px solid #555;">
                                        <colgroup>
                                            <col width="150px" />
                                            <col width="259px" />
                                            <col width="150px" />
                                            <col width="259px" />
                                            <col width="150px" />
                                            <col width="259px" />
                                        </colgroup>
                                        <tbody>
                                              <tr>
                                                <th class="th_title">
                                                    <span>접수일</span>
                                                </th>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtregister_dt" name="txtregister_dt" readonly="readonly" />
                                                </td>
                                                <th class="th_title">
                                                    <span>접수유형</span>
                                                </th>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtservice_type" name="txtservice_type" readonly="readonly" />
                                                </td>
                                                <th class="th_title">
                                                    <span>성적서 발행예정일</span>
                                                </th>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtreport_due_dt" name="txtreport_due_dt" readonly="readonly" />
                                                </td>
                                            </tr>
                                            <tr>
                                                
                                                <th class="th_title">
                                                    <span>의뢰업체</span>
                                                </th>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtvendor_nm" name="txtvendor_nm" readonly="readonly" />
                                                </td>
                                                <th class="th_title">
                                                    <span>제출처</span>
                                                </th>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtbuyer_nm" name="txtbuyer_nm" readonly="readonly" />
                                                </td>
                                                <th class="th_title">
                                                    <span>접수자</span>
                                                </th>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtinertek_user_nm" name="txtinertek_user_nm" readonly="readonly" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="th_title">
                                                    <span>고객요청사항</span>
                                                </th>
                                                <td colspan="5">
                                                    <input type="text" class="form-control input-sm" id="txtreg_customer_req_remark" name="txtreg_customer_req_remark" readonly="readonly" />
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </fieldset>

                            <%--시료 및 테스트 정보--%>
                            <fieldset class="scheduler-border">
                                <legend class="scheduler-border">결과 입력</legend>
                                <div style="border-top: 2px solid #555;">
                                    <table id="grd_Test_Result_List"></table>
                                </div>
                            </fieldset>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

