// インストールしたファイルたちを呼び出します。
import { Calendar} from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import monthGridPlugin from '@fullcalendar/daygrid';
import googleCalendarApi from '@fullcalendar/google-calendar';

//<div id='calendar'></div>のidからオブジェクトを定義してカレンダーを作成

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    //　カレンダーの中身を設定(月表示、クリックアクションを起こす、googleCalendar使用)
    var calendar = new Calendar(calendarEl, {
        plugins: [ monthGridPlugin, interactionPlugin, googleCalendarApi ],

        events: '/events.json',　　 // イベントをjsonにて表示
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        firstDay: 1,
        headerToolbar: {
          start: '',
          center: 'title',
          end: 'today prev,next'
        },
        buttonText: {
           today: '今日'
        },
        allDayText: '終日',
        height: "auto",
        editable: true,  // イベントの移動
        displayEventTime: false,  // 時刻の非表示
        
        // イベントを移動した時の処理
        eventDrop: function(info) {
            $.ajax({
                type: 'PATCH',
                url: '/events/' + info.event.id,
                data: { start: info.event.start,
                        end: info.event.end
                },
            });
        },
        // イベントをクリックした時の処理
        eventClick: function(info) {
          if(confirm('削除しますか？'))  {
          $.ajax({
              type: 'DELETE',
              url: '/events/' + info.event.id,
            });
            info.event.remove();
          }
        },
        
        // 日付をクリックした時の処理
        dateClick: function(info) {
            $.ajax({
                type: 'GET',
                url:  '/events/new',
            }).done(function (res) {
                $('.modal-body').html(res);
            }).fail(function (result) {
                alert("failed");
            });
        }
    });
    //カレンダー表示
    calendar.render();

});