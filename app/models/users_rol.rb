class UsersRol < ApplicationRecord
  belongs_to :user
  belongs_to :rol
end
