var drawGraphs = function(data) {
  // Now that we have our data and are drawing the graph, we can stop the spinner.
  $('#payout-graph').spin(false);

  var rawData = [];
  // The raw data that the graphing library uses is
  // in the form of [ [x, y], [x, y], ... ] so we generate
  // that data from the data downloaded from the server. The
  // timestamp that the graphing library requires is in UNIX
  // timestamp form. That is, milliseconds since Jan 1, 1970.

  for(var i = 0; i < data.payouts.length; i++) {
    var payout = data.payouts[i];

    rawData.push([payout.timestamp, payout.transactions * data.payout_amount])
  }

  // This is the data object our graphing library uses.
  data = {
    data: rawData,
    label: "Payouts"
  }

  // And some basic options that control how the graph is displayed.
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
  // Now we plot it!
  $("#payout-graph").plot([data], options);

  // This draws the y-axis label after the graph has been drawn.
  var yaxisLabel = $("<div class='axisLabel yaxisLabel'></div>")
    .text("Payout Amount (BTC)")
    .appendTo($("#graph-container"));

  // Since CSS transforms use the top-left corner of the label as the transform origin,
  // we need to center the y-axis label by shifting it down by half its width.
  // Subtract 20 to factor the chart's bottom margin into the centering.

  yaxisLabel.css("margin-top", yaxisLabel.width() / 2 - 20);
}

// This function is called right when the page for the graphs
// is loaded.
$(function($) {
  // First we start a spinner in the graph while we get the data.
  $('#payout-graph').spin();

  // Now we get the data used to draw the graphs and call our
  // drawGraphs function once we're done.
  $.ajax({
    url: '/data',
    type: 'get',
    dataType: 'json',
    success: drawGraphs
  });
});
