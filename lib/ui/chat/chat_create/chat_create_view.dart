import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/chat/chat_create/chat_create_view_model.dart';
import 'package:stacked/stacked.dart';

class ChatCreateView extends StatelessWidget {
  const ChatCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatCreateViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => ChatCreateViewModel(),
    );
  }
}
