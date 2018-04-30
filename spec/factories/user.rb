FactoryBot.define do
  factory :user do
    first_name 'Factory'
    last_name 'Girl'
    email 'abc@abc.com'
    password 'password'
  end

  factory :client, class: User do
    first_name 'lient'
    last_name 'lient'
    email 'client@client.com'
    password 'password'
  end
end
