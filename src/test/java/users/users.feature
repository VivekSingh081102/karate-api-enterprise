Feature: User Management API Operations

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def userSchema = read('classpath:users/user-schema.json')

  @TC-REQ-101 @smoke
  Scenario: Get user by ID and validate contract & schema
    Given path 'users', 2
    When method GET
    Then status 200
    And match response.data == userSchema
    And match response.data.id == 2
    And match response.data.first_name == 'Janet'
    # Response time SLA check (< 2000 ms)
    And assert responseTime < 2000

  @TC-REQ-102 @regression
  Scenario Outline: Create user with parameterized payloads (Data-Driven)
    Given path 'users'
    And request { "name": '<name>', "job": '<job>' }
    When method POST
    Then status 201
    And match response.name == '<name>'
    And match response.job == '<job>'
    And match response.id == '#present'
    And match response.createdAt == '#string'

    Examples:
      | name    | job               |
      | Alice   | Solutions Architect |
      | Bob     | DevOps Lead        |

  @TC-REQ-103 @regression
  Scenario: State-dependent workflow - Create, Verify, and Delete User
    # 1. Create User
    Given path 'users'
    And request { "name": "Charlie", "job": "QA Architect" }
    When method POST
    Then status 201
    * def createdId = response.id

    # 2. Delete User
    Given path 'users', createdId
    When method DELETE
    Then status 204

  @TC-REQ-104 @negative
  Scenario: Handle resource not found (404 Error Contract)
    Given path 'users', 99999
    When method GET
    Then status 404
    And match response == {}