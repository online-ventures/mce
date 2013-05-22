class AddAttachmentPhotoToPhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.attachment :image
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
