import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class AuraEvent {}

class CheckInUpdated extends AuraEvent {
  final double stressIndex;
  final String? recommendedNudge;
  CheckInUpdated(this.stressIndex, this.recommendedNudge);
}

class ToggleDemoMode extends AuraEvent {
  final bool isDemo;
  ToggleDemoMode(this.isDemo);
}

// States
class AuraState {
  final double stressIndex;
  final String? activeNudge;
  final bool isDemoMode;
  
  AuraState({
    this.stressIndex = 0.5, 
    this.activeNudge, 
    this.isDemoMode = false
  });
  
  AuraState copyWith({
    double? stressIndex,
    String? activeNudge,
    bool? isDemoMode,
  }) {
    return AuraState(
      stressIndex: stressIndex ?? this.stressIndex,
      activeNudge: activeNudge ?? this.activeNudge,
      isDemoMode: isDemoMode ?? this.isDemoMode,
    );
  }
}

// BLoC
class AuraBloc extends Bloc<AuraEvent, AuraState> {
  AuraBloc() : super(AuraState()) {
    on<CheckInUpdated>((event, emit) {
      emit(state.copyWith(
        stressIndex: event.stressIndex, 
        activeNudge: event.recommendedNudge
      ));
    });
    
    on<ToggleDemoMode>((event, emit) {
      if (event.isDemo) {
        // Sarah's Demo Data
        emit(state.copyWith(
          isDemoMode: true,
          stressIndex: 0.85, 
          activeNudge: "triggerRespiteCareNudge"
        ));
      } else {
        emit(state.copyWith(
          isDemoMode: false,
          stressIndex: 0.5,
          activeNudge: null
        ));
      }
    });
  }
}
