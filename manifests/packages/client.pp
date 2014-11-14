class hyperdex::packages::client {
	case $::operatingsystem {
		"Debian": {
			include hyperdex::apt
		}

		default: {
			fail "I don't know how to install packages for '${::operatingsystem}'"
		}
	}

	package { ["libhyperdex-client-dev", "libhyperdex-admin-dev"]: }
}
