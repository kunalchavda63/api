import 'package:api/core/models/src/sudoku_models/box_model.dart';
import 'package:api/core/models/src/sudoku_models/cell_model.dart';

class BoardModel {
  final List<List<CellModel>> cells;
  BoardModel({required this.cells});

 List<BoxModel> get boxes {
   return List.generate(9,(boxIndex){
     final boxCells = cells
         .expand((row) => row)
         .where((cell) => cell.box == boxIndex)
         .toList();
     return BoxModel(index: boxIndex, cells: boxCells);
   });
 }
}
