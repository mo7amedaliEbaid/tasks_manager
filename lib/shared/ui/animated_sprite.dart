import 'package:flutter/widgets.dart';

import 'package:tasks_manager/shared/ui/sprite.dart';

class AnimatedSprite extends AnimatedWidget {
  final ImageProvider image;
  final int frameWidth;
  final int frameHeight;

  const AnimatedSprite({
    super.key,
    required this.image,
    required this.frameWidth,
    required this.frameHeight,
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Sprite(
      image: image,
      frameWidth: frameWidth,
      frameHeight: frameHeight,
      frame: animation.value,
    );
  }
}
