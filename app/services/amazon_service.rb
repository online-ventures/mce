# Responsible for performing services with an s3 bucket
class AmazonService
  class << self
    def upload_photo(photo, file)
      object = bucket.object photo.file_path
      object.upload_file(file, image_metadata)
    end

    def delete_photo(photo)
      key = photo.file_path
      object = bucket.object(key)
      object.delete
    end

    # Default image metadata: public visibility, jpg, cache for a year
    def image_metadata
      {
        acl: 'public-read',
        content_type: 'image/jpg',
        content_disposition: 'inline',
        cache_control: 'public, max-age=31536000'
      }
    end

    def s3
      @s3 ||= Aws::S3::Resource.new
    end

    def bucket
      @bucket ||= s3.bucket 'mce'
    end
  end
end
