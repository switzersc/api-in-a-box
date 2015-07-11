# API-in-a-Box

API-in-a-Box is exactly what it sounds like. Say you have a handful of CSV files that you need a searchable API for. Put those files in Github repository, spin up this API-in-a-Box, and there you go! A REST hypermedia API that utilizes Elasticsearch's killer searching.

## Setup

To get started, clone this repo. 

Then replace the environment variable `ORIGIN_REPO` in the `docker-compose.yml` file to point to the github repo (format: [username]/[repo]) you would like to pull data from. You may use the current repo "switzersc/atlanta-food-data" as an example.

Then, from the root of this directory, build the containers:

    docker-compose build

And start them up:

    docker-compose up

If you would like to run them in the background, add `-d` to the `up` command. 

Now you can curl to get your data:

    curl http://localhost:4567/resources
    
If you're running on boot2docker, you will need to replace `localhost` with your boot2docker ip.


## Using this API

You have three endpoints to work with:

* `GET /resources`: Lists all resources, paginated by 50 by default. You can change the size of each response by passing in a `size` query param, and you can offset to get to the next "page" by passing the query param `from` to identify which result you'd like to start at.
* `GET /resources/:id`: Returns a specific resource.
* `GET /resources/search`: Search all resources. You can use `size` and `from` in the same way as above, but you also have all the queries given in the `queries` object in the `/resources` response. These queries match the field names (mappings) of each document, so for example if your CSV has a column called "STREET", each document now has a field with the name "STREET", and you can pass `STREET` as a query param in a request to this endpoint. You will get results which have a STREET value that includes any word in the value of this query. If you want results matching a whole phrase rather than any word in the phrase, you can pass a query string of `match_phrase=true`. You can also search by `FILE_SOURCE`, which is added to every document and contains the name of the file the document was originally a row in.

All responses are returned in the [Collection+JSON format](https://github.com/collection-json/spec), with a MIME type of 'application/vnd.collection+json'


## How it works

When you run `docker-compose up`, the Elasticsearch container starts, and then the API container starts with the `api/deploy/start.sh` script. This script sleeps for 8 seconds (to give time for the Elasticsearch container to start), then it runs the 'api/data_processor/file_grabber.rb' ruby file, which makes a request to Github's API to download the raw files of whatever is in the repository that you specify with the environment variable `ORIGIN_REPO`. It also creates an Elasticsearch index with the name `api` and then adds the rows from the downloaded files as documents to this index and gives them the type `resource`. 

Then the start script spins up a Sinatra server that provides three endpoints above, and returns responses formatted according to the [Collection+JSON spec](https://github.com/collection-json/spec). 

NB: Currently, if one of the source files has any incorrect formatting, it will probably raise an exception and the FileGrabber class will skip over this file. Watch the docker logs for the API container to see if there's any note of skipping a file. 


## To Do

These are ideas for further development:

* add validations and specs
* add more cool Elasticsearch features
* add examples of requests and responses to README
* add ability to use any remote source, not just a github repo
* allow for private github repo
* add ability to use file structure in a repo to define different types of documents for different types of resources