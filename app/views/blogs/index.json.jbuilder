json.results @blogs do |blog|
  json.id blog
  json.title blog.title
  json.author blog.author
  json.preview_image blog.preview_image.attached? ? rails_blob_path(blog.preview_image) : nil
  json.published_at blog.published_at.strftime('%d %B, %Y')
  json.view blog_path(blog.id)
end