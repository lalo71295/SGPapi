# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  employee_id            :integer
#  approved               :boolean          default(FALSE), not null
#  role                   :integer
#

class User < ApplicationRecord
  has_one :employee
  has_many :users_rols
  has_many :rols, through: :users_rols
  has_many :permissions, through: :rols

def concatenar_nombre
  "#{current_user.employee.nombre} #{current_user.employee.apellido_paterno}"  
end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :employee


  def set_default_role
      self.role ||= :default
  end

  def self.create_new_user(email, password, employee, approved)

    u = User.new(:email => email, :password => password, :employee_id => employee, :approved => approved)
    u.save
    u
  end

  def active_for_authentication?
    super && approved? 
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end
end
