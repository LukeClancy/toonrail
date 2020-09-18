FactoryBot.define do
    factory :user, class: User do
        id {get_a_user_id() + 1}
        email { "test#{get_a_user_id() + 1}@user.com" }
        password { "password" }
        # Add additional fields as required via your User model
    end
    
    # Not used in this tutorial, but left to show an example of different user types
    factory :admin, class: User do
        id {get_a_user_id() + 1} 
        email { "admin#{get_a_user_id() + 1}@admin.com" }
        password { "password" }
        role { 'admin' }
    end
end