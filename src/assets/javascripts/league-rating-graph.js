import Chart from 'chart.js';

let leagueGraphs = document.querySelectorAll('canvas.league-graph');

leagueGraphs.forEach((canvas) => {
  let leagueId = canvas.getAttribute('data-league-id');

  let leagueDataset = {
    labels: ["January", "February", "March", "April", "May", "June"],
    datasets:
     [
      {
        label: 'Name of League',  // TODO: league name
        borderColor: "#ef4b62",  // TODO: league accent colour
        backgroundColor: "#ef4b62",  // TODO: league accent colour
        fill: false,
        data: [1000, 1016, 1040, 1020, 1046, 1066, 1080]
      }
    ]
  }

  let ctx = canvas.getContext('2d');
  new Chart(ctx, {
    type: "line",
    data: leagueDataset,
    options: {
      legend: {
        display: false
      }
    }
  });
})
