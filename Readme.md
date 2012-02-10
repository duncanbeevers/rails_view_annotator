# Rails View Annotator

## Purpose

The Rails View Annotator simply wraps the rendering of Rails partials with html comments indicating the disk location of the rendered partial.

## Usage

Simply add the gem to you Gemfile's development block.

````ruby
group :development
  gem 'rails_view_annotator'
end
````

Now rendered content will have instructive comments.

````html
<!-- begin: app/views/user/_bio.html.haml -->
<div class='bio'>Ed's Bio</div>
<!-- end: app/views/user/_bio.html.haml -->
````

## License

WTFPL
