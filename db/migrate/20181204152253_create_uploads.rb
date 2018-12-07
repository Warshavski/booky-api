# frozen_string_literal: true

class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.integer :size,     limit: 8, null: false
      t.string  :path,     limit: 511, null: false
      t.string  :checksum, limit: 64

      t.references :model, polymorphic: true

      t.string :uploader, null: false
      t.string :mount_point
      t.string :secret
      t.integer :store

      t.datetime :created_at, null: false
    end

    add_index :uploads, :path
    add_index :uploads, :checksum
    add_index :uploads, %i[model_id model_type]
  end
end
