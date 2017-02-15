/**
 * Created by liteng on 2016/11/8.
 */


var AllSeconds = 86400*5;
var timer;
window.onload = function () {
    timer = window.setInterval(onTimer,1000);
};

function onTimer(year,month,day) {
    var now = new Date();
    var endDate = new Date(2016, 10, 15);
    var leftTime=endDate.getTime()/1000 -now.getTime()/1000;
    var dd = parseInt(leftTime  / 60 / 60 / 24, 10);//计算剩余的天数
    var hh = parseInt(leftTime  / 60 / 60 % 24, 10);//计算剩余的小时数
    var mm = parseInt(leftTime  / 60 % 60, 10);//计算剩余的分钟数
    var ss = parseInt(leftTime  % 60, 10);//计算剩余的秒数
    dd = checkTime(dd);
    hh = checkTime(hh);
    mm = checkTime(mm);
    ss = checkTime(ss);//小于10的话加0
    var dayText = document.getElementById('title-day');
    var hoursText = document.getElementById('title-hours');
    var minuteText = document.getElementById('title-minute');
    var secondsText = document.getElementById('title-seconds');

    dayText.innerText = ''+ dd;
    hoursText.innerText = '' + hh;
    minuteText.innerText = ''+ mm;
    secondsText.innerText = ''+ ss;
}

function checkTime(i)
{
    if (i < 10) {
        i = "0" + i;
    }
    return i;
}