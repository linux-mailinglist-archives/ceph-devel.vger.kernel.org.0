Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D65650F00D
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Apr 2022 06:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244201AbiDZFCS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Apr 2022 01:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiDZFCP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Apr 2022 01:02:15 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2111.outbound.protection.outlook.com [40.107.255.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7C1B6D2B
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 21:59:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9MPpQK18qEEm2tB1VaX0we6YA8Z9bDDIYfFHt34HyA6eJUZJmphXkrvsEC60LJVGk237QtdiB8oJQUC4YV5ZCJrTdfFQ3tGufuanU9qxzfCusV5JixgA53/zIWykY7ZNtdhTej6aRJZUusuS+CBoiSXCCMEl4czhdWMFV8dpinOjnJuYkxKjz3K0HAWDLcbhmDl0G7FauUtf04KOznZWwRKtu8nmKMiwD78icmggHibCV9YrWdNYC/18+/jHHzPGeLnHnAb7SmCQERKwpv4q+0fkWgZOAo1QHZ/yBR48XpXTWVVBVk5O45js1rR4AucGgN1S0tVHdX+W6HAk8Xj3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZRzmdXrNmHp5DW+X0B/vkSEOlZB/E9NvobagFkeMTc=;
 b=DPDRjcHhsQitDgsE08xYbfamC9wKktP42ep95lT4ksmt986F8kBnR07S7dzwDlNB7gRjUtmPQHXuVHwMqDP2WQZo90H+BI3hlMxsOPXDl1pQBXcr/pdwXaSaroRjlXR98cdJcmeB7/ruvdsBF4T+IUBUy+6AQBczKyLjx4piOqt+cPORuzdZlEanUiE6ls7HKTRlJ7ii8fNC5/NLVeraP6sGPXWzTtrhxoP4x3Y/fPLmLTaEQcKZ07f22akf0tn/rbHIT4Zrpt5/YqXIwQkfuGyc3VRxyZJqUQ2uMgJwLCiO8QCx0y8JXqCegupTh18RMKtohWXevY3x7cAW0xBKGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cybozu.co.jp; dmarc=pass action=none header.from=cybozu.co.jp;
 dkim=pass header.d=cybozu.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cybozu.co.jp;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZRzmdXrNmHp5DW+X0B/vkSEOlZB/E9NvobagFkeMTc=;
 b=6k24XhPKsSD283+J8wR9Dz1nLyZ2j2mFiToEJTCWAFYTgPl1UsOl0vo1CpWU02HEtdQDmdJwdhowWIJPVbUe12x0L2SoWQLcnd5mXGUxeNuKGpOD90iE98RYoDIeu6ibkFpj5DBr2w+YJYXBvWg+h9SWRBvHVwN/NZHVn9xej3A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cybozu.co.jp;
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com (2603:1096:404:b1::17)
 by SG2PR03MB2862.apcprd03.prod.outlook.com (2603:1096:3:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Tue, 26 Apr
 2022 04:59:04 +0000
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::fd4f:8de8:6cac:f62c]) by TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::fd4f:8de8:6cac:f62c%7]) with mapi id 15.20.5206.012; Tue, 26 Apr 2022
 04:59:04 +0000
Message-ID: <e0e8f5e9-d2fe-bbd6-e115-abe3ea1066e1@cybozu.co.jp>
Date:   Tue, 26 Apr 2022 13:59:02 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     Ceph Development <ceph-devel@vger.kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
From:   Daichi Mukai <daichi-mukai@cybozu.co.jp>
Subject: [PATCH v3] libceph: print fsid and client gid with osd id
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY1PR01CA0162.jpnprd01.prod.outlook.com (2603:1096:402::14)
 To TY2PR03MB4254.apcprd03.prod.outlook.com (2603:1096:404:b1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c67b8c82-105e-4307-ee12-08da27417ca5
X-MS-TrafficTypeDiagnostic: SG2PR03MB2862:EE_
X-Microsoft-Antispam-PRVS: <SG2PR03MB28621E565F410BC9EF5C77CFACFB9@SG2PR03MB2862.apcprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uni19Cyd82x8c5GKav/zYnbzbJpCwS4npc1/L1XC6gNEZ8kDHGzFSvXSpVfX05rj0xpNsyx6/08uj5caH0htKuUMTxQ53ahpPmpo1CsRv4qh5hNa4VhNQMnLTGuW1u1NtcbrX3MR8ocAvyDPccEQT/d7O3GMlRlctlAX6/kg5GuMJlZhc+CzlCoadhxHMPzply+HMYrI7uqmYVr4620l8JQxDlmTmlUgcTP2lZHnu2wmWiB/9vyR8PXQ1K/zy4Sf+wo8+PPqbgiJOOpplUCE1SVc6Qd1TQauqN4+WuZQBPteb/+xQZsauUcPAqCwsXzFmh1w7OTmrfdJfd0FYpTF9/Avia172P4xQDUX5EZymJDNClDws0rvpaziEP1OGSRoN20hX0K1i4cANVabM/+Pco1gYdoVl5EX5LOG4rofIybuZh8yymYoAxi/l5dkEeD2zuB6ClNWtvQWzaIn+y5VT8X6f8UJd9MCXkwL2L+t1eFtmDrYeK9O2/anpeF20SWmUt5rWKKLUw6PIqWqB71GHcTaVdJNBJ+MBKidyghBegcRbupbrdmrwzRY1iS16OpeAUoC1sIJVgmrg07ECK3oLAuYZ4+WUBhV5Rq8yt5zuu3OrM3LC5wbER4MH+EG6S9SOYjT/zQiBNLXGiuu4Kz2/g6MOEayAS9q1nkPd24z3RylwV+hUOpFuVj3X/IDGn75DaFuyF4SvNgFBG983SrGB7OF/+mfBhsikviA7nyyXNnzgtbPQl5gnlrw+uYmY4jjjtcvysgIaMbP1zThZPeIjfv6wbdoz0DbkDKiI5iv4aYdcQ4jy8mSKNd/1lEjWsM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR03MB4254.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38350700002)(38100700002)(31696002)(6512007)(8936002)(6486002)(316002)(6916009)(508600001)(2906002)(5660300002)(26005)(186003)(54906003)(4326008)(2616005)(83380400001)(66556008)(66476007)(6506007)(31686004)(52116002)(66946007)(36756003)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGs1THpsUmtKZWVwQUlYdGFQZDNIZEIwcW5oR0YyUEFHdllyT2VyNEJFZC9p?=
 =?utf-8?B?L2lJMDJPWC9pU05EZXBtRVNobVBlVDhMY0M4WjFOMm54cTREM1pZZ3VxZ2Fk?=
 =?utf-8?B?S3JlQXRoekloY1hISjY0ekc1c3JGYnM1bWl0eE1UeDF4aC92N1BmRk02NmE4?=
 =?utf-8?B?V3VaU1Vxd1VjdzNXNEdYajNCeHpDNTBFMnRxeXhGVHV2ZXBKZnNMUGN2TzlE?=
 =?utf-8?B?c1RFeUdIeUdtME43MnM4L2twZHpOTHluMStMYzdjMlFORUZLN1pZOFJ4dWlz?=
 =?utf-8?B?bWZsazRObk9yWW96THFaQlJIcHlWTGFrY2JHbEJFUDVpUUZ0QktxMjBuZm1x?=
 =?utf-8?B?RFBaSzhMRmttY1hRaFY1M1RMa3FnTXMzTUZyVDg5OVMyQ1lBVkw5Z3NUWmp6?=
 =?utf-8?B?ZTNpRTFKNGtIYlQxSFBId1p3N3NrNFlhVjRsaVR5OTgyNWdKWkRJd2xxN2Fz?=
 =?utf-8?B?ckYrVGNENy9VaHVJSkNzc2hUOWpqcitXSEZXemNYZzVuU09LQjhJemJxTm41?=
 =?utf-8?B?MHJhSFUvdWdTeUFKN3BMVU1QSWNUbDJlbVA1by9wWWNTYnhHYkRBU0htbzlJ?=
 =?utf-8?B?RWt1OERrR1orb2hJbUtVazhKVS9aZis2eFNVVEhBVnpyS1hOd1BxQVFvQTVX?=
 =?utf-8?B?WjJrWjZ4VU9rL28xZGJXaE1VL21ZYXZncjN1WWVObFRnUm00NkJDQ0hCVFhj?=
 =?utf-8?B?bnJiQlJyMFJUelpSdU93SFluZkpOb3NCYkhva0VrSXpQY1Fra3FERXozTHRP?=
 =?utf-8?B?QW5YQTE0UGgycnhaaEVueXlwdWNKU1BDZUVmaWUvNHBSWEVnOE8xNkp0bG9l?=
 =?utf-8?B?VkZUQ3M1YmY1VHMrR1Rkend3RStxTjQwTVpMaS9oN0dKdzFpcUpyVnc0b2dm?=
 =?utf-8?B?YkVuVGpWaWw3MmExb0ZBWU1pbU9COVRMb2ZtRTloMUlRS09keW1wVVpzTlJZ?=
 =?utf-8?B?STJBR2Fwc0UzS2p0N2ovRlo4cEE4bVJWZkhUWXJZOFB1QzFCVnZ4djVkL08x?=
 =?utf-8?B?eUN4b1RBSXhCeUw5eExNdC9oT04vdGJVVHhpUSs1by9kanJUa1FueDNmQzlG?=
 =?utf-8?B?NHE1eU1nSnQxelVWN2h4c3E4ZGlyTnhtYmtrdnZMNGp2YXlkMEI0cmlMOElL?=
 =?utf-8?B?d2lEU2ZHVmE3OVVrcDNlR1lZWlpSRDRtL2xoTlJhbXJnSklKVUpkdk1zd09h?=
 =?utf-8?B?cHNXS0JhVHNrRC9mQzJLam1LR1JVNVJEMDc2Q1M2LzYwMC85UFdRVEUvU2tD?=
 =?utf-8?B?a1lIb0piRHZKUkJ4czdjdW0zcVMwamNaU3JtZitSWGxnYmJCdnNIV2kwYjUy?=
 =?utf-8?B?a0J3OHFSNS9GRWM3a01wVzN3RHAzTHh4cW9DSUxZTXAzSUROUkdjZUlDYU5x?=
 =?utf-8?B?VzZQQ1BwVStEVkNyRWFpMlk4R3BlMFROWTRLRndhWVRQUHJNODlOWlRhWDdz?=
 =?utf-8?B?cXcyYXNZV2Y0ZmJpUTdqMVZmbDdhTUYrcU10c2xVQTltMXNHelJIVWNKZ21k?=
 =?utf-8?B?RmNiWHlSZVJoV2cvWHRjS1ZBNHFtTUFSTEp6cmRqK0NkbFFOc1l4QWcxc1M1?=
 =?utf-8?B?QklkR054dGNsSEY3UUJ2YzBBL1hCakU3eHNWUDhPZUlVRVhKZ1JUclJEb1Mv?=
 =?utf-8?B?UFJoUG9IT2JWcTVQNVJwV1RoeXZVcUFteXF6UVBZRGlvZTNWdjhSdEhTSG8v?=
 =?utf-8?B?QzZtVEs3TzBDMmd2ZmxDUUliMjNZbC9tQmpUQzBHZGFzWXNDeFB0OTV4UjJI?=
 =?utf-8?B?eGV5NHlKdDNOTUZndlpzeVQ0NG5pcmI5TFlVT0V1YnhTTXZpMDRualhJQm83?=
 =?utf-8?B?U3VmVDR3N3Rad01PWGlISWZFSjZ3Rk9kZW9HTzNiUlhycnNsRHBYaXV3YlY4?=
 =?utf-8?B?eVVJRmpVTmxuRCs1K1pienltMXpwdCtvNEM4ZG1HYkJqS0twU0VPUlpwT2Nx?=
 =?utf-8?B?Q1ZpOGx1NWhCeGd0UnU1YXpITEg5Q0VjdXQwbktDdlhyNnJVbkpjbmZXYklp?=
 =?utf-8?B?WWpqVXNrQWduMC9zR29pY0pHbkN4Znlibk16bjZqZHZxK1pld3dKRHdKaUNI?=
 =?utf-8?B?UTZ5WTRRU1FyOGxFa1pNUXZlN0FsK1VndmJrUkFwWllXS0VNSDhLc1RWSkhY?=
 =?utf-8?B?alVkYlNVYlJnRTZxQVVhNVRMbXh6MDRiWm1EVVk0cWdIVWgrdnQ3QVFXU3pm?=
 =?utf-8?B?cG5TaFQxOFJFU0p2SFRRS3dBMnIyQnd3WGFhMjNDSlBVN2dCOTNsVk5zcjNK?=
 =?utf-8?B?UFd3WVlHb1hENVN1WVByUThhM1cyVmMzNGdXVThLdVdaQVpZOFV2OVRFcW9V?=
 =?utf-8?B?VzdWT25jeHVuYTEvQzE0OGtnazljUUw0VFAwc2w2RkdMVGFaRkVvWEd6UG10?=
 =?utf-8?Q?0dVdIXFi2DbibcSlzs/S9060GGqQQhb0qHi1Y?=
X-OriginatorOrg: cybozu.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: c67b8c82-105e-4307-ee12-08da27417ca5
X-MS-Exchange-CrossTenant-AuthSource: TY2PR03MB4254.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 04:59:04.5046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3761f390-05f7-4386-9a0b-b6806c13b841
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YvrhDSDThJ2KueIKjrxsWerlYdlnqoqgT9kacax23/hJ+5mB5qdmZ7h2UK78QOYV1jV5mgH6j0UnU8Z2VtLGzKzc2EJCk5ZSZuvjKXgMvVRc26lV7tPhHSnhCOg+K/hq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB2862
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Print fsid and client gid in libceph log messages to distinct from which
each message come.

Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Daichi Mukai <daichi-mukai@cybozu.co.jp>
---
  include/linux/ceph/osdmap.h |  2 +-
  net/ceph/osd_client.c       |  3 ++-
  net/ceph/osdmap.c           | 43 ++++++++++++++++++++++++++-----------
  3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
index 5553019c3f07..a9216c64350c 100644
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -253,7 +253,7 @@ static inline int ceph_decode_pgid(void **p, void *end, struct ceph_pg *pgid)
  struct ceph_osdmap *ceph_osdmap_alloc(void);
  struct ceph_osdmap *ceph_osdmap_decode(void **p, void *end, bool msgr2);
  struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
-					     struct ceph_osdmap *map);
+					     struct ceph_osdmap *map, u64 gid);
  extern void ceph_osdmap_destroy(struct ceph_osdmap *map);
  
  struct ceph_osds {
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 1c5815530e0d..e7c01fcc1d16 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3920,7 +3920,8 @@ static int handle_one_map(struct ceph_osd_client *osdc,
  	if (incremental)
  		newmap = osdmap_apply_incremental(&p, end,
  						  ceph_msgr2(osdc->client),
-						  osdc->osdmap);
+						  osdc->osdmap,
+						  ceph_client_gid(osdc->client));
  	else
  		newmap = ceph_osdmap_decode(&p, end, ceph_msgr2(osdc->client));
  	if (IS_ERR(newmap))
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 2823bb3cff55..cd65677baff3 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1549,8 +1549,23 @@ static int decode_primary_affinity(void **p, void *end,
  	return -EINVAL;
  }
  
+static __printf(3, 4)
+void print_osd_info(struct ceph_fsid *fsid, u64 gid, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_INFO "%s (%pU %lld): %pV", KBUILD_MODNAME, fsid, gid, &vaf);
+
+	va_end(args);
+}
+
  static int decode_new_primary_affinity(void **p, void *end,
-				       struct ceph_osdmap *map)
+				       struct ceph_osdmap *map, u64 gid)
  {
  	u32 n;
  
@@ -1566,7 +1581,8 @@ static int decode_new_primary_affinity(void **p, void *end,
  		if (ret)
  			return ret;
  
-		pr_info("osd%d primary-affinity 0x%x\n", osd, aff);
+		print_osd_info(&map->fsid, gid, "osd%d primary-affinity 0x%x\n",
+			       osd, aff);
  	}
  
  	return 0;
@@ -1825,7 +1841,8 @@ struct ceph_osdmap *ceph_osdmap_decode(void **p, void *end, bool msgr2)
   *     new_state: { osd=6, xorstate=EXISTS } # clear osd_state
   */
  static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
-				      bool msgr2, struct ceph_osdmap *map)
+				      bool msgr2, struct ceph_osdmap *map,
+				      u64 gid)
  {
  	void *new_up_client;
  	void *new_state;
@@ -1864,9 +1881,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
  		osd = ceph_decode_32(p);
  		w = ceph_decode_32(p);
  		BUG_ON(osd >= map->max_osd);
-		pr_info("osd%d weight 0x%x %s\n", osd, w,
-		     w == CEPH_OSD_IN ? "(in)" :
-		     (w == CEPH_OSD_OUT ? "(out)" : ""));
+		print_osd_info(&map->fsid, gid, "osd%d weight 0x%x %s\n",
+			       osd, w,
+			       w == CEPH_OSD_IN ? "(in)" :
+			       (w == CEPH_OSD_OUT ? "(out)" : ""));
  		map->osd_weight[osd] = w;
  
  		/*
@@ -1898,10 +1916,11 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
  		BUG_ON(osd >= map->max_osd);
  		if ((map->osd_state[osd] & CEPH_OSD_UP) &&
  		    (xorstate & CEPH_OSD_UP))
-			pr_info("osd%d down\n", osd);
+			print_osd_info(&map->fsid, gid, "osd%d down\n", osd);
  		if ((map->osd_state[osd] & CEPH_OSD_EXISTS) &&
  		    (xorstate & CEPH_OSD_EXISTS)) {
-			pr_info("osd%d does not exist\n", osd);
+			print_osd_info(&map->fsid, gid, "osd%d does not exist\n",
+				       osd);
  			ret = set_primary_affinity(map, osd,
  						   CEPH_OSD_DEFAULT_PRIMARY_AFFINITY);
  			if (ret)
@@ -1931,7 +1950,7 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
  
  		dout("%s osd%d addr %s\n", __func__, osd, ceph_pr_addr(&addr));
  
-		pr_info("osd%d up\n", osd);
+		print_osd_info(&map->fsid, gid, "osd%d up\n", osd);
  		map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
  		map->osd_addr[osd] = addr;
  	}
@@ -1947,7 +1966,7 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
   * decode and apply an incremental map update.
   */
  struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
-					     struct ceph_osdmap *map)
+					     struct ceph_osdmap *map, u64 gid)
  {
  	struct ceph_fsid fsid;
  	u32 epoch = 0;
@@ -2033,7 +2052,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
  	}
  
  	/* new_up_client, new_state, new_weight */
-	err = decode_new_up_state_weight(p, end, struct_v, msgr2, map);
+	err = decode_new_up_state_weight(p, end, struct_v, msgr2, map, gid);
  	if (err)
  		goto bad;
  
@@ -2051,7 +2070,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
  
  	/* new_primary_affinity */
  	if (struct_v >= 2) {
-		err = decode_new_primary_affinity(p, end, map);
+		err = decode_new_primary_affinity(p, end, map, gid);
  		if (err)
  			goto bad;
  	}
-- 
2.25.1
