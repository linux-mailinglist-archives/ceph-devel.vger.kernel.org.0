Return-Path: <ceph-devel+bounces-3060-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 980F9AC89DC
	for <lists+ceph-devel@lfdr.de>; Fri, 30 May 2025 10:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52CF91BA5824
	for <lists+ceph-devel@lfdr.de>; Fri, 30 May 2025 08:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FBD621516E;
	Fri, 30 May 2025 08:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="b9kke78v"
X-Original-To: ceph-devel@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013053.outbound.protection.outlook.com [40.107.44.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EB120FAB6;
	Fri, 30 May 2025 08:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748593468; cv=fail; b=NlDSLHQR+Iacrz3umb7JiSOFFGPspkKJA06JsNIyXJViRu4MJ2sWacvbobt3CxcNn5RFvQmrrC8g/M0f1/TtG+vROMTsCRi/8nIqS9NwMfj7kniyPntQKfShm+E1EBan85pheDqDtF0IjrYWolRamgJ8BrugCLuLdcj/cpJPMKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748593468; c=relaxed/simple;
	bh=DZBWRnuZiDq7Ka3MlJjIqcdnIQ7jmn7as8qqMEcxrEg=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Cy/f+7r+wPZH73dFmTaB4ojjDXuDP6xlzAH+zYj/ZTFFmICjQONRfPLoYd7ICq2g2I+cpGBNMtXaL7cbazVc2Yt5NB0RrmrmV+VCERRiaIjxeK74UciYfsVtEdu4N1uYa8gVX0WLKfhjnrsKhedfRK7NyTFMgDdY0s53Q5G253s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=b9kke78v; arc=fail smtp.client-ip=40.107.44.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJ7dVph7sBEXj+ItbljTxiHoYWmGAXw4ZZ1G2ykKMFNZMxOr6mwrN+spj2JFVs5FRsDA0VLO7/3LccpuRqFPw3TANIHj34qgS7oD0oqFLIs0bcBB02hFnAoloTSmNRtpVd3V4qFQanF6luXFkoS+do3fSnb7d1kb+GkTKDGfZV9F26P+NKm1NrxySYNNlAmU+CAMFMY5BzSh6HolmQsIfELFXPM9GzsflCgbVmKAy+W29urmgYwmBwMB92Ntm1CZRNB5jrw5/LmEuZrN4RpR51M/b4HdIaN26Y4V4v7IcbWCUutaJQDx8sjCttV1dAnZW2mXU0MrNErya9sp2YoYhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awdbzXu7cp52Km851VprayeyS8sIHNgi53PtXmowiHY=;
 b=qdTgVQnzYq086hv1cRpmEAEpzZSUscqp5yYcR7Aa28RdU+8di0hQnC2LvckpKSSyEMqDf9iOc++A382T5fR8nWNTwsHNj3S/1Pw1Ghwe6LfxaRW66N9O0cE4f1qURhTPLnNHMUGhM6MpGlZpuO1YpdqTWgKmRKT6tS9lxMjQ260RHMVSFjuslj6DkVY2Fe+VZODrsCJzwwk5t3DJ/gB8XEd8xJho61dhUy0vq5bfDw1uDQkypdYZp+3sfRBNQEvX5CDgXkKdErilt3FFlYZIHGZAOYO0xfahtASOclNwczczDLK5Y3R4K8EGIcTnnIW6FLJxJbA1a73WoejwrImhDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awdbzXu7cp52Km851VprayeyS8sIHNgi53PtXmowiHY=;
 b=b9kke78vptyEyCC4ovrKHxqml9ECVkOpT7Ghlj0lyFlnnMasgqcvqxSyFdnyiaglD+u70xsaG3RJyzmd5NAVErAhnJNgQuiBjxLW+iGAazD2nNPFeo3nMld/TVRwGnO0gSiJs+xoIOahLJVf3Ev1eAwIkORIx9wpPiE5nzf/um7seP/8kiiKxH5e1ahv3wN4QyHBbe9JhHueed2xKaeAyVfxRkt8kvFMowc5k5lbjBvprq9l6Spj7+k/bsdeCfrPChJogdBn0W0WaQqX93XicMbVAvijSe7V8MuMXoAZ6AANkdc1yJRTRMBVosxubFe19QC2IA1jI1GZgcZwEAHZow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
 by KUZPR06MB8028.apcprd06.prod.outlook.com (2603:1096:d10:49::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Fri, 30 May
 2025 08:24:22 +0000
Received: from SEZPR06MB5269.apcprd06.prod.outlook.com
 ([fe80::8c74:6703:81f7:9535]) by SEZPR06MB5269.apcprd06.prod.outlook.com
 ([fe80::8c74:6703:81f7:9535%5]) with mapi id 15.20.8769.022; Fri, 30 May 2025
 08:24:22 +0000
From: Yangtao Li <frank.li@vivo.com>
To: xiubli@redhat.com,
	idryomov@gmail.com
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yangtao Li <frank.li@vivo.com>
Subject: [PATCH] ceph: correct superblock flags
Date: Fri, 30 May 2025 02:44:58 -0600
Message-Id: <20250530084459.2434286-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0033.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::23) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|KUZPR06MB8028:EE_
X-MS-Office365-Filtering-Correlation-Id: beff9f43-6085-442e-6603-08dd9f536146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U/1fyNZm4tNLS8LO2hvrzuYqeJelyoh3j5rOiaegGMuR8SFXLv35OToA+HcZ?=
 =?us-ascii?Q?FtOOsrd03h7+UnNIfy6I3f9LQ5VBEUwr33k4TZFLjY+/MQwdYkdBGm1A8bFZ?=
 =?us-ascii?Q?2mPqFyK7h55E9mOvFdooEkM6KmCjxg2HHjXc5dFWEmyEGw//D/qYfS+1Dc1P?=
 =?us-ascii?Q?y+wT/293tID1unoHpTbAp56Gi3s54d0IQKeqUg8RHGXRkgwsks2DecZ2mjzO?=
 =?us-ascii?Q?eFBgy22Brr6qHVStC2/AHybWoj2keWAs571iF9qulU7lGYneFa5MVefOLKJ6?=
 =?us-ascii?Q?tGE5OmC12+NX3/T138Nper4RhY3fD7OsoJgvpCyjaZq6yAvAZqyTD2Mc3qLO?=
 =?us-ascii?Q?6MKgp/ZKHjdNRDEdJiZoCHm3wxvup2FopdXFr/4o0VzPXAJpHkYd4W4LhpXI?=
 =?us-ascii?Q?E/7McX5oMuT+PrLWp/tM9tHdd11g67jD9rci2Gnea8psfRXRLl+BSePRisHZ?=
 =?us-ascii?Q?80nulnjJIT9EUoD7okaH0eGdsJUjsjSgjxJn0ZHxiw3n8etqcClSyQC19ROK?=
 =?us-ascii?Q?syqkPbyUDkw8irUfKwV+NQotED4dBueMU6JOn46N6VwUIadmUzGhtIgsGzsb?=
 =?us-ascii?Q?8uFrqIPBHjSXNhRf59DobgnVfVHbQuhF2uQgRYVPUwPuDh4ipUPkbYFdFlpr?=
 =?us-ascii?Q?E6u33Pa+tWw/BOoeYDPo+MmfwrpJdINDu3MNFbGiHz61RDO6vLobXFQi0y50?=
 =?us-ascii?Q?grFmAozpyIQGdFF+9ggzh4b27QqKv5zb67bYskOB3FtpWhaE2UDieobVvOPW?=
 =?us-ascii?Q?Pid7Dg1AYOtZ4MGYOsW2XPsfAz2W4ZVtlH9cvvdU645Vf3hXKWQMMOL/xJE7?=
 =?us-ascii?Q?e72fcxmRlSKyLeV0OB+72AGngKZqBxupHD+OsZm0dA+/i9G0zRer/CpNkwyW?=
 =?us-ascii?Q?uad8g7jTFuSKg5vCHLffQU13VjzKLEYiL1MHl/CaCz9VgCLu4LI8xfbCq4MX?=
 =?us-ascii?Q?aebIfkmfm9vwLRpH1gvUAQYk7Z+V8lDEJDYyN2wAcs8Tc8+vxZOhWKb1sBHj?=
 =?us-ascii?Q?AVZY6IvTlnb53YZR76HYLCQV/Y5f3VpqYD1luENkgpS7JWWOvqNHc4+c5Ub8?=
 =?us-ascii?Q?PAr1/CbZtGCNf0pNEMCkZkI6SgOPVKxZP74hwJqXJnqDEwNdo/8hvoyoTNzE?=
 =?us-ascii?Q?vXEPbGkryehF3gjFdgRhd8p1cThCli1I5N0SEZvmCjDmzEPs/5W+p+UhD4tL?=
 =?us-ascii?Q?kkE2uQPXrIh9fHVq1O1vSSjd2Wf8E7qY4/ogeqQgk2M7liR3Ogin7BV4Oaof?=
 =?us-ascii?Q?4MmkvCsRO/Ih9H2lFU+RJKekoUo5HalEvegJ1sNg5ojHVSTKPstkOApfWs44?=
 =?us-ascii?Q?lSqKK2jyE7xpsnwZ6JoDDCKKuWeIwtk9yDGxVu7sOpF4PMAYwIhIukVaAUEO?=
 =?us-ascii?Q?74kGahhJN5Ptyn349NKAHWkIlmIhnUEtKNfzJa8BjHqZbYwA1Fr4MVSObu6/?=
 =?us-ascii?Q?dTw2n2xcg7uedh8kUNN7AAJiK2nbwsQWoGkC6PYf5fSwCpsii4NekQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5269.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mxWNwe9vf/ZSUOPWnMiYOVnhGO46Z8n8bYBF6I0YY1IF8TsviUbIsnMzoo6p?=
 =?us-ascii?Q?AMQmhpGOdvJGySoxvM/ddvK5GsZHremwlRHcA5w5sVHWXfCq5mUbSFWgbxqn?=
 =?us-ascii?Q?ZbDyLHm6/rWsuJfIB+d5H/YjsVWpfjpciedMfwC5O21WW+MzxbykIuU4jb+4?=
 =?us-ascii?Q?CM4HRFEbUaC4jrDP9uiSqFzf2L1j5awiK0d07jDG4xN+z6x2FNgfoXRB9utc?=
 =?us-ascii?Q?qRj3U6Zq+HN5/I/D3jEclXqdSiPDwr6rAfoeI/ogZB/xPVdm3uGGEczGEpbh?=
 =?us-ascii?Q?qyYXUxSqhul0hxAFhYsBqJvdpEBBR/EesUXe553S5hCxug+958aPcM1SPwi2?=
 =?us-ascii?Q?KeeODyM0iZMZPc3bsffPr75kkgBSQgbNgPY+xu9StB11NKIZ2UrcykkoUm+E?=
 =?us-ascii?Q?bFGGYpyCru1f89lGiVoSpnW+D265DmvDfxSNkeDe7z4Wy1DCnqin2mE/JZJ1?=
 =?us-ascii?Q?Zt3PN564Yikp01KK1xvfHkpJB7xAv/eUYk72bhkBIb7G77LWPdgTgk4jBEV7?=
 =?us-ascii?Q?mLy4tCxtOVtcDg0l4bk6cqzvEXgTN9qvFmeDYHIAKsTlbgZRDid+XsQOFtMu?=
 =?us-ascii?Q?/L3BikaICF6sF8ZzCubagTAoMDZ3zE8oBxad8DR1AGXEeUKCNNg3yPcgxQHf?=
 =?us-ascii?Q?nAJrRRpmi4HDRrUvsGVL4q4wh6xt85lOAq0Vi6My1c23bWPV8h6ObXsb+ASN?=
 =?us-ascii?Q?80S1d2B13wxMgjk08VfLylzSxoeqk0sSlXpXX2UHUplh1KrEW/EDA7ARB7iS?=
 =?us-ascii?Q?zQ4lIJ2EecPJVOvNvN8tJYfzCrl70vKuHailOYq3NCONT0bpi4jrZsSwb7a1?=
 =?us-ascii?Q?IJWnsJeugXXulivX0ZbZuCu16aZAGlbVkQAs3ENgkDr/e+vhPjGD1B7pXs0A?=
 =?us-ascii?Q?aQps6OIEDNTGyIvZz3dijKneSFYW+UElLrW6xp7+En8+UzEtruzCIUvQakwU?=
 =?us-ascii?Q?N5KrdJ4oDcRtymXq7QQl9V6d2RO807usGqBuqmZwvs2pC60WcctfNXBC1nTy?=
 =?us-ascii?Q?WWRR09ccP6zEi9PvPQpe7rPMb6GPvJEyhNy2nZoQ2mVzKIPFxmBSnjCoik9h?=
 =?us-ascii?Q?6y7xgue48srDkw2zN5I2X6FyNUNSGrZNq2sln9pGvK2778GGWvJZ2Kxx512C?=
 =?us-ascii?Q?0aVmlXfykJ4f1lLtt6/Txo0DyVIdt9qpz6hMtJd99eX8WjcC0p/4/6hvUxYE?=
 =?us-ascii?Q?vawkruFgxWUDFR6w4QqHrsNq4uy0HAabjs5mY9FpYil/7i4Yn7yw2CqgNwsx?=
 =?us-ascii?Q?r2ODNkyTm5w/pPq/GZJ4sczL5vzUh+HohxKMOZ+sw4S4+INUHinT0/xKSWGp?=
 =?us-ascii?Q?mONPRA9d+o00mlnCiolyz4AnWqUncv2igQTcRPxv7wbbqVw4xxF9UrHSJ7yi?=
 =?us-ascii?Q?qrjJqg3Cx1DGJtFEIy/9zy74SrJXCMvN0unrfm46iuuB7uX0d7DhgBMzQkqU?=
 =?us-ascii?Q?7Ab6Y99XDcNGsQrJo3oG7kJjx/KJXSeu1u/XIKTR7t1TkNGxxTKkx7pWznQ7?=
 =?us-ascii?Q?VL5ExIQHTKbh+MNUlhC5hFlvgq/IzqmDuJzCyQrouGXpyYqDsTWrbfCth4NV?=
 =?us-ascii?Q?fS44BZmnrVNbbigmtGl2K4xfvvBiAzaI9dGAVHn2?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beff9f43-6085-442e-6603-08dd9f536146
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2025 08:24:22.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jp/FMDN5HQpEpANzg58pmBmsROsl2F8Z2oGd76OPWzy0TEVD0gfmv7q7CataPMLuSW0xT9k1KGbNzd1fOnupBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUZPR06MB8028

SB_NOATIME includes SB_NODIRATIME as a subset. Therefore,
setting SB_NOATIME is sufficient to disable atime updates
for all files and directories.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f3951253e393..7c9e4987adf4 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1226,7 +1226,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
 	s->s_time_gran = 1;
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
-	s->s_flags |= SB_NODIRATIME | SB_NOATIME;
+	s->s_flags |= SB_NOATIME;
 
 	ceph_fscrypt_set_ops(s);
 
-- 
2.48.1


