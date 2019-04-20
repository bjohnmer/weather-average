// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require_tree .
//= require jquery3
//= require popper
//= require bootstrap-sprockets

$(document).ready(function() {
  $('#add').click(function(){
    if ($('#search').val() === ''){
      alert('You must type a city');
      return false;
    }
    axios.post('/api/v1/locations', {
      location: {
        city: $('#search').val()
      }
    })
    .then(function (response) {
      $('#locations').html(response.data.html_content);
      $('#response').html(response.data.response_data);
      $('#alert').removeClass('alert-danger')
                 .addClass('alert-success')
                 .removeClass('hide')
                 .addClass('show');
      $('#alert > span').html('Location created!');
    }, function (error) {
      $('#alert').removeClass('hide')
                 .addClass('show');
      $('#alert > span').html(error.response.data.message);
    });
    return false;
  })
})
