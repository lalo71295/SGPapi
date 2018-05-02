class RolsPermission < ApplicationRecord
  belongs_to :rol
  belongs_to :permission
end
