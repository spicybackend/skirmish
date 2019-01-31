import Chart from 'chart.js'

let leagueGraphs = document.querySelectorAll('canvas.league-graph')

leagueGraphs.forEach((canvas) => {
  let ctx = canvas.getContext('2d')
  let leagueStatsUrl = canvas.getAttribute('data-league-stats-url')

  fetch(`${leagueStatsUrl}.json`)
  .then(response => response.json())
  .then(leagueStats => {
    let ratingPlots = []
    for (let rating in leagueStats.ratings) {
      ratingPlots.push({
        x: new Date(rating).valueOf(),
        y: leagueStats.ratings[rating]
      })
    }

    let leagueDataset = {
      datasets:
      [
        {
          label: leagueStats.league_name,
          borderColor: leagueStats.league_color,
          backgroundColor: leagueStats.league_color,
          fill: false,
          data: ratingPlots,
        }
      ]
    }

    new Chart(ctx, {
      type: 'line',
      data: leagueDataset,
      options: {
        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            type: 'time',
          }]
        },
        elements: {
          line: {
            tension: 0.2
          }
        }
      }
    });
  }).catch(function(error) {
    console.log(error)
    ctx.font = '20px Muli'
    ctx.fillStyle = 'white'
    ctx.fillText('Something went wrong.', 0, 15)
  })
})
