# frozen_string_literal: true

class AddUserToContents < ActiveRecord::Migration[6.1]
  def change
    add_reference :contents, :user, null: false, foreign_key: true
  end
end
