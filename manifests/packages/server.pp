class hyperdex::packages::server {
	case $::operatingsystem {
		"Debian": {
			include hyperdex::apt
		},
		default: {
			fail "I don't know how to install packages for '${::operatingsystem}'"
		}
	}

	package { ["hyperdex-daemon", "hyperdex-coordinator", "hyperdex-tools"]: }
}
