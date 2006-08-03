use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => "Time::TT",
	VERSION_FROM => "lib/Time/TT.pm",
	PREREQ_PM => {
		Date::JD => "0.000",
		LWP => "5.5394",
		LWP::UserAgent => 0,
		Math::BigRat => "0.04",
		Math::Interpolator::Knot => "0.000",
		Math::Interpolator::Linear => "0.000",
		Math::Interpolator::Robust => "0.000",
		Math::Interpolator::Source => "0.000",
		Time::UTC => "0.001",
	},
);
