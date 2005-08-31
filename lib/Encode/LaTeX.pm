package Encode::LaTeX;

use 5.008;
use strict;
use warnings;

use AutoLoader qw(AUTOLOAD);

use Encode::Encoding;
use Pod::LaTeX;
use HTML::Entities;

our @ISA = qw(Encode::Encoding);

our $VERSION = '0.1';

__PACKAGE__->Define(qw(LaTeX BibTeX latex bibtex));

use vars qw( %LATEX_Escapes %LATEX_Escapes_inv );

# Missing entities in HTML::Entities?
@HTML::Entities::entity2char{qw(sol verbar)} = qw(\textfractionsolidus{} |);

# Use the mapping from Pod::LaTeX, but we use HTML::Entities
# to get the utf8 value
while( my ($entity,$tex) = each %Pod::LaTeX::HTML_Escapes ) {
	$LATEX_Escapes{$HTML::Entities::entity2char{$entity}} = $tex;
	$LATEX_Escapes_inv{_escape($tex)} = $HTML::Entities::entity2char{$entity};
}

sub _escape {
	$_[0] =~ s/([\\{}\$\&])/\\$1/sg;
}

# encode($string [,$check])
sub encode
{
	use utf8;
	my ($self,$str,$check) = @_;
	$str =~ s/([^\x00-\x80])/$LATEX_Escapes{$1}/sg;
	return $str;
}
# decode($octets [,$check])
sub decode
{
	my ($self,$str,$check) = @_;
	while( my ($re,$char) = each %LATEX_Escapes_inv ) {
		$str =~ s/$re/$char/sg;
	}
	$str;
}

sub perlio_ok { 0 }

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

Encode::LaTeX - Encode/decode Perl utf-8 strings into LaTeX

=head1 SYNOPSIS

  use Encode::LaTeX;
  use Encode;

  $tex = encode('latex', "This will encode an e-acute (".chr(0xe9).") as \'e");
  $str = decode('latex', $tex); # Will decode the \'e too!

=head1 DESCRIPTION

This module provides encoding to LaTeX escapes from utf8 using mapping tables in L<Pod::LaTeX> and L<HTML::Entities>. This covers only a subset of the Unicode character table (undef warnings will occur for non-mapped chars).

Mileage will vary when decoding (converting LaTeX to utf8), as LaTeX is in essence a programming language, and this module does not implement LaTeX.

=head1 CAVEATS

Proper Encode checking is not implemented.

=head2 encode()

Existing Latex-like expressions will not be escaped, only utf8 characters.

=head2 decode()

Only those Latex expressions that exactly match the mapping table will be converted to utf8 characters.

=head1 SEE ALSO

L<Pod::LaTeX>

=head1 AUTHOR

Timothy D Brody, E<lt>tdb01r@ecs.soton.ac.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Timothy D Brody

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
