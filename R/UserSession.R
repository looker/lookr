#' UserSession
#' 
#' Keeps track of the client objects for each binding (LookApi, QueryApi, etc).
#' This shouldn't generally be called directly.
#' A new \code{UserSession} will be generated when you created a new \code{LookerSDK}.
#' 
#' @name UserSession
NULL

#' @export
UserSession <- R6::R6Class(
  'UserSession',
  
  active = list(
    # accessor: settings
    settings = function(value) {
      if(missing(value)) {
        return(private$.settings)
      } else {
        private$.settings <- value
      }
    },
    # accessor: clientConfig
    clientConfig = function(value) {
      if(missing(value)) {
        return(private$.clientConfig)
      } else {
        private$.clientConfig <- value
      }
    },
    # accessor: apiClient
    apiClient = function(value) {
      if(missing(value)) {
        if(is.null(private$.apiClient)) {
          private$.apiClient <- ApiClient$new(basePath = paste0(self$settings$basePath,
                                                                        "/api/3.0"),
                                                      configuration = self$clientConfig)
        }
        return(private$.apiClient)
      } else {
        private$.apiClient <- value
      }
    },
    # accessor: authClient
    authClient = function(value) {
      if(missing(value)) {
        if(is.null(private$.authClient)) {
          private$.authClient <- ApiAuthApi$new(self$apiClient)
        }
        return(private$.authClient)
      } else {
        private$.authClient <- value
      }
    },
    # accessor: lookApi
    lookApi = function(value) {
      if(missing(value)) {
        if(is.null(private$.lookApi)) {
          private$.lookApi <- LookApi$new(self$apiClient)
        }
        return(private$.lookApi)
      } else {
        private$.lookApi <- value
      }
    },
    # accessor: queryApi
    queryApi = function(value) {
      if(missing(value)) {
        if(is.null(private$.queryApi)) {
          private$.queryApi <- QueryApi$new(self$apiClient)
        }
        return(private$.queryApi)
      } else {
        private$.queryApi <- value
      }
    },
    # accessor: dashboardAPI
    dashboardApi = function(value) {
      if(missing(value)) {
        if(is.null(private$.dashboardApi)) {
          private$.dashboardApi <- DashboardApi$new(self$apiClient)
        }
        return(private$.dashboardApi)
      } else {
        private$.dashboardApi <- value
      }
    },
    # accessor: userApi
    userApi = function(value) {
      if(missing(value)) {
        if(is.null(private$.userApi)) {
          private$.userApi <- UserApi$new(self$apiClient)
        }
        return(private$.userApi)
      } else {
        private$.userApi <- value
      }
    },
    # accessor: lookmlModelApi
    lookmlModelApi = function(value) {
      if(missing(value)) {
        if(is.null(private$.lookmlModelApi)) {
          private$.lookmlModelApi <- LookmlModelApi$new(self$apiClient)
        }
        return(private$.lookmlModelApi)
      } else {
        private$.lookmlModelApi <- value
      }
    },
    # accessor: projectApi
    projectApi = function(value) {
      if(missing(value)) {
        if(is.null(private$.projectApi)) {
          private$.projectApi <- ProjectApi$new(self$apiClient)
        }
        return(private$.projectApi)
      } else {
        private$.projectApi <- value
      }
    },
    # accessor: userId
    userId = function(value) {
      if(missing(value)) {
        return(private$.userId)
      } else {
        private$.userId <- value
      }
    },
    # accessor: tokenExpiresAt
    tokenExpiresAt = function(value) {
      if(missing(value)) {
        return(private$.tokenExpiresAt)
      } else {
        private$.tokenExpiresAt <- value
      }
    },
    # accessor: token
    token = function(value) {
      if(missing(value)) {
        return(private$.token)
      }
      if(!is.null(value) && (is.null(private$.token) || private$.token != value)) {
        self$reset()
        private$.token <- value
        self$setAuthExpiration(value)
      }
    },
    # accessor: userToken
    userToken = function(value) {
      if(missing(value)) {
        return(private$.userToken)
      } else {
        private$.userToken <- value
      }
    },
    
    oauthHeader = function(value) {
      if(!missing(value)) {
        warning("Cannot set value on read-only binding oauthHeader")
      } else {
        return(httr::add_headers(
          Authorization = paste("token",self$activeToken()$access_token)))
      }
    }
  ),
  
  private = list(
    .settings = NULL,
    .clientConfig = NULL,
    .apiClient = NULL,
    .authClient = NULL,
    .lookApi = NULL,
    .queryApi = NULL,
    .dashboardApi = NULL,
    .lookmlModelApi = NULL,
    .projectApi = NULL,
    .userApi = NULL,
    .userId = NULL,
    .tokenExpiresAt = NULL,
    .token = NULL,
    .userToken = NULL,
    .me = NULL,
    
    .login = function() {
      self$reset()
      
      self$token <- httr::init_oauth2.0(
        endpoint = httr::oauth_endpoint(
          authorize = NULL,
          access = paste0(
            self$settings$basePath, "/api/", self$settings$apiVersion, "/login")),
        app = httr::oauth_app(
          appname = "lookr",
          key = self$settings$clientId,
          secret = self$settings$clientSecret),
        client_credentials = TRUE)
      
      
#       client <- ApiClient$new(basePath = self$settings$basePath,
#                                       configuration = self$clientConfig)
# 
#       # this would give us parity with the Python SDK, but the AuthApiAuth
#       # class is very broken so we can't use it
# #
# #       auth <- ApiAuthApi$new(client)
# #
# #       tokenResponse <- auth$login(client_id = self$settings$clientId,
# #                                   client_secret = self$settings$clientSecret)
# #
#       # what follows is a workaround until we implement Oauth the way
#       # swagger wants us to
# 
#       tokenResponse <- client$callApi(url = paste0(self$settings$basePath,
#                                                    "/login"),
#                                       method = "POST",
#                                       queryParams = list(),
#                                       headerParams = character(),
#                                       body = paste0("client_id=",
#                                                     self$settings$clientId,
#                                                     "&client_secret=",
#                                                     self$settings$clientSecret))
# 
#       self$token <- RJSONIO::fromJSON(rawToChar(tokenResponse$content))
      
      if(is.null(self$token)) {
        stop("Login to ", self$settings$basePath, " failed")
      }
    }
  ),
  
  public = list(
    initialize = function(configFile, settings) {
      if(missing(settings)) {
        self$settings <- ApiSettings$new(configFile)
      } else {
        self$settings <- settings
      }
    },
    
    reset = function() {
      private$.token <- NULL
      private$.tokenExpiresAt <- NULL
      private$.apiClient <- NULL
      private$.authClient <- NULL
      private$.userApi <- NULL
      private$.lookApi <- NULL
      private$.lookmlModelApi <- NULL
      private$.projectApi <- NULL
      private$.me <- NULL
      private$.userId <- NULL
      private$.userToken <- NULL
    },
    
    # public login method, calls private$.login and and self$loginUser
    login = function() {
      private$.login()
      if(!is.null(self$settings$userId) && nchar(self$settings$userId) > 0) {
        self$loginUser()
      }
    },
    
    loginUser = function() {
      # TODO: implement public loginUser method
      message("self$loginUser not implemented")
    },
    
    isAuthenticated = function() {
      if(is.null(self$apiClient)) {
        return(FALSE)
      }
      if(is.null(self$activeToken)) {
        return(FALSE)
      }
      if(is.null(self$tokenExpiresAt)) {
        return(FALSE)
      }
      return(self$tokenExpiresAt > Sys.time()) # Sys.time is "POSIXct"
    },
    
    # 
    me = function(...) {
      if(is.null(private$.me)) {
        private$.me <- self$userApi$me(...)
      }
      return(private$.me)
    },
    
    # notes: returns token unless userToken is not null
    activeToken = function() {
      if(is.null(self$userToken)) {
        return(self$token)
      } else {
        return(self$userToken)
      }
    },
    
    assignApiClient = function(authToken) {
      if(missing(authToken)) {
        authToken <- self$activeToken()
      }
      ### this isn't necessary at the moment because Oauth via swagger classes
      ### is broken, but once Oauth is implemented we can use something like it
      # self$apiClient <- ApiClient$new(basePath = self$settings$basePath,
      #                                         configuration = self$settings$configuration)
    },
    
    setAuthExpiration = function(authToken) {
      if(missing(authToken)) {
        private$.tokenExpiresAt <- Sys.time()
      } else {
        private$.tokenExpiresAt <- authToken$expires_in + Sys.time()
      }
      return(private$.tokenExpiresAt)
    },
    
    impersonating = function() {
      return(!is.null(self$userToken))
    },
    
    logout = function() {
      if(self$isAuthenticated()) {
        self$authClient$logout()
        if(self$impersonating()) {
          private$.userId <- NULL
          private$.userToken <- NULL
          private$.login()
          } else {
          self$reset()
        }
      }
    }
  )
)