<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="SiteMain.aspx.cs" Inherits="Main_SiteMain" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <link href="/Content/ui.jqgrid.css" rel="stylesheet" />
    <link href="/Content/JqGrid_Common.css" rel="stylesheet" />

    <script src="/Scripts/free-jqGrid/i18n/grid.locale-en.js"></script>
    <script>
        $.jgrid = $.jgrid || {};
        $.jgrid.no_legacy_api = true;
        function GDH_TextAlertColor(row, cell, value, columnDef, dataContext) {
            if (value == '중요' || value == '휴근') {
                return "<span style='color:#d9534f;'><b>" + value + "</b></span>";
            }
            if (value == '알림' || value == '교육') {
                return "<span style='color:orange;'><b>" + value + "</b></span>";
            }
            return "<span>" + value + "</span>";
        }
    </script>
    <script src="/Scripts/free-jqGrid/jquery.jqgrid.src.js"></script>


    <script>

        var ServiceUrl = "/WebService/SiteMaster_Service.asmx/";

        var grd_Worker_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Worker_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                grd_Worker_List_checkbox.getColumnDefinition(),
                { id: "DUTY_CD_KOR_NM", name: "직급", field: "DUTY_CD_KOR_NM", cssClass: "cell-align-center", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "USER_NM", name: "이름", field: "USER_NM", cssClass: "cell-align-center", width: 200, sortable: true },
                { id: "CBKLMS_USER_TEAM_NM", name: "그룹", field: "CBKLMS_USER_TEAM_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "EXT_NUM", name: "전화", field: "EXT_NUM", cssClass: "cell-align-center", width: 100, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
            ]
        };

        var grd_Notice_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Notice_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                 { id: "ALERT_GB_NM", name: "구분", field: "ALERT_GB_NM", cssClass: "cell-align-center", width: 50, sortable: true, formatter: GDH_TextAlertColor },
                { id: "NOTICE_TITLE", name: "제목", field: "NOTICE_TITLE", cssClass: "cell-align-left", width: 180, sortable: true },
                { id: "REG_ID_NM", name: "등록자", field: "REG_ID_NM", cssClass: "cell-align-center", width: 80, sortable: true },
                { id: "REG_DT_NM", name: "등록일", field: "REG_DT_NM", cssClass: "cell-align-center", width: 150, sortable: true },
            ]
        };
    </script>

    <script>
        //======================================================
        // Note - 그리드 셋팅.
        //======================================================
        function grid_init() {
            //-------------------------------------------------------
            // Sample List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Worker_List.grid = new Slick.Grid("#grd_Worker_List", grd_Worker_List.dataView, grd_Worker_List.columns, grd_Worker_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Worker_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Worker_List.grid.registerPlugin(grd_Worker_List_checkbox);
            grd_Worker_List.grid.setSelectedRows([]);

            grd_Worker_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_Worker_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Worker_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Worker_List.grid.updateRowCount();
                grd_Worker_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Worker_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Worker_List.grid.invalidateRows(args.rows);
                grd_Worker_List.grid.render();
            });

            //// Note - 클릭이벤트
            //grd_Worker_List.grid.onClick.subscribe(function (e, args) {
            //    var row = grd_Worker_List.grid.getDataItem(args.row);
            //    if (args.cell == '1') {
            //        if (row != null) {
            //            GetSampleModal(row);
            //        }
            //    }
            //});
            //// Note - 더블클릭이벤트
            //grd_Worker_List.grid.onDblClick.subscribe(function (e, args) {
            //    var row = grd_Worker_List.grid.getDataItem(args.row);
            //    if (row != null) {
            //        GetSampleModal(row);
            //    }
            //});


            grd_Worker_List.grid.init();

            //-------------------------------------------------------
            // Sample List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Notice_List.grid = new Slick.Grid("#grd_Notice_List", grd_Notice_List.dataView, grd_Notice_List.columns, grd_Notice_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Notice_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Notice_List.grid.registerPlugin(grd_Notice_List_checkbox);
            grd_Notice_List.grid.setSelectedRows([]);

            grd_Notice_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_Notice_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Notice_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Notice_List.grid.updateRowCount();
                grd_Notice_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Notice_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Notice_List.grid.invalidateRows(args.rows);
                grd_Notice_List.grid.render();
            });

            // Note - 클릭이벤트
            grd_Notice_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_Notice_List.grid.getDataItem(args.row);
                if (args.cell == '0') {
                    if (row != null) {
                        GetNoticeDtl(row);
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Notice_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Notice_List.grid.getDataItem(args.row);
                if (row != null) {
                    GetNoticeDtl(row);
                }
            });


            grd_Notice_List.grid.init();
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            grid_init();

            InitControls();

            GetMainPageData();


            $('#btnSearch').click(function () {
                GetMainPageData();
            });
        })

        //======================================================
        // Note - 초반 컨트롤 값 셋팅.
        //======================================================
        function InitControls() {
            fn_DatePicker($('#txtstart_dt_s'));
            fn_DatePicker($('#txtend_dt_s'));
            $('#txtstart_dt_s').val(fn_today());
            $('#txtend_dt_s').val(fn_today());
        }

        function fn_btnLink(id) {
            switch (id) {
                case "btnregister_one":
                    location.href = "/UI_Register/Quotation";
                    break;
                case "btnregister_two":
                    location.href = "/UI_Register/Register_Out";
                    break;
                case "btnregister_thr":
                    location.href = "/UI_Register/Register_IN";
                    break;
                    ///
                case "btnworksheet":
                    location.href = "/UI_WorkSheet/WorkSheet";
                    break;
                    ///
                case "btndatainput_one":
                    location.href = "/UI_Data/DataInput";
                    break;
                case "btndatainput_two":
                    location.href = "/UI_Data/DataInput";
                    break;
                case "btndatainput_thr":
                    location.href = "/UI_Data/DataConfirm";
                    break;
                case "btndatainput_four":
                    location.href = "/UI_Data/DataConfirm";
                    break;
                    ///
                case "btnreportclose":
                    location.href = "/UI_Report/ReportClose";
                    break;
                default:

            }
        }

        //======================================================
        // Note - 메인 카운트 가저오기
        //======================================================
        function GetNoticeDtl(row) {
            $('#txtnotice_title').val(row.NOTICE_TITLE);
            $('#txtnotice_desc').val(row.NOTICE_DESC);

            $('#ctl_notice_file').empty();
            var Gparam = {
                IV_NOTICE_ID: row.NOTICE_ID,
            };
            $.ajax({
                url: "/WebService/UI_CM/Announcement_Service.asmx/" + "GetAnnouncementDtl",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);


                    $('#ctl_notice_file').empty();

                    var str = "";
                    for (var i = 0; i < jsonData.result.length; i++) {
                        var dr = jsonData.result[i];
                        str += "<li>";
                        str += "<a href='" + dr.FILE_URL + "' target='_blank'>" + dr.FILE_NM + "</a>";
                        str + "</li>"
                    }

                    $('#ctl_notice_file').append(str);
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

            $('#modalNotice').modal();

        }

        //======================================================
        // Note - 메인 카운트 가저오기
        //======================================================
        function GetMainPageData() {
            var Gparam = {
                IV_START_DT: $('#txtstart_dt_s').val().replaceAll('-', ''),
                IV_END_DT: $('#txtend_dt_s').val().replaceAll('-', ''),
                IV_USER_ID: '<%= CkUserId %>'
            }
            $.ajax({
                url: ServiceUrl + "GetMainPageData",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        ////////////////////////////////////////////////////////////////////////
                        $('#btnregister_one').text(jsonData.MAINCOUNT_LIST[0].MAIN_REGISTER_ONE);
                        $('#btnregister_two').text(jsonData.MAINCOUNT_LIST[0].MAIN_REGISTER_TWO);
                        $('#btnregister_thr').text(jsonData.MAINCOUNT_LIST[0].MAIN_REGISTER_THR);

                        $('#btnworksheet').text(jsonData.MAINCOUNT_LIST[0].MAIN_WORKSHEET);

                        $('#btndatainput_one').text(jsonData.MAINCOUNT_LIST[0].MAIN_DATAINPUT_ONE);
                        $('#btndatainput_two').text(jsonData.MAINCOUNT_LIST[0].MAIN_DATAINPUT_TWO);
                        $('#btndatainput_thr').text(jsonData.MAINCOUNT_LIST[0].MAIN_DATAINPUT_THR);
                        $('#btndatainput_four').text(jsonData.MAINCOUNT_LIST[0].MAIN_DATAINPUT_FOUR);

                        $('#btnreportclose').text(jsonData.MAINCOUNT_LIST[0].MAIN_REPORTCLOSE);
                        //$('#btninvoice').text(jsonData.MAINCOUNT_LIST[0].MAIN_DATAINPUT_FOUR);

                        ////////////////////////////////////////////////////////////////////////
                        grd_Worker_List.dataView.beginUpdate();
                        grd_Worker_List.dataView.setItems(jsonData.WORKER_LIST);
                        grd_Worker_List.dataView.endUpdate();
                        grd_Worker_List.grid.render();


                        ////////////////////////////////////////////////////////////////////////
                        grd_Notice_List.dataView.beginUpdate();
                        grd_Notice_List.dataView.setItems(jsonData.NOTICE_LIST);
                        grd_Notice_List.dataView.endUpdate();
                        grd_Notice_List.grid.render();
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

    <!-- top tiles -->
    <%--<div class="row tile_count">
        <div class="col-md-2 col-xs-6 tile_stats_count">
            <span class="count_top"><i class="fa fa-user"></i>Total Users</span>
            <div class="count">2500</div>
            <span class="count_bottom"><i class="green">4% </i>From last Week</span>
        </div>
        <div class="col-md-2 col-xs-6 tile_stats_count">
            <span class="count_top"><i class="fa fa-clock-o"></i>Average Time</span>
            <div class="count">123.50</div>
            <span class="count_bottom"><i class="green"><i class="fa fa-sort-asc"></i>3% </i>From last Week</span>
        </div>
        <div class="col-md-2 col-xs-6 tile_stats_count">
            <span class="count_top"><i class="fa fa-user"></i>Total Males</span>
            <div class="count green">2,500</div>
            <span class="count_bottom"><i class="green"><i class="fa fa-sort-asc"></i>34% </i>From last Week</span>
        </div>
        <div class="col-md-2 col-xs-6 tile_stats_count">
            <span class="count_top"><i class="fa fa-user"></i>Total Females</span>
            <div class="count">4,567</div>
            <span class="count_bottom"><i class="red"><i class="fa fa-sort-desc"></i>12% </i>From last Week</span>
        </div>
        <div class="col-md-2 col-xs-6 tile_stats_count">
            <span class="count_top"><i class="fa fa-user"></i>Total Collections</span>
            <div class="count">2,315</div>
            <span class="count_bottom"><i class="green"><i class="fa fa-sort-asc"></i>34% </i>From last Week</span>
        </div>
        <div class="col-md-2 col-xs-6 tile_stats_count">
            <span class="count_top"><i class="fa fa-user"></i>Total Females</span>
            <div class="count">4,567</div>
            <span class="count_bottom"><i class="red"><i class="fa fa-sort-desc"></i>12% </i>From last Week</span>
        </div>
    </div>--%>
    <!-- /top tiles -->
    <div class="panel panel-default" style="margin-bottom:20px;"> 
        <div class="panel-heading form-horizontal">
            <div class="panel_serch">
                <div class="form-group">
                    <label for="ddlstatus_s" class="col-md-1 col-xs-4 control-label">일자</label>
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
            <button type="button" class="btn btn-primary btn-sm" data-toggle="confirmation" data-popout="true" id="btnSearch">
                <span class="glyphicon glyphicon glyphicon-search"></span>&nbsp;Search
            </button>
        </div>
    </div>
    
    <style>
        .oddColor {
            background-color: #f1f1e7;
        }
        fieldset button {
            min-width:1px;
            max-width:80px;
            width:100%;
            font-weight:bold !important; 
        }
        fieldset table {
            width:100%;
        }
        fieldset table th, fieldset table td{
            text-align: center;
        }
    </style>

    <div class="row">
        <div class="col-md-3 col-xs-12">
            <fieldset class="scheduler-border">
                <legend class="scheduler-border">접수</legend>
                <table class="table table-bordered">
                    <colgroup>
                        <col style="width:33.3%" />
                        <col style="width:33.3%" />
                        <col style="width:33.3%" />
                    </colgroup>
                    <tr>
                        <th>견적서</th>
                        <th>가접수</th>
                        <th>접수</th>
                    </tr>
                    <tr>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btnregister_one" onclick="fn_btnLink(this.id);">
                                3
                            </button>
                        </td>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btnregister_two" onclick="fn_btnLink(this.id);">>
                                3
                            </button>
                        </td>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btnregister_thr" onclick="fn_btnLink(this.id);">>
                                3
                            </button>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
         <div class="col-md-3 col-xs-12">
            <fieldset class="scheduler-border oddColor">
                <legend class="scheduler-border">시험의뢰서</legend>
                <table class="table table-bordered">
                    <tr>
                        <th>의뢰서</th>
                    </tr>
                    <tr>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btnworksheet" onclick="fn_btnLink(this.id);">>
                                3
                            </button>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
         <div class="col-md-3 col-xs-12">
            <fieldset class="scheduler-border">
                <legend class="scheduler-border">결과</legend>
                <table class="table table-bordered">
                    <tr>
                        <th>입력</th>
                        <th>확인</th>
                        <th>검토</th>
                        <th>승인</th>
                    </tr>
                    <tr>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btndatainput_one" onclick="fn_btnLink(this.id);">>
                                3
                            </button>
                        </td>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btndatainput_two" onclick="fn_btnLink(this.id);">>
                                3
                            </button>
                        </td>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btndatainput_thr" onclick="fn_btnLink(this.id);">>
                                3
                            </button>
                        </td>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btndatainput_four" onclick="fn_btnLink(this.id);">>
                                3
                            </button>
                        </td> 
                    </tr>
                </table>
            </fieldset>
        </div>
         <div class="col-md-3 col-xs-12">
            <fieldset class="scheduler-border oddColor">
                <legend class="scheduler-border">성적서발행</legend>
                <table class="table table-bordered">
                      <colgroup>
                        <col style="width:50%" />
                        <col style="width:50%" />
                    </colgroup>
                    <tr>
                        <th>발행</th>
                        <th>인보이스</th>
                    </tr>
                    <tr>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btnreportclose" onclick="fn_btnLink(this.id);">>
                                3
                            </button>
                        </td>
                        <td>
                            <button type="button" class="btn btn-default btn-sm" id="btninvoice" onclick="fn_btnLink(this.id);">
                                보류
                            </button>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
    </div>


    <div class="row">
        <div class="col-md-6 col-xs-12">
            <fieldset class="scheduler-border">
                <legend class="scheduler-border">근무자</legend>
                <div id="grd_Worker_List" style="height: 200px; border:1px solid #ddd;" class=""></div>
            </fieldset>
        </div>
        <div class="col-md-6 col-xs-12">
            <fieldset class="scheduler-border">
                <legend class="scheduler-border">공지사항</legend>
                <div id="grd_Notice_List" style="height: 200px; border:1px solid #ddd;" class=""></div>
            </fieldset>
        </div>
    </div>

     <%--***********************************************************************************************/
/* Contact 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalNotice" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">공지사항</p>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body">
                     <div class="form-group col-xs-12">
                        <label for="txtsample_status_remark" class="control-label">■ 제목</label>
                        <input type="text" class="form-control input-sm " id="txtnotice_title" name="txtnotice_title" readonly="readonly" />
                    </div>
                    <div class="form-group col-xs-12">
                        <label for="txtsample_status_remark" class="control-label">■ 내용</label>
                        <textarea rows="5" class="form-control input-sm " id="txtnotice_desc" name="txtnotice_desc" readonly="readonly"> </textarea>
                    </div>
                    <div class="form-group col-xs-12">
                        <label for="txtsample_status_remark" class="control-label">■ 파일</label>
                        <ul id="ctl_notice_file">
                            <li><a href="#">content</a></li>
                            <li><a href="#">content</a></li>
                            <li><a href="#">content</a></li>
                        </ul>
                    </div>
                    <div class="clearfix"></div>

                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
</asp:Content>

