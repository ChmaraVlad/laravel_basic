Project Setup Guide
Follow the steps below to set up and run the project.

1. Fill in the empty .env variables
Inside the /docker folder
Inside the /projects folder

2. Fill in the configuration files
docker/server/00-php.ini
docker/server/sites-available/000-default.conf
You can check the example values in these files and modify them according to your setup.

3. Build the project
Run the following command inside the /docker folder to build the project:
docker compose up --build

4. For subsequent runs
You can use the following command to start the project without rebuilding:
docker compose up

6. Access the project
Once the build is successful, you can visit the project at:
https://laravel.loc
