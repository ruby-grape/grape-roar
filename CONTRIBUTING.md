Contributing to Grape-Roar
==========================

Grape-Roar is work of [many of contributors](https://github.com/ruby-grape/grape-roar/graphs/contributors). You're encouraged to submit [pull requests](https://github.com/ruby-grape/grape-roar/pulls), [propose features and discuss issues](https://github.com/ruby-grape/grape-roar/issues). When in doubt, ask a question in the [Grape Google Group](http://groups.google.com/group/ruby-grape).

#### Fork the Project

Fork the [project on Github](https://github.com/ruby-grape/grape-roar) and check out your copy.

```
git clone https://github.com/contributor/grape-roar.git
cd grape-roar
git remote add upstream https://github.com/ruby-grape/grape-roar.git
```

#### Create a Topic Branch

Make sure your fork is up-to-date and create a topic branch for your feature or bug fix.

```
git checkout master
git pull upstream master
git checkout -b my-feature-branch
```

#### Bundle Install and Test

Ensure that you can build the project and run tests.

```
bundle install
bundle exec rake
```

GitHub Actions tests Grape 1.x through 4.x. The core matrix includes Ruby 2.7 with Grape 1.x/2.x, Ruby 3.3 with every Grape major, and Ruby 3.4/4.0 with Grape 4.x. The ruby-head job is allowed to fail. Ruby 2.7 uses Ubuntu 22.04; newer Rubies use the latest Ubuntu runner.

Select dependency versions with `GRAPE_VERSION`, `RACK_VERSION`, `ACTIVERECORD_VERSION`, and `MONGOID_VERSION`. Resolve the bundle again when changing versions:

```sh
GRAPE_VERSION='~> 4.0' bundle update
GRAPE_VERSION='~> 4.0' bundle exec rake
```

Grape 1.x requires Rack 2.x. On Ruby versions older than 3.2, the Gemfile also selects JSON 2.x because the compatible MultiJson releases use `JSON.load` options removed in JSON 3:

```sh
GRAPE_VERSION='~> 1.8' RACK_VERSION='~> 2.2' bundle update
GRAPE_VERSION='~> 1.8' RACK_VERSION='~> 2.2' bundle exec rake
```

Setting `ACTIVERECORD_VERSION` or `MONGOID_VERSION` loads that ORM and automatically includes its tagged examples in the suite. ActiveRecord adapter and validation tests do not require a database. Mongoid examples require MongoDB at `localhost:27017` and use the dedicated `grape_roar_test` database. CI runs MongoDB service containers for Mongoid 6.x through 9.x and tests newer Grape versions with ORM releases that permit their ActiveSupport requirements.

Spec runs generate `coverage/lcov/grape-roar.lcov` with SimpleCov. `test.yml` runs the core matrix and calls the separate reusable `test-activerecord.yml` and `test-mongodb.yml` workflows. Only `test.yml` handles push and pull-request events, so the ORM matrices run once per event. ORM entries marked `coverage: true` upload reports using the built-in GitHub token, covering ActiveRecord and both Mongoid association implementations without extra test runs. After the core matrix and both reusable workflows succeed, one completion job in `test.yml` merges the uploads into a single Coveralls report.

#### Write Tests

Try to write a test that reproduces the problem you're trying to fix or describes a feature that you want to build. Add to [spec/grape-roar](spec/grape-roar).

We definitely appreciate pull requests that highlight or reproduce a problem, even without a fix.

#### Write Code

Implement your feature or bug fix.

Ruby style is enforced with [Rubocop](https://github.com/bbatsov/rubocop), run `bundle exec rubocop` and fix any style issues highlighted.

Make sure that `bundle exec rake` completes without errors.

#### Write Documentation

Document any external behavior in the [README](README.md).

#### Update Changelog

Add a line to [CHANGELOG](CHANGELOG.md) under *Next Release*. Make it look like every other line, including your name and link to your Github account.

#### Commit Changes

Make sure git knows your name and email address:

```
git config --global user.name "Your Name"
git config --global user.email "contributor@example.com"
```

Writing good commit logs is important. A commit log should describe what changed and why. Using the `-p` flag while committing will show you the diff of your changes as you add them to the current commit which helps avoid small errors (e.g. syntax or indentation) that sometimes make it through.

```
git add -p ...
git commit
```

#### Push

```
git push origin my-feature-branch
```

#### Make a Pull Request

Go to https://github.com/contributor/grape-roar and select your feature branch. Click the 'Pull Request' button and fill out the form. Pull requests are usually reviewed within a few days.

#### Rebase

If you've been working on a change for a while, rebase with upstream/master.

```
git fetch upstream
git rebase upstream/master
git push origin my-feature-branch -f
```

#### Update CHANGELOG Again

Update the [CHANGELOG](CHANGELOG.md) with the pull request number. A typical entry looks as follows.

```
* [#123](https://github.com/ruby-grape/grape-roar/pull/123): Reticulated splines - [@contributor](https://github.com/contributor).
```

Amend your previous commit and force push the changes.

```
git commit --amend
git push origin my-feature-branch -f
```

#### Check on Your Pull Request

Go back to your pull request after a few minutes and check its GitHub Actions results. Everything should look green, otherwise fix issues and amend your commit as described above.

#### Be Patient

It's likely that your change will not be merged and that the nitpicky maintainers will ask you to do more, or fix seemingly benign problems. Hang on there!

#### Thank You

Please do know that we really appreciate and value your time and work. We love you, really.
