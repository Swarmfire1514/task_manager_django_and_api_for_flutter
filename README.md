# Django Task Manager + Flutter App

A full-stack task management system built with Django (backend + web) and Flutter (mobile app).
This project allows users to manage categories and tasks, track status and priority, and maintain an activity log of actions. It supports role-based access with user and admin roles.

Live Website: [https://task-manager-with-django.onrender.com](https://task-manager-with-django.onrender.com)

API Documentation: [https://documenter.getpostman.com/view/44780520/2sBXVhDqmY](https://documenter.getpostman.com/view/44780520/2sBXVhDqmY)

# Features
**🌐 Web App (Django + Bootstrap)**
- Responsive UI with Bootstrap
- User Authentication (Login/Register/Logout)
- Task & Category CRUD
- Activity Logs using Django signals
- Ownership-based access control

**🔹 Backend API (Django REST Framework)**
- JWT Authentication (Access/Refresh + Blacklisting)
- Paginated APIs with PATCH support
- SQLite → PostgreSQL migration
- Deployed on Render

**📱 Flutter Mobile App (pre-release, tested on real devices)**
- Connected to live production API
- Persistent login (SharedPreferences)
- Bottom navigation: Home, Tasks, Categories, Activity Log, Profile
- Full Task CRUD + category linking
- Pagination & async state management

**✅ Other Features**
- Automatic timestamps (created_at, updated_at)
- Role-based access (user/admin)
- ActivityLog tracks all user actions
- Tasks filterable by status or priority

# Models Overview

**Profile**
- One-to-one with Django User
- Fields: role, created_at, updated_at

**Category**
- Multiple categories per user
- Fields: name, created_at, updated_at

**Task**
- Multiple tasks per category
- Fields: title, description, status, priority, due_date, created_at, updated_at

**ActivityLog**
- Tracks actions by users on tasks
- Fields: user, task, action, timestamp

# Installation (Django Backend)
- `git clone https://github.com/Swarmfire1514/task_manager_django_and_api_for_flutter`
- `cd task_manager_django_and_api_for_flutter`

**Create and activate a virtual environment:**
-  Windows: `venv\Scripts\activate`
-  macOS/Linux : `source venv/bin/activate`

**Install dependencies:**
- `pip install -r requirements.txt`

**Apply migrations:**
- `python manage.py makemigrations`
- `python manage.py migrate`

**Create a superuser (admin access):**
- `python manage.py createsuperuser`

**Run the development server:**
- `python manage.py runserver`
-Web app: `http://127.0.0.1:8000/`

-Admin panel: `http://127.0.0.1:8000/admin`

# Flutter Mobile App Setup

**Navigate to the Flutter project folder:**
- `cd taskmanager_app`

**Install Flutter dependencies:**
- `flutter pub get`

**Update API base URL (if running backend locally or production):**
- Create an env file and set up the API_BASE_URL
set:
`API_BASE_URL = 'http://127.0.0.1:8000/api/'; //local`
`API_BASE_URL = 'https://task-manager-with-django.onrender.com' //production`

**Run the Flutter app:**
- `flutter run`
Make sure your device/emulator is connected.
If testing on a real device with local backend, enable android:usesCleartextTraffic="true" in AndroidManifest.xml.

# Usage
- Register and log in as a user
- Admins can manage all categories and tasks
- Users can create categories and assign tasks
- ActivityLog tracks all actions
- Flutter app consumes the same API for mobile access

# Future Updates
- Play Store / App Store deployment for Flutter app
- Enhanced notifications and reminders
- Advanced search and filtering in tasks
- Multi-role enterprise-level permissions

# Live Links
Live Website: [https://task-manager-with-django.onrender.com](https://task-manager-with-django.onrender.com)

API Documentation: [https://documenter.getpostman.com/view/44780520/2sBXVhDqmY](https://documenter.getpostman.com/view/44780520/2sBXVhDqmY)

# License
This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.