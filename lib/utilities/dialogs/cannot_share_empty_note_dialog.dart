import 'package:flutter/widgets.dart' show BuildContext;
import 'package:test_flutter_mynotes/extensions/buildcontext/loc.dart';
import 'generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) async {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.sharing,
    content: context.loc.cannot_share_empty_note_prompt,
    optionsBuilder: () => {
      context.loc.ok: null,
    },
  );
}
