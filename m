Return-Path: <ceph-devel+bounces-1199-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88E9A8D4DDF
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 16:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F37F71F224C2
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 14:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1464817F503;
	Thu, 30 May 2024 14:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="mjxLnEl4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2139.outbound.protection.outlook.com [40.107.6.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F9117C212;
	Thu, 30 May 2024 14:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079087; cv=fail; b=LWXsUtNIdkS3BzjHkPZ0+52dK3uyUToI19jriVJ11+kVgjlr9q+iE3oiYTewcKt0fIdIhz7qZRxMTGxHs0cbn8rRymG11s8QdVCPHwekiBSQwVtYWR3hb7zOSm4gwADFO944TOb02sPPE/haR3NTzfU6qmonnCy6HLsGGAfJe5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079087; c=relaxed/simple;
	bh=2+Im+2kXu18jMablAeBcJ/QIXTeWmdY+pzCZJV985fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PFXyNqGldMOTSvEeIEfgGOKapGeexFiMabBSjd+PD4FTiHgy9D4h2KU0KgmgQCu39VtPRnCSOPiQ0yJN+VwZ5wSGB/G179JtAxMNrMGOvwjUCnfMYOlKZo2dzHCO7POZ9WL1t9aujym5oadWvf6dfS1EtKwTw3ZAH/ipXO4b7S4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=mjxLnEl4; arc=fail smtp.client-ip=40.107.6.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiHAveJnL6YbHJxKvpjO1zMgHCNvNtqKeIYkc5lHwF9gbFffN966JGI0jsghHcrqbsOyTWpIwlJg6yKs3BYYd49MW5ZmwcgrXgV7Yr+s9Z70UsLqGIYWQX4SY7hNQrRiiRL07bUK4roTHxaebkE103FZPX0udc+mzw5ovIBCVhmRSNj8VhhaanqzIVJrz82j0pwbl3bMtY599uokVcG1enUXRorqwzhfZSp6aIirqeMkibrBv7OwLhmWTF3czUsVvXGtBZXW0IgLM9b/QjG/hDRNVpUJIw6vpaxgAeZO+ctdbzxjtb8bacboOlSWOg5aXFR5g/rNytmnkSf83DTU4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Rfv8LDVgRTz9jiC1OhOxn9YPDgrbU5FKBlQ7Avcww4=;
 b=QR/uQOORYHc+A/s/H72fskenTHs0t/tjAI1i35qQSq9bdJbYJUys5NsTZrZD1QhxDy05+pUtGA4PW+bSdirtjkC0chn+ex+AWm19yTz+rGAKzOR8k2evtpRHybuv5sEKIk4m989ShwrzanXaUr/lpfILXEb+Qjz/bKVPkoOXlhAQT77HPeO7bY6yEsqsWlkkiwQGGg/jAqvVQDn19d5QZnFBbX3aE3jJ9CzfGtiwvHIkMLxjEqYHG+NTUlCjgrqUbDnmupOEatELFFCZT2DaGZoToKEhgIhOikymLRiie37WiZPNr5Ok9TNLKK1OpurWArU/Lcb/l/D8W9rCnruh6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Rfv8LDVgRTz9jiC1OhOxn9YPDgrbU5FKBlQ7Avcww4=;
 b=mjxLnEl4eu2bSrIUS83OqzUtoh3HNuU9SLnJ3+YTNZ4zDLjDTLtWKtkQ2rY+DjdrXdT5/RBGIpKI2Q2/EEff+uSxs1C6ZNYRIv3uelcQ+fNNUhCY5WU7rAqTLSV9LasoPhCdEkoeIsJqctaOzNsmJbOfkwm5FrwamuoXfpsift87uU4ekT+eapJhLT53U8xPSo9iGHazg3KN02Hm/K4d2h+mZZ6qM+aBw+Yaw1yGLDPFMmyb+1xXNjbqFB4khsPIfD6/nfXXEUx7pQYWY+s7eMqKEmm/oPScn1bOKQvhQdQwtXLbtGyqNPEOr2BPTO2GwPPlEL6o3KsY5giHwW1sWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by GV1PR04MB9216.eurprd04.prod.outlook.com (2603:10a6:150:2b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Thu, 30 May
 2024 14:24:39 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%3]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 14:24:38 +0000
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
Subject: [PATCH v2 4/4] libceph: use sendpages_ok() instead of sendpage_ok()
Date: Thu, 30 May 2024 17:24:14 +0300
Message-ID: <20240530142417.146696-5-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240530142417.146696-1-ofir.gal@volumez.com>
References: <20240530142417.146696-1-ofir.gal@volumez.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL0P290CA0001.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::15) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|GV1PR04MB9216:EE_
X-MS-Office365-Filtering-Correlation-Id: 098d4a6f-7f93-4ea9-ed34-08dc80b43cc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|52116005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oTYtWA9BMj49DaXyDpz1Z37O4Y8mcHDr3QFsXZiX+ZzYgiIhFuBdbA+7FO7R?=
 =?us-ascii?Q?ndTGdK9lxo3cg6Dkc2tdmOJn9rd3GU+6r8bmGAPCHUdy8Qa5HXZMSaEf9sxd?=
 =?us-ascii?Q?JSXgj0eglM7ItVl9sMhcVhBcU8n/NZXitK/DXaSWGFt0vYRe8b7ZHfPSmtoG?=
 =?us-ascii?Q?VeGjXrwCF90mu8Fc9EWvvcewVnil7+f5Wx2Hw22QhoE3X07uiBGG+IDWoBA7?=
 =?us-ascii?Q?RuKYvLh6D4n7P9FSbC636FBZR8Dqk11cm8wJTpTMua+c2Gi53THjCE0awvpA?=
 =?us-ascii?Q?KuF81XsPMlE3FRdAoDAJo5e2fJTmYAoHot2gOiOGVDiaBqlumdygn7f5ZEQt?=
 =?us-ascii?Q?qc6gp9llozoc5gakWAEdPU2mfoXXiFR6jP24lQCZi9EvluXTJkuxaU7TyxmG?=
 =?us-ascii?Q?3J9a4ZIxXtxqrP0d+/3Vcdwt27UazslyDby+vVbt5SmyD3qB0eFiVaIWhPV0?=
 =?us-ascii?Q?8ItbJJRXnLkyhBCGw7MEQpJwq7SLB5xKYDBw5ScKBMdu4YGUzKRkSszqbfsS?=
 =?us-ascii?Q?+e7hV9v760Lf34ryJaCLh5t/SJpXS39+SKLJ7ylpKGQDIeMDPnS5P9n9T/5i?=
 =?us-ascii?Q?bJHOkbxxKpdVTXzext4XtWoeGxeZh2LNpuDNwIFxGrracI2PG2aOVHNbjOke?=
 =?us-ascii?Q?Nyo0pSFbkk6YX7wl6rKSkOZuSo+udQJruTrP/EzfNPRTT+dffGph3enuXZzL?=
 =?us-ascii?Q?YHfxWA7mDK6AO5lKle0mdJHovxDjrgBMuFkdNh3TWb75G5ayVlVvyED6haCS?=
 =?us-ascii?Q?R9I/aBY/ryjCIT2NXpsnN3cETdamBHmjT1q+M+aaJ/oHb7mMPBelVaI81WgR?=
 =?us-ascii?Q?OAoRf2wd3ZhIGal2T6tsc4fpTdJsOp8kelsVeZeANecCHkdCLhY4f9a6P08m?=
 =?us-ascii?Q?s3+FLp/ZZo59NPjP7N11QZxHLR0aMyNI5p/OePB1lKv7wMVZ5GmNCBYgDGD7?=
 =?us-ascii?Q?foUS12uqh4R6IAk528+LxZ+Bd0UZMyjQVc8fG1QgGip6cK8S2zeDfuwRvnlw?=
 =?us-ascii?Q?ZRIpRcVVJ47QBRK3cIxU7MnasdDqwZT1UPxvUiReFDOhu7GLkNsB386vXVJa?=
 =?us-ascii?Q?oyGkp4YPA1jLqwMLObZotXUA5Lwp+fau7F2HNrGGt0A/QuRCJ466IFamxhiq?=
 =?us-ascii?Q?l26lkDwO0TIv6fhsS7TURTarOdcTSKGySqqzxFVQVk/SRk1bxawQdpiL6COJ?=
 =?us-ascii?Q?OOxAL1YcDasIdMRcx7yKi0tfzw3uJgKdXPhGuaw/2etocL8iRWKDdK6xkQLU?=
 =?us-ascii?Q?VVByqQ9+w7zptNEEs8x7eGRz7NBTC4TTkb15OVAV6pkbFn4rfWDv3B1QFSjR?=
 =?us-ascii?Q?4ds+Gb//CL8LHV6QGA4wqwbDiLHJzHLB+MUc1XXAUtD28Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(52116005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GneuxvJmFXOR1NzOJJ9Pd/nAr2iKW5NVnUVsqBREjttgsSj8pup4osM0f57s?=
 =?us-ascii?Q?EerR4THBMKet1vLDXWI3upe+M9SooisaskjEZZo6fBfHGjyBZLEKfYvcC35A?=
 =?us-ascii?Q?ZsJcaz4R7rar/hzdNIHnAv2Ze8zAIgOAsGM4sMrE+uiLbGkAXfQMyMkCcl8D?=
 =?us-ascii?Q?SMaGR61bHSfRJU3OlBPcmNcXFIwk+OvEAv/fgMrSmZAPbmL2A78UtdJBVhlk?=
 =?us-ascii?Q?cKMaeRYsw/7QJUOcfj6e81/BwJTzqttwUHhc5ihehHp7qfMlKLiFqXmjY/E7?=
 =?us-ascii?Q?VqQHABX3j7j976GWW0pFvZZZhmnuO5ni6JPW1u5zouUI+EStBidFfOGrPqca?=
 =?us-ascii?Q?cxBLz/FUoEw9zO8MIZTTFToxS6G1eLI97qQUdwghjXVEKnAI/ntBOdnx6BaE?=
 =?us-ascii?Q?q8rOZOdF6FNNhaG/FtllE2RhVBTZDEBSFFJsQpyfGJ3PFXcEXVYHYY1dmDHh?=
 =?us-ascii?Q?W5dD78VYGnK+6xwxK6l8GWm/HFVqqWmWGeU+i4GWM/kmEBAd4SyNmm5Bk3oR?=
 =?us-ascii?Q?S6XqztrnPQu77u1ysi489GMivkS1KztFi8/3kFBp5GzvTTjA+NksHgYxsVgl?=
 =?us-ascii?Q?L50hFiuDy3dsRg+kKVsjceSEhbhWHVECfazUpPcNEIbdzVSj9V3HL/TKmBaf?=
 =?us-ascii?Q?a0FMfTHTsy8D52GTwTyumxwtvIpccuuKbIBm4dW9nRsKvashgvU0oAlE9J5o?=
 =?us-ascii?Q?N2Jmn2AG0S50T/sRYELEGeUKU4MPaq3UZKY3y2zWcrUiV6pc00VgQ3FGpsHe?=
 =?us-ascii?Q?xkiGWqrkaV++3aCZsPZaHssBsPxkED1lUyr5ZyeYWJ2sjSTYXgRrPttK9qBy?=
 =?us-ascii?Q?w3zwJgnA/J6ke1JXJ3T3r2WOs/yDOKON90VdfdCp33fa4ktETsxdLibIFi6Y?=
 =?us-ascii?Q?WYy9mHszbyHR3IUetW4ldncDQsOqVNOR+rtGyxrKxJNC78BrgqCozucgL8UL?=
 =?us-ascii?Q?8Obr7+lTOUhTh6RZNJ3SCLMUwCRxaagOlp1FyC6BNVCpUjmCDcun1FHm7Mzo?=
 =?us-ascii?Q?NnpR7k1AUWVpW//H8AduKx2XpHqmFh+keXCALAiRKY1W6EPLOdISSR3E+E5S?=
 =?us-ascii?Q?lQegjTQr+1ldAd0OFDPr4nGKmx6iei+w18QWMmmg0gGSD1NmHP16NT+Fz2Dm?=
 =?us-ascii?Q?AUWFhDKyLGfsXf9s2vB0hgV2YoC1pHDO1dQwpZWIreuEJ/mpCCfnVgbTmGC6?=
 =?us-ascii?Q?nQu7KW50y87N0T61LsiBUyLCOlTU+uzRPTKUDiIOP9OLVrlMVS2VLJaPh8jK?=
 =?us-ascii?Q?mS3OII0HdwvF6LKbpJSEWvb/6mWLp7REFbkQvVAHVovh5rR2RBiDQXahqPsU?=
 =?us-ascii?Q?hRaXJeTmCIXhadrLkBKMn8gg+J4L+HBMeX6u36IhrXHp7+wavr/+Kebp/npK?=
 =?us-ascii?Q?IQkLOO/si0hFpNTh8Iam6M4xUcMzV67GfW1YxG68Wa8D46Ta9fNWIUBChiqg?=
 =?us-ascii?Q?z++5YvAGNTHLDP4ol1RqLQLvSxhVIhAuef22glrkD4ORVGxWeWxmV2x3CGf8?=
 =?us-ascii?Q?0sOxQtVs2ieC/3IgA56mW2cqaYkXKkgbWZ96kLvfq/QByPrui4q2HGWPnnAC?=
 =?us-ascii?Q?YtV9fXSR5lT7F448ydcMhUIFdHsHyj2nGLJDDLIL?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 098d4a6f-7f93-4ea9-ed34-08dc80b43cc8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 14:24:38.2864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrDZeKBWZAoNXt1n+KcAUd3ZUOqddFaZEvFKWTJ44/IqmneyE+Hxuv0H1e5nxDQfCIf6NQjG4AJI+Mi2aiMIgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9216

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


