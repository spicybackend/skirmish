/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/dist";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _amber = __webpack_require__(1);

var _amber2 = _interopRequireDefault(_amber);

__webpack_require__(2);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

if (!Date.prototype.toGranite) {
  (function () {

    function pad(number) {
      if (number < 10) {
        return '0' + number;
      }
      return number;
    }

    Date.prototype.toGranite = function () {
      return this.getUTCFullYear() + '-' + pad(this.getUTCMonth() + 1) + '-' + pad(this.getUTCDate()) + ' ' + pad(this.getUTCHours()) + ':' + pad(this.getUTCMinutes()) + ':' + pad(this.getUTCSeconds());
    };
  })();
}

/***/ }),
/* 1 */
/***/ (function(module, exports) {

"use strict";
throw new Error("Module build failed: Error: ENOENT: no such file or directory, open '/mnt/c/Users/jorda/Projects/stratify/lib/amber/assets/js/amber.js'");

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


if (document.getElementById('simple-logger')) {
  var statusField = document.getElementById('status');
  var statusDropdown = document.getElementById('status-dropdown');
  var statusDropdownOptions = document.getElementById('status-dropdown-options');

  Array.from(statusDropdownOptions.children).forEach(function (dropdownItem) {
    dropdownItem.addEventListener('click', function (e) {
      var item = e.target;
      var newStatus = item.getAttribute('data-status').trim();
      var newStatusTitle = item.innerText.trim();

      item.innerText = statusDropdown.innerText.trim();
      item.setAttribute('data-status', statusField.getAttribute('value').trim());

      statusDropdown.innerText = newStatusTitle;
      statusField.setAttribute('value', newStatus);
    });
  });

  var playerField = document.getElementById('opponent-id');
  var playerDropdown = document.getElementById('player-dropdown');
  var playerDropdownOptions = document.getElementById('player-dropdown-options');

  Array.from(playerDropdownOptions.children).forEach(function (dropdownItem) {
    dropdownItem.addEventListener('click', function (e) {
      var item = e.target;
      var newPlayerId = item.getAttribute('data-player-id').trim();
      var newPlayerName = item.innerText.trim();

      item.innerText = playerDropdown.innerText.trim();
      item.setAttribute('data-player-id', playerField.getAttribute('value').trim());

      playerDropdown.innerText = newPlayerName;
      playerField.setAttribute('value', newPlayerId);
    });
  });
}

/***/ })
/******/ ]);
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly8vd2VicGFjay9ib290c3RyYXAgOGQzZmQ1OGM3NDZkYjBkNmM0ODciLCJ3ZWJwYWNrOi8vLy4vc3JjL2Fzc2V0cy9qYXZhc2NyaXB0cy9tYWluLmpzIiwid2VicGFjazovLy8uL3NyYy9hc3NldHMvamF2YXNjcmlwdHMvZ2FtZS5qcyJdLCJuYW1lcyI6WyJEYXRlIiwicHJvdG90eXBlIiwidG9HcmFuaXRlIiwicGFkIiwibnVtYmVyIiwiZ2V0VVRDRnVsbFllYXIiLCJnZXRVVENNb250aCIsImdldFVUQ0RhdGUiLCJnZXRVVENIb3VycyIsImdldFVUQ01pbnV0ZXMiLCJnZXRVVENTZWNvbmRzIiwiZG9jdW1lbnQiLCJnZXRFbGVtZW50QnlJZCIsInN0YXR1c0ZpZWxkIiwic3RhdHVzRHJvcGRvd24iLCJzdGF0dXNEcm9wZG93bk9wdGlvbnMiLCJBcnJheSIsImZyb20iLCJjaGlsZHJlbiIsImZvckVhY2giLCJkcm9wZG93bkl0ZW0iLCJhZGRFdmVudExpc3RlbmVyIiwiZSIsIml0ZW0iLCJ0YXJnZXQiLCJuZXdTdGF0dXMiLCJnZXRBdHRyaWJ1dGUiLCJ0cmltIiwibmV3U3RhdHVzVGl0bGUiLCJpbm5lclRleHQiLCJzZXRBdHRyaWJ1dGUiLCJwbGF5ZXJGaWVsZCIsInBsYXllckRyb3Bkb3duIiwicGxheWVyRHJvcGRvd25PcHRpb25zIiwibmV3UGxheWVySWQiLCJuZXdQbGF5ZXJOYW1lIl0sIm1hcHBpbmdzIjoiO0FBQUE7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBLGFBQUs7QUFDTDtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBLG1DQUEyQiwwQkFBMEIsRUFBRTtBQUN2RCx5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LEVBQXBDOztBQUVBSyxxQkFBZUgsU0FBZixHQUEyQk0sYUFBM0I7QUFDQUosa0JBQVlELFlBQVosQ0FBeUIsT0FBekIsRUFBa0NJLFdBQWxDO0FBQ0QsS0FWRDtBQVdELEdBWkQ7QUFhRCxDIiwiZmlsZSI6Im1haW4uYnVuZGxlLmpzIiwic291cmNlc0NvbnRlbnQiOlsiIFx0Ly8gVGhlIG1vZHVsZSBjYWNoZVxuIFx0dmFyIGluc3RhbGxlZE1vZHVsZXMgPSB7fTtcblxuIFx0Ly8gVGhlIHJlcXVpcmUgZnVuY3Rpb25cbiBcdGZ1bmN0aW9uIF9fd2VicGFja19yZXF1aXJlX18obW9kdWxlSWQpIHtcblxuIFx0XHQvLyBDaGVjayBpZiBtb2R1bGUgaXMgaW4gY2FjaGVcbiBcdFx0aWYoaW5zdGFsbGVkTW9kdWxlc1ttb2R1bGVJZF0pIHtcbiBcdFx0XHRyZXR1cm4gaW5zdGFsbGVkTW9kdWxlc1ttb2R1bGVJZF0uZXhwb3J0cztcbiBcdFx0fVxuIFx0XHQvLyBDcmVhdGUgYSBuZXcgbW9kdWxlIChhbmQgcHV0IGl0IGludG8gdGhlIGNhY2hlKVxuIFx0XHR2YXIgbW9kdWxlID0gaW5zdGFsbGVkTW9kdWxlc1ttb2R1bGVJZF0gPSB7XG4gXHRcdFx0aTogbW9kdWxlSWQsXG4gXHRcdFx0bDogZmFsc2UsXG4gXHRcdFx0ZXhwb3J0czoge31cbiBcdFx0fTtcblxuIFx0XHQvLyBFeGVjdXRlIHRoZSBtb2R1bGUgZnVuY3Rpb25cbiBcdFx0bW9kdWxlc1ttb2R1bGVJZF0uY2FsbChtb2R1bGUuZXhwb3J0cywgbW9kdWxlLCBtb2R1bGUuZXhwb3J0cywgX193ZWJwYWNrX3JlcXVpcmVfXyk7XG5cbiBcdFx0Ly8gRmxhZyB0aGUgbW9kdWxlIGFzIGxvYWRlZFxuIFx0XHRtb2R1bGUubCA9IHRydWU7XG5cbiBcdFx0Ly8gUmV0dXJuIHRoZSBleHBvcnRzIG9mIHRoZSBtb2R1bGVcbiBcdFx0cmV0dXJuIG1vZHVsZS5leHBvcnRzO1xuIFx0fVxuXG5cbiBcdC8vIGV4cG9zZSB0aGUgbW9kdWxlcyBvYmplY3QgKF9fd2VicGFja19tb2R1bGVzX18pXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLm0gPSBtb2R1bGVzO1xuXG4gXHQvLyBleHBvc2UgdGhlIG1vZHVsZSBjYWNoZVxuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5jID0gaW5zdGFsbGVkTW9kdWxlcztcblxuIFx0Ly8gZGVmaW5lIGdldHRlciBmdW5jdGlvbiBmb3IgaGFybW9ueSBleHBvcnRzXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLmQgPSBmdW5jdGlvbihleHBvcnRzLCBuYW1lLCBnZXR0ZXIpIHtcbiBcdFx0aWYoIV9fd2VicGFja19yZXF1aXJlX18ubyhleHBvcnRzLCBuYW1lKSkge1xuIFx0XHRcdE9iamVjdC5kZWZpbmVQcm9wZXJ0eShleHBvcnRzLCBuYW1lLCB7XG4gXHRcdFx0XHRjb25maWd1cmFibGU6IGZhbHNlLFxuIFx0XHRcdFx0ZW51bWVyYWJsZTogdHJ1ZSxcbiBcdFx0XHRcdGdldDogZ2V0dGVyXG4gXHRcdFx0fSk7XG4gXHRcdH1cbiBcdH07XG5cbiBcdC8vIGdldERlZmF1bHRFeHBvcnQgZnVuY3Rpb24gZm9yIGNvbXBhdGliaWxpdHkgd2l0aCBub24taGFybW9ueSBtb2R1bGVzXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLm4gPSBmdW5jdGlvbihtb2R1bGUpIHtcbiBcdFx0dmFyIGdldHRlciA9IG1vZHVsZSAmJiBtb2R1bGUuX19lc01vZHVsZSA/XG4gXHRcdFx0ZnVuY3Rpb24gZ2V0RGVmYXVsdCgpIHsgcmV0dXJuIG1vZHVsZVsnZGVmYXVsdCddOyB9IDpcbiBcdFx0XHRmdW5jdGlvbiBnZXRNb2R1bGVFeHBvcnRzKCkgeyByZXR1cm4gbW9kdWxlOyB9O1xuIFx0XHRfX3dlYnBhY2tfcmVxdWlyZV9fLmQoZ2V0dGVyLCAnYScsIGdldHRlcik7XG4gXHRcdHJldHVybiBnZXR0ZXI7XG4gXHR9O1xuXG4gXHQvLyBPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5LmNhbGxcbiBcdF9fd2VicGFja19yZXF1aXJlX18ubyA9IGZ1bmN0aW9uKG9iamVjdCwgcHJvcGVydHkpIHsgcmV0dXJuIE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbChvYmplY3QsIHByb3BlcnR5KTsgfTtcblxuIFx0Ly8gX193ZWJwYWNrX3B1YmxpY19wYXRoX19cbiBcdF9fd2VicGFja19yZXF1aXJlX18ucCA9IFwiL2Rpc3RcIjtcblxuIFx0Ly8gTG9hZCBlbnRyeSBtb2R1bGUgYW5kIHJldHVybiBleHBvcnRzXG4gXHRyZXR1cm4gX193ZWJwYWNrX3JlcXVpcmVfXyhfX3dlYnBhY2tfcmVxdWlyZV9fLnMgPSAwKTtcblxuXG5cbi8vIFdFQlBBQ0sgRk9PVEVSIC8vXG4vLyB3ZWJwYWNrL2Jvb3RzdHJhcCA4ZDNmZDU4Yzc0NmRiMGQ2YzQ4NyIsImltcG9ydCBBbWJlciBmcm9tICdhbWJlcidcblxuaW1wb3J0IFwiLi9nYW1lLmpzXCJcblxuaWYgKCFEYXRlLnByb3RvdHlwZS50b0dyYW5pdGUpIHtcbiAgKGZ1bmN0aW9uKCkge1xuXG4gICAgZnVuY3Rpb24gcGFkKG51bWJlcikge1xuICAgICAgaWYgKG51bWJlciA8IDEwKSB7XG4gICAgICAgIHJldHVybiAnMCcgKyBudW1iZXI7XG4gICAgICB9XG4gICAgICByZXR1cm4gbnVtYmVyO1xuICAgIH1cblxuICAgIERhdGUucHJvdG90eXBlLnRvR3Jhbml0ZSA9IGZ1bmN0aW9uKCkge1xuICAgICAgcmV0dXJuIHRoaXMuZ2V0VVRDRnVsbFllYXIoKSArXG4gICAgICAgICctJyArIHBhZCh0aGlzLmdldFVUQ01vbnRoKCkgKyAxKSArXG4gICAgICAgICctJyArIHBhZCh0aGlzLmdldFVUQ0RhdGUoKSkgK1xuICAgICAgICAnICcgKyBwYWQodGhpcy5nZXRVVENIb3VycygpKSArXG4gICAgICAgICc6JyArIHBhZCh0aGlzLmdldFVUQ01pbnV0ZXMoKSkgK1xuICAgICAgICAnOicgKyBwYWQodGhpcy5nZXRVVENTZWNvbmRzKCkpICA7XG4gICAgfTtcblxuICB9KCkpO1xufVxuXG5cblxuLy8gV0VCUEFDSyBGT09URVIgLy9cbi8vIC4vc3JjL2Fzc2V0cy9qYXZhc2NyaXB0cy9tYWluLmpzIiwiaWYgKGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCdzaW1wbGUtbG9nZ2VyJykpIHtcbiAgbGV0IHN0YXR1c0ZpZWxkID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoJ3N0YXR1cycpXG4gIGxldCBzdGF0dXNEcm9wZG93biA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCdzdGF0dXMtZHJvcGRvd24nKVxuICBsZXQgc3RhdHVzRHJvcGRvd25PcHRpb25zID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoJ3N0YXR1cy1kcm9wZG93bi1vcHRpb25zJylcblxuICBBcnJheS5mcm9tKHN0YXR1c0Ryb3Bkb3duT3B0aW9ucy5jaGlsZHJlbikuZm9yRWFjaChkcm9wZG93bkl0ZW0gPT4ge1xuICAgIGRyb3Bkb3duSXRlbS5hZGRFdmVudExpc3RlbmVyKCdjbGljaycsIChlKSA9PiB7XG4gICAgICBsZXQgaXRlbSA9IGUudGFyZ2V0XG4gICAgICBsZXQgbmV3U3RhdHVzID0gaXRlbS5nZXRBdHRyaWJ1dGUoJ2RhdGEtc3RhdHVzJykudHJpbSgpXG4gICAgICBsZXQgbmV3U3RhdHVzVGl0bGUgPSBpdGVtLmlubmVyVGV4dC50cmltKClcblxuICAgICAgaXRlbS5pbm5lclRleHQgPSBzdGF0dXNEcm9wZG93bi5pbm5lclRleHQudHJpbSgpXG4gICAgICBpdGVtLnNldEF0dHJpYnV0ZSgnZGF0YS1zdGF0dXMnLCBzdGF0dXNGaWVsZC5nZXRBdHRyaWJ1dGUoJ3ZhbHVlJykudHJpbSgpKVxuXG4gICAgICBzdGF0dXNEcm9wZG93bi5pbm5lclRleHQgPSBuZXdTdGF0dXNUaXRsZVxuICAgICAgc3RhdHVzRmllbGQuc2V0QXR0cmlidXRlKCd2YWx1ZScsIG5ld1N0YXR1cylcbiAgICB9KVxuICB9KVxuXG4gIGxldCBwbGF5ZXJGaWVsZCA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCdvcHBvbmVudC1pZCcpXG4gIGxldCBwbGF5ZXJEcm9wZG93biA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCdwbGF5ZXItZHJvcGRvd24nKVxuICBsZXQgcGxheWVyRHJvcGRvd25PcHRpb25zID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoJ3BsYXllci1kcm9wZG93bi1vcHRpb25zJylcblxuICBBcnJheS5mcm9tKHBsYXllckRyb3Bkb3duT3B0aW9ucy5jaGlsZHJlbikuZm9yRWFjaChkcm9wZG93bkl0ZW0gPT4ge1xuICAgIGRyb3Bkb3duSXRlbS5hZGRFdmVudExpc3RlbmVyKCdjbGljaycsIChlKSA9PiB7XG4gICAgICBsZXQgaXRlbSA9IGUudGFyZ2V0XG4gICAgICBsZXQgbmV3UGxheWVySWQgPSBpdGVtLmdldEF0dHJpYnV0ZSgnZGF0YS1wbGF5ZXItaWQnKS50cmltKClcbiAgICAgIGxldCBuZXdQbGF5ZXJOYW1lID0gaXRlbS5pbm5lclRleHQudHJpbSgpXG5cbiAgICAgIGl0ZW0uaW5uZXJUZXh0ID0gcGxheWVyRHJvcGRvd24uaW5uZXJUZXh0LnRyaW0oKVxuICAgICAgaXRlbS5zZXRBdHRyaWJ1dGUoJ2RhdGEtcGxheWVyLWlkJywgcGxheWVyRmllbGQuZ2V0QXR0cmlidXRlKCd2YWx1ZScpLnRyaW0oKSlcblxuICAgICAgcGxheWVyRHJvcGRvd24uaW5uZXJUZXh0ID0gbmV3UGxheWVyTmFtZVxuICAgICAgcGxheWVyRmllbGQuc2V0QXR0cmlidXRlKCd2YWx1ZScsIG5ld1BsYXllcklkKVxuICAgIH0pXG4gIH0pXG59XG5cblxuXG4vLyBXRUJQQUNLIEZPT1RFUiAvL1xuLy8gLi9zcmMvYXNzZXRzL2phdmFzY3JpcHRzL2dhbWUuanMiXSwic291cmNlUm9vdCI6IiJ9