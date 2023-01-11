

/***********************************************************************************************/
/* 전역 변수
/***********************************************************************************************/
var strreg_no = '';
var edit_options = {
    multiSelect: true,
    //autoHeight: true,
    //rowHeight: 35,
    editable: true,
    enableAddRow: false,
    enableCellNavigation: true,
    explicitInitialization: true,
    asyncEditorLoading: true,
    forceFitColumns: false,
    enableTextSelectionOnCells: true,
    rowHeight: 30,
}
var default_options = {
    editable: false,
    enableAddRow: false,
    enableCellNavigation: true,
    explicitInitialization: true,
    asyncEditorLoading: true,
    forceFitColumns: false,
    enableTextSelectionOnCells: true,
    rowHeight: 30,
}
var header_options = {
    editable: true,
    enableAddRow: false,
    enableCellNavigation: true,
    showHeaderRow: true,
    explicitInitialization: true,
    asyncEditorLoading: true,
    forceFitColumns: false,
    enableTextSelectionOnCells: true,
    rowHeight: 30,
};

(function ($) {
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

    // 함수 스코프 내에서 $는 jQuery Object임.
    //$(document).on('click', '.slick-row', function () {
    //    alert('1');
    //})

    //Bootstrap multiple modal
    
    var count = 0; // 모달이 열릴 때 마다 count 해서  z-index값을 높여줌
    $(document).on('show.bs.modal', '.modal', function () {
        var zIndex = 1040 + (10 * count);
        $(this).css('z-index', zIndex);
        setTimeout(function () {
            $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
        }, 0);
        count = count + 1
    });



    // multiple modal Scrollbar fix

    $(document).on('hidden.bs.modal', '.modal', function () {
        $('.modal:visible').length && $(document.body).addClass('modal-open');
    });

}(jQuery));

function ChangejQGridDesign(table, pager) {
    var $grid = $(table),
    newWidth = $grid.closest(".ui-jqgrid").parent().width();
    $grid.jqGrid("setGridWidth", newWidth, true);
    $grid.trigger("reloadGrid");

    $(window).on("resize", function () {
        var $grid = $(table),
        newWidth = $grid.closest(".ui-jqgrid").parent().width();
        $grid.jqGrid("setGridWidth", newWidth, true);
        $grid.trigger("reloadGrid");
    });
}

function fn_collapseAllGroups(grd) {
    var items = grd.dataView.getItems();
    for (var i = 0; i < items.length; i++) {
        var item = items[i];

        if (item) {
            if (!item._collapsed) {
                item._collapsed = true;
            }
            grd.dataView.updateItem(item.id, item);
        }
    }
}
function fn_expandAllGroups(grd) {
    var items = grd.dataView.getItems();
    for (var i = 0; i < items.length; i++) {
        var item = items[i];

        if (item) {
            if (item._collapsed) {
                item._collapsed = false;
            }
            grd.dataView.updateItem(item.id, item);
        }
    }
}

/***********************************************************************************************/
/* 년도 + -  리턴
/***********************************************************************************************/
function fn_GetYearPnM(forInt) {
    var defautlYear = parseInt(new Date().getFullYear());
    var strYearList = '';
    for (var i = forInt; i >= 1; i--) {
        strYearList += "<option value='" + (defautlYear - i) + "'>" + (defautlYear - i) + "</option>";
    }
    strYearList += "<option value='" + defautlYear + "'>" + defautlYear + "</option>";
    for (var i = 1; i <= forInt; i++) {
        strYearList += "<option value='" + (defautlYear + i) + "'>" + (defautlYear + i) + "</option>";
    }

    return strYearList;
}

/***********************************************************************************************/
/* 3 자리 콤마
/***********************************************************************************************/
function fn_NumberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

/***********************************************************************************************/
/* 페이징 관련
/***********************************************************************************************/
function fn_Paging(data) {
    var aa = '';

    var totalPage = parseInt(data.totalCount / data.countList);

    if (data.totalCount % data.countList > 0) {
        totalPage++;
    }

    if (totalPage < data.page) {
        data.page = totalPage;
    }

    var startPage = parseInt(((data.page - 1) / 10)) * 10 + 1;
    var endPage = startPage + data.countPage - 1;

    if (endPage > totalPage) {
        endPage = totalPage;
    }

    if (startPage > 1) {
        aa += "<li><a>&laquo;&laquo;</a></li>";
    }

    if (data.page > 1) {
        aa += "<li><a>&laquo;</a></li>";
    }

    for (var iCount = startPage; iCount <= endPage; iCount++) {
        if (iCount == data.page) {
            aa += "<li class='active'><a>" + iCount + "</a></li>";
        } else {
            aa += "<li><a>" + iCount + "</a></li>";
        }
    }

    if (data.page < totalPage) {
        aa += "<li><a>&raquo;</a></li>";
    }

    if (endPage < totalPage) {
        aa += "<li><a>&raquo;&raquo;</a></li>";
    }

    data.lastPage = totalPage;
    data.addText = aa;

    return data;
}

/***********************************************************************************************/
/* 검색영역 값 이벤트
/***********************************************************************************************/
function fn_SerchGridSetValue(obj, value) {
    obj.val(value);
    var e = $.Event("keyup");
    e.keyCode = 13;
    obj.trigger(e);
}
/***********************************************************************************************/
/* 영문 달 한국달로 변환 반환
/***********************************************************************************************/
function fn_ReturnKoMonth(str) {
    var re_str = '';
    switch (str) {
        case "January": re_str = "01"; break;
        case "February": re_str = "02"; break;
        case "March": re_str = "03"; break;
        case "April": re_str = "04"; break;
        case "May": re_str = "05"; break;
        case "June": re_str = "06"; break;
        case "July": re_str = "07"; break;
        case "August": re_str = "08"; break;
        case "September": re_str = "09"; break;
        case "October": re_str = "10"; break;
        case "November": re_str = "11"; break;
        case "December": re_str = "12"; break;
        default: re_str = ""; break;
    }

    return re_str;
}

/***********************************************************************************************/
/* 휴무일 제외 한 값 리턴
/***********************************************************************************************/
var fn_ReturnHoliday = function (start, end) {
    var cnt;
    var Gparam = {
        IV_START_DT: start,
        IV_END_DT: end
    };
    $.ajax({
        url: "/WebService/Common_Service.asmx/fn_ReturnHoliday",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ 'Gparam': Gparam }),
        dataType: "json",
        async: false,
        success: function (response) {
            // Note - Json개체 변환
            var jsonData = $.parseJSON(response.d);

            if (jsonData != null && jsonData.result.length > 0) {
                cnt = jsonData.result[0].HOLI_DT;
            }
            else {
                cnt = 0;
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

    return cnt;
}

/***********************************************************************************************/
/* 공통 코드 가져오기
/***********************************************************************************************/
var fn_jqgrid_optionDatas = function (cd_major) {
    var options = '';

    if (cd_major == "YesNo") {
        options += 'Y:Yes;N:No';
    } else {
        $.ajax({
            url: "/WebService/Common_Service.asmx/GetCMCODE",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: "{cd_major:'" + cd_major + "'}",
            dataType: "json",
            async: false,
            success: function (response) {
                // Note - Json개체 변환
                var jsonData = $.parseJSON(response.d);

                for (var i = 0; i < jsonData.result.length; i++) {
                    options += jsonData.result[i].CD_MINOR + ':' + jsonData.result[i].CD_FNAME + ';'
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

    return options;
}

var fn_grid_optionDatas = function (cd_major, IsEmpty) {
    var options = [];

    if (cd_major == "YesNo") {
        if (IsEmpty == true) {
            options.push({ CD_MINOR: "", CD_FNAME: "" });
        }
        options.push({ CD_MINOR: "Y", CD_FNAME: "Y" });
        options.push({ CD_MINOR: "N", CD_FNAME: "N" });
    } else {
        $.ajax({
            url: "/WebService/Common_Service.asmx/GetCMCODE",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: "{cd_major:'" + cd_major + "'}",
            dataType: "json",
            async: false,
            success: function (response) {
                // Note - Json개체 변환
                var jsonData = $.parseJSON(response.d);

                if (IsEmpty == true) {
                    options.push({ CD_MINOR: "", CD_FNAME: "" })
                }
                for (var i = 0; i < jsonData.result.length; i++) {
                    options.push({ CD_MINOR: jsonData.result[i].CD_MINOR, CD_FNAME: jsonData.result[i].CD_FNAME })
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

    return options;
}
var GetCMCODE = function (cd_major, IsEmpty) {
    var options = "";

    $.ajax({
        url: "/WebService/Common_Service.asmx/GetCMCODE",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        data: "{cd_major:'" + cd_major + "'}",
        dataType: "json",
        async: false,
        success: function (response) {
            // Note - Json개체 변환
            var jsonData = $.parseJSON(response.d);

            if (IsEmpty == true) {
                options = "<option value=''>ALL</option>";
            }
            for (var i = 0; i < jsonData.result.length; i++) {
                options += "<option value='" + jsonData.result[i].CD_MINOR + "'>" + jsonData.result[i].CD_FNAME + "</option>";
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

    return options;
}
var GetCMCODE_Level = function (cd_major, cd_level, IsEmpty) {
    var options = [];

    $.ajax({
        url: "/WebService/Common_Service.asmx/GetCMCODE_Level",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        data: "{cd_major:'" + cd_major + "', cd_level : '" + cd_level + "'}",
        dataType: "json",
        async: false,
        success: function (response) {
            // Note - Json개체 변환
            var jsonData = $.parseJSON(response.d);

            if (IsEmpty == true) {
                options = "<option value=''>ALL</option>";
            }
            for (var i = 0; i < jsonData.result.length; i++) {
                options += "<option value='" + jsonData.result[i].CD_MINOR + "'>" + jsonData.result[i].CD_FNAME + "</option>";
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

    return options;
}

var GetCMCODE_Level_New = function (Gparam) {
    var options = [];

    $.ajax({
        url: "/WebService/Common_Service.asmx/GetCMCODE_Level",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        data: "{cd_major:'" + Gparam.cd_major + "', cd_level : '" + Gparam.cd_level + "'}",
        dataType: "json",
        async: false,
        success: function (response) {
            // Note - Json개체 변환
            var jsonData = $.parseJSON(response.d);

            if (Gparam.IsEmpty == true) {
                options = "<option value=''>" + Gparam.Text + "</option>";
            }
            for (var i = 0; i < jsonData.result.length; i++) {
                if (Gparam.Delete != null) {
                    if (Gparam.Delete.indexOf(jsonData.result[i].CD_MINOR) > -1) continue;
                }
                if (Gparam.Default != null) {
                    if (!(Gparam.Default.indexOf(jsonData.result[i].CD_MINOR) > -1)) continue;
                }
                options += "<option value='" + jsonData.result[i].CD_MINOR + "'>" + jsonData.result[i].CD_FNAME + "</option>";
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

    return options;
}
var GetCMCODE_Sub = function (cd_major, cd_fr_minor, IsEmpty) {
    cd_fr_minor = cd_fr_minor == '' ? '..' : cd_fr_minor;
    var options = [];

    $.ajax({
        url: "/WebService/Common_Service.asmx/GetCMCODE_Sub",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        data: "{cd_major:'" + cd_major + "', cd_fr_minor : '" + cd_fr_minor + "'}",
        dataType: "json",
        async: false,
        success: function (response) {
            // Note - Json개체 변환
            var jsonData = $.parseJSON(response.d);

            if (IsEmpty == true) {
                options = "<option value=''>ALL</option>";
            }
            for (var i = 0; i < jsonData.result.length; i++) {
                options += "<option value='" + jsonData.result[i].CD_MINOR + "'>" + jsonData.result[i].CD_FNAME + "</option>";
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

    return options;
}

var GetCMCODE_Sub_New = function (Gparam) {
    Gparam.cd_fr_minor = Gparam.cd_fr_minor == '' ? '..' : Gparam.cd_fr_minor;
    var options = [];

    $.ajax({
        url: "/WebService/Common_Service.asmx/GetCMCODE_Sub",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        data: "{cd_major:'" + Gparam.cd_major + "', cd_fr_minor : '" + Gparam.cd_fr_minor + "'}",
        dataType: "json",
        async: false,
        success: function (response) {
            // Note - Json개체 변환
            var jsonData = $.parseJSON(response.d);

            if (Gparam.IsEmpty == true) {
                options = "<option value=''>" + Gparam.Text + "</option>";
            }
            for (var i = 0; i < jsonData.result.length; i++) {
                if (Gparam.Delete != null) {
                    if (Gparam.Delete.indexOf(jsonData.result[i].CD_MINOR) > -1) continue;
                }
                options += "<option value='" + jsonData.result[i].CD_MINOR + "'>" + jsonData.result[i].CD_FNAME + "</option>";
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

    return options;
}


/***********************************************************************************************/
/* Mail Send 관련
/***********************************************************************************************/
var mailsend_obj = {
    thismodal: {},
    key: "",
    page: "",
};

/***********************************************************************************************/
/* 엑실 업로드  관련 
/***********************************************************************************************/
var excelupload_obj = {
    thismodal: {},
    key: "",
    page: "",
};

/***********************************************************************************************/
/* 파일 업로드  관련 
/***********************************************************************************************/
var fileupload_obj = {
    filemodal: {},
    multi: false,
    key: "",
    page: "",
    clear: function () {
        this.multi = false;
        this.page = "";
        this.key = [];
    }
};

/***********************************************************************************************/
/* 파일 뷰어  관련 
/***********************************************************************************************/
var fileView_obj = {
    key: [],
    page: "",
    clear: function () {
        this.page = "";
        this.key = [];
    }
};

/***********************************************************************************************/
/* 날짜 셋팅 함수
/***********************************************************************************************/
var fn_DatePicker = function (obj) {
    obj.datepicker({
        //showOn: "both",
        //buttonImage : '../Images/datepickerGif.gif',
        changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
        changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
        dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
        showButtonPanel: true,
        currentText: '오늘 날짜', // 오늘 날짜로 이동하는 버튼 패널
        closeText: '닫기',  // 닫기 버튼 패널
        //showAnim: "slide", //애니메이션을 적용한다.
        beforeShow: function () {
            setTimeout(function () {
                $('.ui-datepicker').css('z-index', 99999999999999);
            }, 0);
        }
    });

    //obj.val(fn_today());

    //http://blog.munilive.com/datepicker-%EC%8B%9C%EC%9E%91%EC%9D%BC%EA%B3%BC-%EC%A2%85%EB%A3%8C%EC%9D%BC-%EC%84%A4%EC%A0%95%EC%8B%9C-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0-%EC%A2%8B%EC%9D%80-%ED%8C%81/
}
/***********************************************************************************************/
/* 슬릭그리드 에디터
/***********************************************************************************************/
// 셀렉트 박스 (구동환)
function GDH_SelectEditor(args) {
    var $select;
    var defaultValue;
    var scope = this;

    this.init = function () {

        var optionsArr = args.column.options;
        var option_str = ""
        for (var i = 0; i < optionsArr.length; i++) {
            option_str += "<OPTION value='" + optionsArr[i].CD_MINOR + "'>" + optionsArr[i].CD_FNAME + "</OPTION>";
        }

        $select = $("<SELECT tabIndex='0' class='editor-select'>" + option_str + "</SELECT>");
        $select.appendTo(args.container);
        $select.focus();
    };

    this.destroy = function () {
        $select.remove();
    };

    this.focus = function () {
        $select.focus();
    };

    this.loadValue = function (item) {
        defaultValue = item[args.column.field];
        $select.val(defaultValue);
    };

    this.serializeValue = function () {
        if (args.column.options) {
            return $select.val();
        } else {
            return ($select.val() == "yes");
        }
    };

    this.applyValue = function (item, state) {
        item[args.column.field] = state;
    };

    this.isValueChanged = function () {
        return ($select.val() != defaultValue);
    };

    this.validate = function () {
        return {
            valid: true,
            msg: null
        };
    };

    this.init();
}
/***********************************************************************************************/
/* 슬릭그리드 포멧팅
/***********************************************************************************************/
function GDH_Btn_FileUpload(row, cell, value, columnDef, dataContext) {
    return "<input type='button' style='min-width:10px; width:70px;' value='Upload' class='btn_upload' />";
}
function GDH_Btn_Up(row, cell, value, columnDef, dataContext) {
    return "<input type='button' style='min-width:10px; width:30px;' value='▲' class='btn_up' />";
}
function GDH_Btn_Down(row, cell, value, columnDef, dataContext) {
    return "<input type='button' style='min-width:10px; width:30px;' value='▼' class='btn_down' />";
}
function GDH_Btn_Delete(row, cell, value, columnDef, dataContext) {
    return "<input type='button' style='min-width:10px; width:30px;' value='Ⅹ' class='btn_delete' />";
}
function GDH_FilePopupLink(row, cell, value, columnDef, dataContext) {
    if (value == null || value == '') return '';
    return "<a href='" + value + "' target='_blank'>Y</a>";
}
function GDH_TextDateColor(row, cell, value, columnDef, dataContext) {
    var str = '';
    if (value == null || value == '') return '';
    else {
        var dategb = new Date(value).getDay();

        // 토욜
        if (dategb == 6) {
            str = "<span style='color:#337ab7;'><b>" + value + "</b></span>";
        }
            //일욜
        else if (dategb == 0) {
            str = "<span style='color:#d9534f;'><b>" + value + "</b></span>";
        }
        else {
            str = value;
        }
    }
    return str;
}
function GDH_StatusBackColor(row, cell, value, columnDef, dataContext) {
    if (value == '반려' || value == '검토반려' || value == '승인반려') {
        return "<span style='color:red;'><b>" + value + "</b></span>";
    }
    return "<span>" + value + "</span>";
}
function GDH_TextPopupColor(row, cell, value, columnDef, dataContext) {
    if (value == null) value = '';
    return "<span class='formater_master_text'>" + value + "</span>";
}
function GDH_TextAlertColor(row, cell, value, columnDef, dataContext) {
    // Background
    //if (value == '중요') {
    //    return returnval = "<div style='color:#fff; background-color:#d9534f;'><b>" + value + "</b></div>"
    //}
    // TEXT

    if (value == '해외출장' || value == '국내출장') {
        return "<span style='color:#ee55a2;'><b>" + value + "</b></span>";
    }
    if (value == '연차' || value == '반차 (오후)' || value == '반차 (오전)') {
        return "<span style='color:#5cb85c;'><b>" + value + "</b></span>";
    }
    if (value == '일정') {
        return "<span style='color:#337ab7;'><b>" + value + "</b></span>";
    }
    if (value == '중요' || value == '휴근') {
        return "<span style='color:#d9534f;'><b>" + value + "</b></span>";
    }
    if (value == '알림' || value == '교육') {
        return "<span style='color:orange;'><b>" + value + "</b></span>";
    }
    if (value == '야근') {
        return "<span style='color:#b70038;'><b>" + value + "</b></span>";
    }
    // New Yn
    if (value == 'Y') {
        return "<span style='color:orange;'><b>New</b></span>";
    }
    if (value == 'N') {
        return "";
    }
    return "<span>" + value + "</span>";
}
function GDH_SelectFormatter(row, cell, value, columnDef, dataContext) {
    var returnval = '';
    if (value != null) {
        for (var i = 0; i < columnDef.options.length; i++) {
            if (value == columnDef.options[i].CD_MINOR) {
                returnval = columnDef.options[i].CD_FNAME;
            }
        }
    }
    return returnval;
}
function GDH_SelectFormatter_Style(row, cell, value, columnDef, dataContext) {
    var returnval = '';
    if (value != null) {
        for (var i = 0; i < columnDef.options.length; i++) {
            if (value == columnDef.options[i].CD_MINOR) {
                returnval = columnDef.options[i].CD_FNAME;
            }
        }
    }
    if (returnval == 'FAIL') {
        returnval = "<div style='color:#fff; background-color:orange;'><b>" + returnval + "</b></div>"
    }
    return returnval;

}
function GDH_NumberFormatter(row, cell, value, columnDef, dataContext) {
    var returnval = '';

    if (value != null && value != '') {
        if (isNaN(parseInt(value))) {
            returnval = "0";
        }
        else {
            returnval = value;
        }
    }
    return returnval.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function GDH_CurrencyFormatter(row, cell, value, columnDef, dataContext) {
    var returnval = '';
    if (value != null && value != '') {
        returnval = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
    else {
        returnval = "0";
    }
    return returnval;
}

/***********************************************************************************************/
/* 모달 경고창
/***********************************************************************************************/
function fn_info(title) {
    $('#lblAlertTitle').text(title);
    $('#modalAlert_success').modal();
}

function fn_error(msg) {
    //alert(msg);
    $('#txtModalAlert').val(msg);
    $('#modalAlert_Error').modal();
}


/***********************************************************************************************/
/* 컨트롤 초기화
/***********************************************************************************************/
var fn_lpad = function (str, max) {
    str = str.toString();
    return str.length < max ? fn_lpad("0" + str, max) : str;
}
var fn_ClearGrid = function (grd) {
    if (grd) {
        grd.dataView.beginUpdate();
        grd.dataView.setItems([]);
        grd.grid.setSelectedRows([]);
        grd.dataView.endUpdate();
        grd.grid.render();
    }
}
function lpad(str, max) {
    str = str.toString();
    return str.length < max ? lpad("0" + str, max) : str;
}
var fn_today = function (year, month, day) {
    function lpad(str, max) {
        str = str.toString();
        return str.length < max ? lpad("0" + str, max) : str;
    }

    var dateObj = new Date();

    if (year != undefined || year != null) {
        dateObj.setYear(dateObj.getFullYear() + parseInt(year));
    }
    if (month != undefined || month != null) {
        dateObj.setMonth(dateObj.getMonth() + parseInt(month));
    }
    if (day != undefined || day != null) {
        dateObj.setDate(dateObj.getDate() + parseInt(day));
    }

    var year = dateObj.getFullYear();
    var month = dateObj.getMonth() + 1;
    var day = dateObj.getDate();

    var today = year + "-" + lpad(month, 2) + "-" + lpad(day, 2);

    return today;
}
var fn_calc_date = function (org_date, year, month, day) {
    function lpad(str, max) {
        str = str.toString();
        return str.length < max ? lpad("0" + str, max) : str;
    }

    var arrorg_date = org_date.split('-');
    var dateObj = new Date(arrorg_date[0], parseInt(arrorg_date[1]) - 1, arrorg_date[2]);

    if (year != undefined || year != null) {
        dateObj.setYear(dateObj.getFullYear() + parseInt(year));
    }
    if (month != undefined || month != null) {
        dateObj.setMonth(dateObj.getMonth() + parseInt(month));
    }
    if (day != undefined || day != null) {
        dateObj.setDate(dateObj.getDate() + parseInt(day));
    }

    var year = dateObj.getFullYear();
    var month = dateObj.getMonth() + 1;
    var day = dateObj.getDate();

    var today = year + "-" + lpad(month, 2) + "-" + lpad(day, 2);

    return today;
}
var fn_AddDate = function (value, year, month, day) {
    function lpad(str, max) {
        str = str.toString();
        return str.length < max ? lpad("0" + str, max) : str;
    }

    var dateObj = new Date(value);

    if (year != undefined || year != null) {
        dateObj.setYear(dateObj.getFullYear() + parseInt(year));
    }
    if (month != undefined || month != null) {
        dateObj.setMonth(dateObj.getMonth() + parseInt(month));
    }
    if (day != undefined || day != null) {
        dateObj.setDate(dateObj.getDate() + parseInt(day));
    }

    var year = dateObj.getFullYear();
    var month = dateObj.getMonth() + 1;
    var day = dateObj.getDate();

    var today = year + "-" + lpad(month, 2) + "-" + lpad(day, 2);

    return today;
}

var fn_ClearControls = function (obj) {

    /* 모든 텍스트필드 초기화 */
    obj.find("input").each(function () {
        $(this).val('');
    });
    obj.find("textarea").each(function () {
        $(this).val('');
    });
    obj.find(".summernote").each(function () {
        $(this).summernote('code', '');
    });
    /*이미지 박스 초기화*/
    //obj.find(".form-group span").each(function () {
    //    $(this).text('');
    //});
    // 콤보박스
    obj.find('select:not([multiple])').each(function () {
        $(this).find('option:first').prop('selected', 'selected');
    });
    // 리스트 박스
    //obj.find('select:[multiple]').each(function (index, option) {
    //    $(option).remove();
    //});
    /*날짜 박스 초기화*/
    obj.find("input[type='date']").each(function () {
        $(this).val(fn_today());
    });
    //obj.find(".hasDatepicker").each(function () {
    //    $(this).val(fn_today());
    //});

    /*체크박스 초기화*/
    obj.find("input[type='checkbox']").each(function () {
        $(this).prop("checked", false);
    });
    obj.find("input[type='checkbox']").closest("div").each(function () {
        $(this).removeClass("checked");
    });
    /*Number 박스 초기화*/
    obj.find("input[type='number']").each(function () {
        $(this).val(0);
        $(this).css('text-align', 'right');
    });
    /*이미지 박스 초기화*/
    obj.find("img").each(function () {
        //$(this).prop("src", '../Common/Content/images/product.png');
    });
    /*테이블 초기화*/
    obj.find("table[class='table_bind_List']").each(function () {
        $(this).bootstrapTable('removeAll');
    });

    //$('#date_reserve').val($.datepicker.formatDate('yymmdd', new Date()));

    ///*file 박스 초기화*/
    //var files = $("input[type='file']");
    //for (var i = 0; i < files.length; i++) {
    //    files[i].select();
    //    document.selection.clear;
    //}
}

/***********************************************************************************************/
/* String.format
/***********************************************************************************************/
String.format = function () {
    // The string containing the format items (e.g. "{0}")
    // will and always has to be the first argument.
    var theString = arguments[0];

    // start with the second argument (i = 1)
    for (var i = 1; i < arguments.length; i++) {
        // "gm" = RegEx options for Global search (more than one instance)
        // and for Multiline search
        var regEx = new RegExp("\\{" + (i - 1) + "\\}", "gm");
        theString = theString.replace(regEx, arguments[i]);
    }

    return theString;
}

//replaceAll prototype 선언
String.prototype.replaceAll = function (org, dest) {
    return this.split(org).join(dest);
}

