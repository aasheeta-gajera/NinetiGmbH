# Flutter User Management App

## Project Overview

This Flutter app demonstrates a user management system with the following features:
- Display a paginated, searchable list of users.
- User detail screen showing user posts and todos.
- Add new posts functionality.
- Theme switching (light/dark) with Material 3 design.
- State management using BLoC pattern.
- Clean and modern UI design with custom theming.

---

## Setup Instructions

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>= 3.0.0 recommended)
- An editor like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- A device or emulator to run the app

### Steps

1. **Clone the repository**

git clone https://github.com/aasheeta-gajera/NinetiGmbH
cd NinetiGmbH

2  **Install dependencies**

flutter pub get

3  **Run the app**

flutter run

Architecture Explanation
State Management
BLoC Pattern with flutter_bloc:

UserBloc: Fetches and searches users with infinite scroll support.

PostBloc: Fetches and adds posts for selected users.

TodoBloc: Fetches todos and supports pull-to-refresh.

ThemeCubit: Controls light/dark theme toggling.

UI

UserListScreen: Displays users with search and infinite scroll. Theme toggle in AppBar.

UserDetailScreen: Shows user details, posts (with add button), and todos (pull-to-refresh).

Custom widgets for user, post, and todo list tiles.

Clean, professional design using Material 3 and up-to-date Flutter typography.

Folder Structure

lib/
├── models/         # Data models (User, Post, Todo)
├── theme/          # ThemeCubit and theme data
├── user/           # UserBloc, events, states, user screens
├── post/           # PostBloc, events, states, widgets
├── todo/           # TodoBloc, events, states, widgets
├── widgets/        # Reusable widgets (UserTile, PostTile, TodoTile)
├── main.dart       # App entry point with MultiBlocProvider


Additional Features

Pull-to-refresh on the todos list.

Load more button to paginate posts.

Light/dark theme switching with smooth toggle.

Responsive and clean UI.

```bash
