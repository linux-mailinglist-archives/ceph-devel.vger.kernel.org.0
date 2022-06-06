Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3A553DFDE
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 04:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349231AbiFFC5f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 5 Jun 2022 22:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbiFFC5e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 5 Jun 2022 22:57:34 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2138.outbound.protection.outlook.com [40.107.215.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8FCE083
        for <ceph-devel@vger.kernel.org>; Sun,  5 Jun 2022 19:57:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeCEIuh/qqsnVIipxl3GSka2bJAMwJXS6OGr3dPHAJs0e038bzcwCTabT2BRWV0kIZZQfuQiMPbioIUKd/Waujry219HYboOXiDKXqSFeaMiHhQV4Lkg0vIbuRZK4YgwtbGl2Qi5NCP++RVE+U292nb6q4S0v9NjxxrIKGIqa4DaOzT78TfpcXVdsCzowY2+a6gFR+ev1wsN/5e6DA8yJyFZhhgaO95+Z3/dqK1TM0KC5KGgjUER3N+fQTQZb2b+pbfuANVhwMAWhH5cN7SvMsQnrWk/6OXWtER+0SgWYnA5u/zyqs4gYnFrGbN+UUGzVRXplZsOqjNuzMIs/ND6DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSCHyXaNWbLE2xuaCFFqGFJ32gJb1UYNC1CB2VZyEm0=;
 b=OKzNLvIWoNDNLb6UFeDYLyPZhWFlsKiabjjwBqVuOEruwsJZ+JL8ReqyHWJY69mGAY6Yl8xZAVslZVXi/+Znz1R3iQw3rsK+544q9BIbKaJ+nHSNrG+M3dqAUG/wW3LVMtWjj3QICpuopjj0wOwQSd6HY4N6ZOTY37mwhuVy8saICPL/1zUjZMZ1uidL77aCBZm2JV4YGFEw9RwTyjqCIQgVN6TetgH2Ug8kwe/Huon0eabuqmWZHDrOOPh9afw9285ItED97xU0dCs1E2b7ZJ5HJGa1akNdTrkRkmcIpmcriO4coZxvF7NGz9LXiFgxWF9o0qqw02D5cyRagLkeJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cybozu.co.jp; dmarc=pass action=none header.from=cybozu.co.jp;
 dkim=pass header.d=cybozu.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cybozu.co.jp;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSCHyXaNWbLE2xuaCFFqGFJ32gJb1UYNC1CB2VZyEm0=;
 b=klfW0abC6GO3Wct8CosSYTp+1h432CNLocMG0ErRQoahllpY2n1aM2PthZlRrFEAP+bNNn5IHniGzrWIDf2Oyr5tU8V1RKEFV/LpR46SnK1as0VJeSnvSPIbtl/23lzd+SJ5+4lR9Tt/BYYFxMLAL0L7hH1ZZGblD3AftZEQdU4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cybozu.co.jp;
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com (2603:1096:404:b1::17)
 by SG2PR03MB2909.apcprd03.prod.outlook.com (2603:1096:3:20::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.9; Mon, 6 Jun
 2022 02:57:27 +0000
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3199:64a3:1b02:5465]) by TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3199:64a3:1b02:5465%6]) with mapi id 15.20.5332.009; Mon, 6 Jun 2022
 02:57:26 +0000
Message-ID: <bfc20d2c-9198-2cb3-506a-4bae09c6cd68@cybozu.co.jp>
Date:   Mon, 6 Jun 2022 11:57:25 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
From:   Daichi Mukai <daichi-mukai@cybozu.co.jp>
Subject: [PATCH v4] libceph: print fsid and client gid with osd id
To:     Ceph Development <ceph-devel@vger.kernel.org>
Cc:     Satoru Takeuchi <satoru.takeuchi@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0089.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::29) To TY2PR03MB4254.apcprd03.prod.outlook.com
 (2603:1096:404:b1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f002798-0e85-4982-82a7-08da476849cd
X-MS-TrafficTypeDiagnostic: SG2PR03MB2909:EE_
X-Microsoft-Antispam-PRVS: <SG2PR03MB290996ACAAC1E2B65D87814EACA29@SG2PR03MB2909.apcprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YvxZ9EBzGLzHUpjSlN7k3Jxj25RTCHE7oy1iWUdJS61i52VLL+PXQYCIo9q1GmNrnSrGemHZShmtVKUVq5VbhlT/HmG1jCr2syrvsvhADPqaWnuZY58BF0gT1g7VlTMreloCgOOEaJN8Z0ykd5qTwG2tBUkCgmw8rMjc5cinzqXaFfRH4qL/wSmCuMyQEZ4v8ds1StXSlrac4FKUtdG6+a/5wkce9OMKxi7/ky+naPoG9VSacQ3X00ntGVjWeRSylaE7V85F2ZJ/0jmFUaEuwqBNs4PI/QtFJWVAknEbyNAzGSiCG0Yt9GCsDiV385ddmIImjENopwF/Au8Z1TBwCM9kh3CoBfhWSsfm/pnWtg7QhF6N0jV0uUjDxjbLFklyMDbZiTImaq1WOPb94PccDT3QDDVMQ0q+iuSvu4FKRzG8pK2b8nqSYpZ6V7G2OlZRZOKM5U0e2r8b+u1v3H05sC6xQvxkDA2nnxaYyUlb23enTR5tZ9gHmpAVCRsYCeTNMKBVbUQANbHlkbNW2UbJ0dZI8cRjJicz+PNraalWkHvHQ2ax1SrO1F1klhJEfdc+BjH768owDEoihExGkydvNkbnKviKWJ42NENgMUYbZAmhPW4vYOkHf/L1dvkFM+82eJDajQmwidSUOzXeTJjAxBd7+WXsnR0MShrLDzorn4ZeMqDTK3cg1BKbqq1wrztRz2MTScXgwy7vRdEN+7cq5bn+YiZvmgWALKJIshmP/6B8o99Ou36Nq/OAcWga1owJ1t3lPg8AD0U17PDk5YD+7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR03MB4254.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(4326008)(8676002)(52116002)(66476007)(2906002)(31696002)(86362001)(6916009)(66946007)(66556008)(8936002)(36756003)(6506007)(83380400001)(6512007)(26005)(31686004)(2616005)(38350700002)(5660300002)(186003)(38100700002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkpOQ2RQeE1MMEU3QW5jbkZxdjZFbHBZY0tlU0I5SXN3dXBZYWF0SDM4Rk4y?=
 =?utf-8?B?b2tFZjdkbXYwU2FxR2J6RE5YdGc3ZkhSTzNRV3p5aGcxSUJ5bTVvNmdIQzZC?=
 =?utf-8?B?MUNSOFpSeEhqNXNaSm1TOTJEeVZha0hMU2ZXWnZ3UFAwcy8wNHNmdE90QStn?=
 =?utf-8?B?MVIzcStUL1JWZVNmSUs5SlNCZG1hZUdPNzNpSk9iTGhtTWNGM0tMSG1FUUNa?=
 =?utf-8?B?ellIZEJwMDNmRXhtOFdIVzVJSlNPRWRjcmNMdWtCemVDOFpLdVpPWTYwc0h4?=
 =?utf-8?B?R0hLbGFuYXVpcE5VR05obEtodEtyb1NyZmtJcTdLdWNyMHV6ODlzKzdpSVlh?=
 =?utf-8?B?Rk1EVEZtdVdISVluYnR0a3J3bVpwMHNsM0JLTXIzaGk1YkNvbllhSUorZ0lP?=
 =?utf-8?B?ayt3TzdFR25FYUdLMzU3NzBQZ3hqOHNJYzFGRU5UcTJ3T2x5c0E2LzlqVExX?=
 =?utf-8?B?ZGc3eVhwVHl0RmROY1ZDUDBSK2k1K2VyMG1FcGF3eHNLanlKRDZGZEt6TlFE?=
 =?utf-8?B?aHJMc0cxY1JRTWZOa24rcCtRRnl1dHBEeHVVOWFKRXptaUNWOHVWSjVqOUVs?=
 =?utf-8?B?R21oYi85U1dsLzdIZVdXK3NWRzdyZjlsTVBvcm9Jalp1NDAyOThoQ3U5dTc2?=
 =?utf-8?B?U054cEY3cVJ1SVloL1pBY1NpNGRSRjdzMHl0elBZRldSdGJnOWF1OS94RFhr?=
 =?utf-8?B?SWhBZ0ZCeTE1UitxZ3YwTFY2WWhwamRVelBzWHU3Z1czcHpIWnpITUppUFd0?=
 =?utf-8?B?YXVOU2FMbGhJMkZsRWoyOHc1VldtbytXS3lFN1ViMS9EMzVnQzR2cjRIWUV3?=
 =?utf-8?B?clY0RmRuOVFBRUNIWGdKRjlkOWw0dVVmU1Z5N1F4RjVwWDhyd0pYZENncFh0?=
 =?utf-8?B?L0xKTGtLUy83Ymp0NzNWSVNjNC94RWlBUkpBUUZCeHpMaXVyQkRjeGNvMGN2?=
 =?utf-8?B?ckRxUmNDL1FhTnkrU0twOGM2MW1jL3U4SG9Pcktwb0ovQURPYm9sYk1wbmxy?=
 =?utf-8?B?TlZsSWp0eW9VTkZNRFZ6S1dSOXduYUpKRDQ0MGdzbWJWNEN0Y25jT3FCWHlJ?=
 =?utf-8?B?L1BsOWxBc2tFQmtGTDM2aG00aTEyTTJjazY5ZE5rb1I3Y1g4Um1CbmVqZWdr?=
 =?utf-8?B?NzRjT3g1amlnSnYzK3Zac3RtYythdndpV2VaRUIydndEaVdTdjVIa2tQMGFn?=
 =?utf-8?B?UGNZREFOZVFKL0pxRVVIZldzTno1cllOdnBtMkQwTEpCSjNhckg3OGh6OEpL?=
 =?utf-8?B?RlJ4NjN5aWNvODM4bnlhamFldWovS1E0VFBoamJPZXVPRlFaT2ltcUpXWWhl?=
 =?utf-8?B?aVRXM0xMUXpyZFlSME9pdnBVbitkSWpRQVNlSm8yWkJESUV4bmR6UXpPS1Ur?=
 =?utf-8?B?TUtJdVplZGJBRjB0YW9qajJNckoxNytGbnBaUVpwUTlxak5wRzlaRk9BQ0FH?=
 =?utf-8?B?blRraGdwOTUvNi9DSHd5QVNLMFhuMHdKQUxEdUxueXVMbGY5cVBKYytqcVZC?=
 =?utf-8?B?QVNqSWxtOHVGVDBFdXhqTWF5N3lFaitZWmRzTURBTllHYkVoSklsWGVQZlJK?=
 =?utf-8?B?dExJSUlhQkZJSkdmQ2dQWEQ4NCt0SHovY0tnNzMzSXlPWjJaUHE3TlY4MzZL?=
 =?utf-8?B?c0FxUmxGVStYTWgraWZqbFJvcVJkSzNSSzFEa3J2azNFT2tlek1uRXQ2dThk?=
 =?utf-8?B?N0h1Vm1xc01GMUJwRFlvMWlYZDV0OU85MmM5M1dRVnlFOEUrbVh6TDg5akh3?=
 =?utf-8?B?YUFEalYrR01ERTBRRDRwN3NPQVd0dUpua21QdEpsT0o1a0hnZGI0Rjh5OUdq?=
 =?utf-8?B?aDJrNFVCVWdoNFR3djA3cmwxN0tpa0FodHJ0U1o2S2pzblVrYlg4K1hSVXlo?=
 =?utf-8?B?bk1PK1ZCQmhrZktZeENucHFSQTM1WGh2ZWV2T3ZKWWVkelFpcGZWWERCSTRP?=
 =?utf-8?B?Um5LcEF2Yi9PTk1IM25HajM5eGZTd3J4RVd5SVpyMTlwNWl4UEtldEd3RXZF?=
 =?utf-8?B?dVJDMXZ2MjN5VXJkZXhEMm51YUtsMG1wSGpyYW95ZkY3VmZPVWxZaUNhUnpi?=
 =?utf-8?B?TWo0dEdZZFoyQVQ3c3BPY2RmZlQ3K1pjNkV6K2RJQThBYnByMUpzeVlLWkpM?=
 =?utf-8?B?MmplNCtmMXFkSk1JQnNVSkQ4bjU1R3JiQ3V5aFVTdFBSMkFaa2F1TzZOM1Ft?=
 =?utf-8?B?VitHdGRjZm10MVVxZE80UVFvUzBUMVRLMWs5cnEzcnd3RmJVejBMZTlwdEhD?=
 =?utf-8?B?MDN0eTdXTkRFaWFkTjVka0Z1WnRhYjJUZGxTMkRYT0ovajBmakJ4blJ2c1ZY?=
 =?utf-8?B?ZkY4MUx2N0NiaHhER2hDRHhSalJsME1UZkdVNGQ0N0RUUDFoTkJ4NXZtL2k3?=
 =?utf-8?Q?PmbgfW7kcZKAoBNpxtjHrfxmFiECkOMGL4SDR?=
X-OriginatorOrg: cybozu.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f002798-0e85-4982-82a7-08da476849cd
X-MS-Exchange-CrossTenant-AuthSource: TY2PR03MB4254.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 02:57:26.8284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3761f390-05f7-4386-9a0b-b6806c13b841
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkqehMQmVmRn1QJaAmn+bnGQ/M73oGYK2LLtxstzYEVGCCfGwL9R65lAxyHUBtavAvcWXtEl9Oj33LsIll0KxKOjA5no8paIgEE6Zh4MhB2hUhyzNjJ7lT8JG5AL1h50
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB2909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

* Changes since v3

- Rebased to latest mainline

* Changes since v2

- Set scope of this patch to log message for osd
- Improved format of message

* Changes since v1

- Added client gid to log message

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
index 9d82bb42e958..e9bd6c27c5ad 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3945,7 +3945,8 @@ static int handle_one_map(struct ceph_osd_client *osdc,
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
