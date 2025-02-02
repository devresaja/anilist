part of 'ads_bloc.dart';

sealed class AdsEvent {}

final class ShowRewardedAdEvent extends AdsEvent {
  final bool isCheckAttempt;

  ShowRewardedAdEvent({required this.isCheckAttempt});
}
