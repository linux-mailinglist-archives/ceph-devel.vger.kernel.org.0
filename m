Return-Path: <ceph-devel+bounces-1196-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 457668D4DD5
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 16:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54D911C22515
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 14:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B58617CA0C;
	Thu, 30 May 2024 14:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="X6FSPPF6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2139.outbound.protection.outlook.com [40.107.6.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163D717C21C;
	Thu, 30 May 2024 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079077; cv=fail; b=FX0MJV7eWLnsz5hiRrfhzEmCNs+we8e0YO9/hZKOF38eJeFSOQeq/jTNE3kTCyHxmtjigrVpV9i4Lrv+Sb/pJjd8pbcGi/Whhb3+2IIiaGaVANCsqyh5R2329Ksc/b7GX8ChHOkbFqyiwUXbiqkYcNWE4cbGqq566GemVr/UScU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079077; c=relaxed/simple;
	bh=QSGoCRYFgQrJg6IAMM2bbx8tqw5acj3fKG9auEmVDHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e/ZzwWq/LGuo6XNK4WYlUdKqBgk8Gq98XOlYxBVIa1MTlA784bbU/A0eBpmsPJtID0oudMoaXvP3plUBX+c6AXjtrxv+eJnIlzmJF0gxUrTx+o+0vvFq8EuDbr5jk1S03fy/vWNUL5nibe5zbEHYk62nqdhaU2vtCG2jG4c/K8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=X6FSPPF6; arc=fail smtp.client-ip=40.107.6.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUNf5wwyF+tnqX5Dc3VyHuzFEGD5T40bcEGioVljmmf8HJGZvDCUUq2iNCdfr0C3g+UKJV+OwkJR+ywcixuIf4eNwH2uMOTKr+HBcjfTkXZ7aEs2fQbCY1Ex/tXwWz7S84a/46lm2BLrv1fwxY9wp37652QZR2ld4R4pcRyl7OIC54rD5Zy8OOaSiAsZMtnRZWnKkjYupl0ntpWN2IDVQGGbeeXCt4UJSok2cTreJa7SV4Lv8OuipRtwgWJEnfKA3stmjnvw8VDAmOIVcY/nsgchmEQfDst0w9CZcEqpiyWt+mJ21m5X+8Km+iVJ5glGap9GXIdzh55vsP9MorevQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVkNhCbaBeqVcXtN8qAwX3C9rNtmax2JJ1CKS4eYr7E=;
 b=EfWAn+EPlSOLENp+lQmREVlAk5x1pvKMd6uFE3QCYHoh0v1vBn65WVcXvi14VCDQ2bqvdVzfxPtdioSlz3Q/ET4NiijoNzaR3n04FcgjMc1ssUmwYZL5bJIB2qS1jlleBBgal/akgN43wO8r2Zps3xAhlGE7Wc3o7ek6qYWW9rFayIvA+u6PELEaFHFQIqnxPYd0qzRlrf7Xgy0S96Yg00xvX7EyK22GCBBjMfp3yMFsotDTCWcNDxzaaPiT/GFlapqAosNzINF+bwhR7+tw3K2Ymqj5ZdxJMYB4FC7EalaPZpJiTBZE3WCqk2gKzdJv4PwWEcpJ7jd1IwlOZuh1qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVkNhCbaBeqVcXtN8qAwX3C9rNtmax2JJ1CKS4eYr7E=;
 b=X6FSPPF6FaIhpAUTCN2GfuPX/o8/604sdePVqQcs7zorx2yrAQFii1ZOGnMpS1YV3PPJOBLinkorojtsw4bougmvdJzgtvQxA5KAuOKG2uYpKY6nR84rtBFa2KJ6+97QilwMoiujWOLd/XtI2tTeEZvYLLUeZt6FG0UJaxVodKAeCNx49+CUm7r8jkMEpsmA5vVJrq5YKxVmKimPv7AP6wlWHicgQSXpJ+2fpgTzWVr+suIOmbFVkhAEzLxnjBjDBU4FlUck4vfx5gENOttXi6TQPwoyaVPI+Hgo7oKXaXLrwePTQFIBG9GsTT6F9g//xQr8LX1z1EQMUKc5NYHpog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by GV1PR04MB9216.eurprd04.prod.outlook.com (2603:10a6:150:2b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Thu, 30 May
 2024 14:24:33 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%3]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 14:24:31 +0000
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
Subject: [PATCH v2 1/4] net: introduce helper sendpages_ok()
Date: Thu, 30 May 2024 17:24:11 +0300
Message-ID: <20240530142417.146696-2-ofir.gal@volumez.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8fa06474-63b1-4ac3-aaa2-08dc80b438ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|52116005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bylxCnkko2p23ia9I179XbjIsOyxMPYM6cgH9MuuJmofELKRgEx3T1jfmxCd?=
 =?us-ascii?Q?nh/LZbDl9lQDUimIaplX5t5Ck/M1eivWCvffjJYG+u0w0BN5hqEeVpfPMbjc?=
 =?us-ascii?Q?IEXJApLwtBG5B0zuSRZ1eKpjxio8HSEW1TwOsF8zG3vVSSCCBv+02AhdquD+?=
 =?us-ascii?Q?Ja/BBDVBH4irfdo80K1dmDQ/VgsMtn9D0S4Eu4fZa6LOz0mF4Bcj6gRt+ijE?=
 =?us-ascii?Q?jh8mPdTd5C4eMwk4XlBCG7WrOyeQGDxPa/P8RFE7adDacFqgdmgIq/+NeUck?=
 =?us-ascii?Q?+UGd/yY4H1hexAnHqHze/5Cbpjlz7V+AnJGHaqsk+qx4OAzI7acYiAgNDQfT?=
 =?us-ascii?Q?Wqj0qk/bWi1P9cbxgGoQJd12kIDxDfWIx1xh+G0+g8lnTA4IMT0GvG8QAwbl?=
 =?us-ascii?Q?sJX39NvfUK9mCD9lHT2h1IgXqRvZIaO6UoQZ8bcxfAqSu9iLo6vP/yXcMsPN?=
 =?us-ascii?Q?FWQaqzA1fcXvRKQTaL17aVBbqbDF0TLiCk6T3LRgoWxknC+4UjK0jVkho9g9?=
 =?us-ascii?Q?igcIW7ztN+srpfWUyW7RsEKwx8Mf4715J3j0lKZbKSR2acE6OJb4nzlElgVk?=
 =?us-ascii?Q?I/1qSeX4tzeV6kHFeWEaWbEVWb1cEegeh8ccH/1K8+Q3kDLAu6XDgdM4Oq3f?=
 =?us-ascii?Q?97OBFMvYrWUhOeUJrN3y7NJ9BeaT7VUvFQrNd6e4jUP3pUp2VMpEpcR9Xqqm?=
 =?us-ascii?Q?Dd+3XnSntkPRXN7bTZxPc2EM8bTtRgQMFf8x7TUsCPWjS8VHHSQi/Q8gXWX/?=
 =?us-ascii?Q?uR3smLDKMPDU01oo7CISaCLJTBhqrDPicSP5Wa6z1E2jaan9BdGpJeA+tJWO?=
 =?us-ascii?Q?dlWclzlq1zt+pRqPY5dtrIUxpyrPBz2ttW5KMvZlfsTW2ZYTEeZGO1jS8+EO?=
 =?us-ascii?Q?vkNApavCdWS1pUM920dZGyYU6nqA1qOSpHVwJJY9ms6EV/iwqNI0RruZSVz3?=
 =?us-ascii?Q?Ks6AX/Ki5vLD1hEGwt/VMATtRD4QbDQTXxKJTeWRobO91NnuLbci6mMFQ4QZ?=
 =?us-ascii?Q?/MTougoaA2l8s2W7eezlXQNvap7IDinee/yNDpmKcmS8mKyzHaTyRLAH69y4?=
 =?us-ascii?Q?r1YiDFOriSj6QtsxsXMjqVdtnBuuiDay+yRxpsSIXWUahHqeIj7m12cP9Tsc?=
 =?us-ascii?Q?DibrojzZyIFQf1iuzkCUmtl3qaPA9lwqXBXqBBcDOglWPLYsYZ903uWyVPXA?=
 =?us-ascii?Q?d7MOygVo+7TtUxXjur+18kMhPC/IK2UQicGV+hNBhfnAO6x5Q3tbEysvkr7q?=
 =?us-ascii?Q?suLQrk14yemngCCGy1nFMXr9+U5Kugcmc2QEgx95Tx5mMxr1GtC6eGCRUwXG?=
 =?us-ascii?Q?6DsZjbQpnN75iXzbX1wLaRl9DfFNq1uRqcEb4jxaYxTSCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(52116005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oLNDsvmOdfLNXti1qQG5ZNtRnfQpbF+5HvgK2ON/LlJkQAR4qgq1LAv18WpY?=
 =?us-ascii?Q?3ojwTlEmmfmOPPHEtBLO5Va+qbuqNjTYNXz/AkiJHh3o/bBYlIJo5L582lUA?=
 =?us-ascii?Q?BRwrHZjVqxpfzXM+rbNuPf3wvR90zB72kw+81qwChowVV/Dcb9Rsh+iMYHi6?=
 =?us-ascii?Q?U8m+4F6GUy5vEYvd+JITZWqra0UstVdBA9YFd+FZs+K+IcxkSdan0mcybG3V?=
 =?us-ascii?Q?OcMurv0hBCdmS03kLiSQp0L8SkRdFdDa/BwKaBbSvTBTvjdOkqNnL2eLhdSV?=
 =?us-ascii?Q?Je6sdTKjugfDIreFsfSMryv2IUHuBHBXys+VurURKyYjPDBm79wuz+avfNHd?=
 =?us-ascii?Q?qHluUlXyAvhdEmusnho5yf1GCLeSAMPJ1U2jWuEhP9vIKyRsHj+O1iyBY00L?=
 =?us-ascii?Q?WGvm7d6D0ohDkiCSMo9Rho+BS2lyoWm/dDYYhktT6qky3o0/x2caVJYcfX2/?=
 =?us-ascii?Q?53YN1123GBvzn9GwDSIhrsv0ha9Z1oZ8bgnUwg4xPPUnaoIon0qj984aOeWt?=
 =?us-ascii?Q?gnC45Od4lY43W56UUlNojigH/vDb0u44l+XwWH4HSgFrMyA6c7Krl/CkhzI+?=
 =?us-ascii?Q?MCgHRvfYSCKZY1UsshA0pJPZJIx/U6IfBJia6BomRRsGhpEsZCD1HsqMiPFl?=
 =?us-ascii?Q?DmIWTWSAlMi79G2cJpZVnEfM2HoWNhoGXp0KGRz7njYBuiDdNllGWeHIH+7l?=
 =?us-ascii?Q?aHFwbaM468HibSSPsqQs7+7vQBOOT6SGe+z3rP3zZGixJOLeEj0uVi6Phoc1?=
 =?us-ascii?Q?jXmwtcqoKikGq/7ggDdwSogc6jK7IBD7G9oYr7Du0EP5ZJ448ypQuxF4xFjn?=
 =?us-ascii?Q?8v1USi+io5SJqb9HeVi/xMYWdVwKIrIjMWE4cyOGcvtGj9ds/UJKN1eY3jnY?=
 =?us-ascii?Q?XbSogV1HFJ6cuGKreAtHCg5loJUh2mIX9duxpJluy0fLSyU1tIUe0+SoNxnl?=
 =?us-ascii?Q?gbK96Ur9EioC+4JAf+pd2Alj9rHi4IKLuSQNYzzgHCzgwtSTAXdxjoeV7fOp?=
 =?us-ascii?Q?P2DcxDBHDq+WZD+BU8EBGt4IHcWnQZMdur6YwjDBPxgdmJDmUlfWodKrxauI?=
 =?us-ascii?Q?no5za5NvO73ynVhj04+bK1CsEmHxvv1Ax0vySFykMeYRPf2VZK8Tvklt4zop?=
 =?us-ascii?Q?Bh/nqujfi8HT85ch9R/Z9hhb6P0YbEts7wfEvFYRJ+EH0V7qGDOeakAUOw4r?=
 =?us-ascii?Q?m8OsPXVT1haL7BrA4nWYZlsyunK02PbI9D2MdqFOtlopbZhBN8u5+QrUeiuY?=
 =?us-ascii?Q?BovTH4CkXpJJ9GwmtJ/dCmRpP4uOnKN0KnksK8dxG0NUWAJGI6+OMZFQk/Rs?=
 =?us-ascii?Q?F62+1OllIQwlVeFVa19Noy2ZL7rDdv2exUcoLYckX5dYQj5OkJnHZ4fh7B4g?=
 =?us-ascii?Q?UycjX2yWFGgHZtXsTrpEDU++r+i/c3wPBIrP0paqiztSrJYfsvp5qZrZU7Ht?=
 =?us-ascii?Q?KaLzB+fx8AW4cgB2w3e+3jYKhtkdtTaY1z3fsvB3ahc6yeIZDJjEvjxgBarj?=
 =?us-ascii?Q?deZW6TE3zy6XY1XJ5PWBDfrDVnlbCJ5Ns36Rrugr2VPJNRBu/ULxCfizitfi?=
 =?us-ascii?Q?LZxI60l2xHKPYxHJadAnSzE7aL5IpuRuZCddBRgV?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa06474-63b1-4ac3-aaa2-08dc80b438ce
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 14:24:31.5922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bl3T4IpVRnt7oc3k6w3cq0qsPVnELBEi7rPiNprGV5K9r+mnCOMdXrjRy9v7/K1ZQYpCku+mW7rbf8H3DtIQUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9216

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

Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 include/linux/net.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index 688320b79fcc..b33bdc3e2031 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -322,6 +322,26 @@ static inline bool sendpage_ok(struct page *page)
 	return !PageSlab(page) && page_count(page) >= 1;
 }
 
+/*
+ * Check sendpage_ok on contiguous pages.
+ */
+static inline bool sendpages_ok(struct page *page, size_t len, size_t offset)
+{
+	unsigned int pagecount;
+	size_t page_offset;
+	int k;
+
+	page = page + offset / PAGE_SIZE;
+	page_offset = offset % PAGE_SIZE;
+	pagecount = DIV_ROUND_UP(len + page_offset, PAGE_SIZE);
+
+	for (k = 0; k < pagecount; k++)
+		if (!sendpage_ok(page + k))
+			return false;
+
+	return true;
+}
+
 int kernel_sendmsg(struct socket *sock, struct msghdr *msg, struct kvec *vec,
 		   size_t num, size_t len);
 int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,
-- 
2.34.1


