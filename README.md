[![Coverage Status](https://coveralls.io/repos/github/lighter/travel/badge.svg?branch=master)](https://coveralls.io/github/lighter/travel?branch=develop)

```
$ docker-compose build --no-cache
$ docker-compose up -d
$ docker-compose run --rm web rake db:create
$ docker-compose run --rm web rake db:migrate
```

```
$ rails g controller
$ bundle exec rake test
$ rails g migration add_reset_to_users reset_digest:string reset_sent_at:datetime
$ rails g model User name:string, email:string
$ bundle exec rake db:migrate
$ bundle exec rake db:rollback
```