json.results @blogs do |blog|
  json.id blog
  json.title blog.title
  json.preview_image blog.preview_image.attached? ? rails_blob_path(blog.preview_image) : nil
  json.published_at l(blog.published_at.to_date, format: :default)
  json.view blog_path(blog.id)
  json.author_name blog.author.name
end