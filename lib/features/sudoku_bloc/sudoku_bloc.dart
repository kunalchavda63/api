import 'package:api/core/models/src/sudoku_models/cell_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/src/sudoku_models/board_model.dart';
part 'sudoku_event.dart';
part 'sudoku_state.dart';


class SudokuBloc extends Bloc<SudokuEvent,SudokuState>{
  SudokuBloc() : super(SudokuInitial()) {
    on<GenerateSudokuBoard>(_onGenerateBoard);
    on<UpdatedCellValue>(_onUpdateCell);
  }

  void _onGenerateBoard(GenerateSudokuBoard event,Emitter<SudokuState> emit){
    final board = _generateEmptyBoard();
    emit(SudokuLoaded(board));
  }
}

void _onUpdateCell(UpdatedCellValue event,Emitter<SudokuState> state){
  if(state is SudokuLoaded){
    final current = (state as SudokuLoaded).board;
    final updateCells = List.generate(9,(r){
      return List.generate(9,(c){
        final oldCell = current.cells[r][c];
        if(r == event.row && c == event.col && !oldCell.isFixed){
          return oldCell.copyWith(value: event.value);
        }
        return oldCell;
      });
    });
    state(SudokuLoaded(BoardModel(cells: updateCells)));
  }
}




BoardModel _generateEmptyBoard(){
  final List<List<int?>> sample = [
    [5, 3, null, null, 7, null, null, null, null],
    [6, null, null, 1, 9, 5, null, null, null],
    [null, 9, 8, null, null, null, null, 6, null],
    [8, null, null, null, 6, null, null, null, 3],
    [4, null, null, 8, null, 3, null, null, 1],
    [7, null, null, null, 2, null, null, null, 6],
    [null, 6, null, null, null, null, 2, 8, null],
    [null, null, null, 4, 1, 9, null, null, 5],
    [null, null, null, null, 8, null, null, 7, 9],
  ];
  final cells = List.generate(9,(r){
    return List.generate(9,(c) {
      final box = (r~/3) * 3 + (c~/3);
      final value = sample[r][c];
      return CellModel(
          row: r,
          col: c,
          box: box,
      value: value,
      isFixed: value != null);
    });
  });
  return BoardModel(cells: cells);
}