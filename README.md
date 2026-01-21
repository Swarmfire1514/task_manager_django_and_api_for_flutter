# Django Task Manager

Description:
A Django-based task manager app that allows users to manage categories and tasks, track task status and priority, and maintain an activity log of actions. It supports role-based access with 'user' and 'admin' roles.

Features:

* User registration and profile management
* Role-based access: user or admin
* Category management per user
* Task management with:

  * Title and description
  * Status (pending / completed)
  * Priority (low, medium, high)
  * Due date
* Activity log tracking user actions on tasks
* Automatic timestamping (created_at, updated_at) for models

Models Overview:
Profile:

* One-to-one with Django User
* Fields: role, created_at, updated_at

Category:

* Many categories per user
* Fields: name, created_at, updated_at

Task:

* Many tasks per category
* Fields: title, description, status, priority, due_date, created_at, updated_at

ActivityLog:

* Tracks actions (created, updated, completed) by user on a task
* Fields: user, task, action, timestamp

Linked below is the Posrman API documentation for this project.
API Documentation Link:
[https://documenter.getpostman.com/view/44780520/2sBXVhDqmY](https://documenter.getpostman.com/view/44780520/2sBXVhDqmY)

Installation:

1. Clone the repository:
   git clone [https://github.com/Swarmfire1514/task_manager_django_and_api_for_flutter](https://github.com/Swarmfire1514/task_manager_django_and_api_for_flutter)
   cd task_manager_django_and_api_for_flutter 
   or name it whatever you like.

2. Create and activate a virtual environment:
   python -m venv venv

* Windows

venv\Scripts\activate

* macOS/Linux

source venv/bin/activate

3. Install dependencies:
   pip install -r requirements.txt

4. Apply migrations:
   python manage.py makemigrations
   python manage.py migrate

5. Create a superuser (for admin access):
   python manage.py createsuperuser

6. Run the development server:
   python manage.py runserver

* Access the app at [http://127.0.0.1:8000/](http://127.0.0.1:8000/)
* Admin panel: [http://127.0.0.1:8000/admin/](http://127.0.0.1:8000/admin/) while running locally

Usage:

* Users can register and log in
* Admins can manage all categories and tasks
* Users can create categories and tasks assigned to them
* All actions are logged in the ActivityLog
* Tasks can be filtered by status or priority

This is a work in progress project which in this will be added as updated in the future edits of this file.

Screenshots:
It will appear here once the app is made.

Future Improvements:

* Add a Django REST API for mobile or frontend integration
* Add email notifications for upcoming tasks
* Implement search and filtering for tasks
* Add a dashboard showing task statistics


# Development Logs #

Jan 10, 2026
# Progess
- Setup Django backend and models (User, Category, Task, ActivityLog)
- Implemented Activity log signals through tasks app
- Created UI (containing pages: login, register, base template, home, task, categories, profile, Activity Logs)
- Improved UI for the website
- Implemented login, logout and register features
- Connection of the django backend and the website UI

# Features
- User Authentication
- Crud Operations for Categories and tasks with use of forms
- Activity log for tasks using post_save and post_delete

Jan 11,2025
# Progress
- Improved views related to signals
- Added signals for category too so that its updates are also shown in activity log
- Improved codes for UI data rendering

# Features
- Added activity log according showing whether task or category is worked on using if else, which uses the same view and model.
- Used Django signals pre_save in the task signals with instance._old_status variable to detect completed tasks.
- Task completion toggles added between pending and completed which is also logged.
- Added the admin panel acess for new super user
- When logging in also now the profile is created if not created.
- added logout button in the navbar for easy access.

Jan 12,2026
# Progress
- Added role based access to tasks and categories

During this I found out abouta new concept for me, Permissions
- Permissions are cleaner, safer and more scalable than roles.
- These doesn't depend on the developer create roles attribute in the profile, rather it works with djando admin and is also an industry standard.

* Will be continuing it tomorrow.

Jan 13,2026
# Progess
- Implemented role-based access logic for tasks and categories.

During this, I explored a new concept: Django Permissions.

* What I learned:
- Every Django model automatically gets:

add_model
change_model
delete_model
view_model

So the Task model, It automatically creates:
- tasks.add_task
- tasks.change_task
- tasks.delete_task
- tasks.view_task
so you will assign these permissions to users or groups, rather than via custom role strings.

* How permission works:
- Permissions are assigned to users or groups, not via custom role strings.
- Setup is usually done through the Django shell:
   Create groups (Admin, User)
   Use ContentType to link permissions to models
   Assign full permissions to Admin
   Assign limited permissions to User

* Key Realization:
- Permissions only matter if they are enforced in views.
- Using @permission_required would prevent users from editing/deleting their own tasks.
- Since my current logic already correctly restricts users to their own data, adding permissions now would add complexity without functional benefit.

* Decision:
-  For now, I am keeping my current ownership-based access control.
- I will revisit permissions when multi-role or enterprise-level access is required.

* Next Steps:
- Create API
- Create flutter app integrating the APIS.

Jan 14, 2026
# Progress
- Implemented serializers for user management, including ProfileSerializer and RegisterSerializer.
- Created REST API endpoints for authentication and user profile handling.
- Gained a deeper understanding of JWT authentication, including access and refresh tokens.
- Tested all API endpoints using Postman and confirmed they are functioning correctly.

# Process
- Configured serializers for user registration and profile data.
- Developed API views for Register, Profile, and Logout functionalities.
- Set up URL endpoints for all views, including authentication routes for:
   * User login (TokenObtainPairView)
   * Access token refresh (TokenRefreshView)
- Implemented secure logout by blacklisting refresh tokens using SimpleJWT’s token blacklist mechanism.
- Verified that all endpoints respond as intended.

Jan 15, 2026
# Progress
- Created REST API endpoints for Tasks, Categories CRUD operations and Activity logs.
- Created documentation of the Postman API Collection after testing.

# Process
- Implementation followed a pattern similar to existing user APIs.
- Created serializers for Tasks, Categories, and Activity Logs.
- For task updates, used PATCH instead of PUT, allowing partial updates (e.g., status changes) without requiring a separate endpoint, leveraging the existing TaskDetail API.
- Verified all endpoints responded correctly and consistently.
- Ensured that only authenticated users can access their data, with role-based access control implemented for admins and regular users.

# Key learrnings
- Django REST Framework (DRF) operates differently from standard Django views; for example, PATCH requests do not have a direct equivalent in typical Django views, requiring workarounds for partial updates.
- Most issues encountered were due to syntax errors (e.g., missing commas), missing trailing slashes in URLs, or incorrect imports.

API Documentation Link:
[https://documenter.getpostman.com/view/44780520/2sBXVhDqmY](https://documenter.getpostman.com/view/44780520/2sBXVhDqmY)

ONTO Flutter......

Jan 16, 2026
# Progress
- Explored more about template rendering and Django REST Framework(DRF).

** Django Templates: **
- Server renders HTML
- Backend + Frontend works tightly
- cookies + sessions and CSRF protection needed
- Good for:
   - simple websites
   - admin panels
   - comtent pages

* Request Workflow:
      request -> Django -> HTML -> Browser

Drawback:
- Not reusable for mobile apps
- Hard to scale for apps

** Django API(DRF) **
- Backend returns JSON
- Frontend is seperate
- JWT tokens for authentication
- Good for:
   - web apps
   - mobile apps
   - multiple clients

* Request Workflow:
      request -> Django(DRF) -> JSON -> web/mobile
   
   Positive Points:
   - Reusable
   - Scalable
   - Modern

# Project Implementation:
In this project, a hybrid approach has been used, allowing exploration of both methodologies:
- The website version is implemented using Django template-based rendering
- The Flutter mobile application consumes APIs built using Django REST Framework
This approach has helped me understand the strengths, limitations, and real-world use cases of both template-based rendering and API-driven development.

Jan 17, 2026
# Progress
- Created a flutter project inside the django project.
- Set up basic flutter resources in the local device.

Jan 18, 2026
# Progress
- Implemented Login and Register features.
- Verified that authentication works on a real Android device.

# Process:
- Run the Django Server with:
python manage.py runserver 0.0.0.0:8000
   * This allows Android devices on the same Wi-Fi to access he API.
- In android/app/src/AndroidManifest.xml, inside <application> block, add
android:usesCleartextTraffic="true"
This ensures Flutter allows HTTP requests to the API.
- Test the app on a real device to verify functionality.

Jan 19 - 20, 2026
No progress due to college-related commitments.

Jan 21, 2026
# Progress:
- Implemented persistent login: the app remembers the login state, so logged-in users are directly sent to the Home screen even after closing and reopening the app.
 Added a Bottom Navigation Bar to navigate between Home, Tasks, Categories, Activity Log, and Profile screens.
 
# Process:
- Stored access and refresh tokens in SharedPreferences and set isLoggedIn = true when login succeeds.
- On app start, the isLoggedIn flag is checked:
   * If true, the user is sent to HomeScreen.
   * If false, the user is sent to LoginScreen.
- Used Flutter’s BottomNavigationBar widget to allow seamless navigation between multiple pages.