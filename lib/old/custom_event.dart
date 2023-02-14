import 'dart:async';

/// KEYPOINTS:
/// * Only can use await in async function
/// * Function used with await should return `Future`
/// * Both stream and its controller are static variables, which have local scope with global lifetime. \
/// However the map is not, because each instance has their own events. If you want every instance to operate \
/// on same events, just inherit the CustomEvent (`with CustomEvent`) in your class, then use the specific \
/// operations you want.
/// * CustomEvent is a `mixin` type instead of `class`, since dart weirdly doesn't allow for inheritance of \
/// multiple classes (as Java does). Java uses abstract classes for that. Dart uses an additional type, called `mixin`.

mixin CustomEvent {
  ///stream controller
  static final _controller = StreamController<Map>();

  ///stream itself
  static final _stream = _controller.stream.asBroadcastStream();

  ///collection of all subscriptions for the instance
  /*not static*/ final Map<String, StreamSubscription> _subs = {};

  /// registers an event with name `event`
  Future<void>? on(String event, callback) {
    _subs[event] = _stream.listen(
      (data) {
        if (event == data["event"]) callback(data);
      },
    );
  }

  /// emits event with name `event` with `args`
  Future<void>? emit(String event, [Map? args]) {
    args = args ?? {};
    args["event"] = event;
    _controller.sink.add(args);
  }

  ///dispatches the event with name `event`, if exists
  Future<void>? dispatch(String event) {
    _subs[event]!.cancel();
    _subs.remove(event);
  }

  ///doesn't dispatch a specific event, closes the stream controller
  ///only the last widget should close the controller, which is global
  Future<void>? close() => _controller.close();
}
