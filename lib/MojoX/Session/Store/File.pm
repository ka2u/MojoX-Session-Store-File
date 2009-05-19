package MojoX::Session::Store::File;

use strict;
use warnings;
our $VERSION = '0.01';

use base qw(MojoX::Session::Store);
use MojoX::Session;
use Storable;
use File::Spec;
use Data::Dumper;

__PACKAGE__->attr(dir => (default => 0));

sub create {
    my ($self, $sid, $expires, $data) = @_;

    $data->{expire} = $expires;
    Storable::nstore $data, $self->_to_path($sid);
}

sub update {
    my $self = shift;
    $self->create(@_);
}

sub load {
    my ($self, $sid) = @_;
    if (open my $fh, '<', $self->_to_path($sid)) {
	my $value = Storable::fd_retrieve($fh);
	close $fh;
	my $expire = delete $value->{expire};
	return ($expire, $value);
    }
    undef;
}

sub delete {
    my ($self, $sid) = @_;
    unlink $self->_to_path($sid);
}

sub _to_path {
    my ($self, $sid) = @_;

    Carp::croak "Doesn't have a dir attribute." unless $self->dir;
    Carp::croak "Doesn't exist a dir path." unless -d $self->dir;
    File::Spec->catfile($self->dir, $sid . '.dat');
}

sub delete_expire_session_files {
    my $class = shift;
    my $dir = shift;

    my $fh;
    opendir($fh, $dir) or Carp::croak "Doesn't open dir : $dir.";
    my @files = readdir $fh;
    my $sess = MojoX::Session->new(store => $class->new(dir => $dir));
    for (@files) {
	my ($sid, $dat) = split /\./, $_;
        next unless $dat eq 'dat';
	$sess->load($sid);
	if ($sess->is_expired) {
	    unlink File::Spec->catfile($dir, $_);
	}
    }
}

1;
__END__

=head1 NAME

MojoX::Session::Store::File -

=head1 SYNOPSIS

  use MojoX::Session::Store::File;

=head1 DESCRIPTION

MojoX::Session::Store::File is

=head1 AUTHOR

Kazuhiro Shibuya E<lt>stevenlabs <lt>at<gt> gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
