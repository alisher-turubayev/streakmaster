import 'package:flutter/material.dart';

class SettingProperty {
  final String title;
  final String? subtitle;
  final String? heading; // To indicate the heading
  final bool isSubMenu;
  final IconData? leadingIcon;

  const SettingProperty({
    required this.title,
    this.subtitle,
    this.heading,
    required this.isSubMenu,
    this.leadingIcon,
  });
}

class SettingsScreen extends StatelessWidget {
  final List<SettingProperty> settingsList = [
    const SettingProperty(title: 'Enable notifications', heading: 'Notification Settings', isSubMenu: false),
    const SettingProperty(title: 'Notification frequency', subtitle: 'Daily at 8 PM', isSubMenu: true),
    const SettingProperty(title: 'Notification style', subtitle: 'Quotes', isSubMenu: true),
    const SettingProperty(title: 'Enable online features', heading: 'Online Features', isSubMenu: false),
    const SettingProperty(title: 'Regenerate your code', isSubMenu: true),
    const SettingProperty(title: 'Theme', subtitle: 'Light', heading: 'Display', isSubMenu: true),
    const SettingProperty(title: 'Enable animations', isSubMenu: false),
    const SettingProperty(title: 'App information', subtitle: 'version 0.0.1', heading: 'Miscellaneous', isSubMenu: true),
    const SettingProperty(title: 'Feedback', isSubMenu: true),
  ];

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: settingsList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10, 44, 10, 10),
            child: Text(
              'Settings',
              style: TextTheme.of(context).displaySmall,
            ),
          );
        }
        return SettingListItemBuilder(property: settingsList[index - 1]);
      }
    );
  }
}

class SettingListItemBuilder extends StatelessWidget {
  final SettingProperty property;

  const SettingListItemBuilder({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    if (property.heading != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              property.heading!,
              style: TextTheme.of(context).titleLarge
            ),
          ),
          ListTile(
            title: Text(property.title),
            subtitle: property.subtitle != null ? Text(property.subtitle!, style: TextTheme.of(context).labelSmall) : null,
            trailing: property.isSubMenu ? Icon(Icons.arrow_forward) : Switch(value: true, onChanged: (_) {})
          ),
        ],
      );
    }
    else {
      if (property.isSubMenu) {
        return ListTile(
            title: Text(property.title),
            subtitle: property.subtitle != null ? Text(property.subtitle!, style: TextTheme.of(context).labelSmall) : null,
            trailing: Icon(Icons.arrow_forward),
          );
      }
      return SwitchListTile(
        title: Text(property.title),
        subtitle: property.subtitle != null ? Text(property.subtitle!, style: TextTheme.of(context).labelSmall) : null,
        value: true,
        onChanged: (_) {}
      );
    }
  }
}