Paperclip::Attachment.default_options.update({
  path: ":rails_root/data/:tenant/:class/:attachment/:id_partition/:style.:extension",
});

Paperclip.interpolates :tenant do |attachment, style|
  Apartment::Tenant.current
end

