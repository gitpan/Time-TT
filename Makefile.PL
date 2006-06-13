use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => "Time::TT",
	VERSION_FROM => "lib/Time/TT.pm",
	PREREQ_PM => {
		"Date::JD" => "0.000",
		"LWP" => "5.53_94",
		"LWP::UserAgent" => undef,
		"Math::BigRat" => "0.04",
		"Math::Interpolator" => "0.000",
		"Time::UTC" => "0.001",
	},
);
