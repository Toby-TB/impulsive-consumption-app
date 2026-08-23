import 'dart:async';

/// 轻量 combineLatest 实现，避免引入 rxdart。
Stream<R> combineLatest2<A, B, R>(
  Stream<A> streamA,
  Stream<B> streamB,
  R Function(A, B) combine,
) {
  StreamSubscription<A>? subA;
  StreamSubscription<B>? subB;
  var hasA = false, hasB = false;
  A? latestA;
  B? latestB;
  late final StreamController<R> controller;

  void emit() {
    if (hasA && hasB) controller.add(combine(latestA as A, latestB as B));
  }

  controller = StreamController<R>(
    onListen: () {
      subA = streamA.listen(
        (a) {
          latestA = a;
          hasA = true;
          emit();
        },
        onError: controller.addError,
      );
      subB = streamB.listen(
        (b) {
          latestB = b;
          hasB = true;
          emit();
        },
        onError: controller.addError,
      );
    },
    onPause: () {
      subA?.pause();
      subB?.pause();
    },
    onResume: () {
      subA?.resume();
      subB?.resume();
    },
    onCancel: () async {
      await subA?.cancel();
      await subB?.cancel();
    },
  );

  return controller.stream;
}

/// 三流合并。
Stream<R> combineLatest3<A, B, C, R>(
  Stream<A> streamA,
  Stream<B> streamB,
  Stream<C> streamC,
  R Function(A, B, C) combine,
) {
  StreamSubscription<A>? subA;
  StreamSubscription<B>? subB;
  StreamSubscription<C>? subC;
  var hasA = false, hasB = false, hasC = false;
  A? latestA;
  B? latestB;
  C? latestC;
  late final StreamController<R> controller;

  void emit() {
    if (hasA && hasB && hasC) {
      controller.add(combine(latestA as A, latestB as B, latestC as C));
    }
  }

  controller = StreamController<R>(
    onListen: () {
      subA = streamA.listen(
        (a) {
          latestA = a;
          hasA = true;
          emit();
        },
        onError: controller.addError,
      );
      subB = streamB.listen(
        (b) {
          latestB = b;
          hasB = true;
          emit();
        },
        onError: controller.addError,
      );
      subC = streamC.listen(
        (c) {
          latestC = c;
          hasC = true;
          emit();
        },
        onError: controller.addError,
      );
    },
    onPause: () {
      subA?.pause();
      subB?.pause();
      subC?.pause();
    },
    onResume: () {
      subA?.resume();
      subB?.resume();
      subC?.resume();
    },
    onCancel: () async {
      await subA?.cancel();
      await subB?.cancel();
      await subC?.cancel();
    },
  );

  return controller.stream;
}
