import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/show_toast.dart';
import 'package:volunteer_project/core/models/task.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/core/services/providers/event_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class CreateEventNavScr extends StatefulWidget {
  const CreateEventNavScr({Key? key}) : super(key: key);

  @override
  State<CreateEventNavScr> createState() => _CreateEventNavScrState();
}

class _CreateEventNavScrState extends State<CreateEventNavScr> {
  int _count = 0;
  final TextEditingController _eventDescriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberOfMemberController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  String? eventNameErrorText;
  String? addressErrorText;
  String? numberOfMemberErrorText;
  String? numberOfTaskErrorText;
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  List<Widget> taskList = [];
  List<TextEditingController> taskControllers = [];
  bool loading = false;

  void _customInit() {
    _count++;
    _addTask(0);
  }

  void _addTask(int index) {
    setState(() {
      taskControllers.add(TextEditingController());
      taskList.add(_taskField(
          index, TextInputType.multiline, null, null, numberOfTaskErrorText));
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    if (_count == 0) _customInit();
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade300, width: 2)),
                  child: Center(
                    child: imageFile != null? Image.file(imageFile!, fit: BoxFit.cover, height: 220, width: double.infinity,) : customText('No image selected', Colors.black,
                        FontSize.smallFont, FontWeight.w500),
                  ),
                ),
                Positioned(
                    bottom: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () async {
                        pickImageFromGallery();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade700),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          )),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            customText('Event Name', Colors.black, FontSize.mediumFont,
                FontWeight.w500),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(5),
              ),
              child: textFormFieldBuilder(TextInputType.multiline, null,
                  _eventNameController, eventNameErrorText),
            ),
            const SizedBox(
              height: 20,
            ),
            customText('Event Description', Colors.black, FontSize.mediumFont,
                FontWeight.w500),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(5),
              ),
              child: textFormFieldBuilder(TextInputType.multiline, null,
                  _eventDescriptionController, eventNameErrorText),
            ),
            const SizedBox(
              height: 20,
            ),
            customText(
                'Address', Colors.black, FontSize.mediumFont, FontWeight.w500),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(5),
              ),
              child: textFormFieldBuilder(TextInputType.multiline, null,
                  _addressController, addressErrorText),
            ),
            const SizedBox(
              height: 20,
            ),
            customText('Number of People Need', Colors.black,
                FontSize.mediumFont, FontWeight.w500),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(5),
              ),
              child: textFormFieldBuilder(TextInputType.number, null,
                  _numberOfMemberController, numberOfMemberErrorText),
            ),
            const SizedBox(
              height: 20,
            ),
            customText('Event Task', Colors.black, FontSize.mediumFont,
                FontWeight.w500),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return taskList[index];
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                  onPressed: () {
                    _addTask(taskList.length);
                  },
                  child: customText('+ Add More Task', darkGreen,
                      FontSize.mediumFont, FontWeight.bold),
                )),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: (){
                createEvent(authProvider, eventProvider);
              },
              child: loading? const Center(child: CircularProgressIndicator()) : Container(
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: darkGreen
                ),
                alignment: Alignment.center,
                child: const Text(
                  'CREATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontSize.mediumFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  ///text form field demo design
  Widget textFormFieldBuilder(TextInputType keyboardType, int? maxLine,
      TextEditingController? textEditingController, String? errorText) {
    return TextFormField(
        controller: textEditingController,
        style: const TextStyle(fontSize: FontSize.mediumFont),
        maxLength: null,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorText: errorText,
        ),
        keyboardType: keyboardType,
        cursorColor: Colors.black,
        maxLines: maxLine);
  }

  /// task field
  Widget _taskField(int index, TextInputType keyboardType, int? maxLine,
          TextEditingController? textEditingController, String? errorText) =>
      Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText('Task ${index + 1}', Colors.grey, FontSize.mediumFont,
                  FontWeight.normal),
              InkWell(
                onTap: (){
                  setState(() {
                   if(index != 0) {
                     taskControllers[index].clear();
                     taskControllers.removeAt(index);
                     taskList.removeAt(index);
                   }
                  });
                },
                child: Visibility(
                  visible: index == 0? false : true,
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextFormField(
              controller: taskControllers[index],
                style: const TextStyle(fontSize: FontSize.mediumFont),
                maxLength: null,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorText: errorText,
                ),
                keyboardType: keyboardType,
                cursorColor: Colors.black,
                maxLines: maxLine),
          ),
        ],
      );

  Future pickImageFromGallery() async {
    final XFile? originalImage =
    await _picker.pickImage(source: ImageSource.gallery);

    if (originalImage != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: originalImage.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      );
      if (croppedFile != null) {
        setState(() {
          imageFile = File(croppedFile.path);
        });
      }
    }
  }

  void createEvent(AuthProvider authProvider, EventProvider eventProvider) async{
    if(isEventNameEmpty() || isEventDescriptionEmpty() || isAddressEmpty() || isPeopleNumberEmpty() || isTaskEmpty()){
      return;
    }else{
      setState(() {
        loading = true;
      });
      List<Map<String, dynamic>> tasks = [];

      for(var controller in taskControllers){
        String taskId = const Uuid().v4();
        tasks.add({
          Strings.dbTaskId: taskId,
          Strings.dbTaskDescription: controller.text,
          Strings.dbTaskStatus: Strings.pending
        });
      }
      String eventId = const Uuid().v4();
      String? imageUrl = await eventProvider.uploadEventImage(imageFile, eventId);
      Map<String, dynamic> eventDetails = {
        Strings.dbEventId : eventId,
        Strings.dbEventDescription : _eventDescriptionController.text.trim(),
        Strings.dbEventImage : imageUrl ?? "",
        Strings.dbEventName: _eventNameController.text,
        Strings.dbEventAddress : _addressController.text.trim(),
        Strings.dbEventPeopleNeed : _numberOfMemberController.text,
        Strings.dbEventTasks : tasks,
        Strings.dbCreatedBy : authProvider.getCreatedBy(authProvider.currentUser),
        Strings.dbCreatedAt : DateTime.now().millisecondsSinceEpoch.toString(),
        Strings.dbMembers : [authProvider.getCreatedBy(authProvider.currentUser),],
        Strings.dbAppreciation : []
      };

      Map<String, dynamic> chatGroupData = {
        Strings.dbGroupId : eventId,
        Strings.dbEventId : eventId,
        Strings.dbGroupName : _eventNameController.text,
        Strings.dbGroupImage : imageUrl ?? "",
        Strings.dbMembers : [authProvider.getCreatedBy(authProvider.currentUser),],
      };
      bool isSuccessful = await eventProvider.createEvent(eventDetails, chatGroupData);
      if(isSuccessful){
        clearFields();
      }
      setState(() {
        loading = false;
      });
    }
  }

  bool isTaskEmpty() {
    bool isEmpty = false;
    print(taskControllers.length);
    for(var controller in taskControllers){
      print(controller.text);
      if(controller.text.isEmpty){
        toast(Strings.fillUpTasks);
        isEmpty = true;
        break;
      }
    }
    return isEmpty;
  }

  bool isAddressEmpty() {
    if(_addressController.text.isEmpty){
      toast(Strings.emptyAddressMsg);
      return true;
    }
    return false;
  }

  bool isEventNameEmpty() {
    if(_addressController.text.isEmpty){
      toast(Strings.emptyAddressMsg);
      return true;
    }
    return false;
  }

  bool isPeopleNumberEmpty(){
    if(_numberOfMemberController.text.isEmpty){
      toast(Strings.emptyNumberOfPeopleMsg);
      return true;
    }
    return false;
  }

  bool isEventDescriptionEmpty(){
    if(_eventDescriptionController.text.isEmpty){
      toast(Strings.emptyEventDescriptionMsg);
      return true;
    }
    return false;
  }

  clearFields(){
    setState(() {
      imageFile = null;
      _eventDescriptionController.clear();
      _addressController.clear();
      _numberOfMemberController.clear();
      clearTasksList();
    });
  }

  clearTasksList(){
    log(taskList.length.toString());
    for(int i=taskList.length-1; i>0; i--){
      setState(() {
        taskList.removeAt(i);
        log('${i.toString()} ${taskList.length}');
        taskControllers.removeLast();
      });
    }
    for(var controller in taskControllers){
      setState(() {
        controller.clear();
      });
    }
    log(taskList.length.toString());
  }

  @override
  void dispose() {
    _eventDescriptionController.dispose();
    _addressController.dispose();
    _numberOfMemberController.dispose();
    for(var controller in taskControllers){
      controller.dispose();
    }
    super.dispose();
  }
}
