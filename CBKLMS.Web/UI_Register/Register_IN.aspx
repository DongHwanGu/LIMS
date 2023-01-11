<%@ Page Title="" Language="C#" EnableEventValidation="false" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Register_IN.aspx.cs" Inherits="UI_Register_Register_IN" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <link href="/Common/Bootstap_Step/css/style.css" rel="stylesheet" />
    <script src="/Common/Bootstap_Step/js/index.js"></script>
    <style>
    .icon-highlight-off,
    .icon-highlight-on {
      background-image: url(/Common/images/SlickGrid/bullet_blue.png);
    }

    .icon-highlight-off {
      opacity: 0.2;
    }

    .negative-highlight {
      background: red;
    }
        .disabled {
            pointer-events: none;
            opacity: 0.4;
        }
  </style>
    <script>
        var ServiceUrl = "/WebService/UI_Register/Register_IN_Service.asmx/"; SetDueReportDate
        var buyerDefaultAmt = '100,000';
        var pm_req = {};
        var pm_req_file = [];
        var pm_req_customer = [];
        var pm_req_contact = [];
        var pm_req_sample = [];
        var pm_req_sample_file = [];
        var pm_req_sample_file_temp = [];
        var pm_req_sample_test = [];
        var pm_req_test = [];
        var pm_req_test_package = [];

        // Sample 갯수 별 옵션변경.
        function fn_grid_optionDatas_sample_cnt() {
            var options = [];
            var sample_cnt = parseInt($('#txtsample_cnt').val());
            options.push({ CD_MINOR: "0", CD_FNAME: "전체" });
            for (var i = 0; i < sample_cnt; i++) {
                options.push({ CD_MINOR: (i + 1), CD_FNAME: (i + 1) + " 번째" });
            }

            return options;
        }

        function fn_grd_Sample_File_List() {
            grd_Sample_File_List_columns = [
                grd_Sample_File_List_checkbox.getColumnDefinition(),
                { id: "FILE_CNT", name: "-", field: "FILE_CNT", cssClass: "cell-align-center", width: 80, options: fn_grid_optionDatas_sample_cnt(), editor: GDH_SelectEditor, formatter: GDH_SelectFormatter },
                { id: "FILE_TYPE", name: "구분", field: "FILE_TYPE", cssClass: "cell-align-center", width: 80, options: fn_grid_optionDatas('0009', false), editor: GDH_SelectEditor, formatter: GDH_SelectFormatter },
                { id: "FILE_NM", name: "파일명", field: "FILE_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "FILE_URL", name: "파일경로", field: "FILE_URL", cssClass: "cell-align-left", width: 400, sortable: true }
            ];
            grd_Sample_File_List.columns = grd_Sample_File_List_columns;

            //-------------------------------------------------------
            // Sample file List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Sample_File_List.grid = new Slick.Grid("#grd_Sample_File_List", grd_Sample_File_List.dataView, grd_Sample_File_List.columns, grd_Sample_File_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Sample_File_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Sample_File_List.grid.registerPlugin(grd_Sample_File_List_checkbox);
            grd_Sample_File_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Sample_File_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Sample_File_List.grid.updateRowCount();
                grd_Sample_File_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Sample_File_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Sample_File_List.grid.invalidateRows(args.rows);
                grd_Sample_File_List.grid.render();
            });

            grd_Sample_File_List.grid.init();
        }

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
                //상태 / 접수자 / 접수일 / 접수유형 / 제출처 / 의뢰업체 / 인터텍 / 담당자명 / 견적서 / 시료명 / 팀 / UD 사용자 / UD 날짜
                grd_Master_List_checkbox.getColumnDefinition(),
                { id: "STATUS_CD_NM", name: "상태", field: "STATUS_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "REQ_KEY", name: "접수번호", field: "REQ_KEY", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REGISTER_USER_ID_NM", name: "접수자", field: "REGISTER_USER_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "REGISTER_DT_NM", name: "접수일", field: "REGISTER_DT_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "SERVICE_TYPE_NM", name: "접수유형", field: "SERVICE_TYPE_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "VENDOR_CUST_NM", name: "의뢰업체", field: "VENDOR_CUST_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "BUYER_CUST_NM", name: "제출처", field: "BUYER_CUST_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "INTERTEK_USER_ID_NM", name: "등록인", field: "INTERTEK_USER_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },

                { id: "UPD_ID_NM", name: "검토", field: "UPD_ID_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "UPD_DT_NM", name: "검토일", field: "UPD_DT_NM", cssClass: "cell-align-center", width: 120, sortable: true },
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
                { id: "CUST_LIST", name: "고객명", field: "CUST_LIST", cssClass: "cell-align-left", width: 114, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CUST_GB_NM", name: "고객구분", field: "CUST_GB_NM", cssClass: "cell-align-left", width: 114, sortable: true },
                { id: "CONTACT_NM", name: "담당자명", field: "CONTACT_NM", cssClass: "cell-align-center", width: 114, sortable: true },
                { id: "CONTACT_ENM", name: "담당자명(EN)", field: "CONTACT_ENM", cssClass: "cell-align-center", width: 114, sortable: true },
                { id: "CONTACT_TELHP", name: "연락처", field: "CONTACT_TELHP", cssClass: "cell-align-center", width: 114, sortable: true, editor: Slick.Editors.Text },
                { id: "CONTACT_EMAIL", name: "E-Mail", field: "CONTACT_EMAIL", cssClass: "cell-align-left", width: 114, sortable: true },
                { id: "RECEIPT_TO_YN", name: "To", field: "RECEIPT_TO_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "RECEIPT_CC_YN", name: "Cc", field: "RECEIPT_CC_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "RECEIPT_BCC_YN", name: "Bcc", field: "RECEIPT_BCC_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "REPORT_TO_YN", name: "To", field: "REPORT_TO_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "REPORT_CC_YN", name: "Cc", field: "REPORT_CC_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "REPORT_BCC_YN", name: "Bcc", field: "REPORT_BCC_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "INVOICE_TO_YN", name: "To", field: "INVOICE_TO_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "INVOICE_CC_YN", name: "Cc", field: "INVOICE_CC_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "INVOICE_BCC_YN", name: "Bcc", field: "INVOICE_BCC_YN", cssClass: "cell-align-center", width: 57, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
            ]
        };

        var grd_Sample_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Sample_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: default_options,
            columns: [
                grd_Sample_List_checkbox.getColumnDefinition(),
                { id: "SAMPLE_SHORT_NM", name: "-", field: "SAMPLE_SHORT_NM", cssClass: "cell-align-center", width: 50, sortable: true, formatter: GDH_TextPopupColor },
                { id: "SAMPLE_NM", name: "시료명", field: "SAMPLE_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "SAMPLE_CNT", name: "수량", field: "SAMPLE_CNT", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "SAMPLE_CAPACITY", name: "단위", field: "SAMPLE_CAPACITY", cssClass: "cell-align-center", width: 80, sortable: true },
                { id: "SAMPLE_TEAM_NM", name: "팀", field: "SAMPLE_TEAM_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "SAMPLE_TYPE_CD_NM", name: "처리", field: "SAMPLE_TYPE_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "SAMPLE_GET_DT_NM", name: "채취일자", field: "SAMPLE_GET_DT_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "SAMPLE_GET_PLACE", name: "채취장소", field: "SAMPLE_GET_PLACE", cssClass: "cell-align-center", width: 200, sortable: true },
                { id: "STATUS_REMARK", name: "상태비고", field: "STATUS_REMARK", cssClass: "cell-align-center", width: 100, sortable: true },
            ]
        };
        var grd_Sample_File_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Sample_File_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                grd_Sample_File_List_checkbox.getColumnDefinition(),
                { id: "FILE_CNT", name: "-", field: "FILE_CNT", cssClass: "cell-align-center", width: 80, options: fn_grid_optionDatas_sample_cnt(), editor: GDH_SelectEditor, formatter: GDH_SelectFormatter },
                { id: "FILE_TYPE", name: "구분", field: "FILE_TYPE", cssClass: "cell-align-center", width: 80, options: fn_grid_optionDatas('0009', false), editor: GDH_SelectEditor, formatter: GDH_SelectFormatter },
                { id: "FILE_NM", name: "파일명", field: "FILE_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "FILE_URL", name: "파일경로", field: "FILE_URL", cssClass: "cell-align-left", width: 400, sortable: true }
            ]
        };
        
        var grd_Test_Package_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Test_Package_List_Columns = [
                grd_Test_Package_List_checkbox.getColumnDefinition(),
                { id: "TEST_PACKAGE_TYPE", name: "접수유형", field: "TEST_PACKAGE_TYPE", cssClass: "cell-align-left", width: 80, sortable: true, formatter: GDH_TextPopupColor },
                { id: "TEST_PACKAGE_NM", name: "시험항목", field: "TEST_PACKAGE_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "METHOD_NM", name: "시험방법", field: "METHOD_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 80, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 80, sortable: true },
                { id: "DISCOUNT_RATE", name: "할인율(%)", field: "DISCOUNT_RATE", cssClass: "cell-align-right", width: 80, sortable: true },
                { id: "LAST_AMT", name: "최종 금액", field: "LAST_AMT", cssClass: "cell-align-right", width: 80, sortable: true },
                //{ id: "KOLAS_YN", name: "공인", field: "KOLAS_YN", cssClass: "cell-align-left", width: 70, sortable: true },
                { id: "TEST_TEAM", name: "팀", field: "TEST_TEAM", cssClass: "cell-align-left", width: 70, sortable: true },
                { id: "TRUST_REAMRK", name: "위탁", field: "TRUST_REAMRK", cssClass: "cell-align-left", width: 80, sortable: true },
                { id: "DETECTION_LIMIT_CD", name: "검출한계", field: "DETECTION_LIMIT_CD", cssClass: "cell-align-center", width: 80, sortable: true },
                { id: "SPEC_CD", name: "스팩(규격)", field: "SPEC_CD", cssClass: "cell-align-center", width: 80, sortable: true },
                { id: "REFERENCE_CD", name: "레퍼런스", field: "REFERENCE_CD", cssClass: "cell-align-center", width: 80, sortable: true },

        ];
        var grd_Test_Package_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: grd_Test_Package_List_Columns
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
                        var c = grd_Modal_Package_Test_List.grid.getColumns()[grd_Modal_Package_Test_List.grid.getColumnIndex(columnId)];
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
                { id: "CUST_NM", name: "업체명", field: "CUST_NM", cssClass: "cell-align-left", width: 200, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CUST_ENM", name: "업체명(EN)", field: "CUST_ENM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "STATUS_CD_NM", name: "상태", field: "STATUS_CD_NM", cssClass: "cell-align-center", width: 100, sortable: true },
                { id: "BUSINESS_NO", name: "사업자번호", field: "BUSINESS_NO", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_LIST", name: "담당자", field: "CONTACT_LIST", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 200, sortable: true },
            ]
        };

        var grd_Modal_User_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var columnFilters_Modal_User = {};
        function filter_Modal_User(item) {
            for (var columnId in columnFilters_Modal_User) {
                if (item[columnId] == null) {
                    return false;
                }
                else {
                    if (item[columnId] != undefined && columnId != undefined && columnFilters_Modal_User[columnId] != "" && item[columnId].toString().toLowerCase().indexOf(columnFilters_Modal_User[columnId]) == -1) {
                        // 요부분 바꿔야함.
                        var c = grd_Modal_User_List.grid.getColumns()[grd_Modal_User_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters_Modal_User[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Modal_User_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Modal_User_List_checkbox.getColumnDefinition(),
                { id: "USER_NM", name: "User Nm", field: "USER_NM", cssClass: "cell-align-left", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "USER_ENM", name: "User ENm", field: "USER_ENM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "LOGIN_ID", name: "Login Id", field: "LOGIN_ID", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "EMAIL", name: "E-Mail", field: "EMAIL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DEPT_CD1_NM", name: "Dept Nm 1", field: "DEPT_CD1_NM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DEPT_CD2_NM", name: "Dept Nm 2", field: "DEPT_CD2_NM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DEPT_CD3_NM", name: "Dept Nm 3", field: "DEPT_CD3_NM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DUTY_CD_KOR_NM", name: "Position Kr", field: "DUTY_CD_KOR_NM", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "DUTY_CD_NM", name: "Position En", field: "DUTY_CD_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "USER_GB_NM", name: "Employee Tp", field: "USER_GB_NM", cssClass: "cell-align-left", width: 150, sortable: true },
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
                { id: "CUST_LIST", name: "업체", field: "CUST_LIST", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "CONTACT_EMAIL", name: "이메일", field: "CONTACT_EMAIL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_DEPT", name: "부서", field: "CONTACT_DEPT", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_TEL", name: "전화", field: "CONTACT_TEL", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_PHONE", name: "휴대폰", field: "CONTACT_PHONE", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "CONTACT_FAX", name: "팩스", field: "CONTACT_FAX", cssClass: "cell-align-left", width: 100, sortable: true },
                { id: "REMARK", name: "비고", field: "REMARK", cssClass: "cell-align-left", width: 100, sortable: true },
            ]
        };

        var grd_Modal_Package_Test_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var columnFilters_Modal_Package_Test = {};
        function filter_Modal_Package_Test(item) {
            for (var columnId in columnFilters_Modal_Package_Test) {
                if (item[columnId] == null) {
                    return false;
                }
                else {
                    if (item[columnId] != undefined && columnId != undefined && columnFilters_Modal_Package_Test[columnId] != "" && item[columnId].toString().toLowerCase().indexOf(columnFilters_Modal_Package_Test[columnId]) == -1) {
                        // 요부분 바꿔야함.
                        var c = grd_Modal_Package_Test_List.grid.getColumns()[grd_Modal_Package_Test_List.grid.getColumnIndex(columnId)];
                        if (item[c.field] != columnFilters_Modal_Package_Test[columnId]) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        var grd_Modal_Package_Test_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: header_options,
            columns: [
                grd_Modal_Package_Test_List_checkbox.getColumnDefinition(),
                { id: "TEST_PACKAGE_TYPE", name: "접수유형", field: "TEST_PACKAGE_TYPE", cssClass: "cell-align-left", width: 100, sortable: true, formatter: GDH_TextPopupColor },
                { id: "CUST_NM", name: "제출처", field: "CUST_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "TEST_PACKAGE_NM", name: "시험항목", field: "TEST_PACKAGE_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "METHOD_NM", name: "시험방법", field: "METHOD_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
            ]
        };

        var grd_Sample_Amt_List_checkbox = new Slick.CheckboxSelectColumn({
            cssClass: "slick-cell-checkboxsel"
        });
        var grd_Sample_Amt_List = {
            grid: {},
            dataView: new Slick.Data.DataView({ inlineFilters: true }),
            options: edit_options,
            columns: [
                grd_Sample_Amt_List_checkbox.getColumnDefinition(),
                { id: "SAMPLE_SHORT_NM", name: "-", field: "SAMPLE_SHORT_NM", cssClass: "cell-align-center", width: 50, sortable: true, formatter: GDH_TextPopupColor },
                { id: "SAMPLE_NM", name: "시료명", field: "SAMPLE_NM", cssClass: "cell-align-left", width: 200, sortable: true },
                { id: "TEST_TOTAL_AMT", name: "시험 합계", field: "TEST_TOTAL_AMT", cssClass: "cell-align-right", width: 100, sortable: true },
                { id: "DEFAULT_AMT_YN", name: "기본료", field: "DEFAULT_AMT_YN", cssClass: "cell-align-center", width: 100, sortable: true, editor: Slick.Editors.Checkbox, formatter: Slick.Formatters.Checkmark },
                { id: "LAST_TOTAL_AMT", name: "최종 금액", field: "LAST_TOTAL_AMT", cssClass: "cell-align-right", width: 200, sortable: true },
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
                        GetRegisterDetail(row);
                        $('#ulTabs li:eq(1) a').tab('show');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Master_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Master_List.grid.getDataItem(args.row);
                if (row != null) {
                    GetRegisterDetail(row);
                    $('#ulTabs li:eq(1) a').tab('show');
                }
            });

            grd_Master_List.grid.init();

            $("#lblTotal").text(grd_Master_List.dataView.getItems().length);//로우 토탈 건수

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
            // Sample List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Sample_List.grid = new Slick.Grid("#grd_Sample_List", grd_Sample_List.dataView, grd_Sample_List.columns, grd_Sample_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Sample_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Sample_List.grid.registerPlugin(grd_Sample_List_checkbox);
            grd_Sample_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Sample_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Sample_List.grid.updateRowCount();
                grd_Sample_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Sample_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Sample_List.grid.invalidateRows(args.rows);
                grd_Sample_List.grid.render();
            });

            // Note - 클릭이벤트
            grd_Sample_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_Sample_List.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                        GetSampleModal(row);
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Sample_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Sample_List.grid.getDataItem(args.row);
                if (row != null) {
                    GetSampleModal(row);
                }
            });


            grd_Sample_List.grid.init();

            //-------------------------------------------------------
            // Sample file List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Sample_File_List.grid = new Slick.Grid("#grd_Sample_File_List", grd_Sample_File_List.dataView, grd_Sample_File_List.columns, grd_Sample_File_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Sample_File_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Sample_File_List.grid.registerPlugin(grd_Sample_File_List_checkbox);
            grd_Sample_File_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Sample_File_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Sample_File_List.grid.updateRowCount();
                grd_Sample_File_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Sample_File_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Sample_File_List.grid.invalidateRows(args.rows);
                grd_Sample_File_List.grid.render();
            });

            grd_Sample_File_List.grid.init();

            //-------------------------------------------------------
            // Test Package List
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Test_Package_List.grid = new Slick.Grid("#grd_Test_Package_List", grd_Test_Package_List.dataView, grd_Test_Package_List.columns, grd_Test_Package_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Test_Package_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Test_Package_List.grid.registerPlugin(grd_Test_Package_List_checkbox);
            grd_Test_Package_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Test_Package_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Test_Package_List.grid.updateRowCount();
                grd_Test_Package_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Test_Package_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Test_Package_List.grid.invalidateRows(args.rows);
                grd_Test_Package_List.grid.render();
            });

            grd_Test_Package_List.grid.init();

            //-------------------------------------------------------
            // 모달 업체 리스트
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

            // Note - 클릭이벤트
            grd_Modal_Cust_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_Modal_Cust_List.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                        SaveModalCustData(row);
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Modal_Cust_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Modal_Cust_List.grid.getDataItem(args.row);
                if (row != null) {
                    SaveModalCustData(row);
                }
            });

            grd_Modal_Cust_List.grid.init();

            //-------------------------------------------------------
            // 모달 유저 리스트
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Modal_User_List.grid = new Slick.Grid("#grd_Modal_User_List", grd_Modal_User_List.dataView, grd_Modal_User_List.columns, grd_Modal_User_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Modal_User_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Modal_User_List.grid.registerPlugin(grd_Modal_User_List_checkbox);
            grd_Modal_User_List.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Modal_User_List.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters_Modal_User[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Modal_User_List.dataView.refresh();
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Modal_User_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters_Modal_User[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Modal_User_List.grid.render();
            });
            grd_Modal_User_List.grid.onSort.subscribe(function (e, args) {
                var comparer = function (a, b) { return (a[args.sortCol.field] > b[args.sortCol.field]) ? 1 : -1; }
                grd_Modal_User_List.dataView.sort(comparer, args.sortAsc);
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Modal_User_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Modal_User_List.grid.updateRowCount();
                grd_Modal_User_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Modal_User_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Modal_User_List.grid.invalidateRows(args.rows);
                grd_Modal_User_List.grid.render();
            });

            // Note - 클릭이벤트
            grd_Modal_User_List.grid.onClick.subscribe(function (e, args) {
                var row = grd_Modal_User_List.grid.getDataItem(args.row);
                if (args.cell == '1') {
                    if (row != null) {
                        $('#hidintertek_user_id').val(row.USER_ID);
                        $('#txtintertek_user_nm').val(row.USER_NM + " (" + row.USER_ENM + ")");
                        $('#txtintertek_user_dept').text(row.DEPT_CD_NM);
                        $('#modalUser').modal('hide');
                    }
                }
            });
            // Note - 더블클릭이벤트
            grd_Modal_User_List.grid.onDblClick.subscribe(function (e, args) {
                var row = grd_Modal_User_List.grid.getDataItem(args.row);
                if (row != null) {
                    $('#hidintertek_user_id').val(row.USER_ID);
                    $('#txtintertek_user_nm').val(row.USER_NM + " (" + row.USER_ENM + ")");
                    $('#txtintertek_user_dept').text(row.DEPT_CD_NM);
                    $('#modalUser').modal('hide');
                }
            });

            grd_Modal_User_List.grid.init();

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
                    columnFilters_Modal_Cust[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Modal_Contact_List.dataView.refresh();
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Modal_Contact_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters_Modal_Cust[args.column.id])
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

            //-------------------------------------------------------
            // 모달 Package 시험 리스트
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Modal_Package_Test_List.grid = new Slick.Grid("#grd_Modal_Package_Test_List", grd_Modal_Package_Test_List.dataView, grd_Modal_Package_Test_List.columns, grd_Modal_Package_Test_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Modal_Package_Test_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Modal_Package_Test_List.grid.registerPlugin(grd_Modal_Package_Test_List_checkbox);
            grd_Modal_Package_Test_List.grid.setSelectedRows([]);

            // Note - Row filter 이벤트 설정(키입력시 필터링수행, 대소문자 가리지 않게 처리)
            $(grd_Modal_Package_Test_List.grid.getHeaderRow()).delegate(":input", "change keyup", function (e) {
                var columnId = $(this).data("columnId");
                if (columnId != null) {
                    columnFilters_Modal_Package_Test[columnId] = $.trim($(this).val().toLowerCase());
                    grd_Modal_Package_Test_List.dataView.refresh();
                }
            });

            // Note - Row Filter에 TextBox를 추가한다.(옵션 "explicitInitialization: true" 와 "Grid.Init()"과 같이 사용)
            grd_Modal_Package_Test_List.grid.onHeaderRowCellRendered.subscribe(function (e, args) {
                $(args.node).empty();
                if (args.column.id != "_checkbox_selector") { //체크박스는 Header filter 제외
                    $("<input type='text'>")
                       .data("columnId", args.column.id)
                       .val(columnFilters_Modal_Package_Test[args.column.id])
                       .appendTo(args.node)
                       .width(args.column.width - 12);//필터 넓이 조정
                }
                grd_Modal_Package_Test_List.grid.render();
            });

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Modal_Package_Test_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Modal_Package_Test_List.grid.updateRowCount();
                grd_Modal_Package_Test_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Modal_Package_Test_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Modal_Package_Test_List.grid.invalidateRows(args.rows);
                grd_Modal_Package_Test_List.grid.render();
            });

            grd_Modal_Package_Test_List.grid.init();

            //-------------------------------------------------------
            // 금액설정
            //-------------------------------------------------------
            // Note - Grid 초기화
            grd_Sample_Amt_List.grid = new Slick.Grid("#grd_Sample_Amt_List", grd_Sample_Amt_List.dataView, grd_Sample_Amt_List.columns, grd_Sample_Amt_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Sample_Amt_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Sample_Amt_List.grid.registerPlugin(grd_Sample_Amt_List_checkbox);
            grd_Sample_Amt_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Sample_Amt_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Sample_Amt_List.grid.updateRowCount();
                grd_Sample_Amt_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Sample_Amt_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Sample_Amt_List.grid.invalidateRows(args.rows);
                grd_Sample_Amt_List.grid.render();
            });

            grd_Sample_Amt_List.grid.onCellChange.subscribe(function (e, args) {
                GetSampleAmtTotal();
            });

            grd_Sample_Amt_List.grid.init();
        }

        //======================================================
        // Note - 페이지 로드.
        //======================================================
        $(function () {
            // Add 
            $('#btnAdd, #btnAdd2').click(function () {
                InitControls();
                $('#ulTabs li:eq(1) a').tab('show');
            });
            // 업체 추가 버튼
            $('#btnbuyer_cust_popup, #btnvendor_cust_popup, #btnintertek_cust_popup').click(function () {
                var cust_gb = '';
                if (this.id == 'btnbuyer_cust_popup') {
                    cust_gb = '01';
                } else if (this.id == 'btnvendor_cust_popup') {
                    cust_gb = '02';
                } else {
                    cust_gb = '03';
                }

                if (cust_gb == '03') {
                    GetModalUserList();
                    $('#modalUser').modal();
                } else {
                    GetModalCustomerList(cust_gb);
                    fn_ClearGrid(grd_Contact_List);
                    $('#modalCustomer').modal();
                }
            });
            $('#btnbuyer_cust_addrview, #btnvendor_cust_addrview').click(function () {
                if (this.id == 'btnbuyer_cust_addrview')
                {
                    $('#lblcust_nm_view').text($('#txtbuyer_cust_nm').val());
                    $('#txtcust_addr_view').val($('#hidbuyer_cust_addr_kr').val());
                } else {
                    $('#lblcust_nm_view').text($('#txtvendor_cust_nm').val());
                    $('#txtcust_addr_view').val($('#hidvendor_cust_addr_kr').val());
                }

                $('#modalCustAddrView').modal();
            });

            // 담당자
            $('#btncontact_add').click(function () {
                GetModalContactList();
                $('#modalContact').modal();
            });
            $('#btnmodalcontact_list').click(function () {
                SaveModalContactList();
            });
            $('#btncontact_delete').click(function () {
                DeleteContactList();
            });
            // 접수일
            $('#txtreg_dt').change(function () {
                SetDueReportDate();
                $('#txtreg_sample_arrive_dt').val($('#txtreg_dt').val());
            });
            // 접수유형 
            $('#ddlreg_service_type').change(function () {
                SetDueReportDate();
            });
            // 시료
            $('#btnsample_add').click(function () {
                fn_ClearControls($('#modalSampleData'));
                fn_DatePicker($('#txtsample_get_dt'));
                fn_ClearGrid(grd_Sample_File_List);
                fn_grd_Sample_File_List();
                $('#txtsample_get_dt').val(fn_today());
                $('#txtsample_cnt').val('0');
                $('#modalSampleData').modal();
            });
            $('#txtsample_cnt').change(function () {
                fn_ClearGrid(grd_Sample_File_List);
                fn_grd_Sample_File_List();

            });
            $('#btnmodalsample_save').click(function () {
                SaveModalSampleData();
            });
            $('#btnsample_delete').click(function () {
                DeleteSampleData();
            });
            $('#btnsample_excel').on('click', function () {
                var data = grd_Sample_List.dataView.getItems();
                if (data.length > 0) {
                    $("#grid_Sample_List_Excel").excelexportjs({
                        containerid: "grid_Sample_List_Excel"
                               , datatype: 'json'
                               , dataset: data
                               , columns: getColumns(data)
                               , title: "SampleList"
                    });
                }
            });
            
            // 시험
            $('#ddltestcurreny_cd').change(function () {
                GetCurrency_Amt($(this).val());
            });
            $('#chkexchange_rate').on('ifChanged', function () {
                SetTestPackageListAmt();
                GetSampleAmtTotal();
            });
            $('#btnpackage_test_add').click(function () {
                if (grd_Sample_List.dataView.getItems().length == 0) {
                    fn_info('시료 추가 후 진행해 주세요.');
                    return;
                }
                GetModalPackageTestList();
                $('#modalPackageTest').modal();
            });
            $('#btnpackage_test_delete').click(function () {
                DeletePackageTestList();
            });

            $('#btnmodaltestpackage_save').click(function () {
                SaveModalPackageTestList();
            });
            $('#btntestpackage_include_rate').click(function () {
                var gridData = grd_Test_Package_List.dataView.getItems();
                fn_ClearGrid(grd_Test_Package_List);
                $(gridData).each(function (index, entry) {
                    entry.DISCOUNT_RATE = $('#txttestpackage_include_rate').val();
                    grd_Test_Package_List.dataView.beginUpdate();
                    grd_Test_Package_List.dataView.addItem(entry);
                    grd_Test_Package_List.dataView.endUpdate();
                });
                SetTestPackageListAmt();
                GetSampleAmtTotal();
            });
            $('#btntest_team_save').click(function () {
                var gridData = grd_Test_Package_List.dataView.getItems();
                fn_ClearGrid(grd_Test_Package_List);
                $(gridData).each(function (index, entry) {
                    entry.TEST_TEAM = $('#ddltest_team').val();
                    grd_Test_Package_List.dataView.beginUpdate();
                    grd_Test_Package_List.dataView.addItem(entry);
                    grd_Test_Package_List.dataView.endUpdate();
                });
            });
            $('#txttestpackage_include_rate').change(function () {
                $(this).val($.number(this.value, 0));
            });
            $('#txtexchange_rate').change(function () {
                $(this).val($.number(this.value, 2));
            });
            $('#txtsample_cnt').change(function () {
                $(this).val($.number(this.value, 0));
            });
            $('#btnsample_amt_refresh').click(function () {
                GetSampleAmtTotal();
            });
            $('#btnSearch').click(function () {
                GetRegisterList();
            });
            $('#btnsample_file_delete').click(function () {
                DeleteSampleFileData();
            });

            // Step 버튼
            $('.a_tab').on('shown.bs.tab', function (e) {

                var href = $(e.target).attr('href');
                var $curr = $(".process-model  a[href='" + href + "']").parent();

                $('.process-model li').removeClass('visited');

                $curr.addClass("active");
                $curr.prevAll().addClass("visited");
            });

            // 파일업로드
            $('#btnreg_file_popup').click(function () {
                fileupload_obj.filemodal = $('#modalfileupload');
                fileupload_obj.multi = false;
                fileupload_obj.page = "Register_IN";
                fileupload_obj.key = $('#hidreq_num').val()
                $('#modalfileupload').modal();
            });
            // 파일업로드
            $('#btnsample_file_upload').click(function () {
                fileupload_obj.filemodal = $('#modalfileupload');
                fileupload_obj.multi = true;
                fileupload_obj.page = "Register_IN_Sample";
                fileupload_obj.key = $('#hidreq_num').val()
                $('#modalfileupload').modal();
            });

            // 스텝별 저장
            $('#btnStepOne').click(function () {
                SaveStepOne();
            });
            $('#btnStepTwo').click(function () {
                SaveStepTwo();
            });
            $('#btnSave, #btnSaveAndMail').click(function () {
                SaveRegisterFinish(this.id);
            });


            // 초기 그리드 바인딩할때 필수..
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                grd_Contact_List.grid.resizeCanvas();
                grd_Sample_List.grid.resizeCanvas();
                grd_Test_Package_List.grid.resizeCanvas();
                grd_Sample_Amt_List.grid.resizeCanvas();
            });
            // 초기 그리드 바인딩할때 필수..
            $('a[aria-controls="step_complete"]').on('shown.bs.tab', function (e) {
                SetStepCompleteData();
            });

            // 모달 팝업 이벤트
            $('#modalCustomer').on('shown.bs.modal', function (e) {
                grd_Modal_Cust_List.grid.resizeCanvas();
            });
            $('#modalUser').on('shown.bs.modal', function (e) {
                grd_Modal_User_List.grid.resizeCanvas();
            });
            $('#modalContact').on('shown.bs.modal', function (e) {
                grd_Modal_Contact_List.grid.resizeCanvas();
            });
            $('#modalPackageTest').on('shown.bs.modal', function (e) {
                grd_Modal_Package_Test_List.grid.resizeCanvas();
            });
            $('#modalSampleData').on('shown.bs.modal', function (e) {
                grd_Sample_File_List.grid.resizeCanvas();
            });


            $('#btnEmail').click(function () {
                mailsend_obj.thismodal = $('#modalMailSend');
                mailsend_obj.page = 'Mail_Register_IN';
                mailsend_obj.key = $('#hidreq_num').val() + ',' + '<%= CkUserId %>';
                mailsend_obj.thismodal.modal();
                return;
            });


            // 그리드 그리기
            grid_init();
            // 초반 컨트롤 셋팅
            InitControls();
            // 초반 조회
            GetRegisterList();

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
        // Note - 초반 컨트롤 셋팅.
        //======================================================
        function InitControls() {
            

            $('#ulTabs_Step li:eq(0) a').tab('show');

            $('#ulTabs_Step li:eq(0) a').removeClass('disabled');
            $('#ulTabs_Step li:eq(1) a').addClass('disabled');
            $('#ulTabs_Step li:eq(2) a').addClass('disabled');

            ClearObjectAll();

            fn_ClearControls($('#detail'));
            // 담당자 정보.
            fn_ClearGrid(grd_Contact_List);
            // 시료 정보
            fn_ClearGrid(grd_Sample_List);
            // 시험 정보
            fn_ClearGrid(grd_Test_Package_List);
            // 금액 설정
            fn_ClearGrid(grd_Sample_Amt_List);
            
            fn_DatePicker($('#txtreg_dt'));
            $('#txtreg_dt').val(fn_today());
            fn_DatePicker($('#txtreg_sample_arrive_dt'));
            $('#txtreg_sample_arrive_dt').val(fn_today());
            fn_DatePicker($('#txtreg_report_dt'));
            $('#txtreg_report_dt').val(fn_today());

            fn_DatePicker($('#txtstart_dt_s'));
            fn_DatePicker($('#txtend_dt_s'));
            $('#txtstart_dt_s').val(fn_today(null, -1));
            $('#txtend_dt_s').val(fn_today());

            $('#ddlmasterstatus_cd_s').empty();
            $('#ddlmasterstatus_cd_s').append(GetCMCODE_Level_New({ cd_major: "0005", cd_level: '11', IsEmpty: true, Text: "ALL", Delete: '04,05,06,07,08,10,11,12,90,91,99,80,81,82,83,84,85,88,89' }));
            
            $('#ddlreg_service_type').empty();
            $('#ddlreg_service_type').append(GetCMCODE_Level_New({ cd_major: "0004", cd_level: '11', IsEmpty: true, Text: "=== Select ===" }));
            $('#ddltestcurreny_cd').empty();
            $('#ddltestcurreny_cd').append(GetCMCODE_Level_New({ cd_major: "0100", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddlstatus_cd').empty();
            $('#ddlstatus_cd').append(GetCMCODE_Level_New({ cd_major: "0005", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddlsample_type_cd').empty();
            $('#ddlsample_type_cd').append(GetCMCODE_Level_New({ cd_major: "0007", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddlsample_team').empty();
            $('#ddlsample_team').append(GetCMCODE_Level_New({ cd_major: "0101", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddltest_team').empty();
            $('#ddltest_team').append(GetCMCODE_Level_New({ cd_major: "0101", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddlreport_use_cd').empty();
            $('#ddlreport_use_cd').append(GetCMCODE_Level_New({ cd_major: "0011", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddlreport_send_cd').empty();
            $('#ddlreport_send_cd').append(GetCMCODE_Level_New({ cd_major: "0012", cd_level: '11', IsEmpty: false, Text: "" }));
            $('#ddlsample_unit').empty();
            $('#ddlsample_unit').append(GetCMCODE_Level_New({ cd_major: "0014", cd_level: '11', IsEmpty: true, Text: "=== Select ===" }));
            $('#ddlextra_type').empty();
            $('#ddlextra_type').append(GetCMCODE_Level_New({ cd_major: "0017", cd_level: '11', IsEmpty: true, Text: "=== Select ===" }));

            $('#rdoreg_dt_am').iCheck('check');
            $('#rdoreg_dt_pm').iCheck('uncheck');
            $('#rdoreg_report_dt_am').iCheck('check');
            $('#rdoreg_report_dt_pm').iCheck('uncheck');


            // 초반 상태 접수중...
            $('#ddlstatus_cd').val('02');

            // 숫자필드 초기화
            $('#txttestpackage_include_rate').val('0');

            // 업체정보
            $('#txtbuyer_cust_busi_no').text('');
            $('#txtbuyer_cust_status_nm').text('');
            $('#rdobuyer_cust_bill_yn').iCheck('uncheck');

            $('#txtvendor_cust_busi_no').text('');
            $('#txtvendor_cust_status_nm').text('');
            $('#rdovendor_cust_bill_yn').iCheck('uncheck');

            $('#txtintertek_user_dept').text('');

            // 접수 및 등록
            $('#txtreg_user_nm').val('<%= CkUserNm %>');

            // 버튼 설정
            $('#btnSave').addClass('hidden');
            $('#btnSaveAndMail').addClass('hidden');
            $('#btnEmail').addClass('hidden');
            $('#btnStepOne').removeClass('hidden');
            $('#btnStepTwo').removeClass('hidden');

            // 환율 셋팅
            GetCurrency_Amt($('#ddltestcurreny_cd').val());
        }
        
        //======================================================
        // Note - 접수 유형 변경 시 성적서 발행일 설정..
        //======================================================
        function SetDueReportDate() {
            var type_day = $('#ddlreg_service_type').val();

            //switch (type_day) {
            //    case "01": type_day = 0; break;
            //    case "02": type_day = 1; break;
            //    case "03": type_day = 2; break;
            //    case "04": type_day = 0; break;
            //    case "05": type_day = 1; break;
            //    case "06": type_day = 2; break;
            //    default:
            //        type_day = parseInt(type_day) - 4;
            //        break;
            //}

            var due_dt = fn_calc_date($('#txtreg_dt').val(), null, null, type_day);

            $('#txtreg_report_dt').val(due_dt);
        }

        //======================================================
        // Note - 접수 완료 & 메일전송..
        //======================================================
        function SaveRegisterFinish(btnId) {
            var strBtn = btnId == 'btnSave' ? 'Save' : 'MailSave';
            
            var Gparam = {
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_BTN_GB: strBtn,
                IV_USER_ID: '<%= this.CkUserId %>'
            };

            $.ajax({
                url: ServiceUrl + "SaveRegisterFinish",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#ddlstatus_cd').val('03');
                        $('#hidreq_code').val(result.OV_RTN_MSG);
                        $('#txtreq_key').val(result.OV_RTN_MSG);

                        //$('#ulTabs li:eq(0) a').tab('show');
                        $('#btnSave').addClass('hidden');
                        $('#btnEmail').removeClass('hidden');
                        GetRegisterList();
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
        // Note - 모델 초기화.
        //======================================================
        function ClearObjectAll() {
            pm_req = {};
            pm_req_file = [];
            pm_req_customer = [];
            pm_req_contact = [];
            pm_req_sample = [];
            pm_req_sample_file = [];
            pm_req_sample_test = [];
            pm_req_test = [];
            pm_req_test_package = [];
        }

        //======================================================
        // Note - Sample Modal Open.
        //======================================================
        function GetSampleModal(row) {
            $('#hidsample_id').val(row.id);
            if (row.SAMPLE_ID != null) {
                $('#hidsample_id_barcode').val(row.SAMPLE_ID);
            }
            $('#hidsample_short_nm').val(row.SAMPLE_SHORT_NM);
            $('#txtsample_nm').val(row.SAMPLE_NM);
            $('#txtsample_cnt').val(row.SAMPLE_CNT);
            $('#txtsample_capacity').val(row.SAMPLE_CAPACITY);
            $('#ddlsample_unit').val(row.SAMPLE_UNIT);
            $('#ddlsample_type_cd').val(row.SAMPLE_TYPE_CD);
            $('#txtsample_get_dt').val(row.SAMPLE_GET_DT_NM);
            $('#txtsample_get_place').val(row.SAMPLE_GET_PLACE);
            $('#ddlsample_team').val(row.SAMPLE_TEAM);
            $('#txtreport_no').val(row.REPORT_NO);
            $('#chksample_status_extorior').iCheck(row.STATUS_EXTORIOR_YN == 'Y' ? 'check' : 'uncheck');
            $('#chksample_status_leak').iCheck(row.STATUS_LEAK_YN == 'Y' ? 'check' : 'uncheck');
            $('#txtsample_status_remark').val(row.STATUS_REMARK);
            $('#chksample_kolas').iCheck(row.RET_KOLAS_YN == 'Y' ? 'check' : 'uncheck');
            $('#chksample_nonkolas').iCheck(row.RET_NON_KOLAS_YN == 'Y' ? 'check' : 'uncheck');
            $('#chksample_ilacmra').iCheck(row.RET_ILAC_MRA_YN == 'Y' ? 'check' : 'uncheck');
            $('#chksample_korean').iCheck(row.RET_KOR_YN == 'Y' ? 'check' : 'uncheck');
            $('#chksample_english').iCheck(row.RET_ENG_YN == 'Y' ? 'check' : 'uncheck');

            fn_grd_Sample_File_List();

            grd_Sample_File_List.dataView.beginUpdate();
            grd_Sample_File_List.dataView.setItems(row.FILE_LIST);
            grd_Sample_File_List.dataView.endUpdate();
            grd_Sample_File_List.grid.render();

            $('#modalSampleData').modal();
        }
        
        //======================================================
        // Note - Step One.
        //======================================================
        function SaveStepOne() {

            ClearObjectAll();

            // 마스터 값 셋팅
            pm_req = {
                IV_REQ_NUM : $('#hidreq_num').val(),
                IV_REQ_CODE: $('#hidreq_code').val(),
                IV_STATUS_CD: $('#ddlstatus_cd').val(),
                IV_INTERTEK_USER_ID: $('#hidintertek_user_id').val(),
                IV_INTERTEK_REMARK: $('#txtintertek_cust_remark').val(),
                IV_CUSTOMER_REQ_REMARK: $('#txtreg_customer_req_remark').val(),
                IV_REGISTER_USER_ID: '<%= CkUserId %>',
                IV_REGISTER_DT: $('#txtreg_dt').val().replaceAll('-', ''),
                IV_REGISTER_AMPM: $('#rdoreg_dt_am')[0].checked == true ? 'AM' : 'PM',
                IV_SERVICE_TYPE: $('#ddlreg_service_type').val(),
                IV_REPORT_DUE_DT: $('#txtreg_report_dt').val().replaceAll('-', ''),
                IV_REPORT_AMPM: $('#rdoreg_report_dt_am')[0].checked == true ? 'AM' : 'PM',
                IV_EXTRA_TYPE: $('#ddlextra_type').val(),
                IV_EXTRA_RATE: $('#ddlextra_rate').val(),
                IV_RE_TEST_YN: $('#ddlreg_re_test_yn').val(),
                IV_SAMPLE_ARRIVE_DT: $('#txtreg_sample_arrive_dt').val().replaceAll('-', ''),
                IV_REPORT_USE_CD: $('#ddlreport_use_cd').val(),
                IV_REPORT_SEND_CD: $('#ddlreport_send_cd').val(),
                IV_CURRENCY_CD: $('#ddltestcurreny_cd').val(),
                IV_EXCHANGE_RATE: $('#txtexchange_rate').val(),
                IV_EXCHANGE_YN: $('#chkexchange_rate')[0].checked == true ? 'Y' : 'N',
                IV_REMARK: '',
                IV_USER_ID: '<%= CkUserId %>',
            }

            // 마스터 파일 추가
            pm_req_file.push({
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_FILE_NM: $('#txtreg_file_nm').val(),
                IV_FILE_URL: $('#hidreg_file_url').val(),
                IV_USER_ID: '<%= CkUserId %>',
            });

            // 제출처
            pm_req_customer.push({
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_CUST_GB: '01',
                IV_CUST_ID: $('#hidbuyer_cust_id').val(),
                IV_BILLING_YN: $('#rdobuyer_cust_bill_yn')[0].checked == true ? 'Y' : 'N',
                IV_REMARK: $('#txtbuyer_cust_remark').val(),
                IV_USER_ID: '<%= CkUserId %>',
            });
            // 의뢰업체
            pm_req_customer.push({
                IV_REQ_NUM: $('#hidreq_num').val(),
                IV_CUST_GB: '02',
                IV_CUST_ID: $('#hidvendor_cust_id').val(),
                IV_BILLING_YN: $('#rdovendor_cust_bill_yn')[0].checked == true ? 'Y' : 'N',
                IV_REMARK: $('#txtvendor_cust_remark').val(),
                IV_USER_ID: '<%= CkUserId %>',
            });

            // 담당자
            for (var i = 0; i < grd_Contact_List.dataView.getItems().length; i++) {
                var dr = grd_Contact_List.dataView.getItems()[i];
                pm_req_contact.push({
                    IV_REQ_NUM: $('#hidreq_num').val(),
                    IV_CONTACT_ID: dr.CONTACT_ID,
                    IV_RECEIPT_TO_YN: dr.RECEIPT_TO_YN == null ? 'N' : dr.RECEIPT_TO_YN,
                    IV_RECEIPT_CC_YN: dr.RECEIPT_CC_YN == null ? 'N' : dr.RECEIPT_CC_YN,
                    IV_RECEIPT_BCC_YN: dr.RECEIPT_BCC_YN == null ? 'N' : dr.RECEIPT_BCC_YN,
                    IV_REPORT_TO_YN: dr.REPORT_TO_YN == null ? 'N' : dr.REPORT_TO_YN,
                    IV_REPORT_CC_YN: dr.REPORT_CC_YN == null ? 'N' : dr.REPORT_CC_YN,
                    IV_REPORT_BCC_YN: dr.REPORT_BCC_YN == null ? 'N' : dr.REPORT_BCC_YN,
                    IV_INVOICE_TO_YN: dr.INVOICE_TO_YN == null ? 'N' : dr.INVOICE_TO_YN,
                    IV_INVOICE_CC_YN: dr.INVOICE_CC_YN == null ? 'N' : dr.INVOICE_CC_YN,
                    IV_INVOICE_BCC_YN: dr.INVOICE_BCC_YN == null ? 'N' : dr.INVOICE_BCC_YN,
                    IV_CUST_GB : dr.CUST_GB,
                    IV_REMARK: '',
                    IV_USER_ID: '<%= CkUserId %>',
                });
            }

            if ($('#hidbuyer_cust_id').val() == '') {
                fn_info('[ 업체 정보 ] 제출처를 선택해 주세요.');
                return;
            }
            if ($('#hidvendor_cust_id').val() == '') {
                fn_info('[ 업체 정보 ] 의뢰업체를 선택해 주세요.');
                return;
            }
            if ($('#rdobuyer_cust_bill_yn')[0].checked == false && $('#rdovendor_cust_bill_yn')[0].checked == false) {
                fn_info('[ 업체 정보 ] 청구지를 선택해 주세요.');
                return;
            }

            //if (grd_Contact_List.dataView.getItems().length == 0) {
            //    fn_info('[ 담당자 정보 ] 담당자는 최소 1명 이상 추가 하셔야 합니다.');
            //    return;
            //}

            if ($('#ddlreg_service_type').val() == '') {
                fn_info('[ 접수 및 등록 ] 접수유형을 선택해 주세요.');
                return;
            }
            if ($('#ddlextra_type').val() == '') {
                fn_info('[ 접수 및 등록 ] 추가비용을 선택해 주세요.');
                return;
            }

            $.ajax({
                url: ServiceUrl + "SaveStepOne",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "pm_req": pm_req, "pm_req_file": pm_req_file, "pm_req_customer": pm_req_customer, 'pm_req_contact': pm_req_contact }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        $('#hidreq_num').val(result.OV_RTN_MSG);
                        $('#txtreq_key').val(result.OV_RTN_MSG);


                        $('#ulTabs_Step li:eq(0) a').removeClass('disabled');
                        $('#ulTabs_Step li:eq(1) a').removeClass('disabled');
                        $('#ulTabs_Step li:eq(2) a').addClass('disabled');

                        $('#ulTabs_Step li:eq(1) a').tab('show'); //다음스텝
                        $('html').scrollTop(0);
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
        // Note - Step Two.
        //======================================================
        function SaveStepTwo() {
            ClearObjectAll();
            
            // 시료
            for (var i = 0; i < grd_Sample_List.dataView.getItems().length; i++) {
                var dr = grd_Sample_List.dataView.getItems()[i];
                var drAmt = grd_Sample_Amt_List.dataView.getItems()[i];
                pm_req_sample.push({
                    IV_REQ_NUM: $('#hidreq_num').val(),                                     
                    IV_SAMPLE_ID: 1000 + pm_req_sample.length,
                    IV_SAMPLE_SHORT_NM: dr.SAMPLE_SHORT_NM,
                    IV_SAMPLE_NM: dr.SAMPLE_NM,
                    IV_SAMPLE_ENM: dr.SAMPLE_ENM,
                    IV_SAMPLE_CNT: dr.SAMPLE_CNT,
                    IV_SAMPLE_CAPACITY: dr.SAMPLE_CAPACITY,
                    IV_SAMPLE_UNIT: dr.SAMPLE_UNIT,
                    IV_SAMPLE_TYPE_CD: dr.SAMPLE_TYPE_CD,
                    IV_SAMPLE_GET_DT: dr.SAMPLE_GET_DT.replaceAll('-', ''),
                    IV_SAMPLE_GET_PLACE: dr.SAMPLE_GET_PLACE,
                    IV_SAMPLE_TEAM: dr.SAMPLE_TEAM,
                    IV_REPORT_NO: dr.REPORT_NO,
                    IV_STATUS_EXTORIOR_YN: dr.STATUS_EXTORIOR_YN,
                    IV_STATUS_LEAK_YN: dr.STATUS_LEAK_YN,
                    IV_STATUS_REMARK: dr.STATUS_REMARK,
                    IV_RET_KOLAS_YN: dr.RET_KOLAS_YN,
                    IV_RET_NON_KOLAS_YN: dr.RET_NON_KOLAS_YN,
                    IV_RET_ILAC_MRA_YN: dr.RET_ILAC_MRA_YN,
                    IV_RET_KOR_YN: dr.RET_KOR_YN,
                    IV_RET_ENG_YN: dr.RET_ENG_YN,
                    IV_TEST_TOTAL_AMT: drAmt.TEST_TOTAL_AMT.replaceAll(',', ''),
                    IV_DEFAULT_AMT_YN: drAmt.DEFAULT_AMT_YN ,
                    IV_DEFAULT_AMT: buyerDefaultAmt.replaceAll(',', ''),
                    IV_LAST_TOTAL_AMT: drAmt.LAST_TOTAL_AMT.replaceAll(',', ''),
                    IV_USER_ID: '<%= CkUserId %>',
                });

                if (dr.FILE_LIST.length > 0) {
                    for (var j = 0; j < dr.FILE_LIST.length; j++) {
                        pm_req_sample_file.push({
                            IV_REQ_NUM: pm_req_sample[i].IV_REQ_NUM,
                            IV_SAMPLE_ID: pm_req_sample[i].IV_SAMPLE_ID,
                            IV_FILE_CNT: dr.FILE_LIST[j].FILE_CNT,
                            IV_FILE_TYPE: dr.FILE_LIST[j].FILE_TYPE,
                            IV_FILE_NM: dr.FILE_LIST[j].FILE_NM,
                            IV_FILE_URL: dr.FILE_LIST[j].FILE_URL,
                            IV_USER_ID: '<%= CkUserId %>',
                        });
                    }
                }
            }

            // Test
            for (var i = 0; i < grd_Test_Package_List.dataView.getItems().length; i++) {
                var dr = grd_Test_Package_List.dataView.getItems()[i];
                pm_req_test.push({
                    IV_REQ_NUM: $('#hidreq_num').val(),
                    IV_TEST_SEQ: 100 + pm_req_test.length,
                    IV_TEST_TYPE: dr.TEST_PACKAGE_TYPE == 'Package' ? '01' : dr.TEST_PACKAGE_TYPE == 'Client' ? '02' : '03',
                    IV_PACKAGE_ID: dr.PACKAGE_ID,
                    IV_PACKAGE_NM: dr.PACKAGE_NM,
                    IV_PACKAGE_ENM: dr.PACKAGE_ENM,
                    IV_TEST_ID: dr.TEST_ID,
                    IV_TEST_NM: dr.TEST_NM,
                    IV_TEST_ENM: dr.TEST_ENM,
                    IV_UNIT_ID: dr.UNIT_ID,
                    IV_UNIT_NM : dr.UNIT_NM,
                    IV_METHOD_ID: dr.METHOD_ID,
                    IV_METHOD_NM: dr.METHOD_NM,
                    IV_METHOD_ENM: dr.METHOD_ENM,
                    IV_ENG_AMT: dr.ENG_AMT == '' ? '0' : dr.ENG_AMT.replaceAll(',', ''),
                    IV_KOR_AMT: dr.KOR_AMT == '' ? '0' : dr.KOR_AMT.replaceAll(',', ''),
                    IV_DISCOUNT_RATE: dr.DISCOUNT_RATE,
                    IV_LAST_AMT: dr.LAST_AMT == '' ? '0' : dr.LAST_AMT.replaceAll(',', ''),
                    IV_KOLAS_YN: dr.KOLAS_YN == null ? 'N' : dr.KOLAS_YN,
                    IV_TEST_TEAM: dr.TEST_TEAM == null ? '' : dr.TEST_TEAM,
                    IV_TRUST_REMARK: dr.TRUST_REMARK == null ? '' : dr.TRUST_REMARK,
                    IV_DETECTION_LIMIT_CD: dr.DETECTION_LIMIT_CD == null ? '' : dr.DETECTION_LIMIT_CD,
                    IV_SPEC_CD: dr.SPEC_CD == null ? '' : dr.SPEC_CD,
                    IV_REFERENCE_CD: dr.REFERENCE_CD == null ? '' : dr.REFERENCE_CD,
                    IV_USER_ID: '<%= CkUserId %>',
                });
            }

            // Sample 별 Test
            for (var i = 0; i < pm_req_sample.length; i++) {
                var package_id = '';
                for (var j = 0; j < pm_req_test.length; j++) {
                    var sample_field = grd_Test_Package_List.grid.getColumns()[14 + i].field;
                    var testdr = grd_Test_Package_List.dataView.getItems()[j];
                    var testdr_yn = grd_Test_Package_List.dataView.getItems()[j][sample_field];
                    // 테스트 선택
                    if (testdr_yn == 'Y') {
                        // 패키지 일 경우
                        if (testdr.PACKAGE_ID > 0) {
                            package_id = testdr.PACKAGE_ID;
                            // 같은 패키지면 Y 설정
                            if (testdr.PACKAGE_ID == package_id) {
                                pm_req_sample_test.push({
                                    IV_REQ_NUM: $('#hidreq_num').val(),
                                    IV_SAMPLE_ID: pm_req_sample[i].IV_SAMPLE_ID,
                                    IV_TEST_SEQ: pm_req_test[j].IV_TEST_SEQ,
                                    IV_USER_ID: '<%= CkUserId %>',
                                });
                            }
                        } 
                        else { // 단건의 경우.
                            pm_req_sample_test.push({
                                IV_REQ_NUM: $('#hidreq_num').val(),
                                IV_SAMPLE_ID: pm_req_sample[i].IV_SAMPLE_ID,
                                IV_TEST_SEQ: pm_req_test[j].IV_TEST_SEQ,
                                IV_USER_ID: '<%= CkUserId %>',
                            });
                        }
                    }
                    else {
                        // 같은 패키지면 Y 설정
                        if (testdr.PACKAGE_ID === package_id) {
                            pm_req_sample_test.push({
                                IV_REQ_NUM: $('#hidreq_num').val(),
                                IV_SAMPLE_ID: pm_req_sample[i].IV_SAMPLE_ID,
                                IV_TEST_SEQ: pm_req_test[j].IV_TEST_SEQ,
                                IV_USER_ID: '<%= CkUserId %>',
                            });
                        }
                    }
                }
            }

            if (pm_req_sample.length == 0) {
                fn_info('사용되지 않은 시험항목이 존재합니다. 설정을 확인해 주세요.');
                return;
            }

            for (var i = 0; i < pm_req_sample.length; i++) {
                if (pm_req_sample[i].IV_TEST_TOTAL_AMT == '0')
                {
                    fn_info('사용되지 않은 시험항목이 존재합니다. 설정을 확인해 주세요.');
                    return;
                }
                if (pm_req_sample[i].IV_REPORT_NO == '') {
                    fn_info('성적서 번호가 없는 값이 존재합니다. 설정을 확인해 주세요.');
                    return;
                }
            }
            for (var i = 0; i < pm_req_test.length; i++) {
                if (pm_req_test[i].IV_TEST_TEAM == '') {
                    fn_info('시험 항목중 팀 설정이 안된 값이 존재합니다. 설정을 확인해 주세요.');
                    return;
                }
            }



            // 시험 항목을 선택했는지 확인
            var package_id = "";
            var check_test_list = grd_Test_Package_List.dataView.getItems();

            for (var i = 0; i < check_test_list.length; i++) {
                var check_cnt = 0;
                var test_dr = check_test_list[i];

                if (package_id == test_dr.PACKAGE_ID) {
                    continue;
                }

                var check_sample_list = grd_Sample_List.dataView.getItems();
                for (var j = 0; j < check_sample_list.length; j++) {
                    var sample_dr = check_sample_list[j];
                    var sample_col = sample_dr.SAMPLE_SHORT_NM.replaceAll('(', '').replaceAll(')', ''); // TEST_A
                    var check_data = eval("grd_Test_Package_List.dataView.getItems()[i]." + "TEST_" + sample_col);
                    if (check_data == 'Y') {
                        check_cnt++;
                    }
                }
                package_id = test_dr.PACKAGE_ID;

                if (check_cnt == 0) {
                    fn_info('사용되지 않은 시험항목이 존재합니다. 설정을 확인해 주세요.');
                    return;
                }
            }

            $.ajax({
                url: ServiceUrl + "SaveStepTwo",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "pm_req_sample": pm_req_sample, "pm_req_sample_file" : pm_req_sample_file, "pm_req_test": pm_req_test, "pm_req_sample_test": pm_req_sample_test }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        if ($('#ddlstatus_cd').val() == '02') {
                            $('#btnSave').removeClass('hidden');
                            $('#btnSaveAndMail').removeClass('hidden');
                        }

                        $('#ulTabs_Step li:eq(0) a').removeClass('disabled');
                        $('#ulTabs_Step li:eq(1) a').removeClass('disabled');
                        $('#ulTabs_Step li:eq(2) a').removeClass('disabled');

                        $('#ulTabs_Step li:eq(2) a').tab('show'); //다음스텝
                        $('html').scrollTop(0);
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
        // Note - 접수완료 화면 셋팅.
        //======================================================
        function SetStepCompleteData() {
            // 접수내역
            $('#txtreg_user_nm_com').text($('#txtreg_user_nm').val());
            $('#txtreg_dt_com').text($('#txtreg_dt').val() + ($('#rdoreg_dt_am')[0].checked == true ? ' ( AM )' : ' ( PM )'));
            $('#ddlreg_service_type_com').text($('#ddlreg_service_type option:selected').text());
            $('#txtreg_report_dt_com').text($('#txtreg_report_dt').val() + ($('#rdoreg_report_dt_am')[0].checked == true ? ' ( AM )' : ' ( PM )'));
            $('#ddlreg_re_test_yn_com').text($('#ddlreg_re_test_yn').val());
            $('#txtreg_sample_arrive_dt_com').text($('#txtreg_sample_arrive_dt').val());
            $('#txtreg_file_nm_com').attr("href", $('#hidreg_file_url').val());
            $('#txtreg_file_nm_com').val($('#txtreg_file_nm').val());

            // 업체정보
            $('#txtbuyer_cust_nm_com').text($('#txtbuyer_cust_nm').val());
            $('#txtbuyer_cust_busi_no_com').text($('#txtbuyer_cust_busi_no').text());
            $('#txtbuyer_cust_status_nm_com').text($('#txtbuyer_cust_status_nm').text());
            $('#rdobuyer_cust_bill_yn_com').text($('#rdobuyer_cust_bill_yn')[0].checked == true ? "●" : "");
            $('#txtbuyer_cust_remark_com').text($('#txtbuyer_cust_remark').val());
            $('#txtvendor_cust_nm_com').text($('#txtvendor_cust_nm').val());
            $('#txtvendor_cust_busi_no_com').text($('#txtvendor_cust_busi_no').text());
            $('#txtvendor_cust_status_nm_com').text($('#txtvendor_cust_status_nm').text());
            $('#rdovendor_cust_bill_yn_com').text($('#rdovendor_cust_bill_yn')[0].checked == true ? "●" : "");
            $('#txtvendor_cust_remark_com').text($('#txtvendor_cust_remark').val());
            $('#txtintertek_user_nm_com').text($('#txtintertek_user_nm').val());
            $('#txtintertek_user_dept_com').text($('#txtintertek_user_dept').text());
            $('#txtintertek_cust_remark_com').text($('#txtintertek_cust_remark').val());

            // 담당자 정보
            var gridContact = grd_Contact_List.dataView.getItems();
            $('#tbl_contact_com tbody').empty();
            var strContactList = '';
            for (var i = 0; i < gridContact.length; i++) {
                strContactList += '<tr>';
                strContactList += '<td style="text-align:left;">' + gridContact[i].CUST_LIST + '</td>'
                strContactList += '<td style="text-align:left;">' + gridContact[i].CUST_GB_NM + '</td>'
                strContactList += '<td>' + gridContact[i].CONTACT_NM + '</td>'
                strContactList += '<td>' + gridContact[i].CONTACT_ENM + '</td>'
                strContactList += '<td style="text-align:left;">' + gridContact[i].CONTACT_EMAIL + '</td>'
                strContactList += '<td>' + (gridContact[i].RECEIPT_TO_YN == undefined ? '' : gridContact[i].RECEIPT_TO_YN == 'N' ? '' : '●') + '</td>'
                strContactList += '<td>' + (gridContact[i].RECEIPT_CC_YN == undefined ? '' : gridContact[i].RECEIPT_CC_YN == 'N' ? '' : '●') + '</td>'
                strContactList += '<td>' + (gridContact[i].RECEIPT_BCC_YN == undefined ? '' : gridContact[i].RECEIPT_BCC_YN == 'N' ? '' : '●') + '</td>'
                strContactList += '<td>' + (gridContact[i].REPORT_TO_YN == undefined ? '' : gridContact[i].REPORT_TO_YN == 'N' ? '' : '●') + '</td>'
                strContactList += '<td>' + (gridContact[i].REPORT_CC_YN == undefined ? '' : gridContact[i].REPORT_CC_YN == 'N' ? '' : '●') + '</td>'
                strContactList += '<td>' + (gridContact[i].REPORT_BCC_YN == undefined ? '' : gridContact[i].REPORT_BCC_YN == 'N' ? '' : '●') + '</td>'
                strContactList += '<td>' + (gridContact[i].INVOICE_TO_YN == undefined ? '' : gridContact[i].INVOICE_TO_YN == 'N' ? '' : '●') + '</td>'
                strContactList += '<td>' + (gridContact[i].INVOICE_CC_YN == undefined ? '' : gridContact[i].INVOICE_CC_YN == 'N' ? '' : '●') + '</td>'
                strContactList += '<td>' + (gridContact[i].INVOICE_BCC_YN == undefined ? '' : gridContact[i].INVOICE_BCC_YN == 'N' ? '' : '●') + '</td>'
                strContactList += '</tr>';
            }

            $('#tbl_contact_com tbody').append(strContactList);

            // 시료 정보
            $('.ddltestcurreny_cd_com').text($('#ddltestcurreny_cd option:selected').text());
            $('.chkexchange_rate_com').text($('#chkexchange_rate')[0].checked == true ? "Y" : "N");
            $('.txtexchange_rate_com').text($('#txtexchange_rate').val());

            var gridTest = grd_Test_Package_List.dataView.getItems();
            var gridSample = grd_Sample_Amt_List.dataView.getItems();

            $('#tblcomplete_sample tbody').empty();
            var strTable = '<tr><th>접수유형</th><th>시험항목</th><th>시험방법</th><th>할인율</th><th>검출한계</th><th>스팩(규격)</th><th>레퍼런스</th><th>금액</th></tr>';
            for (var i = 0; i < gridSample.length; i++) {
                strTable += '<tr><td colspan="8"></td></tr>';
                strTable += '<tr><th colspan="8">' + gridSample[i].SAMPLE_SHORT_NM + ' ' + gridSample[i].SAMPLE_NM + '</th></tr>';

                var package_id = '';

                for (var j = 0; j < gridTest.length; j++) {
                    if (gridTest[j][grd_Test_Package_List.grid.getColumns()[i + 14].field] == 'Y') {
                        strTable += '<tr>'
                                         + '<td>' + gridTest[j].TEST_PACKAGE_TYPE + '</td>'
                                         + '<td>' + gridTest[j].TEST_PACKAGE_NM + '</td>'
                                         + '<td>' + gridTest[j].METHOD_NM + '</td>'
                                         + '<td style="text-align:center;">' + gridTest[j].DISCOUNT_RATE + ' %</td>'
                                         + '<td>' + gridTest[j].DETECTION_LIMIT_CD + '</td>'
                                         + '<td>' + gridTest[j].SPEC_CD + '</td>'
                                         + '<td>' + gridTest[j].REFERENCE_CD + '</td>'
                                         + '<td style="text-align:right;">' + gridTest[j].LAST_AMT + '</td>'
                        '</tr>';

                        package_id = gridTest[j].PACKAGE_ID;
                    } else {
                        if (package_id != '' && package_id === gridTest[j].PACKAGE_ID) {
                            strTable += '<tr>'
                                         + '<td>' + gridTest[j].TEST_PACKAGE_TYPE + '</td>'
                                         + '<td>' + gridTest[j].TEST_PACKAGE_NM + '</td>'
                                         + '<td>' + gridTest[j].METHOD_NM + '</td>'
                                         + '<td style="text-align:center;"></td>'
                                         + '<td>' + gridTest[j].DETECTION_LIMIT_CD + '</td>'
                                         + '<td>' + gridTest[j].SPEC_CD + '</td>'
                                         + '<td>' + gridTest[j].REFERENCE_CD + '</td>'
                                         + '<td style="text-align:right;"></td>'
                            '</tr>';
                        }
                    }
                }
                strTable += '<tr>'
                                + '<td style="font-weight:bold;" colspan="7">Total</td>'
                                + '<td style="font-weight:bold; font-size:1.2em; text-align:right;">' + gridSample[i].LAST_TOTAL_AMT + '</td>'
                            + '</tr>';

            }
            $('#tblcomplete_sample tbody').append(strTable);
        }

        //======================================================
        // Note - 모달 : 시험 테스트 저장.
        //======================================================
        function SaveModalPackageTestList() {
            if (grd_Modal_Package_Test_List.grid.getSelectedRows().length == 0) {
                fn_info('선택된 데이터가 없습니다.');
                return;
            }

            var gridData = grd_Modal_Package_Test_List.grid.getSelectedRows();

            var Gparam = [];

            for (var i = 0; i < gridData.length; i++) {
                Gparam.push({
                    IV_TEST_PACKAGE_ID: grd_Modal_Package_Test_List.grid.getDataItem(gridData[i])["TEST_PACKAGE_ID"],
                    IV_TEST_PACKAGE_TYPE: grd_Modal_Package_Test_List.grid.getDataItem(gridData[i])["TEST_PACKAGE_TYPE"],
                    IV_CUST_ID: grd_Modal_Package_Test_List.grid.getDataItem(gridData[i])["CUST_ID"],
                    IV_UNIT_ID: grd_Modal_Package_Test_List.grid.getDataItem(gridData[i])["UNIT_ID"],
                    IV_METHOD_ID: grd_Modal_Package_Test_List.grid.getDataItem(gridData[i])["METHOD_ID"],
                    IV_USER_ID: '<%= this.CkUserId %>'
                });
            }

            $.ajax({
                url: ServiceUrl + "SaveModalPackageTestList_GetDetail",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    //fn_ClearGrid(grd_Test_Package_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        $(jsonData.result).each(function (index, entry) {
                            grd_Test_Package_List.dataView.beginUpdate();
                            entry.id = grd_Test_Package_List.dataView.getItems().length;
                            grd_Test_Package_List.dataView.addItem(entry);
                            grd_Test_Package_List.dataView.endUpdate();
                        });

                        SetTestPackageListAmt();
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

            $('#modalPackageTest').modal('hide');
        }

        //======================================================
        // Note - 테스트 금액별 할인 후 적용.
        //======================================================
        function SetTestPackageListAmt() {
            var gridData = grd_Test_Package_List.dataView.getItems();
            var currency_apply_yn = $('#chkexchange_rate')[0].checked == true ? "Y" : "N";
            var package_id = '';

            for (var i = 0; i < gridData.length; i++) {
                var calcAmt = 0;
                var rateInt = 0;
                
                if (package_id === gridData[i].PACKAGE_ID) {
                    gridData[i].ENG_AMT = '';
                    gridData[i].KOR_AMT = '';
                    gridData[i].DISCOUNT_RATE = '';
                    gridData[i].LAST_AMT = '';
                    gridData[i].KOLAS_YN = 'N';
                    grd_Test_Package_List.dataView.updateItem(gridData[i].id, gridData[i]);
                    continue;
                };

                if ($('#ddltestcurreny_cd').val() == '90') {
                    calcAmt = gridData[i].KOR_AMT.replaceAll(',', '');
                } else {
                    if (currency_apply_yn == 'Y') {
                        calcAmt = gridData[i].ENG_AMT.replaceAll(',', '') * $('#txtexchange_rate').val().replaceAll(',', '');
                    }
                    else {
                        calcAmt = gridData[i].ENG_AMT.replaceAll(',', '');
                    }
                }
                calcAmt = calcAmt * (1 - gridData[i].DISCOUNT_RATE / 100);

                gridData[i].LAST_AMT = $.number(calcAmt, 0);
                grd_Test_Package_List.dataView.updateItem(gridData[i].id, gridData[i]);

                if (gridData[i].PACKAGE_ID != '0') {
                    package_id = gridData[i].PACKAGE_ID;
                } 

            }
            
        }

        //======================================================
        // Note - 모달 : 시험 테스트 리스트.
        //======================================================
        function GetModalPackageTestList() {
            var DeleteItem = [];

            for (var i = 0; i < grd_Test_Package_List.dataView.getItems().length; i++) {
                var dr = grd_Test_Package_List.dataView.getItems()[i];
                if (dr.PACKAGE_ID != '0') {
                    DeleteItem.push(grd_Test_Package_List.dataView.getItems()[i]["id_Gb"])
                }
            }

            DeleteItem = $.unique(DeleteItem);

            var Gparam = {
                IV_CUST_ID: $('#hidbuyer_cust_id').val(),
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetModalPackageTestList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Modal_Package_Test_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Modal_Package_Test_List.dataView.beginUpdate();
                        grd_Modal_Package_Test_List.dataView.setItems(jsonData.result);
                        grd_Modal_Package_Test_List.dataView.setFilter(filter_Modal_Package_Test);
                        grd_Modal_Package_Test_List.dataView.endUpdate();
                        grd_Modal_Package_Test_List.grid.render();

                        for (var i = 0; i < DeleteItem.length; i++) {
                            grd_Modal_Package_Test_List.dataView.deleteItem(DeleteItem[i]);
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
        // Note - 패키지 및 시험 삭제
        //======================================================
        function DeletePackageTestList() {
            if (grd_Test_Package_List.grid.getSelectedRows().length == 0) {
                fn_info('데이터를 선택해 주세요.');
                return;
            }

            var gridData = grd_Test_Package_List.grid.getSelectedRows();

            var DeleteData = [];
            for (var i = 0; i < gridData.length; i++) {

                if (grd_Test_Package_List.grid.getDataItem(gridData[i])["PACKAGE_ID"] > 0) { // Package 일때.
                    var gridTestList = grd_Test_Package_List.dataView.getItems();
                    for (var j = 0; j < gridTestList.length; j++) {
                        if (gridTestList[j].PACKAGE_ID == grd_Test_Package_List.grid.getDataItem(gridData[i])["PACKAGE_ID"]) {
                            DeleteData.push(gridTestList[j]["id"]);
                        }
                    }
                } else { // 일반 시험 항목 일때.
                    DeleteData.push(grd_Test_Package_List.grid.getDataItem(gridData[i])["id"]);
                }
            }

            var resultArr = []; 
            
            $.each(DeleteData, function (key, value) {
                if($.inArray(value, resultArr) === -1) resultArr.push(value); 
            });

            for (var i = 0; i < resultArr.length; i++) {
                grd_Test_Package_List.dataView.deleteItem(resultArr[i]);
            }

            grd_Test_Package_List.grid.setSelectedRows([]);
            GetSampleAmtTotal();
        }

        //======================================================
        // Note - 시료에따른 패키지테스트 그리드 설정.
        //======================================================
        function SetTestPackageGrid() {
            grd_Test_Package_List_Columns = [
                grd_Test_Package_List_checkbox.getColumnDefinition(),
                { id: "TEST_PACKAGE_TYPE", name: "접수유형", field: "TEST_PACKAGE_TYPE", cssClass: "cell-align-left", width: 80, sortable: true, formatter: GDH_TextPopupColor },
                { id: "TEST_PACKAGE_NM", name: "시험항목", field: "TEST_PACKAGE_NM", cssClass: "cell-align-left", width: 150, sortable: true },
                { id: "METHOD_ID", name: "시험방법", field: "METHOD_NM", cssClass: "cell-align-left", width: 150, sortable: true, editor: Slick.Editors.TestMethod },
                { id: "ENG_AMT", name: "USD($)", field: "ENG_AMT", cssClass: "cell-align-right", width: 80, sortable: true },
                { id: "KOR_AMT", name: "KRW(￦)", field: "KOR_AMT", cssClass: "cell-align-right", width: 80, sortable: true },
                { id: "DISCOUNT_RATE", name: "할인율(%)", field: "DISCOUNT_RATE", cssClass: "cell-align-right", width: 80, sortable: true, editor: Slick.Editors.Text, formatter: GDH_NumberFormatter },
                { id: "LAST_AMT", name: "최종 금액", field: "LAST_AMT", cssClass: "cell-align-right", width: 80, sortable: true },
                { id: "UNIT_ID", name: "Unit", field: "UNIT_NM", cssClass: "cell-align-center", width: 80, sortable: true, editor: Slick.Editors.TestUnit },
                //{
                //    id: "KOLAS_YN", name: "공인", field: "KOLAS_YN", cssClass: "cell-align-center", width: 70, sortable: true, editor: Slick.Editors.Checkbox,
                //    formatter: Slick.Formatters.Checkmark,
                //    header: {
                //        buttons: [
                //          {
                //              cssClass: "icon-highlight-off",
                //              command: "toggle-highlight",
                //          }
                //        ]
                //    }
                //},
                { id: "TEST_TEAM", name: "팀", field: "TEST_TEAM", cssClass: "cell-align-left", width: 70, sortable: true, options: fn_grid_optionDatas('0101', false), editor: GDH_SelectEditor, formatter: GDH_SelectFormatter },
                { id: "TRUST_REMARK", name: "위탁", field: "TRUST_REMARK", cssClass: "cell-align-left", width: 80, sortable: true, editor: Slick.Editors.Text },
                { id: "DETECTION_LIMIT_CD", name: "검출한계", field: "DETECTION_LIMIT_CD", cssClass: "cell-align-left", width: 80, sortable: true, editor: Slick.Editors.Text },
                { id: "SPEC_CD", name: "스팩(규격)", field: "SPEC_CD", cssClass: "cell-align-left", width: 80, sortable: true, editor: Slick.Editors.Text },
                { id: "REFERENCE_CD", name: "레퍼런스", field: "REFERENCE_CD", cssClass: "cell-align-left", width: 80, sortable: true, editor: Slick.Editors.Text },
            ];

            for (var i = 0; i < grd_Sample_List.dataView.getItems().length; i++) {
                var sample_short_nm = grd_Sample_List.dataView.getItems()[i].SAMPLE_SHORT_NM;

                var colums = {
                    id: "TEST_" + sample_short_nm.replaceAll('(', '').replaceAll(')', ''),
                    name: sample_short_nm,
                    field: "TEST_" + sample_short_nm.replaceAll('(', '').replaceAll(')', ''),
                    cssClass: "cell-align-center",
                    width: 70,
                    sortable: true,
                    editor: Slick.Editors.Checkbox,
                    formatter: Slick.Formatters.Checkmark,
                    header: {
                        buttons: [
                          {
                              cssClass: "icon-highlight-off",
                              command: "toggle-highlight",
                          }
                        ]
                    }
                };

                grd_Test_Package_List_Columns.push(colums);
            }

            grd_Test_Package_List.columns = grd_Test_Package_List_Columns;

             // Note - Grid 초기화
            grd_Test_Package_List.grid = new Slick.Grid("#grd_Test_Package_List", grd_Test_Package_List.dataView, grd_Test_Package_List.columns, grd_Test_Package_List.options);
            // Note - Row 선택시 배경색 반전
            grd_Test_Package_List.grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true }));
            //선택된 checkbox 선택 관련
            grd_Test_Package_List.grid.registerPlugin(grd_Test_Package_List_checkbox);
            grd_Test_Package_List.grid.setSelectedRows([]);

            // Note - 스크롤사용시 숨겨진 Row의 생성(없으면 보여지는 페이지만 Row가 생성된다.)
            grd_Test_Package_List.dataView.onRowCountChanged.subscribe(function (e, args) {
                grd_Test_Package_List.grid.updateRowCount();
                grd_Test_Package_List.grid.render();
            });

            // Note - Row 위치가 변경되면 수행된다.(Sort시 같이 사용해야함)
            grd_Test_Package_List.dataView.onRowsChanged.subscribe(function (e, args) {
                grd_Test_Package_List.grid.invalidateRows(args.rows);
                grd_Test_Package_List.grid.render();
            });
            // Note - 그리드에서 Cell에서 포커스가 변경될때(Changed)
            grd_Test_Package_List.grid.onCellChange.subscribe(function (e, args) {
                var gridData = grd_Test_Package_List.dataView.getItems();
                var row = args.item;
                if (args.cell == 3) {
                    if (row.TEST_PACKAGE_TYPE != 'Package') {
                        fn_SelectMethodChanged(row);
                    }
                }
                // 할인율 적용 선택 시
                if (args.cell == 6) { 
                    if (row.PACKAGE_ID != '0') {
                        for (var i = 0; i < gridData.length; i++) {
                            if (gridData[i].PACKAGE_ID == row.PACKAGE_ID) {
                                gridData[i].DISCOUNT_RATE = row.DISCOUNT_RATE;
                                grd_Test_Package_List.dataView.updateItem(gridData[i].id, gridData[i]);
                            }
                        }
                    }
                }
                // 시료별 변경 시
                if (args.cell > 14) {
                    if (row.PACKAGE_ID != '0') {
                        var package_top_bool = true;
                        for (var i = 0; i < gridData.length; i++) {
                            if (gridData[i].PACKAGE_ID == row.PACKAGE_ID) {
                                if (package_top_bool) {
                                    gridData[i][grd_Test_Package_List.grid.getColumns()[args.cell].field] = row[grd_Test_Package_List.grid.getColumns()[args.cell].field];
                                } else {
                                    gridData[i][grd_Test_Package_List.grid.getColumns()[args.cell].field] = "N";
                                }
                                grd_Test_Package_List.dataView.updateItem(gridData[i].id, gridData[i]);
                                package_top_bool = false;
                            }
                        }
                    }
                }
                SetTestPackageListAmt();
                GetSampleAmtTotal();
            });


            var headerButtonsPlugin = new Slick.Plugins.HeaderButtons();
            headerButtonsPlugin.onCommand.subscribe(function (e, args) {
                var column = args.column;
                var button = args.button;
                var command = args.command;
                var grdDatas = grd_Test_Package_List.dataView.getItems();
                if (command == "toggle-highlight") {
                    if (button.cssClass == "icon-highlight-on") {
                        button.cssClass = "icon-highlight-off";
                        for (var i = 0; i < grdDatas.length; i++) {
                            eval("grdDatas[" + i + "]." + column.id + "= 'N'");
                        }
                    } else {
                        button.cssClass = "icon-highlight-on";

                        for (var i = 0; i < grdDatas.length; i++) {
                            eval("grdDatas[" + i + "]." + column.id + "= 'Y'");
                        }

                    }
                    grd_Test_Package_List.dataView.setItems(grdDatas);
                    grd_Test_Package_List.grid.invalidate();
                    GetSampleAmtTotal();

                    var gridData = grd_Test_Package_List.dataView.getItems();
                    var package_id = '';

                    for (var i = 0; i < gridData.length; i++) {
                        if (package_id === gridData[i].PACKAGE_ID) {
                            gridData[i][args.column.field] = 'N';
                            grd_Test_Package_List.dataView.updateItem(gridData[i].id, gridData[i]);
                        };

                        if (gridData[i].PACKAGE_ID != '0') {
                            package_id = gridData[i].PACKAGE_ID;
                        }
                    }
                    
                }
            });
            grd_Test_Package_List.grid.registerPlugin(headerButtonsPlugin);

            grd_Test_Package_List.grid.init();

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

                        grd_Test_Package_List.dataView.beginUpdate();
                        grd_Test_Package_List.dataView.updateItem(row.id, row);
                        grd_Test_Package_List.dataView.endUpdate();
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
        // Note - 시료 별 금액설정
        //======================================================
        function SetSampleAmtGrid() {
            var sampleAmtList = [];
            var sampleList = grd_Sample_List.dataView.getItems();

            for (var i = 0; i < sampleList.length; i++) {
                sampleAmtList.push({
                    id: sampleList[i].id,
                    SAMPLE_SHORT_NM: sampleList[i].SAMPLE_SHORT_NM,
                    SAMPLE_NM: sampleList[i].SAMPLE_NM,
                    TEST_TOTAL_AMT: 0,
                    DEFAULT_AMT_YN: 'N',
                    LAST_TOTAL_AMT: 0
                });
            }

            fn_ClearGrid(grd_Sample_Amt_List);

            grd_Sample_Amt_List.dataView.beginUpdate();
            grd_Sample_Amt_List.dataView.setItems(sampleAmtList);
            grd_Sample_Amt_List.dataView.endUpdate();
            grd_Sample_Amt_List.grid.render();

            GetSampleAmtTotal();
        }

        //======================================================
        // Note - 환율 가져오기
        //======================================================
        function GetCurrency_Amt(currency_cd) {
            var currency_amt = '';
            var Gparam = {
                IV_CURRENCY_CD: currency_cd,
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetCurrency_Amt",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                asyncc: false,
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        if ($('#ddltestcurreny_cd').val() == '90') {
                            currency_amt = '0';
                        }
                        else {
                            if (jsonData.result.length > 0) {
                                currency_amt = $.number(jsonData.result[0].CURRENCY_AMT, 2);
                            } else {
                                currency_amt = '0';
                            }
                        }
                        $('#txtexchange_rate').val(currency_amt);

                        SetTestPackageListAmt();
                        GetSampleAmtTotal();
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
        // Note - 시료 별 시험 체크금액 합산.
        //======================================================
        function GetSampleAmtTotal() {
            // Note - Cell Edit 해제
            if (!Slick.GlobalEditorLock.commitCurrentEdit()) {
                return;
            }

            var grdSampleAmtList = grd_Sample_Amt_List.dataView.getItems();
            var grdTestList = grd_Test_Package_List.dataView.getItems();
            var currency_gb = $('#ddltestcurreny_cd').val();

            for (var i = 0; i < grdSampleAmtList.length; i++) {
                var testAmtSum = 0.0; // 시험 합계
                var defaultYn = grdSampleAmtList[i].DEFAULT_AMT_YN;
                var currency_amt = $('#txtexchange_rate').val().replaceAll(',', '');
                var currency_apply_yn = $('#chkexchange_rate')[0].checked == true ? "Y" : "N";
                var totalSum = 0.0; // 총금액
                var package_id = '';

                for (var j = 0; j < grdTestList.length; j++) {
                    var calcAmt = 0;
                    // 체크했을때.
                    if (grdTestList[j][grd_Test_Package_List.grid.getColumns()[i + 14].field] == 'Y') {
                        if (package_id === grdTestList[j].PACKAGE_ID) continue;
                        calcAmt = currency_gb == '90' ? grdTestList[j].KOR_AMT.replaceAll(',', '') : grdTestList[j].ENG_AMT.replaceAll(',', '');
                        if (currency_gb == '01') {
                            if (currency_apply_yn == 'Y') {
                                calcAmt = parseFloat(calcAmt) * parseFloat(currency_amt);
                            }
                        } 
                        calcAmt = parseFloat(calcAmt);

                        // 할인율 적용이 있을때.
                        if (grdTestList[j].DISCOUNT_RATE != '0') {
                            calcAmt = calcAmt * (1 - grdTestList[j].DISCOUNT_RATE / 100);
                        }
                        testAmtSum += calcAmt;
                        if (grdTestList[j].PACKAGE_ID != '0')  package_id = grdTestList[j].PACKAGE_ID;
                    }
                }

                grdSampleAmtList[i].TEST_TOTAL_AMT = $.number(testAmtSum, 0);

                if (defaultYn == 'Y') {
                    totalSum = buyerDefaultAmt;
                } else {
                    totalSum = testAmtSum;
                }
                grdSampleAmtList[i].LAST_TOTAL_AMT = $.number(totalSum, 0);;
                

                grd_Sample_Amt_List.dataView.updateItem(grdSampleAmtList[i].id, grdSampleAmtList[i]);
            }

            // 시료 정보
            $('.ddltestcurreny_cd_com').text($('#ddltestcurreny_cd option:selected').text());
            $('.chkexchange_rate_com').text($('#chkexchange_rate')[0].checked == true ? "Y" : "N");
            $('.txtexchange_rate_com').text($('#txtexchange_rate').val());
        }

        //======================================================
        // Note - 시료 데이터 삭제
        //======================================================
        function DeleteSampleFileData() {///
            if (grd_Sample_File_List.grid.getSelectedRows().length == 0) {
                fn_info('데이터를 선택해 주세요.');
                return;
            }

            var gridData = grd_Sample_File_List.grid.getSelectedRows();

            var DeleteData = [];
            for (var i = 0; i < gridData.length; i++) {
                DeleteData.push(grd_Sample_File_List.grid.getDataItem(gridData[i])["id"]);
            }
            for (var i = 0; i < DeleteData.length; i++) {
                grd_Sample_File_List.dataView.deleteItem(DeleteData[i]);
            }

            grd_Sample_File_List.grid.setSelectedRows([]);
        }

        //======================================================
        // Note - 시료 데이터 삭제
        //======================================================
        function DeleteSampleData() {///
            if (grd_Sample_List.grid.getSelectedRows().length == 0) {
                fn_info('데이터를 선택해 주세요.');
                return;
            }

            var gridData = grd_Sample_List.grid.getSelectedRows();

            var DeleteData = [];
            for (var i = 0; i < gridData.length; i++) {
                DeleteData.push(grd_Sample_List.grid.getDataItem(gridData[i])["id"]);
            }
            for (var i = 0; i < DeleteData.length; i++) {
                grd_Sample_List.dataView.deleteItem(DeleteData[i]);
            }

            grd_Sample_List.grid.setSelectedRows([]);
            SetTestPackageGrid();
            SetSampleAmtGrid();
        }

        //======================================================
        // Note - 모달 : 시료데이터 저장.
        //======================================================
        function SaveModalSampleData() {
            var sample_items = grd_Sample_List.dataView.getItems();
            var Gparam = {
                SAMPLE_NM: $('#txtsample_nm').val(),
                SAMPLE_ENM: $('#txtsample_nm').val(),
                SAMPLE_CNT: $('#txtsample_cnt').val(),
                SAMPLE_CAPACITY: $('#txtsample_capacity').val(),
                SAMPLE_UNIT: $('#ddlsample_unit').val(),
                SAMPLE_TYPE_CD: $('#ddlsample_type_cd').val(),
                SAMPLE_GET_DT: $('#txtsample_get_dt').val(),
                SAMPLE_GET_PLACE: $('#txtsample_get_place').val(),
                SAMPLE_TEAM: $('#ddlsample_team').val(),
                REPORT_NO: $('#txtreport_no').val(),
                STATUS_EXTORIOR_YN: $('#chksample_status_extorior')[0].checked == true ? 'Y' : 'N',
                STATUS_LEAK_YN: $('#chksample_status_leak')[0].checked == true ? 'Y' : 'N',
                STATUS_REMARK: $('#txtsample_status_remark').val(),

                RET_KOLAS_YN: $('#chksample_kolas')[0].checked == true ? 'Y' : 'N',
                RET_NON_KOLAS_YN: $('#chksample_nonkolas')[0].checked == true ? 'Y' : 'N',
                RET_ILAC_MRA_YN: $('#chksample_ilacmra')[0].checked == true ? 'Y' : 'N',
                RET_KOR_YN: $('#chksample_korean')[0].checked == true ? 'Y' : 'N',
                RET_ENG_YN: $('#chksample_english')[0].checked == true ? 'Y' : 'N',

                SAMPLE_TEAM_NM: $('#ddlsample_team option:selected').text(),
                SAMPLE_TYPE_CD_NM: $('#ddlsample_type_cd option:selected').text(),
                SAMPLE_GET_DT_NM: $('#txtsample_get_dt').val(),
                FILE_LIST : grd_Sample_File_List.dataView.getItems(),       
            };

            if (Gparam.SAMPLE_NM == '') {
                fn_info('시료명 값을 입력해 주세요.');
                return;
            }
            if (Gparam.SAMPLE_CNT == '0') {
                fn_info('수량 값을 입력해 주세요.');
                return;
            }
            //if (Gparam.STATUS_EXTORIOR_YN == 'N' && Gparam.STATUS_LEAK_YN == 'N') {
            //    fn_info('상태 값을 입력해 주세요.');
            //    return;
            //}
            if (Gparam.RET_KOLAS_YN == 'N'
                && Gparam.RET_NON_KOLAS_YN == 'N'
                && Gparam.RET_ILAC_MRA_YN == 'N'
                && Gparam.RET_KOR_YN == 'N'
                && Gparam.RET_ENG_YN == 'N') {
                fn_info('형태 값을 입력해 주세요.');
                return;
            }

            var arrShort_nm = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
            var lastItemNm = sample_items.length == 0 ? "A" : arrShort_nm[$.inArray(sample_items[sample_items.length - 1].SAMPLE_SHORT_NM.replaceAll("(", "").replaceAll(")", ""), arrShort_nm) + 1];

            if ($('#hidsample_id').val() == '') {
                Gparam.id = (sample_items.length == 0 ? 0 : parseInt(sample_items[sample_items.length - 1].id)) + 1;
                Gparam.SAMPLE_SHORT_NM = "(" + lastItemNm + ")";
                grd_Sample_List.dataView.addItem(Gparam);
            } else {
                Gparam.id = $('#hidsample_id').val();
                Gparam.SAMPLE_SHORT_NM = $('#hidsample_short_nm').val();

                var row = parseInt(Gparam.id) - 1;
                Gparam.REQ_NUM = sample_items[row].REQ_NUM,
                Gparam.SAMPLE_ID = sample_items[row].SAMPLE_ID,

                grd_Sample_List.dataView.updateItem(Gparam.id, Gparam);

                // 시료사진있으면 저장로직 한번.
                if ($('#ddlstatus_cd').val() == '03') {
                    SaveSampleFileList(row);
                }
            }

            //if ($('#hidsample_id').val() == '') {
            //    Gparam.id = (sample_items.length == 0 ? 0 : sample_items[sample_items.length - 1].id) + 1;
            //    Gparam.SAMPLE_SHORT_NM = "(" + String.fromCharCode(64 + ((sample_items.length == 0 ? 0 : sample_items[sample_items.length - 1].id) + 1)) + ")";
            //    grd_Sample_List.dataView.addItem(Gparam);
            //} else {
            //    Gparam.id = $('#hidsample_id').val();
            //    Gparam.SAMPLE_SHORT_NM = $('#hidsample_short_nm').val();
            //    grd_Sample_List.dataView.updateItem(Gparam.id, Gparam);
            //}

            $('#modalSampleData').modal('hide');
            
            SetTestPackageGrid();
            SetSampleAmtGrid();
        }

        //======================================================
        // Note - 샘플별 파일을 저장.
        //======================================================
        function SaveSampleFileList(row) {
            var sampleDr = grd_Sample_List.dataView.getItems()[row];
            if (sampleDr.REQ_NUM == null || sampleDr.SAMPLE_ID == null) {
                fn_info('존재하던 데이터가 아니라 사진을 등록할 수 없습니다.');
                return;
            }
            var Gparam = {
                IV_REQ_NUM: sampleDr.REQ_NUM,
                IV_SAMPLE_ID: sampleDr.SAMPLE_ID,
                IV_USER_ID: '<%= CkUserId %>',
            }
            var arrGparam = [];
            for (var i = 0; i < grd_Sample_File_List.dataView.getItems().length; i++) {
                var dr = grd_Sample_File_List.dataView.getItems()[i];
                arrGparam.push({
                    IV_REQ_NUM: sampleDr.REQ_NUM,
                    IV_SAMPLE_ID: sampleDr.SAMPLE_ID,
                    IV_FILE_CNT: dr.FILE_CNT,
                    IV_FILE_TYPE: dr.FILE_TYPE,
                    IV_FILE_NM: dr.FILE_NM,
                    IV_FILE_URL: dr.FILE_URL,
                    IV_USER_ID: '<%= CkUserId %>',
                });
            }

            $.ajax({
                url: ServiceUrl + "SaveSampleFileList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam, "arrGparam": arrGparam }),
                dataType: "json",
                success: function (response) {
                    var result = response.d;

                    if (result.OV_RTN_CODE == "0") {
                        
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
        // Note - 담당자 리스트 삭제.
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
        // Note - 모달 담당자 리스트 저장.
        //======================================================
        function SaveModalContactList() {
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
                    CONTACT_EMAIL: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CONTACT_EMAIL"],
                    CUST_LIST: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CUST_LIST"],
                    CUST_GB_NM: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CUST_GB_NM"],
                    CUST_GB: grd_Modal_Contact_List.grid.getDataItem(gridData[i])["CUST_GB"],
                    IV_USER_ID: '<%= this.CkUserId %>',
                };

                grd_Contact_List.dataView.addItem(ModalList);
            }
            GetModalContactList();

            $('#modalContact').modal('hide');
        }

        //======================================================
        // Note - 모달 담당자 리스트.
        //======================================================
        function GetModalContactList() {
            var DeleteItem = [];

            for (var i = 0; i < grd_Contact_List.dataView.getItems().length; i++) {
                DeleteItem.push(grd_Contact_List.dataView.getItems()[i]["id"])
            }

            var Gparam = {
                IV_CUST_ID1: $('#hidbuyer_cust_id').val(),
                IV_CUST_ID2: $('#hidvendor_cust_id').val(),
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
        // Note - 모달 업체 저장.
        //======================================================
        function SaveModalCustData(row) {

            switch ($('#hidmodalcust_gb').val()) {
                case "01": // 제출처
                    $('#hidbuyer_cust_id').val(row.CUST_ID);
                    $('#hidbuyer_cust_addr_kr').val(row.CUST_ADDR_KR);
                    $('#txtbuyer_cust_nm').val(row.CUST_NM);
                    $('#txtbuyer_cust_busi_no').text(row.BUSINESS_NO);
                    $('#txtbuyer_cust_status_nm').text(row.STATUS_CD_NM);
                    break;
                case "02": // 의뢰업체
                    $('#hidvendor_cust_id').val(row.CUST_ID);
                    $('#hidvendor_cust_addr_kr').val(row.CUST_ADDR_KR);
                    $('#txtvendor_cust_nm').val(row.CUST_NM);
                    $('#txtvendor_cust_busi_no').text(row.BUSINESS_NO);
                    $('#txtvendor_cust_status_nm').text(row.STATUS_CD_NM);

                    $('#hidbuyer_cust_id').val(row.CUST_ID);
                    $('#hidbuyer_cust_addr_kr').val(row.CUST_ADDR_KR);
                    $('#txtbuyer_cust_nm').val(row.CUST_NM);
                    $('#txtbuyer_cust_busi_no').text(row.BUSINESS_NO);
                    $('#txtbuyer_cust_status_nm').text(row.STATUS_CD_NM);
                    break;
                default:
                    break;

            }
            
            $('#modalCustomer').modal('hide');
        }

        //======================================================
        // Note - 초반 컨트롤 셋팅.
        //======================================================
        function GetModalCustomerList(cust_gb) {
            $('#hidmodalcust_gb').val(cust_gb);
            var Gparam = {
                IV_CUST_GB : cust_gb,
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetModalCustomerList",
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
        // Note - 유저 가져오기.
        //======================================================
        function GetModalUserList() {
            var Gparam = {
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetModalUserList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    fn_ClearGrid(grd_Modal_User_List);

                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        // Note - Customer Information
                        grd_Modal_User_List.dataView.beginUpdate();
                        grd_Modal_User_List.dataView.setItems(jsonData.result);
                        grd_Modal_User_List.dataView.setFilter(filter_Modal_User);
                        grd_Modal_User_List.dataView.endUpdate();
                        grd_Modal_User_List.grid.render();
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
        // Note - 마스터 디테일.
        //======================================================
        function GetRegisterDetail(row) {
            $('#btnStepOne').removeClass('hidden');
            $('#btnStepTwo').removeClass('hidden');

            if (row.REGISTER_GB == '01') // 가접수
            {
                // 버튼 설정
                $('#btnSave').addClass('hidden');
                $('#btnSaveAndMail').addClass('hidden');
                $('#btnEmail').addClass('hidden');
                $('#ulTabs_Step li:eq(0) a').tab('show');
                $('#ulTabs_Step li:eq(0) a').removeClass('disabled');
                $('#ulTabs_Step li:eq(1) a').addClass('disabled');
                $('#ulTabs_Step li:eq(2) a').addClass('disabled');
            }
            else if (row.REGISTER_GB == '02' || row.REGISTER_GB == '03') // 접수중 1차
            {
                // 버튼 설정
                $('#btnSave').addClass('hidden');
                $('#btnSaveAndMail').addClass('hidden');
                $('#btnEmail').addClass('hidden');
                $('#ulTabs_Step li:eq(1) a').tab('show');
                $('#ulTabs_Step li:eq(0) a').removeClass('disabled');
                $('#ulTabs_Step li:eq(1) a').removeClass('disabled');
                $('#ulTabs_Step li:eq(2) a').addClass('disabled');
            }
            else {
                // 버튼 설정
                $('#btnSave').removeClass('hidden');
                $('#btnSaveAndMail').removeClass('hidden');
                $('#btnEmail').removeClass('hidden');
                
                $('#ulTabs_Step li:eq(2) a').tab('show');
                $('#ulTabs_Step li:eq(0) a').removeClass('disabled');
                $('#ulTabs_Step li:eq(1) a').removeClass('disabled');
                $('#ulTabs_Step li:eq(2) a').removeClass('disabled');

                if (row.STATUS_CD == '03') {
                    $('#btnSave').addClass('hidden');
                    $('#btnSaveAndMail').addClass('hidden');
                    $('#btnStepOne').addClass('hidden');
                    $('#btnStepTwo').addClass('hidden');

                }
            }
            //  마스터 정보 설정.
            $('#hidreq_num').val(row.REQ_NUM);
            $('#hidreq_code').val(row.REQ_CODE);
            $('#txtreq_key').val(row.REQ_CODE == '' ? row.REQ_NUM : row.REQ_CODE);
            $('#ddlstatus_cd').val(row.STATUS_CD == '01' ? '02' : row.STATUS_CD);

            // 업체 설정
            $('#hidintertek_user_id').val(row.INTERTEK_USER_ID);
            $('#txtintertek_user_nm').val(row.INTERTEK_USER_ID_NM);
            $('#txtintertek_user_dept').text(row.INTERTEK_DEPT_CD_NM);
            $('#txtintertek_cust_remark').val(row.INTERTEK_REMARK);

            // 접수및 등록
            $('#txtreg_user_nm').val(row.REGISTER_USER_ID_NM);
            $('#txtreg_dt').val(row.REGISTER_DT_NM);
            $('#rdoreg_dt_am').iCheck(row.REGISTER_AMPM == 'AM' ? 'check' : 'uncheck');
            $('#rdoreg_dt_pm').iCheck(row.REGISTER_AMPM == 'PM' ? 'check' : 'uncheck');
            $('#ddlreg_service_type').val(row.SERVICE_TYPE);
            $('#txtreg_report_dt').val(row.REPORT_DUE_DT_NM);
            $('#rdoreg_report_dt_am').iCheck(row.REPORT_AMPM == 'AM' ? 'check' : 'uncheck');
            $('#rdoreg_report_dt_pm').iCheck(row.REPORT_AMPM == 'PM' ? 'check' : 'uncheck');

            $('#ddlextra_type').val(row.EXTRA_TYPE);
            $('#ddlextra_rate').val(row.EXTRA_RATE);

            $('#ddlreg_re_test_yn').val(row.RE_TEST_YN);
            $('#txtreg_sample_arrive_dt').val(row.SAMPLE_ARRIVE_DT_NM);
            $('#txtreg_customer_req_remark').val(row.CUSTOMER_REQ_REMARK);

            var Gparam = {
                IV_REQ_NUM: row.REQ_NUM
            };
            $.ajax({
                url: ServiceUrl + "GetRegisterDetail",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ "Gparam": Gparam }),
                dataType: "json",
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        if (jsonData.FILE_LIST.length > 0) {
                            $('#txtreg_file_nm').val(jsonData.FILE_LIST[0].FILE_NM);
                            $('#hidreg_file_url').val(jsonData.FILE_LIST[0].FILE_URL);
                        }
                        if (jsonData.CUSTOMER_LIST.length > 0) {
                            $('#hidbuyer_cust_id').val(jsonData.CUSTOMER_LIST[0].CUST_ID);
                            $('#hidbuyer_cust_addr_kr').val(jsonData.CUSTOMER_LIST[0].ADDR_KR);
                            $('#hidbuyer_cust_addr_en').val(jsonData.CUSTOMER_LIST[0].ADDR_EN);
                            $('#txtbuyer_cust_nm').val(jsonData.CUSTOMER_LIST[0].CUST_NM);
                            $('#txtbuyer_cust_busi_no').text(jsonData.CUSTOMER_LIST[0].BUSINESS_NO);
                            $('#txtbuyer_cust_status_nm').text(jsonData.CUSTOMER_LIST[0].STATUS_CD_NM);
                            $('#rdobuyer_cust_bill_yn').iCheck(jsonData.CUSTOMER_LIST[0].BILLING_YN == 'Y' ? 'check' : 'uncheck');
                            $('#txtbuyer_cust_remark').val(jsonData.CUSTOMER_LIST[0].REMARK);

                            $('#hidvendor_cust_id').val(jsonData.CUSTOMER_LIST[1].CUST_ID);
                            $('#hidvendor_cust_addr_kr').val(jsonData.CUSTOMER_LIST[1].ADDR_KR);
                            $('#hidvendor_cust_addr_en').val(jsonData.CUSTOMER_LIST[1].ADDR_EN);
                            $('#txtvendor_cust_nm').val(jsonData.CUSTOMER_LIST[1].CUST_NM);
                            $('#txtvendor_cust_busi_no').text(jsonData.CUSTOMER_LIST[1].BUSINESS_NO);
                            $('#txtvendor_cust_status_nm').text(jsonData.CUSTOMER_LIST[1].STATUS_CD_NM);
                            $('#rdovendor_cust_bill_yn').iCheck(jsonData.CUSTOMER_LIST[1].BILLING_YN == 'Y' ? 'check' : 'uncheck');
                            $('#txtvendor_cust_remark').val(jsonData.CUSTOMER_LIST[1].REMARK);
                        }
                        fn_ClearGrid(grd_Contact_List);
                        if (jsonData.CONTACT_LIST.length > 0) {
                            grd_Contact_List.dataView.beginUpdate();
                            grd_Contact_List.dataView.setItems(jsonData.CONTACT_LIST);
                            grd_Contact_List.dataView.endUpdate();
                            grd_Contact_List.grid.render();
                        }
                        fn_ClearGrid(grd_Sample_List);
                        if (jsonData.SAMPLE_LIST.length > 0) {
                            for (var i = 0; i < jsonData.SAMPLE_LIST.length; i++) {
                                jsonData.SAMPLE_LIST[i].FILE_LIST = [];

                                var sample_id = jsonData.SAMPLE_LIST[i].SAMPLE_ID;
                                for (var j = 0; j < jsonData.SAMPLE_FILE_LIST.length; j++) {
                                    var sample_id_file = jsonData.SAMPLE_FILE_LIST[j].SAMPLE_ID;
                                    if(sample_id == sample_id_file)
                                    {
                                        jsonData.SAMPLE_LIST[i].FILE_LIST.push(jsonData.SAMPLE_FILE_LIST[j]);
                                    }
                                }
                            }
                            grd_Sample_List.dataView.beginUpdate();
                            grd_Sample_List.dataView.setItems(jsonData.SAMPLE_LIST);
                            grd_Sample_List.dataView.endUpdate();
                            grd_Sample_List.grid.render();
                        }
                        fn_ClearGrid(grd_Sample_Amt_List);
                        if (jsonData.SAMPLE_LIST.length > 0) {
                            grd_Sample_Amt_List.dataView.beginUpdate();
                            grd_Sample_Amt_List.dataView.setItems(jsonData.SAMPLE_LIST);
                            grd_Sample_Amt_List.dataView.endUpdate();
                            grd_Sample_Amt_List.grid.render();
                        }

                        // 그리드 먼저 만들기.
                        SetTestPackageGrid();

                        // 조합 하여 그리기.
                        fn_ClearGrid(grd_Test_Package_List);
                        var sampleTestDt = jsonData.TEST_LIST;

                        for (var i = 0; i < jsonData.SAMPLE_LIST.length; i++) {
                            var _field = "TEST_" + jsonData.SAMPLE_LIST[i].SAMPLE_SHORT_NM.replaceAll('(', '').replaceAll(')', '');
                            var _sample_id = jsonData.SAMPLE_LIST[i].SAMPLE_ID;
                            
                            for (var j = 0; j < jsonData.TEST_LIST.length; j++) {
                                var _test_seq = jsonData.TEST_LIST[j].TEST_SEQ;

                                for (var k = 0; k < jsonData.SMAPLE_TEST_LIST.length; k++) {
                                    if (jsonData.SMAPLE_TEST_LIST[k].SAMPLE_ID == _sample_id && jsonData.SMAPLE_TEST_LIST[k].TEST_SEQ == _test_seq) {
                                        sampleTestDt[j][_field] =  jsonData.TEST_LIST[j].KOR_AMT == '' ? 'N' : 'Y';
                                    }
                                }
                            }
                        }

                        grd_Test_Package_List.dataView.beginUpdate();
                        grd_Test_Package_List.dataView.setItems(sampleTestDt);
                        grd_Test_Package_List.dataView.endUpdate();
                        grd_Test_Package_List.grid.render();

                        // Step 3 화면 데이터 바인뎅
                        SetStepCompleteData();
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
        function GetRegisterList() {
            var Gparam = {
                IV_START_DT: $('#txtstart_dt_s').val().replaceAll('-', ''),
                IV_END_DT: $('#txtend_dt_s').val().replaceAll('-', ''),
                IV_MASTER_STATUS_CD: $('#ddlmasterstatus_cd_s').val(),
                IV_USER_ID: '<%= CkUserId %>'
            };
            $.ajax({
                url: ServiceUrl + "GetRegisterList",
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

        // File 클릭시 볼 수 있도록.
        function GetFileViewer(obj) {
            var clickName = obj.id;
            var linkUrl = '';

            if (clickName != '') {
                switch (clickName) {
                    case "txtreg_file_nm":
                        linkUrl = $('#hidreg_file_url').val();
                        break;
                    default:
                        break;
                }
                if (linkUrl != '') window.open(linkUrl, "_blank");
            }
        }

        //======================================================
        // Note - 업로드 후
        //======================================================
        function fileUploadBinding(Gparam) {
            $('#hidreg_file_url').val(Gparam.file_url);
            $('#txtreg_file_nm').val(Gparam.file_nm);
        }
        //======================================================
        // Note - 업로드 후 Sample
        //======================================================
        function fileUploadBinding_Sample(jsonData) {
            if (jsonData != null) {
                for (var i = 0; i < jsonData.result.length; i++) {
                    jsonData.result[i].FILE_CNT = '0';
                    jsonData.result[i].FILE_TYPE = '01';
                    grd_Sample_File_List.dataView.addItem(jsonData.result[i]);
                }
            }

            //if (jsonData != null) {
            //    for (var i = 0; i < jsonData.result.length; i++) {
                    
            //    }
            //    grd_Sample_File_List.dataView.beginUpdate();
            //    grd_Sample_File_List.dataView.setItems(jsonData.result);
            //    grd_Sample_File_List.dataView.endUpdate();
            //    grd_Sample_File_List.grid.render();
            //}
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
                    <button type="button" class="btn btn-default btn-sm" id="btnAdd">
                        <span class="glyphicon glyphicon-plus"></span>&nbsp;신규
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
                        <span class="glyphicon glyphicon-plus"></span>&nbsp;신규
                    </button>
                    <button type="button" class="btn btn-warning btn-sm" data-toggle="confirmation" data-popout="true" id="btnEmail">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;메일발송
                    </button>
                    <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnSave">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;접수완료
                    </button>
                    <%--<button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnSaveAndMail">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;접수완료 & 메일전송
                    </button>--%>
                </div>
                <div class="panel-body form-horizontal">
                    
                    <div class="col-xs-12 layout_dtl_page">
                        <div class="clearfix"></div>
                        <!-- design process steps-->
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs process-model more-icon-preocess " role="tablist" id="ulTabs_Step" >
                            <li role="presentation" class="active"><a class="a_tab" href="#step_customer" aria-controls="step_customer" role="tab" data-toggle="tab"><i class="fa fa-building-o" aria-hidden="true"></i>
                                <p>업체 설정</p>
                            </a></li>
                            <li role="presentation"><a class="a_tab" href="#step_test" aria-controls="step_test" role="tab" data-toggle="tab"><i class="fa fa-file-text-o" aria-hidden="true"></i>
                                <p>시험 설정</p>
                            </a></li>
                            <li role="presentation"><a class="a_tab" href="#step_complete" aria-controls="step_complete" role="tab" data-toggle="tab"><i class="fa fa-qrcode" aria-hidden="true"></i>
                                <p>접수 완료</p>
                            </a></li>
                        </ul>
                        
                        <!-- end design process steps-->
                        <!-- Tab panes -->
                        <div class="tab-content" style="background-color: #fafafa;">
                            <fieldset class="scheduler-border">
                                <legend class="scheduler-border">접수 관리</legend>
                                <div class="form-group col-md-3 col-xs-12">
                                    <label for="txtreq_key" class="control-label ">■ 접수 번호</label>
                                    <input type="hidden" id="hidreq_num" />
                                    <input type="hidden" id="hidreq_code" />
                                    <input type="text" class="form-control input-sm" id="txtreq_key" name="txtreq_key" readonly="readonly" />
                                </div>
                                <div class="form-group col-md-3 col-xs-12">
                                    <label for="ddlstatus_cd" class="control-label ">■ 접수 상태</label>
                                    <asp:DropDownList ID="ddlstatus_cd" runat="server" name="ddlstatus_cd" CssClass="form-control input-sm" ClientIDMode="Static"   disabled="disabled">
                                    </asp:DropDownList>
                                </div>
                            </fieldset>

                            <%--신청자 및 접수정보--%>
                            <div role="tabpanel" class="tab-pane active" id="step_customer">

                                <%--업체 정보--%>
                                <fieldset class="scheduler-border">
                                    <legend class="scheduler-border">업체 정보</legend>
                                    <div class="table-responsive">
                                        <table class="GDH_table" style="width: 1227px; border-top:2px solid #555; ">
                                        <colgroup>
                                            <col width="70px" />
                                            <col width="200px" />
                                            <col width="100px" />
                                            <col width="80px" />
                                            <col width="80px" />
                                            <col width="80px" />
                                            <col width="200px" />
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>구분</th>
                                                <th>신청회사</th>
                                                <th>사업자 등록번호</th>
                                                <th>상태</th>
                                                <th>청구지</th>
                                                <th>주소</th>
                                                <th>비고</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="th_title">
                                                    <span>의뢰업체</span>
                                                </td>
                                                <td>
                                                    <div class="input-group mgn0">
                                                        <input type="hidden" id="hidvendor_cust_id" />
                                                        <input type="hidden" id="hidvendor_cust_addr_kr" />
                                                        <input type="hidden" id="hidvendor_cust_addr_en" />
                                                        <input type="text" class="form-control input-sm" id="txtvendor_cust_nm" name="txtvendor_cust_nm" readonly="readonly" />
                                                        <div class="input-group-btn">
                                                            <button type="button" class="btn btn-default input-sm" id="btnvendor_cust_popup" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                                                <span class="glyphicon glyphicon-search"></span>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span id="txtvendor_cust_busi_no"></span>
                                                </td>
                                                <td>
                                                    <span id="txtvendor_cust_status_nm"></span>
                                                </td>
                                                <td>
                                                    <input type="radio" class="flat" id="rdovendor_cust_bill_yn" name="rdoBilling" />
                                                </td>
                                                <td>
                                                    <button type="button" id="btnvendor_cust_addrview" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                                        보기
                                                    </button>
                                                </td>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtvendor_cust_remark" name="txtvendor_cust_remark" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="th_title">
                                                    <span>제출처</span>
                                                </td>
                                                <td>
                                                    <div class="input-group mgn0">
                                                        <input type="hidden" id="hidbuyer_cust_id" />
                                                        <input type="hidden" id="hidbuyer_cust_addr_kr" />
                                                        <input type="hidden" id="hidbuyer_cust_addr_en" />
                                                        <input type="text" class="form-control input-sm" id="txtbuyer_cust_nm" name="txtbuyer_cust_nm" readonly="readonly" />
                                                        <div class="input-group-btn">
                                                            <button type="button" class="btn btn-default input-sm" id="btnbuyer_cust_popup" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                                                <span class="glyphicon glyphicon-search"></span>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span id="txtbuyer_cust_busi_no"></span>
                                                </td>
                                                <td>
                                                    <span id="txtbuyer_cust_status_nm"></span>
                                                </td>
                                                <td>
                                                    <input type="radio" class="flat" id="rdobuyer_cust_bill_yn" name="rdoBilling" />
                                                </td>
                                                <td>
                                                    <button type="button" id="btnbuyer_cust_addrview" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                                        보기
                                                    </button>
                                                </td>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtbuyer_cust_remark" name="txtbuyer_cust_remark" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="th_title">
                                                    <span>등록인</span>
                                                </td>
                                                <td>
                                                    <div class="input-group mgn0">
                                                        <input type="hidden" id="hidintertek_user_id" />
                                                        <input type="text" class="form-control input-sm" id="txtintertek_user_nm" name="txtintertek_user_nm" readonly="readonly" />
                                                        <div class="input-group-btn">
                                                            <button type="button" class="btn btn-default input-sm" id="btnintertek_cust_popup" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                                                <span class="glyphicon glyphicon-search"></span>
                                                            </button>
                                                            <button type="button" class="btn btn-default input-sm" id="" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                                                <span class="glyphicon glyphicon-remove"></span>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td colspan="4" style="text-align:left;">
                                                    <span id="txtintertek_user_dept"></span>
                                                </td>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtintertek_cust_remark" name="txtintertek_cust_remark" />
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    </div>
                                </fieldset>
                                <%--담당자 정보--%>
                                <fieldset class="scheduler-border">
                                    <legend class="scheduler-border">담당자 정보</legend>
                                    <div class="text-right mgn_B5 mgn_T10">
                                        <button type="button" class="btn btn-default btn-sm" id="btncontact_add" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-plus"></span>
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" id="btncontact_delete" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-trash"></span>
                                        </button>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="GDH_table" style="width: 1227px; border-bottom: none; border-top:2px solid #555;">
                                            <colgroup>
                                                <col width="26px" />
                                                <col width="100px" />
                                                <col width="100px" />
                                                <col width="100px" />
                                                <col width="100px" />
                                                <col width="100px" />
                                                <col width="100px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th rowspan="2">-</th>
                                                    <th rowspan="2">고객명</th>
                                                    <th rowspan="2">고객구분</th>
                                                    <th rowspan="2">담당자명</th>
                                                    <th rowspan="2">담당자명(EN)</th>
                                                    <th rowspan="2">연락처</th>
                                                    <th rowspan="2">E-Mail</th>
                                                    <th colspan="3">접수증</th>
                                                    <th colspan="3">성적서</th>
                                                    <th colspan="3">인보이스</th>
                                                </tr>
                                                <tr>
                                                    <th>To</th>
                                                    <th>Cc</th>
                                                    <th>Bcc</th>
                                                    <th>To</th>
                                                    <th>Cc</th>
                                                    <th>Bcc</th>
                                                    <th>To</th>
                                                    <th>Cc</th>
                                                    <th>Bcc</th>
                                                </tr>
                                            </thead>
                                        </table>
                                        <div style="border: 1px solid #ddd; width: 1227px; border-top: none;">
                                        <style>
                                            #grd_Contact_List .slick-header-columns {
                                                display: none;
                                            }

                                            #grd_Contact_List .slick-viewport {
                                                overflow: hidden !important;
                                            }
                                        </style>
                                        <div id="grd_Contact_List" style="height: 200px;"></div>
                                    </div>
                                    </div>
                                </fieldset>
                                <%--접수 및 등록--%>
                                <fieldset class="scheduler-border">
                                    <legend class="scheduler-border">접수 및 등록</legend>
                                    <div class="table-responsive">
                                        <table class="GDH_table" style="width: 1227px; border-top:2px solid #555;">
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
                                                    <span>접수자</span>
                                                </th>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtreg_user_nm" name="txtreg_user_nm" disabled="disabled"  />
                                                </td>
                                                <th class="th_title">
                                                    <span>접수일</span>
                                                </th>
                                                <td style="border-right:none;">
                                                    <input type="text" class="form-control input-sm" id="txtreg_dt" name="txtreg_dt" readonly="readonly" />
                                                </td>
                                                <td style="border-left:none" colspan="2">
                                                    <table border="0">
                                                        <tr>
                                                            <td style="border:none; padding:0; margin:0;">
                                                                <div class="radio" style="padding-top:2px;">
                                                                    <label style="padding:0;">
                                                                        <input type="radio" class="flat" id="rdoreg_dt_am" name="rdoregtimetype" />
                                                                        AM
                                                                    </label>
                                                                </div>
                                                            </td>
                                                            <td style="border:none; padding:0; margin:0;">
                                                                <div class="radio" style="padding-top:2px;">
                                                                    <label>
                                                                        <input type="radio" class="flat" id="rdoreg_dt_pm" name="rdoregtimetype" />
                                                                        PM
                                                                    </label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="th_title">
                                                    <span>접수유형</span>
                                                </th>
                                                <td>
                                                    <asp:DropDownList ID="ddlreg_service_type" runat="server" name="ddlreg_service_type" CssClass="form-control input-sm" ClientIDMode="Static">
                                                    </asp:DropDownList>
                                                </td>
                                                <th class="th_title">
                                                    <span>성적서발행예정일</span>
                                                </th>
                                                <td style="border-right:none;">
                                                    <input type="text" class="form-control input-sm" id="txtreg_report_dt" name="" readonly="readonly"  />
                                                </td>
                                                 <td style="border-left:none" colspan="2">
                                                    <table border="0">
                                                        <tr>
                                                            <td style="border:none; padding:0; margin:0;">
                                                                <div class="radio" style="padding-top:2px;">
                                                                    <label style="padding:0;">
                                                                        <input type="radio" class="flat" id="rdoreg_report_dt_am" name="rdoregtimetype2" />
                                                                        AM
                                                                    </label>
                                                                </div>
                                                            </td>
                                                            <td style="border:none; padding:0; margin:0;">
                                                                <div class="radio" style="padding-top:2px;">
                                                                    <label>
                                                                        <input type="radio" class="flat" id="rdoreg_report_dt_pm" name="rdoregtimetype2" />
                                                                        PM
                                                                    </label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="th_title">
                                                    <span>추가비용</span>
                                                </th>
                                                <td>
                                                    <table style="border:none; width:100%;">
                                                        <tr>
                                                            <td style="border:none; padding:0px; margin:0px;">
                                                                <asp:DropDownList ID="ddlextra_type" runat="server" name="ddlextra_type" CssClass="form-control input-sm" ClientIDMode="Static">
                                                                </asp:DropDownList></td>
                                                            <td style="width:2px; border:none; padding:0px; margin:0px;"></td>
                                                            <td style="border:none; padding:0px; margin:0px;">
                                                                <asp:DropDownList ID="ddlextra_rate" runat="server" name="ddlextra_rate" CssClass="form-control input-sm" ClientIDMode="Static">
                                                                    <asp:ListItem Value="1" Text="X 1" />
                                                                    <asp:ListItem Value="1.5" Text="X 1.5" />
                                                                    <asp:ListItem Value="2" Text="X 2" />
                                                                    <asp:ListItem Value="2.5" Text="X 2.5" />
                                                                    <asp:ListItem Value="3" Text="X 3" />
                                                                </asp:DropDownList></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <th class="th_title">
                                                    <span>재시험</span>
                                                </th>
                                                <td>
                                                    <asp:DropDownList ID="ddlreg_re_test_yn" runat="server" name="ddlreg_re_test_yn" CssClass="form-control input-sm" ClientIDMode="Static">
                                                        <asp:ListItem Text="N" Value="N" />
                                                        <asp:ListItem Text="Y" Value="Y" />
                                                    </asp:DropDownList>
                                                </td>
                                                <th class="th_title">
                                                    <span>시료도착일</span>
                                                </th>
                                                <td>
                                                    <input type="text" class="form-control input-sm" id="txtreg_sample_arrive_dt" name="txtreg_sample_arrive_dt" readonly="readonly"  />
                                                </td>
                                                
                                            </tr>
                                            <tr>
                                                <th class="th_title">
                                                    <span>성적서용도</span>
                                                </th>
                                                <td>
                                                    <asp:DropDownList ID="ddlreport_use_cd" runat="server" name="ddlreport_use_cd" CssClass="form-control input-sm" ClientIDMode="Static">
                                                    </asp:DropDownList>
                                                </td>
                                                <th class="th_title">
                                                    <span>성적서발송</span>
                                                </th>
                                                <td>
                                                    <asp:DropDownList ID="ddlreport_send_cd" runat="server" name="ddlreport_send_cd" CssClass="form-control input-sm" ClientIDMode="Static">
                                                    </asp:DropDownList>
                                                </td>
                                                <th class="th_title">
                                                    <span>해당견적서 NO</span>
                                                </th>
                                                <td>
                                                    <div class="col-xs-12 pdd0">
                                                        <div class="input-group mgn0">
                                                            <input type="hidden" class="form-control input-sm" id="hidreg_file_url" name="hidreg_file_url" />
                                                            <input type="text" class="form-control input-sm" id="txtreg_file_nm" name="txtreg_file_nm" readonly="readonly" onclick="GetFileViewer(this);" />
                                                            <div class="input-group-btn">
                                                                <button type="button" class="btn btn-default input-sm" id="btnreg_file_popup" style="min-height: 1px; min-width: 1px; line-height: normal;" >
                                                                    <span class="glyphicon glyphicon-search"></span>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="th_title">
                                                    <span>고객요청사항</span>
                                                </th>
                                                <td colspan="5">
                                                    <input type="text" class="form-control input-sm" id="txtreg_customer_req_remark" name="txtreg_customer_req_remark"  />
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    </div>
                                </fieldset>

                                <div class="col-xs-12" style="padding-top:30px; padding-bottom:20px; background-color: #eee;">
                                    <div class="form-group col-xs-12" style="text-align: right;">
                                        <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnStepOne">
                                            저장 ▶
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <%--신청자 및 접수정보--%>

                            <%--시료 및 시험항목--%>
                            <div role="tabpanel" class="tab-pane" id="step_test">
                                <%--시료 정보--%>
                                <fieldset class="scheduler-border">
                                    <legend class="scheduler-border">시료 정보</legend>
                                    <div class="text-right mgn_B5 mgn_T10">
                                        <button type="button" class="btn btn-info btn-sm hidden" id="btnsample_excel" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-save"></span>
                                        </button>
                                        <button type="button" class="btn btn-default btn-sm" id="btnsample_add" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-plus"></span>
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" id="btnsample_delete" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-trash"></span>
                                        </button>
                                    </div>
                                    <div id="grd_Sample_List" style="height: 200px; border:1px solid #ddd; border-top:2px solid #555;" class=""></div>
                                    <div id="grid_Sample_List_Excel"></div>
                                </fieldset>
                                <%--시험 및 항목 셋팅--%>
                                <fieldset class="scheduler-border table-responsive">
                                    <legend class="scheduler-border">시험 정보</legend>
                                    <div class="form-group col-md-3 col-xs-12">
                                        <label for="ddltestcurreny_cd" class="control-label">■ 통화 기준</label>
                                        <asp:DropDownList ID="ddltestcurreny_cd" runat="server" name="ddltestcurreny_cd" CssClass="form-control input-sm" ClientIDMode="Static">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="form-group col-md-3 col-xs-12 hidden">
                                        <div class="col-xs-12">
                                            <div class="checkbox" style="margin-bottom:3px;">
                                                <label>
                                                    <input type="checkbox" class="flat" id="chkexchange_rate" name="chkexchange_rate" />
                                                    <b>환율(USD)</b> : <span style="font-size:11px;">체크 시 적용</span>
                                                </label>
                                            </div>
                                            <input type="text" class="form-control input-sm" id="txtexchange_rate" name="txtexchange_rate" readonly="readonly" style="text-align: right; font-weight: bold; font-size: 1.2em;" />
                                        </div>
                                    </div>
                                    <div class="form-group col-md-3 col-xs-12">
                                        <label for="txttestpackage_include_rate" class="control-label">■ 할인</label>
                                        <div class="input-group ">
                                            <input type="text" class="form-control input-sm" id="txttestpackage_include_rate" name="txtsample_file_nm" style="text-align: right;" />
                                            <div class="input-group-btn">
                                                <button type="button" class="btn btn-default input-sm" id="btntestpackage_include_rate" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                                    (%) 일괄적용
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-3 col-xs-12">
                                        <label for="txttestpackage_include_rate" class="control-label">■ 팀</label>
                                        <div class="input-group ">
                                            <asp:DropDownList ID="ddltest_team" runat="server" name="ddltest_team" CssClass="form-control input-sm" ClientIDMode="Static">
                                            </asp:DropDownList>
                                            <div class="input-group-btn">
                                                <button type="button" class="btn btn-default input-sm" id="btntest_team_save" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                                    (팀) 일괄적용
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="clearfix"></div>
                                    <div class="text-right mgn_B5 mgn_T10">
                                        <button type="button" class="btn btn-default btn-sm" id="btnpackage_test_add" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-plus"></span>
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" id="btnpackage_test_delete" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-trash"></span>
                                        </button>
                                    </div>
                                    <div id="grd_Test_Package_List" style="height: 300px; border:1px solid #ddd; border-top: 2px solid #555;" class=""></div>
                                </fieldset>
                                 <%--시료별 금액설정--%>
                                <fieldset class="scheduler-border table-responsive">
                                    <legend class="scheduler-border">금액 설정</legend>
                                    <div class="form-group col-md-3 col-xs-12 hidden">
                                        <label for="ddltestcurreny_cd" class="control-label">■ 통화 기준 : <span class="ddltestcurreny_cd_com"></span></label><br />
                                        <label for="ddltestcurreny_cd" class="control-label">■ 환율 적용 : <span class="chkexchange_rate_com"></span></label><br />
                                        <label for="ddltestcurreny_cd" class="control-label">■ 환율(USD) : <span class="txtexchange_rate_com"></span> 원</label>
                                    </div>
                                    <div class="clearfix"></div>
                                    <div class="text-right mgn_B5 mgn_T10">
                                        <button type="button" class="btn btn-default btn-sm" id="btnsample_amt_refresh" style="min-width: 1px;">
                                            <span class="glyphicon glyphicon-refresh"></span>
                                        </button>
                                    </div>
                                    <div id="grd_Sample_Amt_List" style="height: 200px; border:1px solid #ddd; border-top:2px solid #555;" class=""></div>
                                </fieldset>

                                <div class="col-xs-12" style="padding-top:30px; padding-bottom:20px; background-color: #eee;">
                                    <div class="form-group col-xs-12" style="text-align: right;">
                                        <button type="button" class="btn btn-success btn-sm" data-toggle="confirmation" data-popout="true" id="btnStepTwo">
                                            저장 ▶
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <%--시료 및 시험항목--%>

                            <%--접수완료--%>
                            <div role="tabpanel" class="tab-pane" id="step_complete">
                                <%--접수 및 등록--%>
                                <fieldset class="scheduler-border">
                                    <legend class="scheduler-border">접수 내역</legend>
                                    <div class="table-responsive">
                                        <style>
                                            #tbl_reg_com td {
                                                text-align:left;
                                            }
                                        </style>
                                        <table id="tbl_reg_com" class="GDH_table" style="width: 1227px; border-top: 2px solid #555;">
                                            <colgroup>
                                                <col width="150px" />
                                                <col width="463px" />
                                                <col width="150px" />
                                                <col width="*" />
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <th class="th_title">
                                                        <span>접수자</span>
                                                    </th>
                                                    <td>
                                                        <span id="txtreg_user_nm_com"></span>
                                                    </td>
                                                    <th class="th_title">
                                                        <span>접수일</span>
                                                    </th>
                                                    <td>
                                                        <span id="txtreg_dt_com"></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th class="th_title">
                                                        <span>접수유형</span>
                                                    </th>
                                                    <td>
                                                        <span id="ddlreg_service_type_com"></span>
                                                    </td>
                                                    <th class="th_title">
                                                        <span>성적서발행예정일</span>
                                                    </th>
                                                    <td>
                                                        <span id="txtreg_report_dt_com"></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th class="th_title">
                                                        <span>재시험</span>
                                                    </th>
                                                    <td>
                                                        <span id="ddlreg_re_test_yn_com"></span>
                                                    </td>
                                                    <th class="th_title">
                                                        <span>시료도착일</span>
                                                    </th>
                                                    <td>
                                                        <span id="txtreg_sample_arrive_dt_com"></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th class="th_title">
                                                        <span>해당견적서 NO</span>
                                                    </th>
                                                    <td colspan="3">
                                                        <a id="txtreg_file_nm_com" href="#"></a>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </fieldset>
    
                                <%--업체 정보--%>
                                <fieldset class="scheduler-border">
                                    <legend class="scheduler-border">업체 정보</legend>
                                    <div class="table-responsive">
                                        <style>
                                            #tbl_customer_com td {
                                                text-align:left;
                                            }
                                        </style>
                                        <table id="tbl_customer_com" class="GDH_table table-bordered" style="width: 1227px; border-top: 2px solid #555;">
                                            <colgroup>
                                               <col width="100px" />
                                                <col width="350px" />
                                                <col width="150px" />
                                                <col width="150px" />
                                                <col width="150px" />
                                                <col width="*" />
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th>
                                                        <span>구분</span>
                                                    </th>
                                                    <th>
                                                        <span>신청회사</span>
                                                    </th>
                                                    <th>
                                                        <span>사업자 등록번호</span>
                                                    </th>
                                                    <th>
                                                        <span>상태</span>
                                                    </th>
                                                    <th>
                                                        <span>청구지</span>
                                                    </th>
                                                    <th>
                                                        <span>비고</span>
                                                    </th>
                                                </tr>
                                                
                                            </thead>
                                            <tbody style="">
                                                <tr>
                                                    <th class="th_title">의뢰업체</th>
                                                    <td><span id="txtvendor_cust_nm_com"></span></td>
                                                    <td><span id="txtvendor_cust_busi_no_com"></span></td>
                                                    <td><span id="txtvendor_cust_status_nm_com"></span></td>
                                                    <td style="text-align:center;"><span id="rdovendor_cust_bill_yn_com"></span></td>
                                                    <td><span id="txtvendor_cust_remark_com"></span></td>
                                                </tr>
                                                <tr>
                                                    <th class="th_title">제출처</th>
                                                    <td><span id="txtbuyer_cust_nm_com"></span></td>
                                                    <td><span id="txtbuyer_cust_busi_no_com"></span></td>
                                                    <td><span id="txtbuyer_cust_status_nm_com"></span></td>
                                                    <td style="text-align:center;"><span id="rdobuyer_cust_bill_yn_com"></span></td>
                                                    <td><span id="txtbuyer_cust_remark_com"></span></td>
                                                </tr>
                                                <tr>
                                                    <th class="th_title">인터텍</th>
                                                    <td><span id="txtintertek_user_nm_com"></span></td>
                                                    <td colspan="3"><span id="txtintertek_user_dept_com"></span></td>
                                                    <td><span id="txtintertek_cust_remark_com"></span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </fieldset>

                                <%--담당자 정보--%>
                                <fieldset class="scheduler-border">
                                    <legend class="scheduler-border">담당자 정보</legend>
                                    <div class="table-responsive">
                                        <table class="GDH_table" id="tbl_contact_com" style="width: 1227px; border-bottom: none; border-top: 2px solid #555;">
                                            <colgroup>
                                                <col width="150px" />
                                                <col width="100px" />
                                                <col width="100px" />
                                                <col width="100px" />
                                                <col width="150px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                                <col width="50px" />
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th rowspan="2">고객명</th>
                                                    <th rowspan="2">고객구분</th>
                                                    <th rowspan="2">담당자명</th>
                                                    <th rowspan="2">담당자명(EN)</th>
                                                    <th rowspan="2">E-Mail</th>
                                                    <th colspan="3">접수증</th>
                                                    <th colspan="3">성적서</th>
                                                    <th colspan="3">인보이스</th>
                                                </tr>
                                                <tr>
                                                    <th>To</th>
                                                    <th>Cc</th>
                                                    <th>Bcc</th>
                                                    <th>To</th>
                                                    <th>Cc</th>
                                                    <th>Bcc</th>
                                                    <th>To</th>
                                                    <th>Cc</th>
                                                    <th>Bcc</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                            </tbody>
                                        </table>
                                    </div>
                                </fieldset>

                                <%--접수 및 등록--%>
                                <fieldset class="scheduler-border">
                                    <legend class="scheduler-border">시료 및 테스트 정보</legend>
                                    <div class="table-responsive">
                                        <style>
                                            #tblcomplete_sample td {
                                                text-align:left;
                                            }
                                        </style>
                                        <div class="form-group col-md-3 col-xs-12 hidden">
                                            <label for="ddltestcurreny_cd" class="control-label">■ 통화 기준 : <span class="ddltestcurreny_cd_com"></span></label><br />
                                            <label for="ddltestcurreny_cd" class="control-label">■ 환율 적용 : <span class="chkexchange_rate_com"></span></label><br />
                                            <label for="ddltestcurreny_cd" class="control-label">■ 환율(USD) : <span class="txtexchange_rate_com"></span> 원</label>
                                        </div>
                                        <div class="clearfix mgn_T15"></div>
                                        <table id="tblcomplete_sample" class="GDH_table table-bordered table-condensed" style="width: 1227px; border-top: 2px solid #555;">
                                            <colgroup>
                                                <col width="100px" />
                                                <col width="200px" />
                                                <col width="150px" />
                                                <col width="100px" />
                                                <col width="*" />
                                            </colgroup>
                                            <tbody id="">
                                            </tbody>
                                        </table>
                                    </div>
                                </fieldset>

                            </div>
                            <%--접수완료--%>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    

     <%--***********************************************************************************************/
/* 시험 Package 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalPackageTest" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Package & 시험</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnmodaltestpackage_save">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <div id="grd_Modal_Package_Test_List" style="height: 300px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>


     <%--***********************************************************************************************/
/* 시료 추가
/***********************************************************************************************/--%>
    
    <script>
        $(function () {
            $('#divIframe').empty();

            var page = "Register_IN_Sample_Barcode";
            var key = "0" + "," + "0";

            var url = '/ReportFiles/ReportViewer_Popup.aspx/?page=' + page + '&key=' + key;
            var strIfframe = '<iframe id="iframe1" src="' + url + '" style="width: 100%; height: 100%; border: none;" ></iframe>';
            $('#divIframe').append(strIfframe).css('height', '300px');
        })
   
        function PrintContent() {
            $('#divIframe').removeClass('hidden');
            $('#divIframe').empty();

            var page = "Register_IN_Sample_Barcode";
            var key = $('#hidreq_num').val() + "," + $('#hidsample_id_barcode').val();

            var url = '/ReportFiles/ReportViewer_Popup.aspx/?page=' + page + '&key=' + key;
            var strIfframe = '<iframe id="iframe1" src="' + url + '" style="width: 100%; height: 100%; border: none;" ></iframe>';
            $('#divIframe').append(strIfframe).css('height', '300px');

            setTimeout(PrintContent_func, 1500);
        }
        function PrintContent_func() {
            var iframe1 = document.getElementById("iframe1");

            iframe1.contentWindow.myfunction();
            $('#divIframe').addClass('hidden');
        }
        function SampleBarcodeMapping() {
            __doPostBack('<%=btnmodalsample_barcode_print_server.UniqueID %>', '');
        }

        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        function EndRequestHandler(sender, args) {
            if (args.get_error() != undefined) {
                args.set_errorHandled(true);
                PrintContent();
            }
        }
    </script>
   <%--<div id="img_barcode" style="border: 1px solid black;">
        <asp:Image runat="server" ID="imgBarCode" CssClass="hidden" />
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="100%"
            SizeToReportContent="true" ShowPrintButton="true">
            <LocalReport ReportPath="ReportFiles\UI_Register\Register_IN_Sample_Barcode.rdlc">
            </LocalReport>
        </rsweb:ReportViewer>
    </div>
         --%>
    
    <div class="modal fade" id="modalSampleData" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <div id="divIframe" class="form-group text-center hidden">
                        <%--리포트 뷰어--%>
                    </div>
                    <p class="modal-title">시료</p>
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div class="container">
                                <asp:Button ID="btnmodalsample_barcode_print_server" CssClass="btn btn-outline-primary hidden" runat="server" Text="Genrate" OnClick="btnGenrate_Click" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <button type="button" class="btn btn-info btn-sm" id="btnmodalsample_barcode_print" onclick="PrintContent();">
                        <span class="glyphicon glyphicon-barcode"></span>&nbsp;Barcode Print
                    </button>
                    <button type="button" class="btn btn-success btn-sm" id="btnmodalsample_save">
                        <span class="glyphicon glyphicon-floppy-disk"></span>&nbsp;Save
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body">
                    <div class="form-group col-md-3 col-xs-12">
                        <input type="hidden" id="hidsample_id" />
                        <input type="hidden" id="hidsample_short_nm" />
                        <input type="hidden" id="hidsample_id_barcode" />
                        <label for="txtsample_nm" class="control-label lbl_Vali">■ 시료명</label>
                        <input type="text" class="form-control input-sm " id="txtsample_nm" name="txtsample_nm" />
                    </div>
                    <div class="form-group col-md-3 col-xs-12">
                        <label for="txtsample_nm" class="control-label lbl_Vali">■ 성적서 번호</label>
                        <input type="text" class="form-control input-sm " id="txtreport_no" name="txtreport_no" />
                    </div>
                    <div class="form-group col-md-6 col-xs-12">
                        <label for="txtsample_cnt" class="control-label lbl_Vali">■ 수량</label>
                        <table class="" style="width:100%">
                            <tr>
                                <td ><input type="text" class="form-control input-sm " id="txtsample_cnt" name="txtsample_cnt" style="text-align:right;" /></td>
                                <td style="width:2%">&nbsp;</td>
                                <td><input type="text" class="form-control input-sm " id="txtsample_capacity" name="txtsample_capacity" style="text-align:right;" /></td>
                                <td style="width: 2%">&nbsp;</td>
                                <td>
                                    <asp:DropDownList ID="ddlsample_unit" runat="server" name="ddlsample_unit" CssClass="form-control input-sm" ClientIDMode="Static">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                        
                    </div>
                    <div class="form-group col-md-6 col-xs-12">
                        <label for="ddlsample_team" class="control-label">■ 팀</label>
                        <asp:DropDownList ID="ddlsample_team" runat="server" name="ddlsample_team" CssClass="form-control input-sm" ClientIDMode="Static">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group col-md-6 col-xs-12">
                        <label for="ddlsample_type_cd" class="control-label">■ 처리</label>
                        <asp:DropDownList ID="ddlsample_type_cd" runat="server" name="ddlsample_type_cd" CssClass="form-control input-sm" ClientIDMode="Static">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group col-md-6 col-xs-12">
                        <label for="txtsample_get_dt" class="control-label">■ 채취일자</label>
                        <input type="text" class="form-control input-sm " id="txtsample_get_dt" name="txtsample_get_dt" />
                    </div>
                    
                    <div class="form-group col-md-6 col-xs-12">
                        <label for="txtsample_get_place" class="control-label">■ 채취장소</label>
                        <input type="text" class="form-control input-sm " id="txtsample_get_place" name="txtsample_get_place" />
                    </div>
                    <div class="form-group col-xs-12">
                        <label for="txtsample" class="control-label">■ 시료사진</label>
                        <div class="text-right mgn_B5 mgn_B15">
                            <button type="button" class="btn btn-default btn-sm" id="btnsample_file_upload" style="min-width: 1px;">
                                <span class="glyphicon glyphicon-plus"></span>
                            </button>
                            <button type="button" class="btn btn-danger btn-sm" id="btnsample_file_delete" style="min-width: 1px;">
                                <span class="glyphicon glyphicon-trash"></span>
                            </button>
                        </div>
                        <div id="grd_Sample_File_List" style="height: 200px; border: 1px solid #ddd; border-top: 2px solid #555;" class=""></div>
                        <%--<div class="input-group ">
                            <input type="hidden" class="form-control input-sm" id="txtsample_file_url" name="txtsample_file_url" />
                            <input type="text" class="form-control input-sm" id="txtsample_file_nm" name="txtsample_file_nm" readonly="readonly" onclick="GetFileViewer(this);" />
                            <div class="input-group-btn">
                                <button type="button" class="btn btn-default input-sm" id="btnsample_file_upload" style="min-height: 1px; min-width: 1px; line-height: normal;">
                                    <span class="glyphicon glyphicon-search"></span>
                                </button>
                            </div>
                        </div>--%>
                    </div>
                    <div class="form-group col-md-6 col-xs-12">
                        <label for="txtUnit_nm" class="control-label">■ 외관상태</label>
                        <table style="width: 100%; border-top: 2px solid #ddd;">
                            <tr>
                                <td>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="flat" id="chksample_status_extorior" name="chksample_status_extorior" />
                                            양호
                                        </label>
                                    </div>
                                </td>
                                <td class="">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="flat" id="chksample_status_leak" name="chksample_status_leak" />
                                            누출
                                        </label>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="form-group col-md-6 col-xs-12">
                        <label for="txtsample_status_remark" class="control-label">■ 상태비고</label>
                        <input type="text" class="form-control input-sm " id="txtsample_status_remark" name="txtsample_status_remark" />
                    </div>
                    <div class="clearfix"></div>
                    <div class="form-group col-xs-12">
                        <label for="txtUnit_nm" class="control-label lbl_Vali">■ 형태</label>
                        <table style="width: 100%; border-top: 2px solid #ddd;">
                            <tr>
                                <td>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="flat" id="chksample_kolas" name="chksample_kolas" />
                                            공인성적서(KOLAS)
                                        </label>
                                    </div>
                                </td>
                                <td>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="flat" id="chksample_nonkolas" name="chksample_nonkolas" />
                                            비공인성적서(Non-KOLAS)
                                        </label>
                                    </div>
                                </td>
                                <td>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="flat" id="chksample_ilacmra" name="chksample_ilacmra" />
                                            ILAC-MRA
                                        </label>
                                    </div>
                                </td>
                                <td>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="flat" id="chksample_korean" name="chksample_korean" />
                                            국문(Korean)
                                        </label>
                                    </div>
                                </td>
                                <td>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="flat" id="chksample_english" name="chksample_english" />
                                            영문(English)
                                        </label>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="clearfix"></div>

                </div>
                <div class="clearfix" ></div>
                <div class="modal-footer mgn_T15">

                </div>
            </div>
        </div>
    </div>

     <%--***********************************************************************************************/
/* User 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalUser" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">User</p>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <div id="grd_Modal_User_List" style="height: 300px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>

        <%--***********************************************************************************************/
/* Customer 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalCustomer" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Customer</p>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body pdd0">
                    <input type="hidden" id="hidmodalcust_gb" />
                    <div id="grd_Modal_Cust_List" style="height: 300px; top: 0px;"></div>
                </div>
                <div class="modal-footer">
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
                    <p class="modal-title">Contact</p>
                    <button type="button" class="btn btn-success btn-sm" id="btnmodalcontact_list">
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
/* Item 추가
/***********************************************************************************************/--%>
    <div class="modal fade" id="modalCustAddrView" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">주소 보기</p>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div class="modal-body">
                    <div class="form-group col-xs-12">
                        <label for="txtcust_addr_view" class="control-label" id="">■ 업체 : </label>
                        <label for="txtcust_addr_view" class="control-label" id="lblcust_nm_view"></label>
                        <input type="text" class="form-control input-sm " id="txtcust_addr_view" name="txtcust_addr_view" readonly="readonly"/>
                    </div>
                </div>
                <div class="clearfix" ></div>
                <div class="modal-footer mgn_T15">
                </div>
            </div>
        </div>
    </div>
    <script src="/Scripts/jquery-1.10.2.js"></script>
</asp:Content>

