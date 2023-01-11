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
        "Date": DateFormatter, //�ټ� �߰�
        "RequirementFormatter": RequirementFormatter, //������ �߰�
        "SpecFieldGroupSelectFormatter": SpecFieldGroupSelectFormatter,//������ �߰�
        "SpecFieldOptionFormat": SpecFieldOptionFormatter,//������ �߰�,
        "DeleteButtonFormat": DeleteButtonFormatter,//������ �߰�,
        "SelectFormatter": SelectFormatter, // �Ȼ��� �߰�
        "Currency": CurrencyFormatter,                               // �ݾ� ����
        "OptionButtonFormat":OptionButtonFormatter, //���¿� �߰�
        "LinkTag": LinkTagFormatter,
      }
    }
  });

    // ���¿� �߰�
  function OptionButtonFormatter(row, cell, value, columnDef, dataContext) {
      /*�޾ƿ� ���ڿ�(�ڵ尪+inputType��) �� �߶� Type�� combox �϶��� ��ư ����*/
      var strArray = value.split(',');
      var fts = strArray[1];
      /* Ŭ���̺�Ʈ ������ ���� value �ٽ� ����*/
      var value = strArray[0] + ");";

      if (fts == "FTS02);")
          return '<span class="BtnStyleA" style="margin-left:10px;"><input type="button" value="Option" id="' + row.id + '" onclick="' + value + '" /></span>';
      else
          return '';
  }

    //������ �߰�
  function DeleteButtonFormatter(row, cell, value, columnDef, dataContext) {
      var returnval = '';
      if (value != null) {
          //<span class="BtnStyleB"><input type="button" value="Complete" onclick="CompleteData();" /></span>
          returnval = '<span class="BtnStyleB"><input type="button" onclick="' + value + '" value="Delete" id="' + row.id + '"/></span>';
      }
      return returnval;
  }
  //�Ȼ��� �߰�
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
  //������ �߰�
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

  /*Dasom Jeong ��¥ ����*/
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
    // Note - Path�� Value�� ���ϸ��� �����Ͽ� ǥ���ϰ� A�±׷� �����Ѵ�.
    //======================================================
  function LinkTagFormatter(row, cell, value, columnDef, dataContext) {

      var strReturn = "";

      if (value == null || value === "") {
          return "-";
      } else {
          // Note - ��ο��� ���ϸ��� �����Ѵ�. 
          var arrPath = value.split("/");
          if (arrPath.length <= 0)
              return "-";

          var strFileName = arrPath[arrPath.length - 1];

          strReturn = "<a href=\"" + value + "\" target=\"_blank\">" + strFileName + "</a>";
      }

      return strReturn;
  }

})(jQuery);
