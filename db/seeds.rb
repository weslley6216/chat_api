puts 'Creating users...'

users = [
  { email: 'alice@example.com', password: '123456', password_confirmation: '123456',  username: 'alice' },
  { email: 'bob@example.com', password: '123456', password_confirmation: '123456',  username: 'bob' },
  { email: 'charlie@example.com', password: '123456', password_confirmation: '123456',  username: 'charlie' },
  { email: 'diana@example.com', password: '123456', password_confirmation: '123456',  username: 'diana' },
  { email: 'eric@example.com', password: '123456', password_confirmation: '123456',  username: 'eric' },
  { email: 'fiona@example.com', password: '123456', password_confirmation: '123456',  username: 'fiona' }
].map { |user| User.create!(user) }

puts 'Creating conversations...'

conversations = [
  { user_a: users[0], user_b: users[1] },
  { user_a: users[0], user_b: users[2] },
  { user_a: users[1], user_b: users[3] },
  { user_a: users[2], user_b: users[4] },
  { user_a: users[3], user_b: users[5] },
  { user_a: users[4], user_b: users[0] }
].map { |conversation| Conversation.create!(conversation) }

puts 'Creating messages...'

[
  # Conversation between Alice and Bob
  { conversation: conversations[0], sender: users[0], receiver: users[1], content: 'Oi Bob! Pronto para o projeto de amanhã?' },
  { conversation: conversations[0], sender: users[1], receiver: users[0], content: 'Oi Alice! Estou sim, vamos arrasar!' },
  { conversation: conversations[0], sender: users[0], receiver: users[1], content: 'Alguma ideia nova para a apresentação?' },
  { conversation: conversations[0], sender: users[1], receiver: users[0], content: 'Pensei em adicionar gráficos interativos, o que você acha?' },

  # Conversation between Alice and Charlie
  { conversation: conversations[1], sender: users[0], receiver: users[2], content: 'Charlie, podemos falar sobre aquele cliente?' },
  { conversation: conversations[1], sender: users[2], receiver: users[0], content: 'Claro, Alice. Você viu o último e-mail dele?' },
  { conversation: conversations[1], sender: users[0], receiver: users[2], content: 'Sim, está meio confuso. Melhor alinharmos juntos.' },
  { conversation: conversations[1], sender: users[2], receiver: users[0], content: 'Concordo! Vamos resolver isso rapidamente.' },

  # Conversation between Bob and Diana
  { conversation: conversations[2], sender: users[1], receiver: users[3], content: 'Diana, você vai no happy hour hoje?' },
  { conversation: conversations[2], sender: users[3], receiver: users[1], content: 'Vou sim, Bob! Estou precisando de uma pausa.' },
  { conversation: conversations[2], sender: users[1], receiver: users[3], content: 'Ótimo! Já avisei ao Eric, ele vai também.' },
  { conversation: conversations[2], sender: users[3], receiver: users[1], content: 'Perfeito! Vai ser divertido.' },

  # Conversation between Charlie and Eric
  { conversation: conversations[3], sender: users[2], receiver: users[4], content: 'Eric, você terminou aquele relatório?' },
  { conversation: conversations[3], sender: users[4], receiver: users[2], content: 'Ainda estou ajustando os últimos detalhes, Charlie.' },
  { conversation: conversations[3], sender: users[2], receiver: users[4], content: 'Certo. Preciso dele até amanhã de manhã, tudo bem?' },
  { conversation: conversations[3], sender: users[4], receiver: users[2], content: 'Sem problema, vou trabalhar nele agora!' },

  # Conversation between Diana and Fiona
  { conversation: conversations[4], sender: users[3], receiver: users[5], content: 'Oi Fiona! Quer almoçar na terça-feira?' },
  { conversation: conversations[4], sender: users[5], receiver: users[3], content: 'Oi Diana! Claro, que tal o novo restaurante?' },
  { conversation: conversations[4], sender: users[3], receiver: users[5], content: 'Adorei a ideia! Vamos nos encontrar ao meio-dia.' },
  { conversation: conversations[4], sender: users[5], receiver: users[3], content: 'Fechado! Te vejo lá.' },

  # Conversation between Eric and Alice
  { conversation: conversations[5], sender: users[4], receiver: users[0], content: 'Alice, precisamos falar sobre o evento de marketing.' },
  { conversation: conversations[5], sender: users[0], receiver: users[4], content: 'Certo, Eric. Quer fazer uma ligação amanhã à tarde?' },
  { conversation: conversations[5], sender: users[4], receiver: users[0], content: 'Amanhã é ótimo. Vou organizar os tópicos.' },
  { conversation: conversations[5], sender: users[0], receiver: users[4], content: 'Perfeito. Vamos arrasar!' }
].each { |message| Message.create!(message) }

puts 'Seeds created successfully! 🚀'
