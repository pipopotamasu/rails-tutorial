require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path # homeへのアクセス
    assert_template 'static_pages/home' # homeのルーティングか?
    assert_select "a[href=?]", root_path, count:2 # rootへのリンクは2箇所あるためcount:2をつける
    assert_select "a[href=?]", help_path # ?はhelp_pathに置き換えられる
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
  end
end
