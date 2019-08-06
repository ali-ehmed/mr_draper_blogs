# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(person)
    person ||= Person.new
    can :manage, Blog, author_id: person.id
  end
end
