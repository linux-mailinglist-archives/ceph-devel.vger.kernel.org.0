Return-Path: <ceph-devel+bounces-3114-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E518AD8971
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Jun 2025 12:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E5F81887223
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Jun 2025 10:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881152C159E;
	Fri, 13 Jun 2025 10:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="RDSUp6T+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013043.outbound.protection.outlook.com [52.101.127.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ADB20DD4B;
	Fri, 13 Jun 2025 10:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749810228; cv=fail; b=cS2/mmQhKTk6hhN1LKOJ2V2cIZeDaBSHjf0O6BE+G62BezDDrmCaS78T3fNjCuOwRrnocH9z3WDuNo131u/s4KRi1ZncaZ4sXisLD8pKghscwK0+lyalD2v3iqIbX9FCLlNnrehyB7iIlunIKAxBwUePvkhmwI6bNyynt3XOF9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749810228; c=relaxed/simple;
	bh=dsGaqhWlUz3hFrgxaGRl0uA9S1l2xiwLtIu/OBe+5/I=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=COoZe+ZWOSaJd3jHrfEVGOq6dw1EaxNHiks+79hyw79tt3j6vpeIPCIxUdE+2IMUp/o7gX+GZMKBMqlFYh1ZjCJOxH1PQIRn/ORa3qe7whQ4FIus9lsbbnq0laaRv2WDhBSRoyMNv2kTfBbXNwD5zcuRDZom0pj9dbQ7SJH4Yj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=RDSUp6T+; arc=fail smtp.client-ip=52.101.127.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f0SaUQb2YimZs0ApMHOhULCObT1XS+JW/eGJ0lnRShL7pVdhh4Km7UcX5QDroJ6n4J8Uk4xwK/UZcitJsTLUPDZQd64fqfxebP3fUIt9gckXNRqLWE3Mv7PNkgn7WbBy4hW3zFObVcpQdZ8ff8QBdU5l1mvUQ1C6Lo6UV67wcFcJF8H9bYW7X0rFhqZlbAJ27XSNxlEfrj4WG5lrEEResyf4JvbEZAvwTeuqvXex5eJ/dyysbMwPJz1JDg/o/3wHl1OIyYUNUCM9X6kuW0u6FasMY2lONjpqZhN7I7xFu/0bYGNPEKYwtuNf7oi7jPPbTe7rkaDBarwSL9s6usYUMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6n1lg8OesHiM2yKEJo0OTuzLt3M8ed2e/p9rUVaDYs=;
 b=C9+zlN4Fg6r8kRVfQb3LOYOqDBuCBZKpVss8YBUH894xiRutq1z5g9vvriYynsIuJEpMovPfsbvCWJ8Hu/eC/FTTwyz9b8m7glBRYHTx8EDilPQgFTmQCcTFO/qBgeW2cQJhYIcIybwP42SrDia2SN8Z8l+Tm2nSe8C6R+WyXgP2nFylRadg3qRlRtndBVve2NMMkoiX61jG1tcpylS6lVG2yefa6KXbtCCHPEDbl0NsrT9L1lm9HBDj85WgcoLLb5Z0njc58808BVWohh+VNoVh1nhIu4R6GnPBUl3iFlnbK9QAWdaZ7+WL+bIqMW7uGQSinGaGbzVMHPPRcwa2Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6n1lg8OesHiM2yKEJo0OTuzLt3M8ed2e/p9rUVaDYs=;
 b=RDSUp6T+HxBwV6JvwtqLSY+RyiASrt+WZTfedD/MHAqoxABn9NobYekBTZF0oeNlhQgdjsAocbiNLHjKA++NU2JCg1SkhtCSz1utyQ1dGRpaV1Cj6R5E/VCJEiOlsUK/h8apc7l/SQoaKzRzk8mqyIQvhPXEvFx7m99hORwMvG8Zq1lSD9ngr75cAVxbLhSTq/AqKbWyi5mygjVbOnuPIYRjHfIXYRuXuqGWyrfam2EXyukiGqjxE/rlEoxF2gpW43y2Ph5Y++2orgA7lOFzyAKzWnluDQGPR5wtj3DT55JKNGMKvYJPDTvsQP6zEqA79wNaF8SJZX0295PnPJKyyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB4802.apcprd06.prod.outlook.com (2603:1096:4:169::8) by
 SI2PR06MB5018.apcprd06.prod.outlook.com (2603:1096:4:1a2::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.24; Fri, 13 Jun 2025 10:23:41 +0000
Received: from SG2PR06MB4802.apcprd06.prod.outlook.com
 ([fe80::685f:929d:f06c:a349]) by SG2PR06MB4802.apcprd06.prod.outlook.com
 ([fe80::685f:929d:f06c:a349%3]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 10:23:41 +0000
From: Yuesong Li <liyuesong@vivo.com>
To: Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Yuesong Li <liyuesong@vivo.com>
Subject: [PATCH v1] ceph: convert to use secs_to_jiffies
Date: Fri, 13 Jun 2025 18:23:22 +0800
Message-Id: <20250613102322.3074153-1-liyuesong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::23)
 To SG2PR06MB4802.apcprd06.prod.outlook.com (2603:1096:4:169::8)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB4802:EE_|SI2PR06MB5018:EE_
X-MS-Office365-Filtering-Correlation-Id: 70fd12e9-73ef-4d58-af91-08ddaa645e18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9ZAfYnj1gdE0HldzUk7W0+nsWVkIrM3SX2yOLauqNLJThi+0KxJx+rvWq57a?=
 =?us-ascii?Q?Exk6hvHIk794euBZwrnc+JrDgZSF+A32K+DrINw9+92afIk6ZVH+7xaFQWrZ?=
 =?us-ascii?Q?Vke3kiVol8UVXDZxuQY0J4TgTRm0YvsNbO8zPXBUxDAGSg6guxPOmZGQQDC7?=
 =?us-ascii?Q?CzjlmrIXjKs9/zJ9qJFtNGb2d1pnLx9O3LC7cGTZV3QSvjLybwrOp1XEYdnB?=
 =?us-ascii?Q?HAg0GV19ztojiDg3mgCfXAbc59PXsg1Xaf99OrNPuo7pZ6qc5yQh6G2GFggx?=
 =?us-ascii?Q?9WeDWUYku+PFgsZZurAY1VB32P9N7B5mUtl/Tl4Tenm0eYzgliyP2Gj7u4E2?=
 =?us-ascii?Q?80bJA1flMHqe/Z02AufzEXXOveP03sAaTdHd629Z99QiMzkc2iJq7Wd51b5c?=
 =?us-ascii?Q?gAhAMNbHNx+IbyBnVH3s9JvbdPiVPaLmsF+BtpDzy5ncXQ1Q+RgYweJBGRva?=
 =?us-ascii?Q?9EhkintQtzTp3pSDR4QXRHf9nHyvaUjDZDeVqT9HTOnkbD9e7XmRPZbtatiB?=
 =?us-ascii?Q?M7CZpfUMslwuCeOdMoS1WlQ/6cEtWKhLnc4ARRqbCmkAb8c3JXxgg/7HvmqK?=
 =?us-ascii?Q?KXqymUylhfN9+YbZm1KcUplw8IGWJD76ah4wG7JsTWayxsYy4Xo5rcgmbeYT?=
 =?us-ascii?Q?aptfWtu3Oil7sZLFcay5MowA2KsZ41bLfKWmVT0Quw3kZz1u7A1tuQQjTbMp?=
 =?us-ascii?Q?bIkmAMsJy+DUDrh92QIKXgDpcDyOEsdMlK6mg2n22Uu6/p40qXy8axD+vd8W?=
 =?us-ascii?Q?o9/zYWqTvSxeBHXXUUN9xQ6Xugxm7IcyCAgqs+2irrf1r42nJYrXd5PCQnWy?=
 =?us-ascii?Q?kS5uxQ64jU4S395vGDwkRM9CbHwKwQgn54/p9KgJ+ezwsVfNRY0t9n5OMXpC?=
 =?us-ascii?Q?5m2AHMB+WmARq+5XaEPqN3AFiTY0LmaU7abezHevAowp/Nqs2UH1eAHKFebk?=
 =?us-ascii?Q?eX5zXLmD5KgenGMgp9G892D12TiFkGv/exAYHnJftA/VMiuuXC0/s5+ZwcI2?=
 =?us-ascii?Q?f9+TIJ+GxGW5qNfGTDvlEbniz9TUeN3RH3B3Jk5ewYkf63psi1tRPq6thc9e?=
 =?us-ascii?Q?D99X1TUWB/lbSBrq9YtMh4XAyei4NK05yCqS6lVV005hbBMGyH1NtSGpxOxD?=
 =?us-ascii?Q?+w4evu42gLRRm2BUO9RqnNsFhOB8Ks4KnsTO3kFko7sJ4iX4WjNyy6fGhfhU?=
 =?us-ascii?Q?T5a5doTY/TUF0QRIGvDouuepJ+iB+ZAXqmKr0ZGQOmutlBVK+C387hmwB0od?=
 =?us-ascii?Q?AYhkgYJJWzWfcSW9duHQjM+vSEI9MYWpwOyr5FTof6e6iydYvPWwBk1pyt0O?=
 =?us-ascii?Q?jO7yLok9Nip/Gihxi2fMz90TCwP/khBfnD4mtZlqSGgC9kfPuuXu4w7+TA0T?=
 =?us-ascii?Q?E1cPKcagSDavyrRmqskjIhLjM4QjhQ1bSAZJlRbC/mdTlZ6D2ll8VqWMJlDS?=
 =?us-ascii?Q?0WA8Ec0zhfYiMUedBCEbmWhV+zLGIx4tMeGVauZJaIgsdDJBVsmbuA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB4802.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Bm/LIEBVPqKSEtyOjGrNFqcKvizfpHqX4N57Csb+3w0nSN0zjRdBEH4UGi0?=
 =?us-ascii?Q?gUvjEXck51gS7zv/iiDaPafXAcoRzHTzCyS9Vpv8UJRJLA0/AHCx4aOhYN5R?=
 =?us-ascii?Q?dIhUXwxaQm82qBXsn6ZN7v0kvw1T0kZZNb28G4a0aarjIpFHCnsgqu+3MN2l?=
 =?us-ascii?Q?YyD0mOLgGdERijNFvunmdEEa432lBwxJo8M/ShHkyB8iitUbxDKFe+4jOv8C?=
 =?us-ascii?Q?W6zg6gBV2lj0rpcMFSmbjz3uWLFih4MXa1KFL8G7yKpABhXmiK8aYYuRrTOX?=
 =?us-ascii?Q?ZNDtKn8HY51li3yFK7z4nJrYL6da0u71I9af3dZL0VlSSlbqoAljPV6ydsC6?=
 =?us-ascii?Q?EEN6muNxFK09ecNtu19MNUnPrJe9KAFwdv3UY5VzrnB/pSVpbmb/84OrZREg?=
 =?us-ascii?Q?gBt/NEvIm8BdWaiOOM6jtWJHo9gxhQxy37uV4tyHKKEbfqjQmv0YlshSKzLy?=
 =?us-ascii?Q?4IkHmXFQnKK3qtsC3qdiXvbFUUHaOYpucW9L1DbuNPFb0M/sJ5M3CCqxjUKf?=
 =?us-ascii?Q?AMfYcIVoUKSkXbi98c9XuM5o2YslBBNwRNtvH2NaNgI7wQPsqduodcJfmNSb?=
 =?us-ascii?Q?JjwMIfCa+sx/rXJoA6W5KC34z5Oh/uTxiWB/B0N/qVSpuptav7A4WSqQL7uX?=
 =?us-ascii?Q?L1Ym926BmkND8w+aeaEfuJ5WpiX0AlfDdMd5QA8MOWL6r1yyQPMHKVrUqPJ7?=
 =?us-ascii?Q?g9IAu4bbU6Vr1SOLOB04W4lxkfA9upB8wusLuIzteFupJVYpRVGwT4K8td2W?=
 =?us-ascii?Q?VHtM0/lqXPv/ud8oyIepzH4YEz5E+q2E4/2yBTPToJo4WzWQYtfVvnPVvVVh?=
 =?us-ascii?Q?vC2vkHIwCt1g0WtXfRcAcx1suop9lIjRls9kk6FRDk4tp33nJ+LjXF2BU2BN?=
 =?us-ascii?Q?UpHRksVgiWDGIbOfp9ZtOQdcYq6L2exErmR5cuNpnXL1EnYNwLwYWBnLEkTd?=
 =?us-ascii?Q?B1znS/6/xn1iU9GTTQWrE4ojwzTrDBCrlKkMB2wgDgZc3YGDDp0YFNhkKcn6?=
 =?us-ascii?Q?0MztLre34rEYFNu1kVJ738ZmXdzs0Q8C4myVAHQbvnKZLs/PIJZ3fo1D7jbD?=
 =?us-ascii?Q?udMgdFlxRBJiibCIfdvVLUktG0ifxeAzj9Ti2Q8jvAdCNPzty5gp+OhKzsNm?=
 =?us-ascii?Q?JjeYjDuFuwwaVElIWvJIxVnTrQAh5degqo76vsh3jWRDUP5RAW9enGtLLZUW?=
 =?us-ascii?Q?VrpCgmT8ZNTunS4lJjKzL22T8W/ee1ARG309YtSBX/05LjfTTvBOnwk8km7I?=
 =?us-ascii?Q?mPZOO4GRheQuic87xMf3+iPbJ1pMCoUXunL7LL7wYrvgavEjclVmH/pW7YMK?=
 =?us-ascii?Q?hbFPbDoei8e/XQMD4xWn3TNJim76rYr3Ak+f0DrHazeb1mqmInZah0LayuKW?=
 =?us-ascii?Q?TpYOJJFt9VforQVoGGtVcHBDP+1feYs4OmRIIMwB4VaZmMtVQawz+6dnQUu5?=
 =?us-ascii?Q?11PghXTuo+1NHFuDfZQZxATRTP+ZRKSFr73LBBNQvrRTFpbv6weSJrDI9CPk?=
 =?us-ascii?Q?Q3I9kmECunQfpPRU5gUDDydeD2pPhe+54jTG28befRqKaK3Gn3iYKKm71JFR?=
 =?us-ascii?Q?vjM7mZnPxFoczeSVNL4Q5xb/HHkd020k6ub5FnJs?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70fd12e9-73ef-4d58-af91-08ddaa645e18
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB4802.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 10:23:41.0690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +yf5OL0YHlyTFtE1CyM11p2RUl/8/88zMoj9UAd3KkmA3yT5dNrL3Fnphvuf5uIwwu1H8Cbgsp1on0Oy4mkLaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB5018

Since secs_to_jiffies()(commit:b35108a51cf7) has been introduced, we can
use it to avoid scaling the time to msec.

Signed-off-by: Yuesong Li <liyuesong@vivo.com>
---
 net/ceph/ceph_common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 4c6441536d55..9ef326b0d50e 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -530,26 +530,26 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
 			goto out_of_range;
 		opt->osd_keepalive_timeout =
-		    msecs_to_jiffies(result.uint_32 * 1000);
+		    secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_osd_idle_ttl:
 		/* 0 isn't well defined right now, reject it */
 		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
 			goto out_of_range;
-		opt->osd_idle_ttl = msecs_to_jiffies(result.uint_32 * 1000);
+		opt->osd_idle_ttl = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_mount_timeout:
 		/* 0 is "wait forever" (i.e. infinite timeout) */
 		if (result.uint_32 > INT_MAX / 1000)
 			goto out_of_range;
-		opt->mount_timeout = msecs_to_jiffies(result.uint_32 * 1000);
+		opt->mount_timeout = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_osd_request_timeout:
 		/* 0 is "wait forever" (i.e. infinite timeout) */
 		if (result.uint_32 > INT_MAX / 1000)
 			goto out_of_range;
 		opt->osd_request_timeout =
-		    msecs_to_jiffies(result.uint_32 * 1000);
+		    secs_to_jiffies(result.uint_32);
 		break;
 
 	case Opt_share:
-- 
2.34.1


