import 'package:flutter/material.dart';

class PersonaSelector extends StatelessWidget {
  final String selectedPersonaId;
  final VoidCallback onChangePersona;

  const PersonaSelector({
    Key? key,
    required this.selectedPersonaId,
    required this.onChangePersona,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch actual persona data
    final personaName = _getPersonaName(selectedPersonaId);
    final personaDescription = _getPersonaDescription(selectedPersonaId);
    final personaAvatar = _getPersonaAvatar(selectedPersonaId);

    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(personaAvatar)),
        title: Text(personaName),
        subtitle: Text(personaDescription),
        trailing: TextButton(
          onPressed: onChangePersona,
          child: const Text('Change Partner'),
        ),
      ),
    );
  }

  String _getPersonaName(String id) {
    // TODO: Replace with actual data
    return 'Sarah';
  }

  String _getPersonaDescription(String id) {
    // TODO: Replace with actual data
    return 'Friendly, Patient';
  }

  String _getPersonaAvatar(String id) {
    // TODO: Replace with actual data
    return 'S';
  }
}
