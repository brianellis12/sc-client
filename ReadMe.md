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

# Data Maps
## A user-friendly application that shows U.S. Census Bureau information for any location on the map.

This project aims to create an application that allows users to view Census Bureau information for any area they select. Many map applications exist that allow users to explore how the world looks or provide limited information on specific topics. For example, the U.S. Census Bureau has several maps that show demographic data from different decades. But these maps are often limited in scope, only showing one or two variables of the over 27,000 availible data points and having difficult to navigate interfaces that only work in web browsers.

This project aims to improve upon these existing applications by creating an application that is:

- Comprehensive in scope: It shows all the U.S. Census Bureau information for any location on the map.
- Modern in design: It has a fast and easy to navigate interface that works on any device.

The goal of this application is to be capable of both educational/research-based functions, as well as simply being an enjoyable way of viewing information about the world.

## Features
- A map to explore different areas and select locations
- A list of various groups of data to view, such as income, ancestry, and occupations.
- A list of dropdowns of the different sections within that group, for example income level based on education.
- A table of data specific to each section, ex. "Percentage of workers making $40,000-$60,000 with a high school degree.
- A window with descriptions of the different data groups
- The ability to save selected sets of data to one's device or email.
- Google sign in and authentication
- Cross platform with Windows, Linux, MacOS, Web, IOS, and Android

## Technologies
The project consists of a variaty of technologies chosen because of the development team's experience in them and goal to learn how to stand up a complete application with them. This goal included implementing features to industry best practices as researched by the team, including using [Alembic](https://alembic.sqlalchemy.org/en/latest/) for database migrations, securing REST API endpoints, adjusting the Google Sign in, UI Layout, and other features based on the users' platform, and implemeting a logging framework in addition to a Redis database to store the logs. 
![image](https://user-images.githubusercontent.com/97993107/234724435-c38f9e59-fe41-4522-8fbd-8d074db1e967.png)
- A Python/Fast API REST API using the [SQLAlchemy](https://www.sqlalchemy.org/) ORM for database connections and retreiving data from [Google Authentication](https://pypi.org/project/google-auth/) and the [U.S. Census Bureau API](https://www.census.gov/data/developers/data-sets.html). Run in using Docker.
- A PostgresDB database for storing Census Bureau sections and variables, as well as user information. Run in using Docker.
- A RedisDB database used for storing applications logs. Run in using Docker.
- A Flutter front end for multiplatorm functionality, employing [Google Sign In](https://pub.dev/packages/google_sign_in), [Flutter Map](https://pub.dev/packages/flutter_map), and the Flutter [Mailer](https://pub.dev/packages/mailer) package.

All of these technologies were chosen because the development team had brief previous experience working with them and wanted to not only learn how to use them more in depth, but also how to set them up in the first place. Examples of this is learning how to setup, configure, and troubleshoot Docker in applications as opposed to simply using `docker-compose up` and `docker-compose down`, how to generate and create responsive Flutter Widgets as opposed to just creating static ones, and learning how to push data to Redis databases.

## Cloud Deployment
The application is not currently deployed in the cloud but could be done so quite easily thanks to the use of Docker throughout the application. 

## Techincal Design
- As already mentioned in the Technologies section, the application consists of a Rest API that retrieves and sends data to a Postgres Database, a Redis Database for Logging and the U.S. Census Bureau API. The necessary information is then sent to the front end client via HTTP and is displayed to the User.
- The following diagram illustrates the high-level architecture of the application, including the generalized file structure and contents of the Front and Back Ends of the application. The design chosen for the Flutter client application was one that utilized components. Inside each component, is standardly a model, service, screen, and additional widgets that are called by the screen. The FastAPI backend is similarly broken into modules based on object-type. In this case, the standard is to have a model for database or outside data retrieval, a schema for database insertion, a router, and any necessary utility functions. 
![image](https://user-images.githubusercontent.com/97993107/234726953-cb2fe1f6-e318-46d3-9c42-ffaedc2899c5.png)
- The following UML diagram shows a more detailed look at the modules and services with the the user component and module in blue and the location data component and module in orange. The Rest Service’s data access layer is listed in red.
![image](https://user-images.githubusercontent.com/97993107/234726997-9698e033-b7ad-456f-b604-f436e73d2ed2.png)

## Risks
The major risks involved with the development of the project was the Development teams uncertainty in their capability to stand up the technologies listed in the technologies section and and uncertainty that several of the necessary packages would fit the project requirements. To resolve this, several proof of concepts were created which are displayed the the following table.

| Proof of Concepts | Description | Rationale | Results |
| --- | --- | --- | --- |
| 1 - Census Bureau API Data Retrieval Testing | Testing the API data retrieval from the U.S. Census Bureau | To ensure that the data could be obtained, what data was received, and what was needed to query the API | Data was successfully retrieved in the form of key-value pairs; querying required a GeoID and access token |
| 2 - Flutter Environment Testing | Testing the creation of a Flutter application | To ensure that the development team could successfully create a Flutter application | Creation was successful |
| 3 – FastAPI and PostgresDB Testing | Testing the creation and integration of a FastAPI REST service and a Postgres database | To ensure that the development team could successfully create and integrate a FastAPI REST service and a Postgres database | Creation and integration were successful |
| 4 – Google Maps/Flutter Map Package Testing | Testing the functionality and performance of the Google Maps and Flutter Map packages | To ensure that the plugins would work as expected and that location coordinates could be obtained from them | A prototype application using the Google Maps plugin showed performance issues and difficulties on several device platforms. A prototype using the Flutter Map package was successfully created and location coordinates were successfully obtained |
| 5 - Google Sign In and Firebase Authentication Integration Testing | Testing the integration of Google Sign In and Firebase Authentication services | To ensure that the two services would be sufficient for authentication | A prototype application using the Google Sign In and Firebase packages was created and worked as expected for authenticating users |
| 6 - Docker Setup and Integration Testing | Testing the setup and integration of Docker for the application | To ensure that the development team could effectively use Docker for the application | A prototype application was created and successfully run inside a Docker container |

## Known Issues
- **Styling** While very functional, the project design could be updated to improve the project.
- **Performance** Most latency is due to the API connection with the U.S. Census Bureau, but improvements could be made to Flutter Widgets and Rest API functions.
- **Login Optimization** While the login system works, it would be more efficient if it didn't require permission to the user's email account.

