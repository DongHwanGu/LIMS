/***
 * Contains basic SlickGrid formatters.
 * 
 * NOTE:  These are merely examples.  You will most likely need to implement something more
 *        robust/extensible/localizable/etc. for your use!
 * 
 * @module Formatters
 * @namespace Slick
 */

(function ($) {
  // register namespace
  $.extend(true, window, {
    "Slick": {
      "Formatters": {
        "PercentComplete": PercentCompleteFormatter,
        "PercentCompleteBar": PercentCompleteBarFormatter,
        "YesNo": YesNoFormatter,
        "Checkmark": CheckmarkFormatter,
        "Date": DateFormatter, //다솜 추가
        "RequirementFormatter": RequirementFormatter, //조선만 추가
        "SpecFieldGroupSelectFormatter": SpecFieldGroupSelectFormatter,//조선만 추가
        "SpecFieldOptionFormat": SpecFieldOptionFormatter,//조선만 추가,
        "DeleteButtonFormat": DeleteButtonFormatter,//조선만 추가,
        "SelectFormatter": SelectFormatter, // 안상진 추가
        "Currency": CurrencyFormatter,                               // 금액 포멧
        "OptionButtonFormat":OptionButtonFormatter, //이태욱 추가
        "LinkTag": LinkTagFormatter,
      }
    }
  });

    // 이태욱 추가
  function OptionButtonFormatter(row, cell, value, columnDef, dataContext) {
      /*받아온 문자열(코드값+inputType값) 을 잘라서 Type이 combox 일때만 버튼 생성*/
      var strArray = value.split(',');
      var fts = strArray[1];
      /* 클릭이벤트 설정을 위해 value 다시 지정*/
      var value = strArray[0] + ");";

      if (fts == "FTS02);")
          return '<span class="BtnStyleA" style="margin-left:10px;"><input type="button" value="Option" id="' + row.id + '" onclick="' + value + '" /></span>';
      else
          return '';
  }

    //조선만 추가
  function DeleteButtonFormatter(row, cell, value, columnDef, dataContext) {
      var returnval = '';
      if (value != null) {
          //<span class="BtnStyleB"><input type="button" value="Complete" onclick="CompleteData();" /></span>
          returnval = '<span class="BtnStyleB"><input type="button" onclick="' + value + '" value="Delete" id="' + row.id + '"/></span>';
      }
      return returnval;
  }
  //안상진 추가
  function SelectFormatter(row, cell, value, columnDef, dataContext) {
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
  //조선만 추가
  function SpecFieldOptionFormatter(row, cell, value, columnDef, dataContext) {
      var returnval = '';
      if (value != null) {
          returnval = value;
      }
      return returnval;
  }

  function RequirementFormatter(row, cell, value, columnDef, dataContext) {
      return value ? "Yes" : "No";
  }

  function SpecFieldGroupSelectFormatter(row, cell, value, columnDef, dataContext) {
      var returnval = '';
      if (value != null) {
          returnval = value;
      }
      return returnval;
  }

  function PercentCompleteFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "-";
    } else if (value < 50) {
      return "<span style='color:red;font-weight:bold;'>" + value + "%</span>";
    } else {
      return "<span style='color:green'>" + value + "%</span>";
    }
  }

  function PercentCompleteBarFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }

    var color;

    if (value < 30) {
      color = "red";
    } else if (value < 70) {
      color = "silver";
    } else {
      color = "green";
    }

    return "<span class='percent-complete-bar' style='background:" + color + ";width:" + value + "%'></span>";
  }

  function YesNoFormatter(row, cell, value, columnDef, dataContext) {
    return value ? "Yes" : "No";
  }

  function PercentCompleteFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "-";
    } else if (value < 50) {
      return "<span style='color:red;font-weight:bold;'>" + value + "%</span>";
    } else {
      return "<span style='color:green'>" + value + "%</span>";
    }
  }

  function PercentCompleteBarFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }

    var color;

    if (value < 30) {
      color = "red";
    } else if (value < 70) {
      color = "silver";
    } else {
      color = "green";
    }

    return "<span class='percent-complete-bar' style='background:" + color + ";width:" + value + "%'></span>";
  }

  function YesNoFormatter(row, cell, value, columnDef, dataContext) {
    return value ? "Yes" : "No";
  }

  function PercentCompleteFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "-";
    } else if (value < 50) {
      return "<span style='color:red;font-weight:bold;'>" + value + "%</span>";
    } else {
      return "<span style='color:green'>" + value + "%</span>";
    }
  }

  function PercentCompleteBarFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }

    var color;

    if (value < 30) {
      color = "red";
    } else if (value < 70) {
      color = "silver";
    } else {
      color = "green";
    }

    return "<span class='percent-complete-bar' style='background:" + color + ";width:" + value + "%'></span>";
  }

  function YesNoFormatter(row, cell, value, columnDef, dataContext) {
    return value ? "Yes" : "No";
  }

  function CheckmarkFormatter(row, cell, value, columnDef, dataContext) {
      var returnImg = '';
      if (value != null) {
          if (value.toUpperCase() == 'Y') {
              returnImg = "<img src='/Common/images/SlickGrid/tick.png'>";
          }
      }
      
    
      return returnImg;
  }

  /*Dasom Jeong 날짜 포맷*/
  function DateFormatter(row, cell, value, columnDef, dataContext) {
      if (value != null)
          return new Date(parseInt(value.substr(6), 10)).format("yyyy-MM-dd");
      else
          return value;
  }

  function CurrencyFormatter(row, cell, value, columnDef, dataContext) {
      if (value === null || value === "" || !(value > 0)) {
          return Number();
      } else {
          return Number(value).toFixed(2);
      }
  }


    //======================================================
    // Note - Path를 Value로 파일명을 추출하여 표시하고 A태그로 구성한다.
    //======================================================
  function LinkTagFormatter(row, cell, value, columnDef, dataContext) {

      var strReturn = "";

      if (value == null || value === "") {
          return "-";
      } else {
          // Note - 경로에서 파일명을 추출한다. 
          var arrPath = value.split("/");
          if (arrPath.length <= 0)
              return "-";

          var strFileName = arrPath[arrPath.length - 1];

          strReturn = "<a href=\"" + value + "\" target=\"_blank\">" + strFileName + "</a>";
      }

      return strReturn;
  }

})(jQuery);
