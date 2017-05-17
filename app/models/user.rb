class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events

  before_validation :set_name, on: :create

  validates :name, presence: true, length: {maximum: 35}

  private

  def set_name
    self.name = "Объект №#{rand(666)}" if self.name.blank?
  end
end
