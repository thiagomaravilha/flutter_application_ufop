import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activities_provider.dart';
import '../../models/activity_model.dart';

class ActivityFormScreen extends StatefulWidget {
  final ActivityModel? activity;

  const ActivityFormScreen({super.key, this.activity});

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _speakerNameController = TextEditingController();
  final _speakerBioController = TextEditingController();
  final _locationController = TextEditingController();
  String _type = 'Palestra';
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      _titleController.text = widget.activity!.title;
      _descriptionController.text = widget.activity!.description;
      _speakerNameController.text = widget.activity!.speakerName;
      _speakerBioController.text = widget.activity!.speakerBio;
      _locationController.text = widget.activity!.location;
      _type = widget.activity!.type;
      _startTime = widget.activity!.startTime;
      _endTime = widget.activity!.endTime;
    }
  }

  Future<void> _selectDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startTime : _endTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStart ? _startTime : _endTime),
      );
      if (time != null && mounted) {
        setState(() {
          final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          if (isStart) {
            _startTime = newDateTime;
          } else {
            _endTime = newDateTime;
          }
        });
      }
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final activity = ActivityModel(
        id: widget.activity?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        speakerName: _speakerNameController.text,
        speakerBio: _speakerBioController.text,
        location: _locationController.text,
        startTime: _startTime,
        endTime: _endTime,
        type: _type,
      );
      final provider = context.read<ActivitiesProvider>();
      if (widget.activity == null) {
        provider.addActivity(activity);
      } else {
        provider.updateActivity(activity.id, activity);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity == null ? 'Nova Atividade' : 'Editar Atividade'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _speakerNameController,
              decoration: const InputDecoration(labelText: 'Nome do Palestrante'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _speakerBioController,
              decoration: const InputDecoration(labelText: 'Biografia do Palestrante'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Local'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            DropdownButtonFormField<String>(
              initialValue: _type,
              items: ['Palestra', 'Workshop'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _type = value!),
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            ListTile(
              title: Text('Início: ${_startTime.toString()}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDateTime(true),
            ),
            ListTile(
              title: Text('Fim: ${_endTime.toString()}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDateTime(false),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}