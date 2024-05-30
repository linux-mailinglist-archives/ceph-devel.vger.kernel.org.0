Return-Path: <ceph-devel+bounces-1191-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E60CF8D4CAD
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 15:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 122A91C2175E
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 13:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD9F183A61;
	Thu, 30 May 2024 13:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="VW/h5ZwZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2118.outbound.protection.outlook.com [40.107.7.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB4017D8B9;
	Thu, 30 May 2024 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717075619; cv=fail; b=O1jTBt2pSGasVrVl6bSoGvMmARY2Gwazx2Lku9pa4c98YBF7Vot0fhXkqg5DQ6dGRAvgjzlsXG8z2+g0Z2yRmCdSpsvYewzMvGPelmp8r7Hh4+CFTepxube4MCIZ+nJ1PYvIp2FqVt01Z2+EqTbDQ0//teuI5AizGpEPxpFH46E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717075619; c=relaxed/simple;
	bh=QSGoCRYFgQrJg6IAMM2bbx8tqw5acj3fKG9auEmVDHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q/gFnJ4EtdwPNuRUevXkri2612E3k/hCqfM4gNYn4GMLFqupAmgoQQp+Fh/3eeF8WZ+a0EKkUsTB4mxpoR6uhqhiRZHAhGCjWinT7FdBVh/E2O+vNmqh0jUWHOYsBSIX5skUffw+psuk8D+7ZQFbBnz1NPHbXMOCA7dhwQH6Rfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=VW/h5ZwZ; arc=fail smtp.client-ip=40.107.7.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSavrcyaD3FwTKJ9w10+v1BSm4oqZ0dW4idNJDeyw+smt0FaAzLK1LNyR5m4vAmY9tCHkFOEKW0w5+z0jOm4cdQOD9o6T5baYtq5X/LAIDt9udEyqXi+ifnFNTKe68764CDTXimPXafoOkpmLtST6cvojYeRdkT6f+Zq5naN5NiPut0/80DKSLmcA2Nk5Pdva0InqQ4UPoxmagu5usV5jnKpJi7PtK5Nfc9a81c1d4RM5VAk4uR+EwetcFmh/tQUVMd273vwjMV4Er+ttVNyLC2j99hnS2T3kKR69g+0RadlWkLczc42eZU7xRC7PLF86ZRI1iXb+NDOTlo7MPNJfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVkNhCbaBeqVcXtN8qAwX3C9rNtmax2JJ1CKS4eYr7E=;
 b=TeC2+QFDVKwYm5id54PiSYLDww+vxqVtIJIVe6gSK6AgpCVMhyB8eDf3PY1zs0jtrX32QMQkHqRXNg8CTMw5G53U78fOJJrpGUZddz1SzGwGp5WhTqYaCP45eUd5XG/QDjUMMiuZ9Hah3dfRPal9o0R/3x1PX88ae0/iNJRn5qVeMAaq4VmaexLkxh+KqYP+fj1zvX6FuKkOoA8litc21cumEnvwlmkp3ovmCt5IFoZLvYI0TknzHEDM8tyfOqb23j8JiWqAoMhXuC1/2fePkvt0sD6vj6Z/nQGrSLKtnqX0z1E3kD8GqycdTZ2KJHirYmlr8ONgFCCyrjqsP8R7AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVkNhCbaBeqVcXtN8qAwX3C9rNtmax2JJ1CKS4eYr7E=;
 b=VW/h5ZwZHOOU6z0w6csaz7Rz16A5Mv2dcgSqnJ8/84R8sa++bA6Bvw0a6NbOb3nqQXXdiSqo62Blto/0d4ypa8jNn5/jPO4Uwd/RkgLrtfs39fjCCOj7DEd6PhcDaXyBxwjSIGFRe55FbNN5H2Gl+rrwETP7Dq4OaQyOObjCZxa8Xsur/nKW2HdDOE55O7PKvbvhO7pleVAgMKhSWSCFdy5kEZE1fyaFA/SMwn7WqBV4k3LMoqteYZUhdVkLjhakYXd0tJ8r+ZbQ47ypAlT77y7D3z1RpUV5GpxO89puSJ2845tPCEOIQHm49/RXcV02t/rp5KhAYbNo4O2g4ZhsvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by PAXPR04MB8814.eurprd04.prod.outlook.com (2603:10a6:102:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 13:26:54 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%3]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 13:26:54 +0000
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
Subject: [PATCH 1/4] net: introduce helper sendpages_ok()
Date: Thu, 30 May 2024 16:26:23 +0300
Message-ID: <20240530132629.4180932-2-ofir.gal@volumez.com>
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
X-MS-Office365-Filtering-Correlation-Id: 039a2b5b-8882-46bc-c721-08dc80ac2c5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|366007|52116005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?swQtvtdekMQTTcj11CrkYkEw3cSQTMR/IYXIZo4BcM5CyajsTJnbX/+BFhav?=
 =?us-ascii?Q?nK/h7lZ8oMYutQw1CQ6fr2zIAYSRLt3+jCd6LOBVSsLOhGdxgJkRmLYByZFf?=
 =?us-ascii?Q?6GJNVMqtDcwvBiaW01UWGQctJdcFIi3fFx/O5ZVCfx7aGjKcXq1VXZb6CYb6?=
 =?us-ascii?Q?l4kzvRxWAjmGyi4PCdoVpQYzAjNksaBFknTG/OYhUE58OOZWqLVSF7d2Sj/6?=
 =?us-ascii?Q?WC5DatQ9X9kDRDLEXsLnnThNooIWnABAahnumcvSQX1PdW5LMwAEtybNmOeb?=
 =?us-ascii?Q?J2mhRtF2WhqtNP86BnFPMLhLhhKFlP37unYSC/2wuWGh24lWBzcfZcipzV4l?=
 =?us-ascii?Q?/CfO44+Cx/y/3lRjWOLx8L71mD1HXDZvmuqpDR3fqrq48XzinFiD3yJvdCRk?=
 =?us-ascii?Q?izgMDVRFeZmv5kWZgiA01QFbyxLoT35vALLErkprEgBut4XEaagCKXf3aK3i?=
 =?us-ascii?Q?ksAt26li3piWXNKgbxKXm3Q1JK0PypjBzVN/fk6fgthKtr/pKFgqjYOTamFu?=
 =?us-ascii?Q?ZBxmON2Q25xglhzxG9GLNQPQu7CC7vSAgV9PNt2Q9tQP0ZLi+odviQ0CpChy?=
 =?us-ascii?Q?TyQDLY+CnnmeamQKgwc0CRBjop0OGi68yzmYUTLaEgW+8A9eZxSEYHBvWjsf?=
 =?us-ascii?Q?goCXblNYf8gz8gFDjWqdqX0EhgdWLXtdx82icKCVbSA87TrAEPipD2WqD/4L?=
 =?us-ascii?Q?pYWqOxVo2k0sAXHgJYwg5S02Fp/WIYIyy3NiF49udcwGQxOcWlzL4zxzNxsZ?=
 =?us-ascii?Q?PlNfWoz5NZmdcJH2zQPs46SBrp5JLKtD1ysmmYybtzynQRNRp6Ru36NmwnXZ?=
 =?us-ascii?Q?Fuf2liO90I1lrxE9zLJnLKkcCoe67/VURihauydDvlCwA+gtj/K9MF4SgiH0?=
 =?us-ascii?Q?cHl+fUGsNVEICSe0vNMIqupqNy5Rjw0Ayb1Jh8kirs/mTHMWAo2QtZPKyXyA?=
 =?us-ascii?Q?+y1CPJRH/eT55BJuaJ0Y0GpDzp3VUO7e9oMkEp5In8sAA13MUq/Gr8gJNCAc?=
 =?us-ascii?Q?al7cL9CGZ38g128mnMNqe61upm8x1mEXz9JBUCDeX8/7gGiM7hU6moFImZAg?=
 =?us-ascii?Q?E27f8coM0YmTqG2MRgjHlgLJ8zInIxBc9D3PrzLX/+uyou/2G18ZRLCiQkEb?=
 =?us-ascii?Q?TKVKpY3td72Syj+Poh3AQBe6m1uKugJixr9tzjQIVGFnYjAa2Lr5SJKO2+m3?=
 =?us-ascii?Q?ZBDOIFwy0BRiBm8cdGeXxX0/Mx5Be77+dfBOM2rG0NGiFCwGS87Dz4iBteqF?=
 =?us-ascii?Q?RTAdCm45IUmAEIORsJyXiCqv8emf5T224BbyQEOTsNZSr17MUs711o8kxKVq?=
 =?us-ascii?Q?S4bFiaRebC/fai/xVHKZJCsJtaLthHR+3iBz23cgGprrTw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(52116005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3nzIss3r3wKn97ZdVvNelLJBDBgwKfItRPlnNyKl/eTst43HvTOccOsq6tPK?=
 =?us-ascii?Q?9vE5mfgLe/UGQ9nBHepxYLO9u98N+srsHIcdr1/lvfIPt7S5yN4mrjqLhMLV?=
 =?us-ascii?Q?oRhWL8maozKsG+5LOjQJS5WnBCps+zbcPQ9gQxJlm/MK3diLiRwWExa7aZmw?=
 =?us-ascii?Q?K+rxmrce2+rBct60ueTz1JT/AZhVDbzgZqj4iq1jZweGVvBWanUB3ZhKLIUP?=
 =?us-ascii?Q?M1KVglBdI46OsWGS1eyvsWK3N0EB6epEj/2rnaEG/i22nV6jiEK3ztVoGTaW?=
 =?us-ascii?Q?/dPlMVpMcw0ilSho/ioZzPyY8nSocOHvzcPetV78tBqYy3acHeOM7f/LgOFT?=
 =?us-ascii?Q?LAxe4SZvGH+AeGaCOojXnXrnYU+rnKkD0eiatBbQQMJv7IDngGceuGMmdc6y?=
 =?us-ascii?Q?PdASyr9eC44WQaz4hJOMcGflyXhyxnKcFYBSRIjCkO1YDbbpnX3DuWLbZE8w?=
 =?us-ascii?Q?5Dgm497qc7gixLAmiGND0/rhgqZ/HIFH0X1feaGGzq7DmUPObLKOEVGeoYQ8?=
 =?us-ascii?Q?loxjrORc54CVseKrCe3mH3PcKBkIMvAQIF70F7W34iL4Zncb6RKh20akrB5Q?=
 =?us-ascii?Q?klNc21HmHTKZJnWHBmkEBG4xFJms3vovJGvTRrEqsUfr1awcLTzrH1OzEBy4?=
 =?us-ascii?Q?pUiUhja+fbpgcIwRpH+F+7s8GheGGATgug2jWtf3iNqBUuAvzyHwYALHUY2Y?=
 =?us-ascii?Q?MsanieQyJXXY8Nd1x3gvSCOtnnlJwMjqXhYNjVfUX83PHI7gERZQyjqfl2P7?=
 =?us-ascii?Q?SnOqAZlXEIe86yxymBqo/g27mOaNHVYoPLNBTaqZkQ5vEUxpeq5f5OGKfkpl?=
 =?us-ascii?Q?u6oYwNhUuTh/7Qq6mIO9B+H86BAtE3EGZ5OfvvnxtHjYGgA7h4BFfmkgcdrd?=
 =?us-ascii?Q?pzvECngQOgN1b5G4NZ3sHk3X7YPhlnTv5Y2D3GEFkbO50T/9gIjBDrL9yqg1?=
 =?us-ascii?Q?uck1W6i0PrP2t4B1QF/D8nFrq5NMUuOE6GSQqa3lHdB1Io1GT3HdCipDro+O?=
 =?us-ascii?Q?JLeOllx6KM9+v9X8DLMkGMkJKqzl55CZTW6v4kpq9bcgudnS9tO4VO7P55QZ?=
 =?us-ascii?Q?gWsKI9Q4pe/a6TTl2uxTzl4mO2h6XDj/FJaji9zmAajspVTfHarcZB9KAnr0?=
 =?us-ascii?Q?k+pVyFEy4JIpvh53BeCqqoI6kogne7M9xDmRAKPOOO0ogM+RXChMCxULV7Xi?=
 =?us-ascii?Q?O6mo0x9/+XuJCpNSqlVODWMSsgZOA+IlHVWmKHPxIyrPRTqmjm6Iv1a54SWO?=
 =?us-ascii?Q?0DziN0Nev8oRg0zyv/I3XAVj1fltQNzSScdC8IJEUJP6Qv8X8twNW3TTqE/5?=
 =?us-ascii?Q?S8OIJEo5zBrP1W4l/2v3afu8IslT6gkl89NtKLfdtoybcsxyBfz6Y5v4E4CZ?=
 =?us-ascii?Q?UPdnYvI42BDJ1eEQqxjJz0tV15J+cCBlfmY/k4xF6zd2Ls8bh7aolAFRzMv8?=
 =?us-ascii?Q?Lh2BD/4rCtdNzcl11LmYvd9cNBc8zbdfwS18/JozmXvTBMyxVL9rN+CN9uC4?=
 =?us-ascii?Q?eY9rJB+o2ANwSxNMhxtdSKpbgwUxe0OTeFrHE6hKYIgGGYEqNuPJg5TKqKHL?=
 =?us-ascii?Q?FRvfym1ldTM2ij0kXeNKy6/eEjHNKrJeanSqqIKd?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039a2b5b-8882-46bc-c721-08dc80ac2c5a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 13:26:54.7451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zj7MRMDngnb7I8EHaG981r9nUzpAcqZbVeDH1gqsfZZ5Mg+S8b+yb2gYAPpTWeWdCJTDKFVZGgyMJ+cD13MeGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8814

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


