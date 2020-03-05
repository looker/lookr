<!-- README.md is generated from README.Rmd. Please edit that file -->
DEPRECATION WARNING
===================

This package is deprecated and may not work as an interface to Looker.
There currently is no R SDK for Looker, as a result you are better off
calling the API directly.

LookR
=====

This is an SDK for using the Looker API with the R programming language.
Our priority is to add support for the endpoints that are most useful to
data scientists and analysts working in R (the ones that get data from
Looker) but eventually the goal is to add support for every endpoint in
the Looker API.

For more information about the Looker API’s capabilities and for details
about what each endpoint does, see the [Looker API reference
documentation](https://docs.looker.com/reference/api-and-integration/api-reference).

Important!
----------

*LookR used to be based on
[`rJava`](https://cran.r-project.org/package=rJava), but this caused
problems with reliability and many users struggled to get it to work. To
fix this, we’ve rewritten a new SDK in native R. The versions have been
reset as well.*

*All of the old code is available on the old-lookr branch, so if you
want to continue using it, you an install from that branch by setting*
`ref` *to* `old-lookr`:

``` r
devtools::install_github("looker/lookr", ref = "old-lookr")
```

Install
-------

Use `devtools` to install from this repository:

``` r
devtools::install_github("looker/lookr")
library(lookr)
```

Configure
---------

First, make sure that you have your API credentials and the URL to your
Looker host in a file called `looker.ini`. LookR uses the information in
this file to authenticate. See below for a sample of what `looker.ini`
should look like:

`looker-sample.ini`

    [Looker]
    # API version is required
    api_version=3.0
    # Base URL for API. Do not include /api/* in the url
    base_url=https://<your-looker-endpoint>:19999
    # API 3 client id
    client_id=your_API3_client_id
    # API 3 client secret
    client_secret=your_API3_client_secret
    # Optional embed secret for SSO embedding
    embed_secret=your_embed_SSO_secret
    # Optional user_id to impersonate
    user_id=
    # Set to false if testing locally against self-signed certs. Otherwise leave True
    verify_ssl=True

*Make sure that this file is not checked into version control.*

Connect
-------

All of the endpoints are accessed from methods contained in an instance
of the `LookerSDK` class, which is implemented in
[`R6`](https://cran.r-project.org/web/packages/R6/index.html). To start
using LookR, create an instance of that class:

``` r
sdk <- LookerSDK$new(configFile = "looker.ini")
```

If you’re using a version of RStudio that includes the [Connections
Pane](https://support.rstudio.com/hc/en-us/articles/115010915687-Using-RStudio-Connections),
you can also use that to create a new connection to Looker.

Whether you use the Connection Pane to create the connection or not, you
will be able to browse your projects, models, and explores in the
Connections Pane as long as your API user has access to them.

Query
-----

You can use LookR to fetch the results of a saved Look by calling
`runLook`:

``` r
data <- sdk$runLook(lookId = 1337)
```

You can also use a new query by calling `runInlineQuery`. `model`,
`view`, and `fields` are mandatory arguments:

``` r
data <- sdk$runInlineQuery(model = "model_name",
                           view = "my_awesome_explore",
                           fields = c("id", "count"))
```

and you can optionally supply `filters`, `sorts`, `limit`, and
`queryTimezone`:

``` r
data <- sdk$runInlineQuery(model = "model_name",
                           view = "my_awesome_explore",
                           fields = c("id", "count"),
                           filters = list(c("field_name", "filter_expression"),
                                          c("another_field", "filter_expression")),
                           limit = 500,
                           queryTimezone = "America/Los_Angeles")
```
