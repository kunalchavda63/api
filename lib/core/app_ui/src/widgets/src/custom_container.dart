import '../../../app_ui.dart';

class CustomContainer extends StatelessWidget {
  final double? h;
  final double? w;
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final Alignment? alignment;
  final BoxShape? boxShape;
  final BlendMode? blendMode;
  final Clip? clipBehaviour;
  final String? path;
  final Gradient? gradient;
  final BoxDecoration? foregroundDecoration;



  const CustomContainer({
    super.key,
    this.h,
    this.w,
    this.child,
    this.padding,
    this.borderRadius,
    this.border,
    this.onTap,
    this.color,
    this.boxShadow,
    this.alignment,
    this.boxShape,
    this.blendMode,
    this.clipBehaviour,
    this.path,
    this.constraints,
    this.margin,
    this.gradient,
    this.foregroundDecoration
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        foregroundDecoration: foregroundDecoration,
        height: h,
        width: w,
        alignment: alignment,
        padding: padding,
        margin: margin,
        constraints: constraints,
        decoration: BoxDecoration(
          gradient: gradient,


          backgroundBlendMode: blendMode,
          image:
              path != null
                  ? DecorationImage(
                    opacity: 0.2,
                    fit: BoxFit.cover,
                    image: AssetImage(path ?? ''),
                  )
                  : null,
          border: border,
          borderRadius: borderRadius,
          color: color,
          boxShadow: boxShadow,
          shape: boxShape ?? BoxShape.rectangle,
        ),
        clipBehavior: clipBehaviour ?? Clip.none,
        child: child,
      ),
    );
  }
}
