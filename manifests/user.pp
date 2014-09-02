class hyperdex::user {
	group { "hyperdex":
		ensure => present,
	}

	user { "hyperdex":
		ensure => present,
		gid    => "hyperdex",
	}
}
