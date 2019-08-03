module SignUpFormHelper
  def sign_in_form_tabs(order: %i[sign_in sign_up], active_link: nil, wrapper_class: '')
    links = {
      sign_in: -> (active_class) {
        link_to('Login', "#sign_in_tab", class: "nav-link #{active_class}", data: { toggle: 'tab' }, role: 'tab', 'aria-controls': "sign_up_tab", 'aria-selected': true)
      },
      sign_up: -> (active_class) {
        link_to('Register', "#sign_up_tab", class: "nav-link #{active_class}", data: { toggle: 'tab' }, role: 'tab', 'aria-controls': "sign_up_tab", 'aria-selected': true)
      }
    }

    tag.ul(class: "sign-in-modal__nav nav nav-tabs #{wrapper_class}", role: 'tablist') do
      capture do
        order.each do |link_name|
          active = link_name == (active_link || order.first) ? 'active' : ''
          concat(tag.li(class: 'nav-item') { links[link_name].call(active) })
        end
      end
    end
  end

  def sign_in_form_tab_pane(tab_name: :sign_in, active: false, identifier: '')
    tag.div(class: "tab-pane fade #{'show active' if active}", id: "#{tab_name}_tab#{identifier}", role: 'tabpanel', 'aria-labelledby': 'sign_up-tab') do
      yield
    end
  end

  def sign_in_modal_form_social_links(wrapper_class: nil, link_class: nil)
    tag.div(class: wrapper_class) do
      capture do
        concat(
          link_to(person_facebook_omniauth_authorize_path, class: "btn btn-fb btn-block #{link_class}") do
            capture do
              concat(content_tag(:i, nil, class: 'fab fa-facebook-f mr-2'))
              concat(content_tag(:span, 'LOGIN WITH FACEBOOK'))
            end
          end
        )
        concat(
          link_to(person_google_oauth2_omniauth_authorize_path, class: "btn btn-google btn-block #{link_class}") do
            capture do
              concat(content_tag(:i, nil, class: 'fab fa-google mr-2'))
              concat(content_tag(:span, 'LOGIN WITH GOOGLE'))
            end
          end
        )
      end
    end
  end
end