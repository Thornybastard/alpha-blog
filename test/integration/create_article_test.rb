require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "Bob", email: "bob@example.com", password: "password", admin: false)
  end

  test "get new article form and post article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: {title: "ABCDEF", description: "This is a test article" } }
      end
    follow_redirect!
  end

  test "article is invalid" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count', 1 do
      post articles_path, params: {article: {title: " ", description: " ", category_ids: [] } }
    end
    assert_template 'articles/new'
    assert_select "h2.panel-title"
    assert_match "stopped this article from being saved", response.body
    assert_match "Title is too short", response.body
    assert_match "Description is too short", response.body
  end
end
