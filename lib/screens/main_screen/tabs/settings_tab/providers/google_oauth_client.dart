// ignore_for_file: use_build_context_synchronously

import 'dart:io' as io;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/dfareporting/v3_4.dart';
import 'package:googleapis/drive/v3.dart' as gDrive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../repository/db_provider.dart';
import '../../../../../repository/drive_api_data.dart';
import '../../../../../repository/riverpod_context_operations.dart';
import '../../../../../root_app.dart';
import '../../../../../widgets/custoum_dialog.dart';
import '../../../../../widgets/snack_bar.dart';

final googleOAuthProvider =
    ChangeNotifierProvider<GoogleAuthClient>((final ref) {
  throw UnimplementedError();
});

class GoogleAuthClient extends ChangeNotifier {
  final String _path;

  GoogleAuthClient(this._path, final AccessCredentials? credentials) {
    if (credentials == null) return;

    final client = authenticatedClient(
      Client(),
      credentials,
    );

    _drive = gDrive.DriveApi(client);

    WidgetsBinding.instance?.addPostFrameCallback(
      (final timeStamp) => getBackup(),
    );
  }

  static const scopes = ['https://www.googleapis.com/auth/drive.appdata'];

  gDrive.DriveApi? _drive;

  bool get isNotLogin => _drive == null;

  Future<void> logIn() async {
    try {
      final client = await clientViaUserConsent(
        DriveApiData.clientId,
        scopes,
        _prompt,
      );

      await DriveApiData.saveCredentials(client.credentials);

      _drive = gDrive.DriveApi(client);

      notifyListeners();

      return getBackup();
    } catch (e) {
      SnackBarHelper.show(message: e.toString(), type: SnackType.error);
    }
  }

  Future<void> getBackup({final bool forceOverWrite = false}) async {
    if (isNotLogin) return;

    try {
      if (forceOverWrite)
        SnackBarHelper.show(message: 'getting_backup'.tr(), maxDuration: true);

      final files = await _drive!.files.list(
        spaces: 'appDataFolder',
        $fields: 'files(id, createdTime)',
        orderBy: 'createdTime',
      );

      if (files.files == null) return;

      _deleteOldBackups(files.files!);

      if (files.files?.isEmpty ?? true) {
        if (forceOverWrite)
          SnackBarHelper.show(
            message: 'backup_not_found'.tr(),
            type: SnackType.error,
          );

        return;
      }

      await _saveBackToStorage(
        files.files!.last.id!,
        files.files!.last.createdTime!,
        forceOverWrite,
      );
    } catch (e) {
      _handelInvaledToken(e);

      if (forceOverWrite)
        SnackBarHelper.show(message: e.toString(), type: SnackType.error);
    }
  }

  Future<void> backup({final bool showSnackBar = false}) async {
    if (isNotLogin) return;

    try {
      if (showSnackBar)
        SnackBarHelper.show(
          message: 'Backup_being_uploaded'.tr(),
          maxDuration: true,
        );

      final dbFile = io.File('$_path/todo_data.db');

      final fileLength = await dbFile.length();

      await _drive!.files.create(
        gDrive.File(parents: ['appDataFolder']),
        uploadMedia: gDrive.Media(
          dbFile.openRead(),
          fileLength,
        ),
        uploadOptions: gDrive.ResumableUploadOptions(),
      );

      if (showSnackBar)
        SnackBarHelper.show(
          message: 'Backup_uploaded'.tr(),
          type: SnackType.success,
        );
    } catch (e) {
      _handelInvaledToken(e);

      if (showSnackBar)
        SnackBarHelper.show(message: e.toString(), type: SnackType.error);
    }
  }

  Future<void> deleteBackUp(final String fileId) async {
    try {
      SnackBarHelper.show(message: 'delete_backup'.tr(), maxDuration: true);
      await _drive!.files.delete(fileId);
      SnackBarHelper.show(message: 'deleted'.tr(), type: SnackType.success);
    } catch (e) {
      _handelInvaledToken(e);
      SnackBarHelper.show(message: e.toString(), type: SnackType.error);
    }
  }

  Future<void> _deleteBackUp(final String fileId) async {
    try {
      await _drive!.files.delete(fileId);
    } catch (e) {
      _handelInvaledToken(e);
    }
  }

  Future<void> retriveBackUp(
    final String fileId,
    final DateTime createdTime,
  ) async {
    try {
      SnackBarHelper.show(message: 'Backup_recovery'.tr(), maxDuration: true);

      await _saveBackToStorage(
        fileId,
        createdTime,
        true,
      );
    } catch (e) {
      _handelInvaledToken(e);
      SnackBarHelper.show(message: e.toString(), type: SnackType.error);
    }
  }

  Future<void> _saveBackToStorage(
    final String fileId,
    final DateTime createdTime,
    final bool forceOverWrite,
  ) async {
    final file = await _drive!.files.get(
      fileId,
      downloadOptions: DownloadOptions.fullMedia,
    ) as Media;

    final List<int> fileBytes = [];

    file.stream.listen((final data) {
      fileBytes.insertAll(fileBytes.length, data);
    }, onDone: () async {
      try {
        final isDbTableEmpty =
            await router.context.read(dbProvider).isTableEmpty();

        if (isDbTableEmpty)
          return _setDbBackup(createdTime, fileBytes, forceOverWrite);

        final lastModifiedDate =
            await router.context.read(dbProvider).getDbModifiedDate();

        final isBackupNew = createdTime.isAfter(lastModifiedDate.toLocal());

        if (isBackupNew)
          return _setDbBackup(createdTime, fileBytes, forceOverWrite);

        if (forceOverWrite && !isBackupNew) {
          final isCancle = await showCancleDialog('old_backup_warning'.tr());

          if (isCancle) {
            SnackBarHelper.hide();
            return;
          } else {
            _setDbBackup(createdTime, fileBytes, forceOverWrite);
          }
        }
      } catch (e) {
        if (forceOverWrite)
          SnackBarHelper.show(message: e.toString(), type: SnackType.error);
      }
    }, onError: (final error) {
      if (forceOverWrite)
        SnackBarHelper.show(message: error.toString(), type: SnackType.error);
    });
  }

  void _prompt(final String userPrompt) {
    launch(userPrompt);
  }

  Future<void> _setDbBackup(
    final DateTime createdTime,
    final List<int> fileBytes,
    final bool forceOverWrite,
  ) async {
    await router.context.read(dbProvider).updateWithBackup(fileBytes);
    await router.context.read(dbProvider).setDbModifiedDate(
          createdTime.toLocal(),
        );

    if (forceOverWrite)
      SnackBarHelper.show(
        message: 'restored_Backup'.tr(),
        type: SnackType.success,
      );
  }

  Future<void> _deleteOldBackups(final List<gDrive.File> fileList) async {
    try {
      if (fileList.length >= 4) {
        for (int i = 0; i < fileList.length - 3; i++)
          await _deleteBackUp(
            fileList[i].id!,
          );
      }
    } catch (e) {
      _handelInvaledToken(e);
    }
  }

  void _handelInvaledToken(final Object e) {
    if (!e.toString().contains('token')) return;

    _drive = null;

    DriveApiData.deleteCredentials();

    notifyListeners();
  }
}

final backupListProvider =
    FutureProvider.autoDispose<Map<String, DateTime>>((final ref) async {
  final result = await ref.read(googleOAuthProvider)._drive!.files.list(
        spaces: 'appDataFolder',
        $fields: 'files(id, createdTime)',
        orderBy: 'createdTime',
      );

  if (result.files?.isEmpty ?? true) throw Exception('no_data'.tr());

  final Map<String, DateTime> data = {};

  result.files!.forEach((final element) {
    data.addAll({element.id!: element.createdTime!});
  });

  return data;
});
