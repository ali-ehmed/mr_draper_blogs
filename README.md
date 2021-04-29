# Mr.Draper Blogs

Simple blog application with oAuth enabled for user registration and login and integrate 2 factor
authentication for posts. Integrate 2FA using Twillio Authy app & SMS. 

### Tools
- [Ruby on Rails](https://rubyonrails.org/)
- [Stimulus JS](https://stimulusjs.org/handbook/origin)
- [Twitter Bootstrap 4](https://getbootstrap.com/)
- [HAML](http://haml.info/)
- [Twilio Authy Service](https://www.twilio.com/authy)

### Docker

#### Pre-requisites:

- Docker (Latest Version)
- Docker Compose (Latest Version)

#### Steps:

**Docker on Linux/Mac:**

- [Linux](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [Mac](https://docs.docker.com/docker-for-mac/install/)

**Setup Application:**

1. Run `docker-compose up --build`
2. Run `docker-compose run app yarn install --check-files` to load node_nodules in docker container
3. Open a new Tab and run `docker-compose run app rails db:create db:migrate`
4. Run `rails sample_data:load_db_to_docker`
5. Paste the `master.key` in config directory. You have to Obtain it from the Code Owner
6. Visit `localhost:3000` to your browser
7. There you go 🎉

### Setup Manually

#### Pre-requisites:
- Ruby 2.5.3
- Rails 5.2.3
- Postgres (Latest Version)

#### Steps:

**Ruby on Rails Installation on Linux/Mac:**

- Visit [Go Rails](http://gorails.com)
- Under Guides->Installation, follow all the steps to install Ruby on Rails

App uses `sidekiq` as background worker, which requires

**Redis Installation:**

- Linux `sudo apt-get install redis-server`
- Mac `brew install redis`

**Setup Application:**

Once Rails/Ruby installed, app can be configured by following below steps:

1. Clone the repo `git@github.com:aliahmed922/mr.draper.git`
2. Run `bundle` and `yarn install --check-files`
3. Run `cp config/webpacker.manual.yml config/webpacker.yml`
4. Run `cp config/database.manual.yml config/database.yml`
5. Update `.env.development` with your Postgres `username/password`
6. Run `rails db:create db:migrate`
7. Run `rails sample_data:load_db` to get the Sample Data
8. Paste the `master.key` in config directory. You have to Obtain it from the Code Owner
9. Run `cp Procfile.example.dev Procfile.dev`
10. Run `foreman start --procfile Procfile.dev`  
11. There you go 🎉
