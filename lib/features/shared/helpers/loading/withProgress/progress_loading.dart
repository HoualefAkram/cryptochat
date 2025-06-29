import 'dart:async';

import 'package:cryptochat/features/shared/helpers/loading/withProgress/progress_loading_controller.dart';
import 'package:flutter/material.dart';

class ProgressLoadingScreen {
  static final ProgressLoadingScreen _shared =
      ProgressLoadingScreen._shareInstance();
  ProgressLoadingScreen._shareInstance();
  factory ProgressLoadingScreen() => _shared;

  ProgressLoadingScreenContoller? controller;

  void show({
    required BuildContext context,
    String? text,
    double? progress,
    bool useEvercamLogo = false,
  }) {
    if (controller?.update(progress ?? 0) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        text: text ?? "Loading...",
        progress: progress ?? 0,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  ProgressLoadingScreenContoller showOverlay({
    required BuildContext context,
    required String text,
    required double progress,
  }) {
    final loadingScreenProgress = StreamController<double>();
    loadingScreenProgress.add(progress);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      StreamBuilder(
                        stream: loadingScreenProgress.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final double? progress = snapshot.data;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "${progress?.toInt()}%",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);
    return ProgressLoadingScreenContoller(
      close: () {
        loadingScreenProgress.close();
        overlay.remove();
        return true;
      },
      update: (progress) {
        loadingScreenProgress.add(progress);
        return true;
      },
    );
  }
}
