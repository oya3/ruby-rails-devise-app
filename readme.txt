# メモ
- development, production ともにsqlite3を使うように指定している
- add_mariadb_for_production ブランチにmariadb使用版もある（productionのみ）
- apache経由の場合、nodejsが必要なので、$ sudo apt install nodejs の実施が必要
- apache virtualhost 設定追加
  ```
  $ sudo emacs /etc/apache2/sites-available/trainroute.conf
  <VirtualHost *:80>
      ServerName trainroute.oya3.net
      DocumentRoot /home/developer/trainroute/public
      RailsEnv production
      <Directory "/home/developer/trainroute">
          Options Includes ExecCGI FollowSymLinks
          AllowOverride All
          Order allow,deny
          Allow from all
          Require all granted
      </Directory>
  </VirtualHost>
  $ sudo apache2ctl configtest
  $ sudo systemctl restart apache2
  ```
- credentials 追加
  ```
  $ EDITOR="vi" bundle exec rails credentials:edit
  ```
- storage追加(rails 5.x から追加された storage 設定)
  ```
  $ emacs config/storage.yml
  local:
    service: Disk
    root: <%= Rails.root.join("storage") %>
  ---END---
  $ emacs config/environments/production.rb
  config.active_storage.service = :local
  ---END---
  $ bundle exec rails active_storage:install RAILS_ENV=production
  $ bundle exec rake db:migrate RAILS_ENV=production
  ```

# 開発環境構築

```
$ git clone git@github.com:oya3/ruby-rails-devise-app
$ cd ruby-rails-devise-app

# 前回のbundle設定を破棄する場合
$ rm -rf .bundle vendor/bundle/ config/master.key

# プロジェクト設定
$ bundle config set --local path vendor/bundle
$ bundle install
$ EDITOR="vi" bundle exec rails credentials:edit
$ bundle exec rake db:migrate:reset
$ bundle exec rake db:seed

$ sudo systemctl restart apache2

$ bundle exec rails server -u puma
# http://localhost:3000/ をブラウザでアクセス
#  users:
#   - id: admin, password: admin3
```

# デプロイ

```
$ git clone git@github.com:oya3/ruby-rails-devise-app
$ cd ruby-rails-devise-app

# 前回のbundle設定を破棄する場合
$ rm -rf .bundle vendor/bundle/ config/master.key

# - mariadb を使用する場合
$ mysql -u root -p
MariaDB [(none)]> CREATE DATABASE trainroute default CHARACTER SET utf8mb4;
MariaDB [(none)]> CREATE USER 'trainroute'@'localhost' IDENTIFIED BY 'abc123!!';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON trainroute.* TO 'trainroute'@'localhost';
MariaDB [(none)]> flush privileges;
MariaDB [(none)]> exit;

# - mariadb の旧設定を削除する場合
$ mysql -u root -p
MariaDB [(none)]> drop database trainroute;
MariaDB [(none)]> CREATE DATABASE trainroute default CHARACTER SET utf8mb4;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON trainroute.* TO 'trainroute'@'localhost';
MariaDB [(none)]> flush privileges;
MariaDB [(none)]> exit;

# プロジェクト設定
$ bundle config set --local without 'development test'
$ bundle install
$ EDITOR="vi" bundle exec rails credentials:edit

$ bundle exec rake db:migrate RAILS_ENV=production
$ bundle exec rake db:seed RAILS_ENV=production
$ bundle exec rake tmp:cache:clear RAILS_ENV=production

#  users:
#   - id: admin, password: admin3
```

# 課題
- bundle install すると以下のメッセージが表示されるが、現状何も対策していない
  ```
  Post-install message from devise:

  [DEVISE] Please review the [changelog] and [upgrade guide] for more info on Hotwire / Turbo integration.

    [changelog] https://github.com/heartcombo/devise/blob/main/CHANGELOG.md
    [upgrade guide] https://github.com/heartcombo/devise/wiki/How-To:-Upgrade-to-Devise-4.9.0-%5BHotwire-Turbo-integration%5D
    Post-install message from rubyzip:
  RubyZip 3.0 is coming!
  **********************

  The public API of some Rubyzip classes has been modernized to use named
  parameters for optional arguments. Please check your usage of the
  following classes:
    * `Zip::File`
    * `Zip::Entry`
    * `Zip::InputStream`
    * `Zip::OutputStream`

  Please ensure that your Gemfiles and .gemspecs are suitably restrictive
  to avoid an unexpected breakage when 3.0 is released (e.g. ~> 2.3.0).
  See https://github.com/rubyzip/rubyzip for details. The Changelog also
  lists other enhancements and bugfixes that have been implemented since
  version 2.3.0.
  ```

