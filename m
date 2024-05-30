Return-Path: <ceph-devel+bounces-1193-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3368A8D4CB4
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 15:28:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 549271C21169
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 13:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60EF73DAC0A;
	Thu, 30 May 2024 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="ORLnKGVO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2113.outbound.protection.outlook.com [40.107.7.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41242183996;
	Thu, 30 May 2024 13:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717075628; cv=fail; b=TH0V5GLPuwgc1Nr9R9/vg0pncYd6DgwTUgen/TffVJMhyf9Fegz5ovzoKtxMc40HqUCw+fvdN92zFp1al9Yf1jiTvhI6rVznvxb9DYAx09nuJxqZUyo8fdyvAQRWyPFr9OfJAiU54+QVfI1hHvtV1o20gBBAxn07stLfHnw9cj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717075628; c=relaxed/simple;
	bh=n+30LPrgh3ECtE4vwoN9GQnQtWDt8J1uBwKgssKCb6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W4wgIc3vSwCKmIKKGH/zDlaD++kj5AQoyiMfSuctJtaN/9mb6V0E4RzWcYpSTOzPF7wQIUAWVQlgmED95SmOju1p2km938V9ISxaSrIbke46EaVgKYQBp0e2IqtJsDjcGa+nbTLNwPUUjCy2GK+DQOC0o9sVMSWuGLiS7VrKnPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=ORLnKGVO; arc=fail smtp.client-ip=40.107.7.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cg2lccXUpDlJpbxejW54v7u6XGsnlmiZpULlsNtw2lCAVAqconPPhIzRYIPaWpeK8PKgURS30E2M0FXaSAwoiQUGYMbN7y7P5fYT4PhAyazkNYD2h1jfsJBQbKAv9153AMNxrbMJUoCN/RkwYvosnlkIQ59MM2kzspjh8YCfxJGbnM/JHNJcdTFJagRI1LxA3aFGHErae7vgNaJSCSIr1jXSCwPXnHFAO9c85vSQkQyfvvevVtjf3kHiLNqSAty16wUljX4UYtbOhNZIDWAnH+Oa2FlmzUjT7rpRJNPYRyVrOz5g4ZzJmq3SaSIDKtG+h1mU+STHXkH398oHDYmN2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXyPTjSX0sG4zzXDMHIlAtzkqrxPxSoExsIIIIGAj/c=;
 b=HxjLLVlYBE3RALblSQcF1OJcNB1/EiAh1hT2RqfMhHNe0lFNJ6cilok4zT+9KcqBABsQ9QCT3vSXtF/Ko9Db5LKsQ6raNZApqImUH/C+StfN6ZBmCG33vOvhmavtuDSEaKiTd/nWcdE2KVrWQe/ymTGIpJ1uGwp4RuJ0NBhpq6zA66t0OsoFdQGiGjhPiTywSjqXiTrQDSQhogggJC0iO5Ry1XYDLK1MkF8sDQ0NUkQX0z3iso8kNGhYwqe4oU7nnTPmWJHwJ9KFEOD0/eeNBqEH6hQBOgiBFjGxk3rMIuDW0ICIzgTqnvaFIeAcR8RBbYEfLjqUuQ1VjdULmJ/Bpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXyPTjSX0sG4zzXDMHIlAtzkqrxPxSoExsIIIIGAj/c=;
 b=ORLnKGVO9v4WbHExX/gWFY9cs2nqZcm/nt0NL3ra3m/DEyPa/hKcpzFFalkXpFrrzddpWSwwI9TOAvOIXisMM4n80ZaFwqw2RzPlILbygenIn9zDnz/U9O0S4SJYgbrWpLurpxXZF6fG/hjhipZmeNBcmaps+7guTqfZscdFAxaMgztJp5HM1QzLLNCO2ZE5YNU1ojkldOPaxO0kV+OJQsRXTt4nU1b0anlUmesQA7FLG9GUHayiENgmrefgQ1vS3zOP4cW1hI7PVTDNxytSOGK5gSFaNQ+3gsqjZ67/+KgmTrdKjLDBFY+7UqmiJxQ8jfw6tXRTZy2/K4g0gQi0yA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by PAXPR04MB8814.eurprd04.prod.outlook.com (2603:10a6:102:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 13:27:00 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%3]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 13:27:00 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	edumazet@google.com,
	pabeni@redhat.com,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com
Subject: [PATCH 3/4] drbd: use sendpages_ok() to instead of sendpage_ok()
Date: Thu, 30 May 2024 16:26:25 +0300
Message-ID: <20240530132629.4180932-4-ofir.gal@volumez.com>
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
X-MS-Office365-Filtering-Correlation-Id: c72a5bf4-f563-4af2-6311-08dc80ac2feb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|366007|52116005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0dUSThsx+paOeDmM6vWFAIWw8FYzn/i1UK2So8ziSqnjj6LB+RMyqNPzeuyc?=
 =?us-ascii?Q?YfNPZf9D9EfMOgJGhkRPC9lYMdvXnWTKT1l4bPgs2Rc7brkSsuXAbuMhO6ZY?=
 =?us-ascii?Q?858aqeMupTV6WUX3+3NgYsoqFLjhbbFzxYht2qZp3ggSBQvJyxFzkZM2TbIc?=
 =?us-ascii?Q?KiKK7aoDubyykxhU3FOY8C+ogxebNXLkGpqGbcSjHX70ErR/TjzArFDGcw/9?=
 =?us-ascii?Q?HhFupj2J6Tn4ttlnDemVETZZy13ZFlqi2Fu2i6tW98pw2SH2FuMdCFRdhRhK?=
 =?us-ascii?Q?BUAGbycMu7L2EGm487oKtcj773IdsUWRIKi7pwBBSXwl+Gm6oXHq+vIP1WfG?=
 =?us-ascii?Q?7Hk0yVDhH8mO5+A3UqwvRDPxD4edVEWagBrNAeoM/bsirA2hDV4f5SOYbDf3?=
 =?us-ascii?Q?pNgG/mVI1QqES2T2u5YjjR/gysAdAL5EdpDe6H1TUtkZr4dCL2MlwCj8FHUj?=
 =?us-ascii?Q?iPtbuc6Ym4TjyyBV3x60A9qXVw7ea5Ef3s6/06SsrbYpT/nSnI6+LaFN+ehB?=
 =?us-ascii?Q?Smk8Ln4IPvlYvOWWAcldy5PiyfyxxiGbm1pW12VxF0hyHW2ltg3KR9LSuP3L?=
 =?us-ascii?Q?cvGenS9b6Y43aRP1udcHD5vZvinnhzLKDu2yjq9wD7zaA5jBhlCs6XWtNg1L?=
 =?us-ascii?Q?lcdko+7yQTBaz+jvH5w5++6axj4GoZaIILR9Ep6ck5BP/PHX0MUe7bkaxS9r?=
 =?us-ascii?Q?kPAUpGuxlI5YmYSne6Xxyh4dWVWWOASuRUH3jY1iAs2PJTWhCiUSrNBcwRt7?=
 =?us-ascii?Q?ZHbks2PGSdvtYxMuDsa23Kto5Minqf9EMNCbGEkEJQe+jJCtpjmPTtkHU8GX?=
 =?us-ascii?Q?4o/VKloBS1fND5480vah6w+yW+Jq+T74xV/qXIeSC4i57i2tkJnrbbRJgi4Y?=
 =?us-ascii?Q?+aW6J8mJ8MSZHykQCwkiYWYyggFAK68Q2+X2Hfh7XdUO9mZ1gI4T7HUWaEW2?=
 =?us-ascii?Q?/j6uixS8ON9c2YkljdPqxMj11gaTCHjX5qmVDzAJK3K2tOUXWT4CqCr99SMK?=
 =?us-ascii?Q?ivD8v66hBtIAod6uTzhgiBWDvQVAz+6J0apbiPtuSPokI0rzwifoI9chil8I?=
 =?us-ascii?Q?h/U/kySygv7qb59UlaJIwEBRmooQpNqHhe1q4Uma82jENbZj7KEJWtHifO82?=
 =?us-ascii?Q?jmWEMxyby5vrTWtZHpmSpxK2HjOW4lWgVZTkAolyM2+bafHSAVvMXi8/g0s2?=
 =?us-ascii?Q?camc2FtD2+ntQ5JjT1M/GskFw+OH6oHVncrWNesGfYef7tZEZNS+Hgxpeqky?=
 =?us-ascii?Q?0jaaOwFLXTmeE+e6iLfyyjG5Wgw8IxjpiK1aaWyMpm7/Ejzo7mOEnVxXFdYC?=
 =?us-ascii?Q?3idcoe2Vmri2L5wbdnq7UTvHtMp7sNws3XsWXS5npC91SQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(52116005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hK1FQ4r0SWg9mRO6dHBu/N2kaV2QK/JzHdQ49qqXkPN68+Cjugn8zb0Khdo4?=
 =?us-ascii?Q?zhLqEA5luPX6j1F+bVvItQLAYMxn37Dm+XnIgJ2baSSP8om/VS8VVxfhcBTe?=
 =?us-ascii?Q?5rqNcCN6ii7N5lMJpAgpXs+y6u7+QFT8qeGQzvfTbWNMoXQdNPJbLxMM2lUJ?=
 =?us-ascii?Q?JXiUDNW7Nbvc1GKCSCqKz/YTnYNaJW2uesmy36e8b4kIGAbnQmluOed3hXg6?=
 =?us-ascii?Q?AN9him1WGJt4mDxhXX2bbpuNMvQzgsp9s45r/8V0rQkYgHekqr+twfInC/K5?=
 =?us-ascii?Q?IzWraRv8urbBjDCvZUl0yddecZPK9VHARhuJeGw1ywdNTz5migCiSgMiDJLy?=
 =?us-ascii?Q?jF9gMPo7LnrT0N6zL+wKpfOqnTOEmXpMqlZddkmWEFdTS1apDuP6YOMvWLTz?=
 =?us-ascii?Q?VaFJi09EBx7N0qdyAZAdAu0m82W96vk3jHBLG7z1CHYtG02IE0FTuvdzUu7I?=
 =?us-ascii?Q?LQsyLZa0wBj7dqdDjvYuWTZmsTtDRUnPmq6t42BEWnsz+tDOClr2btJRLuyz?=
 =?us-ascii?Q?tbPuCdP8skYRc9KnjOgDT/SaXP18w6vMaVPaF0I+Y7L+326ijPoiILs8K1A2?=
 =?us-ascii?Q?O62KFr7GmMtWruuV8VMQyqNRmXJgIsI/dZ6GdH+iU2U4MOThNfkDZV3Y60kQ?=
 =?us-ascii?Q?AmHD1q+/Ks0Psl3TXUi7bOsW0Xo46aLsaKoSvUr3R0qctjDaWY3wyymFPRl4?=
 =?us-ascii?Q?PZnGpZTQqlLYrZSaRx1Pbfzm2yilbBcTuyjImDhLH+uZsUp0zwpB9kVDgOkk?=
 =?us-ascii?Q?2RPcWQbZWX62Ity5kqlXQGbvkHZVCf2Yw9PofXzibk58dxzzy6i1yJiTlwAT?=
 =?us-ascii?Q?r16WveBV1uE3pGHDYCYOh+tjlrCuJXsC7SgUt2iHtp2JNIk5vatvGGXHTe/p?=
 =?us-ascii?Q?NAohHMSEo0xzNeQbaKa1WU1WrGy79SCFOIg4gZDc/o2lqGthJR4bsL8BIYsF?=
 =?us-ascii?Q?WUJRwXStsnKDhT7Yqbo8yY6Nu0gsnkRBLkdHmhwIXRASr127+3f03hkUjvRj?=
 =?us-ascii?Q?ya4uu4dkzuuZ5fdaJ5M4DSMkFX8QgsKvF0Fervxc684gC9KA89gUY2f9iBYR?=
 =?us-ascii?Q?Y2TEC88CqxqDD9ToeOgW0VOWJjL0tyeHX9ysQhTjzNaWI1ehaYxa/1uRAGFV?=
 =?us-ascii?Q?+RN1V0yhPO2SdvliN0vJdpeWkeAM4dRlP5m53uvkfPr+Jbho3QJi4nX+qtBs?=
 =?us-ascii?Q?OWGK5NsEIn6tYwuv1C83ODBnWmzV/yx6HhGRJFdwaZSM9D7qNwLKMseqv/ds?=
 =?us-ascii?Q?cM9fwBbJivy0cuY2xeMiwmUBUJ/v2AFzlgyfEp7W6Clwr0NlxeUz0PtKeBqj?=
 =?us-ascii?Q?5DdZ8Bf28CVIzCy9DSCNUW9VYCCBX3x/P3cLKJ5uvr+ysvqgOuXZfmIM5nuo?=
 =?us-ascii?Q?QZ0F6tkGbUu1TfzakL0bYCtIJUPyIaXxOX/HZVbo9QhIJhjeqMcmOf9/XEeB?=
 =?us-ascii?Q?tsw2THkQUkrTQKjG6W9OZF0hKZJJhUe6lX4Wl6XBMfoRxJ8zffobV1H2/f26?=
 =?us-ascii?Q?DEWSRsF38M4QsvkOZuB1kqW5mFJwaf6c+r9jQxehDUUV7yVxPqibuAHUm+7P?=
 =?us-ascii?Q?vD8zU5m5BHl7xclMRslTZV6kXNdk71jl3cbE2zcN?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72a5bf4-f563-4af2-6311-08dc80ac2feb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 13:27:00.7379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1gaQRCjkAfJbNzjEqspmGGjjibHX2ML6ytmEfBBgf/4xWRefDgikVIin9rm+Jtl6kgZPknaNgThKyR5w+xQgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8814

Currently _drbd_send_page() use sendpage_ok() in order to enable
MSG_SPLICE_PAGES, it check the first page of the iterator, the iterator
may represent contiguous pages.

MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
pages it sends with sendpage_ok().

When _drbd_send_page() sends an iterator that the first page is
sendable, but one of the other pages isn't skb_splice_from_iter() warns
and aborts the data transfer.

Using the new helper sendpages_ok() in order to enable MSG_SPLICE_PAGES
solves the issue.

Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 113b441d4d36..a5dbbf6cce23 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1550,7 +1550,7 @@ static int _drbd_send_page(struct drbd_peer_device *peer_device, struct page *pa
 	 * put_page(); and would cause either a VM_BUG directly, or
 	 * __page_cache_release a page that would actually still be referenced
 	 * by someone, leading to some obscure delayed Oops somewhere else. */
-	if (!drbd_disable_sendpage && sendpage_ok(page))
+	if (!drbd_disable_sendpage && sendpages_ok(page, len, offset))
 		msg.msg_flags |= MSG_NOSIGNAL | MSG_SPLICE_PAGES;
 
 	drbd_update_congested(peer_device->connection);
-- 
2.34.1


