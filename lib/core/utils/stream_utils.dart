import 'dart:async';

/// 轻量 combineLatest 实现，避免引入 rxdart。
Stream<R> combineLatest2<A, B, R>(
  Stream<A> streamA,
  Stream<B> streamB,
  R Function(A, B) combine,
) {
  late StreamSubscription<A> subA;
  late StreamSubscription<B> subB;
  var hasA = false, hasB = false;
  A? latestA;
  B? latestB;
  final controller = StreamController<R>(sync: true);

  void emit() {
    if (hasA && hasB) controller.add(combine(latestA as A, latestB as B));
  }

  controller.onListen = () {
    subA = streamA.listen(
      (a) {
        latestA = a;
        hasA = true;
        emit();
      },
      onError: controller.addError,
      onDone: () {
        if (!hasB) controller.close();
      },
    );
    subB = streamB.listen(
      (b) {
        latestB = b;
        hasB = true;
        emit();
      },
      onError: controller.addError,
      onDone: () {
        if (!hasA) controller.close();
      },
    );
  };

  return controller.stream;
}
