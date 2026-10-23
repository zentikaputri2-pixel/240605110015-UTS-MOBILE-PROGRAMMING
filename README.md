# 📖 Al-Qur'an Digital

### Hi, I'm Zentica! 👋

Welcome to my GitHub repository!

I'm a fifth-semester Informatics Engineering student at UIN Maulana Malik Ibrahim Malang. This repository contains my **Al-Qur'an Digital app**, developed as part of the **Mobile Programming (Pemrograman Mobile A) midterm examination (UTS)**.

---

## 📱 About This Project

Al-Qur'an Digital is a simple mobile application built with **Flutter and Dart** to read the Holy Qur'an on Android. It shows all 114 surahs, and for each surah it displays the Arabic text, Latin transliteration, and Indonesian translation.

This project demonstrates how to fetch data from a REST API, convert JSON responses into Dart objects, process the data (search, filter, summary), and display dynamic information in a mobile application.

---

## ✨ Features

- 📚 Display the list of 114 surahs (number, Latin name, Arabic name, meaning, number of verses, and place of revelation)
- 🔍 Search surahs by Latin name, meaning, or surah number
- 🕌 Filter surahs by place of revelation (Mecca or Medina) using `ChoiceChip`
- 📊 Summary of the number of surahs and total verses based on the search and filter results
- 📖 Surah detail page with Arabic text, Latin transliteration, and Indonesian translation
- ℹ️ Surah description in an expandable panel
- 👁️ Show or hide the Latin text with a button in the AppBar
- ⏳ Loading indicator, error message, and a **Try again** button when the connection fails
- 🔄 Pull-to-refresh on the surah list

---

## 🛠️ Technologies Used

- **Flutter** – UI framework (Material Design 3, `colorSchemeSeed: Colors.teal`)
- **Dart** – programming language
- **[`http`](https://pub.dev/packages/http)** – package for HTTP requests to the API
- **[eQuran.id API v2](https://equran.id/api/v2)** – source of Qur'an data
- **Android Studio** – IDE
- **Git & GitHub** – version control

### 🌐 API Endpoints

| Endpoint | Method | Purpose |
|---|---|---|
| `https://equran.id/api/v2/surat` | GET | Get the list of 114 surahs |
| `https://equran.id/api/v2/surat/{nomor}` | GET | Get the detail of one surah along with all its verses |

---

## 🚀 How to Run

1. Clone this repository
   ```bash
   git clone https://github.com/zentikaputri2-pixel/UTS_Mobile.git
   ```

2. Go to the project folder
   ```bash
   cd UTS_Mobile
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Run the app (make sure an emulator or Android device is connected, and you have an internet connection)
   ```bash
   flutter run
   ```

> The app needs the `INTERNET` permission, which is already added in `android/app/src/main/AndroidManifest.xml`.

---

## 📁 Project Structure

```
lib/
├── main.dart                   # App entry point, theme, and initial page
├── models/
│   └── surat.dart              # Surat and Ayat models + JSON conversion
├── services/
│   └── quran_service.dart      # Fetching data from the API
└── pages/
    ├── home_page.dart          # Surah list, search, and filter
    └── detail_page.dart        # Surah detail and verses
```

---

## 🔮 Future Improvements

- Bookmark and last-read history
- Audio recitation (murottal) for each verse or surah
- Local cache so the app can be read offline
- Dark mode and Arabic font size settings
- Search by verse translation
- More structured state management (Provider / Riverpod)

---

## 👤 Author

**Zentica Putri Destani**

Informatics Engineering, Faculty of Science and Technology
UIN Maulana Malik Ibrahim Malang, 2026

- GitHub: [@zentikaputri2-pixel](https://github.com/zentikaputri2-pixel)

---

## 🙏 Acknowledgements

- Lecturer: A'la Syauqi, M.Kom
- Data provided by [eQuran.id](https://equran.id)

---

⭐ If you find this project useful, feel free to give it a star!
