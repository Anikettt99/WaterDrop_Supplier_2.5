// ignore_for_file: implementation_imports, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/src/MonthSelector.dart';
import 'package:month_picker_dialog/src/YearSelector.dart';
import 'package:month_picker_dialog/src/common.dart';
import 'package:month_picker_dialog/src/locale_utils.dart';
import 'package:rxdart/rxdart.dart';


Future<DateTime?> showMonthPickerCustom({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Locale? locale,
}) async {
  assert(context != null);
  assert(initialDate != null);
  final localizations = locale == null
      ? MaterialLocalizations.of(context)
      : await GlobalMaterialLocalizations.delegate.load(locale);
  assert(localizations != null);
  return await showDialog<DateTime>(
    context: context,
    builder: (context) => _MonthPickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: locale,
      localizations: localizations,
    ),
  );
}

class _MonthPickerDialog extends StatefulWidget {
  final DateTime? initialDate, firstDate, lastDate;
  final MaterialLocalizations localizations;
  final Locale? locale;

  const _MonthPickerDialog({
    Key? key,
    required this.initialDate,
    required this.localizations,
    this.firstDate,
    this.lastDate,
    this.locale,
  }) : super(key: key);

  @override
  _MonthPickerDialogState createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  final GlobalKey<YearSelectorState> _yearSelectorState = GlobalKey();
  final GlobalKey<MonthSelectorState> _monthSelectorState = GlobalKey();

  PublishSubject<UpDownPageLimit>? _upDownPageLimitPublishSubject;
  PublishSubject<UpDownButtonEnableState>?
  _upDownButtonEnableStatePublishSubject;

  Widget? _selector;
  DateTime? selectedDate, _firstDate, _lastDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(widget.initialDate!.year, widget.initialDate!.month);
    if (widget.firstDate != null) {
      _firstDate = DateTime(widget.firstDate!.year, widget.firstDate!.month);
    }
    if (widget.lastDate != null) {
      _lastDate = DateTime(widget.lastDate!.year, widget.lastDate!.month);
    }

    _upDownPageLimitPublishSubject = PublishSubject();
    _upDownButtonEnableStatePublishSubject = PublishSubject();

    _selector = MonthSelector(
      key: _monthSelectorState,
      openDate: selectedDate!,
      selectedDate: selectedDate!,
      upDownPageLimitPublishSubject: _upDownPageLimitPublishSubject!,
      upDownButtonEnableStatePublishSubject:
      _upDownButtonEnableStatePublishSubject!,
      firstDate: _firstDate,
      lastDate: _lastDate,
      onMonthSelected: _onMonthSelected,
      locale: widget.locale,
    );
  }

  void dispose() {
    _upDownPageLimitPublishSubject!.close();
    _upDownButtonEnableStatePublishSubject!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var locale = getLocale(context, selectedLocale: widget.locale);
    var header = buildHeader(theme, locale);
    var pager = buildPager(theme, locale);
    var content = Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [pager, buildButtonBar(context)],
      ),
      color: theme.dialogBackgroundColor,
    );
    return Theme(
      data:
      Theme.of(context).copyWith(dialogBackgroundColor: Colors.transparent),
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(builder: (context) {
              if (MediaQuery.of(context).orientation == Orientation.portrait) {
                return IntrinsicWidth(
                  child: Column(children: [header, content]),
                );
              }
              return IntrinsicHeight(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [header, content]),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildButtonBar(
      BuildContext context,
      ) {
    return ButtonBar(
      children: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(widget.localizations.cancelButtonLabel),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context, selectedDate),
          child: Text(widget.localizations.okButtonLabel),
        )
      ],
    );
  }

  Widget buildHeader(ThemeData theme, String locale) {
    return Material(
      color: theme.primaryColor,
    );
  }

  Widget buildPager(ThemeData theme, String locale) {
    return SizedBox(
      height: 230.0,
      width: 300.0,
      child: Theme(
        data: theme.copyWith(
          buttonTheme: ButtonThemeData(
            padding: EdgeInsets.all(2.0),
            shape: CircleBorder(),
            minWidth: 4.0,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 500),
          child: _selector,
        ),
      ),
    );
  }

  void _onSelectYear() => setState(() => _selector = YearSelector(
    key: _yearSelectorState,
    initialDate: selectedDate!,
    firstDate: _firstDate,
    lastDate: _lastDate,
    onYearSelected: _onYearSelected,
    upDownPageLimitPublishSubject: _upDownPageLimitPublishSubject!,
    upDownButtonEnableStatePublishSubject:
    _upDownButtonEnableStatePublishSubject!,
  ));

  void _onYearSelected(final int year) => null;

  void _onMonthSelected(final DateTime date) => setState(() {
    selectedDate = date;
    _selector = MonthSelector(
      key: _monthSelectorState,
      openDate: selectedDate!,
      selectedDate: selectedDate!,
      upDownPageLimitPublishSubject: _upDownPageLimitPublishSubject!,
      upDownButtonEnableStatePublishSubject:
      _upDownButtonEnableStatePublishSubject!,
      firstDate: _firstDate,
      lastDate: _lastDate,
      onMonthSelected: _onMonthSelected,
      locale: widget.locale,
    );
  });

  void _onUpButtonPressed() {
    if (_yearSelectorState.currentState != null) {
      _yearSelectorState.currentState!.goUp();
    } else {
      _monthSelectorState.currentState!.goUp();
    }
  }

  void _onDownButtonPressed() {
    if (_yearSelectorState.currentState != null) {
      _yearSelectorState.currentState!.goDown();
    } else {
      _monthSelectorState.currentState!.goDown();
    }
  }
}
