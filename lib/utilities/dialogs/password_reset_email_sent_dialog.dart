import 'package:flutter/widgets.dart' show BuildContext;
import 'package:test_flutter_mynotes/extensions/buildcontext/loc.dart';
import 'package:test_flutter_mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.password_reset,
    content: context.loc.password_reset_dialog_prompt,
    optionsBuilder: () => {
      context.loc.ok: null,
    },
  );
}
