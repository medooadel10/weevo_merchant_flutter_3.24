import 'dart:developer';
import "dart:io";

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import "package:flutter_image_compress/flutter_image_compress.dart";
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../features/Screens/before_registration.dart';
import '../Models/account_type.dart';
import '../Models/cash_out.dart';
import '../Models/merchant_feedback_model.dart';
import '../Models/offer.dart';
import '../Models/pay_type.dart';
import '../Models/payment_method.dart';
import '../Models/shipment_tab_model.dart';
import '../Models/user_type.dart';
import '../Providers/auth_provider.dart';
import 'colors.dart';

String ast(String imageName) => 'assets/images/$imageName.png';

String lot(String name) => 'assets/images/$name.json';

const String addOneMore = "ADD_ONE_MORE";
const String from_warehouse = "FROM_WAREHOUSE";
const String add_shipment = "ADD_SHIPMENT";
const String from_item_details = "FROM_ITEM_DETAILS";
const String from_home_map = "Home_Map";
const String from_address_map = "Address_Map";
const String from_shipment_map = "Shipment_Map";
const String oneShipment = "one_shipment";
const String giftShipment = "gift_shipment";
const String moreThanOneShipment = "more_than_one";
const String priceForPay = 'ادخل المبلغ بطريقة صحيحة';
final List<String> genders = ["ذكر", "انثي"];
final List<UserTypeModel> userType = [
  UserTypeModel("تاجر", "عندي بيزنس وأوردرات بشكل متكرر", "merchant"),
  UserTypeModel("مستخدم عادي", "عندي طلب فردي وعاوز أوصله", "user"),
];
final List<String> userAccountType = ["حساب بنكي", "محفظة الكترونية"];
// const String courier = 'Courier-';
// const String merchant = 'Merchant-';
final paymentList = <Payment>[
  const Payment(
    paymentMethodTitle: "الطلب مدفوع مسبقا",
    paymentMethodIcon: "assets/images/payment_visa_icon.png",
  ),
  const Payment(
    paymentMethodTitle: "دفع مقدم",
    paymentMethodIcon: "assets/images/payment_cash_icon.png",
  ),
];
final offerList = [
  Offers(
      image: 'assets/images/plus_preview_1.png',
      subtitle: 'هتقدر تضيف عدد شحنات غير محدودة\nعلي تطبيق ويفو',
      title: "عدد اوردرات غير محدود",
      assetImage: ('assets/images/plus_preview_box_icon.png')),
  Offers(
      image: 'assets/images/plus_preview_2.png',
      subtitle: 'شحنتك هتوصل لعدد أكبر وبالتالي\nهيتم شحنها بطريقة أسرع',
      title: 'وصل شحنتك لعدد اكبر\nمن الكباتن',
      assetImage: ('assets/images/plus_preview_motor_bike_icon.png')),
  Offers(
      image: 'assets/images/plus_preview_3.png',
      subtitle: 'شحنتك هتبقي في اول الشحنات\nاللي موجودة عند المناديب',
      title: 'شحنتك هتبقا مميزة',
      assetImage: ('assets/images/plus_preview_star_icon.png')),
];

bool validateUserEmail(String email) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  return emailValid;
}

bool validateUserPhone(String phone) {
  bool phoneValid = RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)").hasMatch(phone);
  return phoneValid;
}

final tabs = <ShipmentTab>[
  ShipmentTab(name: 'جديدة', image: 'assets/images/new_icon.png'),
  ShipmentTab(
      name: 'شحنات غير مكتملة', image: 'assets/images/incompleted_icon.png'),
  ShipmentTab(
      name: 'في انتظار التوصيل', image: 'assets/images/wait_to_deliver.png'),
  ShipmentTab(name: 'في الطريق', image: 'assets/images/in_my_way_icon.png'),
  ShipmentTab(name: 'قيد التوصيل', image: 'assets/images/on_delivery.png'),
  ShipmentTab(name: 'مكتملة', image: 'assets/images/delivered_icon.png'),
  ShipmentTab(name: 'مرتجعة', image: 'assets/images/returned_icon.png'),
  ShipmentTab(name: 'ملغية', image: 'assets/images/cancelled_icon.png'),
];
List<PayType> payTypes = [
  PayType(title: 'بطاقة ميزة', icon: 'assets/images/miza_card.jpeg'),
  PayType(title: 'محفظة الكترونية', icon: 'assets/images/miza.png'),
  PayType(title: 'بطاقة أئتمان', icon: 'assets/images/visa_master_card.png'),
];

void check({
  required BuildContext ctx,
  required AuthProvider auth,
  required NetworkState state,
}) async {
  if (state == NetworkState.LOGOUT) {
    await auth.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
        ctx, BeforeRegistration.id, (route) => false);
  }
}

Future<File?> compressFile(String path) async {
  var splited = path.split("/");
  String original = path.split("/").last.split(".").first;
  String extension = path.split("/").last.split(".").last;
  String outputName =
      "${splited.sublist(0, splited.length - 1).join("/")}/${original}_out.$extension";
  XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
    path,
    outputName,
    quality: 50,
  );
  if (compressedFile == null) return null;
  return File(compressedFile.path);
}

Future<File?> convertAndCompressImage(File file) async {
  try {
    // Load the image file into memory
    final imageBytes = await file.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) return null;
    // Convert the image to a JPEG format if not already
    List<int> jpegBytes;
    if (file.path.endsWith('.jpg') || file.path.endsWith('.jpeg')) {
      jpegBytes = imageBytes; // Use original bytes if already a JPEG
    } else {
      jpegBytes = img.encodeJpg(originalImage, quality: 80); // Convert to JPEG
    }

    // Save the JPEG image to a temporary file
    Directory tempDir = await getTemporaryDirectory();
    String jpegPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_temp.jpg';
    File jpegFile = File(jpegPath)..writeAsBytesSync(jpegBytes);

    // Compress the JPEG image
    String compressedPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';
    XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      jpegFile.path,
      compressedPath,
      quality: 50, // Adjust the compression quality as needed
    );

    if (compressedFile == null) return null;
    // Clean up the temporary uncompressed file
    await jpegFile.delete();

    return File(compressedFile.path);
  } on Exception catch (e) {
    log("Error processing image: ${e.toString()}");
    rethrow;
  }
}

enum Type {
  TEXT,
  IMAGE,
}

Future<TaskSnapshot?> uploadImage(
    {required String path, required String uid}) async {
  String fileName = uid;
  File? image = await compressFile(path);
  if (image == null) return null;
  Reference reference = FirebaseStorage.instance.ref().child(fileName);
  UploadTask uploadTask = reference.putFile(image);
  return uploadTask;
}

const List<AccountType> accountTypes = [
  AccountType(name: "حساب بنكي", image: "assets/images/bank.png"),
  AccountType(name: "محفظة الكترونية", image: "assets/images/e_wallet.png"),
];

const List<CashOut> cashOutList = [
  CashOut(
    name: "حساب بنكي",
    color: weevoLightGreen,
  ),
  CashOut(
    name: "محفظة الكترونية",
    color: weevoRedColor,
  ),
  CashOut(
    name: "كارت ميزة",
    color: weevoDarkPurple,
  ),
];
List<MerchantFeedbackModel> merchantfeedback = [
  MerchantFeedbackModel(
      message: 'تاجر اكثر من رائع',
      hasMessage: true,
      imageUrl: 'assets/images/profile.png',
      username: 'Mostafa Saleh',
      rateNumber: 4.5),
  MerchantFeedbackModel(
    hasMessage: false,
    imageUrl: 'assets/images/profile_picture.png',
    username: 'Ahmed Shaker',
    rateNumber: 3.0,
  ),
  MerchantFeedbackModel(
    message: 'تاجر ملتزم بالمواعيد ويعمل بجد',
    hasMessage: true,
    imageUrl: 'assets/images/profile.png',
    username: 'Ali hossam',
    rateNumber: 5.0,
  ),
  MerchantFeedbackModel(
    hasMessage: false,
    imageUrl: 'assets/images/profile_picture.png',
    username: 'Omar Ahmed',
    rateNumber: 2.5,
  ),
  MerchantFeedbackModel(
    message: 'منجاته جيدة للغاية',
    hasMessage: true,
    imageUrl: 'assets/images/profile.png',
    username: 'Noha Khaled',
    rateNumber: 4.0,
  ),
  MerchantFeedbackModel(
    hasMessage: false,
    imageUrl: 'assets/images/profile_picture.png',
    username: 'Ahmed Ayman',
    rateNumber: 3.5,
  ),
];
const String passwordValidatorMessage = "من فضلك تأكد من كلمة السر الخاصة بك";
const String nameValidatorMessage = "من فضلك ادخل الاسم بطريقة صحيحة";
const String nationalIdNumberValidatorMessage =
    'من فضلك ادخل الرقم القومي بطريقة صحيحة';
const String emailValidatorMessage = "من فضلك ادخل بريد الكتروني بطريقة صحيحة";
const String emailCheckValidatorMessage =
    "من فضلك تأكد من البريد الكتروني الخاص بك";
const String phoneValidatorMessage = "من فضلك ادخل رقم الهاتف بطريقة صحيحة";
const String NameValidatorMessage = "الاسم الجديد";
const String newBirthDayMessage = "ادخل تاريخ الميلاد";
const String commercialActivity = "ادخل نشاطك التجاري";
const String YourWebsiteOrFacebook = "ادخل موقعك او الفيس بوك";

final List<String> images = [
  "assets/images/orange.png",
  "assets/images/voda.png",
  "assets/images/miza.png",
  "assets/images/bm.png",
  "assets/images/smart.png",
  "assets/images/etisalat.png",
];

enum NetworkState {
  SUCCESS,
  ERROR,
  LOGOUT,
  LIVEDATA,
  WAITING,
  PAGING,
}

Map<String, dynamic> banks = {
  "banks": [
    {"id": 1, "name": "البنك الأهلي المصري", "icon": "1.jpg"},
    {"id": 2, "name": "بنك مصر", "icon": "2.jpg"},
    {"id": 3, "name": "بنك القاهرة", "icon": "3.jpg"},
    {"id": 4, "name": "البنك التجاري الدولي", "icon": "4.jpg"},
    {"id": 5, "name": "بنك الاسكندرية", "icon": "5.jpg"},
    {"id": 6, "name": "بنك قطر الوطني", "icon": "6.jpg"},
    {"id": 7, "name": "بنك كريدي اجري كول", "icon": "7.jpg"},
    {"id": 8, "name": "البنك العربي الافريقي الدولي", "icon": "8.jpg"},
    {"id": 9, "name": "البنك المصري الخليجي", "icon": "9.jpg"},
    {"id": 10, "name": "بنك قناة السويس", "icon": "10.jpg"},
    {"id": 11, "name": "بنك عوده", "icon": "11.jpg"},
    {"id": 12, "name": "بنك اتش اس بي سي HSBC", "icon": "12.jpg"},
    {"id": 13, "name": "المؤسسة العربية المصرفية", "icon": "13.jpg"},
    {"id": 14, "name": "بنك الإسكان والتعمير", "icon": "14.jpg"},
    {"id": 15, "name": "البريد المصري", "icon": "15.jpg"},
    {"id": 16, "name": "بنك الكويت الوطني", "icon": "16.jpg"},
    {"id": 17, "name": "مصرف أبو ظبي الإسلامي", "icon": "17.jpg"},
    {"id": 18, "name": "البنك المركزي المصري", "icon": "18.jpg"},
    {"id": 19, "name": "بنك فيصل الإسلامي", "icon": "19.jpg"},
    {"id": 20, "name": "بنك الإمارات دبي الوطني", "icon": "20.jpg"},
    {"id": 21, "name": "البنك المصري لتنمية الصادرات", "icon": "21.jpg"},
    {"id": 22, "name": "بنك البركة", "icon": "22.jpg"},
    {"id": 23, "name": "البنك العربي", "icon": "23.jpg"},
    {"id": 24, "name": "بنك المشرق", "icon": "24.jpg"},
    {
      "id": 25,
      "name": "بنك الشركة المصرفية العربية الدولية saib",
      "icon": "25.jpg"
    },
    {"id": 26, "name": "بنك التجاري وفا", "icon": "26.jpg"},
    {"id": 27, "name": "بنك المصرف المتحد", "icon": "27.jpg"},
    {"id": 28, "name": "بنك بلوم مصر", "icon": "28.jpg"},
    {"id": 29, "name": "ميد بنك", "icon": "29.jpg"},
    {"id": 30, "name": "المصرف العربي الدولي", "icon": "30.jpg"},
    {
      "id": 31,
      "name": "البنك الرئيسي للتنمية والائتمان الزراعي",
      "icon": "31.jpg"
    },
    {"id": 32, "name": "بنك ناصر الاجتماعي", "icon": "32.jpg"},
    {"id": 33, "name": "بنك سيتي citi", "icon": "33.jpg"},
    {"id": 34, "name": "البنك الأهلي المتحد", "icon": "34.jpg"},
    {"id": 35, "name": "بنك أبو ظبي التجاري", "icon": "35.jpg"},
    {"id": 36, "name": "بنك الاستثمار العربي", "icon": "36.jpg"},
    {"id": 37, "name": "البنك العقاري المصري العربي", "icon": "41.jpg"},
    {"id": 38, "name": "البنك الأهلي اليوناني", "icon": "37.jpg"},
    {"id": 39, "name": "بنك التنمية الصناعية", "icon": "38.jpg"},
    {"id": 40, "name": "بنك أبو ظبي الأول", "icon": "39.jpg"},
    {"id": 41, "name": "سيتي بنك", "icon": "41.jpg"}
  ]
};

// Future<String> facebookAuth() async {
//   try {
//     final LoginResult result = await FacebookAuth.instance.login();
//     FacebookAuthCredential credential =
//     FacebookAuthProvider.credential(result.accessToken.token);
//     String res = await userCredential(credential);
//     return res;
//   } on FacebookAuthErrorCode catch (e) {
//     return e.toString();
//   }
// }
