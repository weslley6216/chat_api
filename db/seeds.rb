puts 'Criando usuários...'
user_a = User.create!(username: 'Alice', email: 'alice@example.com')
user_b = User.create!(username: 'Bob', email: 'bob@example.com')
user_c = User.create!(username: 'Charlie', email: 'charlie@example.com')

puts 'Criando conversas...'
conversation1 = Conversation.create!(user_a: user_a, user_b: user_b)
conversation2 = Conversation.create!(user_a: user_a, user_b: user_c)

puts 'Criando mensagens...'
Message.create!(conversation: conversation1, sender: user_a, receiver: user_b, content: 'Oi, Bob!')
Message.create!(conversation: conversation1, sender: user_b, receiver: user_a, content: 'Oi, Alice!')
Message.create!(conversation: conversation2, sender: user_a, receiver: user_c, content: 'E aí, Charlie?')
Message.create!(conversation: conversation2, sender: user_c, receiver: user_a, content: 'Oi, Alice!')

puts 'Seeds criados com sucesso! 🚀'
