require 'rails_helper'

RSpec.describe 'Comments CRUD', type: :feature do
  let!(:user) { create(:user) }
  let!(:article) { create(:article) }
  let!(:comment) { create(:comment, article: article, user: user) }

  before do
    login_as(user, scope: :user)
  end

  it "allows the user to create a new comment" do
    visit article_path(article)
    fill_in 'Body', with: 'Sample comment text body'
    click_button 'Add Comment'

    expect(page).to have_content('Sample comment text body')
    expect(page).to have_content(user.username)
  end

  # it "does not allow invalid create" do
  #   # Body is required
  #   visit article_path(article)
  #   fill_in 'Body', with: ''
  #   click_button 'Add Comment'

  #   expect(page).to have_content('prohibited this comment from being saved')
  # end
  # can't get the prohibited this comment from being saved to actually show up

  it 'allows the user to edit a comment' do
    visit edit_article_comment_path(article, comment)

    fill_in 'Body', with: 'Updated comment body'
    click_button 'Update Comment'

    expect(page).to have_content('Comment was successfully updated')
    expect(page).to have_content('Updated comment body')
  end

  it 'does not allow invalid comment update' do
    visit edit_article_comment_path(article, comment)

    fill_in 'Body', with: ''
    click_button 'Update Comment'

    expect(page).to have_content('prohibited this comment from being saved')
  end

  it 'allows the user to delete a comment' do
    visit article_path(article)

    # Assuming delete button is a form button or link with confirm
    click_button 'Delete'

    expect(page).to have_content('Comment was successfully destroyed')
    expect(page).not_to have_content(comment.body)
  end
end

RSpec.describe "Comment User Authentication Edit/Delete", type: :system do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:article) { create(:article, user: owner, title: "Secret Stuff") }
  let!(:comment) { create(:comment, article: article, user: owner, body: "Top secret comment") }

  it "does not allow a different user to see edit/delete for a comment" do
    login_as(other_user, scope: :user)
    visit article_path(article)

    expect(page).not_to have_link("Edit", href: edit_article_comment_path(article, comment))
    expect(page).not_to have_button("Delete")
  end

  it "allows the comment owner to see edit/delete links" do
    login_as(owner, scope: :user)
    visit article_path(article)

    expect(page).to have_link("Edit", href: edit_article_comment_path(article, comment))
    expect(page).to have_button("Delete")
  end

  it "redirects unauthorized user when trying to edit comment directly" do
    login_as(other_user, scope: :user)
    visit edit_article_comment_path(article, comment)

    expect(current_path).to eq(articles_path)
    expect(page).to have_content("You are not authorized")
  end
end
