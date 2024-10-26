# Heart Health Analysis App

The **Heart Health Analysis** app is a mobile application designed for real-time, continuous heart rate monitoring. It uses **remote photoplethysmography (rPPG)** for contactless heart rate detection. The app is built using **Flutter** for the frontend and **Firebase** for data storage.

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Signal Processing Overview](#signal-processing-overview)
- [Contributing](#contributing)


## Features
- **Contactless Heart Rate Detection:** Utilizes rPPG technology to measure heart rate using a mobile camera.
- **Real-Time Monitoring:** Continuous heart rate tracking and live feedback.
- **User-Friendly Interface:** Designed with simplicity in mind for ease of use.
- **Cloud Database Integration:** Stores data securely in Firebase for access across multiple devices.

## Technologies Used
- **Flutter:** Frontend framework for building the mobile interface.
- **Firebase:** Cloud database for real-time data storage and retrieval.
- **rPPG (Remote Photoplethysmography):** Signal processing method for detecting heart rate through a mobile camera without physical contact.

## Installation

### Prerequisites
- Flutter SDK (latest version) installed on your machine.
- A Firebase account set up and configured.

### Frontend Setup (Flutter)

1. Clone the repository:
    ```bash
    git clone https://github.com/muskan2911/heart-health-analysis.git
    cd heart-health-analysis/frontend
    ```

2. Get the Flutter dependencies:
    ```bash
    flutter pub get
    ```

3. Connect the app to Firebase:
   - Configure Firebase in your Flutter project using `google-services.json` for Android and `GoogleService-Info.plist` for iOS.

4. Run the Flutter app:
    ```bash
    flutter run
    ```

## Usage

1. Open the app and allow access to the camera.
2. Position the camera towards your face for the rPPG-based heart rate detection.
3. View your heart rate in real-time on the app's dashboard.
4. The data is saved to Firebase and can be accessed later.

## Signal Processing Overview

The heart rate detection algorithm uses **remote photoplethysmography (rPPG)**, which extracts the heart rate by analyzing subtle changes in skin color from the video feed captured by the phone’s camera. The app leverages signal processing techniques to filter noise and isolate the heart rate signal from the data.

### Key signal processing techniques used:
- **Bandpass filtering** to remove noise.
- **Peak detection** to determine the heart rate from periodic changes in the signal.

## Contributing

Contributions are welcome! If you want to contribute to the project, please fork the repository and submit a pull request. You can also raise issues or suggest features through GitHub issues.

1. Fork the project.
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a pull request.

