import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentOrigin;
  final List<String> currentInterests;
  final String currentProfileImage;

  const EditProfileScreen({
    Key? key,
    required this.currentName,
    required this.currentOrigin,
    required this.currentInterests,
    required this.currentProfileImage,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _originController;
  late List<String> _interests;
  late String _profileImage;
  final TextEditingController _newInterestController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _originController = TextEditingController(text: widget.currentOrigin);
    _interests = List.from(widget.currentInterests);
    _profileImage = widget.currentProfileImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _originController.dispose();
    _newInterestController.dispose();
    super.dispose();
  }

  void _addInterest() {
    final interest = _newInterestController.text.trim();
    if (interest.isNotEmpty) {
      setState(() {
        _interests.add(interest);
        _newInterestController.clear();
      });
    }
  }

  // Función simulada para cambiar la foto de perfil (podrías integrar image_picker en el futuro)
  void _changeProfileImage() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _profileImage);
        return AlertDialog(
          title: const Text("Cambiar Foto de Perfil"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Nueva ruta de imagen (asset path)",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _profileImage = controller.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _saveProfile() {
    // Retornamos un mapa con los datos actualizados
    Navigator.pop(context, {
      'name': _nameController.text.trim(),
      'origin': _originController.text.trim(),
      'interests': _interests,
      'profileImage': _profileImage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // Usamos padding para que el modal ocupe la pantalla completa
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: GestureDetector(
                onTap: _changeProfileImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(_profileImage),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nombre de Usuario",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _originController,
              decoration: const InputDecoration(
                labelText: "Origen",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Intereses:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _interests.map((interest) {
                return Chip(
                  label: Text(interest),
                  onDeleted: () {
                    setState(() {
                      _interests.remove(interest);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newInterestController,
                    decoration: const InputDecoration(
                      labelText: "Nuevo Interés",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addInterest,
                )
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Guardar Cambios"),
            )
          ],
        ),
      ),
    );
  }
}
