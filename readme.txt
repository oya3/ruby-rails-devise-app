# メモ
#  - development, production ともにsqlite3を使うように指定している

# プロジェクト取得
$ git clone git@github.com:oya3/ruby-rails-devise-app
$ cd ruby-rails-devise-app

# 前回のbundle設定を破棄する場合
$ rm -rf .bundle vendor/bundle/

# プロジェクト設定
$ bundle config set --local path vendor/bundle
$ bundle install
$ bundle exec rake db:migrate:reset
$ bundle exec rake db:seed
$ bundle exec rails server -u puma
# http://localhost:3000/ をブラウザでアクセス
#  users:
#   - id: admin, password: admin3

# * bundle install すると以下のメッセージが表示されるが、現状何も対策していない
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
