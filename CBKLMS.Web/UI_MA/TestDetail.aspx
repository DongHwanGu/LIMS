<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="TestDetail.aspx.cs" Inherits="UI_MA_TestDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_MA/TestDetail_Service.asmx/";
        
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
                { id: "TEST_NM", name: "시험항목명", field: "TEST_NM", cssClass: "cell-align-left", width: 200, sortable: true, formatter: GDH_TextPopupColor },
                { id: "TEST_ENM", name: "시험항목명(EN)", field: "TEST_ENM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "METHOD_NM", name: "시험방법", field: "METHOD_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "UNIT_NM", name: "Unit", field: "UNIT_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "REG_ID_NM", name: "등록자", field: "REG_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REG_DT_NM", name: "등록일자", field: "REG_DT_NM", cssClass: "cell-align-center", width: 150, sortable: true },
            ]
        };

        var grd_TestMethod_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_TestMethod_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                grd_TestMethod_List_checkbox.getColumnDefinition(),
                { id: "METHOD_NM", name: "방법명", field: "METHOD_NM", cssClass: "cell-align-left", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "METHOD_ENM", name: "방법명(EN)", field: "METHOD_ENM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "FIRST_YN", name: "대표", field: "FIRST_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
            ]
        };
        var grd_Unit_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Unit_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                grd_Unit_List_checkbox.getColumnDefinition(),
                { id: "UNIT_NM", name: "Unit 명", field: "UNIT_NM", cssClass: "cell-align-left", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "FIRST_YN", name: "대표", field: "FIRST_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 300, sortable: true },

            ]
        };

        var grd_Modal_Unit_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Modal_Unit_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: default_options,
            columns: [
                grd_Modal_Unit_List_checkbox.getColumnDefinition(),
                { id: "UNIT_NM", name: "Unit 명", field: "UNIT_NM", cssClass: "cell-align-left", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 300, sortable: true },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
            ]
        };

        var grd_Modal_TestMethod_List_checkbox = new Slick.CheckboxSelectColumn({
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
                        var c = grd_Modal_TestMethod_List.grid.getColumns()[grd_Modal_TestMethod_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters_TestMethod[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Modal_TestMethod_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Modal_TestMethod_List_checkbox.getColumnDefinition(),
                { id: "METHOD_NM", name: "방법명", field: "METHOD_NM", cssClass: "cell-align-left", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "METHOD_ENM", name: "방법명(EN)", field: "METHOD_ENM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
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
                        GetTestDataDtl(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    GetTestDataDtl(row);
                    $('#ulTabs li:eq(1) a').tab('show');
                }
            });


            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수

            //-------------------------------------------------------
            // Test Method
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_TestMethod_List.grid = new Slick.Grid("#grd_TestMethod_List", grd_TestMethod_List.dataView, grd_TestMethod_List.columns, grd_TestMethod_List.options);
            // Note - Row 선택시 배경색 반전
            grd_TestMethod_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_TestMethod_List.grid.registerPlugin(grd_TestMethod_List_checkbox);
            grd_TestMethod_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_TestMethod_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_TestMethod_List.grid.updateRowCount();
                grd_TestMethod_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_TestMethod_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_TestMethod_List.grid.invalidateRows(args.rows);
                grd_TestMethod_List.grid.render();
            });

            // Note - 클릭이벤트
            grd_TestMethod_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_TestMethod_List.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                        
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_TestMethod_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_TestMethod_List.grid.getDataItem(args.row);
                if (row != null) {
                    
                }
            });

            grd_TestMethod_List.grid.init();

            //-------------------------------------------------------
            // Unit
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Unit_List.grid = new Slick.Grid("#grd_Unit_List", grd_Unit_List.dataView, grd_Unit_List.columns, grd_Unit_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Unit_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Unit_List.grid.registerPlugin(grd_Unit_List_checkbox);
            grd_Unit_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Unit_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Unit_List.grid.updateRowCount();
                grd_Unit_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Unit_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Unit_List.grid.invalidateRows(args.rows);
                grd_Unit_List.grid.render();
            });

            grd_Unit_List.grid.init();

            //-------------------------------------------------------
            // Model Unit
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Modal_Unit_List.grid = new Slick.Grid("#grd_Modal_Unit_List", grd_Modal_Unit_List.dataView, grd_Modal_Unit_List.columns, grd_Modal_Unit_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Modal_Unit_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Modal_Unit_List.grid.registerPlugin(grd_Modal_Unit_List_checkbox);
            grd_Modal_Unit_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Modal_Unit_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Modal_Unit_List.grid.updateRowCount();
                grd_Modal_Unit_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Modal_Unit_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Modal_Unit_List.grid.invalidateRows(args.rows);
                grd_Modal_Unit_List.grid.render();
            });

            grd_Modal_Unit_List.grid.init();

            //-------------------------------------------------------
            // Modal TEst Method
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Modal_TestMethod_List.grid = new Slick.Grid("#grd_Modal_TestMethod_List", grd_Modal_TestMethod_List.dataView, grd_Modal_TestMethod_List.columns, grd_Modal_TestMethod_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Modal_TestMethod_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Modal_TestMethod_List.grid.registerPlugin(grd_Modal_TestMethod_List_checkbox);
            grd_Modal_TestMethod_List.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Modal_TestMethod_List.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters_TestMethod[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Modal_TestMethod_List.dataView.refresh();
                    $("#lblTotal").text(grd_Modal_TestMethod_List.grid.getDataLength());//로우 토탈 건수
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Modal_TestMethod_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters_TestMethod[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Modal_TestMethod_List.grid.render();
            });
            grd_Modal_TestMethod_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_Modal_TestMethod_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Modal_TestMethod_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Modal_TestMethod_List.grid.updateRowCount();
                grd_Modal_TestMethod_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Modal_TestMethod_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Modal_TestMethod_List.grid.invalidateRows(args.rows);
                grd_Modal_TestMethod_List.grid.render();
            });

            //// Note - 클릭이벤트
            //grd_Modal_TestMethod_List.grid.onClick.subscribe(function (e, args) {
            //    var row = grd_Modal_TestMethod_List.grid.getDataItem(args.row);
            //    if (args.cell == '1') {
            //        if (row != null) {
            //            SaveModalTestMethod(row);
            //        }
            //    }
            //});
            //// Note - 더블클릭이벤트
            //grd_Modal_TestMethod_List.grid.onDblClick.subscribe(function (e, args) {
            //    var row = grd_Modal_TestMethod_List.grid.getDataItem(args.row);
            //    if (row != null) {
            //        SaveModalTestMethod(row);
            //    }
            //});


            grd_Modal_TestMethod_List.grid.init();

            $("#lblTotal").text(grd_Modal_TestMethod_List.dataView.getItems().length);//로우 토탈 건수
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            
            // 저장버튼
            $('#btnSave, #btnSaveAs').click(function () {
                SaveTestDetail(this.id);
            });
            $('#btnSearch').click(function () {
                GetTestList();
            });
            $('#btnTestMethodAdd').click(function () {
                grd_Modal_TestMethod_List.grid.setSelectedRows([]);
                GetModalTestMethodList();
                $('#modalTestMethod').modal();
            });
            $('#btnTestMethodDelete').click(function () {
                DeleteTestMethodList();
            });
            $('#btnUnitDelete').click(function () {
                DeleteUnitList();
            });
            $('#btnUnitAdd').click(function () {
                grd_Modal_Unit_List.grid.setSelectedRows([]);
                GetModalUnitList();
                $('#modalUnit').modal();
            });
            $('#btnTestMethodSave').click(function () {
                SaveModalTestMethod();
            });
            $('#btnUnitSave').click(function () {
                SaveModalUnit();
            });

            $('#btnAdd1, #btnAdd2').click(function () {
                InitControls();
                $('#ulTabs li:eq(1) a').tab('show');
            });
            
            // 초기 그리드 바인딩할때 필수..
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                grd_TestMethod_List.grid.resizeCanvas();
                grd_Unit_List.grid.resizeCanvas();
            });
            // 모달 팝업 이벤트
            $('#modalUnit').on('shown.bs.modal', function (e) {
                grd_Modal_Unit_List.grid.resizeCanvas();
            });
            $('#modalTestMethod').on('shown.bs.modal', function (e) {
                grd_Modal_TestMethod_List.grid.resizeCanvas();
            });

            // 초반 조회
            grid_init();
            InitControls();
            GetTestList();

            $('.slick-viewport').on('blur', 'input.editor-text', function (e) {
                window.setTimeout(function () {
                    Slick.GlobalEditorLock.commitCurrentEdit();
                }, 0);
            })
            $('#grd_Unit_List').on('blur', 'input.editor-checkbox', function (e) {
                window.setTimeout(function () {
                    Slick.GlobalEditorLock.commitCurrentEdit();
                    SetGridCheckFalse(grd_Unit_List);
                }, 0);
            })
            $('#grd_TestMethod_List').on('blur', 'input.editor-checkbox', function (e) {
                window.setTimeout(function () {
                    Slick.GlobalEditorLock.commitCurrentEdit();
                    SetGridCheckFalse(grd_TestMethod_List);
                }, 0);
            })
            $('.slick-viewport').on('blur', 'select.editor-select', function (e) {
                window.setTimeout(function () {
                    Slick.GlobalEditorLock.commitCurrentEdit();
                }, 0);
            });

        })

        //======================================================
        // Note - 초반 컨트롤 값 셋팅.
        //======================================================
        function InitControls() {
            fn_ClearControls($('#detail'))
            
            fn_ClearGrid(grd_TestMethod_List);
            fn_ClearGrid(grd_Unit_List);

            $('#btnSaveAs').addClass('hidden');

            // Role Set
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "InitControls_Unit",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);
                    var options = "";
                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        for (var i = 0; i < jsonData.result.length; i++) {
                            options += "<option value='" + jsonData.result[i].UNIT_ID + "'>" + jsonData.result[i].UNIT_NM + "</option>";
                        }

                        $('#ddlunit_id').empty();
                        $('#ddlunit_id').append(options);
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
        // Note - GridCheckbox False.
        //======================================================
        function SetGridCheckFalse(grd) {
            var gridData = grd.grid.getSelectedRows();

            for (var i = 0; i < grd.dataView.getItems().length; i++) {
                if (gridData != i) {
                    var entry = grd.dataView.getItems()[i];
                    entry.FIRST_YN = 'N';

                    grd.dataView.beginUpdate();
                    grd.dataView.updateItem(entry.id, entry);
                    grd.dataView.endUpdate();
                }
            }
        }

        //======================================================
        // Note - Unit Delete.
        //======================================================
        function DeleteUnitList() {
            if (grd_Unit_List.grid.getSelectedRows().length == 0) {
                fn_info('데이터를 선택해 주세요.');
                return;
            }

            var gridData = grd_Unit_List.grid.getSelectedRows();

            var DeleteData = [];
            for (var i = 0; i < gridData.length; i++) {
                DeleteData.push(grd_Unit_List.grid.getDataItem(gridData[i])["id"]);
            }
            for (var i = 0; i < DeleteData.length; i++) {
                grd_Unit_List.dataView.deleteItem(DeleteData[i]);
            }
        }

        //======================================================
        // Note - Test Method Delete.
        //======================================================
        function DeleteTestMethodList() {
            if (grd_TestMethod_List.grid.getSelectedRows().length == 0) {
                fn_info('데이터를 선택해 주세요.');
                return;
            }

            var gridData = grd_TestMethod_List.grid.getSelectedRows();

            var DeleteData = [];
            for (var i = 0; i < gridData.length; i++) {
                DeleteData.push(grd_TestMethod_List.grid.getDataItem(gridData[i])["id"]);
            }
            for (var i = 0; i < DeleteData.length; i++) {
                grd_TestMethod_List.dataView.deleteItem(DeleteData[i]);
            }
        }


        //======================================================
        // Note - Unit Popup Save.
        //======================================================
        function SaveModalUnit() {
            if (grd_Modal_Unit_List.grid.getSelectedRows().length == 0) {
                fn_info('선택된 데이터가 없습니다.');
                return;
            }

            var gridData = grd_Modal_Unit_List.grid.getSelectedRows();

            for (var i = 0; i < gridData.length; i++) {

                var ModalList = {
                    id: grd_Modal_Unit_List.grid.getDataItem(gridData[i])["id"],
                    UNIT_ID: grd_Modal_Unit_List.grid.getDataItem(gridData[i])["UNIT_ID"],
                    UNIT_NM: grd_Modal_Unit_List.grid.getDataItem(gridData[i])["UNIT_NM"],
                    USE_YN: grd_Modal_Unit_List.grid.getDataItem(gridData[i])["USE_YN"],
                    REMARK: grd_Modal_Unit_List.grid.getDataItem(gridData[i])["REMARK"],
                    IV_USER_ID: '<%= this.CkUserId %>'
                };
                grd_Unit_List.dataView.addItem(ModalList);
            }

            $('#modalUnit').modal('hide');
        }


        //======================================================
        // Note - Test Method Popup Save.
        //======================================================
        function SaveModalTestMethod() {
            if (grd_Modal_TestMethod_List.grid.getSelectedRows().length == 0) {
                fn_info('선택된 데이터가 없습니다.');
                return;
            }

            var gridData = grd_Modal_TestMethod_List.grid.getSelectedRows();

            for (var i = 0; i < gridData.length; i++) {

                var ModalList = {
                    id: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["id"],
                    METHOD_ID: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["METHOD_ID"],
                    METHOD_NM: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["METHOD_NM"],
                    METHOD_ENM: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["METHOD_ENM"],
                    ENG_AMT: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["ENG_AMT"],
                    KOR_AMT: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["KOR_AMT"],
                    CURRENCY_CD_NM: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["CURRENCY_CD_NM"],
                    METHOD_AMT: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["METHOD_AMT"],
                    USE_YN: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["USE_YN"],
                    REMARK: grd_Modal_TestMethod_List.grid.getDataItem(gridData[i])["REMARK"],
                    IV_USER_ID: '<%= this.CkUserId %>'
                };
                grd_TestMethod_List.dataView.addItem(ModalList);
            }

            $('#modalTestMethod').modal('hide');
        }

        
        //======================================================
        // Note - Unit Popup.
        //======================================================
        function GetModalUnitList() {
            var DeleteItem = [];

            for (var i = 0; i < grd_Unit_List.dataView.getItems().length; i++) {
                DeleteItem.push(grd_Unit_List.dataView.getItems()[i]["id"])
            }
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetModalUnitList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Modal_TestMethod_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Modal_Unit_List.dataView.beginUpdate();
                        grd_Modal_Unit_List.dataView.setItems(jsonData.result);
                        grd_Modal_Unit_List.dataView.endUpdate();
                        grd_Modal_Unit_List.grid.render();

                        for (var i = 0; i < DeleteItem.length; i++) {
                            grd_Modal_Unit_List.dataView.deleteItem(DeleteItem[i]);
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
        // Note - Test Method Popup.
        //======================================================
        function GetModalTestMethodList() {
            var DeleteItem = [];

            for (var i = 0; i < grd_TestMethod_List.dataView.getItems().length; i++) {
                DeleteItem.push(grd_TestMethod_List.dataView.getItems()[i]["id"])
            }
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetModalTestMethodList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Modal_TestMethod_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Modal_TestMethod_List.dataView.beginUpdate();
                        grd_Modal_TestMethod_List.dataView.setItems(jsonData.result);
                        grd_Modal_TestMethod_List.dataView.setFilter(filter_TestMethod);
                        grd_Modal_TestMethod_List.dataView.endUpdate();
                        grd_Modal_TestMethod_List.grid.render();

                        for (var i = 0; i < DeleteItem.length; i++) {
                            grd_Modal_TestMethod_List.dataView.deleteItem(DeleteItem[i]);
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
        // Note - Test 상세.
        //======================================================
        function GetTestDataDtl(row) {
            $('#ulTabs2 li:eq(0) a').tab('show');

            $('#btnSaveAs').removeClass('hidden');

            $('#txttest_id').val(row.TEST_ID);
            $('#txttest_nm').val(row.TEST_NM);
            $('#txttest_enm').val(row.TEST_ENM);
            $('#ddlunit_id').val(row.UNIT_ID);
            $('#ddluse_yn').val(row.USE_YN);
            $('#txtremark').val(row.REMARK);
            
            var Gparam = {
                IV_TEST_ID: row.TEST_ID
            };
            $.ajax({
                url: ServiceUrl + "GetTestDataDtl_Method",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Unit_List);
                    fn_ClearGrid(grd_TestMethod_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Unit_List.dataView.beginUpdate();
                        grd_Unit_List.dataView.setItems(jsonData.UNIT_LIST);
                        grd_Unit_List.dataView.endUpdate();
                        grd_Unit_List.grid.render();

                        grd_TestMethod_List.dataView.beginUpdate();
                        grd_TestMethod_List.dataView.setItems(jsonData.TESTMETHOD_LIST);
                        grd_TestMethod_List.dataView.endUpdate();
                        grd_TestMethod_List.grid.render();
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
        // Note - Test 저장.
        //======================================================
        function SaveTestDetail(btnId) {
            var Gparam = {
                IV_TEST_ID: btnId == 'btnSaveAs' ? '' : $('#txttest_id').val(),
                IV_TEST_NM: $('#txttest_nm').val(),
                IV_TEST_ENM: $('#txttest_enm').val(),
                IV_UNIT_ID: 0, //$('#ddlunit_id').val(),
                IV_USE_YN: $('#ddluse_yn').val(),
                IV_REMARK: $('#txtremark').val(),
                IV_USER_ID: '<%= this.CkUserId %>'
            };

            var TestUnit = [];

            for (var i = 0; i < grd_Unit_List.dataView.getItems().length; i++) {
                TestUnit.push({
                    IV_TEST_ID: $('#txttest_id').val()
                    , IV_UNIT_ID: grd_Unit_List.dataView.getItems()[i].UNIT_ID
                    , IV_FIRST_YN: grd_Unit_List.dataView.getItems()[i].FIRST_YN == null ? 'N' : grd_Unit_List.dataView.getItems()[i].FIRST_YN
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            var TestMethod = [];

            for (var i = 0; i < grd_TestMethod_List.dataView.getItems().length; i++) {
                TestMethod.push({
                    IV_TEST_ID: $('#txttest_id').val()
                    , IV_METHOD_ID: grd_TestMethod_List.dataView.getItems()[i].METHOD_ID
                    , IV_FIRST_YN: grd_TestMethod_List.dataView.getItems()[i].FIRST_YN == null ? 'N' : grd_TestMethod_List.dataView.getItems()[i].FIRST_YN
                    , IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            var boolTestUnit = true;
            for (var i = 0; i < TestUnit.length; i++) {
                if (TestUnit[i].IV_FIRST_YN == 'Y') {
                    boolTestUnit = false;
                }
            }
            var boolTestMethod = true;
            for (var i = 0; i < TestMethod.length; i++) {
                if (TestMethod[i].IV_FIRST_YN == 'Y') {
                    boolTestMethod = false;
                }
            }


        if (Gparam.IV_TEST_NM == '') {
            fn_info('[ 시험항목명 ] 값을 넣어주세요.');
            return;
        }
        if (Gparam.IV_TEST_ENM == '') {
            fn_info('[ 시험항목명(EN) ] 값을 넣어주세요.');
            return;
        }
        if (TestMethod.length < 1) {
            fn_info('[ 시험방법 ] 을 설정해 주세요.');
            return;
        }
        if (boolTestUnit) {
            fn_info('[ UNIT 관리 ] 대표항목을 체크해 주세요.');
            return;
        }
        if (boolTestMethod) {
            fn_info('[ 시험방법 ] 대표항목을 체크해 주세요.');
            return;
        }

        $.ajax({
            url: ServiceUrl + "SaveTestDetail",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({ "Gparam": Gparam, "TestUnit": TestUnit, "TestMethod": TestMethod }),
            dataType: "json",
            success: function (response) {
                var result = response.d;

                if (result.OV_RTN_CODE == "0") {
                    $('#ulTabs li:eq(0) a').tab('show');
                    GetTestList();
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
    // Note - Test 리스트
    //======================================================
    function GetTestList() {
        var Gparam = {
            IV_USER_ID: '<%= CkUserId %>'
            };
        $.ajax({
            url: ServiceUrl + "GetTestList",
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

      <%--***********************************************************************************************/
/* Method 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalTestMethod" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Test Method</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnTestMethodSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <div id="grd_Modal_TestMethod_List" style="height: 300px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
    <%--***********************************************************************************************/
/* Unit 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalUnit" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Test Method</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnUnitSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <div id="grd_Modal_Unit_List" style="height: 300px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
</asp:Content>

