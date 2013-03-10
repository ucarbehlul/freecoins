var drawGraphs = function(data) {
  $('#payout-graph').spin(false);

  console.log(data)

  var rawData = []

  for(var i = 0; i < data.payouts.length; i++) {
    var payout = data.payouts[i];

    rawData.push([payout.timestamp, payout.transactions * data.payout_amount])
  }

  data = {
    data: rawData,
    label: "Payouts"
  }

  var options = {
    series: {
      lines: {
        show: true
      },
      points: {
        show: true
      }
    },
    grid: {
      labelMargin: 10,
      minBorderMargin: 20
    },
    margin: {
      top: 8,
      bottom: 20,
      left: 20
    },
    xaxis: {
      mode: "time",
      timeformat: "%Y/%m/%d",
      timezone: "browser"
    },
    yaxis: {
      min: 0
    },

    legend: {
      show: true
    }
  }
  $("#payout-graph").plot([data], options);

  var yaxisLabel = $("<div class='axisLabel yaxisLabel'></div>")
    .text("Payout Amount (BTC)")
    .appendTo($("#graph-container"));

  // Since CSS transforms use the top-left corner of the label as the transform origin,
  // we need to center the y-axis label by shifting it down by half its width.
  // Subtract 20 to factor the chart's bottom margin into the centering.

  yaxisLabel.css("margin-top", yaxisLabel.width() / 2 - 20);
}

$(function($) {
  $('#payout-graph').spin();
  $.ajax({
    url: '/data',
    type: 'get',
    dataType: 'json',
    success: drawGraphs
  });
});
