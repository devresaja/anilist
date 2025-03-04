part of 'ads_bloc.dart';

sealed class AdsState {}

final class AdsInitial extends AdsState {}

final class ShowRewardedAdLoadingState extends AdsState {}

final class ShowRewardedAdConfirmationState extends AdsState {}

final class ShowRewardedAdLoadedState extends AdsState {}

final class ShowRewardedAdSkippedState extends AdsState {}

final class ShowRewardedAdFailedState extends AdsState {
  final String message;

  ShowRewardedAdFailedState(this.message);
}
