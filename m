Return-Path: <ceph-devel+bounces-1540-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85623934A4D
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 10:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A570B1C23378
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 08:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E8CF13A3F3;
	Thu, 18 Jul 2024 08:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="LeocIx4+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11022116.outbound.protection.outlook.com [52.101.66.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EFA13790B;
	Thu, 18 Jul 2024 08:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721292338; cv=fail; b=UecuYQ2AFcFGpz35Qn/2/bLs5w0kHXJXBAzHcyi/Y9sjfuzX3Ky4vfrDTY9sn2AnmGDSuI8Kq0VhApGIWdA4qPyA311STXiX3XBMtotX6lCaaqGBDOLPA26nFMO+d8GJPwTHEC9ok1l/PDLQkEKz7rNv1eEFWhT1DpynHZnd1tI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721292338; c=relaxed/simple;
	bh=wYZQ26y0os4R5zRsiqzIRgSNnbiRuxC9GerU31GCTcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rdZWIQUjSA1Fwxekv88MipD1jArPAuiZIsMSgEN8NR/IV08seile8DoRM+088OzmCc5MOAMPNGJYn+9c1r8rbfZI7XKtGJjGj2NSnmxk9e8P3WLQcH4cJU8fu7GI9QYykLPSJgAuW3HxEGvUsl5z6aQyj3FoLxhCnej4vYC3uAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=LeocIx4+; arc=fail smtp.client-ip=52.101.66.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NYJfBs6JzFSlf4wTHoRW8A7QTs7k6MtVZaEpvqtAi5DJachZdFOMvRcFOKjStdg2BeT1I+uXTOXI6kHSxUXZkmWaqEKx68LXhvFweGj1f7yUosQonuZYlgXfV0InJpc2fMbZI4NzuPkUg5q7T9hyLo1SD7aV26KKCYZfkLUeWUtS+Ukyax9paG66KswOW1YDaQasexkZRLbtoUa2K76Py5ci1ZxOKN3+a02s3PJtcXS+RD2VXfUIffGqwWfYvJbdwzGT3EYxWy+/2ZDtD7u5BhKuJMvnJyEP+nY/yQxC94w3V6HCjMuxyrO3Cd3dBww6dl2JcRPUzkrA9f7Ee2HmXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aH20jbNOmN07YNyZ4sxTXgGz26CzhSHDXBRGbZ9/rkM=;
 b=FbSJ96qo9O51NU9mAG+q7aTasoF96fbBFeX9kSGG0AG7ArWQL4zQhg55xirx6XWMUQiN2c2MyRxRFSsNXLu85HFqNcJHAzAG2XQ8EKV3QUcEb8pJKo8IHMNjHEMClxjaeYlbveQZXeIUhCOPxdpdqls/ekXRAFsKfvT7Ena4xWzONeFh55NnfQALQnXFyoKxLAQjLRevLp1XCWEY/lsEBJ6DLYmU27qtNyBQX/bJFdGaaZvsGHTagKyKHfzUPHNQyghmfOg2tHtlpTcP4iHUq/daNLG3kFTuNfdSLIH2UWnKSqe9ALQVRXMz8tz2h7axSSRfrA8jsyCtFTC6gZ4g7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aH20jbNOmN07YNyZ4sxTXgGz26CzhSHDXBRGbZ9/rkM=;
 b=LeocIx4+QKUxebSM+0lCz43wswA5gVMLwGJv1Pht7GPFjdQUHFY1q05+OS+xfO8X0Y0Z+45I7xNJyArpap/TtXoknbCzCI1vlmKt36F5KVGvJnWjJ5bUsLM4Af0Il5BZ5j7jWFCKyZlGl24Wr0xi+3c+G58kVdIb6lWPn2tbWg8ZkW7NpKjHq0BgYzUJ+ou4u3AFZDUdX00NE3+1/LBKSRkqChvQE+Z+nFfgIHF24vPPGzNyH52wQ1kJog/ZtgcRqevye2MifEuWN7qNPd1dvSAe1QysiaLYbyM430AmNwNGtluWMX9DgmrNCAqr5dX+ECCnBSMwoJqaqYrizKBBVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by PAXPR04MB9005.eurprd04.prod.outlook.com (2603:10a6:102:210::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Thu, 18 Jul
 2024 08:45:29 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7784.016; Thu, 18 Jul 2024
 08:45:29 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	idryomov@gmail.com,
	xiubli@redhat.com,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v5 2/3] nvme-tcp: use sendpages_ok() instead of sendpage_ok()
Date: Thu, 18 Jul 2024 11:45:13 +0300
Message-ID: <20240718084515.3833733-3-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240718084515.3833733-1-ofir.gal@volumez.com>
References: <20240718084515.3833733-1-ofir.gal@volumez.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To AS8PR04MB8344.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b3::20)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8344:EE_|PAXPR04MB9005:EE_
X-MS-Office365-Filtering-Correlation-Id: 073a5c02-4481-4819-e588-08dca705f9ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7R1QZaPCI5D35DcNgC8G1MkD1TtuGpisGZOlCuLXlPh2TM5XIMgXjdYn6ug8?=
 =?us-ascii?Q?h0ugRtW0UfCiw+zKRIefdKTpezmhuwJ/K/OR+HMLR+0vCS2mk+lzm49QwEIe?=
 =?us-ascii?Q?t2Pn2F2u4tVAL2IY5u2/A0I+mqF4GwfXCZUXc96QFHJaq13RqbjhO1OyFTdI?=
 =?us-ascii?Q?vHTRbiKS53utsiCTbtFuYEo7xInoSA3jTesRPl0sRuNZ4c/ddfkjGh2xuaSw?=
 =?us-ascii?Q?6fS0rI4pstXoMBKq/I45CSSE4BfCXcHxcm4qS4QCBYsqgsIAFst6dITEv9lr?=
 =?us-ascii?Q?+URX/uedqYA4KWVUM2GO2BQRdNkanqpYS7dhziOMDYxKqNE6ZbLGGTIxKed1?=
 =?us-ascii?Q?z3v+aRaPwM5AsSJFk9VzR+X+NCqwsUCYHt8pBgn8h4BGkI5QX7tQ2FzrPESw?=
 =?us-ascii?Q?RZ4owL3tbS0JLfZ/Npow4Rbui2dNhJsmRf+KxYBd1UOAuQqUeu2tKAlOXzxb?=
 =?us-ascii?Q?HCBBPZGeB9YAkJNcJ8t2fCEEPmrdNTpiWbIZz3daDk81KrSo6WasiHCcSXFf?=
 =?us-ascii?Q?DXu0Qoo4Xk8nDmo4p05F8T2LVkMeyd//Nz0Ix2duPTrg+48PYbw/ZZYgYz2t?=
 =?us-ascii?Q?ZQtqXvxt/NECOVGE+Eyh2vDvcx2cqeQE3klMONIvsI8u/wtyQt1wrRQvyFnQ?=
 =?us-ascii?Q?dG3KD7BLnW7pd7rENmSiyE6GpyGEsCBXQHLIVJlzIIhlyqIvjK6V44eMf+25?=
 =?us-ascii?Q?kYzWC0D73tNePj7MJcLN25S6zW6aCwFCmk59B8MWUrU26GTpGofN3dmSJOtw?=
 =?us-ascii?Q?NkxROaf6vheXMuZ6kYU1bhMV15yu1PGDiXkDzOv5R7a2qeb/XIBOJHlI6Npl?=
 =?us-ascii?Q?CmbuSw32GHySWmbeQNxi/+iAV6m1y63oia1Sr8ARXsg6+OgwxTMn3kb0SA44?=
 =?us-ascii?Q?Uo9yQGJQHRwLj9ljCTUfWBTVLGkmTHmjCeoaQaP2flT7+HTXCIX7myJon/c+?=
 =?us-ascii?Q?Amqr6gdAQdDYq6bXM/0QYh1rIKTASzQNqxoL97s4kESXX0JMv5PffxyicOTC?=
 =?us-ascii?Q?H9YuysIe+ZK+RwAUBxNSsosV27psub2bqM1DaIWR8gP/N/9tZuFILSSDG8fa?=
 =?us-ascii?Q?Fzaf/iKJjwJhR9xN98pqQV5wh4g+Ht0CAYzBDKvsNxvpPqke0cVa7LnYPA1h?=
 =?us-ascii?Q?o4kCSSEa4bsbfsPJwgHJdY4/eYp6xHU7hQGiBQIwcjltKY9vbVA0uBDljxwe?=
 =?us-ascii?Q?COKYpzkO63K4lH0dagk9QWlWQwi5tx6OkavmKmdwchAEK16O/0LTDPE6ndCH?=
 =?us-ascii?Q?//M0kpF6UUNtjF7Hf2DzPHYWPb0x62I16GC3QnKKNss9IRHQ76wil39yZVgi?=
 =?us-ascii?Q?GDWzxcSsL5bK6Wxy971QcyPLnh+iy2SgWeNOJyswGSswH/CcIm23FAGwj6bM?=
 =?us-ascii?Q?K0dr7n6fLidN1www++Dg1GswmqIpiP156e+jvhnvfmsS42QCmg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(52116014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lcR3zV6GJ+tA2JRXKrDlvEWqvN3OII4IrULdNoPH7PXs7VZlYgQ0rY4Un8Ro?=
 =?us-ascii?Q?P+Ju4k7eEoz3A6b78BRvJ1/LorPBSHE5BSf5N0MH33MTjnWtmBdEk+4yrkfm?=
 =?us-ascii?Q?cS/tFiGrBXrz5yztWyaMscPwqZ3lOll8jxCblgfXhiw5BMJFelqIOVRWhZyF?=
 =?us-ascii?Q?U+uCN9GbY9FJWFV0cAjmhOUUtgjv2IerHmA90tbOwkfC1cQRGhM26OmoNxq7?=
 =?us-ascii?Q?7JHIRQTKjCSMZexuE7PPpx3eUEg3oAVC7WTUCnAjKjfL10y7jM0FT9ZqjKsr?=
 =?us-ascii?Q?hzlb79bXwnGdZn5aVH2El3V7s44obq+KOOwP2QCWPvOoWKYSOMZJd3Ps/BBJ?=
 =?us-ascii?Q?3lXZFi4nqqNjcVl67h5N9xXwx2st/qJ2NytFGV03qTKL9LUVIYRaXI+SXr+R?=
 =?us-ascii?Q?3TW5e9oVetBUlcn2tHDJ9Ux5r1ChxBhHqeydC+Y1L252aSb2uGv4L5rSDjOe?=
 =?us-ascii?Q?y+K6eZt6psiZ7yf+LCKazaAnALnxjy3gdeLNtWfJ++D2nvT9ZnE0AN5FecwZ?=
 =?us-ascii?Q?AAJY+Dw5WLpMepqeF+/ixL0yzCz0Z3SDPwz2PPSEpZPpN3P1GwYM4/T0c08S?=
 =?us-ascii?Q?uoQTnh84qJ+3FKHHk5DOyMBHPPI4vhy2g+GMPhmBpB8olT+7zV1k2crJfebo?=
 =?us-ascii?Q?5CHt0M666m6xqx3nRJ57vN2pY22LAy/P+01yBgyn9EJG28HBslDhTPIhgFxR?=
 =?us-ascii?Q?DEuNt8TLnjgKhHQNvgctO22irZoHkKXn0n3o3cnW2pTeH47PPz2z5+6zkOAK?=
 =?us-ascii?Q?N1noOsfWLLZ8c4pF2S0A+6tRQQK+C8rKlwLvUPA0x3sjMymyHSghwfCMOQ3e?=
 =?us-ascii?Q?EsbCVQBNjKEEiuZwWQrxqBvjr/AU+HBWT4GH5XgetFfWqLpPZMgmVy2+43ok?=
 =?us-ascii?Q?ecgkJ46AR+u0+RcxRuTYTP5a//NKiFkESHj0wT8gwJRigxfHrY8mrqqj/P/b?=
 =?us-ascii?Q?XbF+uhpTgzVLxNcblnGpuQpYIG3gDuxUKGJrTDr70Osrnlg/QlYmc9udsWsr?=
 =?us-ascii?Q?o21KRSepKyfhSpsMiX6I4NXD9Hov1WW1Ayfr/69vwnajnpbba/GpKU8dm3xk?=
 =?us-ascii?Q?51fzXOMCjhixJwkKEzbf/l0grRC5GiqmX3AbXlLbivBjVq8z4NDt6Btjo0jB?=
 =?us-ascii?Q?Svb4VQCP73OHIy4+A/k5HKp8mupEkL+cs6ZzWtF+2aHBBY6h/sqSC/wM5YDY?=
 =?us-ascii?Q?xfqykOUJ8RaikuDJxq0xuktpG1y+jIamK1DSTuvQcEVATXy5Gb6dzpMMg7A/?=
 =?us-ascii?Q?NG5Nd4NoUH4/ZRchxmZNk2R9gDku7AYt7+xSTQa4NIvsTE+m6gX+Qt7mCdSH?=
 =?us-ascii?Q?/oiehZHMG/4BYp5MiCw7KoQpiXhvUmn+gP/TbtDDjtS3/vSLkLrLphsZZVr/?=
 =?us-ascii?Q?XeYi2bKohSM9ZUc3Oyw1Cc7Xcjsv7Dhed3gr0qZn8FaNoT3js/7WBFhSLWDW?=
 =?us-ascii?Q?Dda7Uz8aPeNRFlR/ijvHIhYPNMDXXzdaUURbJmC7s5Ggzt8TcTC8QjPeEpHa?=
 =?us-ascii?Q?5xObKxiboFt7MGXGVd8dyUg2RKUNmjhCzI+H4MUoPRoIxOIrxFjx+h1NE+Un?=
 =?us-ascii?Q?i8R/hy7cwC/h8t0jA5nU6uUzn/pCLGsGNGjT4vLI?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073a5c02-4481-4819-e588-08dca705f9ec
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 08:45:29.1180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mpa1Y1DXjOkse/Z8KWjgdtx9iqedWpCV1ViFxR+ebxgMo4qs8oyKlyivsOnptbIR8ACLU8/x77se46ViM4c3mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9005

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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
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
2.45.1


