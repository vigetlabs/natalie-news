require 'rails_helper'

RSpec.describe 'Articles CRUD', type: :feature do
  let!(:user) { create(:user) }
  let!(:article) { create(:article, user: user) } # default article by factory bot

  before do
    login_as(user, scope: :user)
  end
  it 'allows the user to create a new article' do
    visit new_article_path

    fill_in 'Title', with: 'Viget Website'
    fill_in 'Url', with: 'https://www.viget.com/'
    click_button 'Create Article'

    expect(page).to have_content('Article was successfully created')
    expect(page).to have_content('Viget Website')
  end

  it 'allows the user to view an article' do
    visit article_path(article)

    expect(page).to have_content('Sample Article')
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

    click_link 'Delete this article'

    expect(page).to have_content('Article was successfully destroyed')
    expect(page).not_to have_content('Sample Article')
  end
end

RSpec.describe 'Article sorting', type: :feature do
  let!(:user) { create(:user) }
  let!(:older_article) { create(:article, :published_yesterday, user: user, title: 'Old News') }

  before do
    login_as(user, scope: :user)
  end
  it 'shows newly created article at the top of the list' do
    visit new_article_path

    fill_in 'Title', with: 'Fresh Post'
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

RSpec.describe "Article User Authentication for New Article", type: :feature do
  let(:user) { create(:user) }

  it "redirects unauthenticated user from new article" do
    visit new_article_path
    expect(current_path).to eq(new_user_session_path)
  end

  it "allows authenticated user to create an article" do
    login_as(user, scope: :user)

    visit new_article_path
    fill_in 'Title', with: 'My Article'
    fill_in 'Url', with: 'https://www.viget.com/'
    click_button 'Create Article'

    expect(page).to have_content('Article was successfully created')
    expect(page).to have_content('My Article')
  end
end

RSpec.describe "Article User Authentication Edit/Delete", type: :system do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:article) { create(:article, user: owner, title: "Secret Stuff") }

  it "does not allow a different user to see edit/delete" do
    login_as(other_user, scope: :user)
    visit article_path(article)

    expect(page).not_to have_link("Edit this article")
    expect(page).not_to have_link("Delete this article")
  end

  it "allows the owner to see edit/delete" do
    login_as(owner, scope: :user)
    visit article_path(article)

    expect(page).to have_link("Edit this article")
    expect(page).to have_link("Delete this article")
  end
end
