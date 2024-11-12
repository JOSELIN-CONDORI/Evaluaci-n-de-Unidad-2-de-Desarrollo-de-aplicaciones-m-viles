import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final int id;
  final String fotoURL;
  final Future<void> Function(int id, String fotoURL) onConfirmDelete;

  ConfirmDeleteDialog({
    required this.id,
    required this.fotoURL,
    required this.onConfirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmar Eliminación'),
      content: Text('¿Estás seguro de que deseas eliminar este ítem?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo sin hacer nada
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(); // Cierra el diálogo

            // Llama al callback para eliminar el ítem
            await onConfirmDelete(id,fotoURL);
          },
          child: Text('Eliminar'),
        ),
      ],
    );
  }
}
