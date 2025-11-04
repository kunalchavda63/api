import 'package:api/core/models/src/sudoku_models/cell_model.dart';

class BoxModel {
  final int index; // 0-8
  final List<CellModel> cells;

  BoxModel({required this.index,required this.cells});
}