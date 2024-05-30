Return-Path: <ceph-devel+bounces-1192-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6818D4CB1
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 15:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01F701C21B2D
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 13:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519371CB30C;
	Thu, 30 May 2024 13:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="X+SCcUG1"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2118.outbound.protection.outlook.com [40.107.7.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604CC183996;
	Thu, 30 May 2024 13:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717075620; cv=fail; b=j1bV1Dwc9sz6kyk2KjvcUD7Wyqe1Vrh7pPIPc6P7mlrNRIaA2Sgxx958HB8xgwXHqJQMZQlt5EbrqrxeQZ9opDMaTCIHbgI2sdSsrxt3YrXkGFYDfTjt20cRuv7D7v8/3O2RQa//QOQVzi+9IZOItZgBx9DoOY0xSYOOr8Ir2/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717075620; c=relaxed/simple;
	bh=YJD+FPKgbmJBQczz7F0n2W7TR14NqRIo6Xol2gzLjeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F/Do818NYfJFm81FO6zHVv/rUDI8X5Md80aLjqM4xP7s9IW13Dkax05nwmYIQ0sbQt7wJXhsATRLQbGn+HbstGsEen1sOj7RWmi+vkDMEzetW8rfxWyX082sVbfBLpR9ojVCh73VeziN5aD3kOOgCsP+mFKpyUZbSa4McMOcSCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=X+SCcUG1; arc=fail smtp.client-ip=40.107.7.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGje6C/NKvWSrZF2am7UnlK2nNtDAfvxfkOByM+EN9m6pl0Cf128mMj2eg1lGlzGK3wWhiGmqhi06V4512hWIjc75KmMyLZgI2GfXU+qTf+nEffbAS0drrilIJH+gsxUOHUBUPJBXJAroaGtlkf2OXWCgrX1NwWSW5+R6GEQPoegzGRo2m5bu6Zbyeo59mmkOLwwG+N7CmxYxos6DSyQX1M01aPfbcXLZQgUogYeaoCbG53wRwTPKAEtR6C03hqEEiokCQUd419IEhN3XrbaPf82zYySJwPDHKBBZdP1FBDUbvXGPH063e18DzHbWwpy70S7N7eNrS9o6Z0iHq/gKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6CD2Ca2T75xtBaR82rnXRMIKFDHu6ZHcG7APYtvi+I=;
 b=IZWLcg4PppxgtIT8Uj2AD/slUVzLDXXcgxoC2td2QsaGu3EFF0l7FDJ3TiXO90gGdJb56+8GEksn4WI5tcD1Emd3CIZWVtMnknXubkno5YB9RWdl6JicbSE0/fGoM1FQV5S9HwjyqhLvRJgS4wx3GXHgYIr1nVKSbGMMvaGDQgKQYZ3YXOLiqp4Mq8Lh/q/PK13shWQi0f6T5MgMXha2t8sv0TiOZt3tvPwdESgmjKExDPDH8oojsxW2elwZzpvmhjkxhGPjJKOeWkqO/18/1fagWLexbXh73iCDR3RW3bOnC/TYps9LCApF6d+UF3Lrz5LQeqpXXeQtvqkfiCUU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6CD2Ca2T75xtBaR82rnXRMIKFDHu6ZHcG7APYtvi+I=;
 b=X+SCcUG1Tenv3FuXjbOJSfgZdduTdS95ZXJy+kMZxDh5rEOLiMm1HJnIHUewu96p7kh919f3mH28xEGlwFZx6yYbt5/Yy/0JAnu/QAqZJgZEZg9g9DM2iOoJzaLa3nrA34QF4UvtdE28sLby17/om7r7duqx8AYjEUz/vdoZ2WfNFF9ocgSUj+k66wdTgxIiMXXnpLNa5j7VJa+ynK/JAHC3IATdd6ErKYUqpazndrkWw2Za/ZjExQGX4LGoQjSooEIm/rBKZ3yhQLTtCv7XuaClYjHpTXj8HOqHNonS6lnJu99lZ9dTvsOxNC9k46gURXHgIMUz+em0rmVJp3cz+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by PAXPR04MB8814.eurprd04.prod.outlook.com (2603:10a6:102:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 13:26:58 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%3]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 13:26:58 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	edumazet@google.com,
	pabeni@redhat.com,
	kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me
Subject: [PATCH 2/4] nvme-tcp: use sendpages_ok() instead of sendpage_ok()
Date: Thu, 30 May 2024 16:26:24 +0300
Message-ID: <20240530132629.4180932-3-ofir.gal@volumez.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7e14c051-7083-4daa-6d11-08dc80ac2e6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|366007|52116005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5RUiHKm3Cisyj569Zo5cMADn7EN3vLWe7tr0pRtvOWR50fYwbtf/zBsitW0C?=
 =?us-ascii?Q?gUvc5rrGU7GgD2kCPTlzKbzA75ATCVxcaS1wBxyuN4JVOyAG8NUHgIschJHc?=
 =?us-ascii?Q?GdQoc1pkV0lC09G03frE9tSxZ6GJoaszZkZT5qfIAL9pd/7RBiijCE6rmlUS?=
 =?us-ascii?Q?0fH6WEFxOg4CPXmb1yWB5XcCEnwAE2F+I8mcpjycE9R90elEyBR0CpVnAWtn?=
 =?us-ascii?Q?/NA/8Y4vk0gvb8A7hUgZuforFZ6YpVBRJBo8ywvy0w+zKtiiS/44ghzeejA1?=
 =?us-ascii?Q?0eN4XNjGecbxrWtnD0PInCpCh3xjFePEsB+OEfs13RjfczxpPRbVslJKoa0W?=
 =?us-ascii?Q?PCFDYUyoQ91b3DgjgzQzO94goEEkdZCXJ9U0kCBJQkmrqzirPyszPxwegFmx?=
 =?us-ascii?Q?vaZaXtIBwbtyqjh4MY6cptrmCFxCGxoLtAKJnN1GgjL91B6JXTyBUOi0yyRw?=
 =?us-ascii?Q?O1v44pNElePShK1vSodwzsUTGrgDBSEkjuUQKa078efv3Q3OJubmfavyzf0U?=
 =?us-ascii?Q?7LsxdshkOoDEa72PwVACv9ErCNDcS2amyxgpcLBSQNfjAJE1Q05rh5BX40Ju?=
 =?us-ascii?Q?uwylNOAGaQqX+Rh/h3ZPvJASujF84tK+KQUOCt/FyYuSQYf+3mP19pV1N2XH?=
 =?us-ascii?Q?LaAMpfS8tMIE8/+0W8oqha53xo0eH32Sf7JgOrMs9/dr2bE1AAc13cWk/9no?=
 =?us-ascii?Q?WfTcjIjpOq5rGWZz6tNwkrg8d4LRlzA3v7eANcqvpUfhc3b102JgTQtN6NxZ?=
 =?us-ascii?Q?+v8sAX2MnGBjpAmB0FitXKt94dx11aBBgsl+T0euYZVUJ+GiFZIE5Y5KyNY6?=
 =?us-ascii?Q?KQwSFpFuThxrlRBUCpYApxhrP9uX/c5PsiFvJFBGrQqcLnn0qkmdx0f6AWnz?=
 =?us-ascii?Q?ATuX4j/N3AfNlmxLK4mb1aDV4VwnG/CT7EVSzGlRMA8BL7YxZh6iq3k4GKEY?=
 =?us-ascii?Q?4Q2PT7wBhUSHc92n/etffx0iaMhs7ARmlrVrZPTyo1wUWeDb8hH5KlL8HvvW?=
 =?us-ascii?Q?WGslgUw/zMcQ7P/y9YaPNyqtZSFRcrS0Z7wA1qcmlfTesrJB03tFQcWCnCB0?=
 =?us-ascii?Q?QiSW8btNO66+KsCjQaP2jv4Lgxs60HhtiWzbLv9ygqdLiO/rPmfXhtKjbl7U?=
 =?us-ascii?Q?UN+p9YnsDiQIY3YYBTjZWO+oJ7SFRlIMgK8WSBop9SyUnxikh1PO25qkCV25?=
 =?us-ascii?Q?JTop5y4OGHBjfJaxJqF7ZIoSQN8gRqy1yktBzxhJ1c7ljsrNZsUqL8g+nVHx?=
 =?us-ascii?Q?rPiVxKDsorVCGKKqCZr3DQWhjgHJFpyA0O8skbU3qvGl/udkFw4bBTw0r7dn?=
 =?us-ascii?Q?ud24ddU86pL15v0bCfBK/UJ6Ad8qXGwknLxYMky6qzU3HQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(52116005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kPXpXVsEndokRDFOnDbK11qcfFgzaQ8fWbyF1+0xH38Pn1gRnGonY/X1wRun?=
 =?us-ascii?Q?Cqowqc7qQIHGR2i+lr54ZB9HAFXXT0i0LkgtbBBELRu/srPmwawLRmn9PwWu?=
 =?us-ascii?Q?+rD7a3En3RYM1C5TvX17jDx1ymHFrqYKmY+TBa+ffyGrwzTmiCj1lrywEaPH?=
 =?us-ascii?Q?hK2nfeFvbhRKnFo6ETX3sGdHRW3JOsDVUvHcBdBDv9ssEEzZvzZQfO2yjsEE?=
 =?us-ascii?Q?HNNIRmsXS8rTzzw18hH3sIuOYtD110WMJ0lBM+mTkIvXlJc3/TMmDjQLLo7q?=
 =?us-ascii?Q?ALnQDs9VL0/9ceXaqWG5yweA07La3xurswrFnqGQDCkBlmt7Uh43uFK9CI59?=
 =?us-ascii?Q?g7w+yqp6UQG0Hg/rHXuUsDxLn5dcVnVfexICkKSyL95BystW1PUm0gRBJHLC?=
 =?us-ascii?Q?tlZwZfbtdTyxZdnzSuZLfiie6ik/OXyvt11c8lbd8/yzRx2XGHFDGiZuG95n?=
 =?us-ascii?Q?Mzj/yVPrBrtgSqUMe9d/EuoWhhmZNiVi7e2CdwheiuacS0pesptCLW2wRmwu?=
 =?us-ascii?Q?hrwITkCNh9ayPGhrw89b+ND8FUdPCj+C8y54B9gdUTH5X1ZGgU6GzV4oIafX?=
 =?us-ascii?Q?fuR3dGgkbOXfUVg5ArWUc1Lf8u6YSHVPtiw3P1sVeUvLlW9tFqfyI/Vn2WLK?=
 =?us-ascii?Q?FOteoI4G3Eq0iJ5TP+6LvrZ1fB8f/+NuQGgf+zgPuocU7UcISYArqgXoia4m?=
 =?us-ascii?Q?KAaX1RSMiSJJjKnZnAbzNjIN0WluGsHg/LWytOMqCaMdZYyEAV1VNeAUwZwg?=
 =?us-ascii?Q?9IWrEt0vLHx0/F5bM78txsd/6e/F7aLv2M+mqmkBAIc7TIbZt2jfup9kMm8t?=
 =?us-ascii?Q?sQALHAL6EPMFsJQSXDHjMYIzTbm1XM51NiiG38bceN1pn7bee8tqGO4iuZNh?=
 =?us-ascii?Q?ewMVemwkqgLdMpfV+5Ou21CbWyt/P9xkNkf8ZjK3KAeMaaqVDYok162M26VV?=
 =?us-ascii?Q?QZsL+i5gVaKasT2aglwS/86nLatUXsXqUMqih2XisRYLDZxHm8dVvdM5nAOK?=
 =?us-ascii?Q?H7g2+eg5ulXieqkQkJR9NrZyCBlo0zFVkv90RtlTQviYQUZsn66XoTD7lWqj?=
 =?us-ascii?Q?STjkH0AzzYcDQ3I6BdxxHBag4gz2vhAzVqViRzrV6Reh2waKB4EFnyvDij92?=
 =?us-ascii?Q?ex2Xr5wNqr9uBwqiyVKQ4/K4C3TjsEGPMJdTe+YjrC4vIY/HCOBwPgBOBzRy?=
 =?us-ascii?Q?rHl2mkO+zn8b8aT8MVAu5jA6MYRWzhYngnInw1gxuad+eeFLkYt/AAj3G07x?=
 =?us-ascii?Q?xoOE/I7Cpu1eIU8I5HUIQ8Jg/WqaY2XQangFwB3ZHSqlA43z7rhpKhKkcwNc?=
 =?us-ascii?Q?xffYRMC5NwfhNTYGw8QYkIuVFMTuQ7yoIwfgru7MThfMypSHRBovEGkxIIxH?=
 =?us-ascii?Q?3qxCbcDBsCVjhaq9fOZRqmOoLVhHh/ucjo+K/ylOY4oGQ3i0vdYlAyRLfXny?=
 =?us-ascii?Q?7X3mMh+ZnkZHglh2kGlCAdRQR3w1OyDVR2C7IQ+X9RSB0pTw+Ab7Xdni0h1D?=
 =?us-ascii?Q?J3mFkXZx8s2BfYHmlXtKp2Ej8dSmvWqUCzG4DXP24yOMb/8DyBdEgxRe2zyB?=
 =?us-ascii?Q?5MdO2CTw+x5Q/TWqk4t078apj69mq0qNK5q3aq8S?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e14c051-7083-4daa-6d11-08dc80ac2e6a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 13:26:58.2923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0xu8W7k5fpDAM4l+a+aDFw9XbM10l8ba2QlotGD8FCi+We+B0WAyTb4ZPAtBZOR4AN1MSRVann2buy+gZdzWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8814

Currently nvme_tcp_try_send_data() use sendpage_ok() in order to disable
MSG_SPLICE_PAGES, it check the first page of the iterator, the iterator
may represent contiguous pages.

MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
pages it sends with sendpage_ok().

When nvme_tcp_try_send_data() sends an iterator that the first page is
sendable, but one of the other pages isn't skb_splice_from_iter() warns
and aborts the data transfer.

Using the new helper sendpages_ok() in order to disable MSG_SPLICE_PAGES
solves the issue.

Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 drivers/nvme/host/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8b5e4327fe83..9f0fd14cbcb7 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1051,7 +1051,7 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 		else
 			msg.msg_flags |= MSG_MORE;
 
-		if (!sendpage_ok(page))
+		if (!sendpages_ok(page, len, offset))
 			msg.msg_flags &= ~MSG_SPLICE_PAGES;
 
 		bvec_set_page(&bvec, page, len, offset);
-- 
2.34.1


