# get a collection of all the Models in your Rails app
#http://stackoverflow.com/questions/516579/is-there-a-way-to-get-a-collection-of-all-the-models-in-your-rails-app
#no.1
#Rails.application.eager_load!
#ActiveRecord::Base.descendants

Dir.glob(RAILS_ROOT + '/app/models/*.rb').each { |file| require file }
models = ActiveRecord::Base.subclasses.map(&:name)

models.each do |model|
  (instance_eval model).stored_attributes
end
