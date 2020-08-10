abstract class LiveStreamEvents {
  LiveStreamEvents();

  @override
  List<Object> get props => null;
}

class JoinLive extends LiveStreamEvents {
  final int presenterId;
  JoinLive(
    this.presenterId,
  ) : super();
}
