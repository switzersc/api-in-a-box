# API-in-a-Box

To get started, clone this repo. 

Then replace the environment variable `ORIGIN_REPO` in the `docker-compose.yml` file to point to the github repo (format: <username>/<repo>) you would like to pull data from. You may use the current repo "switzersc/atlanta-food-data" as an example.

Then, from the root of this directory, build the containers:

    docker-compose build

And start them up:

    docker-compose up

If you would like to run them in the background, add `-d` to the `up` command. 

Now you can curl to get your data:

    curl http://localhost:4567/resources
    
If you're running on boot2docker, you will need to replace `localhost` with your boot2docker ip.

