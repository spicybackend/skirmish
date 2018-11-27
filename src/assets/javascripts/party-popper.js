import mojs from 'mo-js';

/**
 * Creates a Mo.js party popper animation.
 * https://codepen.io/johanmouchet/pen/qpjavE
 *
 * @property {string}  selector - DOM selector to attach the animation to
 */
function partyPopper(selector) {

  const colors = [
    '#bea4ff',
    '#feb535',
    '#ff6e83',
    '#58cafe',
  ]

  const torsadeBurst = new mojs.Burst({
    parent: selector,
    radius: {0 : 'rand(50, 100)'},
    count: 'rand(18, 22)',
    degree: 30,
    children: {
      shape: 'zigzag',
      points: 'rand(4, 6)',
      radius: 40,
      radiusY: 30,
      strokeLinecap: 'round',
      strokeWidth: 8,
      fill: 'none',
      stroke: colors,
      angle: {0: 'rand(-720, 720)'},
      isSwirl: true,
      swirlSize: 'rand(10, 20)',
      swirlFrequency: 'rand(1, 3)',
      direction: [-1, 1],
      degreeShift: 'rand(-15, 15)',
      duration: 2000,
      easing: 'cubic.out',
      pathScale: 'stagger(.2)',
    }
  });

  const bentBurst = new mojs.Burst({
    parent: selector,
    radius: {0 : 'rand(50, 100)'},
    count: 'rand(18, 22)',
    degree: 30,
    children: {
      shape: 'curve',
      radius: 'rand(25, 35)',
      radiusY: 15,
      strokeLinecap: 'round',
      strokeWidth: 8,
      fill: 'none',
      stroke: colors,
      angle: {0: 'rand(-720, 720)'},
      isSwirl: true,
      swirlSize: 'rand(10, 20)',
      swirlFrequency: 'rand(1, 3)',
      direction: [-1, 1],
      degreeShift: 'rand(-15, 15)',
      duration: 2000,
      easing: 'cubic.out',
      pathScale: 'stagger(.2)',
    }
  });

  const flakeBurst = new mojs.Burst({
    parent: selector,
    radius: {0 : 'rand(50, 100)'},
    count: 'rand(18, 22)',
    degree: 30,
    children: {
      shape:'circle',
      radius: 'rand(5, 10)',
      fill: colors,
      isSwirl: true,
      swirlSize: 'rand(10, 20)',
      swirlFrequency: 'rand(1, 3)',
      direction: [-1, 1],
      degreeShift: 'rand(-15, 15)',
      duration: 2000,
      easing: 'cubic.out',
      pathScale: 'stagger(.2)',
    }
  });

  torsadeBurst.play()
  bentBurst.play()
  flakeBurst.play()
};

setTimeout(() => partyPopper('.party-popper-effects'), 400);


document.querySelectorAll('.party-popper-emoji').forEach((elem) => {
  elem.addEventListener("click", function () {
    partyPopper('.party-popper-effects')
  });
})
