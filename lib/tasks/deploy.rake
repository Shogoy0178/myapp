# frozen_string_literal: true

namespace :deploy do
  desc 'Run migrations on deploy'
  task migrate: :environment do
    Rake::Task['db:migrate'].invoke
  end
end
