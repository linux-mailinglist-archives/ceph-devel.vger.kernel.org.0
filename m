Return-Path: <ceph-devel+bounces-1539-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1AF934A4A
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 10:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9D421C232DD
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 08:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A66F6138490;
	Thu, 18 Jul 2024 08:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="iYOIJh8R"
X-Original-To: ceph-devel@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11022116.outbound.protection.outlook.com [52.101.66.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716AD12FB0A;
	Thu, 18 Jul 2024 08:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721292336; cv=fail; b=ohfH3xGJUxKvgkrKU3WOWWyN5+qyHfYp2ZzlND0IIKMl3aVDJT04sIdcZO+eoLTT9IjvfDHNl/hGGk5kZtdjjV3iCXAzAid3RGQyu+0t7Ai/a1fpmBdM8H08vmhR8ugFuBnT59j5nn64guPpccfi8OEdX8G6CdhYywTBIoaU1Vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721292336; c=relaxed/simple;
	bh=JvGJVB2TWQx07cYj81j3WvS5qO3qZipt7/2iFRhd/2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hILXToZYEu18KfUmNVt6L5RjZhLlTdVGRkjVT5AJaAgspbS81JFKi/AKcBPBaZT/l2ChmmW1q9HjBp2X01uUOLY4oKlplDHeTGQeLxKUlhqVmQr0KyKO3TBrkp2N7aO4ylG0Hmjpd9ew6YZLVhB1+hYOSSVlRs9llfqv0oIOdqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=iYOIJh8R; arc=fail smtp.client-ip=52.101.66.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=se4CLOYxim3/XaDVgOJXo5foM3fVXwIYk8CIlmIhXyE099aL/WfvbQUNUG6vWj3tMQebAuN87ocMWDI/eUyW0Ti9zuvcWh/fozsXMYSQ8mJPTq5AM1JXdcGjVhevoHH/RiwFtK+tg2uZhz9hpfMSSSz42cpbSud6IXqgBYxPNgpxHvXxJwqoLTtBpmER3GKJri+oJVkqfQePjavJtnMgwG/ts0bX2q94dagNQNqKk6FHjwvIVHGXMUtCb13kz0VOWru/QeekruyZCIBAHaNzCoy5QHHpffMyEdbz3IP/HlxbDmDgtXOPiOV7zULcHCFtdnA2kWma9r53OdY1KIRLYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpEc9IbUa5kZ/1013u1ORU9PTtVQZpUlS3RuXqB7dzo=;
 b=KS+WOQIXasDdSxY2V4lB/epLpo0swlVDivRSRtRRVJWuOn2OYMK8K5hcCHUM28ueUcnJlwNjb/t00ZsmbxKU8D+lSNWkJcp3rdx45wDUoSlHK6VJSVVHI6DM7/uO1Ic2VB13FRxAlyVeW8De9RftIaQr4FV8HPCjUeNczMFIUOIott2ChTcaLAM+lPGDn1ct3Jp/+shR/LC3jiH6ZGuOdKqRInjMXB2sfk7FmO4jlGxtRs4z1JQ2oMyL0P47qbVAO2Egu7JdFT8s3TJFvfOPUqnjOeSqWQKfHdzV0OcvapawUWFRlNxVSUHDHGbSfbG3aE+LeQ8NhNlowMksdrnKqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpEc9IbUa5kZ/1013u1ORU9PTtVQZpUlS3RuXqB7dzo=;
 b=iYOIJh8R5f+Kd0sXrf9FfZkIYMjytDWBSgI+VVX0jmNBK8NFvvB84B3uUTPJTt4UyvER554iPdBiaucM4DcNiOUo5nEwxU4295NUX6C5uBwLHfUhfoyXYpjbmfS/9bM9XvQF9s0CaOo3FknMnq2i+Btua9/YSpFSH7GXtHP61ovWskVwy/VPujaEInpAB760m8H9ttwaT6aRAnWaKyPBxOsM9kI1ih1o/2sCYj2Sr0TA4PBxU8i9/Qcj660uFRwcOB4HWo21Trk88dy9Jl/Ijmh8Q0JgnMCAljPiIGGMnpy0DeTtWQnqyu2YC+JzSLcNkcWwD66sUZQ72OhrRuGfdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by PAXPR04MB9005.eurprd04.prod.outlook.com (2603:10a6:102:210::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Thu, 18 Jul
 2024 08:45:27 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7784.016; Thu, 18 Jul 2024
 08:45:27 +0000
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
Subject: [PATCH v5 1/3] net: introduce helper sendpages_ok()
Date: Thu, 18 Jul 2024 11:45:12 +0300
Message-ID: <20240718084515.3833733-2-ofir.gal@volumez.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5453f723-6ed9-421b-4a1c-08dca705f8f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jZeKhkK8EotUN44Jn88kYDZF5CUUDGxocoxmoklIThdGIDySiqglFXqtahA8?=
 =?us-ascii?Q?kbUihirSf5EPPeVBESLP4d4lKAanj3HcJjR29sRbWqK6S+sHRRdo52aPW/vd?=
 =?us-ascii?Q?1/dpir6NXmxxeiGuYS+P0PYWO0J+6TWLv+anfOGrrOmSKXxxAgrPy83zzTzy?=
 =?us-ascii?Q?VYS3IuwlOiqI0dQlhNph+qezOJiZdijIA6LH/oc5SZ8zPwVXcxyG+/PIyC8E?=
 =?us-ascii?Q?sWLOw9wYv07Vgb6dev1TXoyBXyacZtaLs/Logp5iYTyM91Mu3wPfsLZtiOfh?=
 =?us-ascii?Q?CiRu83upbhAlETGgcem+sWpCzZr1oAQRAHr7X73z/yeEHcCl/ZIcyDXcH07Q?=
 =?us-ascii?Q?cMnQarM9nKheQibFLsnSYxrKFc2uirfIrYyUwwN2brxzphY7h34YpbGCdAOE?=
 =?us-ascii?Q?+UrebnvAbDpH9aUz7qUsBGTeyYs5yBeatrG8iDmoEBXPvZWIbQJDqvLRcRAZ?=
 =?us-ascii?Q?T3l8DBhcyg8jMXrv9Ozv+vA/2Ldmr3pMl6uxx25OMcfEPFF1xcSpHCeVigkg?=
 =?us-ascii?Q?KF+VElWKBj+dpL89S8fO61FfYKfcMzrzJhjI0NM6Pxes0RaiPRDmrodM/1h+?=
 =?us-ascii?Q?XaLvpnF58RbRtI2wsBZ5+Sb0oUaLspYqkE5nlXLMMm+WyKi659TYVo+j/5wT?=
 =?us-ascii?Q?oVCYc6P2b1nBqSmST/t3SGc0fNOwfDWQrDwCkH2Ed6NIuI5wNITZrLSooJd/?=
 =?us-ascii?Q?G9/zvnHYLQ7ov3S7b04Z8RjXFHTZXss0xPOMfpB6W8ic+waW5snpXfd/sml8?=
 =?us-ascii?Q?SoXNo7AWc6pVjZtI5d19y3QDlvS+aPWqwB4JGYT/hbCDUiwzCExhYQo8n94s?=
 =?us-ascii?Q?hXS8IIf5vkexdM0mDHV2om2w4IbPevHGshOqfb38eNxEX2qmobINcjvFm8dc?=
 =?us-ascii?Q?vbLmf/pIinQ+fXX7R3+6p/H2BzxWqKbLMeVlpeS2MlQDkQbP9uYbEfZCj+eM?=
 =?us-ascii?Q?TRYoYpECNFnxwTYnbVlVgRS/g3ci1b0K04iSSN5gFJLNzcVPoXAtv/XPBlx1?=
 =?us-ascii?Q?1emES5KRo5HqOCuAkBEVWslr8oDq+GQqs1rzmROTgPNO7qxZgHEqPiC23uFy?=
 =?us-ascii?Q?IKmvV8uG20wwckx+QtPFnfJWH8NsaMMLk/Gw4S83QW+h9GcI0Y6CBIdFVkZc?=
 =?us-ascii?Q?xdwvOCQsEvoCz7zYRUrEKSzRcmNKqnEcJlggHpQWfaAUEUavUXl/x3XS3nSi?=
 =?us-ascii?Q?Aldm2a0gm+dRruRQc7bJmpk4nam5ssn/LzR9Gx6zLB9hHUBAUsUcbxLaEzxQ?=
 =?us-ascii?Q?KQ7uXVlME+knIXpi2Ynhz9CDE6b8obCDYLydcbQOPvxNIvjTN/9tLzBJH5b5?=
 =?us-ascii?Q?XHWPFjZwWvVaPqNlbL/rzXll26bnnT3wSIyk6+IL1YwH+TlbnzXO2P+vCwn8?=
 =?us-ascii?Q?zFdcjGm9q69Bi7YtzbMqpXfB6K3egRC2nlaoQaFFuhFe8MAkRQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(52116014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?78SF13xGFqv/MpOUDZs0783xW1eN4x4n45xCbyYtTRRhMvWjeYwes75qTsm6?=
 =?us-ascii?Q?ps0ruVlj89il6yqlhsMjQE8UhjJAFN4DbxDhCA+v+YJHydEOM4jMlJvRAJ6H?=
 =?us-ascii?Q?eD6n+vYLmXl+0vJtxawP8WsnnjvLpIQ0HS2rd2+V2+9vddILYiP9C2nmQYgN?=
 =?us-ascii?Q?AaTBc6BcuPtzmQWY6kT3m3JJNuJFHlHvnZZXFTgCDrAP58CO86q2bqd+14YW?=
 =?us-ascii?Q?2yxSd1o9cYtnmaTXilqqYX6dHDSnWkrmqkVkV2j3UkE+8raIRMPRBRLQgCqL?=
 =?us-ascii?Q?KlYqTW0apebqJcNGnhjC5O5LCNk4F9DXc/7RGBgJHxgMwo11ZNegdhSe8bVf?=
 =?us-ascii?Q?Rxefrp2l3gKLA5dySNy2vca+1DK2FSTSntG9aHfqsMzpDvw9AEm+b4vf1lyC?=
 =?us-ascii?Q?Ua9aEmd+08PZMP6ASWtA6lPejTh0dEAeBjd+E0VW4h0m+RuRFdI5opp8UJjY?=
 =?us-ascii?Q?2ePayW11pBsnvW2rMYHHzGk6q0VnX3YHr27lnZPjLwJ40JdRqv/wBa2aIQqK?=
 =?us-ascii?Q?lhMOG/p4EZUqraolQIyD5OKoSdg6SrFMGQBK4Dn5Y8ivLZvCjWRR4hQoK18R?=
 =?us-ascii?Q?6aNBkhwc+R5CzWMgkDjs2sBrkKzXRqfg+o+zYpHgdRK6zyTGdjIMJipus39m?=
 =?us-ascii?Q?SsjPewX0dWccziSyxSNYiyHBLEjbUJOSaXgdkZizAcBweZWRorZNHcHgssyl?=
 =?us-ascii?Q?/gq8HybDt0jDxuKqfRHyS1N6+0CGEckcksaf+8aPVy0zjmflwlMfvWmpjg8f?=
 =?us-ascii?Q?1yl6VS58kkBEHKk6wpVEqojtpmvc+ZJeGy3CD6TvO3eGJBUS3ukZx6kxOgjT?=
 =?us-ascii?Q?DVozAFKAbQqrMIHPs+lUnf61F18TKvj6fGWBtKho2bVsHZWB6k7NWA+LIo13?=
 =?us-ascii?Q?XPrLeQ1oHjtaKD1APTZR3HskjRdZqOBdY/9bY2XtlAEZVzibv0vIOXUid0AI?=
 =?us-ascii?Q?Lci020Xo3S/KvUb1yOEa+w0gMzfpSx0HsdMSphwve6jIAD4R7HGECaMkqDhS?=
 =?us-ascii?Q?5Rz1q51C/4YJiPa2jkZgsXjP/oMrmoPVM4/l6huhqyjlpB7W4IrtGsi5RgcR?=
 =?us-ascii?Q?sbU2Ng0NnYg7yaDS/FATmz4dKWjLZ245Mw44xlJIgPy3oxO7PCu9L0f2zH8j?=
 =?us-ascii?Q?UrYmx4cREhMTEFiZpTHzMOrKPodufZ+YBGhGXJXNzj3gphlFtAntgQiAIJDW?=
 =?us-ascii?Q?X/6FdK9i5as0duxV+/q0tB0/9odJhs8lY4ZT53veQBTzk9jaGVUu2BBhESAs?=
 =?us-ascii?Q?jE9Alt+Kv5xNdfDKH9fjki8E489VavwvN4RWQX30JNkEWAx3jtbr2X3UK4d5?=
 =?us-ascii?Q?VCHitsQpkWdBWZgdY37fZL/ZKq/2aohCo2ziZDt1wZZ+MssSKywtypB1bydO?=
 =?us-ascii?Q?/T5tanwh5QbVgR/u2ytkscmOdCeusCkFdgGeb1hkWQmgpB8L8tfAlTeBC3bz?=
 =?us-ascii?Q?qWHvS6g/Jy1e2YdSxiuSHF/I74dcZttlYWZPmNxfn9DQolfvsWsIVdzky+BX?=
 =?us-ascii?Q?vskLX7uIAoW1Rs01WWKdPh6Jf1CkMbmBAMcw4NhrL7ZJX10c0l6iiK73wZ5G?=
 =?us-ascii?Q?MQ97zcVI27n7ud/YJZZ3q5iRU4xrIG1eeGthu9Sx?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5453f723-6ed9-421b-4a1c-08dca705f8f7
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 08:45:27.4297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kcVd67n/6a13P6SnNwdYq2/fLVTgaGWlvdKSWExGf9Efz5imAXfOOh7j/jA0ScK8CBM7xTMG3PYJ3FARGjTjOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9005

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


