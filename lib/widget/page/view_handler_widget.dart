import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/button/custom_button.dart';
import 'package:anilist/widget/image/svg_ui.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

enum ViewMode {
  loading,
  loaded,
  empty,
  failed,
  loadMore,
  loadMax,
  maintenance,
}

class ViewHandlerWidget extends StatefulWidget {
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

  @override
  State<ViewHandlerWidget> createState() => _ViewHandlerWidgetState();
}

class _ViewHandlerWidgetState extends State<ViewHandlerWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.viewMode) {
      case ViewMode.loading:
        return widget.customLoading ?? loading();
      case ViewMode.loaded || ViewMode.loadMore || ViewMode.loadMax:
        return widget.child;
      case ViewMode.empty:
        return Center(
          child: widget.customEmpty ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgUI(
                    'ic_empty.svg',
                    size: 100,
                  ),
                  divide24,
                  TextWidget(
                    LocaleKeys.no_result_found,
                    fontSize: 16,
                  ),
                  divide28,
                ],
              ),
        );
      case ViewMode.failed:
        return Center(
          child: widget.customFailed ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgUI(
                    'ic_error.svg',
                    size: 100,
                  ),
                  TextWidget(
                    LocaleKeys.something_wrong,
                    color: AppColor.errorText,
                  ),
                  if (widget.onTapError != null) ...[
                    divide20,
                    SizedBox(
                      width: 200,
                      child: CustomButton(
                        text: 'Refresh',
                        onTap: widget.onTapError!,
                      ),
                    ),
                  ]
                ],
              ),
        );
      case ViewMode.maintenance:
        return Center(
          child: widget.customMaintenance ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgUI(
                    'ic_maintenance.svg',
                    size: 100,
                  ),
                  divide24,
                  TextWidget(
                    LocaleKeys.not_available,
                    fontSize: 16,
                  ),
                ],
              ),
        );
    }
  }
}
