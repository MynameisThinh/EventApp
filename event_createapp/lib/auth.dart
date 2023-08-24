import 'package:appwrite/appwrite.dart';
import 'package:event_createapp/database.dart';
import 'package:event_createapp/savedata.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('64e06661b4df30f5ed19')
    .setSelfSigned(
        status: true); // For self signed certificates, only use for development

// Register User
Account account = Account(client);
Future<String> createUser(String name, String email, String password) async {
  try {
    final user = await account.create(
        userId: ID.unique(), email: email, password: password, name: name);
    saveUserData(name, email, user.$id);
    return 'success';
  } on AppwriteException catch (e) {
    return e.message.toString();
  }
}

//Login user
Future loginUser(String email, String password) async {
  try {
    final user =
        await account.createEmailSession(email: email, password: password);
    
    SavedData.saveUserId(user.userId);
    getUserData();
    return true;
  } on AppwriteException catch(e) {
    return false;
  }
}

//LogoutUser
Future logoutUser() async {
  await account.deleteSession(sessionId: 'current');
}
//check user have session

Future checkSessions() async {
  try {
    await account.getSession(sessionId: 'current');
    return true;
  } catch (e) {
    return false;
  }
}
