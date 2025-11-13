part of 'ads_bloc.dart';

sealed class AdsEvent {}

final class ShowRewardedAdEvent extends AdsEvent {
  final AdUnit adUnit;
  final bool isCheckAttempt;

  ShowRewardedAdEvent({required this.adUnit, required this.isCheckAttempt});
}
