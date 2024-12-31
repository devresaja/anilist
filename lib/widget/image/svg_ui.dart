import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgUI extends StatelessWidget {
  const SvgUI(
    this.svgSource, {
    super.key,
    this.onTap,
    this.size,
    this.padding,
    this.color,
    this.fit,
  });

  final String? svgSource;
  final Function()? onTap;
  final double? size;
  final EdgeInsets? padding;
  final Color? color;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return GestureDetector(onTap: onTap ?? () {}, child: buildView(context));
    }

    return buildView(context);
  }

  Widget buildView(BuildContext context) {
    if (svgSource == '') {
      return Container();
    }

    final String kkSource = 'assets/svgs/$svgSource';
    final Widget kkImage = SvgPicture.asset(
      kkSource,
      width: size,
      height: size,
      fit: fit ?? BoxFit.cover,
    );

    return Container(
      padding: padding ?? const EdgeInsets.all(0),
      child: kkImage,
    );
  }
}
