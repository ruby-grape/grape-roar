# Releasing grape-roar

There're no particular rules about when to release grape-roar. Release bug fixes frequently, features not so frequently and breaking API changes rarely.

### Release

Run tests, check that all tests succeed locally.

```
bundle install
rake
```

Check that the last build succeeded in [Travis CI](https://travis-ci.org/ruby-grape/grape-roar) for all supported platforms.

Increment the version, modify [lib/grape-roar/version.rb](lib/grape-roar/version.rb).

*  Increment the third number if the release has bug fixes and/or very minor features, only (eg. change `0.3.1` to `0.3.2`).
*  Increment the second number if the release contains major features or breaking API changes (eg. change `0.3.1` to `0.4.0`).

Change "Next Release" in [CHANGELOG.md](CHANGELOG.md) to the new version.

```
### 0.3.2 (February 6, 2014)
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Commit your changes.

```
git add -p CHANGELOG.md lib/grape-roar/version.rb
git commit -m "Preparing for release, 0.4.0."
git tag 0.4.0
git push origin master
```

Release.

```
$ gem build grape-roar.gemspec
$ gem push grape-roar-0.4.0
```

### Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```
Next Release
============

* Your contribution here.
```

Commit your changes.

```
git add CHANGELOG.md
git commit -m "Preparing for next release."
git push origin master
```

### Make an Announcement

Make an announcement on the [ruby-grape@googlegroups.com](mailto:ruby-grape@googlegroups.com) mailing list. The general format is as follows.

```
grape-roar 0.4.0 has been released.

There was 1 contributor to this release, not counting documentation.

Please note the breaking API change in ...

[copy/paste CHANGELOG here]

```