require "rails_helper"

RSpec.describe "Article pagination", type: :feature do
  before do
    FactoryBot.reload
    # Create 25 articles so there's a second page
    create_list(:article, 25)
  end

  it "shows only 20 articles on the first page" do
    visit articles_path

    expect(page).to have_selector(".article", count: 20)

    expect(page).to have_selector("nav.pagy")
    expect(page).to have_link("2")
  end

  it "shows the remaining articles on the second page" do
    visit articles_path
    click_link "2"

    # Should be 5 articles on page 2
    expect(page).to have_selector(".article", count: 5)

    # Confirm one of the articles from earlier in the sequence
    expect(page).to have_content("Sample Article-1")
    expect(page).to have_no_content("Sample Article-21")
  end
end
