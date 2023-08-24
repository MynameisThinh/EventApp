import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:event_createapp/constants/colors.dart';
import 'package:event_createapp/containers/custom_headtext.dart';
import 'package:event_createapp/containers/custom_input_form.dart';
import 'package:event_createapp/database.dart';
import 'package:event_createapp/savedata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  FilePickerResult? _filePickerResult;
  bool _isInPersonEvent = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _guestController = TextEditingController();
  final TextEditingController _sponsorController = TextEditingController();

  Storage storage = Storage(client);

  bool isUploading = false;

  String userId = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    userId = SavedData.getUserId();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //pickup date time

  Future<void> _selectDatetime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute);
        setState(() {
          _dateTimeController.text = selectedDateTime.toString();
        });
      }
    }
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      _filePickerResult = result;
    });
  }

  //upload image into storage appwrite

  Future uploadEventImage() async {
    setState(() {
      isUploading = true;
    });
    try {
      if (_filePickerResult != null) {
        PlatformFile file = _filePickerResult!.files.first;
        final fileByes = await File(file.path!).readAsBytes();
        final inputFile =
            InputFile.fromBytes(bytes: fileByes, filename: file.name);

        final response = await storage.createFile(
            bucketId: "64e21b7463990c6414ef",
            fileId: ID.unique(),
            file: inputFile);
        print(response.$id);
        return response.$id;
      } else {
        print("Xảy ra lỗi");
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                height: 5,
              ),
              CustomHeadText(
                text: "Tạo sự kiện",
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () => _openFilePicker(),
                child: _filePickerResult != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: FileImage(
                              File(_filePickerResult!.files.first.path!)),
                          fit: BoxFit.fill,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * .3,
                        decoration: BoxDecoration(
                            color: kLightGreen,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 42,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Thêm ảnh",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
              ),
              SizedBox(
                height: 8,
              ),
              CustomInputForm(
                  controller: _nameController,
                  icon: Icons.event_outlined,
                  label: "Tên sự kiện",
                  hint: "Thêm tên sự kiện"),
              SizedBox(
                height: 8,
              ),
              CustomInputForm(
                  controller: _descController,
                  maxLines: 4,
                  icon: Icons.description_outlined,
                  label: "Mô tả",
                  hint: "Thêm mô tả"),
              SizedBox(
                height: 8,
              ),
              CustomInputForm(
                  controller: _locationController,
                  icon: Icons.location_on_outlined,
                  label: "Địa điểm",
                  hint: "Nhập tên địa điểm của sự kiện"),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 8,
              ),
              CustomInputForm(
                  controller: _dateTimeController,
                  icon: Icons.date_range_outlined,
                  label: "Ngày bắt đầu",
                  hint: "Nhập ngày bắt đầu",
                  readOnly: true,
                  onTap: () => _selectDatetime(context)),
              SizedBox(
                height: 8,
              ),
              CustomInputForm(
                  controller: _guestController,
                  icon: Icons.people_outlined,
                  label: "Khách mời",
                  hint: "Nhập danh sách khách mời"),
              SizedBox(
                height: 8,
              ),
              CustomInputForm(
                  controller: _sponsorController,
                  icon: Icons.attach_money_outlined,
                  label: "Tài trợ",
                  hint: "Nhập nhà tài trợ"),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    "Lưu sự kiện",
                    style: TextStyle(color: kLightGreen, fontSize: 20),
                  ),
                  Spacer(),
                  Switch(
                      activeColor: kLightGreen,
                      value: _isInPersonEvent,
                      onChanged: (value) {
                        setState(() {
                          _isInPersonEvent = value;
                        });
                      }),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: MaterialButton(
                  color: kLightGreen,
                  onPressed: () {
                    if (_nameController.text == "" ||
                        _descController.text == "" ||
                        _locationController.text == "" ||
                        _dateTimeController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Tên sự kiện, mô tả, địa điểm, thời gian không được để trống")));
                    } else {
                      uploadEventImage()
                          .then((value) => createEvent(
                              _nameController.text,
                              _descController.text,
                              value,
                              _locationController.text,
                              _dateTimeController.text,
                              userId,
                              _isInPersonEvent,
                              _guestController.text,
                              _sponsorController.text))
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Sự kiện đã được tạo")));
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Text(
                    "Tạo sự kiện mới",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
