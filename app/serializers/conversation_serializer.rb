class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :name

  def name
    object.display_name_for(instance_options[:current_user])
  end
end
