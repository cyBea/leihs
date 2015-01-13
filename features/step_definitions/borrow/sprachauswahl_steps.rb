# -*- encoding : utf-8 -*-

#Angenommen(/^ich sehe die Sprachauswahl$/) do
Given(/^I see the language list$/) do
  find("footer a[href*='locale']", match: :first)
end

#Wenn(/^ich die Sprache ändere$/) do
When(/^I change the language$/) do
  find("footer a[href*='locale']", :text => 'English (US)').click
end

#Dann(/^ist die Sprache für mich geändert$/) do
Then(/^the interface language has been changed$/) do
  find("footer a[href='']", :text => 'English (US)')
end
