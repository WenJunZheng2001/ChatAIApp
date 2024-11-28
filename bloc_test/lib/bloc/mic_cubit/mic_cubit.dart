import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/data/message/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../constants/lisa_constants.dart';
import '../../data/auth/auth_service.dart';
import 'mic_state.dart';

class MicCubit extends Cubit<MicState> {
  late PorcupineManager? _porcupineManager;
  //final String _accessKey = dotenv.env['ACCESS_KEY'] ?? "";
  final String _accessKey = "fake_access_key";
  //final String lisaMobileUrl = dotenv.env['LISA_MOBILE_URL'] ?? "";
  final String lisaMobileUrl = "fake_url";
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  List<LocaleName> localLanguages = [];
  String? selectedLang;
  String audioPath = "";
  late FlutterTts flutterTts;
  final record = AudioRecorder();
  final player = AudioPlayer();
  List<dynamic> localLangAi = [];
  bool isSpeechToTextListening = false;
  bool _speechEnabled = false;
  bool porcupineEnabled = false;
  bool _isDoingSomething = false;
  bool _flutterTtsEnabled = false;
  bool shouldPorcuBeActive = false;
  bool isRecording = false;
  bool isPremium = false;

  MicCubit() : super(MicInitialState());

  void changeLang(String? lang) {
    print(lang);
    selectedLang = lang;
  }

  Future<void> changeAiLang(String? selectedAiLang) async {
    if (selectedAiLang == null) {
      return;
    }
    await flutterTts.setLanguage(selectedAiLang);
  }

  /// This has to happen only once per app
  Future<void> initServices() async {
    try {
      await initTts();
      await initSpeech();
      await initPorcupine();
      print("speech enabled");
    } catch (e) {
      emit(MicErrorState());
      print("error enabling speech");
    }
  }

  Future<void> initPorcupine() async {
    try {
      _porcupineManager = await PorcupineManager.fromKeywordPaths(
        _accessKey,
        [ehiLisaPpn, grazieLisaPpn],
        _wakeWordCallback,
        modelPath: lisaPv,
        errorCallback: _errorCallback,
      );
      porcupineEnabled = true;
    } catch (e) {}
  }

  Future<void> initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onStatus: onStatusCallback,
      );
      localLanguages = await _speechToText.locales();
    } catch (e) {}
  }

  Future<void> initTts() async {
    try {
      flutterTts = FlutterTts();
      localLangAi = await flutterTts.getLanguages;
      await flutterTts.setSpeechRate(0.5); // Imposta la velocità del parlato
      await flutterTts.setVolume(1.0); // Imposta il volume
      await flutterTts.setPitch(1.0); // Imposta il tono

      _flutterTtsEnabled = true;
    } catch (e) {}
  }

  Future<void> onStatusCallback(String? status) async {
    try {
      if (status == "done") {
        isSpeechToTextListening = false;
        emit(MicWaitingAiResponseState());
        if (_lastWords == "") {
          emit(MicReceivedAiResponseState(
              myQuestion: "", aiResponse: "Scusa non ho sentito bene."));
          _lastWords = "";
          _isDoingSomething = false;
          if (porcupineEnabled && shouldPorcuBeActive) {
            await _porcupineManager?.start();
          }
          _isDoingSomething = false;
          return;
        }
        final token = await AuthService.firebase().getIdToken();
        final response = await MessageRepository().getAiResponse(
          userMessage: _lastWords,
          lisaMobileUrl: lisaMobileUrl,
          token: token,
          fileAndImagesFromUser: null,
          isFileUploaded: false,
          isAudioMessage: false,
        );

        if (_flutterTtsEnabled == true) {
          await flutterTts.speak(response.answer);
        }

        emit(MicReceivedAiResponseState(
            myQuestion: _lastWords, aiResponse: response.answer));

        _lastWords = "";
        if (porcupineEnabled && shouldPorcuBeActive) {
          await _porcupineManager?.start();
        }
        _isDoingSomething = false;
        print("fine");
      }
      if (status == "listening") {
        _isDoingSomething = true;
        isSpeechToTextListening = true;

        emit(MicRecordingVoiceState(myWords: ''));
      }
    } catch (e) {
      _isDoingSomething = false;
      print("error$e");
    }
  }

  void _errorCallback(PorcupineException error) {
    print(error.message);
  }

  bool changeToPremium() {
    if (_isDoingSomething == false) {
      isPremium = !isPremium;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> endOngoingMicService() async {
    if (_speechEnabled == true) {
      if (isSpeechToTextListening == true) {
        await _speechToText.stop();
        return true;
      }
    }
    if (_isDoingSomething == true) {
      return true;
    }
    if (await record.hasPermission()) {
      if (isRecording == true) {
        isRecording = false;
        final path = await record.stop();

        print(path);
        //invio a server file e prendi risposta
        emit(MicWaitingAiResponseState());
        // final response = await Future.delayed(const Duration(seconds: 3), () {
        //   return "Ciao! Come posso aiutarti oggi?";
        // });
        final token = await AuthService.firebase().getIdToken();
        final response = await MessageRepository().getAiResponse(
          userMessage: "salutami in cinque lingue.",
          lisaMobileUrl: lisaMobileUrl,
          token: token,
          fileAndImagesFromUser: null,
          isFileUploaded: false,
          isAudioMessage: true,
        );
        final base64Audio = response.base64Audio;
        if (base64Audio != null) {
          final aiAudioPath = await writeFile(base64Audio);
          print(response.base64Audio);
          if (path != null) {
            print("null audio path");
            await player.play(UrlSource(aiAudioPath));
            print("fine");
          }

          emit(MicReceivedAiResponseState(
              myQuestion: "salutami in cinque lingue",
              aiResponse: response.answer));
          print("received ai response");
          _isDoingSomething = false;
          return true;
        }
      }
    }
    return false;
  }

  /// Each time to start a speech recognition session
  Future<void> handleMicButtonPressed() async {
    final didEndAService = await endOngoingMicService();
    if (didEndAService == true) {
      return;
    }
    if (isPremium) {
      await handleMicButtonPressedPremium();
    } else {
      await handleMicButtonPressedStandard();
    }
  }

  Future<void> handleMicButtonPressedStandard() async {
    if (_speechEnabled == false) {
      return;
    }
    try {
      await flutterTts.stop();

      await player.stop();
      await _porcupineManager?.stop();
      await _speechToText.listen(
          onResult: _onSpeechResult,
          pauseFor: const Duration(seconds: 3),
          localeId: selectedLang,
          listenOptions: SpeechListenOptions(autoPunctuation: true));
    } catch (e) {
      emit(MicErrorState());
      print(e.toString());
    }
  }

  Future<void> handleMicButtonPressedPremium() async {
    _isDoingSomething = true;
    try {
      if (await record.hasPermission()) {
        isRecording = true;

        await flutterTts.stop();

        await player.stop();
        final directory = await getTemporaryDirectory();
        audioPath = "${directory.path}/myaudio.m4a";
        await record.start(const RecordConfig(), path: audioPath);
        print("started recording");
        emit(MicRecordingVoiceState(myWords: ''));
        _isDoingSomething = false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _wakeWordCallback(int keywordIndex) async {
    if (keywordIndex == 0) {
      await flutterTts.stop();
      await handleMicButtonPressed();
    } else if (keywordIndex == 1) {
      await endOngoingMicService();
    }
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(result) {
    _lastWords = result.recognizedWords;
    emit(MicRecordingVoiceState(myWords: _lastWords));
  }

  Future<bool> togglePorcupine() async {
    if (porcupineEnabled == false) {
      return false;
    }
    if (shouldPorcuBeActive == true) {
      shouldPorcuBeActive = false;
      if (_isDoingSomething == false) {
        _porcupineManager?.stop();
      }
      return true;
    } else {
      shouldPorcuBeActive = true;
      if (_isDoingSomething == false) {
        _porcupineManager?.start();
      }
      return true;
    }
  }

  @override
  Future<void> close() async {
    // cancel streams
    await flutterTts.stop();
    await _speechToText.cancel();
    final porcupineManager = _porcupineManager;
    if (porcupineManager != null) {
      await porcupineManager.delete();
    }
    super.close();
  }

  Future<void> closePage() async {
    await flutterTts.stop();
    if (shouldPorcuBeActive == true && _porcupineManager != null) {
      shouldPorcuBeActive = false;
      _porcupineManager?.stop();
    }
    _lastWords = "";
    emit(MicInitialState());
  }

  Future<String> writeFile(String base64String) async {
    final decodedBytes = base64Decode(base64String);
    final directory = await getApplicationDocumentsDirectory();
    final fileAudio = File('${directory.path}/aiAudio.mp3');
    print(fileAudio.path);
    fileAudio.writeAsBytesSync(List.from(decodedBytes));
    return fileAudio.path;
  }
}
