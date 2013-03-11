// This entire script is a general-purpose script dealing with
// nearly all the javascript done on the site, except for the
// graphs which is done in graphs.js

// This function is run once the transaction goes through successfully
// and shows a message confirming it.
var success_function = function() {//{{{
  alert_html = "<div class='alert alert-success'>" +
    "<button type='button' class='close' data-dismiss='alert'>&times;</button>" +
    "Your transaction was successful, payouts are sent once every day." +
    "</div>";
  $('#alert-container').html(alert_html);
}//}}}
// This object contains error functions that are run depending
// on what the type of error might be.
var error_functions = {//{{{
  // This one is run if the bitcoin address has been used twice.
  bad_addr: function() {//{{{
    alert_html = "<div class='alert alert-error'>" +
      "<button type='button' class='close' data-dismiss='alert'>&times;</button>" +
      "Your Bitcoin address has already been used." +
      "</div>";
    $('#alert-container').html(alert_html);
  },//}}}
  // And this one if the IP address has tried submitting a transaction
  // twice
  bad_ip: function() {//{{{
    alert_html = "<div class='alert alert-error'>" +
      "<button type='button' class='close' data-dismiss='alert'>&times;</button>" +
      "A request with this IP address has already been sent." +
      "</div>";
    $('#alert-container').html(alert_html);
  }//}}}
}//}}}
// This function is run first when the user submits the
// payout form to verify the captcha.
var verifyCaptcha = function(text, sessionId, callback) {//{{{
  // By default, it wasn't successful.
  var success = false;
  // The captcha works by sending a POST request to the captcha
  // server with the session ID and the answer to the captcha.
  // This is done on the server-side, since the cross-domain
  // AJAX doesn't work.
  $.ajax({
    url: "/captcha",
    dataType: "json",
    type: "post",
    data: {
      input: text,
    sessionId: sessionId
    },
    success: function(data) {
      // If it worked, stop the spinner on the captcha field and
      // set the success variable.
      $('#captcha-spinner').spin(false)
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
  // This sends the request to the server saying to commit the transaction
  // since everything checks out.
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
        $('span#address-spinner').html('<i class="icon-ok"></i>');
        // If everything was successful, run the success function.
        success_function();
      } else {
        // If there was an error, run the respective error function.
        error_functions[data.error]();
        $('span#address-spinner').html('<i class="icon-remove"></i>');
      }
    }
  });
}//}}}
$(function($) {//{{{
  // This handles whenever the user clicks the submit button on
  // the form to request a payout.
  $('button#form-submit').on('click', function() {//{{{
    // First, we get a few variables that help us with
    // asking the server for the payout, doing the captcha,
    // etc.
    captchaText = $('input#captcha-input').val();
    bitcoinAddress = $('input#address-input').val();
    sessionId = $('img#captcha-image').attr('data-session_id');

    // Start spinner on the captcha input field.
    if($('#captcha-spinner').length == 0) {
      $('div#captcha-input-container').addClass("input-append");
      $('<span class="add-on" id="captcha-spinner"></span>').insertAfter("input#captcha-input");
    } else {
      $('#captcha-spinner').html('');
    }

    $('span#captcha-spinner').spin("small");

    // Now we run the captcha verification function and give it
    // a callback to run, teling what to do on success/failure.
    verifyCaptcha(captchaText, sessionId, function(success) {
      if(success == true) {
        // Start spinner on Bitcoin address field since now
        // we have to verify that the bitcoin address and IP
        // address haven't been used twice.
        if($('#address-spinner').length == 0) {
          $('div#address-input-container').addClass("input-append");
          $('<span class="add-on" id="address-spinner"></span>').insertAfter("input#address-input");
        } else {
          $('#address-spinner').html('');
        }
        $('span#address-spinner').spin("small");

        sendCoins(bitcoinAddress);
      }
    });
    // This stops the form from submitting normally.
    return false;
  });//}}}
});//}}}
