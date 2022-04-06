# Mapobox in Flutter

This is a simple app to show a Mapbox map and be able to do *"zoom in"*, *"zoom-out"*, *"move when clicking"*, and create custom maps thanks to Mapbox Studio.

In this example, we are going to use:
- [Mapbox](https://www.mapbox.com/)
- [Location package](https://pub.dev/packages/location)
- [Flutter dot env package](https://pub.dev/packages/flutter_dotenv)
- [Flutter bloc](https://pub.dev/packages/flutter_bloc)
- [Very Good CLI](https://github.com/VeryGoodOpenSource/very_good_cli) to create a new package called location_repository.

## Getting Started

### Native configurations

I created an article on Medium to teach you how to implement Mapbox.
There are a few important native configurations that you are going to need to use Mapbox.

- [Article on Medium]()

Please, after you clone this project, go to the article and configure the native part.

### .env file

For this project I used .env directory to store my **PUBLIC ACCESS TOKEN**, if you want to use it, you need to create this structure on the root of your app:

````
assets:
  - .env
````

Inside this file you need to put your **PUBLIC ACCESS TOKEN** like that:

````
MAPBOX_ACCESS_TOKEN = 'your public access token here';
````

For more info, you can check the official documentation of [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) library.

## Test

Install ```lcov``` to visualize the test:

```brew install lcov```

Then you can run test on:

- Test folder on your root project:
    ```
       flutter test —coverage
       genhtml -o coverage coverage/lcov.info
       open coverage/index.html```
  
- Test folder on your **location_repository package** (use commands from Very Good CLI):

   ```
   very_good test --coverage --min-coverage 100
   genhtml -o coverage coverage/lcov.info
   open coverage/index.html```
  

## Future features

Things that I would like to add:
- Custom markers.
- Update the current location.
- Search by city or country.
- Animations.
--------
If you want to contribute to this code open a **PR** or an **Issue**.

Hope you enjoy it 😊
