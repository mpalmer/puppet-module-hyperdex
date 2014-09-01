# Setup apt to take hyperdex packages from hyperdex.org.
#
class hyperdex::apt {
	apt::key { '311BC546':
		key_source => 'http://debian.hyperdex.org/hyperdex.gpg.key'
	}

	apt::source { "hyoerdex":
		location    => "http://debian.hyperdex.org",
		release     => "wheezy",
		include_src => false;
	}
}
