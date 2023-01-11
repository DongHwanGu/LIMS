<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="UserLogin.aspx.cs" Inherits="UI_CM_UserLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_CM/UserLogin_Service.asmx/";
        //======================================================
        // Note - 변수
        //======================================================
        var grd_LoginLog_List_checkbox = new Slick.CheckboxSelectColumn({
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
                        var c = grd_LoginLog_List.grid.getColumns()[grd_LoginLog_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_LoginLog_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_LoginLog_List_checkbox.getColumnDefinition(),
                { id: "LOGIN_DT_NM", name: "Login Dt", field: "LOGIN_DT_NM", cssClass: "cell-align-center", width: 150, sortable: true, formatter: GDH_TextPopupColor },
                { id: "LOGIN_USER_ID_NM", name: "User Nm", field: "LOGIN_USER_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "DEPT_CD1", name: "Dept 1", field: "DEPT_CD1", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DEPT_CD2", name: "Dept 2", field: "DEPT_CD2", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "LOGIN_IP", name: "IP", field: "LOGIN_IP", cssClass: "cell-align-center", width: 150, sortable: true },
                { id: "BROWSER_TYPE", name: "Brower Type", field: "BROWSER_TYPE", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "BROWSER_VER", name: "Brower Ver", field: "BROWSER_VER", cssClass: "cell-align-center", width: 150, sortable: true },
                { id: "TOTAL_INFO", name: "Total Info", field: "TOTAL_INFO", cssClass: "cell-align-center", width: 300, sortable: true },
            ]
        };

        //======================================================
        // Note - 그리드 설정을 정의한다.
        //======================================================
        function grid_init() {
            //-------------------------------------------------------
            // e-Works
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_LoginLog_List.grid = new Slick.Grid("#grd_LoginLog_List", grd_LoginLog_List.dataView, grd_LoginLog_List.columns, grd_LoginLog_List.options);
            // Note - Row 선택시 배경색 반전
            grd_LoginLog_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_LoginLog_List.grid.registerPlugin(grd_LoginLog_List_checkbox);
            grd_LoginLog_List.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_LoginLog_List.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters[columnId] = $.trim($(this).val().toLowerCase());
                    grd_LoginLog_List.dataView.refresh();
                    $("#lblTotal").text(grd_LoginLog_List.grid.getDataLength());//로우 토탈 건수
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_LoginLog_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_LoginLog_List.grid.render();
            });
            grd_LoginLog_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_LoginLog_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_LoginLog_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_LoginLog_List.grid.updateRowCount();
                grd_LoginLog_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_LoginLog_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_LoginLog_List.grid.invalidateRows(args.rows);
                grd_LoginLog_List.grid.render();
            });

            // Note - 클릭이벤트
            grd_LoginLog_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_LoginLog_List.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_LoginLog_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_LoginLog_List.grid.getDataItem(args.row);
                if (row != null) {
                }
            });

            grd_LoginLog_List.grid.init();

            $("#lblTotal").text(grd_LoginLog_List.dataView.getItems().length);//로우 토탈 건수
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(document).ready(function () {
            fn_DatePicker($('#txtstart_dt_s'));
            fn_DatePicker($('#txtend_dt_s'));

            $('#txtstart_dt_s').val(fn_today());
            $('#txtend_dt_s').val(fn_today());

            grid_init();

            GetLogDataList();

            $('#btnSearch').click(function () {
                GetLogDataList();
            });
            // 초기 그리드 바인딩할때 필수..
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            });
        });

        //======================================================
        // Note - 로그인 리스트 가져오기
        //======================================================
        function GetLogDataList() {
            var Gparam = {
                IV_FROM_DT: $('#txtstart_dt_s').val().replaceAll('-', '') + "000000",
                IV_END_DT: $('#txtend_dt_s').val().replaceAll('-', '') + "235959"
            };
            $.ajax({
                url: ServiceUrl + "GetLogDataList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ 'Gparam': Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_LoginLog_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_LoginLog_List.dataView.beginUpdate();
                        grd_LoginLog_List.dataView.setItems(jsonData.result);
                        grd_LoginLog_List.dataView.setFilter(filter);
                        grd_LoginLog_List.dataView.endUpdate();
                        grd_LoginLog_List.grid.render();

                        $("#lblTotal").text(grd_LoginLog_List.dataView.getItems().length);//로우 토탈 건수
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
        <li class="active"><a href="#list" data-toggle="tab" aria-expanded="true">CBKLMS</a></li>
        <%--<li><a href="#frm_list" data-toggle="tab" aria-expanded="true">Solution</a></li>--%>
    </ul>
    <div id="myTabContent" class="tab-content">
        <%--리스트--%>
        <div class="tab-pane fade active in" id="list">
            <div class="panel panel-default">
                <div class="panel-heading form-horizontal">
                    <div class="panel_serch">
                        <div class="form-group">
                            <label for="ddlstatus_s" class="col-md-1 col-xs-4 control-label">Request Dt</label>
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
                        </div>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-primary btn-sm" data-toggle="confirmation" data-popout="true" id="btnSearch">
                            <span class="glyphicon glyphicon glyphicon-search"></span>&nbsp;Search
                        </button>
                    </div>
                </div>
                <div class="panel-body pdd0">
                    <div id="grd_LoginLog_List" style="height: 650px;" class="grd_height_size"></div>
                    <p class="panel-body-List-cnt">
                        Total :
                        <label id="lblTotal"></label>
                    </p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

