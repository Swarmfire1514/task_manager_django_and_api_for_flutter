Django Task Manager

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

Installation:

1. Clone the repository:
   git clone [https://github.com/username/repo-name.git](https://github.com/username/repo-name.git)
   cd repo-name

2. Create and activate a virtual environment:
   python -m venv venv

# Windows

venv\Scripts\activate

# macOS/Linux

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
* Admin panel: [http://127.0.0.1:8000/admin/](http://127.0.0.1:8000/admin/)

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
