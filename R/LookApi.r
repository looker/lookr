# Looker API 3.0 Reference
#
# ### Authorization  The Looker API uses Looker **API3** credentials for authorization and access control. Looker admins can create API3 credentials on Looker's **Admin/Users** page. Pass API3 credentials to the **/login** endpoint to obtain a temporary access_token. Include that access_token in the Authorization header of Looker API requests. For details, see [Looker API Authorization](https://looker.com/docs/r/api/authorization)  ### Client SDKs  The Looker API is a RESTful system that should be usable by any programming language capable of making HTTPS requests. Client SDKs for a variety of programming languages can be generated from the Looker API's Swagger JSON metadata to streamline use of the Looker API in your applications. A client SDK for Ruby is available as an example. For more information, see [Looker API Client SDKs](https://looker.com/docs/r/api/client_sdks)  ### Try It Out!  The 'api-docs' page served by the Looker instance includes 'Try It Out!' buttons for each API method. After logging in with API3 credentials, you can use the \"Try It Out!\" buttons to call the API directly from the documentation page to interactively explore API features and responses.  ### Versioning  Future releases of Looker will expand this API release-by-release to securely expose more and more of the core power of Looker to API client applications. API endpoints marked as \"beta\" may receive breaking changes without warning. Stable (non-beta) API endpoints should not receive breaking changes in future releases. For more information, see [Looker API Versioning](https://looker.com/docs/r/api/versioning)
#
# OpenAPI spec version: 3.0.0
#
# Generated by: https://github.com/swagger-api/swagger-codegen.git

#' @title Look operations
#' @description looker.Look
#'
#' @field path Stores url path of the request.
#' @field apiClient Handles the client-server communication.
#' @field userAgent Set the user agent of the request.
#'
#' @importFrom R6 R6Class
#'
#' @section Methods:
#' \describe{
#'
#' all_looks Get All Looks
#'
#'
#' create_look Create Look
#'
#'
#' delete_look Delete Look
#'
#'
#' look Get Look
#'
#'
#' run_look Run Look
#'
#'
#' search_looks Search Looks
#'
#'
#' update_look Update Look
#'
#' }
#'
#' @export
LookApi <- R6::R6Class(
  'LookApi',
  public = list(
    userAgent = "Swagger-Codegen/1.0.0/r",
    apiClient = NULL,
    initialize = function(apiClient){
      if (!missing(apiClient)) {
        self$apiClient <- apiClient
      }
      else {
        self$apiClient <- ApiClient$new()
      }
    },
    all_looks = function(fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`fields`)) {
        queryParams['fields'] <- fields
      }

      urlPath <- "/looks"
      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)

      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        returnObject <- Look$new()
        result <- returnObject$fromJSON(httr::content(resp, "text", encoding = "UTF-8"))
        Response$new(returnObject, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", resp)
      }

    },
    create_look = function(body, fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`fields`)) {
        queryParams['fields'] <- fields
      }

      if (!missing(`body`)) {
        body <- `body`$toJSONString()
      } else {
        body <- NULL
      }

      urlPath <- "/looks"
      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "POST",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)

      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        returnObject <- LookWithQuery$new()
        result <- returnObject$fromJSON(httr::content(resp, "text", encoding = "UTF-8"))
        Response$new(returnObject, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", resp)
      }

    },
    delete_look = function(look_id, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      urlPath <- "/looks/{look_id}"
      if (!missing(`look_id`)) {
        urlPath <- gsub(paste0("\\{", "look_id", "\\}"), `look_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "DELETE",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)

      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        returnObject <- Character$new()
        result <- returnObject$fromJSON(httr::content(resp, "text", encoding = "UTF-8"))
        Response$new(returnObject, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", resp)
      }

    },
    look = function(look_id, fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`fields`)) {
        queryParams['fields'] <- fields
      }

      urlPath <- "/looks/{look_id}"
      if (!missing(`look_id`)) {
        urlPath <- gsub(paste0("\\{", "look_id", "\\}"), `look_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)

      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        returnObject <- LookWithQuery$new()
        result <- returnObject$fromJSON(httr::content(resp, "text", encoding = "UTF-8"))
        Response$new(returnObject, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", resp)
      }

    },
    run_look = function(look_id, result_format, limit, apply_formatting, apply_vis, cache, image_width, image_height, generate_drill_links, force_production, cache_only, path_prefix, rebuild_pdts, server_table_calcs, ...){
      args <- list(...)
      queryParams <- list()
      print(queryParams)
      headerParams <- character()

      if (!missing(`apply_formatting`)) {
        queryParams['apply_formatting'] <- apply_formatting
      }

      if (!missing(`apply_vis`)) {
        queryParams['apply_vis'] <- apply_vis
      }

      if (!missing(`cache`)) {
        queryParams['cache'] <- cache
      }

      if (!missing(`image_width`)) {
        queryParams['image_width'] <- image_width
      }

      if (!missing(`image_height`)) {
        queryParams['image_height'] <- image_height
      }

      if (!missing(`generate_drill_links`)) {
        queryParams['generate_drill_links'] <- generate_drill_links
      }

      if (!missing(`force_production`)) {
        queryParams['force_production'] <- force_production
      }

      if (!missing(`cache_only`)) {
        queryParams['cache_only'] <- cache_only
      }

      if (!missing(`path_prefix`)) {
        queryParams['path_prefix'] <- path_prefix
      }

      if (!missing(`rebuild_pdts`)) {
        queryParams['rebuild_pdts'] <- rebuild_pdts
      }

      if (!missing(`server_table_calcs`)) {
        queryParams['server_table_calcs'] <- server_table_calcs
      }

      urlPath <- "/looks/{look_id}/run/{result_format}"
      if (!missing(`look_id`)) {
        urlPath <- gsub(paste0("\\{", "look_id", "\\}"), `look_id`, urlPath)
      }

      if (!missing(`result_format`)) {
        urlPath <- gsub(paste0("\\{", "result_format", "\\}"), `result_format`, urlPath)
      }

      if (!missing(`limit`)) {
        urlPath <- gsub(paste0("\\{", "limit", "\\}"), `limit`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)

      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        returnObject <- Character$new()
        result <- returnObject$fromJSON(httr::content(resp, "text", encoding = "UTF-8"))
        Response$new(returnObject, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", resp)
      }

    },
    search_looks = function(fields, page, per_page, limit, offset, sorts, title, description, content_favorite_id, space_id, user_id, view_count, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`fields`)) {
        queryParams['fields'] <- fields
      }

      if (!missing(`page`)) {
        queryParams['page'] <- page
      }

      if (!missing(`per_page`)) {
        queryParams['per_page'] <- per_page
      }

      if (!missing(`limit`)) {
        queryParams['limit'] <- limit
      }

      if (!missing(`offset`)) {
        queryParams['offset'] <- offset
      }

      if (!missing(`sorts`)) {
        queryParams['sorts'] <- sorts
      }

      if (!missing(`title`)) {
        queryParams['title'] <- title
      }

      if (!missing(`description`)) {
        queryParams['description'] <- description
      }

      if (!missing(`content_favorite_id`)) {
        queryParams['content_favorite_id'] <- content_favorite_id
      }

      if (!missing(`space_id`)) {
        queryParams['space_id'] <- space_id
      }

      if (!missing(`user_id`)) {
        queryParams['user_id'] <- user_id
      }

      if (!missing(`view_count`)) {
        queryParams['view_count'] <- view_count
      }

      urlPath <- "/looks/search"
      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "GET",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)

      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        returnObject <- Look$new()
        result <- returnObject$fromJSON(httr::content(resp, "text", encoding = "UTF-8"))
        Response$new(returnObject, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", resp)
      }

    },
    update_look = function(look_id, body, fields, ...){
      args <- list(...)
      queryParams <- list()
      headerParams <- character()

      if (!missing(`fields`)) {
        queryParams['fields'] <- fields
      }

      if (!missing(`body`)) {
        body <- `body`$toJSONString()
      } else {
        body <- NULL
      }

      urlPath <- "/looks/{look_id}"
      if (!missing(`look_id`)) {
        urlPath <- gsub(paste0("\\{", "look_id", "\\}"), `look_id`, urlPath)
      }

      resp <- self$apiClient$callApi(url = paste0(self$apiClient$basePath, urlPath),
                                 method = "PATCH",
                                 queryParams = queryParams,
                                 headerParams = headerParams,
                                 body = body,
                                 ...)

      if (httr::status_code(resp) >= 200 && httr::status_code(resp) <= 299) {
        returnObject <- LookWithQuery$new()
        result <- returnObject$fromJSON(httr::content(resp, "text", encoding = "UTF-8"))
        Response$new(returnObject, resp)
      } else if (httr::status_code(resp) >= 400 && httr::status_code(resp) <= 499) {
        Response$new("API client error", resp)
      } else if (httr::status_code(resp) >= 500 && httr::status_code(resp) <= 599) {
        Response$new("API server error", resp)
      }

    }
  )
)
