//
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../app_ui.dart';
//
// class CustomCheckBox extends StatelessWidget {
//   final bool val;
//   final Border? border;
//   final Color? color;
//   final double? boxH;
//   final double? boxW;
//   final BorderRadius? borderRadius;
//   final Color? iconColor;
//   final double? iconSize;
//   final VoidCallback? onTap;
//
//   const CustomCheckBox({
//     super.key,
//     this.onTap,
//     this.val = false,
//     this.border,
//     this.color,
//     this.boxH,
//     this.boxW,
//     this.borderRadius,
//     this.iconColor,
//     this.iconSize,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CheckboxCubit, bool>(
//         builder: (context, isChecked) {
//           return CustomContainer(
//             onTap: onTap,
//             borderRadius: borderRadius ?? BorderRadius.circular(4),
//             alignment: Alignment.center,
//             h: boxH ?? 24,
//             w: boxW ?? 24,
//             color: color ?? AppColors.hex6469,
//             border: border ?? Border.all(color: Colors.grey),
//             child: isChecked
//                 ? Icon(
//               Icons.check,
//               color: iconColor ?? Colors.white,
//               size: iconSize ?? 16,
//             )
//                 : const SizedBox(),
//           );
//         },
//       );
//   }
// }
//
//
// class CheckboxCubit extends Cubit<bool>{
//   CheckboxCubit({bool initialVal = false}): super(initialVal);
//   void toggle() => emit(!state);
// }
