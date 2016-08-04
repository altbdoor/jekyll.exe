jekyll.exe
==========

Original README from [@nilliams](https://github.com/nilliams/jekyll.exe).

> This is an effort to maintain small, portable Windows builds of [Jekyll](http://jekyllrb.com), built with [OCRA](http://ocra.rubyforge.org).
> 
> The current build is Jekyll v1.2.0
> 
> In the future this repo may contain build scripts, patches etc. For now, refer to [this blog post](http://www.nickw.it/jekyll-dot-exe/) on how it is built.
> 
> The source for the Jekyll project can be found on Github [here](https://github.com/mojombo/jekyll).

---

#### About

Jekyll, and all of its dependencies bundled into an executable file, so Windows users can run Jekyll without installing Ruby, Ruby DevKit or any gems. Click [here](https://github.com/altbdoor/today-i-learned/blob/master/topics/Building%20Jekyll%20for%20Windows.md) to read how I got into building Jekyll v2.5.3.


#### Building

Make sure you have the following installed first:

- Git for Windows (or basically a Bash environment in Windows)
- Ruby and Ruby DevKit
- Gems:
    - Depends on the Jekyll version

Run `build.sh` with the version and desired dependencies. Unfortunately, there is no reliable way to fully determine all required dependencies, except for trial and error.

```
Usage: ./build.sh VERSION [INJECT_DEPS] [BUNDLER_DEPS]
Compiles Jekyll into a single .exe file for Windows with OCRA.

  VERSION       Specifies the Jekyll version to build. E.g., "2.5.3". For a
                list of versions, use 'gem list "^jekyll$" -ra'.
  INJECT_DEPS   Optional, manually injects dependencies into the executable
                Jekyll file, comma separated. E.g., "webrick,jekyll-watch".
  BUNDLER_DEPS  Optional, manually injects dependencies via Bundler, comma
                separated. E.g., "webrick,jekyll-watch".

This script assumes that you already have installed whatever dependencies that
you are looking to inject.
```

The following files will be created:
- `jekyll.exe`, yours truly.
- `ocra.log`, the OCRA log while building Jekyll.
- `release.log`, the release information for the build.


#### Testing

Run `test.sh` to perform simple tests on the core Jekyll functions. `jekyll serve` has to be manually tested, as I do not know a reliable way to check the running process in Bash.


#### Downloads

The versions that I have built manually on my personal Windows machine are
[v2.5.3](https://github.com/altbdoor/jekyll-exe/releases/tag/stable-v2.5.3),
[v3.0.5](https://github.com/altbdoor/jekyll-exe/releases/tag/stable-v3.0.5) and
[v3.1.6](https://github.com/altbdoor/jekyll-exe/releases/tag/stable-v3.1.6).
They work fine, and all the steps involved are logged in the release page. However, having a build script properly streamlines the building process.

Subsequent versions are built with the build script on [AppVeyor](https://ci.appveyor.com/project/altbdoor/jekyll-exe). Their corresponding `appveyor.yml` can be found in their respective branches.

Check the [releases](https://github.com/altbdoor/jekyll-exe/releases) page for downloads.


#### Note

- The subcommands `docs`, `import`, `new-theme` are not working or not fully tested. I do not consider them to be a part of the core Jekyll functions, and therefore, have no plans on supporting them.
- Ruby 2.1 has been working very well for me. For unknown reasons, Ruby 2.2 successfully builds an executable which passes the test, but always complains about a Ruby-related error.


#### Credits

My heartfelt thanks to the other developers and projects for making this possible.

- [nilliams/jekyll.exe](https://github.com/nilliams/jekyll.exe)
- [jekyll/jekyll](https://github.com/jekyll/jekyll)
- [larsch/ocra](https://github.com/larsch/ocra)
