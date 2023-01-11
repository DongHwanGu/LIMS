<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Announcement.aspx.cs" Inherits="UI_CM_Announcement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_CM/Announcement_Service.asmx/";
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
                { id: "ALERT_GB_NM", name: "구분", field: "ALERT_GB_NM", cssClass: "cell-align-center", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "NOTICE_TITLE", name: "제목", field: "NOTICE_TITLE", cssClass: "cell-align-left", width: 400, sortable: true },
                { id: "DISP_YN", name: "사용유무", field: "DISP_YN", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REG_ID_NM", name: "등록자", field: "REG_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REG_DT_NM", name: "등록일", field: "REG_DT_NM", cssClass: "cell-align-center", width: 150, sortable: true },
            ]
        };

        var grd_file_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_file_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: default_options,
            columns: [
                grd_file_List_checkbox.getColumnDefinition(),
                { id: "SAMPLE_NM", name: "파일명", field: "SAMPLE_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "SAMPLE_CNT", name: "파일주소", field: "SAMPLE_CNT", cssClass: "cell-align-center", width: 100, sortable: true },
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
            grd_Master_List.dataView.onRowCountChanged.subscribe(function (e, args ) {
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
                        GetAnnouncementDtl(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    GetAnnouncementDtl(row);
                    $('#ulTabs li:eq(1) a').tab('show');
                }
            });


            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수

            ////-------------------------------------------------------
            //// file List
            ////-------------------------------------------------------
            //// Note - Grid 초기화
            //grd_file_List.grid = new Slick.Grid("#grd_file_List", grd_file_List.dataView, grd_file_List.columns, grd_file_List.options);
            //// Note - Row 선택시 배경색 반전
            //grd_file_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            ////선택된 checkbox 선택 관련
            //grd_file_List.grid.registerPlugin(grd_file_List_checkbox);
            //grd_file_List.grid.setSelectedRows([]);

            //// Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            //grd_file_List.dataView.onRowCountChanged.subscribe(function (e, args) {
            //    grd_file_List.grid.updateRowCount();
            //    grd_file_List.grid.render();
            //});

            //// Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            //grd_file_List.dataView.onRowsChanged.subscribe(function (e, args) {
            //    grd_file_List.grid.invalidateRows(args.rows);
            //    grd_file_List.grid.render();
            //});

            //// Note - 클릭이벤트
            //grd_file_List.grid.onClick.subscribe(function (e, args) {
            //    var row = grd_file_List.grid.getDataItem(args.row);
            //    if (args.cell == '1') {
            //        if (row != null) {
            //            GetSampleModal(row);
            //        }
            //    }
            //});
            //// Note - 더블클릭이벤트
            //grd_file_List.grid.onDblClick.subscribe(function (e, args) {
            //    var row = grd_file_List.grid.getDataItem(args.row);
            //    if (row != null) {
            //        GetSampleModal(row);
            //    }
            //});

            //grd_file_List.grid.init();

            //-------------------------------------------------------
            // 담당자 설정
            //-------------------------------------------------------
            $grd_file_List = $("#grd_file_List"),
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

            $grd_file_List.jqGrid({
                datatype: 'local',
                data: [],
                colNames: ["파일명", "파일주소" ],
                colModel: [
                    { name: "FILE_NM", align: "left", width: 200, fixed: true, editable: false },
                    { name: "FILE_URL", align: "left", width: 400, fixed: true, editable: false },
                ],
                beforeEditCell: function (id, name, val, iRow, iCol) {
                },
                loadComplete: function () {
                },
                cmTemplate: { autoResizable: true, editable: true },
                iconSet: "fontAwesome",
                autowidth: true,
                shrinkToFit: false,
                grouping: true,
                cellEdit: true,
                height: 150,
                //caption: "Test List"
                multiselect: true,
            })
            //.jqGrid("navGrid")
            //.jqGrid("filterToolbar")
            .jqGrid("gridResize");
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            // 저장버튼
            $('#btnSave').click(function () {
                SaveAnnouncement();
            });
            $('#btnSearch').click(function () {
                GetAnnouncement();
            });
            $('#btnsample_delete').click(function () {
                DeleteFileList();
            });
            // 신규버튼
            $('#btnAdd1, #btnAdd2').click(function () {
                $('#ulTabs li:eq(1) a').tab('show');
                InitControls();
            });

            // 파일업로드
            $('#btnsample_add').click(function () {
                fileupload_obj.filemodal = $('#modalfileupload');
                fileupload_obj.multi = true;
                fileupload_obj.page = "Announcement";
                fileupload_obj.key = $('#txtnotice_id').val()
                $('#modalfileupload').modal();
            });

            // 초반 조회
            grid_init();
            InitControls();

            GetAnnouncement();

            // 초기 그리드 바인딩할때 필수..
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                ChangejQGridDesign("#grd_file_List", "");
            });
            $(document).on('focusout', '[role="gridcell"] *', function () {
                $("#grd_file_List").jqGrid('editCell', 0, 0, false);
            });


            //// 초기 그리드 바인딩할때 필수..
            //$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            //    grd_file_List.grid.resizeCanvas();
            //});
        })

        function InitControls() {
            fn_ClearControls($('#detail'));

            fn_DatePicker($('#txtstart_dt_s'));
            fn_DatePicker($('#txtend_dt_s'));
            $('#txtstart_dt_s').val(fn_today(-1));
            $('#txtend_dt_s').val(fn_today());

            fn_DatePicker($('#txtstart_dt'));
            fn_DatePicker($('#txtend_dt'));
            $('#txtstart_dt').val(fn_today());
            $('#txtend_dt').val(fn_today(1));


            $('#grd_file_List').jqGrid('clearGridData');

            $('#ddlalert_gb').empty();
            $('#ddlalert_gb').append(GetCMCODE_Level_New({ cd_major: "0103", cd_level: '11', IsEmpty: false, Text: "" }));
        }

        //======================================================
        // Note - 파일 삭제
        //======================================================
        function DeleteFileList() {
            var grdArr = $('#grd_file_List').jqGrid('getGridParam', 'selarrrow');

            if (grdArr.length == 0) {
                fn_info("선택된 파일이 없습니다.");
                return;
            }
            var selectGrdArr = grdArr.slice();
            for (var i = 0; i < selectGrdArr.length; i++) {
                var row = selectGrdArr[i];
                $("#grd_file_List").jqGrid("delRowData", row); // 행 삭제
            }

        }
        
        //======================================================
        // Note - 저장
        //======================================================
        function SaveAnnouncement() {
            var arrGparam = [];
            var dt = $('#grd_file_List').jqGrid('getGridParam', 'data');

            var Gparam = {
                IV_NOTICE_ID: $('#txtnotice_id').val(),
                IV_NOTICE_TITLE: $('#txttitle').val(),
                IV_NOTICE_DESC: $('#txtdesc').val(),
                IV_ALERT_GB: $('#ddlalert_gb').val(),
                IV_START_DATE: $('#txtstart_dt').val().replaceAll('-', ''),
                IV_END_DATE: $('#txtstart_dt').val().replaceAll('-', ''),
                IV_DISP_YN: $('#ddldisplay_yn').val(),
                IV_USER_ID: '<%= this.CkUserId %>'
            }

            for (var i = 0; i < dt.length; i++) {
                arrGparam.push({
                    IV_NOTICE_ID: $('#txtnotice_id').val(),
                    IV_FILE_NM: dt[i].FILE_NM,
                    IV_FILE_URL: dt[i].FILE_URL,
                    IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            $.ajax({
                url: ServiceUrl + "SaveAnnouncement",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam, "arrGparam": arrGparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ulTabs li:eq(0) a').tab('show');
                        GetAnnouncement();
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
        // Note - 리스트 상세 조회.
        //======================================================
        function GetAnnouncementDtl(row) {
            $('#txtnotice_id').val(row.NOTICE_ID);
            $('#ddldisplay_yn').val(row.DISP_YN);
            $('#ddlalert_gb').val(row.ALERT_GB);
            $('#txttitle').val(row.NOTICE_TITLE);
            $('#txtdesc').val(row.NOTICE_DESC);

            var Gparam = {
                IV_NOTICE_ID: row.NOTICE_ID,
            };
            $.ajax({
                url: ServiceUrl + "GetAnnouncementDtl",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        $('#grd_file_List').jqGrid('clearGridData');
                        $('#grd_file_List').jqGrid('setGridParam', { data: jsonData.result });
                        $('#grd_file_List').trigger('reloadGrid');
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
        function GetAnnouncement() {
            var Gparam = {
                IV_START_DT: $('#txtstart_dt_s').val().replaceAll('-', ''),
                IV_END_DT: $('#txtend_dt_s').val().replaceAll('-', ''),
                IV_DISP_YN: $('#ddldisplay_yn_s').val(),
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetAnnouncement",
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
        // Note - 업로드 후 Sample
        //======================================================
        function fileUploadBinding_file(jsonData) {
            if (jsonData != null) {
                $('#grd_file_List').jqGrid('clearGridData');
                $('#grd_file_List').jqGrid('setGridParam', { data: jsonData.result });
                $('#grd_file_List').trigger('reloadGrid');
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

                              <label for="ddlmasterstatus_cd_s" class="col-md-1 col-xs-4 control-label">사용유무</label>
                              <div class="col-md-3 col-xs-8">
                                  <asp:DropDownList ID="ddldisplay_yn_s" runat="server" name="ddldisplay_yn_s" CssClass="form-control input-sm" ClientIDMode="Static">
                                      <asp:ListItem Text="ALL" Value="" />
                                    <asp:ListItem Text="Y" Value="Y" />
                                    <asp:ListItem Text="N" Value="N" />
                                    </asp:DropDownList>
                              </div>
                          </div>
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
                    <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>

                </div>
                <div class="panel-body form-horizontal">
                    <%--form-group--%>
                    <div class="col-xs-12 layout_dtl_page">
                        <%--<fieldset class="scheduler-border ">
                            <legend class="scheduler-border">Master data</legend>--%>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="txtnotice_id" class="control-label">■ Id</label>
                                <input type="text" class="form-control input-sm" id="txtnotice_id" name="txtnotice_id" readonly="readonly" />
                            </div>
                            
                            <div class="form-group col-md-3 col-xs-12 hidden">
                                <label for="txtstart_dt" class="control-label">■ 시작시간</label>
                                <input type="text" class="form-control input-sm " id="txtstart_dt" name="txtstart_dt" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12 hidden">
                                <label for="txtend_dt" class="control-label">■ 종료시간</label>
                                <input type="text" class="form-control input-sm " id="txtend_dt" name="txtend_dt" readonly="readonly" />
                            </div>
                            <div class="form-group col-md-3 col-xs-12">
                                <label for="ddlUse_YN" class="control-label ">■ 사용유무</label>
                                <asp:DropDownList ID="ddldisplay_yn" runat="server" name="ddldisplay_yn" CssClass="form-control input-sm" ClientIDMode="Static">
                                    <asp:ListItem Text="Y" Value="Y" />
                                    <asp:ListItem Text="N" Value="N" />
                                </asp:DropDownList>
                            </div>
                        <div class="form-group col-md-3 col-xs-12">
                                <label for="ddlUse_YN" class="control-label ">■ 구분</label>
                                <asp:DropDownList ID="ddlalert_gb" runat="server" name="ddlalert_gb" CssClass="form-control input-sm" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-md-12 col-xs-12">
                                <label for="txttitle" class="control-label lbl_Vali">■ 제목</label>
                                <input type="text" class="form-control input-sm " id="txttitle" name="txttitle" />
                            </div>
                                <div class="form-group col-md-12 col-xs-12">
                                <label for="txtprogram_nm" class="control-label">■ 내용</label>
                                <textarea rows="5" class="form-control input-sm " id="txtdesc" name="txtdesc"></textarea>
                            </div>
                            <%--시료 정보--%>
                            <div class="form-group col-xs-12">
                                <fieldset class="scheduler-border">
                                    <legend class="scheduler-border">파일</legend>
                                    <div class="text-right mgn_B20" >
                                        <button type="button" class="btn btn-default btn-sm" id="btnsample_add" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-plus"></span>
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" id="btnsample_delete" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-trash"></span>
                                        </button>
                                    </div>
                                    <div style="border-top:2px solid #555 !important; margin-top:10px !important; ">
                                        <table id="grd_file_List" ></table>
                                    </div>

                                </fieldset>
                            </div>
                        
                        <%--</fieldset>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

