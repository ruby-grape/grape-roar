### 0.5.1 (Next)

* [#35](https://github.com/ruby-grape/grape-roar/pull/35): Migrate Danger to use danger-pr-comment workflow - [@dblock](https://github.com/dblock).
* [#37](https://github.com/ruby-grape/grape-roar/pull/37): Modernize CI with Ruby 2.7-4.0 and Grape 1.x-4.x coverage, test newer Grape and ORM combinations with Rack 3.x, and run MongoDB in service containers; include ORM examples automatically when their dependencies are selected - [@dblock](https://github.com/dblock).
* [#40](https://github.com/ruby-grape/grape-roar/pull/40): Document deeply nested representers and verify shared post/image records retain their attributes across repeated requests - [@dblock](https://github.com/dblock).
* [#42](https://github.com/ruby-grape/grape-roar/pull/42): Support caching plain rendered representations without forwarding Roar-only options to generic JSON encoders; document cache serialization and request-context keys - [@dblock](https://github.com/dblock).
* [#41](https://github.com/ruby-grape/grape-roar/pull/41): Document hash-backed representers with explicit key getters and verify module/decorator rendering for symbol and string keys - [@dblock](https://github.com/dblock).
* [#43](https://github.com/ruby-grape/grape-roar/pull/43): Add SimpleCov LCOV reports and a coverage badge; merge Coveralls reports from selected existing ORM matrix entries without duplicate test runs - [@dblock](https://github.com/dblock).
* [#44](https://github.com/ruby-grape/grape-roar/pull/44): Document dynamic Roar rendering options with native Hash responses and verify wrapping, callback data, request context, and request isolation for modules and decorators - [@dblock](https://github.com/dblock).
* [#45](https://github.com/ruby-grape/grape-roar/pull/45): Document native array rendering with Roar's collection factory while preserving collection envelopes and request-aware links - [@dblock](https://github.com/dblock).
* [#46](https://github.com/ruby-grape/grape-roar/pull/46): Document Grape's built-in representer lookup through model Entity constants and API-local decorator mappings, including explicit overrides - [@dblock](https://github.com/dblock).
* [#48](https://github.com/ruby-grape/grape-roar/pull/48): Document presenter parameter types using Grape's custom parsing contract with explicit input validation and writable properties; keep legacy test bundles on JSON 2.x for MultiJson compatibility - [@dblock](https://github.com/dblock).
* [#47](https://github.com/ruby-grape/grape-roar/pull/47): Document Swagger response metadata using the optional grape-swagger-representable parser and Roar decorators; run MongoDB 8.0 CI jobs on Ubuntu 22.04 to avoid unsupported Linux kernels - [@dblock](https://github.com/dblock).
* [#49](https://github.com/ruby-grape/grape-roar/pull/49): Document application-local CRUD endpoints with input/output representers, validated writable fields, partial updates, and explicit persistence failures; use product-oriented class names in CRUD and parameter examples - [@dblock](https://github.com/dblock).
* Your contribution here.

### 0.5.0 (2025/09/25)

* [#31](https://github.com/ruby-grape/grape-roar/pull/31): Add support for Mongoid 7, 8 and 9 - [@dblock](https://github.com/dblock).
* [#23](https://github.com/ruby-grape/grape-roar/pull/23): Resolves pollution issue with invoking representers on singletons - [@mach-kernel](https://github.com/mach-kernel).
* [#28](https://github.com/ruby-grape/grape-roar/pull/28): Replaced Travis-CI with GHA - [@dblock](https://github.com/dblock).

### 0.4.1 (2017/07/14)

* [#22](https://github.com/ruby-grape/grape-roar/pull/22): Adds Grape::Roar::Extensions::Relations - [@mach-kernel](https://github.com/mach-kernel).

### 0.4.0 (2017/02/18)

* [#21](https://github.com/ruby-grape/grape-roar/pull/21): Fixes serialization issue due to [representable](https://github.com/trailblazer/representable) API change, drop support for Ruby < `2.1.0` - [@mach-kernel](https://github.com/mach-kernel).

### 0.3.0 (2014/12/31)

* Added support for Roar 1.0 - [@dblock](https://github.com/dblock).

### 0.2.0 (2014/12/18)

* [#10](https://github.com/ruby-grape/grape-roar/pull/10): Support for Roar decorator - [@sdbondi](https://github.com/sdbondi).

### 0.1.0 (2014/7/17)

* Initial public release, with support for Grape `present` - [@dblock](https://github.com/dblock).
