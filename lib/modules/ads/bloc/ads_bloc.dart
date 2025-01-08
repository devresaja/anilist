import 'dart:async';
import 'dart:developer';
import 'package:anilist/modules/ads/data/unity_ads_api.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:bloc/bloc.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

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
      if (!await UnityAds.isInitialized()) {
        emit(ShowRewardedAdLoadedState());
        return;
      }

      if (!event.isCheckAttemp) {
        emit(ShowRewardedAdConfirmationState());
        return;
      }

      // Check remaining attempt
      // If attempt is 0, decrease attempt and continue
      // If ad is shown successfully, reset attempts to 5
      final attempt = await LocalStorageService.getRemainingTrailerAttempt();
      log(attempt.toString());

      if (attempt == 0) {
        final completer = Completer<void>();

        await UnityAdsApi.showVideoAd(
          onComplete: () async {
            await LocalStorageService.setRemainingTrailerAttempt(5);
            emit(ShowRewardedAdLoadedState());
            completer.complete();
          },
          onSkipped: () {
            emit(ShowRewardedAdSkippedState());
            completer.complete();
          },
          onFailed: (e) {
            emit(ShowRewardedAdFailedState(e));
            completer.complete();
          },
        );

        await completer.future;
      } else {
        await LocalStorageService.setRemainingTrailerAttempt(attempt - 1);
        emit(ShowRewardedAdLoadedState());
      }
    } catch (e) {
      emit(ShowRewardedAdFailedState(e.toString()));
    }
  }
}
