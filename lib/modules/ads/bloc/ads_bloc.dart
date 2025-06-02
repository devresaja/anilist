import 'dart:async';
import 'package:anilist/modules/ads/data/admob_api.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
// import 'package:anilist/modules/ads/data/unity_ads_api.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  AdsBloc() : super(AdsInitial()) {
    on<ShowRewardedAdEvent>(_showRewardedAd);
  }

  _showRewardedAd(ShowRewardedAdEvent event, Emitter<AdsState> emit) async {
    emit(ShowRewardedAdLoadingState());
    try {
      // If Unity Ads is not initialized, emit loaded state then return
      // if (!await UnityAds.isInitialized()) {
      //   emit(ShowRewardedAdLoadedState());
      //   return;
      // }

      if (kIsWeb) {
        emit(ShowRewardedAdLoadedState());
        return;
      }

      // Check remaining attempt
      // If attempt is not 0, decrease attempt and continue
      // If ad is shown successfully, reset attempts based on reward responses

      final attempt = await LocalStorageService.getRemainingAdsAttempt(
          adsType: event.adsType);

      if (attempt <= 0) {
        // show confirmation dialog if isCheckAttempt is true
        if (event.isCheckAttempt) {
          emit(ShowRewardedAdConfirmationState());
          return;
        }

        final completer = Completer<void>();

        await AdMobService.showRewardedAd(
          adsType: event.adsType,
          onComplete: (reward) async {
            await LocalStorageService.setRemainingAdsAttempt(
              adsType: event.adsType,
              value: reward.amount.toInt(),
            );

            emit(ShowRewardedAdLoadedState());
            completer.complete();
          },
          onSkipped: () {
            emit(ShowRewardedAdSkippedState());
            completer.complete();
          },
          onFailed: (e) {
            emit(ShowRewardedAdLoadedState());
            // emit(ShowRewardedAdFailedState(e));
            completer.complete();
          },
        );

        await completer.future;
      } else {
        await LocalStorageService.setRemainingAdsAttempt(
            adsType: event.adsType, value: attempt - 1);

        emit(ShowRewardedAdLoadedState());
      }
    } catch (e) {
      emit(ShowRewardedAdFailedState(e.toString()));
    }
  }
}
