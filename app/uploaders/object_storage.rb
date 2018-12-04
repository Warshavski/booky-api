# frozen_string_literal: true

#
# This concern should add object storage support to the BookyUploader class
#
module ObjectStorage
  UnknownStoreError = Class.new(StandardError)

  TMP_UPLOAD_PATH = 'tmp/uploads'

  module Store
    LOCAL = 1
  end

  module Extension
    #
    # this extension is the glue between the ObjectStorage::Concern and RecordsUploads::Concern
    #
    module RecordsUploads
      extend ActiveSupport::Concern

      def self.prepended(base)
        raise "#{base} must include ObjectStorage::Concern to use extensions." unless base < Concern

        base.include(::RecordsUploads::Concern)
      end

      def retrieve_from_store!(identifier)
        paths = upload_paths(identifier)

        unless current_upload_satisfies?(paths, model)
          #
          # the upload we already have isn't right, find the correct one
          #
          self.upload = model&.retrieve_upload(identifier, paths)
        end

        super
      end

      def build_upload
        super.tap { |upload| upload.store = object_store }
      end

      def upload=(upload)
        return if upload.nil?

        self.object_store = upload.store
        super
      end

      private

      def current_upload_satisfies?(paths, model)
        return false unless upload && model

        paths.include?(upload.path) &&
          upload.model_id == model.id &&
          upload.model_type == model.class.base_class.sti_name
      end
    end
  end

  module Concern
    extend ActiveSupport::Concern

    included do |base|
      base.include(ObjectStorage)
    end

    class_methods do
      def object_store_options
        options.object_store
      end

      def object_store_enabled?
        object_store_options.enabled
      end

      def direct_upload_enabled?
        object_store_options&.direct_upload
      end

      def background_upload_enabled?
        object_store_options.background_upload
      end

      def proxy_download_enabled?
        object_store_options.proxy_download
      end

      def direct_download_enabled?
        !proxy_download_enabled?
      end

      def object_store_credentials
        object_store_options.connection.to_hash.deep_symbolize_keys
      end

      def remote_store_path
        object_store_options.remote_directory
      end

      def serialization_column(model_class, mount_point)
        model_class.uploader_options.dig(mount_point, :mount_on) || mount_point
      end
    end

    # allow to configure and overwrite the filename
    def filename
      @filename || super || file&.filename
    end

    def filename=(filename)
      @filename = filename
    end

    def file_storage?
      storage.is_a?(CarrierWave::Storage::File)
    end

    def file_cache_storage?
      cache_storage.is_a?(CarrierWave::Storage::File)
    end

    def object_store
      # We use Store::LOCAL as null value indicates the local storage
      @object_store ||= model.try(store_serialization_column) || Store::LOCAL
    end

    def object_store=(value)
      @object_store = value || Store::LOCAL
      @storage = storage_for(object_store)
    end

    # Return true if the current file is part or the model (i.e. is mounted in the model)
    #
    def persist_object_store?
      model.respond_to?(:"#{store_serialization_column}=")
    end

    # Save the current @object_store to the model <mounted_as>_store column
    def persist_object_store!
      return unless persist_object_store?

      updated = model.update_column(store_serialization_column, object_store)
      raise 'Failed to update object store' unless updated
    end

    def exists?
      file.present?
    end

    def store_dir(store = nil)
      store_dirs[store || object_store]
    end

    def store_dirs
      { Store::LOCAL => File.join(base_dir, dynamic_segment) }
    end

    # Returns all the possible paths for an upload.
    # the `upload.path` is a lookup parameter, and it may change
    # depending on the `store` param.
    def upload_paths(identifier)
      store_dirs.map { |_store, path| File.join(path, identifier) }
    end

    def cache!(new_file = sanitized_file)
      # We intercept ::UploadedFile which might be stored on remote storage
      # We use that for "accelerated" uploads, where we store result on remote storage
      if new_file.is_a?(::UploadedFile) && new_file.remote_id
        return cache_remote_file!(new_file.remote_id, new_file.original_filename)
      end

      super
    end

    def store!(new_file = nil)
      super
    end

    private

    # this is a hack around CarrierWave. The #migrate method needs to be
    # able to force the current file to the migrated file upon success.
    def file=(file)
      @file = file
    end

    def serialization_column
      self.class.serialization_column(model.class, mounted_as)
    end

    # Returns the column where the 'store' is saved
    #   defaults to 'store'
    def store_serialization_column
      [serialization_column, 'store'].compact.join('_').to_sym
    end

    def storage
      @storage ||= storage_for(object_store)
    end

    def storage_for(store)
      case store
      when Store::LOCAL
        CarrierWave::Storage::File.new(self)
      else
        raise UnknownStoreError
      end
    end
  end

  def unsafe_use_file
    return yield path if file_storage?

    begin
      cache_stored_file!
      yield cache_path
    ensure
      FileUtils.rm_f(cache_path)
      cache_storage.delete_dir!(cache_path(nil))
    end
  end
end
