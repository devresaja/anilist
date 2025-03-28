part of 'ads_bloc.dart';

sealed class AdsEvent {}

final class ShowRewardedAdEvent extends AdsEvent {
  final AdsType adsType;
  final bool isCheckAttempt;

  ShowRewardedAdEvent({
    required this.adsType,
    required this.isCheckAttempt,
  });
}
