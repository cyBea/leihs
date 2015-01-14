
Feature: Contract

  Background:
    Given I am Pius

  @javascript @browser @personas
  Scenario: What I want to see on the contract
    Given I open a contract during hand over
    Then I want to see the following areas:
    | Area                 |
    | Date                 |
    | Title                |
    | Borrower             |
    | Lender               |
    | List 1               |
    | List 2               |
    | List of purposes     |
    | Additional notes     |
    | Terms                |
    | Borrower's signature |
    | Page number          |
    | Barcode              |
    | Contract number      |
    And the models are sorted alphabetically within their group

  @javascript @browser @personas
  Scenario: Mentioning terms and conditions
    Given I open a contract during hand over
    Then I see a note mentioning the terms and conditions

  @javascript @browser @personas
  Scenario: User information on the contract
    Given I open a contract during hand over
    Then the following user information is included on the contract:
    | Area          |
    | First name    |
    | Last name     |
    | Street        |
    | Street number |
    | Country code  |
    | Postal code   |
    | City          |

  @javascript @browser @personas
  Scenario: List of returned items
    Given I open a contract during hand over
    When there are returned items
    Then I see list 1 with the title "Returned Items"
    And this list contains borrowed and returned items

  @javascript @browser @personas
  Scenario: Purposes
    Given I open a contract during hand over
    Then I see a comma-separated list of purposes
     And each unique purpose is listed only once

  @javascript @browser @personas
  Scenario: Date
    Given I open a contract during hand over
    Then I see today's date in the top right corner

  @javascript @browser @personas
  Scenario: Title
    Given I open a contract during hand over
    Then I see a title in the format "Contract No. #"

  @javascript @browser @personas
  Scenario: Position of the barcode
    Given I open a contract during hand over
    Then I see the barcode in the top left

  @javascript @browser @personas
  Scenario: Position of the borrower
    Given I open a contract during hand over
    Then I see the borrower in the top left corner

  @javascript @browser @personas
  Scenario: Content of lists 1 and 2
    Given I open a contract during hand over that contains software
    Then list 1 and list 2 contain the following columns:
    | Column name   |
    | Quantity        |
    | Inventory code  |
    | Model name    |
    | End date      |
    | Return date |
    When the contract contains a software license
    Then I additionally see the following information
    | Serial number  |

  @javascript @browser @personas
  Scenario: Rücknehmende Person
    Given I open a take back
    And I select all lines of an open contract
    And I click take back
    And I click take back inside the dialog
    Then sieht man bei den betroffenen Linien die rücknehmende Person im Format "V. Nachname"

  @javascript @browser @personas
  Scenario: Verleiher
    Given I open a contract during hand over
    Then sehe ich den Verleiher neben dem Ausleihenden

  @javascript @browser @personas
  Scenario: Liste der ausgeliehenen Gegenstände
    Given I open a contract during hand over
    When es Gegenstände gibt, die noch nicht zurückgegeben wurden
    Then sehe ich die Liste 2 mit dem Titel "Ausgeliehene Gegenstände"
    And diese Liste enthält Gegenstände, die ausgeliehen und noch nicht zurückgegeben wurden

  @javascript @browser @personas
  Scenario: Adresse des Verleihers aufführen
    Given I open a contract during hand over
    Then wird unter 'Verleiher/in' der Gerätepark aufgeführt
    When in den globalen Einstellungen die Adresse der Instanz konfiguriert ist
    Then wird unter dem Verleiher diese Adresse angezeigt

  @personas
  Scenario: Adresse des Kunden ohne abschliessenden ", " anzeigen
    Given es gibt einen Kunden mit Vertrag wessen Addresse mit ", " endet
    When ich einen Vertrag dieses Kunden öffne
    Then wird seine Adresse ohne den abschliessenden ", " angezeigt
