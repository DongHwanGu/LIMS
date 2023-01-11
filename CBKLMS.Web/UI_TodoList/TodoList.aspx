<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="TodoList.aspx.cs" Inherits="UI_TodoList_TodoList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_TodoList/TodoList_Service.asmx/";
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
                        SetTodoListDetail(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    SetTodoListDetail(row);
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
            $('#btnSearch').click(function () {
                GetTotoList();
            });

            grid_init();
            InitControls();

            // 초반조회
            GetTotoList();
        })
        //======================================================
        // Note - 초반 컨트롤 값 셋팅.
        //======================================================
        function InitControls() {
            fn_DatePicker($('#txtstart_dt_s'));
            fn_DatePicker($('#txtend_dt_s'));
            $('#txtstart_dt_s').val(fn_today(null, -3));
            $('#txtend_dt_s').val(fn_today());

            $('#ddlmasterstatus_cd_s').empty();
            $('#ddlmasterstatus_cd_s').append(GetCMCODE_Level_New({ cd_major: "0005", cd_level: '11', IsEmpty: true, Text: "ALL" }));
        }

        //======================================================
        // Note - 리스트 조회.
        //======================================================
        function GetTotoList() {
            var Gparam = {
                IV_START_DT: $('#txtstart_dt_s').val().replaceAll('-', ''),
                IV_END_DT: $('#txtend_dt_s').val().replaceAll('-', ''),
                IV_MASTER_STATUS_CD: $('#ddlmasterstatus_cd_s').val(),
                IV_REQ_CODE: $.trim($('#txtreg_no').val()).toUpperCase(),
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetTotoList",
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
                            <div class="ClearPhone"></div>
                            <label for="ddlmasterstatus_cd_s" class="col-md-1 col-xs-4 control-label">접수번호</label>
                            <div class="col-md-3 col-xs-8">
                                <asp:TextBox runat="server" ID="txtreg_no" CssClass="form-control input-sm" ClientIDMode="Static" />
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
</asp:Content>

