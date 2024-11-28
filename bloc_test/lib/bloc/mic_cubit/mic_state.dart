abstract class MicState {}

class MicInitialState extends MicState {}

class MicRecordingVoiceState extends MicState {
  final String myWords;

  MicRecordingVoiceState({required this.myWords});
}

class MicWaitingAiResponseState extends MicState {}

class MicReceivedAiResponseState extends MicState {
  final String myQuestion;
  final String aiResponse;

  MicReceivedAiResponseState(
      {required this.myQuestion, required this.aiResponse});
}

class MicErrorState extends MicState {}
