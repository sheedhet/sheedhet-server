// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var SheedhetGame = (function() {
  var _deck;
  var _game;

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
    deck().mount(game_space);
  };

  var get_card = function(card_json) {
    var suit_string_to_int = {
      's': 0,
      'h': 1,
      'c': 2,
      'd': 3
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
      'k': 13
    };

    var suit_string = card_json.slice(-1);
    var suit = suit_string_to_int[suit_string];

    var rank_string = card_json.slice(0, -1);
    var rank = rank_string_to_int[rank_string];

    var result = deck().cards.find( function(card) {
      return (card.rank === rank && card.suit === suit);
    });

    return result;
  };

  var deal_game = function() {
    var cards = player(0).cards;
    var starting_x = -100;
    var starting_y = 350;
    cards.face_down.forEach(function(card_json, i) {
      var card = get_card(card_json);
      card.animateTo({
        x: starting_x + (i * 30),
        y: starting_y,
        rot: 0,
        delay: i * 100,
        duration: 1000,
        onStart: function() { card.$el.style.zIndex = i; }
      });
    });
  };


  var player = function(position) {
    return _game.players.find(function(player) {
      return player.position === position;
    });
  };

  return {
    init: init,
    get_card: get_card,
    game: game,
    deck: deck,
    player:player,
    deal_game:deal_game,
  };
})();

document.addEventListener("DOMContentLoaded", SheedhetGame.init);
