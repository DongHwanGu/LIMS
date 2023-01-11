<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Customer.aspx.cs" Inherits="UI_MA_Customer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_MA/Customer_Service.asmx/";
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
                { id: "CUST_NM", name: "업체명", field: "CUST_NM", cssClass: "cell-align-left", width: 300, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CUST_ENM", name: "업체명(EN)", field: "CUST_ENM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "CUST_CODE", name: "업체코드", field: "CUST_CODE", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "STATUS_CD_NM", name: "상태", field: "STATUS_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "BUSINESS_NO", name: "사업자번호", field: "BUSINESS_NO", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "REG_ID_NM", name: "등록자", field: "REG_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REG_DT_NM", name: "등록일자", field: "REG_DT_NM", cssClass: "cell-align-center", width: 150, sortable: true },
            ]
        };

        var grd_Package_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Package_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                grd_Package_List_checkbox.getColumnDefinition(),
                { id: "PACKAGE_NM", name: "Package 명", field: "PACKAGE_NM", cssClass: "cell-align-left", width: 200, sortable: true, formatter: GDH_TextPopupColor },
                { id: "PACKAGE_ENM", name: "Package 명(EN)", field: "PACKAGE_ENM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
            ]
        };

        var grd_Modal_Package_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var columnFilters_Modal_Package = {};
        function filter_Modal_Package(item) {
            for (var columnId in columnFilters_Modal_Package) {
                if (item[columnId] == null) {
                    return false;
                }
                else {
                    if (item[columnId] != undefined && columnId != undefined && columnFilters_Modal_Package[columnId] != "" && item[columnId].toString().toLowerCase().indexOf(columnFilters_Modal_Package[columnId]) == -1) {
                        // 요부분 바꿔야함.
                        var c = grd_Modal_Package_List.grid.getColumns()[grd_Modal_Package_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters_Modal_Package[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Modal_Package_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Modal_Package_List_checkbox.getColumnDefinition(),
                { id: "PACKAGE_NM", name: "Package 명", field: "PACKAGE_NM", cssClass: "cell-align-left", width: 200, sortable: true, formatter: GDH_TextPopupColor },
                { id: "PACKAGE_ENM", name: "Package 명(EN)", field: "PACKAGE_ENM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
            ]
        };

        var grd_Test_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Test_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                grd_Test_List_checkbox.getColumnDefinition(),
                 { id: "TEST_NM", name: "시험항목명", field: "TEST_NM", cssClass: "cell-align-left", width: 200, sortable: true, formatter: GDH_TextPopupColor },
                { id: "TEST_ENM", name: "시험항목명(EN)", field: "TEST_ENM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "METHOD_ID", name: "시험방법", field: "METHOD_NM", cssClass: "cell-align-left", width: 150, sortable: true, editor: Slick.Editors.TestMethod },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "UNIT_ID", name: "Unit", field: "UNIT_NM", cssClass: "cell-align-center", width: 100, sortable: true, editor: Slick.Editors.TestUnit },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
            ]
        };

        var grd_Modal_Test_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var columnFilters_Modal_Test = {};
        function filter_Modal_Test(item) {
            for (var columnId in columnFilters_Modal_Test) {
                if (item[columnId] == null) {
                    return false;
                }
                else {
                    if (item[columnId] != undefined && columnId != undefined && columnFilters_Modal_Test[columnId] != "" && item[columnId].toString().toLowerCase().indexOf(columnFilters_Modal_Test[columnId]) == -1) {
                        // 요부분 바꿔야함.
                        var c = grd_Modal_Test_List.grid.getColumns()[grd_Modal_Test_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters_Modal_Test[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Modal_Test_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Modal_Test_List_checkbox.getColumnDefinition(),
                 { id: "TEST_NM", name: "시험항목명", field: "TEST_NM", cssClass: "cell-align-left", width: 200, sortable: true, formatter: GDH_TextPopupColor },
                { id: "TEST_ENM", name: "시험항목명(EN)", field: "TEST_ENM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "METHOD_NM", name: "시험방법", field: "METHOD_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "UNIT_NM", name: "Unit", field: "UNIT_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
            ]
        };

        var grd_Contact_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Contact_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                grd_Contact_List_checkbox.getColumnDefinition(),
                { id: "CONTACT_NM", name: "담당자명", field: "CONTACT_NM", cssClass: "cell-align-left", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CONTACT_ENM", name: "담당자명(EN)", field: "CONTACT_ENM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "CONTACT_GB_NM", name: "구분", field: "CONTACT_GB_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "STATUS_CD_NM", name: "상태", field: "STATUS_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CONTACT_EMAIL", name: "이메일", field: "CONTACT_EMAIL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_DEPT", name: "부서", field: "CONTACT_DEPT", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_TEL", name: "전화", field: "CONTACT_TEL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_PHONE", name: "휴대폰", field: "CONTACT_PHONE", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_FAX", name: "팩스", field: "CONTACT_FAX", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 100, sortable: true },
            ]
        };

        var grd_Modal_Contact_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var columnFilters_Modal_Contact = {};
        function filter_Modal_Contact(item) {
            for (var columnId in columnFilters_Modal_Contact) {
                if (item[columnId] == null) {
                    return false;
                }
                else {
                    if (item[columnId] != undefined && columnId != undefined && columnFilters_Modal_Contact[columnId] != "" && item[columnId].toString().toLowerCase().indexOf(columnFilters_Modal_Contact[columnId]) == -1) {
                        // 요부분 바꿔야함.
                        var c = grd_Modal_Contact_List.grid.getColumns()[grd_Modal_Contact_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters_Modal_Contact[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Modal_Contact_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Modal_Contact_List_checkbox.getColumnDefinition(),
                { id: "CONTACT_NM", name: "담당자명", field: "CONTACT_NM", cssClass: "cell-align-left", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CONTACT_ENM", name: "담당자명(EN)", field: "CONTACT_ENM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "STATUS_CD_NM", name: "상태", field: "STATUS_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "CONTACT_EMAIL", name: "이메일", field: "CONTACT_EMAIL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_DEPT", name: "부서", field: "CONTACT_DEPT", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_TEL", name: "전화", field: "CONTACT_TEL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_PHONE", name: "휴대폰", field: "CONTACT_PHONE", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_FAX", name: "팩스", field: "CONTACT_FAX", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 100, sortable: true },
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
                        GetCustDetail(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                        $('#ulTabs_sub1 li:eq(0) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    GetCustDetail(row);
                    $('#ulTabs li:eq(1) a').tab('show');
                    $('#ulTabs_sub1 li:eq(0) a').tab('show');
                }
            });


            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수

            //-------------------------------------------------------
            // Package List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Package_List.grid = new Slick.Grid("#grd_Package_List", grd_Package_List.dataView, grd_Package_List.columns, grd_Package_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Package_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Package_List.grid.registerPlugin(grd_Package_List_checkbox);
            grd_Package_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Package_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Package_List.grid.updateRowCount();
                grd_Package_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Package_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Package_List.grid.invalidateRows(args.rows);
                grd_Package_List.grid.render();
            });

            grd_Package_List.grid.init();

            //-------------------------------------------------------
            // Modal Package List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Modal_Package_List.grid = new Slick.Grid("#grd_Modal_Package_List", grd_Modal_Package_List.dataView, grd_Modal_Package_List.columns, grd_Modal_Package_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Modal_Package_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Modal_Package_List.grid.registerPlugin(grd_Modal_Package_List_checkbox);
            grd_Modal_Package_List.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Modal_Package_List.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters_Modal_Package[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Modal_Package_List.dataView.refresh();
                    $("#lblTotal").text(grd_Modal_Package_List.grid.getDataLength());//로우 토탈 건수
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Modal_Package_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters_Modal_Package[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Modal_Package_List.grid.render();
            });
            grd_Modal_Package_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_Modal_Package_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Modal_Package_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Modal_Package_List.grid.updateRowCount();
                grd_Modal_Package_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Modal_Package_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Modal_Package_List.grid.invalidateRows(args.rows);
                grd_Modal_Package_List.grid.render();
            });

            grd_Modal_Package_List.grid.init();

            //-------------------------------------------------------
            // Test List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Test_List.grid = new Slick.Grid("#grd_Test_List", grd_Test_List.dataView, grd_Test_List.columns, grd_Test_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Test_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Test_List.grid.registerPlugin(grd_Test_List_checkbox);
            grd_Test_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Test_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Test_List.grid.updateRowCount();
                grd_Test_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Test_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Test_List.grid.invalidateRows(args.rows);
                grd_Test_List.grid.render();
            });
            // Note - 그리드에서 Cell에서 포커스가 변경될때(Changed)
            grd_Test_List.grid.onCellChange.subscribe(function (e, args) {
                var gridData = grd_Test_List.dataView.getItems();
                var row = args.item;
                // 할인율 적용 선택 시
                if (args.cell == 3) {
                    fn_SelectMethodChanged(row);
                }
            });

            grd_Test_List.grid.init();

            //-------------------------------------------------------
            // Modal Test List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Modal_Test_List.grid = new Slick.Grid("#grd_Modal_Test_List", grd_Modal_Test_List.dataView, grd_Modal_Test_List.columns, grd_Modal_Test_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Modal_Test_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Modal_Test_List.grid.registerPlugin(grd_Modal_Test_List_checkbox);
            grd_Modal_Test_List.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Modal_Test_List.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters_Modal_Test[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Modal_Test_List.dataView.refresh();
                    $("#lblTotal").text(grd_Modal_Test_List.grid.getDataLength());//로우 토탈 건수
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Modal_Test_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters_Modal_Test[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Modal_Test_List.grid.render();
            });
            grd_Modal_Test_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_Modal_Test_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Modal_Test_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Modal_Test_List.grid.updateRowCount();
                grd_Modal_Test_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Modal_Test_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Modal_Test_List.grid.invalidateRows(args.rows);
                grd_Modal_Test_List.grid.render();
            });

            grd_Modal_Test_List.grid.init();

            //-------------------------------------------------------
            // Contact List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Contact_List.grid = new Slick.Grid("#grd_Contact_List", grd_Contact_List.dataView, grd_Contact_List.columns, grd_Contact_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Contact_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Contact_List.grid.registerPlugin(grd_Contact_List_checkbox);
            grd_Contact_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Contact_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Contact_List.grid.updateRowCount();
                grd_Contact_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Contact_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Contact_List.grid.invalidateRows(args.rows);
                grd_Contact_List.grid.render();
            });

            grd_Contact_List.grid.init();

            //-------------------------------------------------------
            // 모달 담당자 리스트
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Modal_Contact_List.grid = new Slick.Grid("#grd_Modal_Contact_List", grd_Modal_Contact_List.dataView, grd_Modal_Contact_List.columns, grd_Modal_Contact_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Modal_Contact_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Modal_Contact_List.grid.registerPlugin(grd_Modal_Contact_List_checkbox);
            grd_Modal_Contact_List.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Modal_Contact_List.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters_Modal_Contact[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Modal_Contact_List.dataView.refresh();
                    $("#lblTotal").text(grd_Modal_Contact_List.grid.getDataLength());//로우 토탈 건수
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Modal_Contact_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters_Modal_Contact[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Modal_Contact_List.grid.render();
            });
            grd_Modal_Contact_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_Modal_Contact_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Modal_Contact_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Modal_Contact_List.grid.updateRowCount();
                grd_Modal_Contact_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Modal_Contact_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Modal_Contact_List.grid.invalidateRows(args.rows);
                grd_Modal_Contact_List.grid.render();
            });

            grd_Modal_Contact_List.grid.init();
        }
        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            // 조회
            $('#btnSearch').click(function () {
                GetCustList();
            });
            // 저장버튼
            $('#btnSave, #btnSaveAs').click(function () {
                SaveCustData(this.id);
            });
            // 추가
            $('#btnSaveAs').addClass('hidden');
            $('#btnAdd1, #btnAdd2').click(function () {
                fn_ClearControls($('#detail'))
                fn_ClearGrid(grd_Package_List);
                fn_ClearGrid(grd_Test_List);
                fn_ClearGrid(grd_Contact_List);
                $('#chkteam_gb1').iCheck('uncheck');
                $('#chkteam_gb2').iCheck('uncheck');
                $('#chkteam_gb3').iCheck('uncheck');
                $('#chkteam_gb4').iCheck('uncheck');
                $('#btnSaveAs').addClass('hidden');
                $('#ulTabs li:eq(1) a').tab('show');
                $('#ulTabs_sub1 li:eq(0) a').tab('show');
            });
            // 주소 팝업
            $('#btnaddr_popup').click(function () {
                Fn_GetDaumPostcode();
            });

            // Package Add
            $('#btnpackage_add').click(function () {
                GetModalPackageList();
                $('#modalPackage').modal();
            });
            // Package Modal Save
            $('#btnmodalpackage_save').click(function () {
                SaveModalPackageList();
            });
            // Package Delete
            $('#btnpackage_delete').click(function () {
                DeletePackageList();
            });
            // Test Popup
            $('#btntest_add').click(function () {
                GetModalTestList();
                $('#modalTest').modal();
            });
            // Test Modal Save
            $('#btnmodaltest_save').click(function () {
                SaveModalTestList();
            });
            // Test delete
            $('#btntest_delete').click(function () {
                DeleteTestList();
            });
            // Contact 추가
            $('#btncontact_add').click(function () {
                GetModalContactList();
                $('#modalContact').modal();
            });
            // Contact 저장
            $('#btnContactSave').click(function () {
                SaveModalContactData();
            });
            // Contact 삭제
            $('#btncontact_delete').click(function () {
                DeleteContactList();
            });

            // 초기 그리드 바인딩할때 필수..
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                grd_Package_List.grid.resizeCanvas();
                grd_Test_List.grid.resizeCanvas();
                grd_Contact_List.grid.resizeCanvas();
            });

            // 모달 팝업 이벤트
            $('#modalPackage').on('shown.bs.modal', function (e) {
                grd_Modal_Package_List.grid.resizeCanvas();
            });
            $('#modalTest').on('shown.bs.modal', function (e) {
                grd_Modal_Test_List.grid.resizeCanvas();
            });
            $('#modalContact').on('shown.bs.modal', function (e) {
                grd_Modal_Contact_List.grid.resizeCanvas();
            });


            $('#ddlstatus_cd').empty();
            $('#ddlstatus_cd').append(GetCMCODE_Level_New({ cd_major: "0001", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddlbil_location').empty();
            $('#ddlbil_location').append(GetCMCODE_Level_New({ cd_major: "0002", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddlCon_Status_cd').empty();
            $('#ddlCon_Status_cd').append(GetCMCODE_Level_New({ cd_major: "0003", cd_level: '11', IsEmpty: false, Text: "" }));
            // 초반 조회
            grid_init();
            GetCustList();

            $('.slick-viewport').on('blur', 'input.editor-text', function (e) {
                window.setTimeout(function () {
                    Slick.GlobalEditorLock.commitCurrentEdit();
                }, 0);
            })
            $('.slick-viewport').on('blur', 'input.editor-checkbox', function (e) {
                window.setTimeout(function () {
                    Slick.GlobalEditorLock.commitCurrentEdit();
                }, 0);
            })
            $('.slick-viewport').on('blur', 'select.editor-select', function (e) {
                window.setTimeout(function () {
                    Slick.GlobalEditorLock.commitCurrentEdit();
                }, 0);
            });
        });

        //======================================================
        // Note - 시험방법 정보가져오기.
        //======================================================
        function fn_SelectMethodChanged(row) {
            var Gparam = {
                IV_METHOD_ID: row.METHOD_ID
            }

            $.ajax({
                url: "/WebService/Common_Service.asmx/GetSelectMethodChanged",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                async: false,
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    if (jsonData.result.length > 0) {
                        row.ENG_AMT = jsonData.result[0].ENG_AMT;
                        row.KOR_AMT = jsonData.result[0].KOR_AMT;

                        grd_Test_List.dataView.beginUpdate();
                        grd_Test_List.dataView.updateItem(row.id, row);
                        grd_Test_List.dataView.endUpdate();
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
        // Note - Contact List.
        //======================================================
        function GetModalContactList() {
            var DeleteItem = [];

            for (var i = 0; i < grd_Contact_List.dataView.getItems().length; i++) {
                DeleteItem.push(grd_Contact_List.dataView.getItems()[i]["id"])
            }
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetModalContactList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Modal_Contact_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Modal_Contact_List.dataView.beginUpdate();
                        grd_Modal_Contact_List.dataView.setItems(jsonData.result);
                        grd_Modal_Contact_List.dataView.setFilter(filter_Modal_Contact);
                        grd_Modal_Contact_List.dataView.endUpdate();
                        grd_Modal_Contact_List.grid.render();

                        for (var i = 0; i < DeleteItem.length; i++) {
                            grd_Modal_Contact_List.dataView.deleteItem(DeleteItem[i]);
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
        // Note - Contact Data Delete.
        //======================================================
        function DeleteContactList() {
            if (grd_Contact_List.grid.getSelectedRows().length == 0) {
                fn_info('데이터를 선택해 주세요.');
                return;
            }

            var gridData = grd_Contact_List.grid.getSelectedRows();

            var DeleteData = [];
            for (var i = 0; i < gridData.length; i++) {
                DeleteData.push(grd_Contact_List.grid.getDataItem(gridData[i])["id"]);
            }
            for (var i = 0; i < DeleteData.length; i++) {
                grd_Contact_List.dataView.deleteItem(DeleteData[i]);
            }
        }

        //======================================================
        // Note - Contact Data Save.
        //======================================================
        function SaveModalContactData() {
            if (grd_Modal_Contact_List.grid.getSelectedRows().length == 0) {
                fn_info('선택된 데이터가 없습니다.');
                return;
            }

            var gridData = grd_Modal_Contact_List.grid.getSelectedRows();

            for (var i = 0; i < gridData.length; i++) {
                var ModalList = {
                    id: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["id"],
                    CONTACT_ID: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_ID"],
                    CONTACT_NM: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_NM"],
                    CONTACT_ENM: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_ENM"],
                    STATUS_CD_NM: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["STATUS_CD_NM"],
                    CONTACT_EMAIL: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_EMAIL"],
                    CONTACT_DEPT: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_DEPT"],
                    CONTACT_TEL: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_TEL"],
                    CONTACT_PHONE: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_PHONE"],
                    CONTACT_EMAIL: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_EMAIL"],
                    CONTACT_FAX: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_FAX"],
                    REMARK: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["REMARK"],
                    IV_USER_ID: '<%= this.CkUserId %>'
                };

                grd_Contact_List.dataView.addItem(ModalList);
            }
            GetModalContactList();
        }

        //======================================================
        // Note - Test List Delete.
        //======================================================
        function DeleteTestList() {
            if (grd_Test_List.grid.getSelectedRows().length == 0) {
                fn_info('데이터를 선택해 주세요.');
                return;
            }

            var gridData = grd_Test_List.grid.getSelectedRows();

            var DeleteData = [];
            for (var i = 0; i < gridData.length; i++) {
                DeleteData.push(grd_Test_List.grid.getDataItem(gridData[i])["id"]);
            }
            for (var i = 0; i < DeleteData.length; i++) {
                grd_Test_List.dataView.deleteItem(DeleteData[i]);
            }
        }

        //======================================================
        // Note - Save Modal Test List.
        //======================================================
        function SaveModalTestList() {
            if (grd_Modal_Test_List.grid.getSelectedRows().length == 0) {
                fn_info('선택된 데이터가 없습니다.');
                return;
            }

            var gridData = grd_Modal_Test_List.grid.getSelectedRows();

            for (var i = 0; i < gridData.length; i++) {
                var ModalList = {
                    id: grd_Modal_Test_List.grid.getDataItem(gridData[i])["id"] + "_" + grd_Test_List.dataView.getItems().length,
                    TEST_ID: grd_Modal_Test_List.grid.getDataItem(gridData[i])["TEST_ID"],
                    TEST_NM: grd_Modal_Test_List.grid.getDataItem(gridData[i])["TEST_NM"],
                    TEST_ENM: grd_Modal_Test_List.grid.getDataItem(gridData[i])["TEST_ENM"],
                    UNIT_ID: grd_Modal_Test_List.grid.getDataItem(gridData[i])["UNIT_ID"],
                    UNIT_NM: grd_Modal_Test_List.grid.getDataItem(gridData[i])["UNIT_NM"],
                    USE_YN: grd_Modal_Test_List.grid.getDataItem(gridData[i])["USE_YN"],
                    REMARK: grd_Modal_Test_List.grid.getDataItem(gridData[i])["REMARK"],
                    METHOD_ID: grd_Modal_Test_List.grid.getDataItem(gridData[i])["METHOD_ID"],
                    METHOD_NM: grd_Modal_Test_List.grid.getDataItem(gridData[i])["METHOD_NM"],
                    ENG_AMT: grd_Modal_Test_List.grid.getDataItem(gridData[i])["ENG_AMT"],
                    KOR_AMT: grd_Modal_Test_List.grid.getDataItem(gridData[i])["KOR_AMT"],
                    IV_USER_ID: '<%= this.CkUserId %>'
                };

                grd_Test_List.dataView.addItem(ModalList);
            }

            // 팝업 다시조회
            GetModalTestList();
        }

        //======================================================
        // Note - Modal Test List.
        //======================================================
        function GetModalTestList() {
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetModalTestList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Modal_Test_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Modal_Test_List.dataView.beginUpdate();
                        grd_Modal_Test_List.dataView.setItems(jsonData.result);
                        grd_Modal_Test_List.dataView.setFilter(filter_Modal_Test);
                        grd_Modal_Test_List.dataView.endUpdate();
                        grd_Modal_Test_List.grid.render();

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
        // Note - Package List Delete.
        //======================================================
        function DeletePackageList() {
            if (grd_Package_List.grid.getSelectedRows().length == 0) {
                fn_info('데이터를 선택해 주세요.');
                return;
            }

            var gridData = grd_Package_List.grid.getSelectedRows();

            var DeleteData = [];
            for (var i = 0; i < gridData.length; i++) {
                DeleteData.push(grd_Package_List.grid.getDataItem(gridData[i])["id"]);
            }
            for (var i = 0; i < DeleteData.length; i++) {
                grd_Package_List.dataView.deleteItem(DeleteData[i]);
            }
        }


        //======================================================
        // Note - Modal Package List Save.
        //======================================================
        function SaveModalPackageList() {
            if (grd_Modal_Package_List.grid.getSelectedRows().length == 0) {
                fn_info('선택된 데이터가 없습니다.');
                return;
            }

            var gridData = grd_Modal_Package_List.grid.getSelectedRows();

            for (var i = 0; i < gridData.length; i++) {
                var ModalList = {
                    id: grd_Modal_Package_List.grid.getDataItem(gridData[i])["id"],
                    PACKAGE_ID: grd_Modal_Package_List.grid.getDataItem(gridData[i])["PACKAGE_ID"],
                    PACKAGE_NM: grd_Modal_Package_List.grid.getDataItem(gridData[i])["PACKAGE_NM"],
                    PACKAGE_ENM: grd_Modal_Package_List.grid.getDataItem(gridData[i])["PACKAGE_ENM"],
                    USE_YN: grd_Modal_Package_List.grid.getDataItem(gridData[i])["USE_YN"],
                    REMARK: grd_Modal_Package_List.grid.getDataItem(gridData[i])["REMARK"],
                    ENG_AMT: grd_Modal_Package_List.grid.getDataItem(gridData[i])["ENG_AMT"],
                    KOR_AMT: grd_Modal_Package_List.grid.getDataItem(gridData[i])["KOR_AMT"],
                    IV_USER_ID: '<%= this.CkUserId %>'
                };

                grd_Package_List.dataView.addItem(ModalList);
            }

            // 팝업 다시조회
            GetModalPackageList();
        }

        //======================================================
        // Note - Modal Package List.
        //======================================================
        function GetModalPackageList() {
            var DeleteItem = [];

            for (var i = 0; i < grd_Package_List.dataView.getItems().length; i++) {
                DeleteItem.push(grd_Package_List.dataView.getItems()[i]["id"])
            }
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetModalPackageList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Modal_Package_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Modal_Package_List.dataView.beginUpdate();
                        grd_Modal_Package_List.dataView.setItems(jsonData.result);
                        grd_Modal_Package_List.dataView.setFilter(filter_Modal_Package);
                        grd_Modal_Package_List.dataView.endUpdate();
                        grd_Modal_Package_List.grid.render();

                        for (var i = 0; i < DeleteItem.length; i++) {
                            grd_Modal_Package_List.dataView.deleteItem(DeleteItem[i]);
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
        // Note - 업체 상세.
        //======================================================
        function GetCustDetail(row) {
            $('#btnSaveAs').removeClass('hidden');

            $('#txtcust_id').val(row.CUST_ID);
            $('#txtcust_code').val(row.CUST_CODE);
            $('#txtcust_nm').val(row.CUST_NM);
            $('#txtcust_enm').val(row.CUST_ENM);
            $('#ddlstatus_cd').val(row.STATUS_CD);
            $('#chkcust_gb1').iCheck(row.CUST_GB1 == "Y" ? 'check' : 'uncheck');
            $('#chkcust_gb2').iCheck(row.CUST_GB2 == "Y" ? 'check' : 'uncheck');
            $('#chkcust_gb3').iCheck(row.CUST_GB3 == "Y" ? 'check' : 'uncheck');
            $('#ddlbil_location').val(row.BILL_LOC);
            $('#txtceo_nm').val(row.CEO_NM);
            $('#txtbusiness_no').val(row.BUSINESS_NO);
            $('#txtzip_cd').val(row.ZIP_CD);
            $('#txtaddr_kr1').val(row.ADDR_KR1);
            $('#txtaddr_kr2').val(row.ADDR_KR2);
            $('#txtaddr_en1').val(row.ADDR_EN1);
            $('#txtaddr_en2').val(row.ADDR_EN2);

            $('#txtbiz_class').val(row.BIZ_CLASS);
            $('#txtbiz_item').val(row.BIZ_ITEM);
            $('#txtremark').val(row.REMARK);

            // Sub List Select
            var Gparam = {
                IV_CUST_ID: row.CUST_ID
            };
            $.ajax({
                url: ServiceUrl + "GetCustDetail",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Package_List);
                    fn_ClearGrid(grd_Test_List);
                    fn_ClearGrid(grd_Contact_List);
                    $('#chkteam_gb1').iCheck('uncheck');
                    $('#chkteam_gb2').iCheck('uncheck');
                    $('#chkteam_gb3').iCheck('uncheck');
                    $('#chkteam_gb4').iCheck('uncheck');

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        for (var i = 0; i < jsonData.CUST_TEAM_LIST.length; i++) {
                            switch (jsonData.CUST_TEAM_LIST[i].CUST_TEAM) {
                                case "01":
                                    $('#chkteam_gb1').iCheck('check');
                                    break;
                                case "02":
                                    $('#chkteam_gb2').iCheck('check');
                                    break;
                                case "03":
                                    $('#chkteam_gb3').iCheck('check');
                                    break;
                                case "04":
                                    $('#chkteam_gb4').iCheck('check');
                                    break;
                                default:
                                    break;
                            }
                        }

                        // Note - Customer Information
                        grd_Package_List.dataView.beginUpdate();
                        grd_Package_List.dataView.setItems(jsonData.PACKAGE_LIST);
                        grd_Package_List.dataView.endUpdate();
                        grd_Package_List.grid.render();

                        grd_Test_List.dataView.beginUpdate();
                        grd_Test_List.dataView.setItems(jsonData.TEST_LIST);
                        grd_Test_List.dataView.endUpdate();
                        grd_Test_List.grid.render();

                        grd_Contact_List.dataView.beginUpdate();
                        grd_Contact_List.dataView.setItems(jsonData.CONTACT_LIST);
                        grd_Contact_List.dataView.endUpdate();
                        grd_Contact_List.grid.render();
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
        // Note - 주소 팝업.
        //======================================================
        function Fn_GetDaumPostcode() {
            var width = 500;
            var height = 425;
            new daum.Postcode({
                width: width,
                height: height,
                oncomplete: function (data) {
                    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                    // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var fullAddr = ''; // 최종 주소 변수
                    var extraAddr = ''; // 조합형 주소 변수
                    var fullAddrEng = '';
                    var extraAddrEng = '';

                    // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                    if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                        fullAddr = data.roadAddress;
                        fullAddrEng = data.roadAddressEnglish;

                    } else { // 사용자가 지번 주소를 선택했을 경우(J)
                        fullAddr = data.jibunAddress;
                        fullAddrEng = data.jibunAddressEnglish;
                    }

                    // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                    if (data.userSelectedType === 'R') {
                        //법정동명이 있을 경우 추가한다.
                        if (data.bname !== '') {
                            extraAddr += data.bname;
                        }
                        // 건물명이 있을 경우 추가한다.
                        if (data.buildingName !== '') {
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                        fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
                    }

                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    $('#txtzip_cd').val(data.zonecode);
                    $('#txtaddr_kr1').val(fullAddr);
                    $('#txtaddr_kr2').focus();
                    $('#txtaddr_en1').val(fullAddrEng);
                }
            }).open({
                left: (window.screen.width / 2) - (width / 2),
                top: (window.screen.height / 2) - (height / 2)
            });
        }

        //======================================================
        // Note - 업체 저장
        //======================================================
        function SaveCustData(btnId) {
            var MasterData = {
                IV_CUST_ID: btnId == 'btnSaveAs' ? '' : $('#txtcust_id').val(),
                IV_CUST_CODE: $('#txtcust_code').val(),
                IV_CUST_NM: $('#txtcust_nm').val(),
                IV_CUST_ENM: $('#txtcust_enm').val(),
                IV_STATUS_CD: $('#ddlstatus_cd').val(),
                IV_CUST_GB1: $('#chkcust_gb1')[0].checked == true ? "Y" : "N",
                IV_CUST_GB2: $('#chkcust_gb2')[0].checked == true ? "Y" : "N",
                IV_CUST_GB3: $('#chkcust_gb3')[0].checked == true ? "Y" : "N",
                IV_CUST_GB4: "",
                IV_BILL_LOC: $('#ddlbil_location').val(),
                IV_CEO_NM: $('#txtceo_nm').val(),
                IV_BUSINESS_NO: $('#txtbusiness_no').val(),
                IV_ZIP_CD: $('#txtzip_cd').val(),
                IV_ADDR_KR1: $('#txtaddr_kr1').val(),
                IV_ADDR_KR2: $('#txtaddr_kr2').val(),
                IV_ADDR_EN1: $('#txtaddr_en1').val(),
                IV_ADDR_EN2: $('#txtaddr_en2').val(),
                IV_BIZ_CLASS: $('#txtbiz_class').val(),
                IV_BIZ_ITEM: $('#txtbiz_item').val(),
                IV_REMARK: $('#txtremark').val(),
                IV_USER_ID: '<%= this.CkUserId %>'
            };

            var MasterData_Team = [];
            if ($('#chkteam_gb1')[0].checked == true) {
                MasterData_Team.push({
                    IV_CUST_ID: $('#txtcust_id').val()
                    , IV_CUST_TEAM: '01'
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }
            if ($('#chkteam_gb2')[0].checked == true) {
                MasterData_Team.push({
                    IV_CUST_ID: $('#txtcust_id').val()
                    , IV_CUST_TEAM: '02'
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }
            if ($('#chkteam_gb3')[0].checked == true) {
                MasterData_Team.push({
                    IV_CUST_ID: $('#txtcust_id').val()
                    , IV_CUST_TEAM: '03'
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }
            if ($('#chkteam_gb4')[0].checked == true) {
                MasterData_Team.push({
                    IV_CUST_ID: $('#txtcust_id').val()
                    , IV_CUST_TEAM: '04'
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            var PackageList = [];
            for (var i = 0; i < grd_Package_List.dataView.getItems().length; i++) {
                PackageList.push({
                    IV_CUST_ID: $('#txtcust_id').val()
                    , IV_PACKAGE_ID: grd_Package_List.dataView.getItems()[i].PACKAGE_ID
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            var TestList = [];
            for (var i = 0; i < grd_Test_List.dataView.getItems().length; i++) {
                TestList.push({
                    IV_CUST_ID: $('#txtcust_id').val()
                    , IV_TEST_ID: grd_Test_List.dataView.getItems()[i].TEST_ID
                    , IV_UNIT_ID: grd_Test_List.dataView.getItems()[i].UNIT_ID
                    , IV_METHOD_ID: grd_Test_List.dataView.getItems()[i].METHOD_ID
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            var ContactList = [];
            for (var i = 0; i < grd_Contact_List.dataView.getItems().length; i++) {
                ContactList.push({
                    IV_CUST_ID: $('#txtcust_id').val()
                    , IV_CONTACT_ID: grd_Contact_List.dataView.getItems()[i].CONTACT_ID
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            if (MasterData.IV_CUST_NM == '') {
                fn_info('[ 업체명 ] 값을 넣어주세요.');
                return;
            }
            if (MasterData.IV_CUST_ENM == '') {
                fn_info('[ 업체명(EN) ] 값을 넣어주세요.');
                return;
            }

            $.ajax({
                url: ServiceUrl + "SaveCustData",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "MasterData": MasterData, "MasterData_Team" : MasterData_Team, "PackageList": PackageList, "TestList": TestList, "ContactList": ContactList }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ulTabs li:eq(0) a').tab('show');
                        GetCustList();
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
        // Note - 업체 리스트
        //======================================================
        function GetCustList() {
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetCustList",
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
                            <label for="txtcust_id" class="control-label">■ Cust ID</label>
                            <input type="text" class="form-control input-sm" id="txtcust_id" name="txtcust_id" readonly="readonly" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="ddlstatus_cd" class="control-label">■ 상태</label>
                            <asp:DropDownList ID="ddlstatus_cd" runat="server" name="ddlstatus_cd" CssClass="form-control input-sm" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="clearfix"></div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcust_code" class="control-label">■ 업체코드(피닉스)</label>
                            <input type="text" class="form-control input-sm" id="txtcust_code" name="txtcust_code" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcust_nm" class="control-label lbl_Vali">■ 업체명</label>
                            <input type="text" class="form-control input-sm" id="txtcust_nm" name="txtcust_nm" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtcust_enm" class="control-label lbl_Vali">■ 업체명(EN)</label>
                            <input type="text" class="form-control input-sm" id="txtcust_enm" name="txtcust_enm" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="ddlbil_location" class="control-label ">■ 종류</label>
                            <asp:DropDownList ID="ddlbil_location" runat="server" name="ddlbil_location" CssClass="form-control input-sm" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="form-group col-md-6 col-xs-12">
                            <label for="ddlstatus_cd" class="control-label">■ 구분</label>
                            <table style="width: 100%; border-top: 2px solid #ddd;">
                                <tr>
                                    <td>
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="flat" id="chkcust_gb1" name="chkcust_gb1" />
                                                제출처
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="flat" id="chkcust_gb2" name="chkcust_gb2" />
                                                의뢰업체
                                            </label>
                                        </div>
                                    </td>
                                    <td class="hidden">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="flat" id="chkcust_gb3" name="chkcust_gb3" />
                                                인터텍
                                            </label>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtceo_nm" class="control-label ">■ 대표자</label>
                            <input type="text" class="form-control input-sm" id="txtceo_nm" name="txtceo_nm" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtbusiness_no" class="control-label ">■ 사업자번호</label>
                            <input type="text" class="form-control input-sm" id="txtbusiness_no" name="txtbusiness_no" />
                        </div>
                        <div class="clearfix"></div>
                         <div class="form-group col-xs-12">
                            <label for="ddlstatus_cd" class="control-label">■ 주요 분석</label>
                            <table style="width: 100%; border-top: 2px solid #ddd;">
                                <tr>
                                    <td>
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="flat" id="chkteam_gb1" name="chkteam_gb1" />
                                                석유제품 & LNG팀
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="flat" id="chkteam_gb2" name="chkteam_gb2" />
                                                석유화학 & LPG팀
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="flat" id="chkteam_gb3" name="chkteam_gb3" />
                                                유해물질 & 수질팀
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="flat" id="chkteam_gb4" name="chkteam_gb4" />
                                                에너지자원팀
                                            </label>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="clearfix"></div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtzip_cd" class="control-label ">■ 우편번호</label>
                            <div class="input-group">
                                <input type="text" class="form-control input-sm" id="txtzip_cd" name="txtzip_cd" readonly="readonly" />
                                <div class="input-group-btn">
                                    <button type="button" class="btn btn-default input-sm" id="btnaddr_popup" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                        <span class="glyphicon glyphicon-search"></span>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-md-6 col-xs-12">
                            <label for="txtaddr_kr1" class="control-label ">■ 주소</label>
                            <input type="text" class="form-control input-sm" id="txtaddr_kr1" name="txtaddr_kr1" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtaddr_kr2" class="control-label ">&nbsp;</label>
                            <input type="text" class="form-control input-sm" id="txtaddr_kr2" name="txtaddr_kr2" placeholder="나머지 주소" />
                        </div>
                        <div class="clearfix"></div>

                        <div class="form-group col-md-6 col-xs-12">
                            <label for="txtaddr_en1" class="control-label ">■ 주소(EN)</label>
                            <input type="text" class="form-control input-sm" id="txtaddr_en1" name="txtaddr_en1" />
                        </div>
                        <div class="form-group col-md-6 col-xs-12">
                            <label for="txtaddr_en2" class="control-label ">&nbsp;</label>
                            <input type="text" class="form-control input-sm" id="txtaddr_en2" name="txtaddr_en2" placeholder="나머지 주소" />
                        </div>

                        <div class="form-group col-md-6 col-xs-12">
                            <label for="txtbiz_class" class="control-label ">■ 업태</label>
                            <input type="text" class="form-control input-sm" id="txtbiz_class" name="txtbiz_class" />
                        </div>
                        <div class="form-group col-md-6 col-xs-12">
                            <label for="txtbiz_item" class="control-label ">■ 종목</label>
                            <input type="text" class="form-control input-sm" id="txtbiz_item" name="txtbiz_item" />
                        </div>

                        <div class="form-group col-md-12 col-xs-12">
                            <label for="txtremark" class="control-label">■ Remark</label>
                            <textarea id="txtremark" class="form-control input-sm" rows="3">
                            </textarea>
                        </div>
                        <div class="clearfix"></div>
                        <div class="col-xs-12 mgn_T15">
                            <ul class="nav nav-tabs" style="border-bottom: none;" id="ulTabs_sub1">
                                <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">Contract</a></li>
                                <li><a href="#tab_2" data-toggle="tab" aria-expanded="true">담당자</a></li>
                            </ul>
                            <div id="myTabContent2" class="tab-content " style="border: 1px solid #ddd; padding: 15px;">
                                <%--패키지 와 시험--%>
                                <div class="tab-pane fade active in mgn0" id="tab_1">
                                    <p><label for="txtremark" class="control-label">■ Package</label></p>
                                    <div style="border: 1px solid #ddd;">
                                        <div class="text-right mgn_B5 mgn_T10">
                                            <button type="button" class="btn btn-default btn-sm" id="btnpackage_add" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm" id="btnpackage_delete" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-trash"></span>
                                            </button>
                                        </div>
                                        <div id="grd_Package_List" style="height: 150px; border-top: 2px solid #555" class=""></div>
                                    </div>

                                    <p><label for="txtremark" class="control-label">■ 시험</label></p>
                                    <div style="border: 1px solid #ddd;">
                                        <div class="text-right mgn_B5 mgn_T10">
                                            <button type="button" class="btn btn-default btn-sm" id="btntest_add" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm" id="btntest_delete" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-trash"></span>
                                            </button>
                                        </div>
                                        <div id="grd_Test_List" style="height: 300px; border-top: 2px solid #555" class=""></div>
                                    </div>

                                </div>
                                <%--담당자--%>
                                <div class="tab-pane fade mgn0" id="tab_2">
                                    <p><label for="txtremark" class="control-label">■ 담당자</label></p>
                                    <div style="border: 1px solid #ddd;">
                                        <div class="text-right mgn_B5 mgn_T10">
                                            <button type="button" class="btn btn-default btn-sm" id="btncontact_add" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm" id="btncontact_delete" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-trash"></span>
                                            </button>
                                        </div>
                                        <div id="grd_Contact_List" style="height: 300px; border-top: 2px solid #555" class=""></div>
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
/* Contact 추가
/***********************************************************************************************/--%>
      <div class="modal fade" id="modalContact" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Contact Info</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnContactSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <div id="grd_Modal_Contact_List" style="height: 300px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>

    <%--***********************************************************************************************/
/* Package 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalPackage" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Package</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnmodalpackage_save">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <div id="grd_Modal_Package_List" style="height: 300px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>

     <%--***********************************************************************************************/
/* Test 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalTest" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Package</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnmodaltest_save">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <div id="grd_Modal_Test_List" style="height: 300px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
</asp:Content>

