import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/db/database.dart';
import '../planetas/planetas.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _radioController = TextEditingController();
  final TextEditingController _distanciaSolController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Planetas> planetario = [];
  @override
  void initState() {
    super.initState();
    abrirDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                query();
                if (planetario.isEmpty) {
                  return const Center(
                    child: Text("La base de datos esta vacía"),
                  );
                } else {
                  return ListView.builder(
                      itemCount: planetario.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    leading:
                                    const Icon(Icons.blur_circular_rounded),
                                    title: Text(
                                      "Planeta: ${planetario[index].nombre}",
                                    ),
                                    subtitle: Text(
                                        "Radio: ${planetario[index].radio} - Distancia al sol: ${planetario[index].distanciaSol}"),
                                  ),
                                ),
                                CupertinoButton(
                                    onPressed: () {
                                      mostrarDialogoEdicion(context, planetario[index]);
                                    },
                                    child: const Icon(Icons.edit)),
                                CupertinoButton(
                                    onPressed: () {
                                      delete(planetario[index].id!);
                                    },
                                    child: const Icon(Icons.delete)),

                              ],
                            ));
                      });
                }
              },
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration:
                  const InputDecoration(hintText: "Nombre del Planeta"),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Escriba algo en el campo";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _radioController,
                  decoration: const InputDecoration(hintText: "Radio"),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Escriba algo en el campo";
                    }
                    if (double.tryParse(value) == null) {
                      return "Ingrese un número válido";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _distanciaSolController,
                  decoration:
                  const InputDecoration(hintText: "Distancia al Sol"),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Escriba algo en el campo";
                    }
                    if (double.tryParse(value) == null) {
                      return "Ingrese un número válido";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String nombre = _nombreController.text;
                        double radio = double.parse(_radioController.text);
                        double distanciaSol =
                        double.parse(_distanciaSolController.text);

                        Planetas nuevoPlaneta =
                        Planetas(null, nombre, distanciaSol, radio);
                        await DB.insertar([nuevoPlaneta]).then((_) {
                          query();
                        });
                      }
                    },
                    child: const Text('Agregar'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void abrirDB() {
    DB.db().whenComplete(
          () async {},
    );
  }

  Future<void> delete(int id) async {
    await DB.borrar(id);
    query();
  }

  Future<void> query() async {
    planetario = await DB.consulta().whenComplete(
          () {
        setState(() {});
      },
    );
  }

  void mostrarDialogoEdicion(BuildContext context, Planetas planeta) {
    final TextEditingController editNombreController = TextEditingController(text: planeta.nombre);
    final TextEditingController editRadioController = TextEditingController(text: planeta.radio.toString());
    final TextEditingController editDistanciaSolController = TextEditingController(text: planeta.distanciaSol.toString());
    final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Planeta"),
          content: Form(
            key: editFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: editNombreController,
                  decoration: const InputDecoration(hintText: "Nombre del Planeta"),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Escriba algo en el campo";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: editRadioController,
                  decoration: const InputDecoration(hintText: "Radio"),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Escriba algo en el campo";
                    }
                    if (double.tryParse(value) == null) {
                      return "Ingrese un número válido";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: editDistanciaSolController,
                  decoration: const InputDecoration(hintText: "Distancia al Sol"),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Escriba algo en el campo";
                    }
                    if (double.tryParse(value) == null) {
                      return "Ingrese un número válido";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                if (editFormKey.currentState!.validate()) {
                  planeta.nombre = editNombreController.text;
                  planeta.radio = double.parse(editRadioController.text);
                  planeta.distanciaSol = double.parse(editDistanciaSolController.text);

                  await DB.insertar([planeta]).then((_) {
                    query();
                  });

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}