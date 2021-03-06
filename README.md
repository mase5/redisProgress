redisProgress Package
================
Clément Turbelin

Overview
--------

The goal of redisProgress is to create a progress bar system to follow tasks distributed accross several R instances (using foreach package for example). It uses Redis instance to follow tasks progress. Tasks are grouped in a common named "queue" and can be monitored together on the same screen.

Installation
------------

``` r
# Install the released version from CRAN:
install.packages("redisProgress")

# Install the cutting edge development version from GitHub:
# install.packages("devtools")
devtools::install_github("cturbelin/redisProgress")
```

Usage
-----

The package provides 2 functions :

-   create\_redis\_progress() to create a task queue, and starting one or several task to monitor in the queue
-   redis\_progress\_monitor() to follow the progress of all tasks in a queue

### Creating tasks queue

once created, the progress bar object is used to declare the start of each task and the progress state of each task (basically an integer value representing the number of achieved steps of the running task)

``` r
library(redisProgress)

redis = redis_client("rredis") # creating redis client, using rredis with default parameters

# Creating the queue 
progress = create_redis_progress("my-queue-name", redis=redis)

progress$start("job1", steps=100) # Starting job1 in the queue
progress$step(10)
progress$step(100) # Another step value

# Starting another task
progress$start("job2", steps=5) # Starting job1 in the queue
progress$incr() # Simply incrementing task step
progress$message("job2 is running")
progress$incr() # Simply incrementing task step
```

With parallel tasks, for example with `foreach`

``` r
library(redisProgress)
library(parallel)
library(foreach)
library(doParallel)

registerDoParallel(3)

redis = redis_client("rredis", host="localhost")
progress = create_redis_progress("my-jobs", redis, unique.name=TRUE, publish = "jobs:clement")

data = foreach(job=1:20, .verbose = TRUE, .combine = c, .export = "progress") %dopar% {
    progress$start(paste0("task",job), steps=100)
    for(i in 1:100) {
        # Doing a step of my long running task
        # Sys.sleep(runif(1, min=5, max=30))
        progress$incr() # 
    }
}

stopImplicitCluster()
```

`progress` object is propagated accross all R workers ensuring the tasks are registered in the same job queue and on the same Redis server (!)

In this previous example the queue name is generated, to ensure it is unique each time the program is run. The last generated queue name is published using the key passed to the `publish` parameter.

### Monitoring task progress of a queue

In another R instance, running tasks can be followed using `redis_progress_monitor()` function.

``` r
library(redisProgress)

redis = redis_client("rredis") 

# Known and fixed queue name
redis_progress_monitor(name="my-queue-name", redis=redis)

# Queue name has been generated and published in another redis key, use "key" to monitor the current queue name
redis_progress_monitor(key="jobs:clement", redis=redis)
```

Redis Client implementations
----------------------------

redisProgress can handle several packages implementing redis client API

-   rredis
-   RCppRedis
-   redux
-   rrlite (Redis without Redis)

`redis_client()` creates a client object embedding the connection context, using a unified interface, regardless the redis package used. The connection parameters (host, port,...) will be propagated to the R instances
