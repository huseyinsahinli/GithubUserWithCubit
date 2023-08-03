# Github Stalker

This project is a Flutter application that retrieves information about Github users based on their username. 

## Overview

The application allows the user to enter a Github username and then retrieves and displays information about the corresponding Github profile. This is an excellent tool for developers who want to quickly find out more about other Github users.

## Technologies Used

- [Flutter](https://flutter.dev/)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) for state management
- [dio](https://pub.dev/packages/dio) for networking
- [equatable](https://pub.dev/packages/equatable) for value comparison
- [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) for icons
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) for environment variable handling
- [url_launcher](https://pub.dev/packages/url_launcher) for launching URLs


## How to Use

### This application requires a Github token to work. Please follow these steps:

1. Create a `.env` file in the root directory of the project.

2. Inside the `.env` file, add your Github token like this: 

   GITHUB_TOKEN=your_github_token

Replace `your_github_token` with your actual Github token.

### [Generate Github Token Steps](https://github.com/settings/tokens/new)
1. Sign in to your GitHub account.</br>
2. Click your profile picture on the top right.</br>
3. Click "Settings".</br>
4. Scroll down and click "Developer settings" on the left side.</br>
5. Click "Personal access tokens".</br>
6. Click "Tokens (classic)".</br>
7. Click "Generate new token".</br>
8. Enter a note to remind you what the token is for (Optinal).</br>
9. Set the expiration for your token.</br>
10. Under "Select scopes", check only the "repo" box.</br>
11. Click "Generate token" at the bottom.</br>
12. Copy new token and paste `.env` file.

<b>For example:</b>

  GITHUB_TOKEN=ghp_kExdQqlkPqdbES4YdTy6Ty654nSJev2a7fXK

Please make sure not to disclose your token publicly, as it may be used to perform actions on your behalf.

Once you have started the application:

1. Enter the Github username of the user you would like to "stalk"
2. Press the "Stalk" button.

The application will then retrieve and display information about the user.

## Contributions

Contributions are welcomed! If you see an issue that you'd like to see fixed, the best way to make it happen is to help out by submitting a pull request implementing it. I'll be happy to review your pull request!

