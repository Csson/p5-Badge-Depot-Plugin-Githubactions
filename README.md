# NAME

Badge::Depot::Plugin::Githubactions - Github Actions plugin for Badge::Depot

<div>
    <p>
    <img src="https://img.shields.io/badge/perl-5.10+-blue.svg" alt="Requires Perl 5.10+" />
    <img src="https://img.shields.io/badge/coverage-75.8%25-orange.svg" alt="coverage 75.8%" />
    </p>
</div>

# VERSION

Version 0.0100, released 2020-12-27.

# SYNOPSIS

    use Badge::Depot::Plugin::Githubactions;

    my $badge = Badge::Depot::Plugin::Githubactions->new(user => 'my_name', repo => 'the_repo', branch => 'master', workflow => 'gh-actions-workflow');

    print $badge->to_html;
    # prints '<a href="https://github.com/my_name/the_repo/actions?query=workflow%3Agh-actions-workflow+branch%3Amaster"><img src="https://img.shields.io/github/workflow/status/my_name/the_repo/gh-actions-workflow/master" alt="Build status at Github" /></a>'

# DESCRIPTION

Create a [Github Actions](https://docs.github.com/en/free-pro-team@latest/actions) badge for a github repository.

This class consumes the [Badge::Depot](https://metacpan.org/pod/Badge::Depot) role.

# ATTRIBUTES

The `user` and `repo` attributes are required or optional, depending on your configuration. It looks for the `resources/repository/web` setting in `META.json`:

- If `META.json` doesn't exist in the dist root, `user` and `repo` are required.
- If `resources/repository/web` doesn't exist (or is not a github url), `user` and `repo` are required.

## user

Github username.

## repo

Github repository.

## workflow

The name of the Github Actions workflow. Required.

## branch

Github branch. Optional, no default.

# SEE ALSO

- [Badge::Depot](https://metacpan.org/pod/Badge::Depot)

# SOURCE

[https://github.com/Csson/p5-Badge-Depot-Plugin-Githubactions](https://github.com/Csson/p5-Badge-Depot-Plugin-Githubactions)

# HOMEPAGE

[https://metacpan.org/release/Badge-Depot-Plugin-Githubactions](https://metacpan.org/release/Badge-Depot-Plugin-Githubactions)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Erik Carlsson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
