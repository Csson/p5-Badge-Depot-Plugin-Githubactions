use 5.10.0;
use strict;
use 5.10.1;
use warnings;
use strict;


package Badge::Depot::Plugin::Githubactions;

# ABSTRACT: Github Actions plugin for Badge::Depot
# AUTHORITY
our $VERSION = '0.0100';

use Moose;
use namespace::autoclean;
use Types::Standard qw/Str HashRef Maybe/;
use Path::Tiny;
use JSON::MaybeXS 'decode_json';
with 'Badge::Depot';

has user => (
    is => 'ro',
    isa => Str,
    lazy => 1,
    default => sub {
        my $self = shift;
        if($self->has_meta) {
            return $self->_meta->{'username'} if exists $self->_meta->{'username'};
        }
    },
);
has repo => (
    is => 'ro',
    isa => Str,
    lazy => 1,
    default => sub {
        my $self = shift;
        if($self->has_meta) {
            return $self->_meta->{'repo'} if exists $self->_meta->{'repo'};
        }
    },
);
has branch => (
    is => 'ro',
    isa => Maybe[Str],
    default => sub { undef }
);
has workflow => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has _meta => (
    is => 'ro',
    isa => HashRef,
    predicate => 'has_meta',
    builder => '_build_meta',
);

sub _build_meta {
    my $self = shift;

    return {} if !path('META.json')->exists;

    my $json = path('META.json')->slurp_utf8;
    my $data = decode_json($json);

    return {} if !exists $data->{'resources'}{'repository'}{'web'};

    my $repository = $data->{'resources'}{'repository'}{'web'};
    return {} if $repository !~ m{^https://(?:www\.)?github\.com/([^/]+)/(.*)(?:\.git)?$};

    return {
        username => $1,
        repo => $2,
    };
}

sub BUILD {
    my $self = shift;
    my $link_url_branch = $self->branch ? '+branch%3A' . $self->branch : '';
    $self->link_url(sprintf 'https://github.com/%s/%s/actions?query=workflow%%3A%s%s', $self->user, $self->repo, $self->workflow, $link_url_branch);
    my $image_url = sprintf 'https://img.shields.io/github/workflow/status/%s/%s/%s', $self->user, $self->repo, $self->workflow;
    $image_url .= '/' . $self->branch if $self->branch;
    $self->image_url($image_url);
    $self->image_alt('Build status at Github');
}

1;

__END__

=pod

=head1 SYNOPSIS

    use Badge::Depot::Plugin::Githubactions;

    my $badge = Badge::Depot::Plugin::Githubactions->new(user => 'my_name', repo => 'the_repo', branch => 'master', workflow => 'gh-actions-workflow');

    print $badge->to_html;
    # prints '<a href="https://github.com/my_name/the_repo/actions?query=workflow%3Agh-actions-workflow+branch%3Amaster"><img src="https://img.shields.io/github/workflow/status/my_name/the_repo/gh-actions-workflow/master" alt="Build status at Github" /></a>'

=head1 DESCRIPTION

Create a L<Github Actions|https://docs.github.com/en/free-pro-team@latest/actions> badge for a github repository.

This class consumes the L<Badge::Depot> role.

=head1 ATTRIBUTES

The C<user> and C<repo> attributes are required or optional, depending on your configuration. It looks for the C<resources/repository/web> setting in C<META.json>:

=for :list
* If C<META.json> doesn't exist in the dist root, C<user> and C<repo> are required.
* If C<resources/repository/web> doesn't exist (or is not a github url), C<user> and C<repo> are required.

=head2 user

Github username.

=head2 repo

Github repository.

=head2 workflow

The name of the Github Actions workflow. Required.

=head2 branch

Github branch. Optional, no default.

=head1 SEE ALSO

=for :list
* L<Badge::Depot>

=cut

