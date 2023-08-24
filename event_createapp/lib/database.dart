import 'package:appwrite/appwrite.dart';
import 'package:event_createapp/auth.dart';
import 'package:event_createapp/savedata.dart';

String databaseId = "64e0feba3156b3284762";

final Databases databases = Databases(client);

//save user data

Future<void> saveUserData(String name, String email, String userId) async {
  return await databases
      .createDocument(
          databaseId: databaseId,
          collectionId: "64e0fec633a207581e7c",
          documentId: ID.unique(),
          data: {
            "name": name,
            "email": email,
            "userId": userId,
          })
      .then((value) => print("Document created"))
      .catchError((e) => print(e));
}

//get user data from the database

Future getUserData() async {
  final id = SavedData.getUserId();

  try {
    final data = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: "64e0fec633a207581e7c",
        queries: [Query.equal("userId", id)]);
    SavedData.saveUserName(data.documents[0].data['name']);
    SavedData.saveUserEmail(data.documents[1].data['email']);
    print(data);
  } catch (e) {
    print(e);
  }
}

//create new events

Future<void> createEvent(
    String name,
    String description,
    String image,
    String location,
    String datetime,
    String createdBy,
    bool isInPersonOrNot,
    String guest,
    String sponsers) async {
  return await databases
      .createDocument(
          databaseId: databaseId,
          collectionId: "64e2172d54d44a90047b",
          documentId: ID.unique(),
          data: {
            "name": name,
            "description": description,
            "image": image,
            "location": location,
            "datetime": datetime,
            "createdBy": createdBy,
            "isInPerson": isInPersonOrNot,
            "guests": guest,
            "sponsers": sponsers,
          })
      .then((value) => print("Event created"))
      .catchError((e) => print(e));
}

//read all events
Future getAllEvents() async {
  try {
    final data = await databases.listDocuments(
        databaseId: databaseId, collectionId: "64e2172d54d44a90047b");
    return data.documents;
  } catch (e) {
    print(e);
  }
}

Future rsvpEvent(List participants, String documentId) async {
  final userId = SavedData.getUserId();
  participants.add(userId);
  try {
    await databases.updateDocument(
        databaseId: databaseId,
        collectionId: "64e2172d54d44a90047b",
        documentId: documentId,
        data: {
          "participants": participants,
        });
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

//List all event created by user

Future manageEvents() async {
  final userId = SavedData.getUserId();
  try {
    final data = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: "64e2172d54d44a90047b",
        queries: [Query.equal("createdBy", userId)]);
    return data.documents;
  } catch (e) {
    print(e);
  }
}

//update created event

Future<void> updateEvent(
    String name,
    String description,
    String image,
    String location,
    String datetime,
    String createdBy,
    bool isInPersonOrNot,
    String guest,
    String sponsers,
    String docID) async {
  return await databases
      .updateDocument(
          databaseId: databaseId,
          collectionId: "64e2172d54d44a90047b",
          documentId: docID,
          data: {
            "name": name,
            "description": description,
            "image": image,
            "location": location,
            "datetime": datetime,
            "createdBy": createdBy,
            "isInPerson": isInPersonOrNot,
            "guests": guest,
            "sponsers": sponsers
          })
      .then((value) => print("Event Updated"))
      .catchError((e) => print(e));
}

//Delele Event

Future deleteEvent(String docId) async {
  try {
    final response = await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: "64e2172d54d44a90047b",
        documentId: docId);
    print(response);
  } catch (e) {
    print(e);
  }
}
