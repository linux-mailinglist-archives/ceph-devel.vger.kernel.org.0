Return-Path: <ceph-devel+bounces-1273-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CF2B8FF1FC
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 18:15:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEA2028A7EE
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 16:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2022C1990D3;
	Thu,  6 Jun 2024 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="HnRwMqYX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2115.outbound.protection.outlook.com [40.107.22.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A82947A;
	Thu,  6 Jun 2024 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690361; cv=fail; b=B9jNr3A//03QCswQif6yvFeq6uVcPJOenS0sRQRJg52locyTvDQlMZK9Ati/INUvN4gHDAHfamu+gaiMdsQYHBrMmiOhSEAUHe8T1ffzbCs1W3K2UeiiseI2zYlEQL8K45W4LBzzqZjVCkaGTCQd3vcJaU8w0axBwwX11GtZguI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690361; c=relaxed/simple;
	bh=+/CS8USn6wiB6FaZ6ooyFQf+NWxoxcSHGKvL5rcyZcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=etzyTD5TD5LjU6TZ9Xnc66e0QSy8f86wPgyRMrN5GcbPvxdTTxm55c7N67NIjOpyDeFjzIJJh+Nlb85VO5qKg50400KE1rvIkFrfUbdYO9rAOf9a2c93wl4O6rGM8X04FyPALoKMgvu0dYPCt4rjti66HQCD+t54KXZKoLGZHNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=HnRwMqYX; arc=fail smtp.client-ip=40.107.22.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8TFrB5JNyhttNDjLD4iHD+1Ch1MYvCereAK1Daz/J6yxTvN7MRjGyiHAV+Yj5aKIhqE0m0m5QyPa7AbcUXX62GFL5TgarmSdiWP1rD2LXQXobsyLv+fJwN76PFblQgJoFey3GTP8JbYeEW4nLrt1NuIwXwZtHrbkSFLPTdsO30cosV2VYXTfQE96Aa0mIOode7sZhu5F/p3urgSTekFufSi1NpFOY+DVc23LMY0/1LSiBcr81GtM7sIZlQmlOuhc7xRcsbN63Sc6INpAbKDfMKXigv1SHrx13ysmy9qsSx7otMLaRMmp8Fj3GlW/rX4se/NPJZKmfL4Yt3gc+ELlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhHgDslOBASD7s64P5KfwTymBRlfINLihCyBsaaDRLk=;
 b=eEJGofUIagvpmSoAD6BkIDf1MdNL1K31hDCsACUgXMvJTTbQY/kTVeW+wtis3qjRqkOcKbEKbbXE/BvbPWnbhcsbhGc9r0AQ4lojjzIo5gDh5q8LLWejYLYEwVK8tfniShVoEIgnJkCWLr8Hf/nEU/y1KClHCXGStzIT/NnOxnluJDy+tnd8+dh7OGFnKOZZFCp00KfSgxII14Xly0VVpnPDBya0qr/gMnHEnM4WQnejCLuDyR8SMCzFJU+sYZofsavjR1F+5/qY1WoxCr9rKNRdRZBDAWei50KKDYF2I1TwghAEVRYcOxQ1VypzxVFdXU5lI/cxae5Ey6PosZACBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhHgDslOBASD7s64P5KfwTymBRlfINLihCyBsaaDRLk=;
 b=HnRwMqYXN5iP57YmaMMTgARS3eDndI1Uz6cTEfkL60nAniGpLJWyMStyJUGUIe90AlgEz1u60+E6SVYE8to0YVGZ0gzdNSp6zoUkIa98lPrnIko5Juoc2Zh2gYNYfv3Jfdr34zCXQ4XxEfk5wcycypyRvIAr5GMXOFtZ8xgW5dpwL+zgkduuxIC1U+O/24ag295CWJOmj4fbz5vKAOmGhnSsPUJ/K/dx55uyIo6m2wllTLIHF/zwE3za/vCVS2w70uMK5UEqHdl1DHEAGFAUP+tHfcKBa5P6urD+hblMXLqvCYvzcuwqL2+JF/ZgLvmN/eAtudnBkTzxXkc+1YxWyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Thu, 6 Jun
 2024 16:12:37 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 16:12:37 +0000
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
	xiubli@redhat.com
Subject: [PATCH v3 1/4] net: introduce helper sendpages_ok()
Date: Thu,  6 Jun 2024 19:12:13 +0300
Message-ID: <20240606161219.2745817-2-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240606161219.2745817-1-ofir.gal@volumez.com>
References: <20240606161219.2745817-1-ofir.gal@volumez.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL0P290CA0009.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:5::6)
 To AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|AS8PR04MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: 9495f9fe-f094-4370-d8a9-08dc86437baa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|1800799015|52116005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+XKTzYWFGIukks25OQqVp53B7+PK0OmQJFA1IXBK2QVw1G+c8iV96kkCfqCr?=
 =?us-ascii?Q?L3mESWo0Ud0sDD9g8wTFZi3dA+ot27IuFT3q6u/WOHUpz6tX3+SejwiJKAAB?=
 =?us-ascii?Q?PDvhgpmFvIb5tx3xJRgUoP+BBm2d5B9QNd+O0vlFuoyrJP4h/nG9HUhAK6vz?=
 =?us-ascii?Q?9+W52gIJHuuraruOTBMUD0eurUHouKdsfjYlW1S3/8Ka37E3Y68T23w9Kk4y?=
 =?us-ascii?Q?KkBX1Yjs8IE/uNmZB60D9Rm87VBcM6Pzbs1YD7Z/io6nul7XW5pi3S9yLxeX?=
 =?us-ascii?Q?kblnUaST4sxcglC0Qosv8KZCMvtm+pOtwo5TLfrjnjjIK9yUafWhEz3G0q5O?=
 =?us-ascii?Q?OUJNIe09VK3DwCUiItWqM6CV+ZOQXz+e+5q6UORYBtGVyWD7UcY0R47DWO1z?=
 =?us-ascii?Q?/izyxFKOZEfmrqMfoIUyGtTWvOP2ouaLNm9yxHp6cVxbIzINhCNsQTjdmaSd?=
 =?us-ascii?Q?NLqHV8cCXLIIur7PnrsyPSTB1sWV/TfU9pb3rbhlEDAaqddzgg7xLfOHJq6/?=
 =?us-ascii?Q?M6grnTIRSoZa3zwlD14VH3v6HV9v2gaYLoBq1eXMe1asQGLRaYNQuhU4giEx?=
 =?us-ascii?Q?Wfc6ZMLjpHLl1mDoGU8q+Igh8xBMcq7KZecRkm9p5/wNWFDCxtEQIxcwBz7g?=
 =?us-ascii?Q?MApaFdnPR0tfmGVOBwCfh/ODsoTpf0VRRHEbueZUvRb9ouLpMbnZY916NEgn?=
 =?us-ascii?Q?c5ECzquyxRR7A3DrY7wSnS0w8Wi8K1Ak+6/diAu3O8qQiibZEruJ9/XpUCE0?=
 =?us-ascii?Q?e9/kqIY7jGFQUfwM5AOEa/j/qQDJUfIHdxBEoLHBUed1psN0H7DzOBJX46zD?=
 =?us-ascii?Q?8F8U5eWaKHdsQCojAadLN4UnoSulEVJCRjYrtsMhZMz+8IGVlD39I5ChV6p5?=
 =?us-ascii?Q?4LPkHUVWmSojxtcC6etlL78XrAF0uo7jdgmfbdGqP5nr/fjbzyurPRiXtHt7?=
 =?us-ascii?Q?G87UAWHoqFLiCibFSNcJwpyJR2VLeyA2uwbu41BZebnnYl6qHrbUUcyTEvk/?=
 =?us-ascii?Q?WLxOFrcRuBLYapC10dhdf7rBboZMUqmmEPZbXAoSAaUoJaqYP+sKDK9BC8YW?=
 =?us-ascii?Q?SxOtMIuSNrgozKNCpdCFS4BTaBK5Bzv+v11yaUYjfIlC4lYhbubCgbKcnp9V?=
 =?us-ascii?Q?4rtdPSuW7zvv3lvpfPtJbBbXCERQ3EpdBuJPUqmGqUsEvi0Oqk2kvQWjSqhg?=
 =?us-ascii?Q?rZ5nFwENbk++6D2bk5nApgi/498+tLxJ7soIa853cpyerJ80I6gxfz6PAAti?=
 =?us-ascii?Q?6/JfZ/MBPMqn2nJfyIFGe1ao3PocdhE3X8zIoJC6OqZL0ClEcnykwJmNwWaQ?=
 =?us-ascii?Q?j857JDlYxdOrfLi8TO5sv2RSotHtgWIsf2pkg+TBK6zLmZLMjLwH4eEXN3k/?=
 =?us-ascii?Q?n/eH8zQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(52116005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yt5zKlB+VUpDVLwyW7Kr+roCIftrJWXwCOZHBcAJUQCsShpi3DBL0tVxme/m?=
 =?us-ascii?Q?X+Ykq+0BG3A8jA8uN9o/K011akwwpG67V8GXw9xZCjC62qdZVcTk2mt7rH6m?=
 =?us-ascii?Q?/rKmkmn09yY/r2HquOYC6RRqlfJIrnHUa98IyyF/RKuqrEw1NCnoshV/r7Yi?=
 =?us-ascii?Q?gDMXYiZHzmfajUwhcUh+mwH59c0KplSF6C08f3Al0zIjqTdtxUrYl55hsIgO?=
 =?us-ascii?Q?JWhGxUGrImSWHz/n+0RBbbp8m2B+/nesuNdsXF/Lx9OlD70ZaY0PBiAgpIn6?=
 =?us-ascii?Q?sKVAl9WZnEd1sx9L+s7Ko3tXWSoAmJFnru1MIVYOW5kk/v2e5UXwhaH54v77?=
 =?us-ascii?Q?ggrrkruyTjvORF3aXI3ZnAKCoG7Jm8maWSjw0A6x5nQzcGXj3q/7B8ZuLUxm?=
 =?us-ascii?Q?5L4mMJzRgpQGIdHXyyGlxwu844tF8cm+ijFpaNFdZ9gPATKscAP3DfMeMqKo?=
 =?us-ascii?Q?UaJ97ApwY7MJvWqfRMey4zeLCV+j+XpCuE9Xe6yZxnkeBJBir4i8zoljIWjw?=
 =?us-ascii?Q?NmZPfXks+8G/r5Uy6p17btx0ewdJxAdJBUIRCkZ6PRtyxzTT1bqIxuP/T3zv?=
 =?us-ascii?Q?x08QmmAFotynjJL1TMYbLMXxkilcFWkXdxULaAaXQKuVMHfopKDGGX19Cu5P?=
 =?us-ascii?Q?0RH7ngYcG43raOXgocisNTwNLZXLxhTPMBeX26JJ9Q++DS4Roaemb+NRmpXP?=
 =?us-ascii?Q?abyceXfX/jYA0InZnRYNE4FumvdM0PwzhuwuMbBB1Z7zxPo94Zjm0vUHgyEB?=
 =?us-ascii?Q?Ixd8TtqRFuhaAzJyv80qbz+y0B4PPl6DL7dSJ6iFt4gAtfUqBlngKFsxxlaI?=
 =?us-ascii?Q?wTw9OW7fXVCcuqZUV/wKB2iS2dTG9EHZ+0LQBxUKEcQO1HoTYeY3caBc/K6l?=
 =?us-ascii?Q?D0VlXl+1zHBbfq7XN5xvaOBZp/fBigucRs18xGLJ9kxXOftMAdufxcrzua3x?=
 =?us-ascii?Q?dpGMnry5mzgY2rWbr1caY8rGd4GxVWTQAZ7H513GwEyzvgG80/IIoTmXTILk?=
 =?us-ascii?Q?YmjW/eZGilCLB52stdbJWPAnYk0cp1J1x38B39KFZSE6gDg+rZSVbJDJz4NG?=
 =?us-ascii?Q?zRcWE0hLTbV87TpSvr6hRKF1OHlD6Wrp6Z0ZhvI0NAHyE4j249V/z1zxIjGe?=
 =?us-ascii?Q?yaMghXcGWrcdw9DEa5A+QS1zjtrhlGDFoXehu8BFkSnbl3g6XljYwa9vxD9w?=
 =?us-ascii?Q?gSQgkNt2x+Gcq9nrj/vYpZvNJOuRI6uiMjK61OtMR5fcmg1KhxgPI2miJcmU?=
 =?us-ascii?Q?vDDyZHRxmH9R+RwREWoghUG/KSqRaIHwjxX9/s+BAYrSFExD/KUgCWPQzcrV?=
 =?us-ascii?Q?t/XsSkHv6jSgFWXtb/lfoS9xOPVvwL131MIpUcB6QjnKmTA8H6JGeu1BYZda?=
 =?us-ascii?Q?lugnqzM1hYkAeusP16e4WohXIrfc3sOsAukiV9n/9w8Jn7/IvcjDonfegJnI?=
 =?us-ascii?Q?iYE91p+1KWVqQStvylHvDSTANzql4/G+BAD6gc7cXUXmmurnfNkrLjmBSgGl?=
 =?us-ascii?Q?/QWoYwxeC8Zk9+D98WaMDNIMHxqULRytUJpV6g0CLLGvHuNQNwSyD+39mZOI?=
 =?us-ascii?Q?AF8V7wfDMB0ianROLLio7j/bylEo/4UOQZBtwPAZ?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9495f9fe-f094-4370-d8a9-08dc86437baa
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 16:12:37.6557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDSTf6hIfi2ZUAOtzmEVi5AlBH7LHlJRL+gpMgPwGIuKvuRF9TPx90IezFHwD6kvmWv0VWeaKdyAJsPrk/vwiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815

Network drivers are using sendpage_ok() to check the first page of an
iterator in order to disable MSG_SPLICE_PAGES. The iterator can
represent list of contiguous pages.

When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
it requires all pages in the iterator to be sendable. Therefore it needs
to check that each page is sendable.

The patch introduces a helper sendpages_ok(), it returns true if all the
contiguous pages are sendable.

Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
this helper to check whether the page list is OK. If the helper does not
return true, the driver should remove MSG_SPLICE_PAGES flag.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 include/linux/net.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index 688320b79fcc..421a6b5b9ad1 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -322,6 +322,28 @@ static inline bool sendpage_ok(struct page *page)
 	return !PageSlab(page) && page_count(page) >= 1;
 }
 
+/*
+ * Check sendpage_ok on contiguous pages.
+ */
+static inline bool sendpages_ok(struct page *page, size_t len, size_t offset)
+{
+	struct page *p;
+	size_t count;
+
+	p = page + (offset >> PAGE_SHIFT);
+
+	count = 0;
+	while (count < len) {
+		if (!sendpage_ok(p))
+			return false;
+
+		p++;
+		count += PAGE_SIZE;
+	}
+
+	return true;
+}
+
 int kernel_sendmsg(struct socket *sock, struct msghdr *msg, struct kvec *vec,
 		   size_t num, size_t len);
 int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,
-- 
2.45.1


