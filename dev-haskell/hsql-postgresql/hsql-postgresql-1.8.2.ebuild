# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# ebuild generated by hackport 0.2.13

EAPI=4

CABAL_FEATURES="lib profile haddock hscolour hoogle"
inherit haskell-cabal

DESCRIPTION="A Haskell Interface to PostgreSQL via the PQ library"
HOMEPAGE="http://hackage.haskell.org/package/hsql-postgresql"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-haskell/hsql-1.8.2[profile?]
		<dev-haskell/hsql-1.9[profile?]
		>=dev-lang/ghc-6.10.1
		>=dev-db/postgresql-7"
DEPEND="${RDEPEND}
		dev-haskell/cabal"
