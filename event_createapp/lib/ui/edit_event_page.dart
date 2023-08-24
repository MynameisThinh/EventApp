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

class EditEventPage extends StatefulWidget {
  final String image, name, desc, loc, datetime, guests, sponsers, docId;
  final bool isInPerson;
  const EditEventPage(
      {super.key,
      required this.image,
      required this.name,
      required this.desc,
      required this.loc,
      required this.datetime,
      required this.guests,
      required this.sponsers,
      required this.docId,
      required this.isInPerson});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage>
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
    _nameController.text = widget.name;
    _descController.text = widget.desc;
    _locationController.text = widget.loc;
    _dateTimeController.text = widget.datetime;
    _guestController.text = widget.guests;
    _sponsorController.text = widget.sponsers;
    _isInPersonEvent = widget.isInPerson;
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
              SizedBox(
                height: 40,
              ),
              CustomHeadText(
                text: "Chỉnh sửa sự kiện",
              ),
              SizedBox(
                height: 20,
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
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://cloud.appwrite.io/v1/storage/buckets/64e21b7463990c6414ef/files/${widget.image}/view?project=64e06661b4df30f5ed19",
                            fit: BoxFit.fill,
                          ),
                        )),
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
                    "Lưu lại sự kiện",
                    style: TextStyle(
                        color: kLightGreen,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Tên sự kiện, mô tả, địa điểm, thời gian không được để trống")));
                    } else {
                      if (_filePickerResult == null) {
                        updateEvent(
                                _nameController.text,
                                _descController.text,
                                widget.image,
                                _locationController.text,
                                _dateTimeController.text,
                                userId,
                                _isInPersonEvent,
                                _guestController.text,
                                _sponsorController.text,
                                widget.docId)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Sự kiện đã được cập nhật!!")));
                          Navigator.pop(context);
                        });
                      } else {
                        uploadEventImage()
                            .then((value) => updateEvent(
                                _nameController.text,
                                _descController.text,
                                value,
                                _locationController.text,
                                _dateTimeController.text,
                                userId,
                                _isInPersonEvent,
                                _guestController.text,
                                _sponsorController.text,
                                widget.docId))
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Sự kiện đã được cập nhật !!")));
                          Navigator.pop(context);
                        });
                      }
                    }
                  },
                  child: Text(
                    "Cập nhật sự kiện",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Lưu ý",
                style: TextStyle(
                    color: Color.fromARGB(255, 249, 122, 120),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: MaterialButton(
                  color: Color.fromARGB(255, 249, 122, 120),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                "Bạn có chắc là sẽ xóa sự kiện này không ?",
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Text("Sự kiện này sẽ bị xóa "),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      deleteEvent(widget.docId)
                                          .then((value) async {
                                        await storage.deleteFile(
                                            bucketId: "64e21b7463990c6414ef",
                                            fileId: widget.image);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Xóa sự kiện thành công.")));
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text("Đồng ý")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Hủy"))
                              ],
                            ));
                  },
                  child: Text(
                    "Xóa sự kiện",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
