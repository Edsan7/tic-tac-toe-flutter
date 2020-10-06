import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/core/winner_rules.dart';
import 'package:tictactoe/enums/player_type.dart';
import 'package:tictactoe/enums/winner_type.dart';
import 'package:tictactoe/models/game_tile.dart';

class GameController {
  List<GameTile> tiles = [];
  List<int> movesPlayer1 = [];
  List<int> movesPlayer2 = [];
  List<int> score = [];
  PlayerType currentPlayer;
  bool isSinglePlayer;

  bool get hasMoves =>
      (movesPlayer1.length + movesPlayer2.length) != BOARD_SIZE;

  GameController() {
    initialize();
    score = [0, 0];
  }

  void initialize() {
    movesPlayer1.clear();
    movesPlayer2.clear();
    currentPlayer = PlayerType.player1;
    isSinglePlayer = false;
    tiles = List<GameTile>.generate(BOARD_SIZE, (index) => GameTile(index + 1));
  }

  void mark(GameTile tile) {
    if (currentPlayer == PlayerType.player1) {
      tile.symbol = PLAYER_1_IMAGE;
      tile.color = PLAYER_1_COLOR;
      movesPlayer1.add(tile.id);
      currentPlayer = PlayerType.player2;
    } else {
      tile.symbol = PLAYER_2_IMAGE;
      tile.color = PLAYER_2_COLOR;
      movesPlayer2.add(tile.id);
      currentPlayer = PlayerType.player1;
    }
    tile.enable = false;
  }

  bool checkPlayerWinner(List<int> moves) {
    return winnerRules.any((rule) =>
        moves.contains(rule[0]) &&
        moves.contains(rule[1]) &&
        moves.contains(rule[2]));
  }

  WinnerType checkWinner() {
    if (checkPlayerWinner(movesPlayer1)) {
      score[0]++;
      return WinnerType.player1;
    }
    if (checkPlayerWinner(movesPlayer2)) {
      score[1]++;
      return WinnerType.player2;
    }
    return WinnerType.none;
  }

  int automaticMoves() {
    var moves = new List<int>.generate(BOARD_SIZE, (index) => index + 1);
    moves.removeWhere((element) => movesPlayer1.contains(element));
    moves.removeWhere((element) => movesPlayer2.contains(element));

    moves.shuffle();
    return moves[0];
  }
}
