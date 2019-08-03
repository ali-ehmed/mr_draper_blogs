class CreateBlogs < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE blog_status AS ENUM ('draft', 'scheduled', 'published');
    SQL

    create_table :blogs do |t|
      t.string :title
      t.string :short_description
      t.text :main_content
      t.integer :author_id
      t.column :status, :blog_status, null: false
      t.datetime :published_at
      t.datetime :scheduled_at

      t.timestamps
    end

    add_index :blogs, :author_id
  end

  def down
    drop_table :blogs

    execute <<-SQL
      DROP TYPE blog_status
    SQL
  end
end
