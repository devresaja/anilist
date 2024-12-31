part of 'ads_bloc.dart';

sealed class AdsEvent {}

final class ShowRewardedAdEvent extends AdsEvent {
  final bool isCheckAttemp;

  ShowRewardedAdEvent({required this.isCheckAttemp});
}
