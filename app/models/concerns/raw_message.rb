module RawMessage
  extend ActiveSupport::Concern

  included do
    has_attached_file :raw_message
    do_not_validate_attachment_file_type :raw_message
  end
end
