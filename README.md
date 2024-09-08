# Flutter Task: Phone Call Duration Capturer App


This part is the process I went through implementing this task.
1. **Adding dependencies:**
    First, I tried to make the app work in the background, so I went with [workmanager](https://pub.dev/packages/workmanager) package from pub.dev. Then, I wanted to prompt to ask for permissions so I went with [permission_handler](https://pub.dev/packages/permission_handler) package. Lastly, I wanted to be able to track the phone state so I used the [phone_state](https://pub.dev/packages/permission_handler) package.
2. **Implementaion:**
    My logical implementation is waiting for the phone state to be call started then set a variable with the start time then every second I update the state and calculate the difference between the current time and the start time and display it.
3. **Testing:**
I tested the application with android, but I don't have a macbook so I couldn't test with iOS. However I read about the Apple security policies, and my implementation doesn't depend on reading the call duration so I think my implementation won't have a problem with iOS.
---
This part is the instructions to run the app.

## Step 1: Clone the repository

```
git clone https://github.com/soubky0/flutter_task
cd flutter_task
```
## Step 2: Install dependencies
```
flutter pub get
```
## Step 3: Building and running the app
- ### For Android:
    1. Ensure an Android device or emulator is connected.
    2. Run the app with the following command:
            ```
            flutter run
            ```
- ### For iOS:
    1. Open the project in Xcode for iOS builds.
    2. Make sure your iOS device is connected or a simulator is running.
    3. Run the app with the following command:
            ```
            flutter run
            ```
