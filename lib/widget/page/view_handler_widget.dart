import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/button/custom_button.dart';
import 'package:anilist/widget/image/svg_ui.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

enum ViewMode { loading, loaded, empty, failed, loadMore, loadMax, maintenance }

class ViewHandlerWidget extends StatelessWidget {
  final ViewMode viewMode;
  final Widget child;
  final Function()? onTapError;
  final Widget? customLoading, customEmpty, customFailed, customMaintenance;
  const ViewHandlerWidget({
    required this.child,
    super.key,
    this.viewMode = ViewMode.loading,
    this.onTapError,
    this.customEmpty,
    this.customFailed,
    this.customLoading,
    this.customMaintenance,
  });

  static Widget empty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgUI('ic_empty.svg', size: 100),
        divide24,
        TextWidget(LocaleKeys.no_result_found, fontSize: 16),
        divide28,
      ],
    );
  }

  static Widget error({Function()? onTapError}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgUI('ic_error.svg', size: 100),
        TextWidget(LocaleKeys.something_wrong, color: AppColor.errorText),
        if (onTapError != null) ...[
          divide20,
          SizedBox(
            width: 200,
            child: CustomButton(text: 'Refresh', onTap: onTapError),
          ),
        ],
      ],
    );
  }

  static Widget maintenance() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgUI('ic_maintenance.svg', size: 100),
        divide24,
        TextWidget(LocaleKeys.not_available, fontSize: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (viewMode) {
      case ViewMode.loading:
        return customLoading ?? loading();
      case ViewMode.loaded || ViewMode.loadMore || ViewMode.loadMax:
        return child;
      case ViewMode.empty:
        return Center(child: customEmpty ?? empty());
      case ViewMode.failed:
        return Center(child: customFailed ?? error(onTapError: onTapError));
      case ViewMode.maintenance:
        return Center(child: customMaintenance ?? maintenance());
    }
  }
}
