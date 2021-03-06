% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/progress.R
\name{redis_progress_bar}
\alias{redis_progress_bar}
\title{Progress bar generator function}
\usage{
redis_progress_bar(name, redis, debug = FALSE)
}
\arguments{
\item{name}{progress name prefix}

\item{redis}{redis_client() results}

\item{debug}{debug mode}
}
\value{
progress bar instance
}
\description{
Holds the environment containing progress bar data
For one task instance
}
\section{progress-bar}{

The progress bar instance is currently a very simple object-mimic list exposing several functions

\describe{
 \item{start}{Start a task}
 \item{incr}{Increment the step value}
 \item{step}{Set the current step value}
 \item{message}{Send a message}
 \item{task}{get the task name}
 \item{queue}{get the queue name}
 \item{value}{get the queue name}
}
Parameters of these functions (if any), are described in the following sections
}

\section{\code{start(taskname, steps=0, init = 0, modulo=NULL)}}{


Declare the starting of a task
\describe{
 \item{taskname}{Name of the starting task (cannot contain colon character) }
 \item{steps}{Total number of steps of the task}
 \item{init}{Initial step value}
}
}

\section{\code{step_task(newvalue)}}{

Define the current task step to be newvalue
}

\section{\code{message(msg)}}{

Send a message
get the queue name
get the value
}

