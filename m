Return-Path: <ceph-devel+bounces-1709-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53EEC95ADBE
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Aug 2024 08:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCAF91F23046
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Aug 2024 06:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E3713B7AE;
	Thu, 22 Aug 2024 06:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="E/PnXQy9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2066.outbound.protection.outlook.com [40.107.255.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2908E13B586;
	Thu, 22 Aug 2024 06:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308808; cv=fail; b=Bju6WtD09yK/RjRe7838tTHRPES0HCaWbYxZ5EPhpf+VRdAk5L4t93JYpYXYxgUOh5cXPho5ric543SlBoTlKzii6/A7R1hGauJWtcuc9I/BkaTP0JTiL0pjnv82PqS/gVwVcSP1pDEU3G8Mt+Q1tx6Ig3atjY9fyJ/RDyiNpvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308808; c=relaxed/simple;
	bh=yQOnOYB5oguHJFgRI0jxF4/ugt3nBk0X4DzsdRTUn0U=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=aE164afEd4gJgTVD12hIxlDQreW6zi4FSQ9/i4BjSlatygMNHQ7HRJUoEWK0/kDVNlMbVRNXlo5aREPdEEKY7GjCQRIoofospXLjxjSkZEzRB5HuDZVhrgatDgpfF1PlWwkYCmb198DuL9OL8uvJ52NjwtXVqr2aQ+Qt0XAIMfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=E/PnXQy9; arc=fail smtp.client-ip=40.107.255.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NSh3evumtI/1yCoyUcKR9HNdJxPYVRkDtcV2OBV9H4QxatKV2dOSpqcDTLjb/NYugoxRUWjMQjkcKDb0KCA3OLB9GarrITX+nk7Et0dSfwDTtScBZo0nh5/LYo+lxrQk7kd+P7IC5G9iaiI5f844KnTmR4YipsgnrwCFfTSX0RUssUXylGfN5onHB7+7t/ku/IVrMlTgH9h7ccfQNuY9Jl+XPYpsE45H2ev29i/0Y+0NHcB4NkZ01YFdXzJw9sdrn0A9MbGmVlJ6cARyHw5lLZ3vsMBoczrdbtGw6dbQ5MN72wDRRxok17NBQX2uoW5LV/JH/qpSHUd9lkVA7NOiXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBxqgxvWiooh3rArjynQbCjfrFZP56lG8JE8ZoUdDnE=;
 b=PXflBmoRwcRxKXVXSqVbmqYPXzZGNelqknbSkY2EX52xApyqCP1uxZAmFioMGngPDN47F6kl9fqNpay0dRznpdMjvDU/KgaRALUeOWF1ih8LRPJWbYPoRd8ZqdVJtMlHjOJ6gGm3F6IeQVcSleEQ1q7flbkiTTcdQ3XhL6WGPONJ3lVvU6GbhiBffbP51Y/9+wkJmFLq6ILwfvhCAs071EblKg8YWzDhfGHeo5V4NgUGkbDYya8aG5We+lPm22O/zxewmEH6WRPy4HttONNSRgHymv+UdMNYHTeiz9Pqljk/eqDcRXgaDt6dVi78HxbBa2SJQO8EBnKrGyXjAjeW2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBxqgxvWiooh3rArjynQbCjfrFZP56lG8JE8ZoUdDnE=;
 b=E/PnXQy9nnC4UVJOgxVsPzwCzQ+rVr9xNZUuR28hoJlTPE02Dey/ddtvPPezLWlXlaTWh9FbbGqZtVP56bm8jLHt2+VIejVONIRrpDIU4HURUyIIJWxjoC8zh99ofWi59ku1hu+hZv/Zf5S47QXKEPJtOZwYdlyW3sKL/0iZDpWMrXhPZHawezmuclVBYO9RQSaosU3eJ2eaODA4t7nPJ2XNt7hWtVU6lGaG/G+/a4J5A9CorQllcqzdVKjQrjS4NXw8A+ZSk6mon7Vr97kHiRAbKJQmJH6E207otk/ht9M9NPza78agSi4kTJ90Nggsld29/af/3YDAsV4eIB3hBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 (2603:1096:820:bf::14) by KL1PR06MB6474.apcprd06.prod.outlook.com
 (2603:1096:820:f2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Thu, 22 Aug
 2024 06:40:04 +0000
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f]) by KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f%7]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 06:40:04 +0000
From: Chen Yufan <chenyufan@vivo.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Chen Yufan <chenyufan@vivo.com>
Subject: [PATCH v1] ceph: Convert to use jiffies macro
Date: Thu, 22 Aug 2024 14:39:41 +0800
Message-Id: <20240822063941.11635-1-chenyufan@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0162.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1b::14) To KL1PR0601MB5487.apcprd06.prod.outlook.com
 (2603:1096:820:bf::14)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB5487:EE_|KL1PR06MB6474:EE_
X-MS-Office365-Filtering-Correlation-Id: 5239b762-2e8b-42a6-b76d-08dcc275415b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kpI6cqONj6Un2hpZKvkFX995t/PexoBfWls+CsT/2VwmrqItjBCrQQznCppA?=
 =?us-ascii?Q?+CrciJw5r+ro7tUFRRq4mfXDi7wVLW/XDixzoYuWo6VUVGPJtxMOUhMh/2MJ?=
 =?us-ascii?Q?O5hC9AXwhw+h1n+TKcphkLqacilLMDzVdyUgZwO6v3p8mf0f5lC0eecbUkru?=
 =?us-ascii?Q?d3mxmmgQYXNT366IeYmeva+6eJXZONEVpS8nUDWO9ZDa7UmbKhl49Gd42uIu?=
 =?us-ascii?Q?VtM3LjDrM/F2SUSOx/aQqA22e3ff477Bwho9xM+twj+S+2vimBk3rdupdtXP?=
 =?us-ascii?Q?sEMhJ1sp0vDHVV3ScqQ2/oP/uEuSAWbUifLiYGNlto+t3SMVqww9QZkm6Wtt?=
 =?us-ascii?Q?MOPhHrr2wkRCM0xvttVWl2QNOB2FN2lOI/xBPf5q4IkSwezEmCMoLWILEJ2O?=
 =?us-ascii?Q?T9sGN1NqBmwGoF5qkjIH+/wwJJTTiVaEr4WQuPbjR5h6441IXQ9vNaYksjzc?=
 =?us-ascii?Q?HpcIyIIPm/CuByd6WOWQGgw4I+qSzv6PJkm7SZejgfxt+N9wlBEdrc0/P3vr?=
 =?us-ascii?Q?BJCivXNjw2w/kRUt9QvZHZB4P0q2BDt9Q7ACU5qX9oIZcdWPn/JxPBxEJN19?=
 =?us-ascii?Q?R+oZ0qm1wCwa9U+o1ngituGni3FA2KEAh8SiUAHbuElf239Z9XtwS9/aekND?=
 =?us-ascii?Q?vuP+QSz77OeXAtGyCKh3dIcOnUPhGm/7OnOtP8KcEErfgUEQaHoTVrSPMkqn?=
 =?us-ascii?Q?XjAU65+D8vW306n40zAYf1J4YGgwpn7LvdaZE+JjvQbOq0zovjq9shdwmV1U?=
 =?us-ascii?Q?zNyljMt93NVNKBr5Prx3MDwhje2TQI4VWul9PDmkaV1y2VmXrJ4WrwMKh4rD?=
 =?us-ascii?Q?x1frdHe3qjdUercC9VHB52vN3AcTDZ17u1bty2UM6VRErkgQjjTa1y87IBm6?=
 =?us-ascii?Q?QGvDApX9tyauLHb2/GXMsbjdrXsTkl/InEn9ftXyDj77gigDNoze72fjq+yi?=
 =?us-ascii?Q?uOGN1vCdPiGSh2oxBhu8ZSS65PVkowzzDQ/RfQeOuh7rnVDT36gym5IQi7Nd?=
 =?us-ascii?Q?3aeTwjOel9/LoJjPD278jt0NPZo89SXF+PQW9c4ft294w7QdoSbb/3aoOZVo?=
 =?us-ascii?Q?iczL1xgMZp0nnf/D4CTMUnBOafsAwIFGIaZmE+bC26bX0fogd8ldPSPG0r1Q?=
 =?us-ascii?Q?NVZAtusnq2M5AfQGLFDn1LVEVQFadAqDP6GyHUvz6dBuueFoasrydnkFKhhO?=
 =?us-ascii?Q?IynRkONgKMQ3FjdNYJhSxhyQL0DoXaF8peUR0hWnAnq6JQZsVDRx7vsL/xZB?=
 =?us-ascii?Q?AoqEENhzbhRHkHRPunzIkI5PWEF4wQiVpFekD3cbpDRbyl73njbdzqzzGAON?=
 =?us-ascii?Q?sRjNh3LYtkIlZSojWPT/18JWJ39EvVr0RIWh20Uu8b7v4u5CthfQBp2OnKju?=
 =?us-ascii?Q?FbgKDvi5csU6kQXQrr1LPSwHjsV+l69xNMJfetnDqhbQj4cEdA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB5487.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RYXgJbBeU9g52VlAl/ODcrsEdCDDQGHUIXuOmlpsNmOaIZH64O5s951MYp8f?=
 =?us-ascii?Q?HKzAFG4GsfI5XFVbv+oYXoWQubWSOV7tBUS6eyAC3Qbz+r1WFGMQmLxMCw6b?=
 =?us-ascii?Q?UQs5/r65B2YgCqyt0OWhYv4jS3vL/bRtDFVFTjW+icrey/B3SLIITCClutwq?=
 =?us-ascii?Q?+k3P4503z2VhtyqRbsDpOJlFqTAbLnk18JHykCpuKXcByHlrZqXNszmanTC9?=
 =?us-ascii?Q?GfZst+md12BzmJZyQ+qxquQjdDJHxJhXlweV6dS20L9dStyYkkGEPRX5xWjI?=
 =?us-ascii?Q?O9sExDy8mwSZNhrxuKfwAYahlC5/VbyuenN7DP2EApd+qdDNGmhzj6Jy+h8X?=
 =?us-ascii?Q?e2qFH3lwTPUWoJL1GdfZMIRNOFHGWm8efCHhT7tWDyM0X8uv2Bh+DdEzugJn?=
 =?us-ascii?Q?QA7GBWJepLmOaxRx+6ftlhphdmwTcBuV3AzBTZzuOg/C52btITQaIkWdMfse?=
 =?us-ascii?Q?wZJtzfJUoi8mhAsE460i/7b0p+ZOtM3ZnmDiYcblm8HHjjHowLoLf7KdcZiX?=
 =?us-ascii?Q?YdU8258uCpk307reSM96oR+M55k/5V/dkx+BX2fjkO0BTvsU5J+LTeLDAn7k?=
 =?us-ascii?Q?/8j94yJiEnsJ9h1BMAbzmNm6uTCuphig4tKo4BzXCkx8pRFsbFvsL/hizavA?=
 =?us-ascii?Q?bNSFUxdq8ZZ7zOz1b/ECiqHW6+dJOgMWvMsyVEsiFIxHXmHH8FSNXdmUWr0i?=
 =?us-ascii?Q?BFTO89c5vm3ldctkkTKcvEF7mBMOvd8BoFmTR41y7adhg9dcI+7v6Rw0qaWs?=
 =?us-ascii?Q?FBp9chSpv1y4bHkUZDUSAELOOEwjM7GHnbEFAG+ZORRvitdjbL+LYl+7qNv9?=
 =?us-ascii?Q?DRctIyKi67LXHb85hrRHPFKG+uBzjStYtzDG6sdqMWcEJ9L0t90ZeBuDE3+X?=
 =?us-ascii?Q?BVy4tKC2TzhZzfWPnuoDakWPeSDAW3kS3y2yLf7z42zSA5u3pnQ49P4UapFD?=
 =?us-ascii?Q?dDH/qdTDA5zoiJV+FIfLLQPbp/B5voUvRd6w/Zd9PMGsfZ0UDN3omlLLVfPL?=
 =?us-ascii?Q?vrSePaHFh9SvuQCy1ylkil3tJK/6XP6ZC3610jo/DW6vgvEmUpgnDq7ljbrI?=
 =?us-ascii?Q?vbdIPKvVYyMyfAEDp3Zn7eFrQGzu8/WdbLBEEXZlzFNpmiW7hcIDJpqgXP1o?=
 =?us-ascii?Q?n2hfRRLIX00sLT6AJpjkCIMrR+xKgZy3aC0lPis6WZ5MpkL+/5wMD1uEe0fE?=
 =?us-ascii?Q?ifTBLYb28WCQKr/4WtuswAdiZUa0JNOrDQqGTvRqIg6XsAOTcYLSAZ6eMc6R?=
 =?us-ascii?Q?Yn7Jwr2gQdU/K0tLxZ97Trcebm96dnhFQOB2PWgGlIxrWKUB7jSBurp/teEB?=
 =?us-ascii?Q?me4yL+fIa6QhKe+K/gC7tC6bw7j4BPxtaJH+Y9stiU+tTynWhTKUgSYZPfMF?=
 =?us-ascii?Q?AW+hkN7s71Zust01PJh9Cmt0p+dSV9AOju8Z3Kw9aj63xneZtoITDB1ERHO0?=
 =?us-ascii?Q?oDW+dYI/XHy2Cvm8EF7zroCPn+i7GtKXS0oi74S56eu04ggDL9Yj8BMaoOA1?=
 =?us-ascii?Q?XMLbUe4Us6mvOcc1W4zYQXlXlY9CIfa+N54qJotSIDk7SuSHNssiDi8UjtcC?=
 =?us-ascii?Q?RqunZRld+2sMppqQc2ovdDjV9HJasGkJYDRB0dXi?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5239b762-2e8b-42a6-b76d-08dcc275415b
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB5487.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 06:40:04.6039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmZ6QfEdz7jeZzsKE5/6xRvJN6fkLdlmfrYtKWhKuYYD04aZ7DueU+f/vRdketaWzfwZJvrkaVci1mXlmRiLow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6474

Use time_after_eq macro instead of using
jiffies directly to handle wraparound.

Signed-off-by: Chen Yufan <chenyufan@vivo.com>
---
 fs/ceph/caps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 808c9c048..15c4aeb63 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -17,6 +17,7 @@
 #include "crypto.h"
 #include <linux/ceph/decode.h>
 #include <linux/ceph/messenger.h>
++#include <linux/jiffies.h
 
 /*
  * Capability management
@@ -4659,7 +4660,7 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 		 * slowness doesn't block mdsc delayed work,
 		 * preventing send_renew_caps() from running.
 		 */
-		if (jiffies - loop_start >= 5 * HZ)
+		if (time_after_eq(jiffies, loop_start + 5 * HZ))
 			break;
 	}
 	spin_unlock(&mdsc->cap_delay_lock);
-- 
2.39.0


