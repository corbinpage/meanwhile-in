// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= bootstrap.min.js
//= require_self
 
       function changePic(path,username){
        $('#pic1').attr('alt',username);
        $('#pic1').attr('src',path);
        $('#pic1').load(function(){
          $('#waiting1').css('visibility','hidden');
        });
      }
      function changeTextbox(text){
        $('#textBox').val(text); 
        $('#textBox').focus();
      }
      function getNewPic() {
            $('#waiting1').css('visibility','visible');
            $.ajax({
                 type:'get', 
                 url: '/meanwhile/index', 
                 data: $.param({ text: $("#textBox").val(), refresh: true}),
                 timeout: 5000,
                 error: function(x, textStatus, m) {
                  $('#waiting1').css('visibility','hidden');
                  console.log(textStatus);
                 },
                 success: function (data) {
                  console.log(data);
                  changePic(data.url,data.username);
                  $('.caption').text(data.caption); 
                  changeTextbox(data.text);
                 }
            });
      }
      $('document').ready(function(){
        $('#waiting1').css('visibility','visible');
        $('#pic1').load(function(){
          $('#waiting1').css('visibility','hidden');
        });
        $('#textBox').keypress(function(e){
          if(e.which == 13){          //Enter key pressed
              $('#pic1').click();    //Trigger search button click event
          }
        });
      })