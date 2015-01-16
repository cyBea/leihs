# -*- encoding : utf-8 -*-

#Wenn(/^ich die Sprache auf "(.*?)" umschalte$/) do |language|
When(/^I change the language to "(.*?)"$/) do |language|
  find("a[href*='locale']", match: :first, :text => language).click
end

Then(/^the language is "(.*?)"$/) do |language|
  s = case language
        when "English"
          "en-GB"
        when "Deutsch"
          "de-CH"
  end
  expect(@current_user.reload.language.locale_name).to eq s
  find("a[href=''] strong", match: :first, :text => language)
end
