Return-Path: <ceph-devel+bounces-1321-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B879032D8
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 08:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98DB4B26EF6
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 06:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D99317167D;
	Tue, 11 Jun 2024 06:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="nCDMcBQL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2113.outbound.protection.outlook.com [40.107.247.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5176F171647;
	Tue, 11 Jun 2024 06:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718087794; cv=fail; b=RGV1r9sRA+7QmCcP669u48RVLAjXAZKarG137tKkLcVVC1dGEaHrtQN4fvG2ZzYr8OnXkyIaGmq435jFNVhFw99FWlm0FnJiw8qhYmblEMGacWrAFxn1VluPhtagMW+B3BkaESgeOm3BDCdbepVf1qS1IndLH/A+egTMwTdq3jA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718087794; c=relaxed/simple;
	bh=JvGJVB2TWQx07cYj81j3WvS5qO3qZipt7/2iFRhd/2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dMRnhCPtLA3LYPgmVNnRPc1cuUlXvqbQnAtTIu2ij7wWMM/Ikel2EjRDMDXQnSh4EUPbDVtyTGTtjj6c961ZMdp+T5iYnBJUhXeMTA7A1KhZUvEZJcLs5PHapgVVK0UYFCSxIArsvEgzuqn2ppZT3kZZZWOOXa05oB+ecURghXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=nCDMcBQL; arc=fail smtp.client-ip=40.107.247.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmSC32iEMi2fLoxgMFPOZqz1dLpufBuQCi2xTKXSrb6idQV1gQkQZ0b0090k7yFu8Ba8t3ovkt4KM/JsijPE1NqcKfrdZls6zSSCSKuOofUagcFOSWGx3LfMAaqprw6u8IF5pM+Kr70GpwOpJzMWSrVMrFcbVz/QrtbbEb3/ZfL4Rxh2ltDeJcZ2h+bUmk1JN8J4WJAF4Gk4aj5tFDx2r9811LswmetEnW+F14IKDopoizLvWB60cxz9Hxq2XXqg7S2GYb6M5Od6hBj4z8k+VBjfvnrjcchRNTJxc2O46PneJWfGliOYHYtseZvpep3qVFPKqh4Mtns5MbUW7CwMIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpEc9IbUa5kZ/1013u1ORU9PTtVQZpUlS3RuXqB7dzo=;
 b=gjZ5JprsbXG8aenzqr0Q1LfE1paV9ZmX2lq7mHzeLFgGZ2MTBE8x9xQ2CkQcE4rnaewAB54CwFiFt9awveBa5MioCY6TD2fbdrT4uexAnpKfrYDgIwsXT8ovRElYQ6o+fIDMW93AUhv2T1vHBrzPxfbz5Lp9yw9TyCegJKPraz+jGOrMu5jAxepUGnqw/yn5c1QSlwEmOXtCo98l78ZUZLQcNPJJz3F+A1NDIn2sgfuATdrb0oD6aOaEekyuzYZvdFE88pqPJzQjMFcbiaHfeRKmmNhcxJHJQ2ItxUpUzdPOlTzY9E8YhAoJsmR14yKB4uccjmRBiv968T+6409GvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpEc9IbUa5kZ/1013u1ORU9PTtVQZpUlS3RuXqB7dzo=;
 b=nCDMcBQLfploKjFXsuR+XftmAHdCNqPbF2DzVLBn9sOBr7ytjlNJc8IVTZD7e36ibjSDfPH0DB2LecOZ38c+eS0oYWks1OPEL29apVCwi0h/HaVUVAdwyCX9kavAwsOri40h68+geF70ob2z8smw4xwziqi38QGoppwZoe1BKd+w8EKdCJVxxDdTfSj0jlh1FxNiFWETva69tbZUzqKDzFGsz7sP8+cHtneIGQsLwXebTAeDCNIkfuol40WQogYOvjWU+UbC2rHF9TcvkIqOeX9h8E8zs8Wgo4O5wTyuG5N9OJi45Ts1gc3OlBnH3c6j/xGeojjZSvzLfsdrbc6p3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com (2603:10a6:20b:8::21)
 by VI1PR04MB9977.eurprd04.prod.outlook.com (2603:10a6:800:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 06:36:29 +0000
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371]) by AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371%6]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 06:36:29 +0000
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
Subject: [PATCH v4 1/4] net: introduce helper sendpages_ok()
Date: Tue, 11 Jun 2024 09:36:14 +0300
Message-ID: <20240611063618.106485-2-ofir.gal@volumez.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8860a05f-0cff-4b5a-5acf-08dc89e0d3b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|52116005|1800799015|7416005|376005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KzI2TV2L1TjoxYMLUsa3fPRWcsDHjzPjpyfMAaQOwzoHnAR8iWLe1MU8F6O9?=
 =?us-ascii?Q?G1CuHsNFz/c29MOWJOJGByvyzIWEYHjkjH93y+FuWEQVsmGopFTq86KeRF9I?=
 =?us-ascii?Q?ZGA2QC6VdUoWictaAhaGXll5bNc6X+tkZ7Z5A1Bx9PJITrnbugBjBchIgGlF?=
 =?us-ascii?Q?EzAQ4lO6xoS65kARSyIyvpSEOkYMIni/3bdo3zGpvf2zTmws8MVcA3Yj1ZRJ?=
 =?us-ascii?Q?5EKE/nf1bNWmKDQXTk1GBE+i66b+R2VJ+icgwSTODOR+UqKLmrfWxblbsmWA?=
 =?us-ascii?Q?jw9eh5ONrYl3S8hazVtQeq4W88uiCZDiUuZR76ALIIkGLRMhOxKLEcmKC2rv?=
 =?us-ascii?Q?B95JeswYq+RiFU1oTcP2rlBcO9E2Ll735rX37Tyme5BN9dgb5UeG6E+uMi7V?=
 =?us-ascii?Q?6L//eJ5mL66wrhAAf5LocesHUWm7otNZCNKCyruTun82su1IrStNMArKeIiF?=
 =?us-ascii?Q?y6WAnCb7MW/8bkFhN0tTWGKeFMZrBMAj2dApM0HRPa447xCHjge5OHdVPsNV?=
 =?us-ascii?Q?94AkASP+XY9zcBHNez/btvOfVVr69t2loABka3mXhzM3HWmCzVaZ/FBfz47I?=
 =?us-ascii?Q?ryMBj6S9oA7gX8P8mmeq9FjAUvGA4ZKmCgb5K3aRzQtUY1LkMBM13dHbxh81?=
 =?us-ascii?Q?Msx4yVIE5RuV0XHRZX7Gc3EvpqE38e65W0/HNmVVjnyS18he9ta3+GJV9ZgA?=
 =?us-ascii?Q?+kHUOLSxXD2Q7KTW14KnC6pPiG46sEZxCrQ8r/+Kzk/dBqV1OfZKw2YMOFzX?=
 =?us-ascii?Q?EDsweFQcZPTnisWFQ/NHNIW6K9psGc/kGOFbjoczRVl2lvr2a83q7RMWuY1q?=
 =?us-ascii?Q?4Ja4qSEJfTL3GA2z5BLdBnH2a3CvB7zfMnGpirT/dMaJ5XdmrEsjZShax5y1?=
 =?us-ascii?Q?1vRdnnnwB/LH+LhQW3FRDeIJVi7fTjTcZyq4pprOmXPJxNiCA4RHsnPx6KSH?=
 =?us-ascii?Q?oA77ZcshorGnbwlNy1X/u2iZgkSPIzKXYVRiROXkPHSpqzodRj+UPpfPtbBO?=
 =?us-ascii?Q?aREToNP2HXgsdl51jg7FhmUdQa5F4++hKBkiydX5Dz2Kooz4Si2pBw735vhQ?=
 =?us-ascii?Q?3HGKzBPPhnOGtpouTDF69xC4yCvIHc9/2jrBZBM1W9a8nzU4AUwfOsf+LAxt?=
 =?us-ascii?Q?g273L4OmoqjoIM3HcdcLxbmyrXZF4Ubd7BPiTUpXYXEbLfBg3nuGaH61/6Q9?=
 =?us-ascii?Q?uNh1jWO8bCxRHycgT9pUnNgL9bckETfwjeVWXJRdZsYAp3GKyCb9ppXBagIO?=
 =?us-ascii?Q?GHcdYTCGn/zuzv2YgE7eEhRYBJ+4HQV0v441Yl2yY+Bt8qWy+YBlwIr9blqm?=
 =?us-ascii?Q?Siqe223YbXpHBYnr+LbgDBIuOWUeolZWp0O/FlS2SnC2FJo106PacDXGHUuq?=
 =?us-ascii?Q?Iy3SHJk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5110.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(52116005)(1800799015)(7416005)(376005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R/JFLKILAfVjHWNZoqyCC5UeRdvt2XqvCh4dRUZcCzeLRaAbWK8aHZgjLvV6?=
 =?us-ascii?Q?lOMqjLDn7ktkTFnX/+jHfCMdXYB3KGF68Z3YpeA72/mv3PNifsucsOlUG2Wx?=
 =?us-ascii?Q?9QBNO6xHKp6fFuskl+8/h0/PKLcyAh5bMAjEjGZ1NCCq9RIUJsmkNiBD+Hcj?=
 =?us-ascii?Q?tDJiITPG8JGMRtdt5q2Z5g+rusLo+OvAQ+lQtI3e8U04/mo2tqUJrA1wEoyG?=
 =?us-ascii?Q?/cshiwO0UZteLYlQ9Uv+C908VConm+d7DJKgRHWifZA/ouhWhUWST/ZSRlUD?=
 =?us-ascii?Q?gZaFx8mFQrHh8hvN1xs80iAkCdEf9aLBMW0rXuqVIEgmbDAjdxbTzWDPDfNN?=
 =?us-ascii?Q?BwTrbFaxKiNRcFj4ZqJUheAZwVsTDwB0+aoGSGlpYdQqlzeOH/fFMlT6td29?=
 =?us-ascii?Q?f7yAUbU7nvnnM/CRcTiQJuO6ZK+f3OSUfTyamSKkpRovkK8zW0l58+3mCnmF?=
 =?us-ascii?Q?erf6pQSq2Jqs+cHe/LSq+WkNHUjmfo0gyRqKQzkd6OAZ05bznrxN5GUi9bM6?=
 =?us-ascii?Q?3rQzM6DbfZHgnSlWdmj0dP6MbhhCsvUlFJkjZeDrOHNSwEdXBB13ep915v8u?=
 =?us-ascii?Q?Kt5NL8xfjcMEIe3KzO+wC5UdD8VvT9jZ1wWRPsBYPGRs1jlXMOCysU5dXo0t?=
 =?us-ascii?Q?KB/WeKzDfe5YmwNRvpoZNvlyNNu0pNkvDcdzdSel8QKjaPisKaeQd2WviNdG?=
 =?us-ascii?Q?QyzWCliEM/Nn4a6DoQWUcCUfFylpIqLeG5l3TpQbQJeUIae/qjn4eBT/M/E3?=
 =?us-ascii?Q?3V+E9NlCvjLni2sSAa4bwSH4dT9dlYO0GKVs8jh0nCOroglD9vzLNSJJRve6?=
 =?us-ascii?Q?mTLOF3onZA5A1hrAaIH736dmkCZFf9cNeyIFqDLpCj4Ppc1VNl5qBYJ6jV1Z?=
 =?us-ascii?Q?G50L3uBdW8ngYrdg7KaLBPPJOdBSKBzB69u/557QY5jWZSXeoJjJvanl1NjZ?=
 =?us-ascii?Q?BTVfMLrqcCKLF6pnhRfvGXaecznSq9s5HhztsAB8dSEoPZU7iKzNdzbWO+gY?=
 =?us-ascii?Q?ZaB7XR0BSAIdsO2OcT5mkYDH2pMegerTgQhb6ZuGd4GuFNGHqCLvt30vcnKF?=
 =?us-ascii?Q?vEY0eoCEicPHFpUkz7S8w5OdxFmnBtKtohwlIZWBtL1QRrbeOE7W2liJ7qKT?=
 =?us-ascii?Q?sWRgx1KX6wehVFuGqmTIhwYNK2BtS9G3maSEmIdLMkoyv9a3vgy9ZYHgD90S?=
 =?us-ascii?Q?ftcsV0t2MmhP0KOkKMZQMfUD4KlOVboO9BD44fPRJwbRKHiNT05nNrrcXHYi?=
 =?us-ascii?Q?oTP9KGbv9M3ky9rs6JPixwBTBabfA6PdE4VOhJ99SPrjajUzO1vtkFt7r0AO?=
 =?us-ascii?Q?aWSwlSZG1YUk9ju1SUJDWWQf22auvWoq6/yH1B9ZpO3sEHDxPXI/1SJ7x18w?=
 =?us-ascii?Q?bz4nNGBpmDdf1gB/d2f2xjb6E40vLRTDl+ixGhZtVTKqUWZcVYVtKT8fjgKd?=
 =?us-ascii?Q?1a+tW77pUkAXN1KUhAc57Qs4gvttWc3fs/i88Hk2ld/K9sfV6GZxukCEmZjG?=
 =?us-ascii?Q?+dYe6cCIedTzKDvxWH/PXmlyI29qufWgZlxEIjcHI7u8hVX5LGnB/C4NRD4K?=
 =?us-ascii?Q?Om6ELJ+SSZnH0Wznz5FYXmO/NWfYG/H/wtBY9JxC?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8860a05f-0cff-4b5a-5acf-08dc89e0d3b5
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5110.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 06:36:29.8296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDenvQOw++f1Gxv125oRbS4a9LfNkjxKWgIl2fEHXf9vzP9wAsD5zluYO462dXRsbLD39zwedey+tTkEpsH1lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9977

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
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 include/linux/net.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index 688320b79fcc..b75bc534c1b3 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -322,6 +322,25 @@ static inline bool sendpage_ok(struct page *page)
 	return !PageSlab(page) && page_count(page) >= 1;
 }
 
+/*
+ * Check sendpage_ok on contiguous pages.
+ */
+static inline bool sendpages_ok(struct page *page, size_t len, size_t offset)
+{
+	struct page *p = page + (offset >> PAGE_SHIFT);
+	size_t count = 0;
+
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


