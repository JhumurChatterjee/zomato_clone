# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create!(username: "admin", email: "admin@gmail.com", password: "123456", password_confirmation: "123456", admin: true)
location=Location.create!(longitude: 0.884339039e2, latitude: 0.225749254e2, city: "kolkata",address: nil, street: "college more", country: "India", state: "West Bengal", full_address: "college more,kolkata,west bengal,india", user_id: 1)
restaurant1 = Restaurant.create!(name: "Rang De Basanti Dhaba", location_id: 1, category: "Multi-Cuisine", situated_at: "college more,kolkata,west bengal,india", food_menu: {"mutton_biriyani"=>"210", "chicken_biriyani"=>"160", "Paneer_Tikka"=>"190"}, food_item: ["mutton biriyani","210","chicken_biriyani","160","Paneer_Tikka","190"])
restaurant2 = Restaurant.create!(name: "Barbeque Nation", location_id: 1, category: "Barbeque", situated_at: "college more,kolkata,west bengal,india", food_menu: {"chicken_biriyani"=>"160"}, food_item: ["chicken biriyani","160"])
restaurant3 = Restaurant.create!(name: "CCD", location_id: 1, category: "Cafe", situated_at: "college more,kolkata,west bengal,india", food_menu: {"Espresso"=>"110"}, food_item: ["Espresso","110"])
review1 = Review.create!(rating: 4.0, comment: "Wow", user_id: 1, restaurant_id: 1, approved: true)
review2 = Review.create!(rating: 4.0, comment: "Great", user_id: 1, restaurant_id: 2, approved: true)
review3 = Review.create!(rating: 5.0, comment: "Delicious", user_id: 1, restaurant_id: 3, approved: true)
table1 = Table.create!(four_seater: 10, six_seater: 5, two_seater: 5, restaurant_id: 1)
table2 = Table.create!(four_seater: 11, six_seater: 6, two_seater: 6, restaurant_id: 2)
table3 = Table.create!(four_seater: 12, six_seater: 7, two_seater: 7, restaurant_id: 3)
