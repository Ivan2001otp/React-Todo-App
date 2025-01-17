import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/model/video.dart';
import 'package:tik_tok_clone/util/constants.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _videoList.bindStream(
      fireStore.collection("videos").snapshots().map((QuerySnapshot query) {
        List<Video> returnValue = [];
        for (var element in query.docs) {
          returnValue.add(Video.fromSnap(element));
        }
        return returnValue;
      }),
    );
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await fireStore.collection("videos").doc(id).get();

    var uid = authController.user.uid;

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await fireStore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await fireStore.collection("videos").doc(id).update({
        "likes": FieldValue.arrayUnion([uid]),
      });
    }
  }

  shareVideo(String id) async {
    DocumentSnapshot doc = await fireStore.collection("videos").doc(id).get();

    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['shareCount'].contains(uid)) {
      await fireStore.collection('videos').doc(id).update({
        'shareCount': FieldValue.arrayRemove([uid])
      });
    }else{
      await fireStore.collection('videos').doc(id).update({
        'shareCount': FieldValue.arrayUnion([uid])
      });
    }
  }
}
