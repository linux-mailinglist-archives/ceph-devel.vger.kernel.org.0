Return-Path: <ceph-devel+bounces-1325-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B9E9032DE
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 08:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 130A1B26435
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 06:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E78172BCA;
	Tue, 11 Jun 2024 06:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="XrDXE1YV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2113.outbound.protection.outlook.com [40.107.247.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413D1172BAB;
	Tue, 11 Jun 2024 06:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718087802; cv=fail; b=AK80g0yT1BCqU8tCNjlhLg625veMUHDj1z+wdacf8bNIYv0hMTnxQCYnE4UCYWDg6JGuK0jZ/xKaJO7+J+iJ1CaP77Yf+rK4S/iPh7lFOuM7RbPiZkVCJaJ/4VuhcekEoHpOMcrDDUiCclPyxbTsEN2Kb0zjbj8eaJl4V5yFXhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718087802; c=relaxed/simple;
	bh=FAVkWpZD9mVkfSM3Go9hINDMlbcRhVrmFZ4QA04jCVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Abji9dy56RwWCLmspOnbKWoXhlqjdbR68r8BA/Q9VtaSWVFq4P76pa1d+6PGs9abVBGnaBiPcdIzuUox5InOC0REtbt4dczs7mxv0CWNtVZObxR6KosstanJqWBJYiHAG6GvKW9X5nhvfGzQqFxZnF/1qp7URdDtrkcqVcxicNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=XrDXE1YV; arc=fail smtp.client-ip=40.107.247.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnLIrMb/qzuZmwus9mbIJaKcpabiRjIpCXKbaMKaKCTMnaToMyVUcVkUksdnaY9YbuUbwKUccNzXytC1PrpC2PEpJl2uEtbSVFTdcGp080fYTZX2QvSXJG6kmUSGh0P9WZv2dtqWZ6Sp/b7iBV+0tCpFzmua0bYvD+0rwk18B8VUYs9Y27vNia2vVKrSV4S7EdosbpxnXTUy8OCIK+EAJzeLFc2y6bn/mV2FDnbY5VDBSmzC2GICFWGjYaD30AblEorw9phbhYPgLwuRDHv0E4vdhrusrD7q3LtLkAct2eDIFkIfOvfDzVP6oqG9vG/ls0R/akAHX8nLe4agIpN1Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9SX86DQTOJ8HdXRRoou33jJOY8pcihenVKw3GEnto/A=;
 b=JMQWNOPUSCk/+GL71d4B9o3C/UcDaNfrInGJg4p5USVojPLuqACPcVcCVhszvMebD6aR8ZCasG/66oKKZptX7QUMNzbsbqH4Z5CVqWepss4ZP5VjN3eHJev+P6L20eQhQUncMt+YX6bIoR5gH+dBwEQAj/aH5NULau4u5fhD9bCyIUimt+P9ocvTvt9RetEYFOMc07vLqLQQ14oneJAFJbHfTaDFbX6K44QqhUjamQu2PZb/fefgHk+P61Tpqdj9JM+QtKG039vH2nIFmj9RjKAhP48xzMBncmByhb04z8Qkvf38lnQXaCEsyWeXzbNv7aMSp4HY7QbyNN9vl4K8lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SX86DQTOJ8HdXRRoou33jJOY8pcihenVKw3GEnto/A=;
 b=XrDXE1YVOMb4WZGCK61ifAGcu2ROfYnqziVvhHpJP5K1mqnUAvZ0FKbfR0j9BQOmiYOmHMb3AMKSfpqIeczgCGwbzrZ2mC5Fmf2MsjPhefg9PaYMGa000SLJLHuO0V1NCiEWKcSu2rMAaZOSYJTfqvzBcoqxVxWZnBoqpj0Bk8PyFRVjl7nSNmLqDsHHohzycW8Mk9I9EAZNvNc4h1ehv5CHnMd0nRnnXNIWjcoKfbEbM269JF0r22F+xEN5lV/BNnECjPR7T5x8m8jZQrzomtVOY/bvSpolFUEP5c343b7fVcJgGTu2mQNEjnF8AMQ+/hKMhNc4Fv06UgG7/KZX4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com (2603:10a6:20b:8::21)
 by VI1PR04MB9977.eurprd04.prod.outlook.com (2603:10a6:800:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 06:36:33 +0000
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371]) by AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371%6]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 06:36:33 +0000
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
	idryomov@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v4 4/4] libceph: use sendpages_ok() instead of sendpage_ok()
Date: Tue, 11 Jun 2024 09:36:17 +0300
Message-ID: <20240611063618.106485-5-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240611063618.106485-1-ofir.gal@volumez.com>
References: <20240611063618.106485-1-ofir.gal@volumez.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To AM6PR04MB5110.eurprd04.prod.outlook.com
 (2603:10a6:20b:8::21)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6PR04MB5110:EE_|VI1PR04MB9977:EE_
X-MS-Office365-Filtering-Correlation-Id: 41663eb0-2a67-4b1a-9119-08dc89e0d5d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|52116005|1800799015|7416005|376005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b9CViXbhOZVlT6bJTVcX00GvjDo7xg3kaGDtQ/u1Bt3d9bcy+79+h9FHY/qZ?=
 =?us-ascii?Q?NrIiCAuIP1ZdpHWkuhQOrrRA6Z1sOS1nT9gnqs2vgDRc/z92qiERVqGDR+Qk?=
 =?us-ascii?Q?i7Py4gsA60cuCKgBtJ2f4N8UEsTHMKjFfdT4/rY3fwLLM713XfUfgy5J+/tL?=
 =?us-ascii?Q?sndqiPvyJ2K2pfrHI1gMBvX+ubFfoD8up6NjQgJn2HbUoxIIwlsGaiJRycr7?=
 =?us-ascii?Q?7UC8+pb/ZAX7KGYJhXj+mwWFdGJG5mnACeSiw6ztzJQExL3SdHQxaHsp0hYZ?=
 =?us-ascii?Q?Z2Ec4FFWfQObbJKcWd6WHHYgRJjTLhmDbiqT6+3+tpRj/3yVzz+gsKgO/58k?=
 =?us-ascii?Q?GsF9DJN0DoqP6lZOyOih4fSHg8S8jvSdulgnIu4HHdZ0PC5KE2bfTnanQ7f/?=
 =?us-ascii?Q?nzQjE9+bjDcDcAnB5eYoLe5EFUNCLiQDZJuw4R5Q7NM62faYFY3+kOGZagK9?=
 =?us-ascii?Q?mP7hzGb8K/eOfXTe/VROTk0dlnGOxCnZEbKH5O1XeA51GpRsvTbhkhffrpvp?=
 =?us-ascii?Q?fs9IyI31WMxqMB6H6UGPAstsUivmv2BPs4AWXNzFJDPGSdvx98ESEaanx+zx?=
 =?us-ascii?Q?kOXAJbxdHXdqn1SjuTvc0HtJe5CSuuMxfLDcATR9oAjzhAjGp/caEES8xyIO?=
 =?us-ascii?Q?yzhOzKxw91BGkwlUWxMVivuM1t7vh99Bytthnig+RIIIwK/4LAJCGFhUb0Dr?=
 =?us-ascii?Q?13UQwB0KyF7Z/W1ydqwSl8/fnz8bytpycVrZdlWPkYqMj/zfV2DOeNR8/4RC?=
 =?us-ascii?Q?k/B8i781+AbdkcxLIL9kXopH/wsWXm7Rd99OVUqa0zDiK6vl6JIPxC0/LcCe?=
 =?us-ascii?Q?OYeYwZIvUlD9Tl6JOuv1v0dp8DRAwn5a9BcUVtRUuo81q3eyECSdxWldK9DX?=
 =?us-ascii?Q?sGZ1pY4DBanMqMPPADS6RvwQeeFlN/MVtwu7YfwZzFNJzspEYAJWHbVB4JMs?=
 =?us-ascii?Q?Wq9hVtQ4okL7j5FYt7QK5BNhxidAplaI0GhgbIlrpG+3xze58T1AOWfPBVDW?=
 =?us-ascii?Q?yWZ+wSwNZuCKVxR6/kmKJg0lHp6nI3TW2+t+uUPuHKnGRyswpLhMIM5nJJu3?=
 =?us-ascii?Q?rPcuil1rldPCgMYWLI4oVmKnUm5Pd2Bre/Fe3EQYafQcu/1jau9I6uOWY7Ha?=
 =?us-ascii?Q?9tiPD3F9q4VCPJf+QbQoRQWD3PlFDLVeT3bhtzfA9dEkqCqrZSDT5Y1elDC4?=
 =?us-ascii?Q?MKgsZTVHGanN6ez0aw8plDPALYOPXJ5sTmrBa9D4nEYyWiTA6rF1VPr4l8aA?=
 =?us-ascii?Q?Hsh6oNwT7lcjraDBTuxAd8HV/33mH4B7T1CP8xs6BOoUB7J/hmBkt/jhcONP?=
 =?us-ascii?Q?ZQc0bYDcY8KZRtJtu+mVLZBDstvDxHf6kHruigelA914ScAm99HpnwsZOEpn?=
 =?us-ascii?Q?499cMl4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5110.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(52116005)(1800799015)(7416005)(376005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fxmXtAo4VlMhYwBa4gKJEWYimaxSAA+ptCtWEurPpDxnyn0bZauwkk5iStj2?=
 =?us-ascii?Q?OTM7WQJGl6378+u305yY9/WPKEsTg5f/KDLnsVurLwKyHv3l1dJzjPADsCkk?=
 =?us-ascii?Q?1st98RoNY9HQmJLZ7ip+yswxk/mpgajBiaMoSiyDTUXAjQHwKrp+6zmEj6Xc?=
 =?us-ascii?Q?xVJ2rhmCplkEWVCidWZTFvktuHnkS+XjsmKkMDm7/+Uef1fAovxupyV4fgsP?=
 =?us-ascii?Q?OzNrkRuCEhTfS+SCg3MNB/s1/Q5QZryus4XjP7jCpfyy4z15ZZ0l10WHSix2?=
 =?us-ascii?Q?sRebx7EmhP0S8j+dtVu43+wd3KmQXdJ4bF3EvYQHPpouIWq5kXzwYvtPaipc?=
 =?us-ascii?Q?12EjInFtxK+LSK7/bFRa5APdVe9fLAxh231LAN0g8WWA6zlMszX/DVYjUVdz?=
 =?us-ascii?Q?XGP2GjsWw7o+GvUs3MWDzK4xrMa6fD8wMZAX5ZDF48XzjSRSs+FIP+FJEEVJ?=
 =?us-ascii?Q?+3y8QMAwnM2wxqO51C9dAOHIOh548GEpsC5CC/KJvM7toJ2KMlnuFYOvuENL?=
 =?us-ascii?Q?RM0ltqL7BjSvE3gszD2neLyyTIx84QIBccdDDM2L7sAa/utTO8jTpJnzbXXG?=
 =?us-ascii?Q?6iQYqDDbHX6nTSsuPYaAqXvxEvtvGkst1D3FLZkIxtmGI8siqBReixDsy/c/?=
 =?us-ascii?Q?ZUAQDg0iv/OXQ8SzQQZ5CEylpYFH6xh8fAcB56fHHJd4I+lPwAF0LNrs1Ty5?=
 =?us-ascii?Q?NHZ0XmdlnOClAiR0CBJkOWwsiGh641Uwpk87EIZQW6LjUglQaePGjnA+zjp6?=
 =?us-ascii?Q?WAza2um8k50lEVLMzHO452HXEpQcxo0wj4jxbem6VIbDm3giB6nGoV3yMTMK?=
 =?us-ascii?Q?D91ztYZ0xApDselupqGABq2xmnISB3sLqd67H2JMEF2LkPRcyvX2z3rFcuQo?=
 =?us-ascii?Q?Cqrfpee8/p/XJe2XaIANCZzFvQQ1Qp4/h3wqgSssjFTOwsi3tjceh8b212KS?=
 =?us-ascii?Q?nZnlDy0W/EW8T/lgjJ/Z7X2X5EjMbtKBey5OVaGod/VOQHMgBeq0ON9HhkUt?=
 =?us-ascii?Q?cXY/6VbsCGUnhnW3TqD3G+Uz3G4gV5ZiFUEUbW7jnVVNOJN7gpFUrb4zHDX6?=
 =?us-ascii?Q?Z257M+NDBdYfSZ9ReZsFIu2ViIhHc/Rb3PB/FR/Shqo9/T+eae3UZ6nHezCQ?=
 =?us-ascii?Q?Fx5XSJJ4uNAortZxdYycvp4VXKmVe3h5bXLS7ueqqh/PBxDZLuwYx5ciB8ka?=
 =?us-ascii?Q?LIlTvslYNj54V2WXw1rDsF7xxpK5zCavFyElsYn3BB031u2SB5bcYDtCX+mh?=
 =?us-ascii?Q?ffRYqN/VjA1T8nzcLRS0DB+qgqoy4pN6ZNR5axy2IE5GhMzmrXZhR1t8hR5g?=
 =?us-ascii?Q?iro/4d4u7DeCROKoXaOk4ndiiqImycrmzJq1+zCtXayXhF6wy4k/b0brveSF?=
 =?us-ascii?Q?A74CMbQiCfg9i3BU5pz1hfXdlQ9xqZaHmfq9e4EAQx2tcCVDCs1RDjE7tn/C?=
 =?us-ascii?Q?p+tYb24KmZn2Lj8w3cqdm1A0pmP5KWTIbGfJTvySzqAc98AyNwrBj2eXMzo+?=
 =?us-ascii?Q?8j+cV6N+c73rNfw8RZomFuPy+mwc5JyKNV895QaC+uIf7Ml9uUc5oGZOJMCH?=
 =?us-ascii?Q?fh505T4fWfGzrPQNWZloE/2P3EV+zc17kFPK2cup?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41663eb0-2a67-4b1a-9119-08dc89e0d5d6
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5110.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 06:36:33.3859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHhBJ7d6GZLSjpYwF9KYK8lSRinYPKxmy6qLh2JnttMn5PbyXcTWFh0KwzaZJ0Ex4JUdHouD471I/or5NZoMHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9977

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
2.45.1


