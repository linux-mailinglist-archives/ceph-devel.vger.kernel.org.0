Return-Path: <ceph-devel+bounces-1194-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E628D4CB7
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 15:28:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECB0A28437E
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 13:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A67917C213;
	Thu, 30 May 2024 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="SMvB1pzv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2113.outbound.protection.outlook.com [40.107.7.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5DC3DABFA;
	Thu, 30 May 2024 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717075629; cv=fail; b=BhThXi9gX/zVk34RWRpby1Gco/1i9Z6jes8LgIoBvA3QT4Zpet9i6phwOdsW6BRAC3j1muqb2iC2/tqhhKIcwrU3HElnAx/C6t6cWhhPSYj0JSVaj2GA0RYKSH2FgaR8qoXN7TPdsOVvyi39NtlRALArmKJzmQAvpWZzsH0v4W8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717075629; c=relaxed/simple;
	bh=2+Im+2kXu18jMablAeBcJ/QIXTeWmdY+pzCZJV985fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=duBF+u0zw+dT8yGOMaUAs16jvg5xVRExrC1uv0RtnVvsGJqYgM2XCSDOFCkTbgIcsXekYW3IFZPCk31hWxD4nRcSz1SyXFh1NzK3Bgmrrpaxq1k5uPmnWc5DgcE4qSOqydhhRYxx2coi5mUoOQt16iCYz+U3/8FEARDlNyXq9R4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=SMvB1pzv; arc=fail smtp.client-ip=40.107.7.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmPIwbROBTxSIPMmghlMEuwcVL72Er60KUpbj0fWLK5Xxvl3Y15JQ4hCJje87kMUNyPB+tTpwEUm2jEmn0Pz8bhYE9o37ckOby3prV4H0jPPTRBaLw1j7hh4mK9QTBeecoqnyM8g8iR4FJKLaxJdb2SRcju4eO+kifl0N84V7tIrfn67LD+aOgtxxChXw/t95Nu67zrFV/5s1F3I9Zbu3d4tTtl0j4LYIzXcQ0Vqec27uCesbfe8sadZAGBGwVYW10utt9ixm24DmNN0uo4lJVLJ5GSjNdVDCa7MqXXHx7FLX+y867W6VVI419y4dLYCp8d2K4ZcBdbN19cc707koA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Rfv8LDVgRTz9jiC1OhOxn9YPDgrbU5FKBlQ7Avcww4=;
 b=Dyt7FUbMYucu1v9QwRKh2V96s41bGNXWfkGoPHKF88AQn53SpHreUG5RBtDBESgWVjUgNL2lOHZp8X+kdST/vkdEjSaWY5yKGEtiMpQe1z5y/tueN+GnZrDyzs7ns279ztVwGIV6v4IkGXRHcDNbmHrrIPCdBykjWkKdZnDa90/chb27W0eYB3ij7fSKu5rtWVj/x+8g/jhcHI8hSMDEe5b9Soe1LmcmjBLz53usX4YnqIpwZeCxTJIeFFg64VrHKIjt+BwAaavnhq7RfacxltPSMqmvMPq15imYQ2YK+hH8giYlivquGIIvSBJ9vB6Gc1eiGb2qoL+07LO/hIDTWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Rfv8LDVgRTz9jiC1OhOxn9YPDgrbU5FKBlQ7Avcww4=;
 b=SMvB1pzvgoCZLOAndGZOzmxlbngaTuUljF9e3pMTIX2RXVBba92jLeQ6sH3B/DsM/BAqbobWmxOny1ADBxM1x6aMNdumdLe4ATtWI7mCeH5uX++LpDWKPlLIHUBwu7FEgtQyeCe7nGaAGl6iHs03DXQ7krvxyda18bCtc/79tyr4zcSArzmfMMBn0fLgZAWS6eDVSfzURmDcAsJbJ6EfAFmqv1XQ+XwVIqWpIlby4QIQ8VQQf71RDNWu2ywE+1i0ZJ4qU4eDHe1TBP9awaKHmN2/ldm+ZmIYPG3OCMlxRqgB/4GFtTxqpZlz3X4nG9f7H2z3YiiNdVN9PxSOvJWhMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by PAXPR04MB8814.eurprd04.prod.outlook.com (2603:10a6:102:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 13:27:05 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%3]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 13:27:03 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	edumazet@google.com,
	pabeni@redhat.com,
	idryomov@gmail.com,
	xiubli@redhat.com
Subject: [PATCH 4/4] libceph: use sendpages_ok() to instead of sendpage_ok()
Date: Thu, 30 May 2024 16:26:26 +0300
Message-ID: <20240530132629.4180932-5-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240530132629.4180932-1-ofir.gal@volumez.com>
References: <20240530132629.4180932-1-ofir.gal@volumez.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|PAXPR04MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: 654021b9-d290-492d-f2de-08dc80ac3175
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|366007|52116005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9WNn5jGJY3XrebvUfzk+GkzaBraANVyOuxWKP7pesIwO2iD9b4QjIrnyDkig?=
 =?us-ascii?Q?zu/cpAWqpwW7yFQ9OgOTX8RhAb5RjFi2o1qyy336b/RLIHHAuaR8FfJzjSpO?=
 =?us-ascii?Q?xBbYgQcUsnBuWri0vNGLfVLnY4l/lWdxqjzapMYzgmo1Z+CCU8gkZ0DbaJW6?=
 =?us-ascii?Q?L5x9GAV8ZEZOdxH0emjUzWGwc8I3/FLyMy2kuk6lrcRVy1ZPB/FtRITnlVEc?=
 =?us-ascii?Q?Lgdxqp4FnnKt0WBPG4GLBD1NdODRhr0dRPsUnBHjBPGWJybuPIUPDT5pDz3n?=
 =?us-ascii?Q?UXoI6V+kyLybTZBdYRqBSPQ9STSh8hZ+8UwGR+9IyiSPwq2cbD234zqICgH0?=
 =?us-ascii?Q?Ka34w0CdNCv4i1Mz73i0MAoLuRP9FXwdezex7Jz/+ZFoNe/8/+BddvpTzaD/?=
 =?us-ascii?Q?B3zCOQ7dNSbIditWdt5g14jgZ/308GMrl3L3Zvp6iePn/yH+7KkvbLExpUOM?=
 =?us-ascii?Q?nufCd6uy7nn2nzS13Z9N+n15rPnCT8AcJ74gloIVG+/XSl27Aa39rhg4Eyju?=
 =?us-ascii?Q?tKum9yrgdhKOsRQbYHyNozKF5dPM4t69FJD39AJFqORfeuYfYNFY1F6N1wYf?=
 =?us-ascii?Q?rsii+QiV9Q6fxD+DsyKKguSxkoY9XE7eiqDlZGwGKHK+ULXG79CcCWLjSH4Z?=
 =?us-ascii?Q?sxpyQO1spTIfJXgvrL2pyUSC/BCjZ4aLOhIs/B3UuQWufJMLipCbN/Y8hi35?=
 =?us-ascii?Q?8UuuoBLtsIVDMtTK8+4DTZpcmCbwSjugOHPr8JhExrJn9nHEBhO9VtsvKKso?=
 =?us-ascii?Q?P2ZnbLJZU8zh3mYyqHR6xHxxdfX6Ii+JnEEmSN26hVLhTF9ag7pv5jIYQ3a+?=
 =?us-ascii?Q?oDHPNPqauLhp7pPZayUP2K9Z1W7uTp62JEh8v7+Bd2UKGwEOSF3ZLAHD60Ma?=
 =?us-ascii?Q?AH0cFq4cOyy6l4RfCrxQP5q/dcM142/P9e4RT5KxSc91HHyTSQ3HtiYF3tSp?=
 =?us-ascii?Q?uICbpJAB+Zb/5PzDJASMihKL3J/hz+enKPRiKMBeLYbGZs4OHjwFpnckVSRO?=
 =?us-ascii?Q?9k7ouTDJRCziVP9rzDsgrwF0hgwF5NGJ3qRTccZatPHQIAx7L2waMygWLkkK?=
 =?us-ascii?Q?hUFIrllY5jII0elQqHm4npST8bzTvJ+lQ/CHzFgCIoFrc9O8ZVoSnnPLN6bB?=
 =?us-ascii?Q?CVIE3bEf0kUUXnH472RaTemQ3BC8W+Q8wt8U/l/qttKS6MQBoJiHKTT7hYjc?=
 =?us-ascii?Q?qGgV8n2MZuukvT+OJJSujX6JZJj0SFkewIcxfvjToIWsnVbX0bHtrdBKIwOa?=
 =?us-ascii?Q?UTjePTmhGyowTCxhAj/Ut8ASCz2Yb8R55GirXXiaYYaanc+yt68qphsDPsiT?=
 =?us-ascii?Q?gvf3/lpCx/XsKMTz2ON0lxWjqv4Xr4NgnGVGSSAylgwG+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(52116005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3zMc9eBd+FCYDZF0RT71icHZWhJSl3Yfzlt+2sB5/VKBN1nKYGDkPm1XKtxa?=
 =?us-ascii?Q?lAF5ruyAlqgI+xpSLsnacfEYPTtSHcjixkjZd8s6wrAi1d/2uU7j/Xcxe4Zn?=
 =?us-ascii?Q?IzZ8CfTBakxXuud5V4yJRy7PvoofapnSLXJ1/8yc2Ksk6Tjk9MxSOpH3PjSP?=
 =?us-ascii?Q?1FY4Do6sXSB6b7AJ67tN0+goAYLhwnx9ThfoTjkQQmrcoBXWw7IHbO3u3ouE?=
 =?us-ascii?Q?2o/glyf34Uuns9lmheytdM131d51HN3pfddQiW/Rr/rEJDzrtQa4KLbnJfPS?=
 =?us-ascii?Q?/cwJBUwVaI6Ib7Od1GBy8LnOCQOBePV52lsAGkO8n5qf30+PqOFA9cFFmvjY?=
 =?us-ascii?Q?EVePV8ZTuGbQdlYQBEyrkWzq2m5HPipAjrFtq5x9NJh5C5geDaXYISfEVJwB?=
 =?us-ascii?Q?P2ii+XnHOZLbVBSpGmFhUksycc9UGYYK5RYDSblqYMwt0LxLCj/5rXrTRZOk?=
 =?us-ascii?Q?RLUObEcm08DSZA2Wu6FxddmtWmSsS1t0yLQCUh3tXSegQ0nQy50k7XBODDlm?=
 =?us-ascii?Q?9G9bLZB9vOSfC8jDiaZa+LjbtbKTOOOBkWsIosSkFFw/yWOep1g6a6pIkG2b?=
 =?us-ascii?Q?5MblIPg+cNJFVuNXcapaGnq7LcUo5fp/YdUlagrCHh9jzOIhZ1apk5P5/Ypw?=
 =?us-ascii?Q?RXXEOuOn4dCS+2EDV7pwMNaesIgg7Ac8t0cJgcWqdRedEMh3Q6rApALY7lxZ?=
 =?us-ascii?Q?H+X7zEJfcAl0irWPThj8dZo61UaH+qjT05F5UNXRFkNLI57V4ndRFfhksHPq?=
 =?us-ascii?Q?zoGRr2rfScbrBwmsas0xZj5iJw9dHVrnKokgL648sT/iS5Ls6esJANKJwvDY?=
 =?us-ascii?Q?2dzwrVfZroOWL6oHKaRBxctTET29dnkL2fI3WD6Wur0IQ5ceX01GqXQOYzj8?=
 =?us-ascii?Q?Z+ChN6EzJc+EUzeOvJDnm7tPKyxnRI3xCMQNJTCeiCm7zGd8VM8wELIXVvfs?=
 =?us-ascii?Q?NZJ4YGmsxdbxXqZw2Lb1uAGOPLRJ/4l/N7SRPrnINyxQJkHRwveM3pza3BHH?=
 =?us-ascii?Q?vQPBcg4U+dRbJ1dYfpCYBA5VmqqPZ8mE6VzYdsAmD8nNcrEbveP6Nsskr9s9?=
 =?us-ascii?Q?Y3KNm/4Vi2O2jkO+8DbdSnBPiy8MkqGhSMNBLUKwxQiK4PU6D3HAfCYmN8Hq?=
 =?us-ascii?Q?TBXsVwJTqYg2CvR+vp9QdZP8cCj4MMK2RmTrLu5o1rSyo+tJobZjnv+H0Hg3?=
 =?us-ascii?Q?Rpg0q285VbdQVZv1hqygaVXjCdMMGgOHQnGKq49UwqwxT7s1fkt4qLWOAGvY?=
 =?us-ascii?Q?dOQaWdQthyHt05AZCN1PSBP5i9uGbv04eu7Ac6gyfNb8ye0Ns+3G4EA8S73Q?=
 =?us-ascii?Q?PLQy2YlfQ60eqGL80mcOGlyjxmysEnDNEczjm+hGmSJ/hShpT8vVQtwvGg+4?=
 =?us-ascii?Q?APesuzwG3SoI0UKqiq3Zi80Fn/4p1APjWnKnfRD78j3AZvXXAl5OY3l3mUof?=
 =?us-ascii?Q?pmnJpa1iHpT7lhXCnKWetCd53d/9ssvich6ONrusJ99jXuukMCE5hN5zxOTO?=
 =?us-ascii?Q?4hZP7yWuaCuV17e8829HLJ+RICGFd4ntd3Fu03Q3yrucCBV1jCagD7Nnz0Sw?=
 =?us-ascii?Q?XDsi4fcv36BHFaKJgNgXJPy/vwmgUSh8wdGERbpw?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654021b9-d290-492d-f2de-08dc80ac3175
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 13:27:03.2864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GY3tElxkCWzdJZMYpfzGlyRgE+/A8/7+dMA7lqouX0DGEA+kWPFltKXY9uKgrH1q0n1E3pCk5AQpAl3BbFsk1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8814

Currently ceph_tcp_sendpage() and do_try_sendpage() use sendpage_ok() in
order to enable MSG_SPLICE_PAGES, it check the first page of the
iterator, the iterator may represent contiguous pages.

MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
pages it sends with sendpage_ok().

When ceph_tcp_sendpage() or do_try_sendpage() send an iterator that the
first page is sendable, but one of the other pages isn't
skb_splice_from_iter() warns and aborts the data transfer.

Using the new helper sendpages_ok() in order to enable MSG_SPLICE_PAGES
solves the issue.

Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 net/ceph/messenger_v1.c | 2 +-
 net/ceph/messenger_v2.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 0cb61c76b9b8..a6788f284cd7 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -94,7 +94,7 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
 	 * coalescing neighboring slab objects into a single frag which
 	 * triggers one of hardened usercopy checks.
 	 */
-	if (sendpage_ok(page))
+	if (sendpages_ok(page, size, offset))
 		msg.msg_flags |= MSG_SPLICE_PAGES;
 
 	bvec_set_page(&bvec, page, size, offset);
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index bd608ffa0627..27f8f6c8eb60 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -165,7 +165,7 @@ static int do_try_sendpage(struct socket *sock, struct iov_iter *it)
 		 * coalescing neighboring slab objects into a single frag
 		 * which triggers one of hardened usercopy checks.
 		 */
-		if (sendpage_ok(bv.bv_page))
+		if (sendpages_ok(bv.bv_page, bv.bv_len, bv.bv_offset))
 			msg.msg_flags |= MSG_SPLICE_PAGES;
 		else
 			msg.msg_flags &= ~MSG_SPLICE_PAGES;
-- 
2.34.1


