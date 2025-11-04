// import '../../../app_ui.dart';
//
// class CustomCanCopy extends StatelessWidget {
//   final String text;
//
//   const CustomCanCopy({super.key, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomContainer(
//       color: AppColors.hex3234.withAlpha(200),
//       borderRadius: BorderRadius.circular(20),
//       h: 40,
//       w: MediaQuery.of(context).size.width,
//       onTap: () {
//         // copyToClipboard(text);
//       },
//       border: Border.all(color: AppColors.hex3234),
//       alignment: Alignment.center,
//       padding: EdgeInsets.symmetric(horizontal: 5),
//       child: CustomText(
//         data: text,
//         textAlign: TextAlign.center,
//         style: BaseStyle.s10w700.c(AppColors.hex3234),
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
// }
