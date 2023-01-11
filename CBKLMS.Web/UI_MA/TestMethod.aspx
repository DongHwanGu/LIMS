<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="TestMethod.aspx.cs" Inherits="UI_MA_TestMethod" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var rateInt = 0;

        var ServiceUrl = "/WebService/UI_MA/TestMethod_Service.asmx/";
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
                { id: "METHOD_NM", name: "방법명", field: "METHOD_NM", cssClass: "cell-align-left", width: 200, sortable: true, formatter: GDH_TextPopupColor },
                { id: "METHOD_ENM", name: "방법명(EN)", field: "METHOD_ENM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "USE_YN", name: "사용", field: "USE_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 300, sortable: true },
                { id: "REG_ID_NM", name: "등록자", field: "REG_ID_NM", cssClass: "cell-align-center", width: 150, sortable: true },
                { id: "REG_DT_NM", name: "등록일자", field: "REG_DT_NM", cssClass: "cell-align-center", width: 150, sortable: true },
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
                        SetTestMethodData(row);
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    SetTestMethodData(row);
                }
            });

            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            $('#txtmethod_amt_en').change(function () {
                $('#txtmethod_amt_en').val($.number($('#txtmethod_amt_en').val(), 2));
            });
            $('#txttraining_amt_kr').change(function () {
                $('#txttraining_amt_kr').val($.number($('#txttraining_amt_kr').val(), 0));
            });

            // 저장버튼
            $('#btnTestMethodSave, #btnTestMethodSaveAs').click(function () {
                SaveTestMethodData(this.id);
            });
            $('#btnSearch').click(function () {
                GetTestMethodList();
            });
            $('#btnAdd').click(function () {
                fn_ClearControls($('#modalTestMethodData'));
                $('#btnTestMethodSaveAs').addClass('hidden');
                $('#txtmethod_amt_en').val(0);
                $('#txttraining_amt_kr').val(0);
                $('#txtmethod_amt').val(0);
                $('#modalTestMethodData').modal();
            });
            // 초반 조회
            grid_init();
            InitControls();
            GetTestMethodList();
        })

        //======================================================
        // Note - 초반 컨트롤 값 셋팅.
        //======================================================
        function InitControls() {
            $('#btnTestMethodSaveAs').addClass('hidden');
        }

        //======================================================
        // Note - 프로그램 상세.
        //======================================================
        function SetTestMethodData(row) {
            $('#btnTestMethodSaveAs').removeClass('hidden');
            $('#hidmethod_id').val(row.METHOD_ID);
            $('#txtmethod_nm').val(row.METHOD_NM);
            $('#txtmethod_enm').val(row.METHOD_ENM);
            $('#txtmethod_amt_en').val(row.ENG_AMT);
            $('#txttraining_amt_kr').val(row.KOR_AMT);
            $('#txtremark').val(row.REMARK);
            $('#ddluse_yn').val(row.USE_YN);
            $('#modalTestMethodData').modal();
        }

        //======================================================
        // Note - 프로그램 저장.
        //======================================================
        function SaveTestMethodData(btnId) {
            var Gparam = {
                IV_METHOD_ID: btnId == 'btnTestMethodSaveAs' ? '' : $('#hidmethod_id').val(),
                IV_METHOD_NM: $('#txtmethod_nm').val(),
                IV_METHOD_ENM: $('#txtmethod_enm').val(),
                IV_ENG_AMT: $('#txtmethod_amt_en').val().replaceAll(',', ''),
                IV_KOR_AMT: $('#txttraining_amt_kr').val().replaceAll(',', ''),
                IV_REMARK: $('#txtremark').val(),
                IV_USE_YN: $('#ddluse_yn').val(),
                IV_USER_ID: '<%= this.CkUserId %>'
            };
            if (Gparam.IV_METHOD_NM == '') {
                fn_info('[ 방법명 ] 값을 입력해주세요.');
                return;
            }
            if (Gparam.IV_METHOD_ENM == '') {
                fn_info('[ 방법명(EN) ] 값을 입력해주세요.');
                return;
            }

        $.ajax({
            url: ServiceUrl + "SaveTestMethodData",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({ "Gparam": Gparam }),
            dataType: "json",
            success: function (response) {
                var result = response.d;

                if (result.OV_RTN_CODE == "0") {
                    $('#modalTestMethodData').modal('hide');
                    GetTestMethodList();
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
    // Note - 시험방법 리스트
    //======================================================
        function GetTestMethodList() {
        var Gparam = {
            IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetTestMethodList",
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
    </ul>
    <div id="myTabContent" class="tab-content">
        <%--리스트--%>
        <div class="tab-pane fade active in" id="list">
            <div class="panel panel-default">
                <div class="panel-heading form-horizontal">
                    <div class="panel_serch">
                    </div>
                    <button type="button" class="btn btn-primary btn-sm" data-toggle="confirmation" data-popout="true" id="btnSearch">
                        <span class="glyphicon glyphicon glyphicon-search"></span>&nbsp;Search
                    </button>
                    <button type="button" class="btn btn-default btn-sm" id="btnAdd">
                        <span class="glyphicon glyphicon-plus"></span>&nbsp;Add
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
    </div>


    <%--***********************************************************************************************/
/* Item 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalTestMethodData" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Test Method</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnTestMethodSaveAs">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save As
                    </button>
                    <button type="button" class="btn btn-success btn-sm" id="btnTestMethodSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body">
                    <div class="form-group col-xs-12">
                        <label for="hidmethod_id" class="control-label">■ Method ID</label>
                        <input type="text" class="form-control input-sm" id="hidmethod_id" name="hidmethod_id" readonly="readonly" />
                    </div>
                    <div class="form-group col-xs-12">
                        <label for="txtmethod_nm" class="control-label lbl_Vali">■ 방법명</label>
                        <input type="text" class="form-control input-sm" id="txtmethod_nm" name="txtmethod_nm" />
                    </div>
                    <div class="form-group col-xs-12">
                        <label for="txtmethod_enm" class="control-label lbl_Vali">■ 방법명(EN)</label>
                        <input type="text" class="form-control input-sm" id="txtmethod_enm" name="txtmethod_enm" />
                    </div>

                    <div class="form-group col-xs-12">
                        <label for="txtmethod_amt_en" class="control-label">■ USD</label>
                        <div class="input-group">
                            <span class="input-group-addon">＄</span>
                            <input type="text" class="form-control input-sm text-right" id="txtmethod_amt_en" name="txtmethod_amt_en" style="font-size: 1.3em; font-weight:bold;" />
                        </div>
                    </div>
                    <div class="form-group col-xs-12">
                        <label for="txttraining_amt_kr" class="control-label">■ KRW</label>
                        <div class="input-group">
                            <span class="input-group-addon">￦</span>
                            <input type="text" class="form-control input-sm text-right" id="txttraining_amt_kr" name="txttraining_amt_kr" style="font-size: 1.3em; font-weight:bold;" />
                        </div>
                    </div>
                    <div class="form-group col-xs-12">
                        <label for="txtremark" class="control-label">■ 비고</label>
                        <input type="text" class="form-control input-sm" id="txtremark" name="txtremark" />
                    </div>
                    <div class="form-group col-xs-12">
                        <label for="ddluse_yn" class="control-label">■ 사용</label>
                        <asp:DropDownList ID="ddluse_yn" runat="server" name="ddluse_yn" CssClass="form-control input-sm" ClientIDMode="Static">
                            <asp:ListItem Text="Y" Value="Y" />
                            <asp:ListItem Text="N" Value="N" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="modal-footer mgn_T15">
                </div>
            </div>
        </div>
    </div>

</asp:Content>

