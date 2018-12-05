import Chart from 'chart.js';
import newDateString from 'moment';
import newDate from 'moment';
import timeParser from 'moment';
import moment from 'moment';

let chartElem = document.getElementById("tournamentRating")

if (chartElem) {
  let ctx = chartElem.getContext('2d');
  let myChart = new Chart(ctx, {
    type: 'line',
    data: {
        labels: [
          moment().subtract(3, 'days'),
          moment().subtract(2, 'days'),
          moment().subtract(1, 'days'),
          moment(),
          moment().add(1, 'days')
        ],
        datasets: [{
          label: 'Player Rating',
          backgroundColor: '#ffa039',
          borderColor: '#ffa039',
          fill: false,
          data: [{
            x: moment().subtract(3, 'days'),
            y: 1000
          }, {
            x: moment().subtract(2, 'days'),
            y: 1032
          }, {
            x: moment().subtract(1, 'days'),
            y: 1043
          }, {
            x: moment(),
            y: 1050
          }],
        }]
      },
      options: {
        title: {
          display: false,
          fontFamily: 'Muli',
          fontSize: 24,
          fontColor: 'white',
					text: 'Rating over Time'
				},
        scales: {
          xAxes: [{
            type: 'time',
            time: {
              format: timeParser,
              // round: 'day',
              tooltipFormat: 'll HH:mm'
            },
            scaleLabel: {
              display: true,
              labelString: 'Time',
              fontFamily: 'Muli',
              fontSize: 14,
              fontColor: 'white'
            }
          }],
          yAxes: [{
            scaleLabel: {
              display: true,
              labelString: 'Rating',
              fontFamily: 'Muli',
              fontSize: 14,
              fontColor: 'white'
            }
          }]
        },
      }
  });
}
