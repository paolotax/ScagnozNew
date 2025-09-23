# NOTE: only doing this in development as some production environments (Heroku)
# NOTE: are sensitive to local FS writes, and besides -- it's just not proper
# NOTE: to have a dev-mode tool do its thing in production.
if Rails.env.development?
  namespace :annotate do
    desc "Add schema information (as comments) to model and fixture files"
    task :models do
      system "bundle exec annotaterb models"
    end

    desc "Remove schema information from model files"
    task :remove_models do
      system "bundle exec annotaterb models --delete"
    end

    desc "Add schema information (as comments) to routes file"
    task :routes do
      system "bundle exec annotaterb routes"
    end

    desc "Remove schema information from routes file"
    task :remove_routes do
      system "bundle exec annotaterb routes --delete"
    end

    desc "Add schema information (as comments) to all files"
    task :all do
      system "bundle exec annotaterb models"
      system "bundle exec annotaterb routes"
    end

    desc "Remove schema information from all files"
    task :remove_all do
      system "bundle exec annotaterb models --delete"
      system "bundle exec annotaterb routes --delete"
    end
  end

  # Legacy task name for backward compatibility
  task annotate_models: "annotate:models"
end
