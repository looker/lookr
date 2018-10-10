# Looker API 3.0 Reference
# 
# ### Authorization  The Looker API uses Looker **API3** credentials for authorization and access control. Looker admins can create API3 credentials on Looker's **Admin/Users** page. Pass API3 credentials to the **/login** endpoint to obtain a temporary access_token. Include that access_token in the Authorization header of Looker API requests. For details, see [Looker API Authorization](https://looker.com/docs/r/api/authorization)  ### Client SDKs  The Looker API is a RESTful system that should be usable by any programming language capable of making HTTPS requests. Client SDKs for a variety of programming languages can be generated from the Looker API's Swagger JSON metadata to streamline use of the Looker API in your applications. A client SDK for Ruby is available as an example. For more information, see [Looker API Client SDKs](https://looker.com/docs/r/api/client_sdks)  ### Try It Out!  The 'api-docs' page served by the Looker instance includes 'Try It Out!' buttons for each API method. After logging in with API3 credentials, you can use the \"Try It Out!\" buttons to call the API directly from the documentation page to interactively explore API features and responses.  ### Versioning  Future releases of Looker will expand this API release-by-release to securely expose more and more of the core power of Looker to API client applications. API endpoints marked as \"beta\" may receive breaking changes without warning. Stable (non-beta) API endpoints should not receive breaking changes in future releases. For more information, see [Looker API Versioning](https://looker.com/docs/r/api/versioning) 
# 
# OpenAPI spec version: 3.0.0
# 
# Generated by: https://github.com/swagger-api/swagger-codegen.git


#' LookmlModelExploreSet Class
#'
#' @field name 
#' @field value 
#'
#' @importFrom R6 R6Class
#' @importFrom jsonlite fromJSON toJSON
#' @export
LookmlModelExploreSet <- R6::R6Class(
  'LookmlModelExploreSet',
  public = list(
    `name` = NULL,
    `value` = NULL,
    initialize = function(`name`, `value`){
      if (!missing(`name`)) {
        stopifnot(is.character(`name`), length(`name`) == 1)
        self$`name` <- `name`
      }
      if (!missing(`value`)) {
        stopifnot(is.list(`value`), length(`value`) != 0)
        lapply(`value`, function(x) stopifnot(is.character(x)))
        self$`value` <- `value`
      }
    },
    toJSON = function() {
      LookmlModelExploreSetObject <- list()
      if (!is.null(self$`name`)) {
        LookmlModelExploreSetObject[['name']] <- self$`name`
      }
      if (!is.null(self$`value`)) {
        LookmlModelExploreSetObject[['value']] <- self$`value`
      }

      LookmlModelExploreSetObject
    },
    fromJSON = function(LookmlModelExploreSetJson) {
      LookmlModelExploreSetObject <- jsonlite::fromJSON(LookmlModelExploreSetJson)
      if (!is.null(LookmlModelExploreSetObject$`name`)) {
        self$`name` <- LookmlModelExploreSetObject$`name`
      }
      if (!is.null(LookmlModelExploreSetObject$`value`)) {
        self$`value` <- LookmlModelExploreSetObject$`value`
      }
    },
    toJSONString = function() {
       sprintf(
        '{
           "name": %s,
           "value": [%s]
        }',
        self$`name`,
        lapply(self$`value`, function(x) paste(paste0('"', x, '"'), sep=","))
      )
    },
    fromJSONString = function(LookmlModelExploreSetJson) {
      LookmlModelExploreSetObject <- jsonlite::fromJSON(LookmlModelExploreSetJson)
      self$`name` <- LookmlModelExploreSetObject$`name`
      self$`value` <- LookmlModelExploreSetObject$`value`
    }
  )
)