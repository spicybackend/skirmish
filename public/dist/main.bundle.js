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

document.querySelectorAll("form").forEach(function (form) {
  form.querySelectorAll("form input[type=submit]").forEach(function (submissionElem) {
    var confirmationMessage = submissionElem.getAttribute("data-confirm");

    if (confirmationMessage) {
      submissionElem.addEventListener("click", function (e) {
        e.preventDefault();

        if (confirm(confirmationMessage)) {
          form.submit();
        }
      });
    }
  });
});

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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly8vd2VicGFjay9ib290c3RyYXAgMjY2MTUxNDc3YzE4NWY2ZGUxNzEiLCJ3ZWJwYWNrOi8vLy4vc3JjL2Fzc2V0cy9qYXZhc2NyaXB0cy9tYWluLmpzIiwid2VicGFjazovLy8uL2xpYi9hbWJlci9hc3NldHMvanMvYW1iZXIuanMiLCJ3ZWJwYWNrOi8vLy4vc3JjL2Fzc2V0cy9qYXZhc2NyaXB0cy9nYW1lLmpzIl0sIm5hbWVzIjpbIkRhdGUiLCJwcm90b3R5cGUiLCJ0b0dyYW5pdGUiLCJwYWQiLCJudW1iZXIiLCJnZXRVVENGdWxsWWVhciIsImdldFVUQ01vbnRoIiwiZ2V0VVRDRGF0ZSIsImdldFVUQ0hvdXJzIiwiZ2V0VVRDTWludXRlcyIsImdldFVUQ1NlY29uZHMiLCJkb2N1bWVudCIsInF1ZXJ5U2VsZWN0b3JBbGwiLCJmb3JFYWNoIiwiZm9ybSIsInN1Ym1pc3Npb25FbGVtIiwiY29uZmlybWF0aW9uTWVzc2FnZSIsImdldEF0dHJpYnV0ZSIsImFkZEV2ZW50TGlzdGVuZXIiLCJlIiwicHJldmVudERlZmF1bHQiLCJjb25maXJtIiwic3VibWl0IiwiRVZFTlRTIiwiam9pbiIsImxlYXZlIiwibWVzc2FnZSIsIlNUQUxFX0NPTk5FQ1RJT05fVEhSRVNIT0xEX1NFQ09ORFMiLCJTT0NLRVRfUE9MTElOR19SQVRFIiwibm93IiwiZ2V0VGltZSIsInNlY29uZHNTaW5jZSIsInRpbWUiLCJDaGFubmVsIiwidG9waWMiLCJzb2NrZXQiLCJvbk1lc3NhZ2VIYW5kbGVycyIsIndzIiwic2VuZCIsIkpTT04iLCJzdHJpbmdpZnkiLCJldmVudCIsIm1zZyIsImhhbmRsZXIiLCJzdWJqZWN0IiwiY2FsbGJhY2siLCJwYXlsb2FkIiwicHVzaCIsIlNvY2tldCIsImVuZHBvaW50IiwiY2hhbm5lbHMiLCJsYXN0UGluZyIsInJlY29ubmVjdFRyaWVzIiwiYXR0ZW1wdFJlY29ubmVjdCIsImNsZWFyVGltZW91dCIsInJlY29ubmVjdFRpbWVvdXQiLCJzZXRUaW1lb3V0IiwiY29ubmVjdCIsInBhcmFtcyIsIl9yZWNvbm5lY3QiLCJfcmVjb25uZWN0SW50ZXJ2YWwiLCJwb2xsaW5nVGltZW91dCIsIl9jb25uZWN0aW9uSXNTdGFsZSIsIl9wb2xsIiwiX3N0YXJ0UG9sbGluZyIsIm9wdHMiLCJsb2NhdGlvbiIsIndpbmRvdyIsImhvc3RuYW1lIiwicG9ydCIsInByb3RvY29sIiwiT2JqZWN0IiwiYXNzaWduIiwiUHJvbWlzZSIsInJlc29sdmUiLCJyZWplY3QiLCJXZWJTb2NrZXQiLCJvbm1lc3NhZ2UiLCJoYW5kbGVNZXNzYWdlIiwib25jbG9zZSIsIm9ub3BlbiIsIl9yZXNldCIsImNsb3NlIiwiY2hhbm5lbCIsImRhdGEiLCJfaGFuZGxlUGluZyIsInBhcnNlZF9tc2ciLCJwYXJzZSIsIm1vZHVsZSIsImV4cG9ydHMiLCJlbGVtZW50IiwiY3JlYXRlRWxlbWVudCIsImlucHV0Iiwic2V0QXR0cmlidXRlIiwiYXBwZW5kQ2hpbGQiLCJib2R5IiwiZ2V0RWxlbWVudEJ5SWQiLCJzdGF0dXNGaWVsZCIsInN0YXR1c0Ryb3Bkb3duIiwic3RhdHVzRHJvcGRvd25PcHRpb25zIiwiQXJyYXkiLCJmcm9tIiwiY2hpbGRyZW4iLCJkcm9wZG93bkl0ZW0iLCJpdGVtIiwidGFyZ2V0IiwibmV3U3RhdHVzIiwidHJpbSIsIm5ld1N0YXR1c1RpdGxlIiwiaW5uZXJUZXh0IiwicGxheWVyRmllbGQiLCJwbGF5ZXJEcm9wZG93biIsInBsYXllckRyb3Bkb3duT3B0aW9ucyIsIm5ld1BsYXllcklkIiwibmV3UGxheWVyTmFtZSJdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOzs7QUFHQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSxh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Q0FBd0IseUJBQXhCLENBQTVCOztBQUVBSSxRQUFNQyxJQUFOLENBQVdXLHNCQUFzQlYsUUFBakMsRUFBMkN6RixPQUEzQyxDQUFtRCx3QkFBZ0I7QUFDakUwRixpQkFBYXJGLGdCQUFiLENBQThCLE9BQTlCLEVBQXVDLFVBQUNDLENBQUQsRUFBTztBQUM1QyxVQUFJcUYsT0FBT3JGLEVBQUVzRixNQUFiO0FBQ0EsVUFBSVEsY0FBY1QsS0FBS3ZGLFlBQUwsQ0FBa0IsZ0JBQWxCLEVBQW9DMEYsSUFBcEMsRUFBbEI7QUFDQSxVQUFJTyxnQkFBZ0JWLEtBQUtLLFNBQUwsQ0FBZUYsSUFBZixFQUFwQjs7QUFFQUgsV0FBS0ssU0FBTCxHQUFpQkUsZUFBZUYsU0FBZixDQUF5QkYsSUFBekIsRUFBakI7QUFDQUgsV0FBS1gsWUFBTCxDQUFrQixnQkFBbEIsRUFBb0NpQixZQUFZN0YsWUFBWixDQUF5QixPQUF6QixFQUFrQzBGLElBQWxDLEVBQXBDOztBQUVBSSxxQkFBZUYsU0FBZixHQUEyQkssYUFBM0I7QUFDQUosa0JBQVlqQixZQUFaLENBQXlCLE9BQXpCLEVBQWtDb0IsV0FBbEM7QUFDRCxLQVZEO0FBV0QsR0FaRDtBQWFELEMiLCJmaWxlIjoibWFpbi5idW5kbGUuanMiLCJzb3VyY2VzQ29udGVudCI6WyIgXHQvLyBUaGUgbW9kdWxlIGNhY2hlXG4gXHR2YXIgaW5zdGFsbGVkTW9kdWxlcyA9IHt9O1xuXG4gXHQvLyBUaGUgcmVxdWlyZSBmdW5jdGlvblxuIFx0ZnVuY3Rpb24gX193ZWJwYWNrX3JlcXVpcmVfXyhtb2R1bGVJZCkge1xuXG4gXHRcdC8vIENoZWNrIGlmIG1vZHVsZSBpcyBpbiBjYWNoZVxuIFx0XHRpZihpbnN0YWxsZWRNb2R1bGVzW21vZHVsZUlkXSkge1xuIFx0XHRcdHJldHVybiBpbnN0YWxsZWRNb2R1bGVzW21vZHVsZUlkXS5leHBvcnRzO1xuIFx0XHR9XG4gXHRcdC8vIENyZWF0ZSBhIG5ldyBtb2R1bGUgKGFuZCBwdXQgaXQgaW50byB0aGUgY2FjaGUpXG4gXHRcdHZhciBtb2R1bGUgPSBpbnN0YWxsZWRNb2R1bGVzW21vZHVsZUlkXSA9IHtcbiBcdFx0XHRpOiBtb2R1bGVJZCxcbiBcdFx0XHRsOiBmYWxzZSxcbiBcdFx0XHRleHBvcnRzOiB7fVxuIFx0XHR9O1xuXG4gXHRcdC8vIEV4ZWN1dGUgdGhlIG1vZHVsZSBmdW5jdGlvblxuIFx0XHRtb2R1bGVzW21vZHVsZUlkXS5jYWxsKG1vZHVsZS5leHBvcnRzLCBtb2R1bGUsIG1vZHVsZS5leHBvcnRzLCBfX3dlYnBhY2tfcmVxdWlyZV9fKTtcblxuIFx0XHQvLyBGbGFnIHRoZSBtb2R1bGUgYXMgbG9hZGVkXG4gXHRcdG1vZHVsZS5sID0gdHJ1ZTtcblxuIFx0XHQvLyBSZXR1cm4gdGhlIGV4cG9ydHMgb2YgdGhlIG1vZHVsZVxuIFx0XHRyZXR1cm4gbW9kdWxlLmV4cG9ydHM7XG4gXHR9XG5cblxuIFx0Ly8gZXhwb3NlIHRoZSBtb2R1bGVzIG9iamVjdCAoX193ZWJwYWNrX21vZHVsZXNfXylcbiBcdF9fd2VicGFja19yZXF1aXJlX18ubSA9IG1vZHVsZXM7XG5cbiBcdC8vIGV4cG9zZSB0aGUgbW9kdWxlIGNhY2hlXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLmMgPSBpbnN0YWxsZWRNb2R1bGVzO1xuXG4gXHQvLyBkZWZpbmUgZ2V0dGVyIGZ1bmN0aW9uIGZvciBoYXJtb255IGV4cG9ydHNcbiBcdF9fd2VicGFja19yZXF1aXJlX18uZCA9IGZ1bmN0aW9uKGV4cG9ydHMsIG5hbWUsIGdldHRlcikge1xuIFx0XHRpZighX193ZWJwYWNrX3JlcXVpcmVfXy5vKGV4cG9ydHMsIG5hbWUpKSB7XG4gXHRcdFx0T2JqZWN0LmRlZmluZVByb3BlcnR5KGV4cG9ydHMsIG5hbWUsIHtcbiBcdFx0XHRcdGNvbmZpZ3VyYWJsZTogZmFsc2UsXG4gXHRcdFx0XHRlbnVtZXJhYmxlOiB0cnVlLFxuIFx0XHRcdFx0Z2V0OiBnZXR0ZXJcbiBcdFx0XHR9KTtcbiBcdFx0fVxuIFx0fTtcblxuIFx0Ly8gZ2V0RGVmYXVsdEV4cG9ydCBmdW5jdGlvbiBmb3IgY29tcGF0aWJpbGl0eSB3aXRoIG5vbi1oYXJtb255IG1vZHVsZXNcbiBcdF9fd2VicGFja19yZXF1aXJlX18ubiA9IGZ1bmN0aW9uKG1vZHVsZSkge1xuIFx0XHR2YXIgZ2V0dGVyID0gbW9kdWxlICYmIG1vZHVsZS5fX2VzTW9kdWxlID9cbiBcdFx0XHRmdW5jdGlvbiBnZXREZWZhdWx0KCkgeyByZXR1cm4gbW9kdWxlWydkZWZhdWx0J107IH0gOlxuIFx0XHRcdGZ1bmN0aW9uIGdldE1vZHVsZUV4cG9ydHMoKSB7IHJldHVybiBtb2R1bGU7IH07XG4gXHRcdF9fd2VicGFja19yZXF1aXJlX18uZChnZXR0ZXIsICdhJywgZ2V0dGVyKTtcbiBcdFx0cmV0dXJuIGdldHRlcjtcbiBcdH07XG5cbiBcdC8vIE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbFxuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5vID0gZnVuY3Rpb24ob2JqZWN0LCBwcm9wZXJ0eSkgeyByZXR1cm4gT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eS5jYWxsKG9iamVjdCwgcHJvcGVydHkpOyB9O1xuXG4gXHQvLyBfX3dlYnBhY2tfcHVibGljX3BhdGhfX1xuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5wID0gXCIvZGlzdFwiO1xuXG4gXHQvLyBMb2FkIGVudHJ5IG1vZHVsZSBhbmQgcmV0dXJuIGV4cG9ydHNcbiBcdHJldHVybiBfX3dlYnBhY2tfcmVxdWlyZV9fKF9fd2VicGFja19yZXF1aXJlX18ucyA9IDApO1xuXG5cblxuLy8gV0VCUEFDSyBGT09URVIgLy9cbi8vIHdlYnBhY2svYm9vdHN0cmFwIDI2NjE1MTQ3N2MxODVmNmRlMTcxIiwiaW1wb3J0IEFtYmVyIGZyb20gJ2FtYmVyJ1xuXG5pbXBvcnQgXCIuL2dhbWUuanNcIlxuXG5pZiAoIURhdGUucHJvdG90eXBlLnRvR3Jhbml0ZSkge1xuICAoZnVuY3Rpb24oKSB7XG5cbiAgICBmdW5jdGlvbiBwYWQobnVtYmVyKSB7XG4gICAgICBpZiAobnVtYmVyIDwgMTApIHtcbiAgICAgICAgcmV0dXJuICcwJyArIG51bWJlcjtcbiAgICAgIH1cbiAgICAgIHJldHVybiBudW1iZXI7XG4gICAgfVxuXG4gICAgRGF0ZS5wcm90b3R5cGUudG9HcmFuaXRlID0gZnVuY3Rpb24oKSB7XG4gICAgICByZXR1cm4gdGhpcy5nZXRVVENGdWxsWWVhcigpICtcbiAgICAgICAgJy0nICsgcGFkKHRoaXMuZ2V0VVRDTW9udGgoKSArIDEpICtcbiAgICAgICAgJy0nICsgcGFkKHRoaXMuZ2V0VVRDRGF0ZSgpKSArXG4gICAgICAgICcgJyArIHBhZCh0aGlzLmdldFVUQ0hvdXJzKCkpICtcbiAgICAgICAgJzonICsgcGFkKHRoaXMuZ2V0VVRDTWludXRlcygpKSArXG4gICAgICAgICc6JyArIHBhZCh0aGlzLmdldFVUQ1NlY29uZHMoKSkgIDtcbiAgICB9O1xuXG4gIH0oKSk7XG59XG5cbmRvY3VtZW50LnF1ZXJ5U2VsZWN0b3JBbGwoXCJmb3JtXCIpLmZvckVhY2goKGZvcm0pID0+IHtcbiAgZm9ybS5xdWVyeVNlbGVjdG9yQWxsKFwiZm9ybSBpbnB1dFt0eXBlPXN1Ym1pdF1cIikuZm9yRWFjaCgoc3VibWlzc2lvbkVsZW0pID0+IHtcbiAgICBsZXQgY29uZmlybWF0aW9uTWVzc2FnZSA9IHN1Ym1pc3Npb25FbGVtLmdldEF0dHJpYnV0ZShcImRhdGEtY29uZmlybVwiKTtcblxuICAgIGlmIChjb25maXJtYXRpb25NZXNzYWdlKSB7XG4gICAgICBzdWJtaXNzaW9uRWxlbS5hZGRFdmVudExpc3RlbmVyKFwiY2xpY2tcIiwgZnVuY3Rpb24oZSkge1xuICAgICAgICBlLnByZXZlbnREZWZhdWx0KClcblxuICAgICAgICBpZiAoY29uZmlybShjb25maXJtYXRpb25NZXNzYWdlKSkge1xuICAgICAgICAgIGZvcm0uc3VibWl0KClcbiAgICAgICAgfVxuICAgICAgfSlcbiAgICB9XG4gIH0pXG59KVxuXG5cblxuLy8gV0VCUEFDSyBGT09URVIgLy9cbi8vIC4vc3JjL2Fzc2V0cy9qYXZhc2NyaXB0cy9tYWluLmpzIiwiY29uc3QgRVZFTlRTID0ge1xuICBqb2luOiAnam9pbicsXG4gIGxlYXZlOiAnbGVhdmUnLFxuICBtZXNzYWdlOiAnbWVzc2FnZSdcbn1cbmNvbnN0IFNUQUxFX0NPTk5FQ1RJT05fVEhSRVNIT0xEX1NFQ09ORFMgPSAxMDBcbmNvbnN0IFNPQ0tFVF9QT0xMSU5HX1JBVEUgPSAxMDAwMFxuXG4vKipcbiAqIFJldHVybnMgYSBudW1lcmljIHZhbHVlIGZvciB0aGUgY3VycmVudCB0aW1lXG4gKi9cbmxldCBub3cgPSAoKSA9PiB7XG4gIHJldHVybiBuZXcgRGF0ZSgpLmdldFRpbWUoKVxufVxuXG4vKipcbiAqIFJldHVybnMgdGhlIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGUgY3VycmVudCB0aW1lIGFuZCBwYXNzZWQgYHRpbWVgIGluIHNlY29uZHNcbiAqIEBwYXJhbSB7TnVtYmVyfERhdGV9IHRpbWUgLSBBIG51bWVyaWMgdGltZSBvciBkYXRlIG9iamVjdFxuICovXG5sZXQgc2Vjb25kc1NpbmNlID0gKHRpbWUpID0+IHtcbiAgcmV0dXJuIChub3coKSAtIHRpbWUpIC8gMTAwMFxufVxuXG4vKipcbiAqIENsYXNzIGZvciBjaGFubmVsIHJlbGF0ZWQgZnVuY3Rpb25zIChqb2luaW5nLCBsZWF2aW5nLCBzdWJzY3JpYmluZyBhbmQgc2VuZGluZyBtZXNzYWdlcylcbiAqL1xuZXhwb3J0IGNsYXNzIENoYW5uZWwge1xuICAvKipcbiAgICogQHBhcmFtIHtTdHJpbmd9IHRvcGljIC0gdG9waWMgdG8gc3Vic2NyaWJlIHRvXG4gICAqIEBwYXJhbSB7U29ja2V0fSBzb2NrZXQgLSBBIFNvY2tldCBpbnN0YW5jZVxuICAgKi9cbiAgY29uc3RydWN0b3IodG9waWMsIHNvY2tldCkge1xuICAgIHRoaXMudG9waWMgPSB0b3BpY1xuICAgIHRoaXMuc29ja2V0ID0gc29ja2V0XG4gICAgdGhpcy5vbk1lc3NhZ2VIYW5kbGVycyA9IFtdXG4gIH1cblxuICAvKipcbiAgICogSm9pbiBhIGNoYW5uZWwsIHN1YnNjcmliZSB0byBhbGwgY2hhbm5lbHMgbWVzc2FnZXNcbiAgICovXG4gIGpvaW4oKSB7XG4gICAgdGhpcy5zb2NrZXQud3Muc2VuZChKU09OLnN0cmluZ2lmeSh7IGV2ZW50OiBFVkVOVFMuam9pbiwgdG9waWM6IHRoaXMudG9waWMgfSkpXG4gIH1cblxuICAvKipcbiAgICogTGVhdmUgYSBjaGFubmVsLCBzdG9wIHN1YnNjcmliaW5nIHRvIGNoYW5uZWwgbWVzc2FnZXNcbiAgICovXG4gIGxlYXZlKCkge1xuICAgIHRoaXMuc29ja2V0LndzLnNlbmQoSlNPTi5zdHJpbmdpZnkoeyBldmVudDogRVZFTlRTLmxlYXZlLCB0b3BpYzogdGhpcy50b3BpYyB9KSlcbiAgfVxuXG4gIC8qKlxuICAgKiBDYWxscyBhbGwgbWVzc2FnZSBoYW5kbGVycyB3aXRoIGEgbWF0Y2hpbmcgc3ViamVjdFxuICAgKi9cbiAgaGFuZGxlTWVzc2FnZShtc2cpIHtcbiAgICB0aGlzLm9uTWVzc2FnZUhhbmRsZXJzLmZvckVhY2goKGhhbmRsZXIpID0+IHtcbiAgICAgIGlmIChoYW5kbGVyLnN1YmplY3QgPT09IG1zZy5zdWJqZWN0KSBoYW5kbGVyLmNhbGxiYWNrKG1zZy5wYXlsb2FkKVxuICAgIH0pXG4gIH1cblxuICAvKipcbiAgICogU3Vic2NyaWJlIHRvIGEgY2hhbm5lbCBzdWJqZWN0XG4gICAqIEBwYXJhbSB7U3RyaW5nfSBzdWJqZWN0IC0gc3ViamVjdCB0byBsaXN0ZW4gZm9yOiBgbXNnOm5ld2BcbiAgICogQHBhcmFtIHtmdW5jdGlvbn0gY2FsbGJhY2sgLSBjYWxsYmFjayBmdW5jdGlvbiB3aGVuIGEgbmV3IG1lc3NhZ2UgYXJyaXZlc1xuICAgKi9cbiAgb24oc3ViamVjdCwgY2FsbGJhY2spIHtcbiAgICB0aGlzLm9uTWVzc2FnZUhhbmRsZXJzLnB1c2goeyBzdWJqZWN0OiBzdWJqZWN0LCBjYWxsYmFjazogY2FsbGJhY2sgfSlcbiAgfVxuXG4gIC8qKlxuICAgKiBTZW5kIGEgbmV3IG1lc3NhZ2UgdG8gdGhlIGNoYW5uZWxcbiAgICogQHBhcmFtIHtTdHJpbmd9IHN1YmplY3QgLSBzdWJqZWN0IHRvIHNlbmQgbWVzc2FnZSB0bzogYG1zZzpuZXdgXG4gICAqIEBwYXJhbSB7T2JqZWN0fSBwYXlsb2FkIC0gcGF5bG9hZCBvYmplY3Q6IGB7bWVzc2FnZTogJ2hlbGxvJ31gXG4gICAqL1xuICBwdXNoKHN1YmplY3QsIHBheWxvYWQpIHtcbiAgICB0aGlzLnNvY2tldC53cy5zZW5kKEpTT04uc3RyaW5naWZ5KHsgZXZlbnQ6IEVWRU5UUy5tZXNzYWdlLCB0b3BpYzogdGhpcy50b3BpYywgc3ViamVjdDogc3ViamVjdCwgcGF5bG9hZDogcGF5bG9hZCB9KSlcbiAgfVxufVxuXG4vKipcbiAqIENsYXNzIGZvciBtYWludGFpbmluZyBjb25uZWN0aW9uIHdpdGggc2VydmVyIGFuZCBtYWludGFpbmluZyBjaGFubmVscyBsaXN0XG4gKi9cbmV4cG9ydCBjbGFzcyBTb2NrZXQge1xuICAvKipcbiAgICogQHBhcmFtIHtTdHJpbmd9IGVuZHBvaW50IC0gV2Vic29ja2V0IGVuZHBvbnQgdXNlZCBpbiByb3V0ZXMuY3IgZmlsZVxuICAgKi9cbiAgY29uc3RydWN0b3IoZW5kcG9pbnQpIHtcbiAgICB0aGlzLmVuZHBvaW50ID0gZW5kcG9pbnRcbiAgICB0aGlzLndzID0gbnVsbFxuICAgIHRoaXMuY2hhbm5lbHMgPSBbXVxuICAgIHRoaXMubGFzdFBpbmcgPSBub3coKVxuICAgIHRoaXMucmVjb25uZWN0VHJpZXMgPSAwXG4gICAgdGhpcy5hdHRlbXB0UmVjb25uZWN0ID0gdHJ1ZVxuICB9XG5cbiAgLyoqXG4gICAqIFJldHVybnMgd2hldGhlciBvciBub3QgdGhlIGxhc3QgcmVjZWl2ZWQgcGluZyBoYXMgYmVlbiBwYXN0IHRoZSB0aHJlc2hvbGRcbiAgICovXG4gIF9jb25uZWN0aW9uSXNTdGFsZSgpIHtcbiAgICByZXR1cm4gc2Vjb25kc1NpbmNlKHRoaXMubGFzdFBpbmcpID4gU1RBTEVfQ09OTkVDVElPTl9USFJFU0hPTERfU0VDT05EU1xuICB9XG5cbiAgLyoqXG4gICAqIFRyaWVzIHRvIHJlY29ubmVjdCB0byB0aGUgd2Vic29ja2V0IHNlcnZlciB1c2luZyBhIHJlY3Vyc2l2ZSB0aW1lb3V0XG4gICAqL1xuICBfcmVjb25uZWN0KCkge1xuICAgIGNsZWFyVGltZW91dCh0aGlzLnJlY29ubmVjdFRpbWVvdXQpXG4gICAgdGhpcy5yZWNvbm5lY3RUaW1lb3V0ID0gc2V0VGltZW91dCgoKSA9PiB7XG4gICAgICB0aGlzLnJlY29ubmVjdFRyaWVzKytcbiAgICAgIHRoaXMuY29ubmVjdCh0aGlzLnBhcmFtcylcbiAgICAgIHRoaXMuX3JlY29ubmVjdCgpXG4gICAgfSwgdGhpcy5fcmVjb25uZWN0SW50ZXJ2YWwoKSlcbiAgfVxuXG4gIC8qKlxuICAgKiBSZXR1cm5zIGFuIGluY3JlbWVudGluZyB0aW1lb3V0IGludGVydmFsIGJhc2VkIGFyb3VuZCB0aGUgbnVtYmVyIG9mIHJlY29ubmVjdGlvbiByZXRyaWVzXG4gICAqL1xuICBfcmVjb25uZWN0SW50ZXJ2YWwoKSB7XG4gICAgcmV0dXJuIFsxMDAwLCAyMDAwLCA1MDAwLCAxMDAwMF1bdGhpcy5yZWNvbm5lY3RUcmllc10gfHwgMTAwMDBcbiAgfVxuXG4gIC8qKlxuICAgKiBTZXRzIGEgcmVjdXJzaXZlIHRpbWVvdXQgdG8gY2hlY2sgaWYgdGhlIGNvbm5lY3Rpb24gaXMgc3RhbGVcbiAgICovXG4gIF9wb2xsKCkge1xuICAgIHRoaXMucG9sbGluZ1RpbWVvdXQgPSBzZXRUaW1lb3V0KCgpID0+IHtcbiAgICAgIGlmICh0aGlzLl9jb25uZWN0aW9uSXNTdGFsZSgpKSB7XG4gICAgICAgIHRoaXMuX3JlY29ubmVjdCgpXG4gICAgICB9IGVsc2Uge1xuICAgICAgICB0aGlzLl9wb2xsKClcbiAgICAgIH1cbiAgICB9LCBTT0NLRVRfUE9MTElOR19SQVRFKVxuICB9XG5cbiAgLyoqXG4gICAqIENsZWFyIHBvbGxpbmcgdGltZW91dCBhbmQgc3RhcnQgcG9sbGluZ1xuICAgKi9cbiAgX3N0YXJ0UG9sbGluZygpIHtcbiAgICBjbGVhclRpbWVvdXQodGhpcy5wb2xsaW5nVGltZW91dClcbiAgICB0aGlzLl9wb2xsKClcbiAgfVxuXG4gIC8qKlxuICAgKiBTZXRzIGBsYXN0UGluZ2AgdG8gdGhlIGN1cmVudCB0aW1lXG4gICAqL1xuICBfaGFuZGxlUGluZygpIHtcbiAgICB0aGlzLmxhc3RQaW5nID0gbm93KClcbiAgfVxuXG4gIC8qKlxuICAgKiBDbGVhcnMgcmVjb25uZWN0IHRpbWVvdXQsIHJlc2V0cyB2YXJpYWJsZXMgYW4gc3RhcnRzIHBvbGxpbmdcbiAgICovXG4gIF9yZXNldCgpIHtcbiAgICBjbGVhclRpbWVvdXQodGhpcy5yZWNvbm5lY3RUaW1lb3V0KVxuICAgIHRoaXMucmVjb25uZWN0VHJpZXMgPSAwXG4gICAgdGhpcy5hdHRlbXB0UmVjb25uZWN0ID0gdHJ1ZVxuICAgIHRoaXMuX3N0YXJ0UG9sbGluZygpXG4gIH1cblxuICAvKipcbiAgICogQ29ubmVjdCB0aGUgc29ja2V0IHRvIHRoZSBzZXJ2ZXIsIGFuZCBiaW5kcyB0byBuYXRpdmUgd3MgZnVuY3Rpb25zXG4gICAqIEBwYXJhbSB7T2JqZWN0fSBwYXJhbXMgLSBPcHRpb25hbCBwYXJhbWV0ZXJzXG4gICAqIEBwYXJhbSB7U3RyaW5nfSBwYXJhbXMubG9jYXRpb24gLSBIb3N0bmFtZSB0byBjb25uZWN0IHRvLCBkZWZhdWx0cyB0byBgd2luZG93LmxvY2F0aW9uLmhvc3RuYW1lYFxuICAgKiBAcGFyYW0ge1N0cmluZ30gcGFybWFzLnBvcnQgLSBQb3J0IHRvIGNvbm5lY3QgdG8sIGRlZmF1bHRzIHRvIGB3aW5kb3cubG9jYXRpb24ucG9ydGBcbiAgICogQHBhcmFtIHtTdHJpbmd9IHBhcmFtcy5wcm90b2NvbCAtIFByb3RvY29sIHRvIHVzZSwgZWl0aGVyICd3c3MnIG9yICd3cydcbiAgICovXG4gIGNvbm5lY3QocGFyYW1zKSB7XG4gICAgdGhpcy5wYXJhbXMgPSBwYXJhbXNcblxuICAgIGxldCBvcHRzID0ge1xuICAgICAgbG9jYXRpb246IHdpbmRvdy5sb2NhdGlvbi5ob3N0bmFtZSxcbiAgICAgIHBvcnQ6IHdpbmRvdy5sb2NhdGlvbi5wb3J0LFxuICAgICAgcHJvdG9jb2w6IHdpbmRvdy5sb2NhdGlvbi5wcm90b2NvbCA9PT0gJ2h0dHBzOicgPyAnd3NzOicgOiAnd3M6JyxcbiAgICB9XG5cbiAgICBpZiAocGFyYW1zKSBPYmplY3QuYXNzaWduKG9wdHMsIHBhcmFtcylcbiAgICBpZiAob3B0cy5wb3J0KSBvcHRzLmxvY2F0aW9uICs9IGA6JHtvcHRzLnBvcnR9YFxuXG4gICAgcmV0dXJuIG5ldyBQcm9taXNlKChyZXNvbHZlLCByZWplY3QpID0+IHtcbiAgICAgIHRoaXMud3MgPSBuZXcgV2ViU29ja2V0KGAke29wdHMucHJvdG9jb2x9Ly8ke29wdHMubG9jYXRpb259JHt0aGlzLmVuZHBvaW50fWApXG4gICAgICB0aGlzLndzLm9ubWVzc2FnZSA9IChtc2cpID0+IHsgdGhpcy5oYW5kbGVNZXNzYWdlKG1zZykgfVxuICAgICAgdGhpcy53cy5vbmNsb3NlID0gKCkgPT4ge1xuICAgICAgICBpZiAodGhpcy5hdHRlbXB0UmVjb25uZWN0KSB0aGlzLl9yZWNvbm5lY3QoKVxuICAgICAgfVxuICAgICAgdGhpcy53cy5vbm9wZW4gPSAoKSA9PiB7XG4gICAgICAgIHRoaXMuX3Jlc2V0KClcbiAgICAgICAgcmVzb2x2ZSgpXG4gICAgICB9XG4gICAgfSlcbiAgfVxuXG4gIC8qKlxuICAgKiBDbG9zZXMgdGhlIHNvY2tldCBjb25uZWN0aW9uIHBlcm1hbmVudGx5XG4gICAqL1xuICBkaXNjb25uZWN0KCkge1xuICAgIHRoaXMuYXR0ZW1wdFJlY29ubmVjdCA9IGZhbHNlXG4gICAgY2xlYXJUaW1lb3V0KHRoaXMucG9sbGluZ1RpbWVvdXQpXG4gICAgY2xlYXJUaW1lb3V0KHRoaXMucmVjb25uZWN0VGltZW91dClcbiAgICB0aGlzLndzLmNsb3NlKClcbiAgfVxuXG4gIC8qKlxuICAgKiBBZGRzIGEgbmV3IGNoYW5uZWwgdG8gdGhlIHNvY2tldCBjaGFubmVscyBsaXN0XG4gICAqIEBwYXJhbSB7U3RyaW5nfSB0b3BpYyAtIFRvcGljIGZvciB0aGUgY2hhbm5lbDogYGNoYXRfcm9vbToxMjNgXG4gICAqL1xuICBjaGFubmVsKHRvcGljKSB7XG4gICAgbGV0IGNoYW5uZWwgPSBuZXcgQ2hhbm5lbCh0b3BpYywgdGhpcylcbiAgICB0aGlzLmNoYW5uZWxzLnB1c2goY2hhbm5lbClcbiAgICByZXR1cm4gY2hhbm5lbFxuICB9XG5cbiAgLyoqXG4gICAqIE1lc3NhZ2UgaGFuZGxlciBmb3IgbWVzc2FnZXMgcmVjZWl2ZWRcbiAgICogQHBhcmFtIHtNZXNzYWdlRXZlbnR9IG1zZyAtIE1lc3NhZ2UgcmVjZWl2ZWQgZnJvbSB3c1xuICAgKi9cbiAgaGFuZGxlTWVzc2FnZShtc2cpIHtcbiAgICBpZiAobXNnLmRhdGEgPT09IFwicGluZ1wiKSByZXR1cm4gdGhpcy5faGFuZGxlUGluZygpXG5cbiAgICBsZXQgcGFyc2VkX21zZyA9IEpTT04ucGFyc2UobXNnLmRhdGEpXG4gICAgdGhpcy5jaGFubmVscy5mb3JFYWNoKChjaGFubmVsKSA9PiB7XG4gICAgICBpZiAoY2hhbm5lbC50b3BpYyA9PT0gcGFyc2VkX21zZy50b3BpYykgY2hhbm5lbC5oYW5kbGVNZXNzYWdlKHBhcnNlZF9tc2cpXG4gICAgfSlcbiAgfVxufVxuXG5tb2R1bGUuZXhwb3J0cyA9IHtcbiAgU29ja2V0OiBTb2NrZXRcbn1cblxuXG4vKipcbiAqIEFsbG93cyBkZWxldGUgbGlua3MgdG8gcG9zdCBmb3Igc2VjdXJpdHkgYW5kIGVhc2Ugb2YgdXNlIHNpbWlsYXIgdG8gUmFpbHMganF1ZXJ5X3Vqc1xuICovXG5kb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKFwiRE9NQ29udGVudExvYWRlZFwiLCBmdW5jdGlvbiAoKSB7XG4gICAgZG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbChcImFbZGF0YS1tZXRob2Q9J2RlbGV0ZSddXCIpLmZvckVhY2goZnVuY3Rpb24gKGVsZW1lbnQpIHtcbiAgICAgICAgZWxlbWVudC5hZGRFdmVudExpc3RlbmVyKFwiY2xpY2tcIiwgZnVuY3Rpb24gKGUpIHtcbiAgICAgICAgICAgIGUucHJldmVudERlZmF1bHQoKTtcbiAgICAgICAgICAgIHZhciBtZXNzYWdlID0gZWxlbWVudC5nZXRBdHRyaWJ1dGUoXCJkYXRhLWNvbmZpcm1cIikgfHwgXCJBcmUgeW91IHN1cmU/XCI7XG4gICAgICAgICAgICBpZiAoY29uZmlybShtZXNzYWdlKSkge1xuICAgICAgICAgICAgICAgIHZhciBmb3JtID0gZG9jdW1lbnQuY3JlYXRlRWxlbWVudChcImZvcm1cIik7XG4gICAgICAgICAgICAgICAgdmFyIGlucHV0ID0gZG9jdW1lbnQuY3JlYXRlRWxlbWVudChcImlucHV0XCIpO1xuICAgICAgICAgICAgICAgIGZvcm0uc2V0QXR0cmlidXRlKFwiYWN0aW9uXCIsIGVsZW1lbnQuZ2V0QXR0cmlidXRlKFwiaHJlZlwiKSk7XG4gICAgICAgICAgICAgICAgZm9ybS5zZXRBdHRyaWJ1dGUoXCJtZXRob2RcIiwgXCJQT1NUXCIpO1xuICAgICAgICAgICAgICAgIGlucHV0LnNldEF0dHJpYnV0ZShcInR5cGVcIiwgXCJoaWRkZW5cIik7XG4gICAgICAgICAgICAgICAgaW5wdXQuc2V0QXR0cmlidXRlKFwibmFtZVwiLCBcIl9tZXRob2RcIik7XG4gICAgICAgICAgICAgICAgaW5wdXQuc2V0QXR0cmlidXRlKFwidmFsdWVcIiwgXCJERUxFVEVcIik7XG4gICAgICAgICAgICAgICAgZm9ybS5hcHBlbmRDaGlsZChpbnB1dCk7XG4gICAgICAgICAgICAgICAgZG9jdW1lbnQuYm9keS5hcHBlbmRDaGlsZChmb3JtKTtcbiAgICAgICAgICAgICAgICBmb3JtLnN1Ym1pdCgpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICB9KVxuICAgIH0pXG59KTtcblxuXG5cbi8vIFdFQlBBQ0sgRk9PVEVSIC8vXG4vLyAuL2xpYi9hbWJlci9hc3NldHMvanMvYW1iZXIuanMiLCJpZiAoZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoJ3NpbXBsZS1sb2dnZXInKSkge1xuICBsZXQgc3RhdHVzRmllbGQgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgnc3RhdHVzJylcbiAgbGV0IHN0YXR1c0Ryb3Bkb3duID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoJ3N0YXR1cy1kcm9wZG93bicpXG4gIGxldCBzdGF0dXNEcm9wZG93bk9wdGlvbnMgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgnc3RhdHVzLWRyb3Bkb3duLW9wdGlvbnMnKVxuXG4gIEFycmF5LmZyb20oc3RhdHVzRHJvcGRvd25PcHRpb25zLmNoaWxkcmVuKS5mb3JFYWNoKGRyb3Bkb3duSXRlbSA9PiB7XG4gICAgZHJvcGRvd25JdGVtLmFkZEV2ZW50TGlzdGVuZXIoJ2NsaWNrJywgKGUpID0+IHtcbiAgICAgIGxldCBpdGVtID0gZS50YXJnZXRcbiAgICAgIGxldCBuZXdTdGF0dXMgPSBpdGVtLmdldEF0dHJpYnV0ZSgnZGF0YS1zdGF0dXMnKS50cmltKClcbiAgICAgIGxldCBuZXdTdGF0dXNUaXRsZSA9IGl0ZW0uaW5uZXJUZXh0LnRyaW0oKVxuXG4gICAgICBpdGVtLmlubmVyVGV4dCA9IHN0YXR1c0Ryb3Bkb3duLmlubmVyVGV4dC50cmltKClcbiAgICAgIGl0ZW0uc2V0QXR0cmlidXRlKCdkYXRhLXN0YXR1cycsIHN0YXR1c0ZpZWxkLmdldEF0dHJpYnV0ZSgndmFsdWUnKS50cmltKCkpXG5cbiAgICAgIHN0YXR1c0Ryb3Bkb3duLmlubmVyVGV4dCA9IG5ld1N0YXR1c1RpdGxlXG4gICAgICBzdGF0dXNGaWVsZC5zZXRBdHRyaWJ1dGUoJ3ZhbHVlJywgbmV3U3RhdHVzKVxuICAgIH0pXG4gIH0pXG5cbiAgbGV0IHBsYXllckZpZWxkID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoJ29wcG9uZW50LWlkJylcbiAgbGV0IHBsYXllckRyb3Bkb3duID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoJ3BsYXllci1kcm9wZG93bicpXG4gIGxldCBwbGF5ZXJEcm9wZG93bk9wdGlvbnMgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgncGxheWVyLWRyb3Bkb3duLW9wdGlvbnMnKVxuXG4gIEFycmF5LmZyb20ocGxheWVyRHJvcGRvd25PcHRpb25zLmNoaWxkcmVuKS5mb3JFYWNoKGRyb3Bkb3duSXRlbSA9PiB7XG4gICAgZHJvcGRvd25JdGVtLmFkZEV2ZW50TGlzdGVuZXIoJ2NsaWNrJywgKGUpID0+IHtcbiAgICAgIGxldCBpdGVtID0gZS50YXJnZXRcbiAgICAgIGxldCBuZXdQbGF5ZXJJZCA9IGl0ZW0uZ2V0QXR0cmlidXRlKCdkYXRhLXBsYXllci1pZCcpLnRyaW0oKVxuICAgICAgbGV0IG5ld1BsYXllck5hbWUgPSBpdGVtLmlubmVyVGV4dC50cmltKClcblxuICAgICAgaXRlbS5pbm5lclRleHQgPSBwbGF5ZXJEcm9wZG93bi5pbm5lclRleHQudHJpbSgpXG4gICAgICBpdGVtLnNldEF0dHJpYnV0ZSgnZGF0YS1wbGF5ZXItaWQnLCBwbGF5ZXJGaWVsZC5nZXRBdHRyaWJ1dGUoJ3ZhbHVlJykudHJpbSgpKVxuXG4gICAgICBwbGF5ZXJEcm9wZG93bi5pbm5lclRleHQgPSBuZXdQbGF5ZXJOYW1lXG4gICAgICBwbGF5ZXJGaWVsZC5zZXRBdHRyaWJ1dGUoJ3ZhbHVlJywgbmV3UGxheWVySWQpXG4gICAgfSlcbiAgfSlcbn1cblxuXG5cbi8vIFdFQlBBQ0sgRk9PVEVSIC8vXG4vLyAuL3NyYy9hc3NldHMvamF2YXNjcmlwdHMvZ2FtZS5qcyJdLCJzb3VyY2VSb290IjoiIn0=