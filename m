Return-Path: <ceph-devel+bounces-1195-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAC38D4DD2
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 16:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25F3B285E59
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 14:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343E917C21E;
	Thu, 30 May 2024 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="LtR10gf6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2139.outbound.protection.outlook.com [40.107.6.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6566176248;
	Thu, 30 May 2024 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079075; cv=fail; b=NeJByDPRX/aGWcnvcjiz5qHst2JZ0hmKBoQa6uNusiBPXccB3+vA08vLnAe604KSnD6zktMqCtZ9LzO4f0bt3Tbgmcd5il9qhC3TozSVT9mjStzPa1Ved71oXs797AkrnfzRThnint9V4oJOhgutO1Fxvy52r4geDkbgWt2Lvag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079075; c=relaxed/simple;
	bh=UNK2Cd0qP0Z1DWXb/u+qdcQ/HdnYzeNeuQMySxnp6yc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=t3UkMk8ND/qB8yjkhs7cw4CXqMCN2f+DFi9zu7DulCfnDLo9KsckfVRbH+AGnbVtZhT8QxfbLI03w4w3yRQ3Uq7J7EVpvRoY4bN6CTV2ObBjmzdKNzYHWaN10G8XWU9D747I58aHdmjEfmCo1bUwQKfP55U2QTkUzIpup1B0iYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=LtR10gf6; arc=fail smtp.client-ip=40.107.6.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WygrNPbW4u0pOwKHyykQyWT2ZHPxRUsI4uysh4dczwyGknsKAlLDmR/iEf9M214mZI3UK5a5qAEBhZN2bYUGPViNQfUaTQbtDaNUrhLNlYusXS6lB/fdxlyaO8iAignr/hffiZPftUd7C/BPEhjw71pM2lbu/v/0UY6GGmbWxb58+mqoIZW0RzsbJgYEsv4wwVtraqUJj5GmFj7WBBGKZ0KmjYBZ9nEpsHKJTch2X1ZT2SbiUpbSfXZcX85jfJ3MFI9dCR5Upo1tz2kzQzum77mmBK0xmtRNt+N25lEvBJCtgHrs34XdSarCuTCwmTLsp4wloQWZQQQLS9NNEabUuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87OjO5/WhVEFXgqGIEkK4lrvIBj1WHNmiNj+4DwK8sc=;
 b=GZCX/3RbiL6pYYPdAv8Qb4xnh5DSE3aq77IgoVp37ze1Jo99hYyyFyzazS4/HHFiMGBnZaqdSPrC9Mgfu9qJrAImXfU2TfXs9GyeXCs0lt6uQEufYMZw9lkUWHbC1Gm+h9FoatB48CKSZP5qzhOm6Pn8WNWNrc5rXKAlD7a3Emz52VubdndezTIottK83o79L6F4nTb3jkSdaQWPk9824zcBzRBhrZUf7klLzVe9aq4aWQ1yUW5+OMS+C/hVE1r1wmhReC4l5IKRqRva7dFWs+QpWjxZYg7vtQwQgHpDsVSqw75omkkUTYKIrjT0RzdSnsWrWdFoMw++zHopeFvSfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87OjO5/WhVEFXgqGIEkK4lrvIBj1WHNmiNj+4DwK8sc=;
 b=LtR10gf6U19WcW/29rvdOpOaU2mqNTL0vX7hpx5zJ0UXJ9HV8MQA/kZntPQT1gRhoHvYny5MHnre7kYw/vi/FR4NE6Aq861VEFjhDjnq2L9Z/e47nbv/+RnfWKnycG93a9hbL027wdYq0OsPxw+4eLWJxWKBr5zfftObqSljMo3jyTKxYGFunc5lCm8jwMxhd72fDq4DatCaNX8IVYgiz0kImTPIW5wLcSnymU5Pv5ZjYyAuUfLRA3BDfT7MiqBMlo6FU/V/jAP3V+7HracNpqy1zE8l4hHBk2hUjhU8Kiw7WxnH49IoIndbW8nxl2eVl2cAmQjVXDyY2CdXORAJHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by GV1PR04MB9216.eurprd04.prod.outlook.com (2603:10a6:150:2b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Thu, 30 May
 2024 14:24:28 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%3]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 14:24:27 +0000
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
	sagi@grimberg.me,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	idryomov@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check sendpage_ok() on contiguous pages
Date: Thu, 30 May 2024 17:24:10 +0300
Message-ID: <20240530142417.146696-1-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
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
X-MS-Office365-Filtering-Correlation-Id: ccbab9b2-84fd-45f0-38ec-08dc80b43659
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|52116005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6xEeNzW+VWzixWqDr0f6e/NBWmmQF0xTgQWyFXj6F4sFSiKX5lwB0lWS5i8F?=
 =?us-ascii?Q?z0RMEwQ2BSfFEDDDpOq4ZBam907l/j+5wwjYsq8A5GM+ndL8ePyj+lTslmjk?=
 =?us-ascii?Q?3H+8l6u5hUPrYyhyHBCCuzBgkT90FXPr6txo2gBVn/2rkxWq0WE26mzmT5WU?=
 =?us-ascii?Q?uTtYy2rzPA7XOhDfC+PdkKvzK46bTusIjw9xx779Bt18CV8KkgQzCJRWj9s0?=
 =?us-ascii?Q?Nsy8XSQ/DMxqXd2y2oFlqtnJBA29FtgQOD2aTwqI6icrQ9Xht2U0q+EDWWWF?=
 =?us-ascii?Q?dDP+Zfu1i1yEDYbA3qkYHPAUo43ZVp6jmzexoMI6ryt13EpiuzHsL+uy/NkX?=
 =?us-ascii?Q?D56qgm/cJG9AkUIviDhgp1b6TGlKWt4MS6SBRHYB0s4b9tRSNhHmA2BN0o5a?=
 =?us-ascii?Q?fzPcLbiJZW4WKozMFx5GW0YD/8gYbGDfjN5PucRsX319xn+EXOLZ3Rcx0SvN?=
 =?us-ascii?Q?TtjCbjfpJfOQYbITBwCsnCyTdLVwIZH1vheVQMKl/CNEczQumVGInw1H075M?=
 =?us-ascii?Q?jje7ERJo3LkvnuQCO1pBhpCM7ETgkmQBjS7Chp1oR91V1Ilu6pOfFzOTZ6zf?=
 =?us-ascii?Q?hwycQgiBQI6nLTW7B2wlZ39LfLI9wlhbs6bs9ZI48IRAbAQPOZDj3Bfi2Ih7?=
 =?us-ascii?Q?LSZaE0hd/EZXxhNNL0VqmiFVHCW83FrMUg9/j1kpw+9+Jv6qtuifsnGoECWD?=
 =?us-ascii?Q?mtNno0Lco2gsCux+33+ZeTjUdyS7nxq2tlike4MyrZ4s4IjJZ5GcyYEtnnYR?=
 =?us-ascii?Q?QUXaQZJL+O8haybVvGymNgNJt2D0xYNveGvUj4OtwseQQgUvnWn+xAgTxvX6?=
 =?us-ascii?Q?nNo+t7kpQlL0lEE8imEwIv3vg8Pg14Ja9efwPHlBA7D3DNUy8sripbDtAYng?=
 =?us-ascii?Q?CgY0cjWb19iq0fWhwX8Y7fo2/YXcE1jYN/m1rKkCXAVRVjRFiIGLZ0GhE+Ac?=
 =?us-ascii?Q?5BVYGYaU1AzJEV6IfP5TstZkVIcYhziO5xpwqkklMt0lrNk8BWhlZS/IBx2W?=
 =?us-ascii?Q?9QKq4CEDik9I1FIPtrNdTdcaVnJWTi4PFWSTo2iIBfW/C5m+SIZxfcqoxRAu?=
 =?us-ascii?Q?MGc/erbvj7hLhJYO+9nOgQgtoUiWM63Q4fe8ubpOVlChHNeahxn0jNyMwC+l?=
 =?us-ascii?Q?BooU+gt6THZ1hpLrClE+enm5MsTJ1kmDQKvQ5OVzvm1K2x05axR+1q/pn2Nx?=
 =?us-ascii?Q?a53ItchJbUteXUPhHBGKkbiay/Lchj0jQR9QBxJ3dgITR0YNeTDssGr1sLwg?=
 =?us-ascii?Q?fvaS0Z6XWMFhVKXwpU+NGd4C7jA+iS3wJXnoqUQH+0raLjuuImpsSrcu5UTV?=
 =?us-ascii?Q?3cG9b6/6LyRNmqN5nBqJpH1pnxr739lFb9S3/u2HPgpqxw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(52116005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?djbLmTKdYH6PaRTkepZKCt/HrD+I1GyTO3y44tlUf6ABCAq4DiHxT5gCq4Fy?=
 =?us-ascii?Q?q7tmajFHY57WOfMC/pRnE/ULlMgUlJWV5hM92csXb+H0XRyWoz4Ccr65Hruw?=
 =?us-ascii?Q?zx0bFcTTYKl4QplaWht5grHfrZAg7w5cJV5M6Qtiegd3z4ucX0wY6c4s+pHP?=
 =?us-ascii?Q?oAUsOC9nx6WdpfxH9+oFP2ovpP5eRSzcyMbszS0g6G6jnmPPqBGAGjAPCkba?=
 =?us-ascii?Q?9PHiLaHJ+RkpwrgCuioYNM1fqZZq02DTXId3FwMY47dW2uY0M0dK+KAXTJfu?=
 =?us-ascii?Q?rYDF5v87iY59F0qvZPf7vkwB6LXbFRfVABuEAMx5UxD9cDl1MoWtq6UxpdyT?=
 =?us-ascii?Q?7jbWkvXTi2VNrGiSTVldAlP2nxi6bU+xB019EI9yXi00WxEOSsdzlCgS8QMT?=
 =?us-ascii?Q?0JKDy9zLaN+JLXYzzjVZPULhxK8mW3ecg6wsUAegnh3yLudDTgcgoVsHvLkd?=
 =?us-ascii?Q?0B4i4Qt6gfM9SHkUqiELX2yN5zA1JIyGsY23GC7r9ca1EygRppA1BpsD8kIf?=
 =?us-ascii?Q?zLtp4vLHtiCLxuZJ2qwkFy13CmmaO1VmnL4lwvGYfDb7YRo3x10/h/X9wXU1?=
 =?us-ascii?Q?yxy0IegA2o1Q6M1q9Lddk+USj2zCJEaNbC4z5g6Y7w+w3yO91uK8MkY50pAI?=
 =?us-ascii?Q?6P9dU8Ao2VEW8YKxOJTh8Vw0mHkLkXJTfQ3/xM/5RYNKNo8w+UxM6BGuJ4+Q?=
 =?us-ascii?Q?OnTRAZdIpU5VqXOLAX/H87Ws0AnU8HjoFXksIEkwc+W0oLxXdKbs+bybZyvP?=
 =?us-ascii?Q?p/1b6erlN3G/CuDorLw15BxZs+3BePI5yxyXk9UCtllzzksdt5pmc7Zy0TCE?=
 =?us-ascii?Q?JH/iX6bchLXvTCGsxZRBVSCZfZ2s8GNqUveww+lnDKpzndx+s50t/W8pJVxX?=
 =?us-ascii?Q?2TZYGmeS+KuJ2XjnE61PJY4pHaselKMVh41ncdb76xGG9F5I6SJv1ZGx3Skl?=
 =?us-ascii?Q?phoOi3SSiJ1LPSldpBhY8rfBUspis1vRwy+apu2BUPpq4YYUqTANe2RhymvF?=
 =?us-ascii?Q?c82k0LeeniF2EQfb28f5t2JS672OwTsFBJcL9+JdiqowhOwqBAsa+8WmY+II?=
 =?us-ascii?Q?6o8RCmapEEPOmH+cRxXABzq9vxya6Bt2vw1yzv2dWWsNfB0a+CcZTd0Sfjvm?=
 =?us-ascii?Q?7m6BJI8T6VTCtiQBaRfPosN10O4CNf2SwP4F4OIruLyD8SJ5jRG3pMvnt1Q5?=
 =?us-ascii?Q?zdUg+/E6TQ+6dyJWrjuY+nJ7GEvtDwU4ez4zyvsxGnDPm1T83GfjzZobYDC4?=
 =?us-ascii?Q?ZU7aJkMJfxIt9eB02rUEmLmhXfztdmRtA8bcb3bIh90fh3m+5RduJ55Wpi0V?=
 =?us-ascii?Q?npZ6jzJF0yUMzniIA71JPraGH6Yp2gkBlwA/pyRIDVNCCWlQ3f4lhYyctE5m?=
 =?us-ascii?Q?jGhrRKu0mak38cMIX0f7atdTzQUm7GjJMxEBe3hhb4OzVJwP66iVfVLgE92A?=
 =?us-ascii?Q?eiL8UGRZs9HJfwuIzeDmzrGKC2CvT7aE2PM5wTMlmB4ta6c02EVZkFX29bMb?=
 =?us-ascii?Q?IKnbvJjEe2rhtPG2HJqhx4srDrVtpbVlOe6IxIXBTPqlscgh2TgT/ufGamFf?=
 =?us-ascii?Q?OHEzalA2ZzjGFfqP5lJTk1d0vs+9FZPoaAZKiO3j?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbab9b2-84fd-45f0-38ec-08dc80b43659
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 14:24:27.5701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B70Ty2YWVAJFZPoY/FsENwrTpn6J1nJ+Pi4F16JDxcClCDcbdoLeIW9u2TQQUDHtnh66Ub0BxbjRw/nBhnQiwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9216

skb_splice_from_iter() warns on !sendpage_ok() which results in nvme-tcp
data transfer failure. This warning leads to hanging IO.

nvme-tcp using sendpage_ok() to check the first page of an iterator in
order to disable MSG_SPLICE_PAGES. The iterator can represent a list of
contiguous pages.

When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
it requires all pages in the iterator to be sendable.
skb_splice_from_iter() checks each page with sendpage_ok().

nvme_tcp_try_send_data() might allow MSG_SPLICE_PAGES when the first
page is sendable, but the next one are not. skb_splice_from_iter() will
attempt to send all the pages in the iterator. When reaching an
unsendable page the IO will hang.

The patch introduces a helper sendpages_ok(), it returns true if all the
continuous pages are sendable.

Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
this helper to check whether the page list is OK. If the helper does not
return true, the driver should remove MSG_SPLICE_PAGES flag.


The bug is reproducible, in order to reproduce we need nvme-over-tcp
controllers with optimal IO size bigger than PAGE_SIZE. Creating a raid
with bitmap over those devices reproduces the bug.

In order to simulate large optimal IO size you can use dm-stripe with a
single device.
Script to reproduce the issue on top of brd devices using dm-stripe is
attached below.


I have added 3 prints to test my theory. One in nvme_tcp_try_send_data()
and two others in skb_splice_from_iter() the first before sendpage_ok()
and the second on !sendpage_ok(), after the warning.
...
nvme_tcp: sendpage_ok, page: 0x654eccd7 (pfn: 120755), len: 262144, offset: 0
skbuff: before sendpage_ok - i: 0. page: 0x654eccd7 (pfn: 120755)
skbuff: before sendpage_ok - i: 1. page: 0x1666a4da (pfn: 120756)
skbuff: before sendpage_ok - i: 2. page: 0x54f9f140 (pfn: 120757)
WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x142/0x450
skbuff: !sendpage_ok - page: 0x54f9f140 (pfn: 120757). is_slab: 1, page_count: 1
...


stack trace:
...
WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x141/0x450
Workqueue: nvme_tcp_wq nvme_tcp_io_work
Call Trace:
 ? show_regs+0x6a/0x80
 ? skb_splice_from_iter+0x141/0x450
 ? __warn+0x8d/0x130
 ? skb_splice_from_iter+0x141/0x450
 ? report_bug+0x18c/0x1a0
 ? handle_bug+0x40/0x70
 ? exc_invalid_op+0x19/0x70
 ? asm_exc_invalid_op+0x1b/0x20
 ? skb_splice_from_iter+0x141/0x450
 tcp_sendmsg_locked+0x39e/0xee0
 ? _prb_read_valid+0x216/0x290
 tcp_sendmsg+0x2d/0x50
 inet_sendmsg+0x43/0x80
 sock_sendmsg+0x102/0x130
 ? vprintk_default+0x1d/0x30
 ? vprintk+0x3c/0x70
 ? _printk+0x58/0x80
 nvme_tcp_try_send_data+0x17d/0x530
 nvme_tcp_try_send+0x1b7/0x300
 nvme_tcp_io_work+0x3c/0xc0
 process_one_work+0x22e/0x420
 worker_thread+0x50/0x3f0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xd6/0x100
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x3c/0x60
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
...

---
Changelog:
v2, fix typo in patch subject

Ofir Gal (4):
  net: introduce helper sendpages_ok()
  nvme-tcp: use sendpages_ok() instead of sendpage_ok()
  drbd: use sendpages_ok() to instead of sendpage_ok()
  libceph: use sendpages_ok() to instead of sendpage_ok()

 drivers/block/drbd/drbd_main.c |  2 +-
 drivers/nvme/host/tcp.c        |  2 +-
 include/linux/net.h            | 20 ++++++++++++++++++++
 net/ceph/messenger_v1.c        |  2 +-
 net/ceph/messenger_v2.c        |  2 +-
 5 files changed, 24 insertions(+), 4 deletions(-)

 reproduce.sh | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100755 reproduce.sh

diff --git a/reproduce.sh b/reproduce.sh
new file mode 100755
index 000000000..8ae226b18
--- /dev/null
+++ b/reproduce.sh
@@ -0,0 +1,114 @@
+#!/usr/bin/env sh
+# SPDX-License-Identifier: MIT
+
+set -e
+
+load_modules() {
+    modprobe nvme
+    modprobe nvme-tcp
+    modprobe nvmet
+    modprobe nvmet-tcp
+}
+
+setup_ns() {
+    local dev=$1
+    local num=$2
+    local port=$3
+    ls $dev > /dev/null
+
+    mkdir -p /sys/kernel/config/nvmet/subsystems/$num
+    cd /sys/kernel/config/nvmet/subsystems/$num
+    echo 1 > attr_allow_any_host
+
+    mkdir -p namespaces/$num
+    cd namespaces/$num/
+    echo $dev > device_path
+    echo 1 > enable
+
+    ln -s /sys/kernel/config/nvmet/subsystems/$num \
+        /sys/kernel/config/nvmet/ports/$port/subsystems/
+}
+
+setup_port() {
+    local num=$1
+
+    mkdir -p /sys/kernel/config/nvmet/ports/$num
+    cd /sys/kernel/config/nvmet/ports/$num
+    echo "127.0.0.1" > addr_traddr
+    echo tcp > addr_trtype
+    echo 8009 > addr_trsvcid
+    echo ipv4 > addr_adrfam
+}
+
+setup_big_opt_io() {
+    local dev=$1
+    local name=$2
+
+    # Change optimal IO size by creating dm stripe
+    dmsetup create $name --table \
+        "0 `blockdev --getsz $dev` striped 1 512 $dev 0"
+}
+
+setup_targets() {
+    # Setup ram devices instead of using real nvme devices
+    modprobe brd rd_size=1048576 rd_nr=2 # 1GiB
+
+    setup_big_opt_io /dev/ram0 ram0_big_opt_io
+    setup_big_opt_io /dev/ram1 ram1_big_opt_io
+
+    setup_port 1
+    setup_ns /dev/mapper/ram0_big_opt_io 1 1
+    setup_ns /dev/mapper/ram1_big_opt_io 2 1
+}
+
+setup_initiators() {
+    nvme connect -t tcp -n 1 -a 127.0.0.1 -s 8009
+    nvme connect -t tcp -n 2 -a 127.0.0.1 -s 8009
+}
+
+reproduce_warn() {
+    local devs=$@
+
+    # Hangs here
+    mdadm --create /dev/md/test_md --level=1 --bitmap=internal \
+        --bitmap-chunk=1024K --assume-clean --run --raid-devices=2 $devs
+}
+
+echo "###################################
+
+The script creates 2 nvme initiators in order to reproduce the bug.
+The script doesn't know which controllers it created, choose the new nvme
+controllers when asked.
+
+###################################
+
+Press enter to continue.
+"
+
+read tmp
+
+echo "# Creating 2 nvme controllers for the reproduction. current nvme devices:"
+lsblk -s | grep nvme || true
+echo "---------------------------------
+"
+
+load_modules
+setup_targets
+setup_initiators
+
+sleep 0.1 # Wait for the new nvme ctrls to show up
+
+echo "# Created 2 nvme devices. nvme devices list:"
+
+lsblk -s | grep nvme
+echo "---------------------------------
+"
+
+echo "# Insert the new nvme devices as separated lines. both should be with size of 1G"
+read dev1
+read dev2
+
+ls /dev/$dev1 > /dev/null
+ls /dev/$dev2 > /dev/null
+
+reproduce_warn /dev/$dev1 /dev/$dev2
-- 
2.34.1

