import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class DeletePresensiButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return FButton(
      variant: .destructive,
      onPress: () {},
      size: .sm,
      child: Icon(FLucideIcons.trash, size: 20),
    );
  }
}
