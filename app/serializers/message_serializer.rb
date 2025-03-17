class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :receiver, :sender

  def receiver = object.receiver.username
  def sender = object.sender.username
end
