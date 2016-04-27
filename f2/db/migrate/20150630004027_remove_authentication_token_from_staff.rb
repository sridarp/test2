class RemoveAuthenticationTokenFromStaff < ActiveRecord::Migration
  def change
    remove_column :staff, :authentication_token, :string
  end
end
