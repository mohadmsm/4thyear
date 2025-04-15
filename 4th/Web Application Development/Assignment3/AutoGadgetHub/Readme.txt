# eshop
## Requirements

* Python 3.9+
* Visual Studio Code  
  * Extension: "Python" (ms-python.python)
* Docker (optional, for Docker setup)
* MySQL Server (or access to a MySQL database)

## Local Development

### Instructions

To run the project locally:

1. Open the project in Visual Studio Code.
2. Set up a virtual environment:
   - Press `F1` -> "Python: Create Environment" -> Select "Venv" -> Choose `requirements.txt`.
3. Select the Python interpreter:
   - Press `F1` -> "Python: Select Interpreter" -> Choose the `.venv` environment.
4. Run the following commands in the terminal:
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   python manage.py createsuperuser  # Follow prompts to create admin user
   python manage.py runserver  # Host defaults to localhost

Then open <http://localhost:8000> in the web browser to access the web app,

To run the app using Docker follow the below instructions:

first setup MySQL in your machine with db called myappdb and user name 'myappdbuser' with pass'myappdbpass'

This can be done using MYSQL shell (CLI) or DBever or anything you prefer, for MYSQL CLI, please follow the instrunctions in readme_MYSQL.txt. 

once it's running run the following commands in the project.

1. Build the Docker image:
	docker build -t myapp .
2. Create a persistent volume for storage:
	docker volume create myapp-storage
3. Run the container using MYSQL url as per the requirements :
	docker run -ti \
  -e DATABASE_URL="mysql://myappdbuser:myappdbpass@host.docker.internal:3306/myappdb" \
  -v myapp-storage:/app/storage \
  -p 8000:8000 \
  myapp

The application will be available at http://localhost:8000.

Important Notes:

Ensure your MySQL server is running and accessible at host.docker.internal:3306.

