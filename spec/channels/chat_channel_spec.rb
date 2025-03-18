require 'rails_helper'

describe ChatChannel, type: :channel do
  let!(:user_one) { create(:user) }
  let!(:user_two) { create(:user) }
  let!(:conversation) { create(:conversation, users: [ user_one, user_two ]) }
  let!(:message) { create(:message, conversation: conversation, sender: user_one, receiver: user_two, content: "Hello!") }

  it 'successfully subscribes to the chat channel' do
    subscribe(conversation_id: conversation.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(conversation)
  end

  it 'successfully receives and broadcasts a message' do
    subscribe(conversation_id: conversation.id)

    data = {
      'conversation_id' => conversation.id,
      'message_id' => message.id,
      'user_id' => user_one.id
    }

    expect {
      perform(:receive, data)
    }.to have_broadcasted_to(conversation).with(
      message: hash_including(
        'id' => message.id,
        'content' => message.content,
        'sender' => user_one.username,
        'receiver' => user_two.username
      )
    )
  end

  it 'does not broadcast a message if user is not in conversation' do
    subscribe(conversation_id: conversation.id)
    user_three = create(:user)

    data = {
      'conversation_id' => conversation.id,
      'message_id' => message.id,
      'user_id' => user_three.id
    }

    expect {
      perform(:receive, data)
    }.not_to have_broadcasted_to(conversation)
  end

  it 'logs an error if conversation is not found' do
    allow(Rails.logger).to receive(:error)

    subscribe(conversation_id: conversation.id)

    data = {
      'conversation_id' => 999, # ID inexistente
      'message_id' => message.id,
      'user_id' => user_one.id
    }

    perform(:receive, data) rescue nil

    expect(Rails.logger).to have_received(:error).with(/ChatChannel: Record not found/)
  end

  it 'logs an error if message is not found' do
    allow(Rails.logger).to receive(:error)

    subscribe(conversation_id: conversation.id)

    data = {
      'conversation_id' => conversation.id,
      'message_id' => 999, # ID inexistente
      'user_id' => user_one.id
    }

    perform(:receive, data) rescue nil

    expect(Rails.logger).to have_received(:error).with(/ChatChannel: Record not found/)
  end
end
