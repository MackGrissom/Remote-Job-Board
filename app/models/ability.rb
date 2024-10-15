class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Job
    can :create, Job if user.persisted?
    can :manage, Job, user_id: user.id
    can :view_applications, Job, user_id: user.id
    can :create, JobApplication
  end
end
