import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SheetAttend extends StatelessWidget {
  final FLayout side;
  const SheetAttend({required this.side, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .infinity,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: side.vertical
            ? .symmetric(
                horizontal: BorderSide(color: context.theme.colors.border),
              )
            : .symmetric(
                vertical: BorderSide(color: context.theme.colors.border),
              ),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 15, vertical: 8.0),
        child: Center(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                'Account',
                style: context.theme.typography.display.xl2.copyWith(
                  fontWeight: .w600,
                  color: context.theme.colors.foreground,
                  height: 1.5,
                ),
              ),
              Text(
                'Make changes to your account here. Click save when you are done.',
                style: context.theme.typography.body.sm.copyWith(
                  color: context.theme.colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 450,
                child: Column(
                  children: [
                    const FTextField(label: Text('Name'), hint: 'John Renalo'),
                    const SizedBox(height: 12),
                    const FTextField(
                      label: Text('Email'),
                      hint: 'john@doe.com',
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: .centerRight,
                      child: FButton(
                        size: .sm,
                        mainAxisSize: .min,
                        child: const Text('Save'),
                        onPress: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
