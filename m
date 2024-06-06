Return-Path: <ceph-devel+bounces-1276-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8F728FF206
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 18:16:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D8961F265D6
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 16:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6BFB19AD6C;
	Thu,  6 Jun 2024 16:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="WqgMIIJI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2115.outbound.protection.outlook.com [40.107.22.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E3519922C;
	Thu,  6 Jun 2024 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690367; cv=fail; b=Y2xRSCo3HHT+79Urs3bcdkns6ub8Ks1Kryew3yxf4zJSerA2AkiJYTKF2wnxI2YNpOMIJab39ccXlTVqtkhVxScprQiTTI8z2j7MhPic4youQgFFf3MNuuA3LhYOM/Roe99G9MGCzHxoJ+SdAZjOWDuX6nNMf4ZWzgfeRbyFoPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690367; c=relaxed/simple;
	bh=FAVkWpZD9mVkfSM3Go9hINDMlbcRhVrmFZ4QA04jCVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DEiEyf8xeMebrHyd65QSoi+Vr1chqByzCoYWV3xEY+NQOjx7wkiAwarsh3b9bQs+gFbhBL9AUUPrnqxhlQ/FztTRZeYeHM4AFiJjkP8EG2u327DHrdsod1XV0bHP9MeFjDmx8DQTpl3QqDsc2If+IDQuRoInQasxQaiCJWO9qDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=WqgMIIJI; arc=fail smtp.client-ip=40.107.22.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vv7JUPOM6SD+gmUlSwSUKkuNCZZEuTZSV/Buo4jg6yJkyCBQvvkWxgq2r/UulgHRakcgTP0OGiVI/Uuyd2KmgZFYjJoX+c+5z73dk53HdlpwPsVd2PO7knxJt1opNhI7XrA72I5Pyc9wac2Sxs7JwhDc/QFmUWa2rHtcrO1WdGWPcQ5cSaLLrErL8W1PJ8XaKS6BlZA793HLDLRW7zBgLZt42pYKUnNG0zRQ22VgDgrpUCOjdTZMp9gdMm4M2HX/4Q9NnWRe7eQqz6dFrKGvH4SvbzdTxDmBk6eu4P2THgUHEgZJuORRgnrQfV0TmMegrz6Dm3TxhS3gCWgUJss2wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9SX86DQTOJ8HdXRRoou33jJOY8pcihenVKw3GEnto/A=;
 b=aFAmoVWOE1GNukWslDPz2lVPMHyHCyTsdz8mbzsINcEbJr9pCrHEEhoXYrLCYfG86Ol5dYJ6BkYyTpQOHt7JllUQ/z8JeD2fZP4kWlhpYmhdf4TJZZC4eU/9Aav1cSoUXkVz8ULiMz8yzTnEbAxHWt6yvfYbKA2EjYvXnxJ/JIaqO8nJzka6vcCYhoc5qh1LYcABLJ0QC4LTIhdH+xx55hq4Bg3bQQh6YzIz1vRGZVeowvHok+8dhyvMA64/R1Zucze3HMBVLsVr9uRA0Ar93pGH8D+WZeYwXLxL62pMx4POC6Q2whr/vkSQcfttBoW4XhkscRp7vfg5MgNkutZQow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SX86DQTOJ8HdXRRoou33jJOY8pcihenVKw3GEnto/A=;
 b=WqgMIIJINOm1D6nlQLqxjpL6rOxBOQdGkvTT5kVvYT6o03VCzbqsaXrIV8jExlAV+j38/tZvRpw491a8pjNqCpfofosfeCJPO1bzb/NtE4WvVnjdiw+fWzo0jDneBaciVIl1IV/IGEMoznrzE2EzQkJ3LA+D0lkLFSsRh0ZFxpiJYyBMqKM6KG2cmoiKP4zq/E9JeFut+odqtnMR2j53QCKnXh9P3+i//XRWnEwrtt/QBrByCdKFrNEKgCoijAj/PBP71g33YJgfbpk+kjVPC//LsWhT6Fs4jW8iAI/ZvDqolYiWetI/bH9K9J8E9qrutDewhy6UgJVoN/z9Adqc3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Thu, 6 Jun
 2024 16:12:43 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 16:12:43 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	edumazet@google.com,
	pabeni@redhat.com,
	idryomov@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v3 4/4] libceph: use sendpages_ok() instead of sendpage_ok()
Date: Thu,  6 Jun 2024 19:12:16 +0300
Message-ID: <20240606161219.2745817-5-ofir.gal@volumez.com>
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
X-MS-Office365-Filtering-Correlation-Id: 57a6d197-043b-4c4e-10d3-08dc86437f4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|1800799015|52116005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lrQguqNAfATipSx4Z7s7og+E9xZz8cm4bQsowWDh3mMYSr8jP8/MkOIABRUG?=
 =?us-ascii?Q?DFE7nR9sv2YdgnJb2KEbKQpzJKaGCRC3f/7HG+PX+CzufmcLr1QS3YXkrLKU?=
 =?us-ascii?Q?rnZTk2LCRIAENs51+FNiN7NlIvZ9b0/rxJtrVFfsKeov/JLceJaPwmx8lzar?=
 =?us-ascii?Q?wJNOt4D0cmoAgotday3LGmrxLq+PBMvUuw8RFwLxexYJdDH6MlijEeSXN47O?=
 =?us-ascii?Q?nPO732/M1mwXrffo/ZiAbrzs45SfM1V4YGJTVySI2TMxd92VBxV6VWzqPJgN?=
 =?us-ascii?Q?kvmvSj8XLuR/AySUWxQotKse/ActXMQPSOWHLCQIDk2WhRaUrSHeEGY9+J2i?=
 =?us-ascii?Q?lfpK51hykPNgO9DADq1tvLLgxQuEe+1qjWmTaSnwhE+djf5VGQ/Tdd9M9sa2?=
 =?us-ascii?Q?nFl6iBs6KkwHjsEHguQcbn4VnEsFDGaAHC6v5HhMUZnSb2G2d2L0X07sUhtt?=
 =?us-ascii?Q?7EPWhoabXUELmLSZtP/MLfCDN+R+Zqb4vf5c31AlBgUIzIeUn4FsXQTMi6gR?=
 =?us-ascii?Q?r1UQFwFmNRMc5DCG3TwIRONn8NkBMz9MQCl/fXKDYE9b06ZMmhIMVQsSFY63?=
 =?us-ascii?Q?Y8fus7bl/9LsTk1JcOtOkIaagv3qOM7/SePjjGxPE4GS6HxTFdqtFKdk0vOn?=
 =?us-ascii?Q?18GL+ik2+57p8cihdxCjj2gbun0pW4o2/2WvcqzBrAJgkaXOFMFop19D5X/G?=
 =?us-ascii?Q?anT8b97guIaQ9LkXudTBwfZiAEvtc5kmi9zF2PhZLf5KgbeCa4KMqPeFFaGg?=
 =?us-ascii?Q?TFzURS8SUGarrI9o1O+EQoBq9x88A3ibBWFxDxLikCkLk3a9UgddVmbz4bTo?=
 =?us-ascii?Q?iDdLE/5fXdeXU2xMmL97RUinkxmikBdh5TDUYyQfWJOrCucZ317J//t0Wa0D?=
 =?us-ascii?Q?G90AQ5Tnf8AOuX1DbG6vhZnMQjxA+bsB58kdI61Vqy4//yjUKnOpr7QIHtJ7?=
 =?us-ascii?Q?051ZFz3dMFGK+fYkWotNkDFmSyvXVDmq443a3Hl5l4UzLjZpV7Mzr/rgo8QS?=
 =?us-ascii?Q?BDlMmdvFi6FOgwHk7/VDeABFwGEcxVtP5+RmzdWLczjHsJIDlPOy2y/x8R/i?=
 =?us-ascii?Q?4n8NtRcLJlwFSL+TT9KAOvKI/B6QaoDNe+T513NKGLNZlw6Z44PYUiU00lit?=
 =?us-ascii?Q?RsY7/y9BZCgelHO2fMuoLKyZusUS5oMo5/UZyPEiAMhbM5XTQ3MbgjsBTnif?=
 =?us-ascii?Q?ordldwPai8NB6vsbruornarWIzHuGJbFNQGISfQCuZLyZ+6q4RF7eIwg365O?=
 =?us-ascii?Q?WFsTH8w6/ij6ZDRmAQDppnnqlKvmjRfVf7Y/g33UhJddKZvwkJB02u6Ob0kR?=
 =?us-ascii?Q?J3O+wnTnC3/edEQ1NOTHWoRvfINJ/HZds6I2vdw98YW/dy8NJlqUfZlWbiKq?=
 =?us-ascii?Q?RJBUhik=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(52116005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DZoDFsewqmJtu0WCGvqYfT/1OFHqc9SIHe7ssPPWMCgF1vDpSfW9OiIxJKGZ?=
 =?us-ascii?Q?Jz8ngZ21PtgR+WqHaNEaP1H5WCm4jElzkBeNLSZfDKgmhGjijod21RHdg+M5?=
 =?us-ascii?Q?ahYTycBUR1gIloI/nHniclM70uKSk/MCkmrD2VKI2mka9teG54jxxSib/i+c?=
 =?us-ascii?Q?u71uB4aBBZULCbUu40WGGqjVaAyXj5JhGgyjEhRQOGTB1R/TMUrTYLJz+aMP?=
 =?us-ascii?Q?MxSWs4z/03l69q9ZvM7ziPrYBP4Pa3agPYkWWNCM5V31VQ62hGj9uXCArewp?=
 =?us-ascii?Q?XPIUc8cQ1Vnm/9vITpNZdmEeiArJq5uk0rEBYXhIRORSEDVE8TNs10PhPJ37?=
 =?us-ascii?Q?elxCGmtIvTIt4pFYDCcRQxffYYmKwUDRbDrl5YUE8ZflbvoYhcI9nJj1HprN?=
 =?us-ascii?Q?ktSJBWmDg//VKJF1GMsyGDv3O82ze2l0XkIEnpZ4+mo4Wn1N0FRK3tTv36Ua?=
 =?us-ascii?Q?oaAWPHUfGF1ABOzxEKXDlCHs4xIIY8oSB+5kKU9D7gPhM8joHFnnQq5/c2FW?=
 =?us-ascii?Q?E8h9GCGZxjFG6OnBdhwxxcRRavrv/rh/7AhPhGDdL7KfPsTulNTyOKoyiI9l?=
 =?us-ascii?Q?XT5BFSr6GzSazgWwJCGcoi68OlwxRqQs0bChJ1lZIOzkdblFQ20kVqIQqEcX?=
 =?us-ascii?Q?h2vHVlqAg7NGh5YH2YPSi7hr4JEQVXosEaqQypOStxUQMV0i3eXFcqTtBqDD?=
 =?us-ascii?Q?J+B03vpGpbZf/suAkh/TLdaW2sY66Trx9v4R/CmcnZKS4nMQ2Gbr+9xEwO+w?=
 =?us-ascii?Q?3MZdVLCw5T26wckAodlAsvpsqzf95C4P9mSdcItozQ+Lo1yeSn48JgFgoriU?=
 =?us-ascii?Q?KOh6vcmnA+4VRSaeTjauxxD0V4NOi26vsE1/fkDTt6KolxAHoI/tkcKHzGo4?=
 =?us-ascii?Q?CmHqQ3U6Gvhapz0/YJDQ/AUWa9lCjOv03jX7IELq2BWjy92orinJHZZ3sHv2?=
 =?us-ascii?Q?l/roZcdISRZtfNVlZ/+hWZi6E561uKsy70G+Q6Gkr9139gyvStm0n6HN7ceS?=
 =?us-ascii?Q?czYRHJB6j0NmuYXbu2urDC6BvQVNNn2FiRRS0P/OYaWxY9fjauONDDw2vZY8?=
 =?us-ascii?Q?QRoLZMtk4vrszaZKZ3AETz2butPyQdA5e01Buo0C5RWDCwSxbca952Dx4fwh?=
 =?us-ascii?Q?RzqbhGXCs3GKejtOXhWc1RX592iZ4Shby27WI4zndvqPT0o3fWANFlfBjLg0?=
 =?us-ascii?Q?r6xn7y7GklfuoeWopU25UozhIdwYxQaPS/0kKdFe/nhb7m70nON4CTfCz6Ku?=
 =?us-ascii?Q?S00Ktrqqg+KpQXlPR4KOWhgqM80pvi5U4Kgmrf8UdWWqPbjGQI1WRlyxwCle?=
 =?us-ascii?Q?PxjDr2pEfwVPL+oYhBvy9GgrIPZ5jY4KTaDqcUUFZIzlVOQYczGtILbvt1HI?=
 =?us-ascii?Q?1jpWqdI7B3eNEMamy9LFIgoWk0CLaQaAR2+/uy/Aqjx4Ac1xv+2nCwL7XnHJ?=
 =?us-ascii?Q?qLb7u2KjeHy6zhB5lbShJ+N9d1k+EbiNGipU4O5cr2Udz1obGVhmQ5pl6Cle?=
 =?us-ascii?Q?YZTq/jvwzyfPBUU5ggw4v/fMwbb7IxL/i0eU6Kf/M5VRvUfz47mR4lncLKms?=
 =?us-ascii?Q?3sMbKe4s8hMPne9TZZEbJz372CEFnF+x4TEldhDa?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a6d197-043b-4c4e-10d3-08dc86437f4a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 16:12:43.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FY9A2J7fXTh3mg0WmRNYe/qYSnXij8LXnJF7o3ibbCFTKZ5TQ6LDtzVDXgovfd17TGMOyVc9SiXiEWP0ZvpRfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815

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


