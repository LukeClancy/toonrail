FactoryBot.define do
    factory :user, class: User do
        usrid = User.order(id: :desc).first.id + 1
        id {usrid}
        email { "test#{usrid}@user.com" }
        password { "password" }
        # Add additional fields as required via your User model
    end
    
    # Not used in this tutorial, but left to show an example of different user types
    factory :admin, class: User do
        usrid = User.order(id: :desc).first.id + 1
        id { usrid } 
        email { "admin#{usrid}@admin.com" }
        password { "password" }
        role { 'admin' }
    end
end