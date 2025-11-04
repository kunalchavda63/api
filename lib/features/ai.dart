// pubspec.yaml dependencies:
// flutter:
//   sdk: flutter
// flutter_bloc: ^8.1.3
// equatable: ^2.0.5

// main.dart
import 'package:api/core/app_ui/app_ui.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const KillerSudokuApp());
}

class KillerSudokuApp extends StatelessWidget {
  const KillerSudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Killer Sudoku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: BlocProvider(
        create: (context) => SudokuBloc(),
        child: const SudokuScreen(),
      ),
    );
  }
}

// Models
class Cell {
  final int row;
  final int col;
  int? value;
  final bool isFixed;
  final int? cageSum;
  final int? cageId;
  Set<int> notes;

  Cell({
    required this.row,
    required this.col,
    this.value,
    this.isFixed = false,
    this.cageSum,
    this.cageId,
    Set<int>? notes,
  }) : notes = notes ?? {};

  Cell copyWith({
    int? value,
    Set<int>? notes,
    bool clearValue = false,
  }) {
    return Cell(
      row: row,
      col: col,
      value: clearValue ? null : (value ?? this.value),
      isFixed: isFixed,
      cageSum: cageSum,
      cageId: cageId,
      notes: notes ?? Set<int>.from(this.notes),
    );
  }
}

// Events
abstract class SudokuEvent {}

class SelectCell extends SudokuEvent {
  final int row;
  final int col;
  final int box;
  SelectCell(this.row, this.col, this.box);
}

class SetCellValue extends SudokuEvent {
  final int value;
  SetCellValue(this.value);
}

class UndoMove extends SudokuEvent {}

class EraseCell extends SudokuEvent {}

class ToggleNotesMode extends SudokuEvent {}

class GetHint extends SudokuEvent {}

// States
class SudokuState {
  final List<List<Cell>> grid;
  final int? selectedRow;
  final int? selectedCol;
  final int mistakes;
  final int timeSeconds;
  final bool notesMode;
  final List<List<List<Cell>>> history;

  SudokuState({
    required this.grid,
    this.selectedRow,
    this.selectedCol,
    this.mistakes = 0,
    this.timeSeconds = 0,
    this.notesMode = false,
    List<List<List<Cell>>>? history,
  }) : history = history ?? [];

  SudokuState copyWith({
    List<List<Cell>>? grid,
    int? selectedRow,
    int? selectedCol,
    int? mistakes,
    int? timeSeconds,
    bool? notesMode,
    List<List<List<Cell>>>? history,
  }) {
    return SudokuState(
      grid: grid ?? this.grid,
      selectedRow: selectedRow ?? this.selectedRow,
      selectedCol: selectedCol ?? this.selectedCol,
      mistakes: mistakes ?? this.mistakes,
      timeSeconds: timeSeconds ?? this.timeSeconds,
      notesMode: notesMode ?? this.notesMode,
      history: history ?? this.history,
    );
  }
}

// BLoC
class SudokuBloc extends Bloc<SudokuEvent, SudokuState> {
  SudokuBloc() : super(_initialState()) {
    on<SelectCell>(_onSelectCell);
    on<SetCellValue>(_onSetCellValue);
    on<UndoMove>(_onUndoMove);
    on<EraseCell>(_onEraseCell);
    on<ToggleNotesMode>(_onToggleNotesMode);
    on<GetHint>(_onGetHint);
  }

  static SudokuState _initialState() {
    return SudokuState(grid: _generateInitialGrid());
  }

  static List<List<Cell>> _generateInitialGrid() {
    // Level 1 Killer Sudoku puzzle (matching the screenshot)
    final grid = List.generate(
      9,
          (row) => List.generate(
        9,
            (col) => Cell(row: row, col: col),
      ),
    );

    // Set fixed values from the screenshot
    final fixedValues = [
      [0, 0, 5], [0, 1, 3], [0, 2, 4], [0, 4, 7], [0, 6, 1], [0, 7, 2],
      [1, 2, 2], [1, 4, 9], [1, 5, 5], [1, 7, 4],
      [2, 0, 1], [2, 1, 9], [2, 7, 6], [2, 8, 7],
      [3, 2, 9], [3, 3, 7], [3, 4, 6], [3, 5, 1], [3, 7, 2],
      [4, 0, 4], [4, 1, 2], [4, 2, 6], [4, 3, 8], [4, 5, 3], [4, 6, 7], [4, 8, 1],
      [5, 0, 7], [5, 3, 9], [5, 4, 2], [5, 5, 4], [5, 6, 8], [5, 7, 5],
      [6, 0, 9], [6, 1, 6], [6, 4, 3], [6, 5, 7],
      [7, 2, 8], [7, 4, 5], [7, 8, 5],
      [8, 0, 3], [8, 1, 4], [8, 2, 5], [8, 4, 8], [8, 5, 6], [8, 6, 1], [8, 7, 7],
    ];

    for (var pos in fixedValues) {
      grid[pos[0]][pos[1]] = Cell(
        row: pos[0],
        col: pos[1],
        value: pos[2],
        isFixed: true,
      );
    }

    // Set cage information (sum and cage ID)
    _setCageInfo(grid);

    return grid;
  }

  static void _setCageInfo(List<List<Cell>> grid) {
    // Define cages with their sums and cell positions
    final cages = [
      {'sum': 11, 'cells': [[0, 0], [1, 0]]},
      {'sum': 10, 'cells': [[0, 1], [0, 2]]},
      {'sum': 7, 'cells': [[0, 3], [1, 3]]},
      {'sum': 13, 'cells': [[0, 4]]},
      {'sum': 17, 'cells': [[0, 5], [0, 6]]},
      {'sum': 8, 'cells': [[0, 7]]},
      {'sum': 10, 'cells': [[0, 8], [1, 8]]},
      {'sum': 6, 'cells': [[1, 1], [1, 2]]},
      {'sum': 18, 'cells': [[1, 4], [1, 5]]},
      {'sum': 10, 'cells': [[1, 6], [1, 7]]},
      {'sum': 9, 'cells': [[2, 0]]},
      {'sum': 17, 'cells': [[2, 1], [3, 1]]},
      {'sum': 10, 'cells': [[2, 2], [2, 3]]},
      {'sum': 14, 'cells': [[2, 4], [2, 5]]},
      {'sum': 11, 'cells': [[2, 6], [3, 6]]},
      {'sum': 10, 'cells': [[2, 7]]},
      {'sum': 7, 'cells': [[2, 8]]},
      {'sum': 9, 'cells': [[3, 0]]},
      {'sum': 7, 'cells': [[3, 2]]},
      {'sum': 14, 'cells': [[3, 3], [3, 4], [3, 5]]},
      {'sum': 11, 'cells': [[3, 7]]},
      {'sum': 24, 'cells': [[3, 8], [4, 8]]},
      {'sum': 17, 'cells': [[4, 0], [5, 0]]},
      {'sum': 8, 'cells': [[4, 1], [4, 2]]},
      {'sum': 11, 'cells': [[4, 3]]},
      {'sum': 5, 'cells': [[4, 4]]},
      {'sum': 10, 'cells': [[4, 5], [4, 6]]},
      {'sum': 12, 'cells': [[4, 7], [5, 7]]},
      {'sum': 12, 'cells': [[5, 1], [5, 2]]},
      {'sum': 13, 'cells': [[5, 3], [5, 4], [5, 5]]},
      {'sum': 8, 'cells': [[5, 6]]},
      {'sum': 16, 'cells': [[6, 0], [6, 1]]},
      {'sum': 8, 'cells': [[6, 2], [6, 3]]},
      {'sum': 10, 'cells': [[6, 4], [6, 5]]},
      {'sum': 17, 'cells': [[6, 6], [7, 6]]},
      {'sum': 9, 'cells': [[6, 7], [6, 8]]},
      {'sum': 5, 'cells': [[7, 0]]},
      {'sum': 10, 'cells': [[7, 1], [7, 2]]},
      {'sum': 8, 'cells': [[7, 3], [7, 4]]},
      {'sum': 15, 'cells': [[7, 5], [8, 5]]},
      {'sum': 5, 'cells': [[7, 7]]},
      {'sum': 5, 'cells': [[7, 8]]},
      {'sum': 7, 'cells': [[8, 0]]},
      {'sum': 9, 'cells': [[8, 1], [8, 2]]},
      {'sum': 9, 'cells': [[8, 3], [8, 4]]},
      {'sum': 8, 'cells': [[8, 6], [8, 7]]},
      {'sum': 9, 'cells': [[8, 8]]},
    ];

    for (int i = 0; i < cages.length; i++) {
      final cage = cages[i];
      final cells = cage['cells'] as List;
      final sum = cage['sum'] as int;

      for (var cellPos in cells) {
        final row = cellPos[0] as int;
        final col = cellPos[1] as int;
        final existingCell = grid[row][col];
        grid[row][col] = Cell(
          row: row,
          col: col,
          value: existingCell.value,
          isFixed: existingCell.isFixed,
          cageSum: cells[0] == cellPos ? sum : null,
          cageId: i,
        );
      }
    }
  }

  void _onSelectCell(SelectCell event, Emitter<SudokuState> emit) {
    emit(state.copyWith(
      selectedRow: event.row,
      selectedCol: event.col,

    ));
  }

  void _onSetCellValue(SetCellValue event, Emitter<SudokuState> emit) {
    if (state.selectedRow == null || state.selectedCol == null) return;

    final cell = state.grid[state.selectedRow!][state.selectedCol!];
    if (cell.isFixed) return;

    // Save current state to history
    final newHistory = List<List<List<Cell>>>.from(state.history);
    newHistory.add(_copyGrid(state.grid));

    final newGrid = _copyGrid(state.grid);

    if (state.notesMode) {
      // Toggle note
      final newNotes = Set<int>.from(cell.notes);
      if (newNotes.contains(event.value)) {
        newNotes.remove(event.value);
      } else {
        newNotes.add(event.value);
      }
      newGrid[state.selectedRow!][state.selectedCol!] = cell.copyWith(notes: newNotes);
    } else {
      // Set value
      newGrid[state.selectedRow!][state.selectedCol!] = cell.copyWith(
        value: event.value,
        notes: {},
      );
    }

    emit(state.copyWith(
      grid: newGrid,
      history: newHistory,
    ));
  }

  void _onUndoMove(UndoMove event, Emitter<SudokuState> emit) {
    if (state.history.isEmpty) return;

    final newHistory = List<List<List<Cell>>>.from(state.history);
    final previousGrid = newHistory.removeLast();

    emit(state.copyWith(
      grid: previousGrid,
      history: newHistory,
    ));
  }

  void _onEraseCell(EraseCell event, Emitter<SudokuState> emit) {
    if (state.selectedRow == null || state.selectedCol == null) return;

    final cell = state.grid[state.selectedRow!][state.selectedCol!];
    if (cell.isFixed) return;

    final newHistory = List<List<List<Cell>>>.from(state.history);
    newHistory.add(_copyGrid(state.grid));

    final newGrid = _copyGrid(state.grid);
    newGrid[state.selectedRow!][state.selectedCol!] = cell.copyWith(
      clearValue: true,
      notes: {},
    );

    emit(state.copyWith(
      grid: newGrid,
      history: newHistory,
    ));
  }

  void _onToggleNotesMode(ToggleNotesMode event, Emitter<SudokuState> emit) {
    emit(state.copyWith(notesMode: !state.notesMode));
  }

  void _onGetHint(GetHint event, Emitter<SudokuState> emit) {
    // Simple hint: find an empty cell and show a possible value
    // This is a basic implementation
  }

  List<List<Cell>> _copyGrid(List<List<Cell>> grid) {
    return grid.map((row) => row.map((cell) => cell.copyWith()).toList()).toList();
  }
}

// UI
class SudokuScreen extends StatelessWidget {
  const SudokuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Center(
              child: _buildSudokuGrid(),
            ),
          ),
          _buildControls(),
          _buildNumberPad(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<SudokuBloc, SudokuState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Easy',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Text(
                'Mistake: ${state.mistakes}/3',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Row(
                children: [
                  Text(
                    _formatTime(state.timeSeconds),
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.pause, color: Colors.grey),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildSudokuGrid() {
    return BlocBuilder<SudokuBloc, SudokuState>(
      builder: (context, state) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              children: List.generate(9, (row) {
                return Expanded(
                  child: Row(
                    children: List.generate(9, (col) {
                      return _buildCell(context, state, row, col);
                    }),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

Widget _buildCell(BuildContext context, SudokuState state, int row, int col){
    final cell = state.grid[row][col];

    final isSelected = state.selectedRow == row && state.selectedCol == col;
    final isSameRow = state.selectedRow == row;
    final isSameCol = state.selectedCol == col;
    final isSameValue = cell.value != null &&
  state.selectedRow != null &&
  state.selectedCol != null &&
  state.grid[state.selectedRow!][state.selectedCol!].value == cell.value;
    Color bgColor = AppColors.white;
    if(isSelected){
      bgColor = Colors.blue.shade50;

    } else if (isSameRow || isSameCol || isSameValue){
      bgColor = Colors.grey.shade100;
    }
    final cageId = cell.cageId;
    bool topBorder = false;
    bool leftBorder = false;
    bool rightBorder = false;
    bool bottomBorder = false;
    bool topDotted = false;
    bool leftDotted = false;
    bool rightDotted = false;
    bool bottomDotted = false;
    if (cageId != null) {
      // Check top
      if (row == 0 || state.grid[row - 1][col].cageId != cageId) {
        topBorder = true;
      } else {
        topDotted = true;
      }
      // Check left
      if (col == 0 || state.grid[row][col - 1].cageId != cageId) {
        leftBorder = true;
      } else {
        leftDotted = true;
      }
      // Check right
      if (col == 8 || state.grid[row][col + 1].cageId != cageId) {
        rightBorder = true;
      } else {
        rightDotted = true;
      }
      // Check bottom
      if (row == 8 || state.grid[row + 1][col].cageId != cageId) {
        bottomBorder = true;
      } else {
        bottomDotted = true;
      }
    }
    // Also add 3x3 grid borders
    if (!rightBorder && (col + 1) % 3 == 0) {
      rightBorder = true;
      rightDotted = false;
    }
    if (!bottomBorder && (row + 1) % 3 == 0) {
      bottomBorder = true;
      bottomDotted = false;
    }
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<SudokuBloc>().add(SelectCell(row, col, cageId ?? 0));
        },
        child: DottedBorder(
          options: CustomPathDottedBorderOptions(
            color: Colors.grey.shade400,
            strokeWidth: 1.5,
            dashPattern: [3, 2],
            padding: EdgeInsets.zero,
            customPath: (size) {
              final path = Path();

              // Only draw dotted lines where needed
              if (topDotted) {
                path.moveTo(0, 0);
                path.lineTo(size.width, 0);
              }
              if (leftDotted) {
                path.moveTo(0, 0);
                path.lineTo(0, size.height);
              }
              if (rightDotted) {
                path.moveTo(size.width, 0);
                path.lineTo(size.width, size.height);
              }
              if (bottomDotted) {
                path.moveTo(0, size.height);
                path.lineTo(size.width, size.height);
              }

              return path;
            },


          ),

          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(
                top: topBorder
                    ? BorderSide(
                  color: Colors.black,
                  width: 1.5,
                )
                    : BorderSide.none,
                left: leftBorder
                    ? BorderSide(
                  color: Colors.black,
                  width: 1.5,
                )
                    : BorderSide.none,
                right: rightBorder
                    ? BorderSide(
                  color: Colors.black,
                  width: 1.5,
                )
                    : BorderSide.none,
                bottom: bottomBorder
                    ? BorderSide(
                  color: Colors.black,
                  width: 1.5,
                )
                    : BorderSide.none,
              ),
            ),
            child: Stack(
              children: [
                if (cell.cageSum != null)
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Text(
                      '${cell.cageSum}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Center(
                  child: cell.value != null
                      ? Text(
                    '${cell.value}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cell.isFixed ? Colors.black : Colors.blue,
                    ),
                  )
                      : cell.notes.isNotEmpty
                      ? _buildNotes(cell.notes)
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );


}
  Widget _buildNotes(Set<int> notes) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final number = index + 1;
        return Center(
          child: notes.contains(number)
              ? Text(
            '$number',
            style: const TextStyle(fontSize: 8, color: Colors.grey),
          )
              : const SizedBox(),
        );
      },
    );
  }

  Widget _buildControls() {
    return BlocBuilder<SudokuBloc, SudokuState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildControlButton(
                context,
                Icons.undo,
                'Undo',
                    () => context.read<SudokuBloc>().add(UndoMove()),
              ),
              _buildControlButton(
                context,
                Icons.delete_outline,
                'Erase',
                    () => context.read<SudokuBloc>().add(EraseCell()),
              ),
              _buildControlButton(
                context,
                state.notesMode ? Icons.edit : Icons.edit_outlined,
                'Notes',
                    () => context.read<SudokuBloc>().add(ToggleNotesMode()),
                isActive: state.notesMode,
              ),
              _buildControlButton(
                context,
                Icons.lightbulb_outline,
                'Hint',
                    () => context.read<SudokuBloc>().add(GetHint()),
                showBadge: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlButton(
      BuildContext context,
      IconData icon,
      String label,
      VoidCallback onPressed, {
        bool isActive = false,
        bool showBadge = false,
      }) {
    return Column(
      children: [
        Stack(
          children: [
            IconButton(
              icon: Icon(icon, color: isActive ? Colors.blue : Colors.grey),
              onPressed: onPressed,
              iconSize: 28,
            ),
            if (showBadge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberPad() {
    return BlocBuilder<SudokuBloc, SudokuState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(9, (index) {
              final number = index + 1;
              return InkWell(
                onTap: () {
                  context.read<SudokuBloc>().add(SetCellValue(number));
                },
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}