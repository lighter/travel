$(function () {
  $(document).ajaxStart(function () {
    $('body').loading('start');
  }).ajaxStop(function () {
    $('body').loading('stop');
  });
});