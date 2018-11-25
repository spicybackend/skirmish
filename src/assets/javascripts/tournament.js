// photos from flickr with creative commons license
import cytoscape from 'cytoscape';

let tournamentGraphElement = document.getElementById('tournament-graph');

if (tournamentGraphElement) {
  let tournamentDataUrl = tournamentGraphElement.getAttribute('tournament-data-url');
  fetch(`${tournamentDataUrl}.json`)
  .then(response => {
    return response.json();
  }).then(tournamentData => {
    // Get rid of bye matches
    let filteredMatchData = tournamentData.matches.filter((match) => { return match.level > 0 || (match.player_a_id && match.player_b_id) });
    let matchNodes = filteredMatchData.map((match) => {
      let player_a = tournamentData.players.find((player) => player.id == match.player_a_id)
      let player_b = tournamentData.players.find((player) => player.id == match.player_b_id)
      let winner = tournamentData.players.find((player) => player.id == match.winner_id)

      let outlineColor
      if (winner)
        outlineColor = '#ef4b62'
      else if (player_a && player_b)
        outlineColor = '#ffa039'
      else
        outlineColor = '#828282'

      return {
        data: {
          id: `m${match.id}`,
          name: `Match #${match.id}`,
          players_vs: `${ player_a ? player_a.tag : "undetermined" } vs ${ player_b ? player_b.tag : "undetermined" }`,
          background: winner ? winner.image_url : 'none',
          outline: outlineColor
        }
      };
    })

    let matchEdges = filteredMatchData.filter(match => match.next_match_id).map((match) => {
      // source and target and swapped around as to treat the winning node as the top of the tree (BFS)
      return {
        data: {
          target: `m${match.id}`,
          source: `m${match.next_match_id}`,
          color: match.winner_id ? "#4eb4f9" : "#828282"
        }
      };
    })

    let playerNodes = [];
    filteredMatchData.forEach((match) => {
      [match.player_a_id, match.player_b_id].forEach((player_id) => {
        let player = tournamentData.players.find((player) => player.id == player_id)

        if (player)
          playerNodes += { data: { id: `p${player.id}`, name: player.tag } }
      })
    })

    let cy = cytoscape({
      container: tournamentGraphElement,

      boxSelectionEnabled: true,
      autounselectify: true,

      maxZoom: 2,
      minZoom: 0.5,

      style: cytoscape.stylesheet()
        .selector('node')
          .css({
            'height': 80,
            'width': 80,
            'background-image': 'data(background)',
            'background-fit': 'cover',
            'background-color': '#343a40',
            'border-color': 'data(outline)',
            'border-width': 8,
            'border-opacity': 1,
            'content': 'data(players_vs)',
            'color': 'white',
            'text-outline-width': 2,
            'text-outline-color': '#343a40',
            'text-valign': 'bottom',
            'font-weight': 'bold',
            'font-size': '20px',
            'font-family': 'Muli, Helvetica Neue, Helvetica, Arial, sans-serif'
          })
        .selector('.eating')
          .css({
            'border-color': 'red'
          })
        .selector('.eater')
          .css({
            'border-width': 10
          })
        .selector('edge')
          .css({
            'curve-style': 'bezier',
            'width': 8,
            'source-arrow-shape': 'triangle',
            'line-color': 'data(color)',
            'source-arrow-color': 'data(color)'
          })
        .selector('edge.played')
          .css({
            'line-color': "#aef72f"
          }),

      elements: {
        nodes: matchNodes,
        edges: matchEdges
      },

      layout: {
        name: 'breadthfirst',
        directed: true,
        padding: 10
      }
    }); // cy init

    // cy.on('tap', 'node', function() {
    //   var nodes = this;
    //   var tapped = nodes;
    //   var food = [];

    //   nodes.addClass('eater');

    //   for(;;){
    //     var connectedEdges = nodes.connectedEdges(function(el){
    //       return !el.target().anySame( nodes );
    //     });

    //     var connectedNodes = connectedEdges.targets();

    //     Array.prototype.push.apply( food, connectedNodes );

    //     nodes = connectedNodes;

    //     if( nodes.empty() ){ break; }
    //   }

    //   var delay = 0;
    //   var duration = 500;
    //   for( var i = food.length - 1; i >= 0; i-- ){ (function(){
    //     var thisFood = food[i];
    //     var eater = thisFood.connectedEdges(function(el){
    //       return el.target().same(thisFood);
    //     }).source();

    //     thisFood.delay( delay, function(){
    //       eater.addClass('eating');
    //     } ).animate({
    //       position: eater.position(),
    //       css: {
    //         'width': 10,
    //         'height': 10,
    //         'border-width': 0,
    //         'opacity': 0
    //       }
    //     }, {
    //       duration: duration,
    //       complete: function(){
    //         thisFood.remove();
    //       }
    //     });

    //     delay += duration;
    //   })(); }
    // });
  })
}
