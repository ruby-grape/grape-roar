Upgrading Grape-Roar
====================

### Upgrading to >= 0.3.0

This version requires Roar 1.0 or newer.

* Make presenter changes according to the [roar changelog](https://github.com/apotonick/roar/blob/master/CHANGES.markdown), specifically replace `Roar::Representer::Feature::Hypermedia` with `Roar::Hypermedia` and `Roar::Representer::JSON` with `Roar::JSON` and adjust any `require` paths.
* Ensure that `Grape::Roar::Representer` is included *after* any `Roar::JSON` or `Roar::Hypermedia` mixins. You would otherwise get a `TypeError: class or module required` from within `Roar::Representable`.


