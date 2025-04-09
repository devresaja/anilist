import 'package:anilist/constant/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/modules/my_list/bloc/my_list_bloc.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyListButton extends StatefulWidget {
  final Anime anime;
  const MyListButton({
    super.key,
    required this.anime,
  });

  @override
  State<MyListButton> createState() => _MyListButtonState();
}

class _MyListButtonState extends State<MyListButton> {
  late final MyListBloc _myListBloc;

  bool _isMyList = false;

  _getBloc() {
    _myListBloc.add(CheckMyListEvent(widget.anime));
  }

  @override
  void initState() {
    super.initState();
    _myListBloc = context.read<MyListBloc>();
    _getBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyListBloc, MyListState>(
      listener: (context, state) {
        if (state is CheckMyListLoadedState) {
          _isMyList = state.isMyList;
        } else if (state is CheckMyListFailedState) {
          showCustomSnackBar(state.message, isSuccess: false);
        } else if (state is AddMyListLoadedState) {
          _isMyList = true;
        } else if (state is AddMyListFailedState) {
          showCustomSnackBar(state.message, isSuccess: false);
        } else if (state is DeleteMyListLoadedState) {
          _isMyList = false;
        } else if (state is DeleteMyListFailedState) {
          showCustomSnackBar(state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (context.read<AppBloc>().state.user == null) {
                showAccessDeniedDialog(context);
                return;
              }

              if (_isMyList) {
                _myListBloc.add(DeleteMyListEvent(widget.anime.malId));
              } else {
                _myListBloc.add(AddMyListEvent(widget.anime));
              }
            },
            borderRadius: BorderRadius.circular(300),
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.secondaryAccent,
                borderRadius: BorderRadius.circular(300),
              ),
              child: Row(
                children: [
                  Icon(
                    _isMyList ? Icons.bookmark : Icons.bookmark_outline,
                    color: _isMyList ? AppColor.primary : AppColor.whiteAccent,
                    size: 18,
                  ),
                  divideW4,
                  TextWidget(
                    LocaleKeys.mylist,
                    color: _isMyList ? AppColor.primary : AppColor.whiteAccent,
                  ),
                  divideW4,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
