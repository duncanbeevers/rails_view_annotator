require 'test_helper'

class AnnotatedViewsTest < ActionDispatch::IntegrationTest
  setup do
    get '/'
  end

  test 'partials are rendered correctly' do
    assert_select 'h1', 'This is the index template'
    assert_select 'h2', 'This is the outer partial'
    assert_select 'h3', 'This is the inner partial'
  end

  test 'partials are wrapped in comments' do
    comments = response.body.scan(/<!-- .*? -->/)
    assert_equal comments[0], '<!-- begin: app/views/foo/_outer_partial.html.erb (from app/views/foo/index.html.erb:3) -->'
    assert_equal comments[1], '<!-- begin: app/views/foo/_inner_partial.html.erb (from app/views/foo/_outer_partial.html.erb:3) -->'
    assert_equal comments[2], '<!-- end: app/views/foo/_inner_partial.html.erb (from app/views/foo/_outer_partial.html.erb:3) -->'
    assert_equal comments[3], '<!-- end: app/views/foo/_outer_partial.html.erb (from app/views/foo/index.html.erb:3) -->'
  end
end
