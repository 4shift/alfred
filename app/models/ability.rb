class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, Ticket
    can :create, Attachment
    can :update, Reply, user_id: user.id

    if user.agent?
      if user.labelings.count > 0
        limited_agent user
      else
        agent user
      end
    else
      customer user
    end
  end

  protected

  def customer(user)
    can [:create, :read], Reply, ticket: { user_id: user.id }
    can :update, User, id: user.id
    can :read, Ticket, Ticket.viewable_by(user) do |ticket|
      ticket.user == user || (ticket.label_ids & user.label_ids).size > 0
    end
    can [:create, :read], Reply do |reply|
      (reply.ticket.label_ids & user.label_ids).size > 0
    end
  end

  def limited_agent(user)
    can [:create, :read], Reply, ticket: { user_id: user.id }
    can :update, User, id: user.id
    can [:read, :update], Ticket, Ticket.viewable_by(user) do |ticket|
      ticket.user == user || (ticket.label_ids & user.label_ids).size > 0
    end
    can [:create, :read], Reply do |reply|
      (reply.ticket.label_ids & user.label_ids).size > 0
    end
  end

  def agent(user)
    can [:create, :read], Reply, Reply.unlocked_for(user) do |reply|
      !reply.ticket.locked?(user)
    end

    can :manage, User

    can [:read], Ticket
    can [:update, :destroy], Ticket, Ticket.unlocked_for(user) do |ticket|
      !ticket.locked?(user)
    end

    can [:create, :destroy], Labeling, labelable_type: 'Ticket',
        labelable: { locked_by_id: [user.id, nil] }

    can [:create, :destroy], Labeling, -> { where(labelable_type: 'User')
                                                .where.not(labelable_id: user.id) } do |labeling|
      labeling.labelable != user
    end
    can :manage, Rule
    can :manage, EmailAddress
    can :manage, Label

  end
end
