import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:midjourney_flutter_app/feature/prompt/repos/prompt_repo.dart';

part 'prompt_event.dart';
part 'prompt_state.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  PromptBloc() : super(PromptInitial()) {
    on<PromptInitialEvent>(promptInitialEvent);
    on<PromptEnteredEvent>(promptEnteredEvent);
  }

  FutureOr<void> promptEnteredEvent(
      PromptEnteredEvent event, Emitter<PromptState> emit) async {
    emit(PromptGeneratingImageLoadState());
    Uint8List? bytes = await PromptRepo.generateImage(event.prompt);
    if (bytes != null) {
      emit(PromptGeneratingImageSuccessState(bytes));
    } else {
      emit(PromptGeneratingImageErrorState());
    }
  }

  FutureOr<void> promptInitialEvent(
      PromptInitialEvent event, Emitter<PromptState> emit) async {
    ByteData data = await rootBundle.load('assets/file.png');
    Uint8List bytes = data.buffer.asUint8List();
    emit(PromptGeneratingImageSuccessState(bytes));
  }
}
