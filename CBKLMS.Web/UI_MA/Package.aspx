<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Package.aspx.cs" Inherits="UI_MA_Package" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_MA/Package_Service.asmx/";
        var rateInt = 0;
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
                { id: "PACKAGE_NM", name: "Package 명", field: "PACKAGE_NM", cssClass: "cell-align-left", width: 200, sortable: true, formatter: GDH_TextPopupColor },
                { id: "PACKAGE_ENM", name: "Package 명(EN)", field: "PACKAGE_ENM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "REG_ID_NM", name: "등록자", field: "REG_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REG_DT_NM", name: "등록일자", field: "REG_DT_NM", cssClass: "cell-align-center", width: 150, sortable: true },
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
                { id: "TEST_NM", name: "시험명", field: "TEST_NM", cssClass: "cell-align-left", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "TEST_ENM", name: "시험명(EN)", field: "TEST_ENM", cssClass: "cell-align-left", width: 150, sortable: true },
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
        var columnFilters_TestMethod = {};
        function filter_TestMethod(item) {
            for (var columnId in columnFilters_TestMethod) {
                if (item[columnId] == null) {
                    return false;
                }
                else {
                    if (item[columnId] != undefined && columnId != undefined && columnFilters_TestMethod[columnId] != "" && item[columnId].toString().toLowerCase().indexOf(columnFilters_TestMethod[columnId]) == -1) {
                        // 요부분 바꿔야함.
                        var c = grd_Modal_Test_List.grid.getColumns()[grd_Modal_Test_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters_TestMethod[columnId]) {
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
                { id: "TEST_NM", name: "시험명", field: "TEST_NM", cssClass: "cell-align-left", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "TEST_ENM", name: "시험명(EN)", field: "TEST_ENM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "METHOD_NM", name: "시험방법", field: "METHOD_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "UNIT_NM", name: "Unit", field: "UNIT_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
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
                        GetPackageDataDtl(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    GetPackageDataDtl(row);
                    $('#ulTabs li:eq(1) a').tab('show');
                }
            });


            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수

            //-------------------------------------------------------
            // Test Method
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
            // Modal TEst Method
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
                    columnFilters_TestMethod[columnId] = $.trim($(this).val().toLowerCase());
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
                       .val(columnFilters_TestMethod[args.column.id])
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

            // Note - 클릭이벤트
            grd_Modal_Test_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_Modal_Test_List.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Modal_Test_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Modal_Test_List.grid.getDataItem(args.row);
                if (row != null) {
                }
            });


            grd_Modal_Test_List.grid.init();

            $("#lblTotal").text(grd_Modal_Test_List.dataView.getItems().length);//로우 토탈 건수
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            // 저장버튼
            $('#btnSave, #btnSaveAs').click(function () {
                SavePackageDetail(this.id);
            });
            $('#btnSearch').click(function () {
                GetPackageList();
            });
            $('#btnTestdAdd').click(function () {
                GetModalTestList();
                $('#modalTest').modal();
            });
            $('#btnTestDelete').click(function () {
                DeleteTestList();
            });

            $('#btnTestSave').click(function () {
                SaveModalTest();
            });
            $('#btnAdd1, #btnAdd2').click(function () {
                InitControls();
                $('#ulTabs li:eq(1) a').tab('show');
            });
            $('#txtpackage_amt_en').change(function () {
                $(this).val($.number(this.value, 2));
            });
            $('#txtpackage_amt_kr').change(function () {
                $(this).val($.number(this.value, 0));
            });

            // 초기 그리드 바인딩할때 필수..
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                grd_Test_List.grid.resizeCanvas();
            });
            // 모달 팝업 이벤트
            $('#modalTest').on('shown.bs.modal', function (e) {
                grd_Modal_Test_List.grid.resizeCanvas();
            });

            // 초반 조회
            grid_init();
            InitControls();
            GetPackageList();

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
        // Note - 초반 컨트롤 값 셋팅.
        //======================================================
        function InitControls() {
            fn_ClearControls($('#detail'))
            
            $('#btnSaveAs').addClass('hidden');

            rateInt = 0;
            $('#txtpackage_amt').val(rateInt);
            $('#txtpackage_amt').val($.number($('#txtpackage_amt').val(), rateInt));

            $('#txtpackage_amt_en').val(0);
            $('#txtpackage_amt_kr').val(0);

            fn_ClearGrid(grd_Test_List);
        }

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
        // Note - Package 저장.
        //======================================================
        function GetPackageDataDtl(row) {
            $('#btnSaveAs').removeClass('hidden');

            $('#txtpackage_id').val(row.PACKAGE_ID);
            $('#txtpackage_nm').val(row.PACKAGE_NM);
            $('#txtpackage_enm').val(row.PACKAGE_ENM);
            $('#txtpackage_amt_en').val(row.ENG_AMT);
            $('#txtpackage_amt_kr').val(row.KOR_AMT);
            $('#ddluse_yn').val(row.USE_YN);
            $('#txtremark').val(row.REMARK);

            var Gparam = {
                IV_PACKAGE_ID: row.PACKAGE_ID
            };
            $.ajax({
                url: ServiceUrl + "GetPackageDataDtl_Test",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Test_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Test_List.dataView.beginUpdate();
                        grd_Test_List.dataView.setItems(jsonData.result);
                        grd_Test_List.dataView.endUpdate();
                        grd_Test_List.grid.render();
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
        // Note - Package 저장.
        //======================================================
        function SavePackageDetail(btnId) {
            var Gparam = {
                IV_PACKAGE_ID: btnId == 'btnSaveAs' ? '' : $('#txtpackage_id').val(),
                IV_PACKAGE_NM: $('#txtpackage_nm').val(),
                IV_PACKAGE_ENM: $('#txtpackage_enm').val(),
                IV_ENG_AMT: $('#txtpackage_amt_en').val().replaceAll(',', ''),
                IV_KOR_AMT: $('#txtpackage_amt_kr').val().replaceAll(',', ''),
                IV_USE_YN: $('#ddluse_yn').val(),
                IV_REMARK: $('#txtremark').val(),
                IV_USER_ID: '<%= this.CkUserId %>'
            };

            var TestList = [];

            for (var i = 0; i < grd_Test_List.dataView.getItems().length; i++) {
                TestList.push({
                    IV_PACKAGE_ID: $('#txtpackage_id').val()
                    , IV_TEST_ID: grd_Test_List.dataView.getItems()[i].TEST_ID
                    , IV_UNIT_ID: grd_Test_List.dataView.getItems()[i].UNIT_ID
                    , IV_METHOD_ID: grd_Test_List.dataView.getItems()[i].METHOD_ID
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            if (Gparam.IV_PACKAGE_NM == '') {
                fn_info('[ Package 명 ] 값을 넣어주세요.');
                return;
            }
            if (Gparam.IV_PACKAGE_ENM == '') {
                fn_info('[ Package 명(EN) ] 값을 넣어주세요.');
                return;
            }

            $.ajax({
                url: ServiceUrl + "SavePackageDetail",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam, "TestList": TestList }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ulTabs li:eq(0) a').tab('show');
                        GetPackageList();
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
        // Note - Test Delete.
        //======================================================
        function DeleteTestList() {///
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
        // Note - Test Popup Save.
        //======================================================
        function SaveModalTest() {
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
            GetModalTestList();
        }
    

        //======================================================
        // Note - Test Modal List.
        //======================================================
        function GetModalTestList() {
            // var DeleteItem = [];

            //for (var i = 0; i < grd_Test_List.dataView.getItems().length; i++) {
            //    DeleteItem.push(grd_Test_List.dataView.getItems()[i]["id"])
            //}
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
                        grd_Modal_Test_List.dataView.setFilter(filter_TestMethod);
                        grd_Modal_Test_List.dataView.endUpdate();
                        grd_Modal_Test_List.grid.render();

                        //for (var i = 0; i < DeleteItem.length; i++) {
                        //    grd_Modal_Test_List.dataView.deleteItem(DeleteItem[i]);
                        //}
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
        // Note - Package List.
        //======================================================
        function GetPackageList() {
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetPackageList",
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
                            <label for="txtpackage_id" class="control-label">■ Package ID</label>
                            <input type="text" class="form-control input-sm" id="txtpackage_id" name="txtpackage_id" readonly="readonly" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtpackage_nm" class="control-label lbl_Vali">■ Package 명</label>
                            <input type="text" class="form-control input-sm" id="txtpackage_nm" name="txtpackage_nm" />
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtpackage_enm" class="control-label lbl_Vali">■ Package 명(EN)</label>
                            <input type="text" class="form-control input-sm" id="txtpackage_enm" name="txtpackage_enm" />
                        </div>
                        <div class="clearfix"></div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtpackage_amt_en" class="control-label">■ USD</label>
                            <div class="input-group">
                                <span class="input-group-addon">＄</span>
                                <input type="text" class="form-control input-sm text-right" id="txtpackage_amt_en" name="txtpackage_amt_en" style="font-size: 1.3em; font-weight: bold;" />
                            </div>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtpackage_amt_kr" class="control-label">■ KRW</label>
                            <div class="input-group">
                                <span class="input-group-addon">￦</span>
                                <input type="text" class="form-control input-sm text-right" id="txtpackage_amt_kr" name="txtpackage_amt_kr" style="font-size: 1.3em; font-weight: bold;" />
                            </div>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="ddluse_yn" class="control-label">■ 사용</label>
                            <asp:DropDownList ID="ddluse_yn" runat="server" name="ddluse_yn" CssClass="form-control input-sm" ClientIDMode="Static">
                                <asp:ListItem Text="Y" Value="Y" />
                                <asp:ListItem Text="N" Value="N" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group col-md-3 col-xs-12">
                            <label for="txtremark" class="control-label">■ 비고</label>
                            <input type="text" class="form-control input-sm" id="txtremark" name="txtremark" />
                        </div>
                        <div class="clearfix"></div>
                        <%--<fieldset class="scheduler-border " style="margin: 10px !important;">
                            <legend class="scheduler-border mgn_B5">시험</legend>
                            <div class="form-group text-right mgn_B20">
                                
                            </div>
                            <div style="border: 1px solid #ddd;">
                            </div>
                        </fieldset>--%>
                        <div class="col-xs-12 mgn_T15">
                            <ul class="nav nav-tabs" style="border-bottom: none;">
                                <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">시험</a></li>
                            </ul>
                            <div id="myTabContent2" class="tab-content " style="border: 1px solid #ddd; padding: 15px;">
                                <div class="tab-pane fade active in mgn0" id="tab_1">
                                    <div style="border: 1px solid #ddd;">
                                        <div class="text-right mgn_B5 mgn_T10">
                                            <button type="button" class="btn btn-default btn-sm" id="btnTestdAdd" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm" id="btnTestDelete" style="min-width: 1px;">
                                                <span class="glyphicon glyphicon-trash"></span>
                                            </button>
                                        </div>
                                        <div id="grd_Test_List" style="height: 300px; border-top:2px solid #555" class=""></div>
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
/* Role 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalTest" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Test</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnTestSave">
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

