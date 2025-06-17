require 'rails_helper'

RSpec.describe 'Articles CRUD', type: :feature do
  let!(:article) { Article.create(title: 'Sample Article', author: 'Jane', url: 'https://www.viget.com/') }

  it 'allows the user to create a new article' do
    visit new_article_path

    fill_in 'Title', with: 'Viget Website'
    fill_in 'Author', with: 'Jane'
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
