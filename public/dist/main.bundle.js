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
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var EVENTS = {
  join: 'join',
  leave: 'leave',
  message: 'message'
};
var STALE_CONNECTION_THRESHOLD_SECONDS = 100;
var SOCKET_POLLING_RATE = 10000;

/**
 * Returns a numeric value for the current time
 */
var now = function now() {
  return new Date().getTime();
};

/**
 * Returns the difference between the current time and passed `time` in seconds
 * @param {Number|Date} time - A numeric time or date object
 */
var secondsSince = function secondsSince(time) {
  return (now() - time) / 1000;
};

/**
 * Class for channel related functions (joining, leaving, subscribing and sending messages)
 */

var Channel = exports.Channel = function () {
  /**
   * @param {String} topic - topic to subscribe to
   * @param {Socket} socket - A Socket instance
   */
  function Channel(topic, socket) {
    _classCallCheck(this, Channel);

    this.topic = topic;
    this.socket = socket;
    this.onMessageHandlers = [];
  }

  /**
   * Join a channel, subscribe to all channels messages
   */


  _createClass(Channel, [{
    key: 'join',
    value: function join() {
      this.socket.ws.send(JSON.stringify({ event: EVENTS.join, topic: this.topic }));
    }

    /**
     * Leave a channel, stop subscribing to channel messages
     */

  }, {
    key: 'leave',
    value: function leave() {
      this.socket.ws.send(JSON.stringify({ event: EVENTS.leave, topic: this.topic }));
    }

    /**
     * Calls all message handlers with a matching subject
     */

  }, {
    key: 'handleMessage',
    value: function handleMessage(msg) {
      this.onMessageHandlers.forEach(function (handler) {
        if (handler.subject === msg.subject) handler.callback(msg.payload);
      });
    }

    /**
     * Subscribe to a channel subject
     * @param {String} subject - subject to listen for: `msg:new`
     * @param {function} callback - callback function when a new message arrives
     */

  }, {
    key: 'on',
    value: function on(subject, callback) {
      this.onMessageHandlers.push({ subject: subject, callback: callback });
    }

    /**
     * Send a new message to the channel
     * @param {String} subject - subject to send message to: `msg:new`
     * @param {Object} payload - payload object: `{message: 'hello'}`
     */

  }, {
    key: 'push',
    value: function push(subject, payload) {
      this.socket.ws.send(JSON.stringify({ event: EVENTS.message, topic: this.topic, subject: subject, payload: payload }));
    }
  }]);

  return Channel;
}();

/**
 * Class for maintaining connection with server and maintaining channels list
 */


var Socket = exports.Socket = function () {
  /**
   * @param {String} endpoint - Websocket endpont used in routes.cr file
   */
  function Socket(endpoint) {
    _classCallCheck(this, Socket);

    this.endpoint = endpoint;
    this.ws = null;
    this.channels = [];
    this.lastPing = now();
    this.reconnectTries = 0;
    this.attemptReconnect = true;
  }

  /**
   * Returns whether or not the last received ping has been past the threshold
   */


  _createClass(Socket, [{
    key: '_connectionIsStale',
    value: function _connectionIsStale() {
      return secondsSince(this.lastPing) > STALE_CONNECTION_THRESHOLD_SECONDS;
    }

    /**
     * Tries to reconnect to the websocket server using a recursive timeout
     */

  }, {
    key: '_reconnect',
    value: function _reconnect() {
      var _this = this;

      clearTimeout(this.reconnectTimeout);
      this.reconnectTimeout = setTimeout(function () {
        _this.reconnectTries++;
        _this.connect(_this.params);
        _this._reconnect();
      }, this._reconnectInterval());
    }

    /**
     * Returns an incrementing timeout interval based around the number of reconnection retries
     */

  }, {
    key: '_reconnectInterval',
    value: function _reconnectInterval() {
      return [1000, 2000, 5000, 10000][this.reconnectTries] || 10000;
    }

    /**
     * Sets a recursive timeout to check if the connection is stale
     */

  }, {
    key: '_poll',
    value: function _poll() {
      var _this2 = this;

      this.pollingTimeout = setTimeout(function () {
        if (_this2._connectionIsStale()) {
          _this2._reconnect();
        } else {
          _this2._poll();
        }
      }, SOCKET_POLLING_RATE);
    }

    /**
     * Clear polling timeout and start polling
     */

  }, {
    key: '_startPolling',
    value: function _startPolling() {
      clearTimeout(this.pollingTimeout);
      this._poll();
    }

    /**
     * Sets `lastPing` to the curent time
     */

  }, {
    key: '_handlePing',
    value: function _handlePing() {
      this.lastPing = now();
    }

    /**
     * Clears reconnect timeout, resets variables an starts polling
     */

  }, {
    key: '_reset',
    value: function _reset() {
      clearTimeout(this.reconnectTimeout);
      this.reconnectTries = 0;
      this.attemptReconnect = true;
      this._startPolling();
    }

    /**
     * Connect the socket to the server, and binds to native ws functions
     * @param {Object} params - Optional parameters
     * @param {String} params.location - Hostname to connect to, defaults to `window.location.hostname`
     * @param {String} parmas.port - Port to connect to, defaults to `window.location.port`
     * @param {String} params.protocol - Protocol to use, either 'wss' or 'ws'
     */

  }, {
    key: 'connect',
    value: function connect(params) {
      var _this3 = this;

      this.params = params;

      var opts = {
        location: window.location.hostname,
        port: window.location.port,
        protocol: window.location.protocol === 'https:' ? 'wss:' : 'ws:'
      };

      if (params) Object.assign(opts, params);
      if (opts.port) opts.location += ':' + opts.port;

      return new Promise(function (resolve, reject) {
        _this3.ws = new WebSocket(opts.protocol + '//' + opts.location + _this3.endpoint);
        _this3.ws.onmessage = function (msg) {
          _this3.handleMessage(msg);
        };
        _this3.ws.onclose = function () {
          if (_this3.attemptReconnect) _this3._reconnect();
        };
        _this3.ws.onopen = function () {
          _this3._reset();
          resolve();
        };
      });
    }

    /**
     * Closes the socket connection permanently
     */

  }, {
    key: 'disconnect',
    value: function disconnect() {
      this.attemptReconnect = false;
      clearTimeout(this.pollingTimeout);
      clearTimeout(this.reconnectTimeout);
      this.ws.close();
    }

    /**
     * Adds a new channel to the socket channels list
     * @param {String} topic - Topic for the channel: `chat_room:123`
     */

  }, {
    key: 'channel',
    value: function channel(topic) {
      var channel = new Channel(topic, this);
      this.channels.push(channel);
      return channel;
    }

    /**
     * Message handler for messages received
     * @param {MessageEvent} msg - Message received from ws
     */

  }, {
    key: 'handleMessage',
    value: function handleMessage(msg) {
      if (msg.data === "ping") return this._handlePing();

      var parsed_msg = JSON.parse(msg.data);
      this.channels.forEach(function (channel) {
        if (channel.topic === parsed_msg.topic) channel.handleMessage(parsed_msg);
      });
    }
  }]);

  return Socket;
}();

module.exports = {
  Socket: Socket

  /**
   * Allows delete links to post for security and ease of use similar to Rails jquery_ujs
   */
};document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("a[data-method='delete']").forEach(function (element) {
    element.addEventListener("click", function (e) {
      e.preventDefault();
      var message = element.getAttribute("data-confirm") || "Are you sure?";
      if (confirm(message)) {
        var form = document.createElement("form");
        var input = document.createElement("input");
        form.setAttribute("action", element.getAttribute("href"));
        form.setAttribute("method", "POST");
        input.setAttribute("type", "hidden");
        input.setAttribute("name", "_method");
        input.setAttribute("value", "DELETE");
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
      }
      return false;
    });
  });
});

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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly8vd2VicGFjay9ib290c3RyYXAgNTg5YTU0MjZlOTM5ZTUwYzFkYzYiLCJ3ZWJwYWNrOi8vLy4vc3JjL2Fzc2V0cy9qYXZhc2NyaXB0cy9tYWluLmpzIiwid2VicGFjazovLy8uL2xpYi9hbWJlci9hc3NldHMvanMvYW1iZXIuanMiLCJ3ZWJwYWNrOi8vLy4vc3JjL2Fzc2V0cy9qYXZhc2NyaXB0cy9nYW1lLmpzIl0sIm5hbWVzIjpbIkRhdGUiLCJwcm90b3R5cGUiLCJ0b0dyYW5pdGUiLCJwYWQiLCJudW1iZXIiLCJnZXRVVENGdWxsWWVhciIsImdldFVUQ01vbnRoIiwiZ2V0VVRDRGF0ZSIsImdldFVUQ0hvdXJzIiwiZ2V0VVRDTWludXRlcyIsImdldFVUQ1NlY29uZHMiLCJFVkVOVFMiLCJqb2luIiwibGVhdmUiLCJtZXNzYWdlIiwiU1RBTEVfQ09OTkVDVElPTl9USFJFU0hPTERfU0VDT05EUyIsIlNPQ0tFVF9QT0xMSU5HX1JBVEUiLCJub3ciLCJnZXRUaW1lIiwic2Vjb25kc1NpbmNlIiwidGltZSIsIkNoYW5uZWwiLCJ0b3BpYyIsInNvY2tldCIsIm9uTWVzc2FnZUhhbmRsZXJzIiwid3MiLCJzZW5kIiwiSlNPTiIsInN0cmluZ2lmeSIsImV2ZW50IiwibXNnIiwiZm9yRWFjaCIsImhhbmRsZXIiLCJzdWJqZWN0IiwiY2FsbGJhY2siLCJwYXlsb2FkIiwicHVzaCIsIlNvY2tldCIsImVuZHBvaW50IiwiY2hhbm5lbHMiLCJsYXN0UGluZyIsInJlY29ubmVjdFRyaWVzIiwiYXR0ZW1wdFJlY29ubmVjdCIsImNsZWFyVGltZW91dCIsInJlY29ubmVjdFRpbWVvdXQiLCJzZXRUaW1lb3V0IiwiY29ubmVjdCIsInBhcmFtcyIsIl9yZWNvbm5lY3QiLCJfcmVjb25uZWN0SW50ZXJ2YWwiLCJwb2xsaW5nVGltZW91dCIsIl9jb25uZWN0aW9uSXNTdGFsZSIsIl9wb2xsIiwiX3N0YXJ0UG9sbGluZyIsIm9wdHMiLCJsb2NhdGlvbiIsIndpbmRvdyIsImhvc3RuYW1lIiwicG9ydCIsInByb3RvY29sIiwiT2JqZWN0IiwiYXNzaWduIiwiUHJvbWlzZSIsInJlc29sdmUiLCJyZWplY3QiLCJXZWJTb2NrZXQiLCJvbm1lc3NhZ2UiLCJoYW5kbGVNZXNzYWdlIiwib25jbG9zZSIsIm9ub3BlbiIsIl9yZXNldCIsImNsb3NlIiwiY2hhbm5lbCIsImRhdGEiLCJfaGFuZGxlUGluZyIsInBhcnNlZF9tc2ciLCJwYXJzZSIsIm1vZHVsZSIsImV4cG9ydHMiLCJkb2N1bWVudCIsImFkZEV2ZW50TGlzdGVuZXIiLCJxdWVyeVNlbGVjdG9yQWxsIiwiZWxlbWVudCIsImUiLCJwcmV2ZW50RGVmYXVsdCIsImdldEF0dHJpYnV0ZSIsImNvbmZpcm0iLCJmb3JtIiwiY3JlYXRlRWxlbWVudCIsImlucHV0Iiwic2V0QXR0cmlidXRlIiwiYXBwZW5kQ2hpbGQiLCJib2R5Iiwic3VibWl0IiwiZ2V0RWxlbWVudEJ5SWQiLCJzdGF0dXNGaWVsZCIsInN0YXR1c0Ryb3Bkb3duIiwic3RhdHVzRHJvcGRvd25PcHRpb25zIiwiQXJyYXkiLCJmcm9tIiwiY2hpbGRyZW4iLCJkcm9wZG93bkl0ZW0iLCJpdGVtIiwidGFyZ2V0IiwibmV3U3RhdHVzIiwidHJpbSIsIm5ld1N0YXR1c1RpdGxlIiwiaW5uZXJUZXh0IiwicGxheWVyRmllbGQiLCJwbGF5ZXJEcm9wZG93biIsInBsYXllckRyb3Bkb3duT3B0aW9ucyIsIm5ld1BsYXllcklkIiwibmV3UGxheWVyTmFtZSJdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOzs7QUFHQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxhQUFLO0FBQ0w7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQSxtQ0FB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U0FBZixHQUEyQkssYUFBM0I7QUFDQUosa0JBQVlsQixZQUFaLENBQXlCLE9BQXpCLEVBQWtDcUIsV0FBbEM7QUFDRCxLQVZEO0FBV0QsR0FaRDtBQWFELEMiLCJmaWxlIjoibWFpbi5idW5kbGUuanMiLCJzb3VyY2VzQ29udGVudCI6WyIgXHQvLyBUaGUgbW9kdWxlIGNhY2hlXG4gXHR2YXIgaW5zdGFsbGVkTW9kdWxlcyA9IHt9O1xuXG4gXHQvLyBUaGUgcmVxdWlyZSBmdW5jdGlvblxuIFx0ZnVuY3Rpb24gX193ZWJwYWNrX3JlcXVpcmVfXyhtb2R1bGVJZCkge1xuXG4gXHRcdC8vIENoZWNrIGlmIG1vZHVsZSBpcyBpbiBjYWNoZVxuIFx0XHRpZihpbnN0YWxsZWRNb2R1bGVzW21vZHVsZUlkXSkge1xuIFx0XHRcdHJldHVybiBpbnN0YWxsZWRNb2R1bGVzW21vZHVsZUlkXS5leHBvcnRzO1xuIFx0XHR9XG4gXHRcdC8vIENyZWF0ZSBhIG5ldyBtb2R1bGUgKGFuZCBwdXQgaXQgaW50byB0aGUgY2FjaGUpXG4gXHRcdHZhciBtb2R1bGUgPSBpbnN0YWxsZWRNb2R1bGVzW21vZHVsZUlkXSA9IHtcbiBcdFx0XHRpOiBtb2R1bGVJZCxcbiBcdFx0XHRsOiBmYWxzZSxcbiBcdFx0XHRleHBvcnRzOiB7fVxuIFx0XHR9O1xuXG4gXHRcdC8vIEV4ZWN1dGUgdGhlIG1vZHVsZSBmdW5jdGlvblxuIFx0XHRtb2R1bGVzW21vZHVsZUlkXS5jYWxsKG1vZHVsZS5leHBvcnRzLCBtb2R1bGUsIG1vZHVsZS5leHBvcnRzLCBfX3dlYnBhY2tfcmVxdWlyZV9fKTtcblxuIFx0XHQvLyBGbGFnIHRoZSBtb2R1bGUgYXMgbG9hZGVkXG4gXHRcdG1vZHVsZS5sID0gdHJ1ZTtcblxuIFx0XHQvLyBSZXR1cm4gdGhlIGV4cG9ydHMgb2YgdGhlIG1vZHVsZVxuIFx0XHRyZXR1cm4gbW9kdWxlLmV4cG9ydHM7XG4gXHR9XG5cblxuIFx0Ly8gZXhwb3NlIHRoZSBtb2R1bGVzIG9iamVjdCAoX193ZWJwYWNrX21vZHVsZXNfXylcbiBcdF9fd2VicGFja19yZXF1aXJlX18ubSA9IG1vZHVsZXM7XG5cbiBcdC8vIGV4cG9zZSB0aGUgbW9kdWxlIGNhY2hlXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLmMgPSBpbnN0YWxsZWRNb2R1bGVzO1xuXG4gXHQvLyBkZWZpbmUgZ2V0dGVyIGZ1bmN0aW9uIGZvciBoYXJtb255IGV4cG9ydHNcbiBcdF9fd2VicGFja19yZXF1aXJlX18uZCA9IGZ1bmN0aW9uKGV4cG9ydHMsIG5hbWUsIGdldHRlcikge1xuIFx0XHRpZighX193ZWJwYWNrX3JlcXVpcmVfXy5vKGV4cG9ydHMsIG5hbWUpKSB7XG4gXHRcdFx0T2JqZWN0LmRlZmluZVByb3BlcnR5KGV4cG9ydHMsIG5hbWUsIHtcbiBcdFx0XHRcdGNvbmZpZ3VyYWJsZTogZmFsc2UsXG4gXHRcdFx0XHRlbnVtZXJhYmxlOiB0cnVlLFxuIFx0XHRcdFx0Z2V0OiBnZXR0ZXJcbiBcdFx0XHR9KTtcbiBcdFx0fVxuIFx0fTtcblxuIFx0Ly8gZ2V0RGVmYXVsdEV4cG9ydCBmdW5jdGlvbiBmb3IgY29tcGF0aWJpbGl0eSB3aXRoIG5vbi1oYXJtb255IG1vZHVsZXNcbiBcdF9fd2VicGFja19yZXF1aXJlX18ubiA9IGZ1bmN0aW9uKG1vZHVsZSkge1xuIFx0XHR2YXIgZ2V0dGVyID0gbW9kdWxlICYmIG1vZHVsZS5fX2VzTW9kdWxlID9cbiBcdFx0XHRmdW5jdGlvbiBnZXREZWZhdWx0KCkgeyByZXR1cm4gbW9kdWxlWydkZWZhdWx0J107IH0gOlxuIFx0XHRcdGZ1bmN0aW9uIGdldE1vZHVsZUV4cG9ydHMoKSB7IHJldHVybiBtb2R1bGU7IH07XG4gXHRcdF9fd2VicGFja19yZXF1aXJlX18uZChnZXR0ZXIsICdhJywgZ2V0dGVyKTtcbiBcdFx0cmV0dXJuIGdldHRlcjtcbiBcdH07XG5cbiBcdC8vIE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbFxuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5vID0gZnVuY3Rpb24ob2JqZWN0LCBwcm9wZXJ0eSkgeyByZXR1cm4gT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eS5jYWxsKG9iamVjdCwgcHJvcGVydHkpOyB9O1xuXG4gXHQvLyBfX3dlYnBhY2tfcHVibGljX3BhdGhfX1xuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5wID0gXCIvZGlzdFwiO1xuXG4gXHQvLyBMb2FkIGVudHJ5IG1vZHVsZSBhbmQgcmV0dXJuIGV4cG9ydHNcbiBcdHJldHVybiBfX3dlYnBhY2tfcmVxdWlyZV9fKF9fd2VicGFja19yZXF1aXJlX18ucyA9IDApO1xuXG5cblxuLy8gV0VCUEFDSyBGT09URVIgLy9cbi8vIHdlYnBhY2svYm9vdHN0cmFwIDU4OWE1NDI2ZTkzOWU1MGMxZGM2IiwiaW1wb3J0IEFtYmVyIGZyb20gJ2FtYmVyJ1xuXG5pbXBvcnQgXCIuL2dhbWUuanNcIlxuXG5pZiAoIURhdGUucHJvdG90eXBlLnRvR3Jhbml0ZSkge1xuICAoZnVuY3Rpb24oKSB7XG5cbiAgICBmdW5jdGlvbiBwYWQobnVtYmVyKSB7XG4gICAgICBpZiAobnVtYmVyIDwgMTApIHtcbiAgICAgICAgcmV0dXJuICcwJyArIG51bWJlcjtcbiAgICAgIH1cbiAgICAgIHJldHVybiBudW1iZXI7XG4gICAgfVxuXG4gICAgRGF0ZS5wcm90b3R5cGUudG9HcmFuaXRlID0gZnVuY3Rpb24oKSB7XG4gICAgICByZXR1cm4gdGhpcy5nZXRVVENGdWxsWWVhcigpICtcbiAgICAgICAgJy0nICsgcGFkKHRoaXMuZ2V0VVRDTW9udGgoKSArIDEpICtcbiAgICAgICAgJy0nICsgcGFkKHRoaXMuZ2V0VVRDRGF0ZSgpKSArXG4gICAgICAgICcgJyArIHBhZCh0aGlzLmdldFVUQ0hvdXJzKCkpICtcbiAgICAgICAgJzonICsgcGFkKHRoaXMuZ2V0VVRDTWludXRlcygpKSArXG4gICAgICAgICc6JyArIHBhZCh0aGlzLmdldFVUQ1NlY29uZHMoKSkgIDtcbiAgICB9O1xuXG4gIH0oKSk7XG59XG5cblxuXG4vLyBXRUJQQUNLIEZPT1RFUiAvL1xuLy8gLi9zcmMvYXNzZXRzL2phdmFzY3JpcHRzL21haW4uanMiLCJjb25zdCBFVkVOVFMgPSB7XG4gIGpvaW46ICdqb2luJyxcbiAgbGVhdmU6ICdsZWF2ZScsXG4gIG1lc3NhZ2U6ICdtZXNzYWdlJ1xufVxuY29uc3QgU1RBTEVfQ09OTkVDVElPTl9USFJFU0hPTERfU0VDT05EUyA9IDEwMFxuY29uc3QgU09DS0VUX1BPTExJTkdfUkFURSA9IDEwMDAwXG5cbi8qKlxuICogUmV0dXJucyBhIG51bWVyaWMgdmFsdWUgZm9yIHRoZSBjdXJyZW50IHRpbWVcbiAqL1xubGV0IG5vdyA9ICgpID0+IHtcbiAgcmV0dXJuIG5ldyBEYXRlKCkuZ2V0VGltZSgpXG59XG5cbi8qKlxuICogUmV0dXJucyB0aGUgZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSBjdXJyZW50IHRpbWUgYW5kIHBhc3NlZCBgdGltZWAgaW4gc2Vjb25kc1xuICogQHBhcmFtIHtOdW1iZXJ8RGF0ZX0gdGltZSAtIEEgbnVtZXJpYyB0aW1lIG9yIGRhdGUgb2JqZWN0XG4gKi9cbmxldCBzZWNvbmRzU2luY2UgPSAodGltZSkgPT4ge1xuICByZXR1cm4gKG5vdygpIC0gdGltZSkgLyAxMDAwXG59XG5cbi8qKlxuICogQ2xhc3MgZm9yIGNoYW5uZWwgcmVsYXRlZCBmdW5jdGlvbnMgKGpvaW5pbmcsIGxlYXZpbmcsIHN1YnNjcmliaW5nIGFuZCBzZW5kaW5nIG1lc3NhZ2VzKVxuICovXG5leHBvcnQgY2xhc3MgQ2hhbm5lbCB7XG4gIC8qKlxuICAgKiBAcGFyYW0ge1N0cmluZ30gdG9waWMgLSB0b3BpYyB0byBzdWJzY3JpYmUgdG9cbiAgICogQHBhcmFtIHtTb2NrZXR9IHNvY2tldCAtIEEgU29ja2V0IGluc3RhbmNlXG4gICAqL1xuICBjb25zdHJ1Y3Rvcih0b3BpYywgc29ja2V0KSB7XG4gICAgdGhpcy50b3BpYyA9IHRvcGljXG4gICAgdGhpcy5zb2NrZXQgPSBzb2NrZXRcbiAgICB0aGlzLm9uTWVzc2FnZUhhbmRsZXJzID0gW11cbiAgfVxuXG4gIC8qKlxuICAgKiBKb2luIGEgY2hhbm5lbCwgc3Vic2NyaWJlIHRvIGFsbCBjaGFubmVscyBtZXNzYWdlc1xuICAgKi9cbiAgam9pbigpIHtcbiAgICB0aGlzLnNvY2tldC53cy5zZW5kKEpTT04uc3RyaW5naWZ5KHsgZXZlbnQ6IEVWRU5UUy5qb2luLCB0b3BpYzogdGhpcy50b3BpYyB9KSlcbiAgfVxuXG4gIC8qKlxuICAgKiBMZWF2ZSBhIGNoYW5uZWwsIHN0b3Agc3Vic2NyaWJpbmcgdG8gY2hhbm5lbCBtZXNzYWdlc1xuICAgKi9cbiAgbGVhdmUoKSB7XG4gICAgdGhpcy5zb2NrZXQud3Muc2VuZChKU09OLnN0cmluZ2lmeSh7IGV2ZW50OiBFVkVOVFMubGVhdmUsIHRvcGljOiB0aGlzLnRvcGljIH0pKVxuICB9XG5cbiAgLyoqXG4gICAqIENhbGxzIGFsbCBtZXNzYWdlIGhhbmRsZXJzIHdpdGggYSBtYXRjaGluZyBzdWJqZWN0XG4gICAqL1xuICBoYW5kbGVNZXNzYWdlKG1zZykge1xuICAgIHRoaXMub25NZXNzYWdlSGFuZGxlcnMuZm9yRWFjaCgoaGFuZGxlcikgPT4ge1xuICAgICAgaWYgKGhhbmRsZXIuc3ViamVjdCA9PT0gbXNnLnN1YmplY3QpIGhhbmRsZXIuY2FsbGJhY2sobXNnLnBheWxvYWQpXG4gICAgfSlcbiAgfVxuXG4gIC8qKlxuICAgKiBTdWJzY3JpYmUgdG8gYSBjaGFubmVsIHN1YmplY3RcbiAgICogQHBhcmFtIHtTdHJpbmd9IHN1YmplY3QgLSBzdWJqZWN0IHRvIGxpc3RlbiBmb3I6IGBtc2c6bmV3YFxuICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBjYWxsYmFjayAtIGNhbGxiYWNrIGZ1bmN0aW9uIHdoZW4gYSBuZXcgbWVzc2FnZSBhcnJpdmVzXG4gICAqL1xuICBvbihzdWJqZWN0LCBjYWxsYmFjaykge1xuICAgIHRoaXMub25NZXNzYWdlSGFuZGxlcnMucHVzaCh7IHN1YmplY3Q6IHN1YmplY3QsIGNhbGxiYWNrOiBjYWxsYmFjayB9KVxuICB9XG5cbiAgLyoqXG4gICAqIFNlbmQgYSBuZXcgbWVzc2FnZSB0byB0aGUgY2hhbm5lbFxuICAgKiBAcGFyYW0ge1N0cmluZ30gc3ViamVjdCAtIHN1YmplY3QgdG8gc2VuZCBtZXNzYWdlIHRvOiBgbXNnOm5ld2BcbiAgICogQHBhcmFtIHtPYmplY3R9IHBheWxvYWQgLSBwYXlsb2FkIG9iamVjdDogYHttZXNzYWdlOiAnaGVsbG8nfWBcbiAgICovXG4gIHB1c2goc3ViamVjdCwgcGF5bG9hZCkge1xuICAgIHRoaXMuc29ja2V0LndzLnNlbmQoSlNPTi5zdHJpbmdpZnkoeyBldmVudDogRVZFTlRTLm1lc3NhZ2UsIHRvcGljOiB0aGlzLnRvcGljLCBzdWJqZWN0OiBzdWJqZWN0LCBwYXlsb2FkOiBwYXlsb2FkIH0pKVxuICB9XG59XG5cbi8qKlxuICogQ2xhc3MgZm9yIG1haW50YWluaW5nIGNvbm5lY3Rpb24gd2l0aCBzZXJ2ZXIgYW5kIG1haW50YWluaW5nIGNoYW5uZWxzIGxpc3RcbiAqL1xuZXhwb3J0IGNsYXNzIFNvY2tldCB7XG4gIC8qKlxuICAgKiBAcGFyYW0ge1N0cmluZ30gZW5kcG9pbnQgLSBXZWJzb2NrZXQgZW5kcG9udCB1c2VkIGluIHJvdXRlcy5jciBmaWxlXG4gICAqL1xuICBjb25zdHJ1Y3RvcihlbmRwb2ludCkge1xuICAgIHRoaXMuZW5kcG9pbnQgPSBlbmRwb2ludFxuICAgIHRoaXMud3MgPSBudWxsXG4gICAgdGhpcy5jaGFubmVscyA9IFtdXG4gICAgdGhpcy5sYXN0UGluZyA9IG5vdygpXG4gICAgdGhpcy5yZWNvbm5lY3RUcmllcyA9IDBcbiAgICB0aGlzLmF0dGVtcHRSZWNvbm5lY3QgPSB0cnVlXG4gIH1cblxuICAvKipcbiAgICogUmV0dXJucyB3aGV0aGVyIG9yIG5vdCB0aGUgbGFzdCByZWNlaXZlZCBwaW5nIGhhcyBiZWVuIHBhc3QgdGhlIHRocmVzaG9sZFxuICAgKi9cbiAgX2Nvbm5lY3Rpb25Jc1N0YWxlKCkge1xuICAgIHJldHVybiBzZWNvbmRzU2luY2UodGhpcy5sYXN0UGluZykgPiBTVEFMRV9DT05ORUNUSU9OX1RIUkVTSE9MRF9TRUNPTkRTXG4gIH1cblxuICAvKipcbiAgICogVHJpZXMgdG8gcmVjb25uZWN0IHRvIHRoZSB3ZWJzb2NrZXQgc2VydmVyIHVzaW5nIGEgcmVjdXJzaXZlIHRpbWVvdXRcbiAgICovXG4gIF9yZWNvbm5lY3QoKSB7XG4gICAgY2xlYXJUaW1lb3V0KHRoaXMucmVjb25uZWN0VGltZW91dClcbiAgICB0aGlzLnJlY29ubmVjdFRpbWVvdXQgPSBzZXRUaW1lb3V0KCgpID0+IHtcbiAgICAgIHRoaXMucmVjb25uZWN0VHJpZXMrK1xuICAgICAgdGhpcy5jb25uZWN0KHRoaXMucGFyYW1zKVxuICAgICAgdGhpcy5fcmVjb25uZWN0KClcbiAgICB9LCB0aGlzLl9yZWNvbm5lY3RJbnRlcnZhbCgpKVxuICB9XG5cbiAgLyoqXG4gICAqIFJldHVybnMgYW4gaW5jcmVtZW50aW5nIHRpbWVvdXQgaW50ZXJ2YWwgYmFzZWQgYXJvdW5kIHRoZSBudW1iZXIgb2YgcmVjb25uZWN0aW9uIHJldHJpZXNcbiAgICovXG4gIF9yZWNvbm5lY3RJbnRlcnZhbCgpIHtcbiAgICByZXR1cm4gWzEwMDAsIDIwMDAsIDUwMDAsIDEwMDAwXVt0aGlzLnJlY29ubmVjdFRyaWVzXSB8fCAxMDAwMFxuICB9XG5cbiAgLyoqXG4gICAqIFNldHMgYSByZWN1cnNpdmUgdGltZW91dCB0byBjaGVjayBpZiB0aGUgY29ubmVjdGlvbiBpcyBzdGFsZVxuICAgKi9cbiAgX3BvbGwoKSB7XG4gICAgdGhpcy5wb2xsaW5nVGltZW91dCA9IHNldFRpbWVvdXQoKCkgPT4ge1xuICAgICAgaWYgKHRoaXMuX2Nvbm5lY3Rpb25Jc1N0YWxlKCkpIHtcbiAgICAgICAgdGhpcy5fcmVjb25uZWN0KClcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHRoaXMuX3BvbGwoKVxuICAgICAgfVxuICAgIH0sIFNPQ0tFVF9QT0xMSU5HX1JBVEUpXG4gIH1cblxuICAvKipcbiAgICogQ2xlYXIgcG9sbGluZyB0aW1lb3V0IGFuZCBzdGFydCBwb2xsaW5nXG4gICAqL1xuICBfc3RhcnRQb2xsaW5nKCkge1xuICAgIGNsZWFyVGltZW91dCh0aGlzLnBvbGxpbmdUaW1lb3V0KVxuICAgIHRoaXMuX3BvbGwoKVxuICB9XG5cbiAgLyoqXG4gICAqIFNldHMgYGxhc3RQaW5nYCB0byB0aGUgY3VyZW50IHRpbWVcbiAgICovXG4gIF9oYW5kbGVQaW5nKCkge1xuICAgIHRoaXMubGFzdFBpbmcgPSBub3coKVxuICB9XG5cbiAgLyoqXG4gICAqIENsZWFycyByZWNvbm5lY3QgdGltZW91dCwgcmVzZXRzIHZhcmlhYmxlcyBhbiBzdGFydHMgcG9sbGluZ1xuICAgKi9cbiAgX3Jlc2V0KCkge1xuICAgIGNsZWFyVGltZW91dCh0aGlzLnJlY29ubmVjdFRpbWVvdXQpXG4gICAgdGhpcy5yZWNvbm5lY3RUcmllcyA9IDBcbiAgICB0aGlzLmF0dGVtcHRSZWNvbm5lY3QgPSB0cnVlXG4gICAgdGhpcy5fc3RhcnRQb2xsaW5nKClcbiAgfVxuXG4gIC8qKlxuICAgKiBDb25uZWN0IHRoZSBzb2NrZXQgdG8gdGhlIHNlcnZlciwgYW5kIGJpbmRzIHRvIG5hdGl2ZSB3cyBmdW5jdGlvbnNcbiAgICogQHBhcmFtIHtPYmplY3R9IHBhcmFtcyAtIE9wdGlvbmFsIHBhcmFtZXRlcnNcbiAgICogQHBhcmFtIHtTdHJpbmd9IHBhcmFtcy5sb2NhdGlvbiAtIEhvc3RuYW1lIHRvIGNvbm5lY3QgdG8sIGRlZmF1bHRzIHRvIGB3aW5kb3cubG9jYXRpb24uaG9zdG5hbWVgXG4gICAqIEBwYXJhbSB7U3RyaW5nfSBwYXJtYXMucG9ydCAtIFBvcnQgdG8gY29ubmVjdCB0bywgZGVmYXVsdHMgdG8gYHdpbmRvdy5sb2NhdGlvbi5wb3J0YFxuICAgKiBAcGFyYW0ge1N0cmluZ30gcGFyYW1zLnByb3RvY29sIC0gUHJvdG9jb2wgdG8gdXNlLCBlaXRoZXIgJ3dzcycgb3IgJ3dzJ1xuICAgKi9cbiAgY29ubmVjdChwYXJhbXMpIHtcbiAgICB0aGlzLnBhcmFtcyA9IHBhcmFtc1xuXG4gICAgbGV0IG9wdHMgPSB7XG4gICAgICBsb2NhdGlvbjogd2luZG93LmxvY2F0aW9uLmhvc3RuYW1lLFxuICAgICAgcG9ydDogd2luZG93LmxvY2F0aW9uLnBvcnQsXG4gICAgICBwcm90b2NvbDogd2luZG93LmxvY2F0aW9uLnByb3RvY29sID09PSAnaHR0cHM6JyA/ICd3c3M6JyA6ICd3czonLFxuICAgIH1cblxuICAgIGlmIChwYXJhbXMpIE9iamVjdC5hc3NpZ24ob3B0cywgcGFyYW1zKVxuICAgIGlmIChvcHRzLnBvcnQpIG9wdHMubG9jYXRpb24gKz0gYDoke29wdHMucG9ydH1gXG5cbiAgICByZXR1cm4gbmV3IFByb21pc2UoKHJlc29sdmUsIHJlamVjdCkgPT4ge1xuICAgICAgdGhpcy53cyA9IG5ldyBXZWJTb2NrZXQoYCR7b3B0cy5wcm90b2NvbH0vLyR7b3B0cy5sb2NhdGlvbn0ke3RoaXMuZW5kcG9pbnR9YClcbiAgICAgIHRoaXMud3Mub25tZXNzYWdlID0gKG1zZykgPT4geyB0aGlzLmhhbmRsZU1lc3NhZ2UobXNnKSB9XG4gICAgICB0aGlzLndzLm9uY2xvc2UgPSAoKSA9PiB7XG4gICAgICAgIGlmICh0aGlzLmF0dGVtcHRSZWNvbm5lY3QpIHRoaXMuX3JlY29ubmVjdCgpXG4gICAgICB9XG4gICAgICB0aGlzLndzLm9ub3BlbiA9ICgpID0+IHtcbiAgICAgICAgdGhpcy5fcmVzZXQoKVxuICAgICAgICByZXNvbHZlKClcbiAgICAgIH1cbiAgICB9KVxuICB9XG5cbiAgLyoqXG4gICAqIENsb3NlcyB0aGUgc29ja2V0IGNvbm5lY3Rpb24gcGVybWFuZW50bHlcbiAgICovXG4gIGRpc2Nvbm5lY3QoKSB7XG4gICAgdGhpcy5hdHRlbXB0UmVjb25uZWN0ID0gZmFsc2VcbiAgICBjbGVhclRpbWVvdXQodGhpcy5wb2xsaW5nVGltZW91dClcbiAgICBjbGVhclRpbWVvdXQodGhpcy5yZWNvbm5lY3RUaW1lb3V0KVxuICAgIHRoaXMud3MuY2xvc2UoKVxuICB9XG5cbiAgLyoqXG4gICAqIEFkZHMgYSBuZXcgY2hhbm5lbCB0byB0aGUgc29ja2V0IGNoYW5uZWxzIGxpc3RcbiAgICogQHBhcmFtIHtTdHJpbmd9IHRvcGljIC0gVG9waWMgZm9yIHRoZSBjaGFubmVsOiBgY2hhdF9yb29tOjEyM2BcbiAgICovXG4gIGNoYW5uZWwodG9waWMpIHtcbiAgICBsZXQgY2hhbm5lbCA9IG5ldyBDaGFubmVsKHRvcGljLCB0aGlzKVxuICAgIHRoaXMuY2hhbm5lbHMucHVzaChjaGFubmVsKVxuICAgIHJldHVybiBjaGFubmVsXG4gIH1cblxuICAvKipcbiAgICogTWVzc2FnZSBoYW5kbGVyIGZvciBtZXNzYWdlcyByZWNlaXZlZFxuICAgKiBAcGFyYW0ge01lc3NhZ2VFdmVudH0gbXNnIC0gTWVzc2FnZSByZWNlaXZlZCBmcm9tIHdzXG4gICAqL1xuICBoYW5kbGVNZXNzYWdlKG1zZykge1xuICAgIGlmIChtc2cuZGF0YSA9PT0gXCJwaW5nXCIpIHJldHVybiB0aGlzLl9oYW5kbGVQaW5nKClcblxuICAgIGxldCBwYXJzZWRfbXNnID0gSlNPTi5wYXJzZShtc2cuZGF0YSlcbiAgICB0aGlzLmNoYW5uZWxzLmZvckVhY2goKGNoYW5uZWwpID0+IHtcbiAgICAgIGlmIChjaGFubmVsLnRvcGljID09PSBwYXJzZWRfbXNnLnRvcGljKSBjaGFubmVsLmhhbmRsZU1lc3NhZ2UocGFyc2VkX21zZylcbiAgICB9KVxuICB9XG59XG5cbm1vZHVsZS5leHBvcnRzID0ge1xuICBTb2NrZXQ6IFNvY2tldFxufVxuXG5cbi8qKlxuICogQWxsb3dzIGRlbGV0ZSBsaW5rcyB0byBwb3N0IGZvciBzZWN1cml0eSBhbmQgZWFzZSBvZiB1c2Ugc2ltaWxhciB0byBSYWlscyBqcXVlcnlfdWpzXG4gKi9cbmRvY3VtZW50LmFkZEV2ZW50TGlzdGVuZXIoXCJET01Db250ZW50TG9hZGVkXCIsIGZ1bmN0aW9uICgpIHtcbiAgICBkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKFwiYVtkYXRhLW1ldGhvZD0nZGVsZXRlJ11cIikuZm9yRWFjaChmdW5jdGlvbiAoZWxlbWVudCkge1xuICAgICAgICBlbGVtZW50LmFkZEV2ZW50TGlzdGVuZXIoXCJjbGlja1wiLCBmdW5jdGlvbiAoZSkge1xuICAgICAgICAgICAgZS5wcmV2ZW50RGVmYXVsdCgpO1xuICAgICAgICAgICAgdmFyIG1lc3NhZ2UgPSBlbGVtZW50LmdldEF0dHJpYnV0ZShcImRhdGEtY29uZmlybVwiKSB8fCBcIkFyZSB5b3Ugc3VyZT9cIjtcbiAgICAgICAgICAgIGlmIChjb25maXJtKG1lc3NhZ2UpKSB7XG4gICAgICAgICAgICAgICAgdmFyIGZvcm0gPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KFwiZm9ybVwiKTtcbiAgICAgICAgICAgICAgICB2YXIgaW5wdXQgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KFwiaW5wdXRcIik7XG4gICAgICAgICAgICAgICAgZm9ybS5zZXRBdHRyaWJ1dGUoXCJhY3Rpb25cIiwgZWxlbWVudC5nZXRBdHRyaWJ1dGUoXCJocmVmXCIpKTtcbiAgICAgICAgICAgICAgICBmb3JtLnNldEF0dHJpYnV0ZShcIm1ldGhvZFwiLCBcIlBPU1RcIik7XG4gICAgICAgICAgICAgICAgaW5wdXQuc2V0QXR0cmlidXRlKFwidHlwZVwiLCBcImhpZGRlblwiKTtcbiAgICAgICAgICAgICAgICBpbnB1dC5zZXRBdHRyaWJ1dGUoXCJuYW1lXCIsIFwiX21ldGhvZFwiKTtcbiAgICAgICAgICAgICAgICBpbnB1dC5zZXRBdHRyaWJ1dGUoXCJ2YWx1ZVwiLCBcIkRFTEVURVwiKTtcbiAgICAgICAgICAgICAgICBmb3JtLmFwcGVuZENoaWxkKGlucHV0KTtcbiAgICAgICAgICAgICAgICBkb2N1bWVudC5ib2R5LmFwcGVuZENoaWxkKGZvcm0pO1xuICAgICAgICAgICAgICAgIGZvcm0uc3VibWl0KCk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgIH0pXG4gICAgfSlcbn0pO1xuXG5cblxuLy8gV0VCUEFDSyBGT09URVIgLy9cbi8vIC4vbGliL2FtYmVyL2Fzc2V0cy9qcy9hbWJlci5qcyIsImlmIChkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgnc2ltcGxlLWxvZ2dlcicpKSB7XG4gIGxldCBzdGF0dXNGaWVsZCA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCdzdGF0dXMnKVxuICBsZXQgc3RhdHVzRHJvcGRvd24gPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgnc3RhdHVzLWRyb3Bkb3duJylcbiAgbGV0IHN0YXR1c0Ryb3Bkb3duT3B0aW9ucyA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCdzdGF0dXMtZHJvcGRvd24tb3B0aW9ucycpXG5cbiAgQXJyYXkuZnJvbShzdGF0dXNEcm9wZG93bk9wdGlvbnMuY2hpbGRyZW4pLmZvckVhY2goZHJvcGRvd25JdGVtID0+IHtcbiAgICBkcm9wZG93bkl0ZW0uYWRkRXZlbnRMaXN0ZW5lcignY2xpY2snLCAoZSkgPT4ge1xuICAgICAgbGV0IGl0ZW0gPSBlLnRhcmdldFxuICAgICAgbGV0IG5ld1N0YXR1cyA9IGl0ZW0uZ2V0QXR0cmlidXRlKCdkYXRhLXN0YXR1cycpLnRyaW0oKVxuICAgICAgbGV0IG5ld1N0YXR1c1RpdGxlID0gaXRlbS5pbm5lclRleHQudHJpbSgpXG5cbiAgICAgIGl0ZW0uaW5uZXJUZXh0ID0gc3RhdHVzRHJvcGRvd24uaW5uZXJUZXh0LnRyaW0oKVxuICAgICAgaXRlbS5zZXRBdHRyaWJ1dGUoJ2RhdGEtc3RhdHVzJywgc3RhdHVzRmllbGQuZ2V0QXR0cmlidXRlKCd2YWx1ZScpLnRyaW0oKSlcblxuICAgICAgc3RhdHVzRHJvcGRvd24uaW5uZXJUZXh0ID0gbmV3U3RhdHVzVGl0bGVcbiAgICAgIHN0YXR1c0ZpZWxkLnNldEF0dHJpYnV0ZSgndmFsdWUnLCBuZXdTdGF0dXMpXG4gICAgfSlcbiAgfSlcblxuICBsZXQgcGxheWVyRmllbGQgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgnb3Bwb25lbnQtaWQnKVxuICBsZXQgcGxheWVyRHJvcGRvd24gPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgncGxheWVyLWRyb3Bkb3duJylcbiAgbGV0IHBsYXllckRyb3Bkb3duT3B0aW9ucyA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCdwbGF5ZXItZHJvcGRvd24tb3B0aW9ucycpXG5cbiAgQXJyYXkuZnJvbShwbGF5ZXJEcm9wZG93bk9wdGlvbnMuY2hpbGRyZW4pLmZvckVhY2goZHJvcGRvd25JdGVtID0+IHtcbiAgICBkcm9wZG93bkl0ZW0uYWRkRXZlbnRMaXN0ZW5lcignY2xpY2snLCAoZSkgPT4ge1xuICAgICAgbGV0IGl0ZW0gPSBlLnRhcmdldFxuICAgICAgbGV0IG5ld1BsYXllcklkID0gaXRlbS5nZXRBdHRyaWJ1dGUoJ2RhdGEtcGxheWVyLWlkJykudHJpbSgpXG4gICAgICBsZXQgbmV3UGxheWVyTmFtZSA9IGl0ZW0uaW5uZXJUZXh0LnRyaW0oKVxuXG4gICAgICBpdGVtLmlubmVyVGV4dCA9IHBsYXllckRyb3Bkb3duLmlubmVyVGV4dC50cmltKClcbiAgICAgIGl0ZW0uc2V0QXR0cmlidXRlKCdkYXRhLXBsYXllci1pZCcsIHBsYXllckZpZWxkLmdldEF0dHJpYnV0ZSgndmFsdWUnKS50cmltKCkpXG5cbiAgICAgIHBsYXllckRyb3Bkb3duLmlubmVyVGV4dCA9IG5ld1BsYXllck5hbWVcbiAgICAgIHBsYXllckZpZWxkLnNldEF0dHJpYnV0ZSgndmFsdWUnLCBuZXdQbGF5ZXJJZClcbiAgICB9KVxuICB9KVxufVxuXG5cbi8vIFdFQlBBQ0sgRk9PVEVSIC8vXG4vLyAuL3NyYy9hc3NldHMvamF2YXNjcmlwdHMvZ2FtZS5qcyJdLCJzb3VyY2VSb290IjoiIn0=