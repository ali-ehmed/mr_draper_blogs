class PersonDecorator < ApplicationDecorator
  delegate_all

  def gravatar_image_tag(gravtar_options = {}, options = {})
    h.image_tag(object.gravatar_url(rating: 'R', secure: true, size: 150, **gravtar_options), class: 'img-fluid rounded-circle', **options)
  end
end