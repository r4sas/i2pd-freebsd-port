PORTNAME=	i2pd
PORTVERSION=	2.40.0
CATEGORIES=	security net-p2p

MAINTAINER=	ports@FreeBSD.org
COMMENT=	C++ implementation of I2P client

LICENSE=	BSD3CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	boost-libs>=1.72.0_5:devel/boost-libs
LIB_DEPENDS=	libboost_thread.so:devel/boost-libs

USE_GITHUB=	yes
GH_ACCOUNT=	PurpleI2P

USES=		cmake:insource compiler:c++11-lib ssl
CMAKE_ARGS=	-DWITH_GUI=OFF
CMAKE_SOURCE_PATH=	${WRKSRC}/build
USE_RC_SUBR=	${PORTNAME}

PORTDOCS=	*

USERS=		_i2pd
GROUPS=		_i2pd

PLIST_SUB=	USER="${USERS}" GROUP="${GROUPS}"
SUB_LIST=	USER="${USERS}" GROUP="${GROUPS}"
SUB_FILES=	i2pd.newsyslog.conf pkg-message

OPTIONS_DEFINE=	AESNI UPNP DOCS HARDENING

AESNI_DESC=		Use AES-NI instructions set
AESNI_CMAKE_BOOL=	WITH_AESNI
UPNP_DESC=		Include support for UPnP client
UPNP_CMAKE_BOOL=	WITH_UPNP
UPNP_LIB_DEPENDS=	libminiupnpc.so:net/miniupnpc
HARDENING_CMAKE_BOOL=	WITH_HARDENING
HARDENING_DESC=		Use hardening compiler flags

post-install:
	${INSTALL_MAN} ${WRKSRC}/debian/${PORTNAME}.1 ${STAGEDIR}${MAN1PREFIX}/man/man1
	@${MKDIR} ${STAGEDIR}${PREFIX}/etc/newsyslog.conf.d
	${INSTALL_DATA} ${WRKDIR}/i2pd.newsyslog.conf ${STAGEDIR}${PREFIX}/etc/newsyslog.conf.d/i2pd.conf
	@${MKDIR} ${STAGEDIR}${ETCDIR}
	@${MKDIR} ${STAGEDIR}${ETCDIR}/tunnels.conf.d
	${INSTALL_DATA} ${WRKSRC}/contrib/i2pd.conf ${STAGEDIR}${ETCDIR}/i2pd.conf.sample
	${INSTALL_DATA} ${WRKSRC}/contrib/tunnels.conf ${STAGEDIR}${ETCDIR}/tunnels.conf.sample
	@(cd ${WRKSRC}/contrib && ${COPYTREE_SHARE} "certificates" ${STAGEDIR}${DATADIR})
	@${MKDIR} ${STAGEDIR}/var/run/i2pd
	@${MKDIR} ${STAGEDIR}/var/log/i2pd
	@${MKDIR} ${STAGEDIR}/var/db/i2pd

post-install-DOCS-on:
	@${MKDIR} ${STAGEDIR}${DOCSDIR}
	${INSTALL_DATA} ${WRKSRC}/README.md ${STAGEDIR}${DOCSDIR}

.include <bsd.port.mk>
