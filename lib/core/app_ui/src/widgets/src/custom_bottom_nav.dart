import '../../../app_ui.dart';


class CustomBottomNav extends StatelessWidget {
  final List<BottomNavModel> bottomNavList;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNav({
    super.key,
    required this.bottomNavList,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items:
          bottomNavList.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            );
          }).toList(),
    );
  }
}
