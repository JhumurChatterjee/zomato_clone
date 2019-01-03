module ActiveStorage::Blob::Representable
  extend ActiveSupport::Concern
  def variant(transformations)
    if variable?
      ActiveStorage::Variant.new(self, transformations)
    else
      raise ActiveStorage::InvariableError
    end
  end
  def variable?
    ActiveStorage.variable_content_types.include?(content_type)
  end
  def preview(transformations)
    if previewable?
      ActiveStorage::Preview.new(self, transformations)
    else
      raise ActiveStorage::UnpreviewableError
    end
  end

  # Returns true if any registered previewer accepts the blob. By default, this will return true for videos and PDF documents.
  def previewable?
    ActiveStorage.previewers.any? { |klass| klass.accept?(self) }
  end

  def representation(transformations)
    case
    when previewable?
      preview transformations
    when variable?
      variant transformations
    else
      raise ActiveStorage::UnrepresentableError
    end
  end

  # Returns true if the blob is variable or previewable.
  def representable?
    variable? || previewable?
  end
end

