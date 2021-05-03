import 'package:flash_tool/config/app_colors.dart';
import 'package:flash_tool/config/global.dart';
import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:termare_pty/termare_pty.dart';

class TerminalPage extends StatelessWidget {
  const TerminalPage({Key key, this.enableInput = false}) : super(key: key);

  final bool enableInput;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.gap_dp8),
      child: Material(
        color: AppColors.contentBorder,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TermarePty(
            enableInput: enableInput,
            controller: Global.instance.termareController,
            pseudoTerminal: Global.instance.pseudoTerminal,
          ),
        ),
      ),
    );
  }
}
