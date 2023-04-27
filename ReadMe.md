# Data Maps Client
- A Flutter application paired with the Data Maps [REST API](https://github.com/brianellis12/sc-api) to build a map and display U.S. Census Bureau Data for a selected location.
- Utilizes Google Auth, Flutter Maps, Firebase Authentication, Flutter Mailer, and other packages

## Local Setup
- Clone the Repository and run `flutter pub get .` to install all dependencies
- Install the REST API
- Create a deployment.yml file with your Google auth credentials and api_endpoint in assets/config
```
api_endpoint: http://localhost:8000
environment: "Local"
oauth:
  client_id:
    desktop:
    web: 
```

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
