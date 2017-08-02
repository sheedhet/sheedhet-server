// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var SheedhetGame = (function() {
  var _deck;
  var _game;
  var _deck_size;
  var _current_player_position;

  var deck = function() {
    return _deck;
  };

  var game = function() {
    return _game;
  };

  var init = function() {
    var game_space = document.getElementById('container');
    var game_data_json = game_space.dataset.game;
    _game = JSON.parse(game_data_json);
    _deck = Deck();
    _deck_size = deck().cards.length;
    deck().mount(game_space);
    deck().cards.forEach(function(card) {
      card.rank = 1;
      card.suit = 4;
      card.setRankSuit(1, 4);
      card.setSide('back');
    });
    var pathname = window.location.pathname;
    var have_position = pathname.match(/players\/\d/) !== null;
    var playerid = parseInt(pathname.slice(pathname.lastIndexOf('/') + 1));
    _current_player_position = have_position ? playerid : false;
    deal_game();
  };

  var get_player = function(position) {
    return _game.players.find(function(player) {
      return player.position === position;
    });
  };

  var take_from_draw_pile = function(card_json) {
    var suit_string_to_int = {
      's': 0,
      'h': 1,
      'c': 2,
      'd': 3,
      'x': 4
    };
    var rank_string_to_int = {
      'a': 1,
      '2': 2,
      '3': 3,
      '4': 4,
      '5': 5,
      '6': 6,
      '7': 7,
      '8': 8,
      '9': 9,
      '10': 10,
      'j': 11,
      'q': 12,
      'k': 13,
      'x': 1
    };

    var suit_string = card_json.slice(-1);
    var suit = suit_string_to_int[suit_string];

    var rank_string = card_json.slice(0, -1);
    var rank = rank_string_to_int[rank_string];

    result = deck().cards[--_deck_size];
    result.rank = rank;
    result.suit = suit;
    var side = (card_json == 'xx') ? 'back' : 'front';
    result.setRankSuit(rank, suit);
    result.setSide(side);
    return result;
  };

  var deal_pile = function(pile_name, cards, player_angle_index, start_delay) {
    var spacing_x = -125;
    var spacing_y = 350;
    var delay = start_delay || 0;
    var pile_y_spacings = {
      'in_hand': 0,
      'face_up': 175,
      'face_down': 150
    };
    var player_rotation_angles = [0, 120, 240];
    var pile_size = cards.length;
    cards.forEach(function(card_json, i) {
      var x_origin = spacing_x + (i * 80);
      var y_origin = spacing_y - pile_y_spacings[pile_name];
      var angle = player_rotation_angles[player_angle_index];
      var angle_thing = rotate(0, 0, x_origin, y_origin, -angle);
      var nx = angle_thing[0];
      var ny = angle_thing[1];
      var card = take_from_draw_pile(card_json);
      card.animateTo({
        x: nx,
        y: ny,
        rot: angle + getRandomIntInclusive(-5, 5),
        delay: 40 * (i + delay),
        duration: 500,
        onProgress: function() { card.$el.style.zIndex = i + pile_y_spacings[pile_name]; }
      });
    });
  };

  var deal_player = function(player_position) {
    var player_angle_index = (player_position - _current_player_position) % 3;
    var player = get_player(player_position);
    var player_cards = player.cards;
    var j = 0;
    for (var pile_name in player_cards) {
      if (player_cards.hasOwnProperty(pile_name)) {
        deal_pile(pile_name, player_cards[pile_name], player_angle_index, (player_position * (Object.keys(player_cards).length + 1)) + j);
        j++;
      }
    }
  };

  var deal_game = function() {
    for (var i = 0; i < game().players.length; i++) {
      deal_player(i);
    }
  };

// try and deal everyone using the rotation matrix!!
  var rotate = function(cx, cy, x, y, angle) {
    var radians = (Math.PI / 180) * angle,
        cos = Math.cos(radians),
        sin = Math.sin(radians),
        nx = (cos * (x - cx)) + (sin * (y - cy)) + cx,
        ny = (cos * (y - cy)) - (sin * (x - cx)) + cy;
    return [nx, ny];
  };

  var positions = {
    'top': {
      'in_hand': [

      ],
      'face_up': [

      ],
      'face_down': [

      ]
    }
  };

  var getRandomIntInclusive = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  return {
    init: init,
    take_from_draw_pile: take_from_draw_pile,
    game: game,
    deck: deck,
    get_player:get_player,
    deal_game:deal_game,
  };
})();

document.addEventListener("DOMContentLoaded", SheedhetGame.init);
var b = document.querySelector('body');

(function() {
  var throttle = function(type, name, obj) {
    obj = obj || window;
    var running = false;
    var func = function() {
      if (running) { return; }
      running = true;
      requestAnimationFrame(function() {
        obj.dispatchEvent(new CustomEvent(name));
        running = false;
      });
    };
    obj.addEventListener(type, func);
  };

  /* init - you can init any event */
  throttle("resize", "optimizedResize");
})();

// handle event
window.addEventListener("optimizedResize", function() {
    var width = document.getElementById('windowidth');
    var height = document.getElementById('windowheight');
    width.textContent = window.innerWidth;
    height.textContent = window.innerHeight;
    var lesser = Math.min(window.innerWidth, window.innerHeight);
});
