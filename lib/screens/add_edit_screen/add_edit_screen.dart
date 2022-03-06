import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../repository/const_values.dart';
import '../../repository/helper_functions.dart';
import '../../repository/riverpod_context_operations.dart';
import '../../repository/todo_object.dart';
import '../../widgets/appbar/appbar.dart';
import '../../widgets/neumorphism_widgets.dart';
import '../../widgets/snack_bar.dart';
import '../main_screen/tabs/home_tab/providers/day_provider.dart';

class AddEditScreen extends StatefulWidget {
  const AddEditScreen();

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  late final TodoObject? argument =
      ModalRoute.of(context)!.settings.arguments as TodoObject?;

  late TodoObject data = argument ?? TodoObject.empty();

  late final ValueNotifier<DateTime> date = ValueNotifier<DateTime>(
    data.shouldCompleteDate,
  );

  @override
  void dispose() {
    super.dispose();
    date.dispose();
  }

  @override
  Widget build(final context) {
    final size = MediaQuery.of(context).size, theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarWidget(),
      body: Padding(
        padding: paddingH20,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: SizedBox(
              height: size.height - 70,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'title'.tr()),
                    initialValue: data.title,
                    style: theme.textTheme.headline4,
                    maxLines: 2,
                    onSaved: (final newValue) => data = data.copyWith(
                      title: newValue,
                    ),
                    validator: validateTitle,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'description'.tr()),
                    initialValue: data.description,
                    style: theme.textTheme.headline4,
                    maxLines: null,
                    onSaved: (final newValue) => data = data.copyWith(
                      description: newValue,
                    ),
                  ),
                  const SizedBox(height: 50),
                  NeumorphismButton(
                    padding: paddingH20V20,
                    onTap: setDate,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'date'.tr(),
                          style: theme.textTheme.headline2,
                        ),
                        ValueListenableBuilder<DateTime>(
                          valueListenable: date,
                          builder: (final context, final value, final _) {
                            return Text(
                              value.formatStringWithTime(),
                              style: theme.textTheme.headline5,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: NeumorphismButton(
                      padding: paddingH20V10,
                      onTap: save,
                      child: Text(
                        'save'.tr(),
                        style: theme.textTheme.headline2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateTitle(final String? value) {
    if (value == null || value.isEmpty) return 'required_title_error'.tr();

    return null;
  }

  Future<void> save() async {
    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) return;

    if (data.shouldCompleteDate.isBefore(
      DateTime.now().add(const Duration(seconds: 1)),
    )) {
      SnackBarHelper.show(
        message: 'date_past_error'.tr(),
        type: SnackType.error,
      );
      return;
    }

    data = data.copyWith(
      addedDate: DateTime.now().millisecondsSinceEpoch,
    );

    if (argument != null) return Navigator.pop(context, data);

    Navigator.pop(context);

    context.read(todoDayProvider(data.day).notifier).addNew(data);
  }

  Future<void> setDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: date.value,
      firstDate: date.value.subtract(twoYears),
      lastDate: date.value.add(twoYears),
    );

    if (selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: date.value.hour,
        minute: date.value.minute,
      ),
    );

    if (selectedTime == null) return;

    final reminderDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    date.value = reminderDate;

    data = data.copyWith(
      shouldCompleteDate: reminderDate,
      day: reminderDate.day,
      month: reminderDate.month - 1,
      year: reminderDate.year,
    );
  }

  static final _formKey = GlobalKey<FormState>();
}
