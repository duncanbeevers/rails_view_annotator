# Rails View Annotator

## Purpose

The Rails View Annotator wraps the rendering of Rails partials with html comments indicating the disk location of the rendered partial.

## Usage

Simply add the gem to your Gemfile's development block.

````ruby
group :development do
  gem 'rails_view_annotator'
end
````

Now rendered content will have instructive comments.

````html
<!-- begin: app/views/user/_bio.html.haml (from app/views/user/show.html.haml:4) -->
<div class='bio'>Ed's Bio</div>
<!-- end: app/views/user/_bio.html.haml (from app/views/user/show.html.haml:4) -->
````

## License

WTFPL
