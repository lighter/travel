User.create!(name: "test_seed",
             email: "test_seed@test.com",
             password: "abcd1234",
             password_confirmation: "abcd1234")

30.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@test.com"
    password = "password"

    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
end
