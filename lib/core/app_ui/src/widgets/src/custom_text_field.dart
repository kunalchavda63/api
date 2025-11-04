// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../../app_ui.dart';
//
// class CustomTextField extends StatefulWidget {
//   final String? label;
//   final String? hintText;
//   final String? Function(String?)? validator;
//   final InputBorder? border;
//   final TextEditingController? controller;
//   final Widget? suffixIcon;
//   final Widget? prefixIcon;
//   final EdgeInsets? padding;
//   final TextInputAction? textInputAction;
//   final TextInputType? textInputType;
//   final TextCapitalization? textCapitalization;
//   final bool? isExpand;
//   final bool? filled;
//   final Color? fillColor;
//   final TextStyle? style;
//   final TextStyle? hintStyle;
//   final TextStyle? labelStyle;
//   final FocusNode? focusNode;
//   final int? maxLength;
//   final String? initialValue;
//   final Color? cursorColor;
//   final bool? obscureText;
//   final  Function(String? val)? onChanged;
//
//
//   const CustomTextField({
//     super.key,
//     this.label,
//     this.hintText,
//     this.validator,
//     this.border,
//     this.controller,
//     this.suffixIcon,
//     this.prefixIcon,
//     this.padding,
//     this.textInputAction,
//     this.textInputType,
//     this.textCapitalization,
//     this.isExpand,
//     this.filled,
//     this.fillColor,
//     this.style,
//     this.hintStyle,
//     this.labelStyle,
//     this.focusNode,
//     this.maxLength,
//     this.initialValue,
//     this.cursorColor,
//     this.obscureText = false, this.onChanged
//   });
//
//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }
//
// class _CustomTextFieldState extends State<CustomTextField> {
//   late bool _obscure;
//
//   @override
//   void initState() {
//     super.initState();
//     _obscure = widget.obscureText ?? false;
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return TextFormField(
//       onChanged: widget.onChanged,
//       maxLengthEnforcement: MaxLengthEnforcement.none,
//       inputFormatters: [],
//       textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
//       initialValue: widget.initialValue,
//       focusNode: widget.focusNode,
//       keyboardType: widget.textInputType,
//       style: widget.style,
//       expands: widget.isExpand ?? false,
//       controller: widget.controller,
//       cursorColor: widget.cursorColor,
//       cursorHeight: 20,
//       textInputAction: widget.textInputAction,
//       maxLength: widget.maxLength,
//       decoration: InputDecoration(
//         border: widget.border,
//         focusedErrorBorder: widget.border,
//         errorBorder: widget.border,
//         enabledBorder: widget.border,
//         disabledBorder: widget.border,
//         focusedBorder: widget.border,
//         contentPadding: widget.padding,
//         hintText: widget.hintText,
//         labelText: widget.label,
//         floatingLabelStyle: widget.labelStyle,
//         hintStyle: widget.hintStyle,
//         labelStyle: widget.labelStyle,
//         filled: widget.filled,
//         fillColor: widget.fillColor,
//         prefixIcon: widget.prefixIcon,
//         suffixIcon: widget.obscureText==true
//             ? GestureDetector(
//             onTap: () => setState(() {
//               _obscure = !_obscure;
//             }),
//             child:SvgPicture.asset(
//                 _obscure == true ? AssetIcons.icEye:AssetIcons.icEyeOff,colorFilter: ColorFilter.mode(AppColors.hexB4b9,BlendMode.srcIn),)).padH(20.r):
//         widget.suffixIcon,
//         counterText: "",
//       ),
//       validator: widget.validator,
//       obscureText: _obscure,
//
//     );
//   }
// }
