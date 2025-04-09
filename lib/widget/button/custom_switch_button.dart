import 'package:anilist/constant/app_color.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

enum SwitchType { normal, language }

class CustomSwitchButton extends StatefulWidget {
  final bool value;
  final double? width, height;
  final Function(bool) onChanged;
  final bool initialValue;
  final bool enable;
  final bool isLoading;
  final SwitchType switchType;

  const CustomSwitchButton({
    super.key,
    required this.value,
    this.width,
    this.height,
    this.initialValue = false,
    required this.onChanged,
    this.enable = true,
    this.isLoading = false,
    this.switchType = SwitchType.normal,
  });

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<bool>.dual(
      current: widget.value,
      first: false,
      second: true,
      height: 24,
      spacing: 2,
      indicatorSize: const Size(20, 20),
      onChanged: widget.onChanged,
      animationCurve: Curves.linear,
      animationDuration: Duration(milliseconds: 300),
      iconBuilder: (value) => _buildIcon(value),
      textBuilder: (value) => _buildText(value),
      textMargin: EdgeInsets.only(right: 1),
      style: ToggleStyle(
        indicatorColor: AppColor.white,
        backgroundColor: _getBackgroundColor(),
        borderColor: Colors.transparent,
      ),
      indicatorTransition: ForegroundIndicatorTransition.rolling(),
      active: widget.enable,
      loading: widget.isLoading,
      loadingIconBuilder: (context, global) => CircularProgressIndicator(
        color: AppColor.primary,
      ),
    );
  }

  Widget _buildIcon(bool value) {
    if (widget.switchType == SwitchType.language) {
      return value
          ? Image.asset('assets/images/ic_lang_en.png', width: 32)
          : Image.asset('assets/images/ic_lang_id.png', width: 32);
    }
    return Container(); // Default icon for normal mode
  }

  Widget _buildText(bool value) {
    if (widget.switchType == SwitchType.language) {
      return FittedBox(
        child: TextWidget(
          value ? 'EN' : 'ID',
          fontSize: 12,
          color: AppColor.secondary,
          translate: false,
        ),
      );
    }
    return Container();
  }

  Color _getBackgroundColor() {
    if (widget.switchType == SwitchType.language) {
      return Color.fromARGB(255, 213, 215, 218);
    }
    return widget.isLoading
        ? Colors.transparent
        : widget.value
            ? AppColor.primary
            : Color.fromARGB(255, 213, 215, 218);
  }
}
