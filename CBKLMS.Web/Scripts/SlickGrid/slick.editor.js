/***
 * Contains basic SlickGrid editors.
 * @module Editors
 * @namespace Slick
 */


(function ($) {
    // register namespace
    $.extend(true, window, {
        "Slick": {
            "Editors": {
                "Text": TextEditor,
                "AutoText": AutoCompleteText,
                "AutoText_DataInput": AutoCompleteText_DataInput,
                "Integer0": IntegerEditor,
                "Integer2": IntegerEditor2,
                "Date": DateEditor,
                "YesNoSelect": YesNoSelectEditor,
                "Checkbox": CheckboxEditor,
                "PercentComplete": PercentCompleteEditor,
                "LongText": LongTextEditor,
                //sjan추가
                "SelectCellEditor": SelectCellEditor,
                //조선만 추가
                "RequirementSelectEditor": RequirementSelectEditor,
                "SpecFieldGroupSelectEditor": SpecFieldGroupSelectEditor,
                "SpecFieldOptionSelect": SpecFieldOptionSelectEditor,
                "TestResultSelect": TestResultSelectEditor,
                "TestRequirementSelect": TestRequirementSelectEditor,
                "TestRequirementSelect_ENG": TestRequirementSelectEditor_ENG,
                //sjan추가
                "SelectEditFormatter": SelectEditFormatter,

                "TestMethod": TestMethodSelectEditor,           // Note - Test에 속한 Method Combo
                "TestUnit": TestUnitSelectEditor,           // Note - Test에 속한 Method Combo
                "TestSubMethod": TestSubMethodSelectEditor,     // Note - Method에 속한 SubMethod Combo
                "TestRemark": TestRemarkSelectEditor,           // Note - Test에 속한 Remark Combo

                "TestMethod_ENG": TestMethodSelectEditor_ENG,           // Note - Test_ENG에 속한 Method Combo
                "TestSubMethod_ENG": TestSubMethodSelectEditor_ENG,     // Note - Method_ENG에 속한 SubMethod Combo
                "TestRemark_ENG": TestRemarkSelectEditor_ENG,           // Note - Test_ENG에 속한 Remark Combo

                "Alphabet": AlphabetSelectEditor,                // Note - Alphabet Combo
            }
        }
    });

    //데이터 INPUT에서 사용될 Result Editor
    function TestRequirementSelectEditor(args) {
        var $select;
        var $text;
        var defaultValue = '';
        var scope = this;

        //테스트ID, Cust ID, ParamSEQ를 가지고 파라미터 Requirement를 조회
        var TEST_CODE = args.item["TEST_CODE"]; //시험코드번호
        //var FieldCode = args.item["FLD_CODE"];//Field코드
        //var FieldLength = args.item["FLD_LEN"];//Field길이
        //var FieldType = args.item["INPUT_CLS"];


        var FieldOptionData = [];

        //접수번호와 필드코드를 가지고 SpecField Option을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Textile_Servie.asmx/GetTestRequirement",
            async: false,
            contentType: "application/json; charset=utf-8",
            data: "{TEST_CODE:'" + TEST_CODE + "'}",
            dataType: "json",
            success: function (response) {
                FieldOptionData = jQuery.parseJSON(response.d).DATA;
            },
            failure: function (response) {
                alert(response.d);
            },
            error: function (response) {
                alert(response.d);
            }
        });

        var OptionText = '<OPTION value="">-</OPTION>';


        //OPTION TEXT 생성
        jQuery.each(FieldOptionData, function (index, val) {
            OptionText += "<OPTION value=" + val.REQUIREMENT_VALUE + ">" + val.REQUIREMENT_VALUE + "</OPTION>";
            if (val.DEFAULT_YN == "Y") {
                defaultValue = val.REQUIREMENT_VALUE;
            }
        });

        //기존에 셋팅된 그룹코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (defaultValue == '') {
            if (FieldOptionData.length > 0) {
                defaultValue = FieldOptionData[0].REQUIREMENT_VALUE;
            }
        }

        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
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
            if (defaultValue != '') {
                $select.val(defaultValue);
                $select.select();
            }
        };

        this.serializeValue = function () {
            return $select.find('option:selected').text();
        };

        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };

        this.isValueChanged = function () {
            return true;
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };
        this.init();
    }

    //데이터 INPUT에서 사용될 Result Editor
    function TestRequirementSelectEditor_ENG(args) {
        var $select;
        var $text;
        var defaultValue = '';
        var scope = this;

        //테스트ID, Cust ID, ParamSEQ를 가지고 파라미터 Requirement를 조회
        var TEST_CODE = args.item["TEST_CODE"]; //시험코드번호
        //var FieldCode = args.item["FLD_CODE"];//Field코드
        //var FieldLength = args.item["FLD_LEN"];//Field길이
        //var FieldType = args.item["INPUT_CLS"];


        var FieldOptionData = [];

        //접수번호와 필드코드를 가지고 SpecField Option을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Textile_Servie.asmx/GetTestRequirement",
            async: false,
            contentType: "application/json; charset=utf-8",
            data: "{TEST_CODE:'" + TEST_CODE + "'}",
            dataType: "json",
            success: function (response) {
                FieldOptionData = jQuery.parseJSON(response.d).DATA;
            },
            failure: function (response) {
                alert(response.d);
            },
            error: function (response) {
                alert(response.d);
            }
        });

        var OptionText = '<OPTION value="">-</OPTION>';


        //OPTION TEXT 생성
        jQuery.each(FieldOptionData, function (index, val) {
            OptionText += "<OPTION value=" + val.REQUIREMENT_VALUE_ENG + ">" + val.REQUIREMENT_VALUE_ENG + "</OPTION>";
            if (val.DEFAULT_YN == "Y") {
                defaultValue = val.REQUIREMENT_VALUE_ENG;
            }
        });

        //기존에 셋팅된 그룹코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (defaultValue == '') {
            if (FieldOptionData.length > 0) {
                defaultValue = FieldOptionData[0].REQUIREMENT_VALUE_ENG;
            }
        }

        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
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
            if (defaultValue != '') {
                $select.val(defaultValue);
                $select.select();
            }
        };

        this.serializeValue = function () {
            return $select.find('option:selected').text();
        };

        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };

        this.isValueChanged = function () {
            return true;
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };
        this.init();
    }


    //데이터 INPUT에서 사용될 Result Editor
    function TestResultSelectEditor(args) {
        var $select;
        var $text;
        var defaultValue = '';
        var scope = this;

        //테스트ID, Cust ID, ParamSEQ를 가지고 파라미터 Requirement를 조회
        //var REQNUM = args.item["REQ_NUM"]; //접수번호
        //var FieldCode = args.item["FLD_CODE"];//Field코드
        //var FieldLength = args.item["FLD_LEN"];//Field길이
        //var FieldType = args.item["INPUT_CLS"];


        var FieldOptionData = [];

        //접수번호와 필드코드를 가지고 SpecField Option을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Textile_Servie.asmx/GetTestResult_Type",
            async: false,
            contentType: "application/json; charset=utf-8",
            //data: "{REQ_NUM:'" + REQ_NUM + "',FLD_CODE:'" + FieldCode + "'}",
            dataType: "json",
            success: function (response) {
                FieldOptionData = jQuery.parseJSON(response.d).DATA;
            },
            failure: function (response) {
                alert(response.d);
            },
            error: function (response) {
                alert(response.d);
            }
        });

        var OptionText = '<OPTION value="">-</OPTION>';


        //OPTION TEXT 생성
        jQuery.each(FieldOptionData, function (index, val) {
            OptionText += "<OPTION value=" + val.CMO_NAME + ">" + val.CMO_NAME + "</OPTION>";
            if (val.DEFAULT_YN == "Y") {
                defaultValue = val.OPT_VAL;
            }
        });

        //기존에 셋팅된 그룹코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (defaultValue == '') {
            if (FieldOptionData.length > 0) {
                defaultValue = FieldOptionData[0].OPT_VAL;
            }
        }

        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
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
            if (defaultValue != '') {
                $select.val(defaultValue);
                $select.select();
            }
        };

        this.serializeValue = function () {
            return $select.find('option:selected').text();
        };

        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };

        this.isValueChanged = function () {
            return true;
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };
        this.init();
    }

    //조선만 추가 BuyerSpecField에 옵션에따라 Dropdown과 TextBox를 선택하여 에디트
    //수정된 값을 다른 필드에 저장한 후 해당 필드의 값을 업데이트.
    function SpecFieldOptionSelectEditor(args) {
        var $select;
        var $text;
        var defaultValue = '';
        var scope = this;

        //테스트ID, Cust ID, ParamSEQ를 가지고 파라미터 Requirement를 조회
        var REQNUM = args.item["REQ_NUM"]; //접수번호
        var FieldCode = args.item["FLD_CODE"];//Field코드
        var FieldLength = args.item["FLD_LEN"];//Field길이
        var FieldType = args.item["INPUT_CLS"];


        //DropDown 에디터
        if (FieldType == 'FTS02') {
            var FieldOptionData = [];
            
            //접수번호와 필드코드를 가지고 SpecField Option을 가져옴.
            $.ajax({
                type: "POST",
                url: "/WebService/Textile_Servie.asmx/GetSpecFieldOption",
                async: false,
                contentType: "application/json; charset=utf-8",
                data: "{REQ_NUM:'" + REQ_NUM + "',FLD_CODE:'"+FieldCode+"'}",
                dataType: "json",
                success: function (response) {
                    FieldOptionData = jQuery.parseJSON(response.d).DATA;
                },
                failure: function (response) {
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });

            var OptionText = '<OPTION value="">-</OPTION>';
            

            //OPTION TEXT 생성
            jQuery.each(FieldOptionData, function (index, val) {
                OptionText += "<OPTION value=" + val.OPT_VAL + ">" + val.OPT_VAL + "</OPTION>";
                if (val.DEFAULT_YN == "Y") {
                    defaultValue = val.OPT_VAL;
                }
            });

            //기존에 셋팅된 그룹코드를 기본값으로 지정
            //셋팅값이 없을경우 최초 값을 기본선택으로 지정
            if (defaultValue == '') {
                if (FieldOptionData.length > 0) {
                    defaultValue = FieldOptionData[0].OPT_VAL;
                }
            }
         
            this.init = function () {
                $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
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
                if (defaultValue != '') {
                    $select.val(defaultValue);
                    $select.select();
                }
            };

            this.serializeValue = function () {
                return $select.find('option:selected').text();
            };

            this.applyValue = function (item, state) {
                item[args.column.field] = state;
            };

            this.isValueChanged = function () {
                return true;
            };


            this.validate = function () {
                return {
                    valid: true,
                    msg: null
                };
            };
        }
        else {
            var $input;
            var defaultValue;
            var scope = this;


            this.init = function () {
                $input = $("<INPUT type=text class='editor-text' />")
                    .appendTo(args.container)
                    .bind("keydown.nav", function (e) {
                        if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
                            e.stopImmediatePropagation();
                        }
                    })
                    .focus()
                    .select();
            };


            this.destroy = function () {
                $input.remove();
            };


            this.focus = function () {
                $input.focus();
            };


            this.getValue = function () {
                return $input.val();
            };


            this.setValue = function (val) {
                $input.val(val);
            };


            this.loadValue = function (item) {
                defaultValue = item[args.column.field] || "";
                $input.val(defaultValue);
                $input[0].defaultValue = defaultValue;
                $input.select();
            };


            this.serializeValue = function () {
                return $input.val();
            };


            this.applyValue = function (item, state) {
                item[args.column.field] = state;
            };


            this.isValueChanged = function () {
                return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
            };


            this.validate = function () {
                if (args.column.validator) {
                    var validationResults = args.column.validator($input.val());
                    if (!validationResults.valid) {
                        return validationResults;
                    }
                }


                return {
                    valid: true,
                    msg: null
                };
            };
        }
        this.init();
    }

    //조선만 추가 접수건별 BuyerSpecField Group을 DropDown형태로 Editor하기 위함.
    function SpecFieldGroupSelectEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;

        
        var REQNUM = args.item["REQ_NUM"]; //접수번호
        var GroupCode = args.item["FLD_GROUP_CODE"];//그룹코드
        var GroupName = args.item["FLD_GROUP_NAME"];//그룹명
       

        var FieldGroup = [];
        var OptionText = '';

        //접수번호를 가지고 SpecField Group을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Textile_Servie.asmx/GetBuyerSpecFieldGroup",
            async:false,
            contentType: "application/json; charset=utf-8",
            data: "{REQ_NUM:'" + REQ_NUM +  "'}",
            dataType: "json",
            success: function (response) {
                FieldGroup = jQuery.parseJSON(response.d).DATA;
            },
            failure: function (response) {
                alert(response.d);
            },
            error: function (response) {
                alert(response.d);
            }
        });

        //기존에 셋팅된 그룹코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (GroupCode == null) {
            defaultValue = FieldGroup[0].FLD_GROUP_CODE;
        }
        else {
            defaultValue = GroupCode;
        }

        //OPTION TEXT 생성
        jQuery.each(FieldGroup, function (index, val) {
            OptionText += "<OPTION value=" + val.FLD_GROUP_CODE + ">" + val.FLD_GROUP_NAME + "</OPTION>";
        });

        //에디터 생성
        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
            $select.appendTo(args.container);
            $select.focus();
        };

        //에디터에서 focus가 빠졌을경우 에디터를 삭제
        this.destroy = function () {
            $select.remove();
        };


        this.focus = function () {
            $select.focus();
        };

        //초기값셋팅
        this.loadValue = function (item) {
            $select.val(defaultValue);
            $select.select();
        };

        //초기 로드될떄 생성됨 사용처는 아직 잘 모르겠음.
        this.serializeValue = function () {
            return $select.val();
        };

        //기존선택값이 변경되었을경우 데이터 수정
        this.applyValue = function (item, state) {
            item[args.column.field] = $select.find('option:selected').text();
            item["FLD_GROUP_CODE"] = state;
        };

        //기존값이 변경되었는지 확인
        this.isValueChanged = function () {
            return true;//($select.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();
    }


    //조선만 추가 파라미터별 Requirement조건을 가져오기 위함.
    function RequirementSelectEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;
        //테스트ID, Cust ID, ParamSEQ를 가지고 파라미터 Requirement를 조회
        var OptionValue = "1,345345,234234234,123123";

        var OptionText = '';

        for (var i = 0; i < OptionValue.split(',').length; i++) {
            OptionText += "<OPTION value=" + OptionValue.split(',')[i] + ">" + OptionValue.split(',')[i] + "</OPTION>";
        }

        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-yesno'>" + OptionText + "</SELECT>");
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
            $select.val((defaultValue = item[args.column.field]) ? "yes" : "no");
            $select.select();
        };


        this.serializeValue = function () {
            return ($select.val() == "yes");
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


    //sjan 추가
    function SelectCellEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;

        this.init = function () {

            if (args.column.options) {
                opt_values = args.column.options.split(',');
            } else {
                opt_values = "yes,no".split(',');
            }
            option_str = ""
            for (i in opt_values) {
                v = opt_values[i];
                option_str += "<OPTION value='" + v + "'>" + v + "</OPTION>";
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





    // 안상진 수정 Remark 
    function SelectEditFormatter(args) {
        var $select;
        var $text;
        var defaultValue = args.item["Type"];
        var scope = this;

        var OptionData = [];

        //DropDown 에디터
        if (args.column.field == 'Remark') {
            //WorkSheet Remark option을 가져옴.
            $.ajax({
                type: "POST",
                url: "/WebService/Textile_Servie.asmx/GetRemarkSelect",
                async: false,
                contentType: "application/json; charset=utf-8",
                data: "",
                dataType: "json",
                success: function (response) {
                    OptionData = jQuery.parseJSON(response.d).DATA;
                },
                failure: function (response) {
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });
        }
        else if (args.column.field == 'Type') {
                //Finance Bank option을 가져옴.
                $.ajax({
                type: "POST",
                url: "/WebService/Textile_Servie.asmx/GetFinanceBank",
                async: false,
                contentType: "application/json; charset=utf-8",
                data: "",
                dataType: "json",
                success: function (response) {
                            OptionData = jQuery.parseJSON(response.d).DATA;
                },
                    failure: function (response) {
                            alert(response.d);
                },
                    error: function (response) {
                            alert(response.d);
                }
                });
        }
            var OptionText = '<OPTION value=""></OPTION>';


            //OPTION TEXT 생성
            jQuery.each(OptionData, function (index, val) {
                OptionText += "<OPTION value=" + val.CMO_NAME + ">" + val.CMO_NAME + "</OPTION>";
            });

            //기존에 셋팅된 그룹코드를 기본값으로 지정
            //셋팅값이 없을경우 최초 값을 기본선택으로 지정
            if (defaultValue == '') {
                if (OptionData.length > 0) {
                    defaultValue = '';
                }
            }


            this.init = function () {
                $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
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
                if (defaultValue != '') {
                    $select.val(defaultValue);
                    $select.select();
                }
            };

            this.serializeValue = function () {
                return $select.find('option:selected').text();
            };

            this.applyValue = function (item, state) {
                item[args.column.field] = state;
            };

            this.isValueChanged = function () {
                return true;
            };


            this.validate = function () {
                return {
                    valid: true,
                    msg: null
                };
            };

        
        this.init();
    }


    // Note - 알파벳 Combo
    function AlphabetSelectEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;


        // Note - 변수값 설정
        var strPartialCode = args.item["PARTIAL_CODE"];
        
        var AlphabetList = [{ "CODE": "" }, { "CODE": "A" }, { "CODE": "B" }, { "CODE": "C" }, { "CODE": "D" }, { "CODE": "E" }, { "CODE": "F" }, { "CODE": "G" }, { "CODE": "H" }, { "CODE": "I" }, { "CODE": "J" }, { "CODE": "K" }, { "CODE": "L" }, { "CODE": "M" }, { "CODE": "O" }, { "CODE": "P" }, { "CODE": "Q" }, { "CODE": "R" }, { "CODE": "S" }, { "CODE": "T" }, { "CODE": "U" }, { "CODE": "V" }, { "CODE": "W" }, { "CODE": "X" }, { "CODE": "Y" }, { "CODE": "Z" }];
        var OptionText = "";

        
        //기존에 셋팅된 메서드코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (strPartialCode == null) {
            if (AlphabetList.length > 0)
                defaultValue = AlphabetList[0].PARTIAL_CODE;
            else
                defaultValue = "";
        }
        else {
            defaultValue = strPartialCode;
        }

        //OPTION TEXT 생성
        jQuery.each(AlphabetList, function (index, val) {
            OptionText += "<OPTION value=" + val.CODE + ">" + val.CODE + "</OPTION>";
        });

        //에디터 생성
        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
            $select.appendTo(args.container);
            $select.focus();
        };

        //에디터에서 focus가 빠졌을경우 에디터를 삭제
        this.destroy = function () {
            $select.remove();
        };


        this.focus = function () {
            $select.focus();
        };

        //초기값셋팅
        this.loadValue = function (item) {
            $select.val(defaultValue);
            $select.select();
        };

        //초기 로드될떄 생성됨 사용처는 아직 잘 모르겠음.
        this.serializeValue = function () {
            return $select.val();
        };

        //기존선택값이 변경되었을경우 데이터 수정
        this.applyValue = function (item, state) {
            item[args.column.field] = $select.find('option:selected').text();
            item["PARTIAL_CODE"] = state;
        };

        //기존값이 변경되었는지 확인
        this.isValueChanged = function () {
            return true;//($select.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();
    }

    // Note - Test(Method)에 속한 Method(SubMethod) Combo
    function TestMethodSelectEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;

        var strMethodCode = args.item["METHOD_ID"];
        // Note - 변수값 설정
        var Gparam = {
            IV_TEST_ID : args.item["TEST_ID"]
        }

        var MethodList = [];
        var OptionText = "";

        //접수번호를 가지고 SpecField Group을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Common_Service.asmx/GetTestMethodComboList",
            contentType: "application/json; charset=utf-8",
            async: false,
            data: JSON.stringify({ "Gparam": Gparam }),
            dataType: "json",
            success: function (response) {
                MethodList = $.parseJSON(response.d).result;
            },
            failure: function (response) {
//                alert(response.d);
            },
            error: function (response) {
 //               alert(response.d);
            }
        });

        //기존에 셋팅된 메서드코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (strMethodCode == null) {
            if (MethodList != null) {
                if (MethodList.length > 0)
                    defaultValue = MethodList[0].METHOD_ID;
                else
                    defaultValue = "";
            }
            else
                defaultValue = "";
        }
        else {
            defaultValue = strMethodCode;
        }

        //OptionText = "<OPTION value=''></OPTION>";

        //OPTION TEXT 생성
        for (var i = 0; i < MethodList.length; i++) {
            OptionText += "<OPTION value=" + MethodList[i].METHOD_ID + " selected >" + MethodList[i].METHOD_NM + "</OPTION>";
        }
        
        //에디터 생성
        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
            $select.appendTo(args.container);
            $select.focus();
        };

        //에디터에서 focus가 빠졌을경우 에디터를 삭제
        this.destroy = function () {
            $select.remove();
        };


        this.focus = function () {
            $select.focus();
        };

        //초기값셋팅
        this.loadValue = function (item) {
            $select.val(defaultValue);
            $select.select();
        };

        //초기 로드될떄 생성됨 사용처는 아직 잘 모르겠음.
        this.serializeValue = function () {
            return $select.val();
        };

        //기존선택값이 변경되었을경우 데이터 수정
        this.applyValue = function (item, state) {
            item[args.column.field] = $select.find('option:selected').text();
            item["METHOD_ID"] = state;
        };

        //기존값이 변경되었는지 확인
        this.isValueChanged = function () {
            return true;//($select.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();
    }

    // Note - Test(Method)에 속한 Method(SubMethod) Combo
    function TestUnitSelectEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;

        var strMethodCode = args.item["UNIT_ID"];
        // Note - 변수값 설정
        var Gparam = {
            IV_TEST_ID: args.item["TEST_ID"]
        }

        var UnitList = [];
        var OptionText = "";

        //접수번호를 가지고 SpecField Group을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Common_Service.asmx/GetTestUnitComboList",
            contentType: "application/json; charset=utf-8",
            async: false,
            data: JSON.stringify({ "Gparam": Gparam }),
            dataType: "json",
            success: function (response) {
                UnitList = $.parseJSON(response.d).result;
            },
            failure: function (response) {
                //                alert(response.d);
            },
            error: function (response) {
                //               alert(response.d);
            }
        });

        //기존에 셋팅된 메서드코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (strMethodCode == null) {
            if (UnitList != null) {
                if (UnitList.length > 0)
                    defaultValue = UnitList[0].UNIT_ID;
                else
                    defaultValue = "";
            }
            else
                defaultValue = "";
        }
        else {
            defaultValue = strMethodCode;
        }

        //OptionText = "<OPTION value=''></OPTION>";

        //OPTION TEXT 생성
        for (var i = 0; i < UnitList.length; i++) {
            OptionText += "<OPTION value=" + UnitList[i].UNIT_ID + " selected >" + UnitList[i].UNIT_NM + "</OPTION>";
        }

        //에디터 생성
        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
            $select.appendTo(args.container);
            $select.focus();
        };

        //에디터에서 focus가 빠졌을경우 에디터를 삭제
        this.destroy = function () {
            $select.remove();
        };


        this.focus = function () {
            $select.focus();
        };

        //초기값셋팅
        this.loadValue = function (item) {
            $select.val(defaultValue);
            $select.select();
        };

        //초기 로드될떄 생성됨 사용처는 아직 잘 모르겠음.
        this.serializeValue = function () {
            return $select.val();
        };

        //기존선택값이 변경되었을경우 데이터 수정
        this.applyValue = function (item, state) {
            item[args.column.field] = $select.find('option:selected').text();
            item["UNIT_ID"] = state;
        };

        //기존값이 변경되었는지 확인
        this.isValueChanged = function () {
            return true;//($select.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();
    }


    // Note - TestMethod에 속한 SubMethod Combo
    function TestSubMethodSelectEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;


        // Note - 변수값 설정
        var strTestCode = args.item["TEST_CODE"];
        var strMethodCode = args.item["METHOD_CODE"];
        var strSubMethodCode = args.item["SUB_METHOD_CODE"];
        var strCustCode = args.item["CUST_CODE"];

        var strParam = "{"
                     + "strTestCode:" + "'" + strTestCode + "',"
                     + "strMethodCode:" + "'" + strMethodCode + "',"
                     + "strCustCode:" + "'" + strCustCode + "'"
                     + "}";

        var MethodList = [];
        var OptionText = "";

        //접수번호를 가지고 SpecField Group을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Textile_Servie.asmx/SelectTestMethodComboList",
            contentType: "application/json; charset=utf-8",
            async: false,
            data: strParam,
            dataType: "json",
            success: function (response) {
                MethodList = jQuery.parseJSON(response.d).DATA;
            },
            failure: function (response) {
                //alert(response.d);
            },
            error: function (response) {
                //alert(response.d);
            }
        });

        //기존에 셋팅된 메서드코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (strSubMethodCode == null) {
            if (MethodList.length > 0)
                defaultValue = MethodList[0].SUB_METHOD_CODE;
            else
                defaultValue = "";
        }
        else {
            defaultValue = strMethodCode;
        }

        OptionText = "<OPTION value=''></OPTION>";

        //OPTION TEXT 생성
        jQuery.each(MethodList, function (index, val) {
            OptionText += "<OPTION value=" + val.METHOD_CODE + " selected >" + val.METHOD_NAME + "</OPTION>";
        });

        //에디터 생성
        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
            $select.appendTo(args.container);
            $select.focus();
        };

        //에디터에서 focus가 빠졌을경우 에디터를 삭제
        this.destroy = function () {
            $select.remove();
        };


        this.focus = function () {
            $select.focus();
        };

        //초기값셋팅
        this.loadValue = function (item) {
            $select.val(defaultValue);
            $select.select();
        };

        //초기 로드될떄 생성됨 사용처는 아직 잘 모르겠음.
        this.serializeValue = function () {
            return $select.val();
        };

        //기존선택값이 변경되었을경우 데이터 수정
        this.applyValue = function (item, state) {
            item[args.column.field] = $select.find('option:selected').text();
            item["SUB_METHOD_CODE"] = state;
        };

        //기존값이 변경되었는지 확인
        this.isValueChanged = function () {
            return true;//($select.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();
    }

    // Note - TestMethod에 속한 Remark Combo
    function TestRemarkSelectEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;


        // Note - 변수값 설정
        var strTestCode = args.item["TEST_CODE"];
        var strCustCode = args.item["CUST_CODE"];

        var strParam = "{"
                     + "strTestCode:" + "'" + strTestCode + "',"
                     + "strCustCode:" + "'" + strCustCode + "'"
                     + "}";

        var RemakrList = [];
        var OptionText = "";

        //접수번호를 가지고 SpecField Group을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Intertek_Service.asmx/SelectTestRemarkComboList",
            contentType: "application/json; charset=utf-8",
            async: false,
            data: strParam,
            dataType: "json",
            success: function (response) {
                RemakrList = jQuery.parseJSON(response.d).DATA;
            },
            failure: function (response) {
                //alert(response.d);
            },
            error: function (response) {
                //alert(response.d);
            }
        });

        //기존에 셋팅된 메서드코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (strTestCode == null) {
            if (RemakrList.length > 0)
                defaultValue = RemakrList[0].RMK_SEQ;
            else
                defaultValue = "";
        }
        else {
            defaultValue = strTestCode;
        }

        OptionText = "<OPTION value=''></OPTION>";

        //OPTION TEXT 생성
        jQuery.each(RemakrList, function (index, val) {
            OptionText += "<OPTION value=" + val.RMK_SEQ + " selected >" + val.RMK + "</OPTION>";
        });

        

        //에디터 생성
        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
            $select.appendTo(args.container);
            $select.focus();
        };

        //에디터에서 focus가 빠졌을경우 에디터를 삭제
        this.destroy = function () {
            $select.remove();
        };


        this.focus = function () {
            $select.focus();
        };

        //초기값셋팅
        this.loadValue = function (item) {
            $select.val(defaultValue);
            $select.select();
        };

        //초기 로드될떄 생성됨 사용처는 아직 잘 모르겠음.
        this.serializeValue = function () {
            return $select.val();
        };

        //기존선택값이 변경되었을경우 데이터 수정
        this.applyValue = function (item, state) {
            item[args.column.field] = $select.find('option:selected').text();
            item["RMK_SEQ"] = state;
        };

        //기존값이 변경되었는지 확인
        this.isValueChanged = function () {
            return true;//($select.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();
    }


    // Note - Test(Method)에 속한 Method(SubMethod) Combo
    function TestMethodSelectEditor_ENG(args) {
        var $select;
        var defaultValue;
        var scope = this;


        // Note - 변수값 설정
        var strTestCode = args.item["TEST_CODE"];
        var strMethodCode = args.item["METHOD_CODE"];
        var strCustCode = args.item["CUST_CODE"];

        var strParam = "{"
                     + "strTestCode:" + "'" + strTestCode + "',"
                     + "strMethodCode:" + "'',"
                     + "strCustCode:" + "'" + strCustCode + "'"
                     + "}";

        var MethodList = [];
        var OptionText = "";

        //접수번호를 가지고 SpecField Group을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Textile_Servie.asmx/SelectTestMethodComboList",
            contentType: "application/json; charset=utf-8",
            async: false,
            data: strParam,
            dataType: "json",
            success: function (response) {
                MethodList = jQuery.parseJSON(response.d).DATA;
            },
            failure: function (response) {
                //                alert(response.d);
            },
            error: function (response) {
                //               alert(response.d);
            }
        });

        //기존에 셋팅된 메서드코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (strMethodCode == null) {
            if (MethodList.length > 0)
                defaultValue = MethodList[0].METHOD_CODE;
            else
                defaultValue = "";
        }
        else {
            defaultValue = strMethodCode;
        }

        OptionText = "<OPTION value=''></OPTION>";

        //OPTION TEXT 생성
        jQuery.each(MethodList, function (index, val) {
            OptionText += "<OPTION value=" + val.METHOD_CODE + " selected >" + val.METHOD_NAME_ENG + "</OPTION>";
        });



        //에디터 생성
        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
            $select.appendTo(args.container);
            $select.focus();
        };

        //에디터에서 focus가 빠졌을경우 에디터를 삭제
        this.destroy = function () {
            $select.remove();
        };


        this.focus = function () {
            $select.focus();
        };

        //초기값셋팅
        this.loadValue = function (item) {
            $select.val(defaultValue);
            $select.select();
        };

        //초기 로드될떄 생성됨 사용처는 아직 잘 모르겠음.
        this.serializeValue = function () {
            return $select.val();
        };

        //기존선택값이 변경되었을경우 데이터 수정
        this.applyValue = function (item, state) {
            item[args.column.field] = $select.find('option:selected').text();
            item["METHOD_CODE"] = state;
        };

        //기존값이 변경되었는지 확인
        this.isValueChanged = function () {
            return true;//($select.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();
    }


    // Note - TestMethod에 속한 SubMethod Combo
    function TestSubMethodSelectEditor_ENG(args) {
        var $select;
        var defaultValue;
        var scope = this;


        // Note - 변수값 설정
        var strTestCode = args.item["TEST_CODE"];
        var strMethodCode = args.item["METHOD_CODE"];
        var strSubMethodCode = args.item["SUB_METHOD_CODE"];
        var strCustCode = args.item["CUST_CODE"];

        var strParam = "{"
                     + "strTestCode:" + "'" + strTestCode + "',"
                     + "strMethodCode:" + "'" + strMethodCode + "',"
                     + "strCustCode:" + "'" + strCustCode + "'"
                     + "}";

        var MethodList = [];
        var OptionText = "";

        //접수번호를 가지고 SpecField Group을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Textile_Servie.asmx/SelectTestMethodComboList",
            contentType: "application/json; charset=utf-8",
            async: false,
            data: strParam,
            dataType: "json",
            success: function (response) {
                MethodList = jQuery.parseJSON(response.d).DATA;
            },
            failure: function (response) {
                //alert(response.d);
            },
            error: function (response) {
                //alert(response.d);
            }
        });

        //기존에 셋팅된 메서드코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (strSubMethodCode == null) {
            if (MethodList.length > 0)
                defaultValue = MethodList[0].SUB_METHOD_CODE;
            else
                defaultValue = "";
        }
        else {
            defaultValue = strMethodCode;
        }

        OptionText = "<OPTION value=''></OPTION>";

        //OPTION TEXT 생성
        jQuery.each(MethodList, function (index, val) {
            OptionText += "<OPTION value=" + val.METHOD_CODE + " selected >" + val.METHOD_NAME_ENG + "</OPTION>";
        });

        //에디터 생성
        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
            $select.appendTo(args.container);
            $select.focus();
        };

        //에디터에서 focus가 빠졌을경우 에디터를 삭제
        this.destroy = function () {
            $select.remove();
        };


        this.focus = function () {
            $select.focus();
        };

        //초기값셋팅
        this.loadValue = function (item) {
            $select.val(defaultValue);
            $select.select();
        };

        //초기 로드될떄 생성됨 사용처는 아직 잘 모르겠음.
        this.serializeValue = function () {
            return $select.val();
        };

        //기존선택값이 변경되었을경우 데이터 수정
        this.applyValue = function (item, state) {
            item[args.column.field] = $select.find('option:selected').text();
            item["SUB_METHOD_CODE"] = state;
        };

        //기존값이 변경되었는지 확인
        this.isValueChanged = function () {
            return true;//($select.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();
    }

    // Note - TestMethod에 속한 Remark Combo
    function TestRemarkSelectEditor_ENG(args) {
        var $select;
        var defaultValue;
        var scope = this;


        // Note - 변수값 설정
        var strTestCode = args.item["TEST_CODE"];
        var strCustCode = args.item["CUST_CODE"];

        var strParam = "{"
                     + "strTestCode:" + "'" + strTestCode + "',"
                     + "strCustCode:" + "'" + strCustCode + "'"
                     + "}";

        var RemakrList = [];
        var OptionText = "";

        //접수번호를 가지고 SpecField Group을 가져옴.
        $.ajax({
            type: "POST",
            url: "/WebService/Intertek_Service.asmx/SelectTestRemarkComboList",
            contentType: "application/json; charset=utf-8",
            async: false,
            data: strParam,
            dataType: "json",
            success: function (response) {
                RemakrList = jQuery.parseJSON(response.d).DATA;
            },
            failure: function (response) {
                //alert(response.d);
            },
            error: function (response) {
                //alert(response.d);
            }
        });

        //기존에 셋팅된 메서드코드를 기본값으로 지정
        //셋팅값이 없을경우 최초 값을 기본선택으로 지정
        if (strTestCode == null) {
            if (RemakrList.length > 0)
                defaultValue = RemakrList[0].RMK_SEQ;
            else
                defaultValue = "";
        }
        else {
            defaultValue = strTestCode;
        }

        OptionText = "<OPTION value=''></OPTION>";

        //OPTION TEXT 생성
        jQuery.each(RemakrList, function (index, val) {
            OptionText += "<OPTION value=" + val.RMK_SEQ + " selected >" + val.RMK_ENG + "</OPTION>";
        });



        //에디터 생성
        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
            $select.appendTo(args.container);
            $select.focus();
        };

        //에디터에서 focus가 빠졌을경우 에디터를 삭제
        this.destroy = function () {
            $select.remove();
        };


        this.focus = function () {
            $select.focus();
        };

        //초기값셋팅
        this.loadValue = function (item) {
            $select.val(defaultValue);
            $select.select();
        };

        //초기 로드될떄 생성됨 사용처는 아직 잘 모르겠음.
        this.serializeValue = function () {
            return $select.val();
        };

        //기존선택값이 변경되었을경우 데이터 수정
        this.applyValue = function (item, state) {
            item[args.column.field] = $select.find('option:selected').text();
            item["RMK_SEQ"] = state;
        };

        //기존값이 변경되었는지 확인
        this.isValueChanged = function () {
            return true;//($select.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();
    }


    function TextEditor(args) {
        var $input;
        var defaultValue;
        var scope = this;

        this.init = function () {
            $input = $("<INPUT type=text class='editor-text' />")
                .appendTo(args.container)
                .bind("keydown.nav", function (e) {
                    if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
                        e.stopImmediatePropagation();
                    }
                })
                .focus()
                .select();
        };


        this.destroy = function () {
            $input.remove();
        };


        this.focus = function () {
            $input.focus();
        };


        this.getValue = function () {
            return $input.val();
        };


        this.setValue = function (val) {
            $input.val(val);
        };


        this.loadValue = function (item) {
            defaultValue = item[args.column.field] || "";
            $input.val(defaultValue);
            $input[0].defaultValue = defaultValue;
            $input.select();
        };


        this.serializeValue = function () {
            return $input.val();
        };


        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };


        this.isValueChanged = function () {
            //if ((!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue) == true) {
            //    //alert($input.val() + "////" + defaultValue);
            //    //BulkEdit(args.item.id, args.column.field, $input.val());
            //}
            return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);           
        };


        this.validate = function () {
            if (args.column.validator) {
                var validationResults = args.column.validator($input.val());
                if (!validationResults.valid) {
                    return validationResults;
                }
            }


            return {
                valid: true,
                msg: null
            };
        };


        this.init();
    }


    function AutoCompleteText(args) {
        var $input;
        var defaultValue;
        var scope = this;

        
        var chkName = args.item["FLD_NAME"];

        var REQNUM = args.item["REQ_NUM"]; //접수번호
        var FieldCode = args.item["FLD_CODE"];//Field코드
        var FieldLength = args.item["FLD_LEN"];//Field길이
        var FieldType = args.item["INPUT_CLS"];
        
        //DropDown 에디터
        if (FieldType == 'FTS02') {
            var FieldOptionData = [];

            //접수번호와 필드코드를 가지고 SpecField Option을 가져옴.
            $.ajax({
                type: "POST",
                url: "/WebService/Textile_Servie.asmx/GetSpecFieldOption",
                async: false,
                contentType: "application/json; charset=utf-8",
                data: "{REQ_NUM:'" + REQ_NUM + "',FLD_CODE:'" + FieldCode + "'}",
                dataType: "json",
                success: function (response) {
                    FieldOptionData = jQuery.parseJSON(response.d).DATA;
                },
                failure: function (response) {
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });

            var OptionText = '<OPTION value="">-</OPTION>';


            //OPTION TEXT 생성
            jQuery.each(FieldOptionData, function (index, val) {
                OptionText += "<OPTION value=" + val.OPT_VAL + ">" + val.OPT_VAL + "</OPTION>";
                if (val.DEFAULT_YN == "Y") {
                    defaultValue = val.OPT_VAL;
                }
            });

            //기존에 셋팅된 그룹코드를 기본값으로 지정
            //셋팅값이 없을경우 최초 값을 기본선택으로 지정
            if (defaultValue == '') {
                if (FieldOptionData.length > 0) {
                    defaultValue = FieldOptionData[0].OPT_VAL;
                }
            }

            this.init = function () {
                $select = $("<SELECT tabIndex='0' class='editor-select'>" + OptionText + "</SELECT>");
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
                if (defaultValue != '') {
                    $select.val(defaultValue);
                    $select.select();
                }
            };

            this.serializeValue = function () {
                return $select.find('option:selected').text();
            };

            this.applyValue = function (item, state) {
                item[args.column.field] = state;
            };

            this.isValueChanged = function () {
                return true;
            };


            this.validate = function () {
                return {
                    valid: true,
                    msg: null
                };
            };
        }
        else {


            //if (chkName.replace(' ', '').replace('.', '').toUpperCase() == "PONO")
            //{
            this.init = function () {
                if (chkName.replace(/ /gi, "").replace(".", "").toUpperCase() == "PONO") {
                    $input = $("<INPUT type=text id='auto' class='editor-text' onfocus='SetAutoComplete(this.id)' />")
                        .appendTo(args.container)
                        .bind("keydown.nav", function (e) {
                            if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
                                e.stopImmediatePropagation();
                            }
                            if ((e.keyCode == $.ui.keyCode.DOWN || e.keyCode == $.ui.keyCode.UP) && $('ul.ui-autocomplete').is(':visible'))
                                e.stopPropagation();
                        })
                        .focus()
                        .select();
                }
                else {
                    $input = $("<INPUT type=text id='nonAuto' class='editor-text' />")
                        .appendTo(args.container)
                        .bind("keydown.nav", function (e) {
                            if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
                                e.stopImmediatePropagation();
                            }
                            if ((e.keyCode == $.ui.keyCode.DOWN || e.keyCode == $.ui.keyCode.UP) && $('ul.ui-autocomplete').is(':visible'))
                                e.stopPropagation();
                        })
                        .focus()
                        .select();
                }
            };


            this.destroy = function () {
                $input.remove();
            };


            this.focus = function () {
                $input.focus();
            };


            this.getValue = function () {
                return $input.val();
            };


            this.setValue = function (val) {
                $input.val(val);
            };


            this.loadValue = function (item) {
                defaultValue = item[args.column.field] || "";
                $input.val(defaultValue);
                $input[0].defaultValue = defaultValue;
                $input.select();
            };


            this.serializeValue = function () {
                return $input.val();
            };


            this.applyValue = function (item, state) {
                item[args.column.field] = state;
            };


            this.isValueChanged = function () {
                //if ((!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue) == true) {
                //    //alert($input.val() + "////" + defaultValue);
                //    //BulkEdit(args.item.id, args.column.field, $input.val());
                //}
                return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
            };


            this.validate = function () {
                if (args.column.validator) {
                    var validationResults = args.column.validator($input.val());
                    if (!validationResults.valid) {
                        return validationResults;
                    }
                }


                return {
                    valid: true,
                    msg: null
                };
            };
        }

        this.init();

        
    }


    function AutoCompleteText_DataInput(args) {
        var $input;
        var defaultValue;
        var scope = this;

        this.init = function () {
            $input = $("<INPUT type=text id='auto' class='editor-text' onfocus='SetAutoComplete(this.id)' />")
                .appendTo(args.container)
                .bind("keydown.nav", function (e) {
                    if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
                        e.stopImmediatePropagation();
                    }
                    if ((e.keyCode == $.ui.keyCode.DOWN || e.keyCode == $.ui.keyCode.UP) && $('ul.ui-autocomplete').is(':visible'))
                        e.stopPropagation();
                })
                .focus()
                .select();
        };

        this.destroy = function () {
            $input.remove();
        };


        this.focus = function () {
            $input.focus();
        };


        this.getValue = function () {
            return $input.val();
        };


        this.setValue = function (val) {
            $input.val(val);
        };


        this.loadValue = function (item) {
            defaultValue = item[args.column.field] || "";
            $input.val(defaultValue);
            $input[0].defaultValue = defaultValue;
            $input.select();
        };


        this.serializeValue = function () {
            return $input.val();
        };


        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };


        this.isValueChanged = function () {
            //if ((!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue) == true) {
            //    //alert($input.val() + "////" + defaultValue);
            //    //BulkEdit(args.item.id, args.column.field, $input.val());
            //}
            return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
        };


        this.validate = function () {
            if (args.column.validator) {
                var validationResults = args.column.validator($input.val());
                if (!validationResults.valid) {
                    return validationResults;
                }
            }


            return {
                valid: true,
                msg: null
            };
        };

        this.init();

    }

    function IntegerEditor(args) {
        var $input;
        var defaultValue;
        var scope = this;


        this.init = function () {
            $input = $("<INPUT type=text class='editor-text text-right' />");


            $input.bind("keydown.nav", function (e) {
                if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
                    e.stopImmediatePropagation();
                }
            });


            $input.appendTo(args.container);
            $input.focus().select();
        };


        this.destroy = function () {
            $input.remove();
        };


        this.focus = function () {
            $input.focus();
        };


        this.loadValue = function (item) {
            defaultValue = item[args.column.field];
            $input.val(defaultValue);
            $input[0].defaultValue = defaultValue;
            $input.select();
        };


        this.serializeValue = function () {
            return $.number($input.val(), 0);// parseInt($input.val(), 10) || 0;
        };


        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };


        this.isValueChanged = function () {
            return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
        };


        this.validate = function () {
            if (isNaN($input.val())) {
                return {
                    valid: false,
                    msg: "Please enter a valid integer"
                };
            }


            return {
                valid: true,
                msg: null
            };
        };


        this.init();
    }
    function IntegerEditor2(args) {
        var $input;
        var defaultValue;
        var scope = this;


        this.init = function () {
            $input = $("<INPUT type=text class='editor-text' />");


            $input.bind("keydown.nav", function (e) {
                if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
                    e.stopImmediatePropagation();
                }
            });


            $input.appendTo(args.container);
            $input.focus().select();
        };


        this.destroy = function () {
            $input.remove();
        };


        this.focus = function () {
            $input.focus();
        };


        this.loadValue = function (item) {
            defaultValue = item[args.column.field];
            $input.val(defaultValue);
            $input[0].defaultValue = defaultValue;
            $input.select();
        };


        this.serializeValue = function () {
            return $.number($input.val(), 2);// parseInt($input.val(), 10) || 0;
        };


        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };


        this.isValueChanged = function () {
            return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
        };


        this.validate = function () {
            if (isNaN($input.val())) {
                return {
                    valid: false,
                    msg: "Please enter a valid integer"
                };
            }


            return {
                valid: true,
                msg: null
            };
        };


        this.init();
    }


    function DateEditor(args) {
        var $input;
        var defaultValue;
        var scope = this;
        var calendarOpen = false;


        this.init = function () {
            $input = $("<INPUT type=text class='editor-text text-right' readonly />");
            $input.appendTo(args.container);
            $input.focus().select();
            $input.datepicker({
                showOn: "button",
                changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
                changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
                buttonImageOnly: true,
                buttonImage: "/Common/Content/images/Icon/iconCalenda.gif",
                beforeShow: function () {
                    calendarOpen = true
                },
                onClose: function () {
                    calendarOpen = false
                }
            });
            $input.width($input.width() - 18);
        };


        this.destroy = function () {
            $.datepicker.dpDiv.stop(true, true);
            $input.datepicker("hide");
            $input.datepicker("destroy");
            $input.remove();
        };


        this.show = function () {
            if (calendarOpen) {
                $.datepicker.dpDiv.stop(true, true).show();
            }
        };


        this.hide = function () {
            if (calendarOpen) {
                $.datepicker.dpDiv.stop(true, true).hide();
            }
        };


        this.position = function (position) {
            if (!calendarOpen) {
                return;
            }
            $.datepicker.dpDiv
                .css("top", position.top + 30)
                .css("left", position.left);
        };


        this.focus = function () {
            $input.focus();
        };


        this.loadValue = function (item) {
            defaultValue = item[args.column.field];
            $input.val(defaultValue);
            $input[0].defaultValue = defaultValue;
            $input.select();
        };


        this.serializeValue = function () {
            return $input.val();
        };


        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };


        this.isValueChanged = function () {
            return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };


        this.init();
    }


    function YesNoSelectEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;


        this.init = function () {
            $select = $("<SELECT tabIndex='0' class='editor-yesno'><OPTION value='yes'>Yes</OPTION><OPTION value='no'>No</OPTION></SELECT>");
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
            $select.val((defaultValue = item[args.column.field]) ? "yes" : "no");
            $select.select();
        };


        this.serializeValue = function () {
            return ($select.val() == "yes");
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


    function CheckboxEditor(args) {
        var $select;
        var defaultValue;
        var scope = this;


        this.init = function () {
            $select = $("<INPUT type=checkbox value='true' class='editor-checkbox' hideFocus>");
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
            defaultValue = defaultValue == null ? 'N' : defaultValue;

            if (defaultValue.toUpperCase() == 'Y') {
                $select.prop('checked', true);
            } else {
                $select.prop('checked', false);
            }
        };


        this.serializeValue = function () {
            return $select.prop('checked');
        };


        this.applyValue = function (item, state) {
            if (state) {
                item[args.column.field] = 'Y';
            }
            else {
                item[args.column.field] = 'N';
            }
            
        };


        this.isValueChanged = function () {
            return (this.serializeValue() !== defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };


        this.init();
    }


    function PercentCompleteEditor(args) {
        var $input, $picker;
        var defaultValue;
        var scope = this;


        this.init = function () {
            $input = $("<INPUT type=text class='editor-percentcomplete' />");
            $input.width($(args.container).innerWidth() - 25);
            $input.appendTo(args.container);


            $picker = $("<div class='editor-percentcomplete-picker' />").appendTo(args.container);
            $picker.append("<div class='editor-percentcomplete-helper'><div class='editor-percentcomplete-wrapper'><div class='editor-percentcomplete-slider' /><div class='editor-percentcomplete-buttons' /></div></div>");


            $picker.find(".editor-percentcomplete-buttons").append("<button val=0>Not started</button><br/><button val=50>In Progress</button><br/><button val=100>Complete</button>");


            $input.focus().select();


            $picker.find(".editor-percentcomplete-slider").slider({
                orientation: "vertical",
                range: "min",
                value: defaultValue,
                slide: function (event, ui) {
                    $input.val(ui.value)
                }
            });


            $picker.find(".editor-percentcomplete-buttons button").bind("click", function (e) {
                $input.val($(this).attr("val"));
                $picker.find(".editor-percentcomplete-slider").slider("value", $(this).attr("val"));
            })
        };


        this.destroy = function () {
            $input.remove();
            $picker.remove();
        };


        this.focus = function () {
            $input.focus();
        };


        this.loadValue = function (item) {
            $input.val(defaultValue = item[args.column.field]);
            $input.select();
        };


        this.serializeValue = function () {
            return parseInt($input.val(), 10) || 0;
        };


        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };


        this.isValueChanged = function () {
            return (!($input.val() == "" && defaultValue == null)) && ((parseInt($input.val(), 10) || 0) != defaultValue);
        };


        this.validate = function () {
            if (isNaN(parseInt($input.val(), 10))) {
                return {
                    valid: false,
                    msg: "Please enter a valid positive number"
                };
            }


            return {
                valid: true,
                msg: null
            };
        };


        this.init();
    }


    /*
     * An example of a "detached" editor.
     * The UI is added onto document BODY and .position(), .show() and .hide() are implemented.
     * KeyDown events are also handled to provide handling for Tab, Shift-Tab, Esc and Ctrl-Enter.
     */
    function LongTextEditor(args) {
        var $input, $wrapper;
        var defaultValue;
        var scope = this;


        this.init = function () {
            var $container = $("body");


            $wrapper = $("<DIV style='z-index:10000;position:absolute;background:white;padding:5px;border:3px solid gray; -moz-border-radius:10px; border-radius:10px;'/>")
                .appendTo($container);


            $input = $("<TEXTAREA hidefocus rows=5 style='backround:white;width:250px;height:80px;border:0;outline:0'>")
                .appendTo($wrapper);


            $("<DIV style='text-align:right'><BUTTON>Save</BUTTON><BUTTON>Cancel</BUTTON></DIV>")
                .appendTo($wrapper);


            $wrapper.find("button:first").bind("click", this.save);
            $wrapper.find("button:last").bind("click", this.cancel);
            $input.bind("keydown", this.handleKeyDown);


            scope.position(args.position);
            $input.focus().select();
        };


        this.handleKeyDown = function (e) {
            if (e.which == $.ui.keyCode.ENTER && e.ctrlKey) {
                scope.save();
            } else if (e.which == $.ui.keyCode.ESCAPE) {
                e.preventDefault();
                scope.cancel();
            } else if (e.which == $.ui.keyCode.TAB && e.shiftKey) {
                e.preventDefault();
                args.grid.navigatePrev();
            } else if (e.which == $.ui.keyCode.TAB) {
                e.preventDefault();
                args.grid.navigateNext();
            }
        };


        this.save = function () {
            args.commitChanges();
        };


        this.cancel = function () {
            $input.val(defaultValue);
            args.cancelChanges();
        };


        this.hide = function () {
            $wrapper.hide();
        };


        this.show = function () {
            $wrapper.show();
        };


        this.position = function (position) {
            $wrapper
                .css("top", position.top - 5)
                .css("left", position.left - 5)
        };


        this.destroy = function () {
            $wrapper.remove();
        };


        this.focus = function () {
            $input.focus();
        };


        this.loadValue = function (item) {
            $input.val(defaultValue = item[args.column.field]);
            $input.select();
        };


        this.serializeValue = function () {
            return $input.val();
        };


        this.applyValue = function (item, state) {
            item[args.column.field] = state;
        };


        this.isValueChanged = function () {
            return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
        };


        this.validate = function () {
            return {
                valid: true,
                msg: null
            };
        };


        this.init();
    }

})(jQuery);

