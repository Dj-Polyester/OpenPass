import 'package:sprintf/sprintf.dart';
import 'package:flutter/cupertino.dart';

class Lang {
  //TRANSLATIONS COME HERE//////////////////////////////
  static final Map<String, LangItem> _entries = {
    //VAULT
    "Your Vault is Empty. Please click the add button below to add keys.":
        LangItem(
      tr: "Hiç anahtarınız yok. Eklemek için aşağıdaki ekleme tuşuna basınız.",
    ),
    "Selected %s": LangItem(
      tr: "%s seçili",
    ),
    //
    "Search": LangItem(
      tr: "Ara",
    ),
    "Delete from vault": LangItem(
      tr: "Şifrelerimden sil",
    ),
    "Import": LangItem(
      tr: "İçe aktar",
    ),
    "Export": LangItem(
      tr: "Dışa aktar",
    ),
    "Add a key set": LangItem(
      tr: "Anahtar ekle",
    ),
    //
    "Copy to clipboard": LangItem(
      tr: "Kopyala",
    ),
    "Show": LangItem(
      tr: "Göster",
    ),
    "Hide": LangItem(
      tr: "Gizle",
    ),
    "Update": LangItem(
      tr: "Değiştir",
    ),
    //
    "Vault": LangItem(
      tr: "Şifrelerim",
    ),
    "Settings": LangItem(
      tr: "Ayarlar",
    ),
    "Options": LangItem(
      tr: "Seçenekler",
    ),
    //
    "File name": LangItem(
      tr: "Dosya ismi",
    ),
    "Enter a file name": LangItem(
      tr: "Bir dosya ismi giriniz",
    ),
    "Saved the file with the name %s to documents": LangItem(
      tr: "Dosya %s adıyla dokümanlarınıza eklendi",
    ),
    "Imported the file with the name %s": LangItem(
      tr: "%s isimli dosya içe aktarıldı",
    ),
    "Cannot save the file to documents because a file with the same name exists":
        LangItem(
      tr: "Dosya kaydedilemiyor, çünkü aynı isimli bir dosya mevcut",
    ),
    //
    "Name": LangItem(
      tr: "İsim",
    ),
    "Enter a name": LangItem(
      tr: "İsim giriniz",
    ),
    "Enter a key": LangItem(
      tr: "Şifre giriniz",
    ),
    "Is a secret key?": LangItem(
      tr: "Gizli mi?",
    ),
    //
    "Description": LangItem(
      tr: "Açıklama",
    ),
    "Enter a description": LangItem(
      tr: "Açıklama giriniz",
    ),
    "Username": LangItem(
      tr: "Kullanıcı adı",
    ),
    "Username (optional)": LangItem(
      tr: "Kullanıcı adı (opsiyonel)",
    ),
    "Enter a username": LangItem(
      tr: "Kullanıcı adı giriniz",
    ),
    "Email": LangItem(
      tr: "Eposta",
    ),
    "Email (optional)": LangItem(
      tr: "Eposta (opsiyonel)",
    ),
    "Enter an email": LangItem(
      tr: "Eposta giriniz",
    ),
    "Password": LangItem(
      tr: "Şifre",
    ),
    "Enter a password": LangItem(
      tr: "Şifre giriniz",
    ),
    //
    "Allow lowercase letters": LangItem(
      tr: "Küçük harfe izin ver",
    ),
    "Allow uppercase letters": LangItem(
      tr: "Büyük harfe izin ver",
    ),
    "Allow numeric characters": LangItem(
      tr: "Sayılara izin ver",
    ),
    "Allow special characters": LangItem(
      tr: "Özel karakterlere izin ver",
    ),
    "Allow ambiguous characters": LangItem(
      tr: "Belirsiz karakterlere izin ver",
    ),
    "Minimum": LangItem(
      tr: "Minimum",
    ),
    "Length": LangItem(
      tr: "Uzunluk",
    ),
    //
    "+ Add a custom key": LangItem(
      tr: "+ Özel şifre ekle",
    ),
    "Added the key with the name %s": LangItem(
      tr: "%s ismindeki şifreniz eklendi",
    ),
    "Updated the key with the name %s": LangItem(
      tr: "%s ismindeki şifreniz değiştirildi",
    ),
    "Added the key set with the description %s": LangItem(
      tr: "%s açıklamalı anahtarınız eklendi",
    ),
    "Updated the key set with the description %s": LangItem(
      tr: "%s açıklamalı anahtarınız değiştirildi",
    ),
    "Deleted the key sets from vault": LangItem(
      tr: "Anahtarlar silindi",
    ),
    "Deleted the key": LangItem(
      tr: "Şifre silindi",
    ),
    "Key is generated": LangItem(
      tr: "Şifre oluşturuldu",
    ),
    //
    "Submit": LangItem(
      tr: "Onayla",
    ),
    "Generate": LangItem(
      tr: "Oluştur",
    ),
    "Edit": LangItem(
      tr: "Değiştir",
    ),
    "Delete": LangItem(
      tr: "Sil",
    ),
    "Select all": LangItem(
      tr: "Tümünü seç",
    ),
    //
    "The password entered contains": LangItem(
      tr: "Girilen şifre",
    ),
    "* small letters": LangItem(
      tr: "* küçük harf",
    ),
    "* capitalized letters": LangItem(
      tr: "* büyük harf",
    ),
    "* numbers": LangItem(
      tr: "* sayı",
    ),
    "* special characters": LangItem(
      tr: "özel karakterler",
    ),
    "* the character %s": LangItem(
      tr: "%s karakteri",
    ),
    "Therefore is not a valid password": LangItem(
      tr: "içerdiği için kabul edilememektedir",
    ),
    "* An entry with the description already exists": LangItem(
      tr: "Bu açıklamada bir giriş mevcuttur",
    ),
    "* Please enter some text": LangItem(
      tr: "Bu alan zorunludur",
    ),
    "* The email entered is not valid": LangItem(
      tr: "Girilen eposta geçersizdir",
    ),
    "* Sum of minimum allowed characters exceeds the length": LangItem(
      tr: "Minimum izin verilen karakter sayısı uzunluğu aşmaktadır",
    ),
    "* The text entered contains non-ASCII characters": LangItem(
      tr: "Giriş yapılan değer sadece ascii olmayan karakter içermektedir",
    ),
    //SETTINGS
    "Set theme": LangItem(
      tr: "Tema ayarla",
    ),
  };
  //////////////////////////////////////////////////////

  static final String _countryCode =
      WidgetsBinding.instance!.window.locale.countryCode!.toLowerCase();

  static String tr(String text, [List args = const []]) {
    String translated =
        (_countryCode == "us") ? text : _entries[text]!.toMap()[_countryCode];
    return sprintf(translated, args);
  }
}

class LangItem {
  LangItem({
    this.tr,
    this.jp,
  });
  String? tr, jp;

  str(String? str) => str ?? "????";

  Map toMap() => {
        "tr": str(tr),
        "jp": str(jp),
      };
}
