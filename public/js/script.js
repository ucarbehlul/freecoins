var success_function = function() {//{{{
  alert_html = "<div class='alert alert-success'>" +
    "<button type='button' class='close' data-dismiss='alert'>&times;</button>" +
    "Your transaction was successful, payouts are sent once every day." +
    "</div>";
  $('#alert-container').html(alert_html);
}//}}}
var error_functions = {//{{{
  bad_addr: function() {//{{{
    alert_html = "<div class='alert alert-error'>" +
      "<button type='button' class='close' data-dismiss='alert'>&times;</button>" +
      "Your Bitcoin address has already been used." +
      "</div>";
    $('#alert-container').html(alert_html);
  },//}}}
  bad_ip: function() {//{{{
    alert_html = "<div class='alert alert-error'>" +
      "<button type='button' class='close' data-dismiss='alert'>&times;</button>" +
      "A request with this IP address has already been sent." +
      "</div>";
    $('#alert-container').html(alert_html);
  }//}}}
}//}}}
var verifyCaptcha = function(text, sessionId, callback) {//{{{
  var success = false;
  $.ajax({
    url: "/captcha",
    dataType: "json",
    type: "post",
    data: {
      input: text,
    sessionId: sessionId
    },
    success: function(data) {
      $('#captcha-spinner').spin(false)
    console.log(data);
  if(data.success) {
    console.log("Captcha correct");
    $('span#captcha-spinner').html('<i class="icon-ok"></i>')
    callback(true);
  } else {
    console.log("Captcha incorrect");
    $('span#captcha-spinner').html('<i class="icon-remove"></i>')
    callback(false);
  }
    }
  });
}//}}}
var sendCoins = function(address) {//{{{
  console.log("sending coins to " + address);
  $.ajax({
    url: "/send",
    type: "post",
    dataType: "json",
    data: {
      address: address
    },
    success: function(data) {
      console.log(data);
      if(data.success) {
        $('span#address-spinner').html('<i class="icon-ok"></i>')
        success_function();
      } else {
        error_functions[data.error]();
        $('span#address-spinner').html('<i class="icon-remove"></i>')
      }
    }
  });
}//}}}
$(function($) {//{{{
  $('button#form-submit').on('click', function() {//{{{
    captchaText = $('input#captcha-input').val();
    bitcoinAddress = $('input#address-input').val();
    sessionId = $('img#captcha-image').attr('data-session_id');

    // Start spinner
    console.log("Start spinner...");
    if($('#captcha-spinner').length == 0) {
      $('div#captcha-input-container').addClass("input-append");
      $('<span class="add-on" id="captcha-spinner"></span>').insertAfter("input#captcha-input");
    } else {
      $('#captcha-spinner').html('');
    }

    $('span#captcha-spinner').spin("small");

    verifyCaptcha(captchaText, sessionId, function(success) {
      if(success == true) {
        if($('#address-spinner').length == 0) {
          $('div#address-input-container').addClass("input-append");
          $('<span class="add-on" id="address-spinner"></span>').insertAfter("input#address-input");
        } else {
          $('#address-spinner').html('');
        }

        $('span#address-spinner').spin("small");

        // Start spinner on Bitcoin address
        sendCoins(bitcoinAddress);
      }
    });
    return false;
  });//}}}
});//}}}
