<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ReportClose.aspx.cs" Inherits="UI_Report_ReportClose" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_Report/ReportClose_Service.asmx/";
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
                { id: "REPORT_NO", name: "성적서번호", field: "REPORT_NO", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "MASTER_STATUS_CD_NM", name: "상태", field: "MASTER_STATUS_CD_NM", cssClass: "cell-align-center", width: 120, sortable: true },
                { id: "RESULT_CONFIRM_DT", name: "최종승인일", field: "RESULT_CONFIRM_DT", cssClass: "cell-align-center", width: 120, sortable: true },
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
                        SetReportCloseDetail(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    SetReportCloseDetail(row);
                    $('#ulTabs li:eq(1) a').tab('show');
                }
            });

            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수

            //-------------------------------------------------------
            // 성적서 발행
            //-------------------------------------------------------
            $grd_Sample_List = $("#grd_Sample_List"),
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

            $grd_Sample_List.jqGrid({
                datatype: 'local',
                data: [],
                colNames: ["-", "시료명", "성적서 번호", "수량", "단위", "해당팀", "공인", "비공인", "ILAC", "국문", "영문"],
                colModel: [
                    { name: "SAMPLE_SHORT_NM", align: "center", width: 50, fixed: true, editable: false },
                    { name: "SAMPLE_NM", align: "left", width: 100, fixed: true, editable: false },
                    { name: "REPORT_NO", align: "center", width: 100, fixed: true, editable: false },
                    { name: "SAMPLE_CNT", align: "center", width: 80, fixed: true, editable: false },
                    { name: "SAMPLE_CAPACITY", align: "center", width: 80, fixed: true, editable: false },
                    { name: "SAMPLE_TEAM_NM", align: "left", width: 150, fixed: true, editable: false },
                    { name: "RET_KOLAS_YN", align: "center", width: 80, fixed: true, editable: false },
                    { name: "RET_NON_KOLAS_YN", align: "center", width: 80, fixed: true, editable: false },
                    { name: "RET_ILAC_MRA_YN", align: "center", width: 80, fixed: true, editable: false },
                    { name: "RET_KOR_YN", align: "center", width: 80, fixed: true, editable: false },
                    { name: "RET_ENG_YN", align: "center", width: 80, fixed: true, editable: false },
                ],
                loadComplete: function () {
                    var ids = $(this).jqGrid('getDataIDs');
                    for (var i = 0; i < ids.length; i++) {
                        //$(this).jqGrid('setCell', (i + 1), "TEST_CONTACT_USER_ID", "", { 'background-color': '#FBF9EE', 'background-image': 'none' });
                        //$(this).jqGrid('setCell', (i + 1), "RESULT_VALUE", "", { 'background-color': '#FBF9EE', 'background-image': 'none' });
                        //$(this).jqGrid('setCell', (i + 1), "RESULT_REMARK", "", { 'background-color': '#FBF9EE', 'background-image': 'none' });
                    }
                },
                cmTemplate: { autoResizable: true, editable: true },
                iconSet: "fontAwesome",
                autowidth: true,
                shrinkToFit: false,
                //grouping: true,
                //groupingView: {
                //    groupField: ['SAMPLE_NM'],
                //    groupColumnShow: [true],
                //    //groupText: ['<b>{0} - {1} Item(s)</b>'],
                //    groupCollapse: false,
                //    //groupOrder: ['desc']   		
                //},
                cellEdit: true,
                height: 200,
                multiselect: true,
                //caption: "Test List"
            })
            //.jqGrid("navGrid")
            //.jqGrid("filterToolbar")
            .jqGrid("gridResize");

            //-------------------------------------------------------
            // 발행 목록
            //-------------------------------------------------------
            function fn_word_file_link(cellvalue, options, rowObject) {
                return '<a href="' + rowObject.FILE_WORD_URL + '" target="_blank" style="color:blue;">' + "word" + '</a>';
            }
            function fn_pdf_file_link(cellvalue, options, rowObject) {
                return '<a href="' + rowObject.FILE_PDF_URL + '" target="_blank" style="color:blue;">' + "pdf" + '</a>';
            }
            function fn_2d_file_link(cellvalue, options, rowObject) {
                return '<a href="' + rowObject.FILE_2D_PDF_URL + '" target="_blank" style="color:blue;">' + "2d" + '</a>';
            }
            function fn_btn_use(cellvalue, options, rowObject) {
                if (rowObject.USE_YN == 'Y') {
                    return '<input type="button" value="삭제" class="btn btn-danger btn-sm" style="min-width:80px;" onclick="fn_btn_use_click(' + rowObject.id + ');" />  ';
                } else {
                    return '<input type="button" value="사용" class="btn btn-secondary btn-sm" style="min-width:80px;" onclick="fn_btn_use_click(' + rowObject.id + ');" />  ';
                }

            }
            function fn_btn_upload(cellvalue, options, rowObject) {
                return '<input type="button" value="첨부" class="btn btn-sm" style="min-width:80px; border:1px solid #aaa" onclick="fn_btn_upload_click(' + rowObject.id + ');" />  ';
            }
            $grd_Test_Report_List = $("#grd_Test_Report_List"),
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

            $grd_Test_Report_List.jqGrid({
                datatype: 'local',
                data: [],
                colNames: ["-", "성적서 번호", "성적서 종류", "파일명","-", "word", "pdf", "2D", "사용", "시료구분" ],
                colModel: [
                    { name: "REPORT_ID", align: "center", width: 50, fixed: true, editable: false },
                    { name: "REPORT_NO", align: "center", width: 100, fixed: true, editable: false },
                    { name: "REPORT_TYPE_NM", align: "center", width: 100, fixed: true, editable: false },
                    { name: "FILE_NM", align: "left", width: 150, fixed: true, editable: false },
                    { name: "FILE_WORD_UPLOAD", align: "center", width: 90, fixed: true, editable: false, formatter: fn_btn_upload },
                    { name: "FILE_WORD_URL", align: "center", width: 100, fixed: true, editable: false, formatter: fn_word_file_link },
                    { name: "FILE_PDF_URL", align: "center", width: 100, fixed: true, editable: false, formatter: fn_pdf_file_link },
                    { name: "FILE_2D_PDF_URL", align: "center", width: 100, fixed: true, editable: false, formatter: fn_2d_file_link },
                    { name: "USE_YN", align: "center", width: 90, fixed: true, editable: false, formatter: fn_btn_use },
                    { name: "SAMPLE_NM_LIST", align: "left", width: 150, fixed: true, editable: false },
                ],
                loadComplete: function () {
                    var ids = $(this).jqGrid('getDataIDs');
                    for (var i = 0; i < ids.length; i++) {
                        //$(this).jqGrid('setCell', (i + 1), "TEST_CONTACT_USER_ID", "", { 'background-color': '#FBF9EE', 'background-image': 'none' });
                        //$(this).jqGrid('setCell', (i + 1), "RESULT_VALUE", "", { 'background-color': '#FBF9EE', 'background-image': 'none' });
                        //$(this).jqGrid('setCell', (i + 1), "RESULT_REMARK", "", { 'background-color': '#FBF9EE', 'background-image': 'none' });
                    }
                },
                cmTemplate: { autoResizable: true, editable: true },
                iconSet: "fontAwesome",
                autowidth: true,
                shrinkToFit: false,
                //grouping: true,
                //groupingView: {
                //    groupField: ['SAMPLE_NM'],
                //    groupColumnShow: [true],
                //    //groupText: ['<b>{0} - {1} Item(s)</b>'],
                //    groupCollapse: false,
                //    //groupOrder: ['desc']   		
                //},
                cellEdit: true,
                height: 200,
                multiselect: true,
                //caption: "Test List"
            })
            //.jqGrid("navGrid")
            //.jqGrid("filterToolbar")
            .jqGrid("gridResize");

            //-------------------------------------------------------
            // 결과입력
            //-------------------------------------------------------
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
                colNames: ["-", "시험항목", "시험방법", "검출한계", "스팩(규격)", "레퍼런스", "해당팀", "실무자", "시험결과", "비고"],
                colModel: [
                    { name: "SAMPLE_NM", align: "left", width: 50, fixed: true, editable: false },
                    { name: "TEST_PACKAGE_NM", align: "left", width: 200, fixed: true, editable: false },
                    { name: "METHOD_NM", align: "left", width: 200, fixed: true, editable: false },
                    { name: "DETECTION_LIMIT_CD", align: "left", width: 100, fixed: true, editable: false },
                    { name: "SPEC_CD", align: "left", width: 100, fixed: true, editable: false },
                    { name: "REFERENCE_CD", align: "left", width: 100, fixed: true, editable: false },
                    { name: "TEST_TEAM_NM", align: "center", width: 100, fixed: true, editable: false },
                    { name: "TEST_CONTACT_USER_ID", align: "center", width: 100, fixed: true, editable: false },
                    //{ name: "RESULT_VALUE", align: "left", width: 250, fixed: true, editable: true, edittype: "textarea", editoptions: { rows: "2" } },
                    //{ name: "RESULT_REMARK", align: "left", width: 100, fixed: true, editable: true, edittype: "textarea", editoptions: { rows: "2" } },
                    { name: "RESULT_VALUE", align: "left", width: 250, fixed: true, editable: false, edittype: "text" },
                    { name: "RESULT_REMARK", align: "left", width: 100, fixed: true, editable: false, edittype: "text" },

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
            .jqGrid("gridResize");
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            $('#btnSave, #btnSaveEmail').click(function () {
                SaveReportClose(this.id);
            });
            $('#btnSearch').click(function () {
                GetReportCloseList();
            });
            $('#btnreport_create').click(function () {
                SaveReportCreate();
            });
            $('#btninvoice_save').click(function () {
                SaveInvoice();
            });
            $('#btnEmail').click(function () {
                mailsend_obj.thismodal = $('#modalMailSend');
                mailsend_obj.page = 'Mail_ReportClose';
                mailsend_obj.key = $('#hidreq_num').val() + ',' + '<%= CkUserId %>';
                mailsend_obj.thismodal.modal();
                return;
            });
            // 파일업로드
            $('#btninvoice').click(function () {
                fileupload_obj.filemodal = $('#modalfileupload');
                fileupload_obj.multi = false;
                fileupload_obj.page = "Invoice";
                fileupload_obj.key = $('#hidreq_num').val()
                $('#modalfileupload').modal();
            });
            // 초기 그리드 바인딩할때 필수..
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                ChangejQGridDesign("#grd_Test_Result_List", "");
                ChangejQGridDesign("#grd_Sample_List", "");
                ChangejQGridDesign("#grd_Test_Report_List", "");
            });
            $(document).on('focusout', '[role="gridcell"] *', function () {
                $("#grd_Test_Result_List").jqGrid('editCell', 0, 0, false);
                $("#grd_Sample_List").jqGrid('editCell', 0, 0, false);
                $("#grd_Test_Report_List").jqGrid('editCell', 0, 0, false);
            });

            grid_init();
            InitControls();
            // 초반 조회
            GetReportCloseList();
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
            $('#ddlmasterstatus_cd_s').append(GetCMCODE_Level_New({ cd_major: "0005", cd_level: '11', IsEmpty: true, Text: "ALL", Delete: '01,02,03,04,05,06,07,90,91,99,80,81,82,83,84,85,88,89' }));

            $('#ddlmaster_status_cd').empty();
            $('#ddlmaster_status_cd').append(GetCMCODE_Level_New({ cd_major: "0005", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddlreport_type').empty();
            $('#ddlreport_type').append(GetCMCODE_Level_New({ cd_major: "0013", cd_level: '11', IsEmpty: false, Text: "" }));

            $('#btnSave').addClass('hidden');
            $('#btnEmail').addClass('hidden');
            $('#btnSaveEmail').addClass('hidden');
        }

        //======================================================
        // Note - 워드 업로드.
        //======================================================
        function fn_btn_upload_click(row) {
            var selectRow = $('#grd_Test_Report_List').jqGrid('getGridParam', 'data')[row];
            var strKey = selectRow.REQ_NUM + ',' + selectRow.REPORT_ID + ',' + selectRow.FILE_WORD_URL + ',' + '<%= CkUserId %>';

            fileupload_obj.filemodal = $('#modalfileupload');
            fileupload_obj.multi = false;
            fileupload_obj.page = "ReportClose";
            fileupload_obj.key = strKey
            $('#modalfileupload').modal();
        }

        //======================================================
        // Note - 발행목록 사용유무.
        //======================================================
        function fn_btn_use_click(row) {
            var selectRow = $('#grd_Test_Report_List').jqGrid('getGridParam', 'data')[row];

            var Gparam = {
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_REPORT_ID: selectRow.REPORT_ID,
                IV_USE_YN: selectRow.USE_YN == 'Y' ? 'N' : 'Y',
                IV_USER_ID: '<%= this.CkUserId %>'
            }

            $.ajax({
                url: ServiceUrl + "fn_btn_use_click",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        // 발행목록 리로드.
                        GetReportFileList();
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
        // Note - 성적서 발행.
        //======================================================
        function SaveReportCreate() {
            var grdArr = $('#grd_Sample_List').jqGrid('getGridParam', 'selarrrow');

            if (grdArr.length == 0) {
                fn_info("선택된 시료가 없습니다.");
                return;
            }
            //if ($('#txtreport_no').val() == '') {
            //    fn_info('성적서 번호를 넣어 주세요.');
            //    return;
            //}

            var selectGrdArr = [];
            for (var i = 0; i < grdArr.length; i++) {
                var row = grdArr[i];
                var obj = $('#grd_Sample_List').jqGrid('getGridParam', 'data')[row];
                selectGrdArr.push(obj);
            }

            var Gparam = {
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_REPORT_NO: selectGrdArr[0].REPORT_NO,
                IV_REPORT_TYPE: $('#ddlreport_type').val(),
                IV_REQ_CODE: $('#hidreq_code').val(),
                IV_FILE_NM : '',
                IV_FILE_WORD_URL: '',
                IV_FILE_PDF_URL: '',
                IV_FILE_2D_PDF_URL: '',
                IV_USER_ID: '<%= this.CkUserId %>'
            }

            $.ajax({
                url: ServiceUrl + "SaveReportCreate",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam, "selectGrdArr": selectGrdArr }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        // 발행목록 리로드.
                        GetReportFileList();
                        $('#ddlmaster_status_cd').val('10');
                        $('#btnEmail').removeClass('hidden');
                        //$('#txtreport_no').val('');
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
        // Note - Report File 가져오기.
        //======================================================
        function GetReportFileList() {
            var Gparam = {
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_USER_ID: '<%= CkUserId %>'
            }
            $.ajax({
                url: ServiceUrl + "GetReportFileList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        $('#grd_Test_Report_List').jqGrid('clearGridData');
                        $('#grd_Test_Report_List').jqGrid('setGridParam', { data: jsonData.result });
                        $('#grd_Test_Report_List').trigger('reloadGrid');
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
        // Note - 인보이스 저장.
        //======================================================
        function SaveInvoice() {
             var Gparam = {
                 IV_REQ_NUM: $('#hidreq_num').val(),
                 IV_FILE_NM: $('#txtinvoice_nm').val(),
                 IV_FILE_URL: $('#hidinvoice_url').val(),
                 IV_USER_ID: '<%= this.CkUserId %>'
            }
            if (Gparam.IV_FILE_URL == '') {
                fn_info("저장할 파일이 없습니다.");
                return;
            }
            $.ajax({
                url: ServiceUrl + "SaveInvoice",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ulTabs li:eq(0) a').tab('show');
                        GetReportCloseList();
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
        function SaveReportClose(btnId) {
            var Gparam = {
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_USER_ID: '<%= this.CkUserId %>'
            }

            $.ajax({
                url: ServiceUrl + "SaveReportClose",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ulTabs li:eq(0) a').tab('show');
                        $('#btnreport_create').addClass('hidden');
                        $('#btnEmail').addClass('hidden');
                        GetReportCloseList();
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
        function SetReportCloseDetail(row) {
            $('#div_invoice').addClass('hidden');
            $('#btnreport_create').addClass('hidden');
            $('#btnEmail').addClass('hidden');
            
            if (row.MASTER_STATUS_CD == '10') {
                $('#btnreport_create').removeClass('hidden');
                $('#btnEmail').removeClass('hidden');
            }
            if (row.MASTER_STATUS_CD == '11') {
                $('#btnreport_create').removeClass('hidden');
                $('#btnEmail').removeClass('hidden');
                $('#div_invoice').removeClass('hidden');
            }
            if (row.MASTER_STATUS_CD == '12') {
                $('#div_invoice').removeClass('hidden');
            }

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

            $('#txtinvoice_nm').val(row.FILE_NM);
            $('#hidinvoice_url').val(row.FILE_URL);

            var Gparam = {
                IV_REQ_NUM: row.REQ_NUM,
                IV_USER_ID: '<%= CkUserId %>'
            }
            $.ajax({
                url: ServiceUrl + "SetReportCloseDetail",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        $('#grd_Sample_List').jqGrid('clearGridData');
                        $('#grd_Sample_List').jqGrid('setGridParam', { data: jsonData.SAMPLE_LIST });
                        $('#grd_Sample_List').trigger('reloadGrid');

                        $('#grd_Test_Report_List').jqGrid('clearGridData');
                        $('#grd_Test_Report_List').jqGrid('setGridParam', { data: jsonData.TEST_REPORT_LIST });
                        $('#grd_Test_Report_List').trigger('reloadGrid');

                        $('#grd_Test_Result_List').jqGrid('clearGridData');
                        $('#grd_Test_Result_List').jqGrid('setGridParam', { data: jsonData.TEST_LIST });
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
        function GetReportCloseList() {
            var Gparam = {
                IV_START_DT : $('#txtstart_dt_s').val().replaceAll('-', ''),
                IV_END_DT : $('#txtend_dt_s').val().replaceAll('-', ''),
                IV_MASTER_STATUS_CD : $('#ddlmasterstatus_cd_s').val(),
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetReportCloseList",
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
        //======================================================
        // Note - 업로드 후
        //======================================================
        function fileUploadBinding(Gparam) {
            $('#hidinvoice_url').val(Gparam.file_url);
            $('#txtinvoice_nm').val(Gparam.file_nm);
        }
        // File 클릭시 볼 수 있도록.
        function GetFileViewer(obj) {
            var clickName = obj.id;
            var linkUrl = '';

            if (clickName != '') {
                switch (clickName) {
                    case "txtinvoice_nm":
                        linkUrl = $('#hidinvoice_url').val();
                        break;
                    default:
                        break;
                }
                if (linkUrl != '') window.open(linkUrl, "_blank");
            }
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
                
                <div class="panel-heading" style="height: 62px">
                    
<%--                    <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;성적서 발행 완료
                    </button>
                    
                    <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnSaveEmail">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;메일 & 성적서 발행 완료
                    </button>--%>
                </div>
                <div class="panel-body form-horizontal">

                    <div class="col-xs-12 layout_dtl_page">
                        <!-- Tab panes -->
                        <div class="tab-content" style="background-color: #fafafa;">
                            <fieldset class="scheduler-border">
                                <legend class="scheduler-border">마스터 정보</legend>
                                <div class="form-group col-md-3 col-xs-12">
                                    <label for="txtreq_key" class="control-label ">■ 접수 번호</label>
                                    <input type="hidden" id="hidreq_num" />
                                    <input type="hidden" id="hidreq_code" />
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

                            <%--성적서 발행 하기.--%>
                            <fieldset class="scheduler-border">
                                <legend class="scheduler-border">성적서 발행</legend>
                                <table style="margin-bottom:10px;">
                                    <colgroup>
                                        <col style="width:100%" />
                                        <col style="width:auto" />
                                        <col style="width:auto" />
                                        <col style="width:auto" />
                                    </colgroup>
                                    <tr>
                                        <td></td>
                                        <%--<td>
                                            <input type="text" class="form-control input-sm " id="txtreport_no" name="txtreport_no" placeholder="성적서 번호" style="width:150px; margin-bottom:2px; margin-right:10px;"/>
                                        </td>--%>
                                        <td>
                                            <asp:DropDownList ID="ddlreport_type" runat="server" name="ddlreport_type" CssClass="form-control input-sm" ClientIDMode="Static" style="width:150px; margin-bottom:2px; margin-right:10px;">
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnreport_create">
                                                <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;발행
                                            </button>
                                        </td>
                                    </tr>
                                </table>
                                <div style="border-top: 2px solid #555;">
                                    <table id="grd_Sample_List"></table>
                                </div>
                            </fieldset>

                            <%--발행 목록.--%>
                            <fieldset class="scheduler-border" style="text-align:right;">
                                <legend class="scheduler-border">발행 목록</legend>
                                <button type="button" class="btn btn-warning btn-sm" data-toggle="confirmation" data-popout="true" id="btnEmail" style="margin: 15px; margin-top:0px;">
                                    <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;메일발송
                                </button>
                                <div style="border-top: 2px solid #555;">
                                    <table id="grd_Test_Report_List"></table>
                                </div>
                            </fieldset>
                            <%--인보이스 업로드.--%>
                            <fieldset class="scheduler-border" style="text-align:right;" id="div_invoice">
                                <legend class="scheduler-border">인보이스</legend>
                                <table>
                                    <colgroup>
                                        <col style="width:100%" />
                                    </colgroup>
                                    <tr>
                                        <td>
                                            <div class="input-group" style="width:100%; padding-top:5px;">
                                                <input type="hidden" class="form-control input-sm" id="hidinvoice_url" name="hidinvoice_url" />
                                                <input type="text" class="form-control input-sm" id="txtinvoice_nm" name="txtinvoice_nm" readonly="readonly" onclick="GetFileViewer(this);" />
                                                <div class="input-group-btn">
                                                    <button type="button" class="btn btn-default input-sm" id="btninvoice" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                                        <span class="glyphicon glyphicon-search"></span>
                                                    </button>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btninvoice_save">
                                                <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;저장
                                            </button>
                                        </td>
                                    </tr>
                                </table>
                                
                            </fieldset>
                            <%--시료 및 테스트 정보--%>
                            <fieldset class="scheduler-border">
                                <legend class="scheduler-border">시험 정보</legend>
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

