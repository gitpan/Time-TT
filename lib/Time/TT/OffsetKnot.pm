=head1 NAME

Time::TT::OffsetKnot - MJD/offset tuple for realisations of TT

=head1 SYNOPSIS

	use Time::TT::OffsetKnot;

	$pt = Time::TT::OffsetKnot($mjd, $offset_ns, 9);

	$tai_instant = $pt->x;
	$instant = $pt->y;
	$role = $pt->role;

=head1 DESCRIPTION

This class assists in implementing a realisation of Terrestrial Time
(TT) by interpolation using the C<Time::TT::InterpolatingRealisation>
class.  Many such time scales are defined by tables of data giving the
difference between TAI and the time scale at 00:00 UTC on various days.
An object of this class represents such a data point (knot), supplying
the C<Math::Interpolator::Knot> interface required.

The calculations required in order to generate the actual numbers to
interpolate with are performed lazily and memoised.  Until these numbers
(which will be C<Math::BigRat> objects) are generated, the raw data is
stored very space-efficiently.  Construction of the knot object is quick.

=cut

package Time::TT::OffsetKnot;

use warnings;
use strict;

use Carp qw(croak);
use Date::JD 0.000 qw(mjd_to_cjdn);
use Math::BigRat 0.04;
use Time::UTC 0.001 qw(utc_to_tai utc_cjdn_to_day);

our $VERSION = "0.000";

use fields qw(x y);

=head1 CONSTRUCTOR

=over

=item Time::TT::OffsetKnot->new(MJD, OFFSET, UNIT)

Creates and returns an object representing a knot where at the integral
Modified Julian Date MJD (interpreted according to UTC) the time scale of
interest differed from TAI by OFFSET * 10**-UNIT seconds.  For example,
if OFFSET is 43.5 and UNIT is 9 then the time scale differs from TAI by
43.5 ns.

MJD must be purely a string of digits.  OFFSET must be a string in
decimal numeric syntax, matching C</[-+]?\d+(?:\.\d+)?/>.  UNIT must
be non-negative.

If the OFFSET value is positive then it indicates that the time scale
is behind TAI.  If the OFFSET value is negative then the time scale is
ahead of TAI.  This is the sense of the offset found in TAI-TAI(k) files.
If the raw data is in the sense TT(k)-TT(TAI) then the sign will have
to be reversed before passing it to this constructor.

=cut

sub new($$$$) {
	my($class, $mjd, $offset, $unit) = @_;
	croak "malformed MJD `$mjd'" unless $mjd =~ /\A\d+\z/;
	my($sign, $int, $frac) = ($offset =~ /\A([-+]?)(\d+)(?:\.(\d+))?\z/);
	croak "malformed offset `$offset'" unless defined $int;
	$frac = "" unless defined $frac;
	$int = ("0" x $unit).$int;
	my $pos = length($int) - $unit;
	my __PACKAGE__ $self = fields::new($class);
	$self->{x} = $mjd;
	$self->{y} = $sign.substr($int, 0, $pos).".".substr($int, $pos).$frac;
	return $self;
}

=back

=cut

use constant BIGRAT_ZERO => Math::BigRat->new(0);

sub x($) {
	my __PACKAGE__ $self = shift;
	my $x = $self->{x};
	if(ref($x) eq "") {
		$x = utc_to_tai(
			utc_cjdn_to_day(mjd_to_cjdn(
				Math::BigRat->new($x), BIGRAT_ZERO)),
			BIGRAT_ZERO);
		$self->{x} = $x;
	}
	return $x;
}

sub y($) {
	my __PACKAGE__ $self = shift;
	my $y = $self->{y};
	if(ref($y) eq "") {
		$y = $self->x - Math::BigRat->new($y);
		$self->{y} = $y;
	}
	return $y;
}

sub role($) { "KNOT" }

=head1 SEE ALSO

L<Math::Interpolator::Knot>,
L<Time::TT::InterpolatingRealisation>

=head1 AUTHOR

Andrew Main (Zefram) <zefram@fysh.org>

=head1 COPYRIGHT

Copyright (C) 2006 Andrew Main (Zefram) <zefram@fysh.org>

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
