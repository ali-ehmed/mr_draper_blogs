# Rake task to load the sample data
namespace :sample_data do
  desc 'Loading Sample postgres database'
  task :load_db do
    role = ENV['POSTGRES_ROLE'] || 'postgres'
    `pg_restore -c -C -F c -v -U #{role} ./db/sample.psql`
  end

  task :load_db_to_docker do
    `cat ./db/sample | docker exec -i mrdraper_postgres_1 psql -U postgres -d mr_draper_development`
  end
end