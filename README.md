This is a flutter project with a firebase backend. 

Replace these variables by doing find replace:

- ##REPLACEME_WITH_GEMINI_API_KEY##


1. npm install -g firebase-tools
2. firebase login
3. 
Enable Authentication:

Go to the Firebase Console: https://console.firebase.google.com/project/YOUR_PROJECT/overview
In the left sidebar, click on "Authentication"
Click on "Get Started" or "Set up sign-in method"
Enable Email/Password authentication (and any other methods you want to use)


Enable Firestore (if not already done):

In the left sidebar, click on "Firestore Database"
Click on "Create database" if not already created
Choose "Start in test mode" for now (we'll update security rules later)


Enable Storage (if not already done):

In the left sidebar, click on "Storage"
Click on "Get Started" if not already set up
Choose a location for your storage bucket


Reconfigure Firebase in your Flutter project:
Run the following command in your project directory:
4. firebase init
- select storage and firebase

5. flutterfire configure

6. flutter pub get

7. flutter run
- select web