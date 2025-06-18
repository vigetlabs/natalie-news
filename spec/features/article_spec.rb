require 'rails_helper'

RSpec.describe 'Articles CRUD', type: :feature do
  let!(:article) { create(:article) } # default article by factory bot

  it 'allows the user to create a new article' do
    visit new_article_path

    fill_in 'Title', with: 'Viget Website'
    fill_in 'Author', with: 'Danny'
    fill_in 'Url', with: 'https://www.viget.com/'
    click_button 'Create Article'

    expect(page).to have_content('Article was successfully created')
    expect(page).to have_content('Viget Website')
  end

  it 'allows the user to view an article' do
    visit article_path(article)

    expect(page).to have_content('Sample Article')
    expect(page).to have_content('Jane')
  end

  it 'allows the user to edit an article' do
    visit edit_article_path(article)

    fill_in 'Title', with: 'Updated Title'
    click_button 'Update Article'

    expect(page).to have_content('Article was successfully updated')
    expect(page).to have_content('Updated Title')
  end

  it 'allows the user to delete an article' do
    visit article_path(article)

    click_button 'Destroy this article'

    expect(page).to have_content('Article was successfully destroyed')
    expect(page).not_to have_content('Sample Article')
  end
end

RSpec.describe 'Article sorting', type: :feature do
  let!(:older_article) { create(:article, :published_yesterday, title: 'Old News') }

  it 'shows newly created article at the top of the list' do
    visit new_article_path

    fill_in 'Title', with: 'Fresh Post'
    fill_in 'Author', with: 'Bob'
    fill_in 'Url', with: 'https://fresh.com'
    click_button 'Create Article'

    visit articles_path

    # Find all text nodes under the articles div
    article_texts = within('#articles') do
      all('*', minimum: 1).map(&:text).reject(&:empty?)
    end

    # Expect the first article text rendered to include the new title
    expect(article_texts.first).to include('Fresh Post')
  end
end
