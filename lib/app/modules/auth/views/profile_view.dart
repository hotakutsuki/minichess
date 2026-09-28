import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../utils/utils.dart';
import '../../../data/enums.dart';
import '../../../engine/modifier_catalog.dart';
import '../../../engine/rule_modifier.dart';
import '../../language/controllers/language_controller.dart';
import '../../language/views/select_languaje_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/auth_controller.dart';
import 'edit_email_dialog_view.dart';
import 'new_password_dialog_view.dart';

class ProfileView extends GetView<AuthController> {
  ProfileView({Key? key}) : super(key: key);
  LanguageController l = Get.find<LanguageController>();

  ImageProvider<Object> getAvatar() {
    if (controller.user.value?.photoUrl == null) {
      return Image.asset('assets/images/pieces/wkingd.png').image;
    }
    return Image.network(controller.user.value?.photoUrl ?? '').image;
  }

  Widget editableElement(String field, action) {
    return Row(
      children: [
        Text('${field.capitalizeFirst}:'),
        const Spacer(),
        Text(controller.user.value?.getProperty(field) ?? l.g('NotDefined')),
        TextButton(onPressed: action, child: const Icon(Icons.edit))
      ],
    );
  }

  Widget editPassword() {
    return SingleChildScrollView(
      child: TextField(
        controller: controller.passTextController,
        onSubmitted: (e) => controller.handleLoginOrCreate(),
        autofocus: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(l.g('UserName')),
          errorText: controller.userNameError.value,
        ),
      ),
    );
  }

  // Kept in Account rather than Home so this playtest-only tool does not crowd
  // the player-facing menu. It is compiled out of release builds.
  void _showSandboxPicker() {
    Get.dialog(
      SimpleDialog(
        backgroundColor: brackgroundColorSolid,
        title: const Text('Sandbox — probar modificador',
            style: TextStyle(color: Colors.white)),
        children: [
          for (final info in modifierCatalog)
            SimpleDialogOption(
              onPressed: () {
                Get.back();
                _pickSandboxSide(info);
              },
              child: ListTile(
                title: Text(info.name,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                    '${info.description}\n[${info.uses.map((u) => u.name).join(', ')}]'
                    '${info.source == null ? '' : ' — ${info.source}'}',
                    style: const TextStyle(color: Colors.white54)),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }

  void _pickSandboxSide(ModifierInfo info) {
    const options = {
      'Tú (protagonista)': ModifierSide.protagonist,
      'Enemigo (IA)': ModifierSide.antagonist,
      'Ambos': ModifierSide.both,
    };
    Get.dialog(
      SimpleDialog(
        backgroundColor: brackgroundColorSolid,
        title: Text('${info.name} — aplicar a',
            style: const TextStyle(color: Colors.white)),
        children: [
          for (final entry in options.entries)
            SimpleDialogOption(
              onPressed: () {
                Get.back();
                Get.find<HomeController>().startSandbox(info.build(entry.value));
              },
              child: Text(
                entry.key +
                    (entry.value == info.defaultSide ? '  ★' : ''),
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  SizedBox(
                      width: 30, child: Image.asset('assets/images/icon.png')),
                  Text(l.g('YourAccount'), style: const TextStyle(fontSize: 20),
                  ),
                ],
              )),
                  if (kDebugMode)
                    IconButton(
                        tooltip: 'Sandbox de modificadores',
                        onPressed: _showSandboxPicker,
                        icon: const Icon(Icons.science_outlined, size: 18)),
                  IconButton(
                   onPressed: () => Get.back(closeOverlays: true),
                   icon: const Icon(Icons.close))
            ],
          ),
          const Divider(
            height: 20,
          ),
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: brackgroundColor,
                backgroundImage: controller.uploading.value
                    ? null
                    : controller.user.value?.photoUrl == null
                        ? Image.asset('assets/images/icon.png').image
                        : Image.network(controller.user.value!.photoUrl!).image,
                radius: 75,
                child: controller.uploading.value
                    ? const CircularProgressIndicator()
                    : null,
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.orangeAccent,
                  heroTag: 'editButton',
                  onPressed: controller.selectFile,
                  child: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
          Text(
              '@${controller.user.value?.name ?? ''} / ${controller.user.value?.countryCode ?? 'unk'}',
              style: const TextStyle(fontSize: 28)),
          Text('${controller.user.value?.score ?? l.g('Loading')}',
              style: const TextStyle(fontSize: 28)),
          //add toggle buttons for language
          LanguageSelectionWidget(),
          Row(
            children: [
              Text(l.g('Email')),
              const Spacer(),
              Text(controller.user.value?.email ?? l.g('NotDefined')),
              IconButton(
                  onPressed: () {
                    Get.dialog(EditEmailDialogView(), barrierDismissible: true);
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          Row(
            children: [
              Text(l.g('Password')),
              const Spacer(),
              Text(controller.user.value?.password != null
                  ? "••••••••"
                  : l.g('NotDefined')),
              IconButton(
                  onPressed: () {
                    Get.dialog(NewPasswordDialogView(),
                        barrierDismissible: true);
                  },
                  icon: const Icon(Icons.edit)),
            ],
          ),
          OutlinedButton(
            onPressed: () {
              playButtonSound();
              controller.logout();
            },
            child: Text(l.g('Logout'), style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      );
    });
  }
}
