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

Make sure you have the following installed first.

- MinGW
- Ruby and Ruby DevKit
- Gems:
    - `ocra`
    - `webrick`
    - `rouge` ([Recommended for v2.x and below](https://jekyllrb.com/docs/templates/#code-snippet-highlighting))

Using the Bash CLI, execute `build.sh` with the version number. For example, `./build.sh 2.5.3` will build Jekyll v2.5.3. The script will attempt to install the Jekyll version, if it is not installed yet. You can check the OCRA output in `ocra.log`.

To run a series of simple tests, run `test.sh`. A folder called `jekyll-new-folder` will be created to test the Jekyll subcommands.

If you need to add gems into the build, install the gem locally, then include the name of the gem in the `dependencies` array in `build.sh`.


#### Note

- The subcommands `docs` and `import` are not working by default, as their respective gems (`jekyll-docs` and `jekyll-import`) are not included as dependency.
- The `jekyll-watch`, `rouge` and `webrick` gems are by default, included manually into `jekyll-{version}/bin/jekyll`, as OCRA was unable to properly guess them as dependency.
- The extra gems are not included with OCRA's `--gemfile` as it would add Bundler as another dependency.
- The test script does not test `jekyll serve`, as I do not know any reliable way to check the running process.


#### Downloads

The versions that I have built manually on my personal Windows machine are
[v2.5.3](https://github.com/altbdoor/jekyll-exe/releases/tag/stable-v2.5.3),
[v3.0.5](https://github.com/altbdoor/jekyll-exe/releases/tag/stable-v3.0.5) and
[v3.1.6](https://github.com/altbdoor/jekyll-exe/releases/tag/stable-v3.1.6).
They work fine, and all the steps involved are logged in the release page. However, having a build script properly streamlines the building process. Subsequent versions are built with the build script on [AppVeyor](https://ci.appveyor.com/project/altbdoor/jekyll-exe).

Check the [releases](https://github.com/altbdoor/jekyll-exe/releases) page for downloads.


#### Credits

My heartfelt thanks to the other developers and projects for making this possible.

- [nilliams/jekyll.exe](https://github.com/nilliams/jekyll.exe)
- [jekyll/jekyll](https://github.com/jekyll/jekyll)
- [larsch/ocra](https://github.com/larsch/ocra)
