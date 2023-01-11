<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Holiday.aspx.cs" Inherits="UI_CM_Holiday" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script>
        var ServiceUrl = "/WebService/UI_CM/Holiday_Service.asmx/";
        var calendar = {};
        //======================================================
        // Note - 페이지로드
        //======================================================
        $(document).ready(function () {
            calendar = $('#calendar').fullCalendar({
                header: {
                    right: 'prev,next today',
                    left: 'title',
                    //right: 'month,agendaWeek,agendaDay,listMonth'
                },
                height:750,
                selectable: true,
                selectHelper: true,
                editable: false,
                events: GetHoliDayList()
            });
        });

        //======================================================
        // Note - 휴일조회
        //======================================================
        function GetHoliDayList() {
            var eventsData = [];
            
            $.ajax({
                url: ServiceUrl + "GetHoliDayList",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: "json",
                async: false ,
                success: function (response) {
                    // Note - Json개체 변환
                    var jsonData = $.parseJSON(response.d);

                    // Note - Json개체 생성 유무 확인
                    if (jsonData != null) {
                        var dt = jsonData.result;
                        for (var i = 0; i < jsonData.result.length; i++) {
                            eventsData.push({
                                id: i + 1,
                                title: dt[i].HOLI_DESC,
                                start: dt[i].HOLI_DT,
                                color: '#f85d5d'
                            });
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

            return eventsData;
        }
    </script>
    <div class="tab-pane fade active in">
        <div class="panel panel-default">
            <div class="panel-heading form-horizontal">
                <button type="button" class="btn btn-primary btn-sm" data-toggle="confirmation" data-popout="true" id="btnSearch">
                    <span class="glyphicon glyphicon glyphicon-search"></span>&nbsp;Search
                </button>
            </div>
            <div class="panel-body form-horizontal">
                <%--form-group--%>
                <div class="col-xs-12 layout_dtl_page">
                    <div id='calendar'></div>
                </div>
            </div>
        </div>
    </div>
    
</asp:Content>

