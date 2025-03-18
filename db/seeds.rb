puts 'Creating users...'

users = [
  { email: 'alice@example.com', password: '123456', password_confirmation: '123456', username: 'alice' },
  { email: 'bob@example.com', password: '123456', password_confirmation: '123456', username: 'bob' },
  { email: 'charlie@example.com', password: '123456', password_confirmation: '123456', username: 'charlie' }
].map { |user| User.create!(user) }

puts 'Creating conversations...'

# Create conversations and associate users directly
conversations = [
  Conversation.create!(users: [ users[0], users[1] ]), # Alice and Bob
  Conversation.create!(users: [ users[0], users[2] ]), # Alice and Charlie
  Conversation.create!(users: [ users[1], users[2] ])  # Bob and Charlie
]

puts 'Creating messages...'

[
  # Conversation between Alice and Bob
  { conversation: conversations[0], sender: users[0], receiver: users[1], content: 'Oi Bob! Pronto para o projeto?' },
  { conversation: conversations[0], sender: users[1], receiver: users[0], content: 'Oi Alice! Sim, vamos lá!' },
  { conversation: conversations[0], sender: users[0], receiver: users[1], content: 'Como foi a reunião de ontem?' },
  { conversation: conversations[0], sender: users[1], receiver: users[0], content: 'Foi boa, conseguimos definir os próximos passos.' },
  { conversation: conversations[0], sender: users[0], receiver: users[1], content: 'Você já começou a preparar a apresentação?' },
  { conversation: conversations[0], sender: users[1], receiver: users[0], content: 'Ainda não, vou começar hoje à tarde.' },

  # Conversation between Alice and Charlie
  { conversation: conversations[1], sender: users[0], receiver: users[2], content: 'Charlie, viu o email do cliente?' },
  { conversation: conversations[1], sender: users[2], receiver: users[0], content: 'Sim, Alice. Vamos alinhar?' },
  { conversation: conversations[1], sender: users[0], receiver: users[2], content: 'Podemos falar sobre o relatório?' },
  { conversation: conversations[1], sender: users[2], receiver: users[0], content: 'Claro, qual parte precisa de mais detalhes?' },
  { conversation: conversations[1], sender: users[0], receiver: users[2], content: 'Você já terminou a análise dos dados?' },
  { conversation: conversations[1], sender: users[2], receiver: users[0], content: 'Ainda estou finalizando, devo ter tudo pronto até amanhã.' },

  # Conversation between Bob and Charlie
  { conversation: conversations[2], sender: users[1], receiver: users[2], content: 'Charlie, vai no happy hour?' },
  { conversation: conversations[2], sender: users[2], receiver: users[1], content: 'Vou sim, Bob! Até lá.' },
  { conversation: conversations[2], sender: users[1], receiver: users[2], content: 'Viu o novo projeto que chegou?' },
  { conversation: conversations[2], sender: users[2], receiver: users[1], content: 'Sim, parece interessante. Vamos discutir sobre ele depois.' },
  { conversation: conversations[2], sender: users[1], receiver: users[2], content: 'Você já começou a trabalhar nele?' },
  { conversation: conversations[2], sender: users[2], receiver: users[1], content: 'Ainda não, estou finalizando outras tarefas primeiro.' }

].each { |message| Message.create!(message) }

puts 'Seeds created successfully! '
