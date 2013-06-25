Address Normalizer
=======
A simple tool that takes a CSV with an "address" column and adds a column with normalized addresses, using [the Ruby street_address gem](https://github.com/derrek/street-address) (a port of the Perl module [Geo::StreetAddress::US](http://search.cpan.org/~sderle/Geo-StreetAddress-US-0.99/)).

Usage Examples
--------------

    ruby normalize_csv_addresses.rb "my_file_with_addresses.csv"

Current Contributors
--------------------
Dave Guarino ([https://github.com/daguar](https://github.com/daguar))

Contributing
------------
In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues](http://github.com/codeforamerica/cfa_template/issues)
* by reviewing patches

Submitting an Issue
-------------------
We use the [GitHub issue tracker](http://github.com/codeforamerica/cfa_template/issues) to track bugs and
features. Before submitting a bug report or feature request, check to make sure it hasn't already
been submitted. You can indicate support for an existing issuse by voting it up. When submitting a
bug report, please include a [Gist](http://gist.github.com/) that includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem version, Ruby version, and
operating system. Ideally, a bug report should include a pull request with failing specs.

Submitting a Pull Request
-------------------------
(Note: not using this process yet as this is a very early alpha; will conform later.)
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run <tt>bundle exec rake doc:yard</tt>. If your changes are not 100% documented, go back to step 4.
6. Add specs for your feature or bug fix.
7. Run <tt>bundle exec rake spec</tt>. If your changes are not 100% covered, go back to step 6.
8. Commit and push your changes.
9. Submit a pull request. Please do not include changes to the gemspec, version, or history file. (If you want to create your own version for some reason, please do so in a separate commit.)

Does your project or organization use this?
------------------------------------------
Add it to the [apps](http://github.com/codeforamerica/cfa_template/wiki/apps) wiki!

Copyright
---------
Copyright (c) 2013 Code for America Laboratories
See [LICENSE](https://github.com/codeforamerica/cfa_template/blob/master/LICENSE.mkd) for details.

[![Code for America Tracker](http://stats.codeforamerica.org/codeforamerica/cfa_template.png)](http://stats.codeforamerica.org/projects/cfa_template)

