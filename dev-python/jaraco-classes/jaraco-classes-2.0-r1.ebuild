# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Tests fail with pypy
PYTHON_COMPAT=( pypy3 python{2_7,3_{5,6,7,8}} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Classes used by other projects by developer jaraco"
HOMEPAGE="https://github.com/jaraco/jaraco.classes"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"

RDEPEND="
	>=dev-python/namespace-jaraco-2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( $(python_gen_any_dep '
			>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
			>=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]')
	)
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

RESTRICT="!test? ( test )"

python_check_deps() {
	use doc || return 0
	has_version ">=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]" && \
		has_version ">=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]" && \
		has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -i "s:use_scm_version=True:version='${PV}':" setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
			cd docs || die
			sphinx-build . _build/html || die
			HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Avoid ImportMismatchError, override pytest options to skip flake8
	pytest -vv "${BUILD_DIR}"/lib --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}

# https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages#File_collisions_between_pkgutil-style_packages
python_install() {
	rm "${BUILD_DIR}"/lib/jaraco/__init__.py || die
	# note: eclass may default to --skip-build in the future
	distutils-r1_python_install --skip-build
}
