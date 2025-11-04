
import '../../app_ui.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      // primaryColor: AppColors.hex8a2b,
      // scaffoldBackgroundColor: AppColors.hexF2c9,
      appBarTheme: const AppBarTheme(
        // backgroundColor: AppColors.hex8a2b,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        // bodyLarge: TextStyle(color: AppColors.hex3b0a),
        // bodyMedium: TextStyle(color: AppColors.hex3b0a),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // backgroundColor: AppColors.hex8a2b,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      // primaryColor: AppColors.hex3b0a,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        // backgroundColor: AppColors.hex3b0a,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        // bodyLarge: TextStyle(color: AppColors.hexF2c9),
        // bodyMedium: TextStyle(color: AppColors.hexF2c9),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // backgroundColor: AppColors.hex3b0a,
          // foregroundColor: AppColors.hexF2c9,
        ),
      ),
    );
  }
}
