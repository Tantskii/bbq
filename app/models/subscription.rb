class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :event, presence: true

  validates :user_name, presence: true, unless: 'user.present?'
  validates :user_email, presence: true, format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
                                         unless: 'user.present?'

  validates :user, uniqueness: {scope: :event_id}, if: 'user.present?'
  validates :user_email, uniqueness: {scope: :event_id}, unless: 'user.present?'

  validate :user_email_shouldnot_exist_in_db, unless: 'user.present?', on: :create

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  def user_email_shouldnot_exist_in_db
    errors.add(:user_email, 'should not exist in db') if User.find_by_email(self.user_email)
  end
end
