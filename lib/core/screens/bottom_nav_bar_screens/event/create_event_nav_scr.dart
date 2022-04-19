import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/utils/theme.dart';

class CreateEventNavScr extends StatefulWidget {
  const CreateEventNavScr({Key? key}) : super(key: key);

  @override
  State<CreateEventNavScr> createState() => _CreateEventNavScrState();
}

class _CreateEventNavScrState extends State<CreateEventNavScr> {
  int _count = 0;
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberOfMemberController =
      TextEditingController();
  final TextEditingController _numberOfTaskController = TextEditingController();
  String? eventNameErrorText;
  String? addressErrorText;
  String? numberOfMemberErrorText;
  String? numberOfTaskErrorText;

  List<Widget> _taskList = [];

  void _customInit() {
    _count++;
    _addTask(0);
  }

  void _addTask(int index) {
    setState(() {
      _taskList.add(_taskField(
          index, TextInputType.number, null, null, numberOfTaskErrorText));
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    child: customText('No image selected', Colors.black,
                        FontSize.smallFont, FontWeight.w500),
                  ),
                ),
                Positioned(
                    bottom: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () async {},
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
              itemCount: _taskList.length,
              itemBuilder: (context, index) {
                return _taskList[index];
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                  onPressed: () {
                    _addTask(_taskList.length);
                  },
                  child: customText('+ Add More Task', darkGreen,
                      FontSize.mediumFont, FontWeight.bold),
                )),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: (){
              },
              child: Container(
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
                  print('tapped');
                  setState(() {
                   if(index != 0) _taskList.removeAt(index);
                  });
                },
                child: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
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
}
