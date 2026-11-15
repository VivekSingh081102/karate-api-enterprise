Feature: User Management API Operations

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def userSchema = read('classpath:users/user-schema.json')

  @SCRUM-TC-1 @smoke
  Scenario: Verify GET /users/{id} returns HTTP 200 and valid schema
    Given path 'users', 2
    When method GET
    Then status 200
    And match response.data == userSchema
    And match response.data.id == 2
    And match response.data.first_name == 'Janet'
    And assert responseTime < 2000

  @SCRUM-TC-2 @regression
  Scenario: Verify POST /users creates records with valid parameters
    Given path 'users'
    And request { "name": "Alice", "job": "Solutions Architect" }
    When method POST
    Then status 201
    And match response.name == 'Alice'
    And match response.job == 'Solutions Architect'
    And match response.id == '#present'
    And match response.createdAt == '#string'

  @SCRUM-TC-3 @regression
  Scenario: Verify complete lifecycle: Create, Validate, and Delete user
    Given path 'users'
    And request { "name": "Charlie", "job": "QA Architect" }
    When method POST
    Then status 201
    * def createdId = response.id

    Given path 'users', createdId
    When method DELETE
    Then status 204

  @SCRUM-TC-4 @negative
  Scenario: Verify GET /users/{invalid_id} yields HTTP 404
    Given path 'users', 99999
    When method GET
    Then status 404
    And match response == {}
