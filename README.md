411 Docker
==========

What is 411?
------------

411 is an alerting framework built on Elasticsearch. The code can be found here: https://github.com/etsy/411


How to use this image
---------------------

Make sure you're using the right branch! (This branch is for ES 2.0)

To set up just 411:
```
$ docker run -p 8080:80 kaiz/411
```
This assumes you already have an elasticsearch cluster set up with the hostname `es`.


To set up 411 and Elasticsearch (requires `docker-compose`):
```
$ docker-compose up
```


Where is data stored?
---------------------

All data is stored in `/data`, which is declared as a volume.
