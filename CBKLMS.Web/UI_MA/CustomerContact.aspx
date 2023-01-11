<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CustomerContact.aspx.cs" Inherits="UI_MA_CustomerContact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_MA/CustomerContact_Service.asmx/";
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
                { id: "CONTACT_NM", name: "담당자명", field: "CONTACT_NM", cssClass: "cell-align-left", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CONTACT_ENM", name: "담당자명(EN)", field: "CONTACT_ENM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "STATUS_CD_NM", name: "상태", field: "STATUS_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CUST_LIST", name: "업체", field: "CUST_LIST", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "CONTACT_EMAIL", name: "이메일", field: "CONTACT_EMAIL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_GB_NM", name: "구분", field: "CONTACT_GB_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "CONTACT_DEPT", name: "부서", field: "CONTACT_DEPT", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_TEL", name: "전화", field: "CONTACT_TEL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_PHONE", name: "휴대폰", field: "CONTACT_PHONE", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_FAX", name: "팩스", field: "CONTACT_FAX", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REG_ID_NM", name: "등록자", field: "REG_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REG_DT_NM", name: "등록일자", field: "REG_DT_NM", cssClass: "cell-align-center", width: 150, sortable: true },
            ]
        };

        var grd_Cust_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Cust_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                grd_Cust_List_checkbox.getColumnDefinition(),
                { id: "CUST_NM", name: "업체명", field: "CUST_NM", cssClass: "cell-align-left", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CUST_ENM", name: "업체명(EN)", field: "CUST_ENM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "STATUS_CD_NM", name: "상태", field: "STATUS_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "BUSINESS_NO", name: "사업자번호", field: "BUSINESS_NO", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
            ]
        };

        var grd_Modal_Cust_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var columnFilters_Modal_Cust = {};
        function filter_Modal_Cust(item) {
            for (var columnId in columnFilters_Modal_Cust) {
                if (item[columnId] == null) {
                    return false;
                }
                else {
                    if (item[columnId] != undefined && columnId != undefined && columnFilters_Modal_Cust[columnId] != "" && item[columnId].toString().toLowerCase().indexOf(columnFilters_Modal_Cust[columnId]) == -1) {
                        // 요부분 바꿔야함.
                        var c = grd_Modal_Cust_List.grid.getColumns()[grd_Modal_Cust_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters_Modal_Cust[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Modal_Cust_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Modal_Cust_List_checkbox.getColumnDefinition(),
                { id: "CUST_NM", name: "업체명", field: "CUST_NM", cssClass: "cell-align-left", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CUST_ENM", name: "업체명(EN)", field: "CUST_ENM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "STATUS_CD_NM", name: "상태", field: "STATUS_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "BUSINESS_NO", name: "사업자번호", field: "BUSINESS_NO", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
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
                        GetCustContactDetail(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    GetCustContactDetail(row);
                    $('#ulTabs li:eq(1) a').tab('show');
                }
            });

            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수

            //-------------------------------------------------------
            // Cust List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Cust_List.grid = new Slick.Grid("#grd_Cust_List", grd_Cust_List.dataView, grd_Cust_List.columns, grd_Cust_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Cust_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Cust_List.grid.registerPlugin(grd_Cust_List_checkbox);
            grd_Cust_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Cust_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Cust_List.grid.updateRowCount();
                grd_Cust_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Cust_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Cust_List.grid.invalidateRows(args.rows);
                grd_Cust_List.grid.render();
            });

            grd_Cust_List.grid.init();

            //-------------------------------------------------------
            // 모달 업체리스트
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Modal_Cust_List.grid = new Slick.Grid("#grd_Modal_Cust_List", grd_Modal_Cust_List.dataView, grd_Modal_Cust_List.columns, grd_Modal_Cust_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Modal_Cust_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Modal_Cust_List.grid.registerPlugin(grd_Modal_Cust_List_checkbox);
            grd_Modal_Cust_List.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Modal_Cust_List.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters_Modal_Cust[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Modal_Cust_List.dataView.refresh();
                    $("#lblTotal").text(grd_Modal_Cust_List.grid.getDataLength());//로우 토탈 건수
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Modal_Cust_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters_Modal_Cust[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Modal_Cust_List.grid.render();
            });
            grd_Modal_Cust_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_Modal_Cust_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Modal_Cust_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Modal_Cust_List.grid.updateRowCount();
                grd_Modal_Cust_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Modal_Cust_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Modal_Cust_List.grid.invalidateRows(args.rows);
                grd_Modal_Cust_List.grid.render();
            });

            grd_Modal_Cust_List.grid.init();

        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            $('#btnSave, #btnSaveAs').click(function () {
                SaveContactData(this.id);
            });
            $('#btnAdd1, #btnAdd2').click(function () {
                InitControls();
                $('#ulTabs li:eq(1) a').tab('show');
            });
            $('#btnCust_add').click(function () {
                GetModalCustList();
                $('#modalCust').modal();
            });
            $('#btnCustSave').click(function () {
                SaveModalCust();
            });
            $('#btnCust_delete').click(function () {
                DeleteCustList();
            });
            $('#ddlpersoninfo_yn').change(function () {
                if ($(this).val() == 'Y')
                {
                    $('#txtpersoninfo_dt').val(fn_today());
                } else {
                    $('#txtpersoninfo_dt').val('');
                }
            });

            // 초기 그리드 바인딩할때 필수..
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                grd_Cust_List.grid.resizeCanvas();
            });

            // 모달 팝업 이벤트
            $('#modalCust').on('shown.bs.modal', function (e) {
                grd_Modal_Cust_List.grid.resizeCanvas();
            });

            // 초반 조회
            grid_init();
            InitControls();
            GetCustomerContactList();
        });

        //======================================================
        // Note - 전체 초기화.
        //======================================================
        function InitControls() {
            fn_ClearControls($('#detail'));

            fn_ClearGrid(grd_Cust_List);

            $('#btnSaveAs').addClass('hidden');

            $('#ddlpersoninfo_yn').val('N');
            
            fn_DatePicker($('#txtpersoninfo_dt'));
            
            $('#txtpersoninfo_dt').val('');

            $('#ddlstatus_cd').empty();
            $('#ddlstatus_cd').append(GetCMCODE_Level_New({ cd_major: "0003", cd_level: '11', IsEmpty: false, Text: "" }));
        }

        //======================================================
        // Note - 담당자 저장.
        //======================================================
        function SaveContactData(btnId) {
            var Gparam = {
                IV_CONTACT_ID: btnId == 'btnSaveAs' ? '' : $('#txtcontact_id').val(),
                IV_CONTACT_NM: $('#txtcontact_nm').val(),
                IV_CONTACT_ENM: $('#txtcontact_enm').val(),
                IV_STATUS_CD: $('#ddlstatus_cd').val(),
                IV_CONTACT_EMAIL: $('#txtcontact_email').val(),
                IV_CONTACT_PW: $('#txtcontact_pw').val(),
                IV_CONTACT_DEPT: $('#txtcontact_dept').val(),
                IV_CONTACT_TEL: $('#txtcontact_tel').val(),
                IV_CONTACT_PHONE: $('#txtcontact_phone').val(),
                IV_CONTACT_FAX: $('#txtcontact_fax').val(),
                IV_WORKER_YN: $('#chkworker_yn')[0].checked == true ? "Y" : "N",
                IV_CALCULATER_YN: $('#chkcalculater_yn')[0].checked == true ? "Y" : "N",
                IV_REMARK: $('#txtremark').val(),
                IV_PERSONINFO_YN: $('#ddlpersoninfo_yn').val(),
                IV_PERSONINFO_DT: $('#txtpersoninfo_dt').val().replaceAll('-', ''),
                IV_USER_ID: '<%= this.CkUserId %>'
            };

            var CustList = [];

            for (var i = 0; i < grd_Cust_List.dataView.getItems().length; i++) {
                CustList.push({
                    IV_CUST_ID: grd_Cust_List.dataView.getItems()[i].CUST_ID
                    , IV_CONTACT_ID: $('#txtcontact_id').val()
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            if (Gparam.IV_CONTACT_NM == '') {
                fn_info('[ 담당자명 ] 값을 넣어주세요.');
                return;
            }
            if (Gparam.IV_CONTACT_EMAIL == '') {
                fn_info('[ 이메일 ] 값을 넣어주세요.');
                return;
            }

            $.ajax({
                url: ServiceUrl + "SaveContactData",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam, "CustList": CustList }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ulTabs li:eq(0) a').tab('show');
                        GetCustomerContactList();
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
        // Note - Cust List 삭제
        //======================================================
        function DeleteCustList() {///
            if (grd_Cust_List.grid.getSelectedRows().length == 0) {
                fn_info('데이터를 선택해 주세요.');
                return;
            }

            var gridData = grd_Cust_List.grid.getSelectedRows();

            var DeleteData = [];
            for (var i = 0; i < gridData.length; i++) {
                DeleteData.push(grd_Cust_List.grid.getDataItem(gridData[i])["id"]);
            }
            for (var i = 0; i < DeleteData.length; i++) {
                grd_Cust_List.dataView.deleteItem(DeleteData[i]);
            }
        }

        //======================================================
        // Note - 모달 업체 저장.
        //======================================================
        function SaveModalCust() {
            if (grd_Modal_Cust_List.grid.getSelectedRows().length == 0) {
                fn_info('선택된 데이터가 없습니다.');
                return;
            }

            var gridData = grd_Modal_Cust_List.grid.getSelectedRows();

            for (var i = 0; i < gridData.length; i++) {
                var ModalList = {
                    id: grd_Modal_Cust_List.grid.getDataItem(gridData[i])["id"],
                    CUST_ID: grd_Modal_Cust_List.grid.getDataItem(gridData[i])["CUST_ID"],
                    CUST_NM: grd_Modal_Cust_List.grid.getDataItem(gridData[i])["CUST_NM"],
                    CUST_ENM: grd_Modal_Cust_List.grid.getDataItem(gridData[i])["CUST_ENM"],
                    STATUS_CD_NM: grd_Modal_Cust_List.grid.getDataItem(gridData[i])["STATUS_CD_NM"],
                    BUSINESS_NO: grd_Modal_Cust_List.grid.getDataItem(gridData[i])["BUSINESS_NO"],
                    REMARK: grd_Modal_Cust_List.grid.getDataItem(gridData[i])["REMARK"],
                    IV_USER_ID: '<%= this.CkUserId %>'
                };

                grd_Cust_List.dataView.addItem(ModalList);
            }
            GetModalCustList();
        }

        //======================================================
        // Note - 모달 업체 리스트.
        //======================================================
        function GetModalCustList() {
            var DeleteItem = [];

            for (var i = 0; i < grd_Cust_List.dataView.getItems().length; i++) {
                DeleteItem.push(grd_Cust_List.dataView.getItems()[i]["id"])
            }
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetModalCustList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Modal_Cust_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Modal_Cust_List.dataView.beginUpdate();
                        grd_Modal_Cust_List.dataView.setItems(jsonData.result);
                        grd_Modal_Cust_List.dataView.setFilter(filter_Modal_Cust);
                        grd_Modal_Cust_List.dataView.endUpdate();
                        grd_Modal_Cust_List.grid.render();

                        for (var i = 0; i < DeleteItem.length; i++) {
                            grd_Modal_Cust_List.dataView.deleteItem(DeleteItem[i]);
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

        //======================================================
        // Note - 담당자 상세.
        //======================================================
        function GetCustContactDetail(row) {
            $('#btnSaveAs').removeClass('hidden');

            $('#txtcontact_id').val(row.CONTACT_ID);
            $('#txtcontact_nm').val(row.CONTACT_NM);
            $('#txtcontact_enm').val(row.CONTACT_ENM);
            $('#ddlstatus_cd').val(row.STATUS_CD);
            $('#txtcontact_email').val(row.CONTACT_EMAIL);
            $('#txtcontact_dept').val(row.CONTACT_DEPT);
            $('#txtcontact_tel').val(row.CONTACT_TEL);
            $('#txtcontact_phone').val(row.CONTACT_PHONE);
            $('#txtcontact_fax').val(row.CONTACT_FAX);
            $('#chkworker_yn').iCheck(row.WORKER_YN == "Y" ? 'check' : 'uncheck');
            $('#chkcalculater_yn').iCheck(row.CALCULATER_YN == "Y" ? 'check' : 'uncheck');
            $('#txtremark').val(row.REMARK);
            $('#ddlpersoninfo_yn').val(row.PERSONINFO_YN);
            $('#txtpersoninfo_dt').val(row.PERSONINFO_DT);

            var Gparam = {
                IV_CONTACT_ID: row.CONTACT_ID
            };
            $.ajax({
                url: ServiceUrl + "GetCustContactDetail",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Cust_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Cust_List.dataView.beginUpdate();
                        grd_Cust_List.dataView.setItems(jsonData.result);
                        grd_Cust_List.dataView.endUpdate();
                        grd_Cust_List.grid.render();
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
        // Note - 마스터 조회.
        //======================================================
        function GetCustomerContactList() {
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetCustomerContactList",
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
                            <label for="txtcontact_id" class="control-label">■ Contact ID</label>
                            <input type="text" class="form-control input-sm" id="txtcontact_id" name="txtcontact_id" readonly="readonly" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcontact_nm" class="control-label lbl_Vali">■ 담당자명</label>
                            <input type="text" class="form-control input-sm" id="txtcontact_nm" name="txtcontact_nm" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcontact_enm" class="control-label ">■ 담당자명(EN)</label>
                            <input type="text" class="form-control input-sm" id="txtcontact_enm" name="txtcontact_enm" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="ddlstatus_cd" class="control-label">■ 상태</label>
                            <asp:DropDownList ID="ddlstatus_cd" runat="server" name="ddlstatus_cd" CssClass="form-control input-sm" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcontact_email" class="control-label lbl_Vali">■ 이메일</label>
                            <input type="text" class="form-control input-sm" id="txtcontact_email" name="txtcontact_email" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcontact_pw" class="control-label lbl_Vali">■ Password</label>
                            <input type="text" class="form-control input-sm" id="txtcontact_pw" name="txtcontact_pw" value="추후 사용 예정" autocomplete="new-password" disabled="disabled" />
                        </div>
                        <div class="form-group col-md-6 col-xs-12">
                            <label for="chkcontact_gb" class="control-label">■ 구분</label>
                            <table style="width: 100%; border-top: 2px solid #ddd;">
                                <tr>
                                    <td>
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="flat" id="chkworker_yn" name="chkcontact_gb" />
                                                업무
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="flat" id="chkcalculater_yn" name="chkcontact_gb" />
                                                계산서
                                            </label>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcontact_dept" class="control-label ">■ 부서</label>
                            <input type="text" class="form-control input-sm" id="txtcontact_dept" name="txtcontact_dept" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcontact_tel" class="control-label ">■ 전화</label>
                            <input type="text" class="form-control input-sm" id="txtcontact_tel" name="txtcontact_tel" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcontact_phone" class="control-label ">■ 휴대폰</label>
                            <input type="text" class="form-control input-sm" id="txtcontact_phone" name="txtcontact_phone" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcontact_fax" class="control-label ">■ 팩스</label>
                            <input type="text" class="form-control input-sm" id="txtcontact_fax" name="txtcontact_fax" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="ddlpersoninfo_yn" class="control-label">■ 개인정보이용동의</label>
                            <asp:DropDownList ID="ddlpersoninfo_yn" runat="server" name="ddlpersoninfo_yn" CssClass="form-control input-sm" ClientIDMode="Static">
                                <asp:ListItem Text="Y" Value="Y" />
                                <asp:ListItem Text="N" Value="N" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtpersoninfo_dt" class="control-label ">■ 동의 날짜</label>
                            <input type="text" class="form-control input-sm" id="txtpersoninfo_dt" name="txtpersoninfo_dt" readonly="readonly" />
                        </div>
                        <div class="form-group col-md-6 col-xs-12">
                            <label for="txtremark" class="control-label ">■ 비고</label>
                            <input type="text" class="form-control input-sm" id="txtremark" name="txtremark" />
                        </div>

                        <div class="clearfix"></div>
                        <div class="col-xs-12 mgn_T15">
                            <ul class="nav nav-tabs" style="border-bottom: none;">
                                <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">업체 설정</a></li>
                            </ul>
                            <div id="myTabContent2" class="tab-content " style="border: 1px solid #ddd; padding: 15px;">
                                <%--패키지 와 시험--%>
                                <div class="tab-pane fade active in mgn0" id="tab_1">
                                    <p>
                                        <label for="txtremark" class="control-label">■ 업체</label></p>
                                    <div style="border: 1px solid #ddd;">
                                        <div class="text-right mgn_B5 mgn_T10">
                                            <button type="button" class="btn btn-default btn-sm" id="btnCust_add" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm" id="btnCust_delete" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-trash"></span>
                                            </button>
                                        </div>
                                        <div id="grd_Cust_List" style="height: 150px; border-top: 2px solid #555" class=""></div>
                                    </div>
                                </div>
                            </div>
                        </div>



                    </div>
                </div>
            </div>
        </div>
    </div>

     <%--***********************************************************************************************/
/* Customer 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalCust" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">업체</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnCustSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <div id="grd_Modal_Cust_List" style="height: 300px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
</asp:Content>

