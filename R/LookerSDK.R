#' LookerSDK
#' 
#' Top-level container for current user session and API settings.
#' Uses API settings contained in a config file, \code{"looker.ini"} by default.
#' All of the endpoints that should be called by end-users are methods of this object.
#' Instantiate a new instance of this class with the \code{$new} method shown below.
#' 
#' 
#' @section Usage:
#' \preformatted{
#' sdk <- LookerSDK$new(configFile = "looker.ini", login = TRUE,
#'                      settings, userSession)
#' 
#' sdk$login()
#' sdk$isAuthenticated()
#' sdk$logout()
#' }
#' 
#' @section Arguments:
#' \describe{
#'   \item{configFile}{Path to configuration file containing API settings and credentials.}
#'   \item{login}{If \code{TRUE}, get an access token upon object creation.}
#'   \item{settings}{Optional, directly supply an \code{ApiSettings} object.}
#'   \item{userSession}{Optional, directly supply a \code{UserSession} object.}
#'   \item{userSession}{Optional, directly supply a \code{UserSession} object.}
#' }
#' 
#' @section Authentication Methods:
#' \describe{
#'   \item{\code{login()}}{Acquire an access token and authenticate the client.}
#'   \item{\code{logout()}}{Revoke current access token.}
#'   \item{\code{isAuthenticated()}}{Returns \code{TRUE} when an unexpired token is being used.}
#'   \item{\code{activeToken()}}{Returns a list representing the current active token.}
#'   \item{\code{refresh()}}{If current active token is missing or expired, acquires a new token.}
#'   \item{\code{me()}}{Returns information about the current authenticated user.}
#' }
#' 
#' @section Look Endpoints:
#' \describe{
#'   \item{\code{runLook(lookId)}}{Returns the query result for the Look specified in \code{lookId}.}
#' }
#' 
#' @section Dashboard Endpoints:
#' \describe{
#'   \item{\code{allDashboards()}}{Returns a list of all dashboards in the instance.}
#' }
#' 
#' @section Query Endpoints:
#' \describe{
#'   \item{\code{runInlineQuery(model, view, fields, filters, sorts, limit, queryTimezone)}}{Provided with mandatory query parameters (\code{model, view, fields}) plus optional parameters (\code{filters, sorts, limit, queryTimezone}), returns the results of the defined query.}
#' }
#' 
#' @section LookML Project Endpoints:
#' \describe{
#'   \item{\code{allProjects()}}{Returns a list of all projects in the instance.}
#' }
#' 
#' @section LookML Model Endpoints:
#' \describe{
#'   \item{\code{allModels()}}{Return a list of all models in the instance.}
#' }
#' 
#' @name LookerSDK
#' @examples
#' \dontrun{
#' # You can specify the configFile path directly
#' sdk <- lookr::LookerSDK$new(configFile = "path/to/file")
#' 
#' # Or use the looker.ini file in your working directory
#' sdk <- lookr::LookerSDK$new()
#' }
NULL

#' @export
LookerSDK <- R6::R6Class(
  'LookerSDK',
  
  active = list(
    settings = function(value) {
      if(missing(value)) {
        if(is.null(private$.settings)) {
          private$.settings <- ApiSettings$new()
        }
        return(private$.settings)
      } else {
        private$.settings <- value
      }
    },
    
    userSession = function(value) {
      if(missing(value)) {
        if(is.null(private$.userSession)) {
          private$.userSession <- UserSession$new(self$settings)
        }
        return(private$.userSession)
      } else {
        private$.userSession <- value
      }
    },
    
    dashboardApi = function(value) {
      if(missing(value)) {
        if(is.null(self$userSession$dashboardApi)) {
          self$userSession$dashboardApi <- UserSession$new(self$settings)
        }
        return(self$userSession$dashboardApi)
      } else {
        self$userSession$dashboardApi <- value
      }
    },
    
    oauthHeader = function(value) {
      if(missing(value)) {
        return(self$userSession$oauthHeader)
      } else {
        self$userSession$oauthHeader <- value
      }
    }
  ),
  
  private = list(
    .settings = NULL,
    .userSession = NULL
  ),
  
  public = list(
    connectCode = NULL,
    
    initialize = function(configFile = "looker.ini", config, settings, userSession) {
      if(!missing(settings)) {
        self$settings <- settings
      } else {
        self$settings <- ApiSettings$new(configFile = configFile, config = config)
      }
      if(!missing(userSession)) {
        self$userSession <- userSession
      } else {
        self$userSession <- UserSession$new(settings = self$settings)
      }
      
      self$login()
      
      addTaskCallback(function(expr, ...) {
        self$connectCode <- paste(deparse(expr), sep = "\n", collapse = "\n")
        self$on_connection_opened()
        return(FALSE) # return FALSE so this only runs once
      })
    },
    
    on_connection_opened = function(connectCode) {
      observer <- getOption("connectionObserver")
      if(is.null(observer)) {
        return(invisible(NULL))
      }
      observer$connectionOpened(
        type = "looker",
        displayName = "Looker",
        host = self$settings$basePath,
        connectCode = self$connectCode,
        disconnect = self$logout,
        listObjectTypes = function() {
          self$describeRelationships()
        },
        listObjects = function(project, model) {
          self$describeObject(project, model)
        },
        listColumns = function(project, model, explore) {
          self$describeFields(project, model, explore)
        },
        previewObject = function(rowLimit, project, model, explore) {
          self$previewExplore(rowLimit, project, model, explore)
        },
        connectionObject = self)
      return(invisible(NULL))
    },
    
    on_connection_updated = function(hint = "") {
      observer <- getOption("connectionObserver")
      if(is.null(observer)) {
        return(invisible(NULL))
      }
      observer$connectionUpdated(type = "looker",
                                 host = self$settings$basePath,
                                 hint = hint)
    },
    
    on_connection_closed = function() {
      observer <- getOption("connectionObserver")
      if(is.null(observer)) {
        return(invisible(NULL))
      }
      observer$connectionClosed(type = "looker",
                                host = self$settings$basePath)
    },
    
    describeRelationships = function() {
      # TODO: implement nested project/model/explore list
      return(
        list(
          project = list(
            contains = list(
              model = list(
                contains = list(
                  explore = list(
                    contains = "data")))))))
    },
    
    describeObject = function(project, model) {
      if(all(missing(project), missing(model))) {
        projects <- self$allProjects()
        return(data.frame(stringsAsFactors = FALSE,
                          name = projects$name,
                          type = c("project")))
      } else {
        allModels <- self$allModels()
        models <- data.frame(stringsAsFactors = FALSE,
                             name = allModels$name,
                             project_name = allModels$project_name,
                             has_content = allModels$has_content,
                             type = "model")
      }
      if(missing(model)) {
        return(subset(models,
                      subset = (project_name == project) & has_content,
                      select = c(name, type)))
      } else {
        exploreList <- unlist(allModels$explores[[which(allModels$name == model)]])
        return(data.frame(stringsAsFactors = FALSE,
                          name = exploreList$name,
                          type = "explore"))
      }
    },
    
    describeFields = function(project, model, explore) {
      # TODO: implement field description for a given explore
      explore <- self$getLookmlModelExplore(lookmlModelName = model,
                                            exploreName = explore)
      fields <- explore$fields
      dimensions <- data.frame(stringsAsFactors = FALSE,
                               name = vapply(fields$dimensions, function(x) {
                                 x$name
                               }, character(length = 1)),
                               type = vapply(fields$dimensions, function(x) {
                                 x$type
                               }, character(length = 1))
      )
      measures <- data.frame(stringsAsFactors = FALSE,
                             name = vapply(fields$measures, function(x) {
                               x$name
                             }, character(length = 1)),
                             type = vapply(fields$measures, function(x) {
                               x$type
                             }, character(length = 1))
      )
      filters <- data.frame(stringsAsFactors = FALSE,
                            name = vapply(fields$filters, function(x) {
                              x$name
                            }, character(length = 1)),
                            type = vapply(fields$filters, function(x) {
                              x$type
                            }, character(length = 1))
      )
      parameters <- data.frame(stringsAsFactors = FALSE,
                               name = vapply(fields$parameters, function(x) {
                                 x$name
                               }, character(length = 1)),
                               type = vapply(fields$parameters, function(x) {
                                 x$type
                               }, character(length = 1))
      )
      
      return(dimensions)
      #return(rbind(stringsAsFactors = FALSE,
      #  dimensions, measures, filters, parameters))
    },
    
    previewExplore = function(rowLimit, project, model, explore) {
      # TODO: implement explore previewer
      message("listColumns/previewExplore not implemented yet")
      data.frame(id = seq(1, rowLimit),
                 value = sample(1000, size = rowLimit))
    },
    
    login = function() {
      self$userSession$login()
      
      return(invisible(NULL))
    },
    
    logout = function() {
      self$userSession$logout()
      self$on_connection_closed()
    },
    
    isAuthenticated = function() {
      self$userSession$isAuthenticated()
    },
    
    refresh = function() {
      if(!self$isAuthenticated()) {
        self$login()
      }
    },
    
    me = function() {
      self$refresh()
      self$userSession$me(config = self$oauthHeader)
    },
    
    activeToken = function() {
      self$userSession$activeToken()
    },
    
    allDashboards = function() {
      self$refresh()
      self$userSession$dashboardApi$all_dashboards(
        config = self$oauthHeader)$content
    },
    
    allProjects = function() {
      self$refresh()
      self$userSession$projectApi$all_projects(
        config = self$oauthHeader)$content
    },
    
    allModels = function() {
      self$refresh()
      self$userSession$lookmlModelApi$all_lookml_models(
        config = self$oauthHeader)$content
    },
    
    allLooks = function() {
      self$refresh()
      self$userSession$lookApi$all_looks(
        config = self$oauthHeader)$content
    },
    
    runLook = function(lookId, resultFormat = "json") {
      self$refresh()
      
      httr::content(self$userSession$apiClient$callApi(
        url = paste0(self$userSession$apiClient$basePath,
                     "/looks/", lookId,
                     "/run/", resultFormat),
        queryParams = NULL,
        headerParams = NULL,
        method = "GET",
        config = sdk$oauthHeader))
      
      # # generated class not working
      # self$userSession$lookApi$run_look(
      #   look_id = lookId,
      #   result_format = "json",
      #   query = list(fields = fields),
      #   config = self$oauthHeader)$content
    },
    
    runInlineQuery = function(model, # these three are required
                              view,
                              fields,
                              pivots = NULL,
                              filters = NULL,
                              sorts = NULL,
                              limit = 500,
                              queryTimezone = NULL,
                              resultFormat = "json") {
      self$refresh()
      
      if(any(missing(model), missing(view), missing(fields))) {
        stop("must provide all of the following arguments: model, view, fields")
      }
      
      body <- jsonlite::toJSON(
        list(
          model = jsonlite::unbox(model),
          view = jsonlite::unbox(view),
          fields = fields,
          pivots = pivots,
          filters = filters,
          sorts = sorts,
          limit = jsonlite::unbox(as.character(limit)),
          query_timezone = queryTimezone
        ), null = "null"
      )
      
      response <- self$userSession$apiClient$callApi(
        url = paste0(self$userSession$apiClient$basePath,
                     "/queries/run/", resultFormat),
        body = as.character(body),
        queryParams = NULL,
        headerParams = c("Accept"="application/json", "Content-Type"="application/json"),
        method = "POST",
        config = self$oauthHeader
      )
      
      return(httr::content(response))
    },
    
    getLookmlModel = function(lookmlModelName, fields = NULL) {
      # TODO: generated class is broken, this is hand-written for the time being
      # Using the generated class, I get the following error:
      # Error in LookmlModelNavExploreObject$name : 
      # $ operator is invalid for atomic vectors
      
      self$refresh()
      httr::content(self$userSession$apiClient$callApi(
        url = paste0(self$userSession$apiClient$basePath,
                     "/lookml_models/", lookmlModelName),
        queryParams = NULL,
        headerParams = NULL,
        method = "GET",
        config = sdk$oauthHeader))
      
      #self$userSession$lookmlModelApi$lookml_model(
      #  lookml_model_name = lookmlModelName,
      #  config = self$oauthHeader)
    },
    
    getLookmlModelExplore = function(lookmlModelName, exploreName, fields = NULL) {
      # TODO: generated class is broken, this is hand-written for the time being
      # Using the generated class, I get the following error:
      # Error in LookmlModelNavExploreObject$name : 
      # $ operator is invalid for atomic vectors
      
      self$refresh()
      httr::content(self$userSession$apiClient$callApi(
        url = paste0(self$userSession$apiClient$basePath,
                     "/lookml_models/", lookmlModelName,
                     "/explores/", exploreName),
        queryParams = NULL,
        headerParams = NULL,
        method = "GET",
        config = sdk$oauthHeader))
      #self$userSession$lookmlModelApi$lookml_model_explore(
      #  lookml_model_name = lookmlModelName,
      #  explore_name = exploreName,
      #  config = self$oauthHeader)$content
    }
  )
)
