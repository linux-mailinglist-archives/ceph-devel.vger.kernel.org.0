Return-Path: <ceph-devel+bounces-1710-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7073695B273
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Aug 2024 11:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94E101C21CAB
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Aug 2024 09:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1576717B4EC;
	Thu, 22 Aug 2024 09:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="pl2zxKmi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2053.outbound.protection.outlook.com [40.107.117.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14266175D5F;
	Thu, 22 Aug 2024 09:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724320576; cv=fail; b=q44813yPZ7Bub2ynR14ytRR1QTcVzBUkzjeLzASzSEhv4XzbpKjK0VsheF0E6MVeUvL7LKyk/Nb27pUk8Qwr7pmfTXhIH+y6lfPEpgPOShJjTnmaOAP83twfXjwtm+9yNWhIZUf3CD6xc8NqMK49WGT9TZF+qLFixwfHZapvPDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724320576; c=relaxed/simple;
	bh=kslK6KtTEwdqSIwdXNHQGeg4wQAbhTYRYZg0LAF+lMU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=huAmbubN8/qI7iqUMIJvXUH1XRc9lObwDtjgBZhbOkMjsvwJKXgh1/WIegZIJrJG/LlWHlcB/eQTS3Crgx5niRJKYXuGc057hVB06zd2VmbtuA2U5xKflyvXNI9ZPX+GxyvIYtJEVSWD0hU42mr5Ewfhc4fD5Nj75fmjsAPoI5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=pl2zxKmi; arc=fail smtp.client-ip=40.107.117.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X47Q3Br3m5Jll0V7jbXKPR5KrV5qLl6f6r50hLaH4udsBtfYvMJPfjHUuUc/ZHiL4vwUf1dBpMElonMzcBwtbsPDNhu7hVaJq+Z5XryAovwKYKgiaEsLpuQxnRpQ+ZISu7owclaWPVapjvNToVnhzJN5DHnUiABlrybIU7V1eIUzT9ajJCtA2+tU6yC/r6y49Vpy3d05a0KFxgAZOkhTCYvhRr2x2fSpyKKX2FNx9A0s4k/H47TcyUsv5SpKlVjRoQmMwS14fcGk2WDGewRH5CUO8JmXuPSGOuA6qbzzjm9P8nlJAAdkz8CBxABdWIFcnwVb0Hg7b0zEaTcjJEnO7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ng2DdqpX130/NMqU2juq9gaLJohLIm6pi9ViEE5fSgQ=;
 b=Dry9ijAJupHhIgHXwNnY0jMmfgru5MUqeoisy1weLS+/2DLXK4V/z/19QzO4SVsfCY5Lh2Vw1m8Xlhad9WQ4GV08TXy9HX7Evor9mUhgkdGWmNhq8MrZQxFEVHKDA3saA1tid4d0IPquoJc3VM88DCwknQtSBYJzmRoC31rCl21zBD8YdH/tV9PtNSXBf6WT35tAAmhj4qkPcY9hqC3jUp6zagY1z7wvlgo3QEjA0wiSAn9MBGlKypKte9+f4T16YGtIEbiaetllILCmWEgwLB74Un3yKxdQ9NyCtfFZ0bV2KdtMGM97eCWc/G2IvEl5Du1alkH1x1SPHLW/PTN3Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ng2DdqpX130/NMqU2juq9gaLJohLIm6pi9ViEE5fSgQ=;
 b=pl2zxKmirss6ZZgymsXPi07NNF2lRKFx9Y3tiQI65w5IaitydM+23FPRnca/v9d9dt7RmQrd3et//Q2mvXSSkCHWzpaLtF71Q8RguHnZ45tUZeF9dCBpmjbGf8eloyvQzDFdpJW7R0G5Tl0DmizXAPdUeenDz1jzsA5ceGsHC7rv56xhw3jfm/LB4Ryw2FD6p5QiB2juhOEkVZuDv0bkWN58X15MJW6ZReDRm4OV38LWevCYFHUiA3l+abQanP/GIOz4KjVYA3SBTl7oFBRBrWW254G1cOaQjD2biInRG0gR/p7/chKNO3s0vCFMUitC/Q/eq5UmmkhffQKhTzcpxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 (2603:1096:820:bf::14) by TYZPR06MB6617.apcprd06.prod.outlook.com
 (2603:1096:400:458::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Thu, 22 Aug
 2024 09:55:52 +0000
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f]) by KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f%7]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 09:55:52 +0000
From: Chen Yufan <chenyufan@vivo.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Chen Yufan <chenyufan@vivo.com>
Subject: [PATCH v2] ceph: Convert to use jiffies macro
Date: Thu, 22 Aug 2024 17:55:41 +0800
Message-Id: <20240822095541.121094-1-chenyufan@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0195.apcprd06.prod.outlook.com (2603:1096:4:1::27)
 To KL1PR0601MB5487.apcprd06.prod.outlook.com (2603:1096:820:bf::14)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB5487:EE_|TYZPR06MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: a256bbf4-336f-4554-51ee-08dcc2909ba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lLtHnarwEBiqSjAE7554W1Uz4BBERB9uK8gcTGhoR5IMdSjj4mDmVBTBXk/G?=
 =?us-ascii?Q?ZW6X0l/2UCifn+XF4XjdwdALritYhPOIMZrIR84tsiUrgcyQb48NrMQ6n9Mc?=
 =?us-ascii?Q?ubEzqtcNrIVAYQcinbP7PCssICzWtw2PW0jYJmpU8yh19GkMqsmp3MIijNX/?=
 =?us-ascii?Q?tsFnWVRY6yKLvs0XJf4yS/73hAIgUgg7Qr6TIaESe6oLdxXGE7+x7/9dJ+vy?=
 =?us-ascii?Q?Za5SWVCMcOrmPfUNc05mDis/RPU7Y0E0Bu00XBzi4jHiePkCC/RTyyjRhIDx?=
 =?us-ascii?Q?Hxi1v0ZgAah1nJTFDvSJ/0g2ZbdBewqiZX5J+cw4R3HUlrt4J4pIb6yGVfEo?=
 =?us-ascii?Q?4RbxfiUgLDR1wtgoXQVXoGKA2K8FEYMidvrT+i8jc0cpVadLageLXgUSJk4y?=
 =?us-ascii?Q?twHH5sG/43QFmMZzcHIQmSMGfbuDStrsA+w3JtVG2y4vB/NKxqKnETpimMb/?=
 =?us-ascii?Q?/lXH0vwARhAQbPKwvXrNS+wIzOXEy+QO66cbFvzII2UabgmAcFG59GDIklml?=
 =?us-ascii?Q?4pcfoIuXCk5ONJOFsL1HuynUFfRBc6UmicKfGz/94pzKnKJt1rWrzPnIz3dx?=
 =?us-ascii?Q?hmAiO6vI20OcJ5QXtVm9NFMBnMs/qUt4ZvWNJdzq+Mm5lF3jBYbvfv99gP0/?=
 =?us-ascii?Q?uHIzRBfw7Ok7Ep5HWEaF+vy3yNRAwhPGUdlrRNCH5ZuioufG3BSGnAB3OMjz?=
 =?us-ascii?Q?jLOCwIHP1Mkze38vk6ati8BLII8ycwsikrykxtQKnnQBu3jo19oxlWnSOavM?=
 =?us-ascii?Q?37z82YXrgBwZFX6a0fYyXUb8QCbxFKIZJAgeC/TV11oRec3sNEO6/7xM+a66?=
 =?us-ascii?Q?YUT6SNrzPsSd5E74iRqT+jqUSkZpZF9R0n3kFFGqX5+3SLG4XltZmEUHC4y1?=
 =?us-ascii?Q?sUSw8aRRjUbclLr/FfQInkC8VA13wgyJtGfmCj6ddThIfV7Y/01YzhJB8i/c?=
 =?us-ascii?Q?eUmbBJArmDYYJAH0Cj2YQlnwlHfTCSRNGFQOJdkbV9BFbUnZqjztArl/uzXm?=
 =?us-ascii?Q?7DJQLlWmHLr7yDdz3HSaEsu31hL9EWZ+G1/KJzhTjhDtTiXZr+pV1ea2H/jB?=
 =?us-ascii?Q?ls0TKpbhVnaV1D1MOVYu+mtY718Zu5Pvr045SG0xwO0zV4kkyfltZJA0JOpY?=
 =?us-ascii?Q?LgM/DPrkoamHBpTk1q5eFa0AFP3sAHUL7ezMKsSMnaBQ9RiVEppubzAGvdMI?=
 =?us-ascii?Q?1A4mERx6ZKNuLCLgzNgbTH87lVSJB/dkwtosIx5Q8H76CVzqi5bmkrs90ATv?=
 =?us-ascii?Q?zS8AtbhyKdcplUccY+NTDpJSnam2P8VBynhadU8dvQZaIVRalsj+WbPM/qtz?=
 =?us-ascii?Q?e4ffUv3y2cTtAYm1ci537H4438TU2bovm8k+aaLHvHhy4SR0PqTLSGv//UtX?=
 =?us-ascii?Q?k6+dNVW54+tB9OBYlucGCmEa+oN8xMWcpYQOqyRATfwVvqdzYg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB5487.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+LZbyoCY8bpMNcmpwqTc1i8nFtW/K5xpELyDxJxDjNCEG7yq69PU9aQvpBFq?=
 =?us-ascii?Q?NVOcy2kNi0jX5seyGoRI2K1qS+b9dDinUSBlvfl8bK7dFIgLmRQtf/0KF6qX?=
 =?us-ascii?Q?ed9L3jMq5q0jP9qm6v/t07ns4COAWQAIfO9PEZE9c/q7V5EFhlCHV4hvoEQf?=
 =?us-ascii?Q?8qpcAW54fvJ3Q8b9qjui5mIzq9AVtdDszKorSJ4DYMmNxaszMbPvvf0pvkLh?=
 =?us-ascii?Q?qwfp8m+c5yMGwKvamD+2LWJyJlGpYquAtqNySzfgHZ1YOVOO1XnN+XU6z5T1?=
 =?us-ascii?Q?L9bRRDZH4T7xKKkr7FmM9YWRCH6BiJ+v158qSgp0641utc1r0Poo87mygmx+?=
 =?us-ascii?Q?BFRhfJeqJFlkD483wl6RemaDrN4nkim4Kedsy2Gp1WGuweeVNmMs1D0uQoUN?=
 =?us-ascii?Q?HZrnCJevGU9xv/TQQ/XXgdCMJDS+o1CHftbuZng9lC0MjQdWClY0NyJ33qf6?=
 =?us-ascii?Q?jzAn5dKj3erwEisyB78mznAtN8X9aWyofkY9emf/p7LKUsmFL0pDrDujUPVS?=
 =?us-ascii?Q?6EGDPysHGRG3JdXDvw7JnFfJgRZT2g8SAyfHRYQG8HGQCKeSuKpTFzCkRFuI?=
 =?us-ascii?Q?6zKBrlGoYgyc/Lf8y/XW4TQFM+qALIB5ROO00t6EqorsSMqMYNCHO7s7Pd/k?=
 =?us-ascii?Q?i61Kw7fQlydknUTTUJVYPBbtZRFjI0FL+ruZi5KI4d1ChUfzvw/Xp1aYDYTd?=
 =?us-ascii?Q?ErTg4/C2V/tqfI/VXUxp9OjFuvll4m8xdEgdwFy07YBcvZG2nd1jix7KI26I?=
 =?us-ascii?Q?KIgZjnYayvZfVZi0/pAx7+aVvZyCX471sRYS+P8hw0WKcgRkyajfGOBlpFge?=
 =?us-ascii?Q?vk+cGIx1Xaq2tPu5uthAOflTd3WgeyAmcmGSPSJxtESxJrQiG10eW4JwTHJ3?=
 =?us-ascii?Q?vWykRgVYb1EyeW4hTrjbYAjdO+PpcKbhAh+VcxhkaDNcdkN0K9/NMgejxIzb?=
 =?us-ascii?Q?21cLDXTO6p3OhfbXCvu4Zvfz2v8hpJueoy2zSfEV22hiSrRGOC0qXZv7L5m/?=
 =?us-ascii?Q?JHD0zu7/oj5OojckCETe5lEWDPYx0k7pekLsaKCM+NvcnIY9mgdo3+/6nRO5?=
 =?us-ascii?Q?JOmPvj719mcuMOFWN8Q8eKL4wbfeXQlAeQqAwHUPXj3l7PkVVD9tElFwTdXR?=
 =?us-ascii?Q?PXRbrdox4013xY2j3okJ5lJ3D1BKTmeLIECtb4oM+dRNJZBScnQeszHU7k3b?=
 =?us-ascii?Q?MUqIKL+BMnr6nx5baJ1uDqsT/u1YSgEsBuvuu+iKr6Y366nyLyLCSpZ5USXv?=
 =?us-ascii?Q?PAZTWpppsE+ipMy/O2gIlLhLlPLbG1dKULEf8Q+zYGQ4OhxHNpbzfPuxwUPM?=
 =?us-ascii?Q?3t/NrjxYsh+GMCw00Vr4+T+P+mixFqZZWvOwQ1R27fYLXgB7y81VJaHMqP0m?=
 =?us-ascii?Q?r7S807CIKtW53Wv4XjbnZakGA+6GEgdPcE8LBRYKbGuvJRUcRXlcsq5sS9K4?=
 =?us-ascii?Q?tcGiuLTfqUbYmmRemS0VL85rLT68/fC9BiX685/ph8qsRd4f5KUtjKgVqzfp?=
 =?us-ascii?Q?igZJGBatbEhQvIMNHLKLYxtZR/gEnNBOJN4sd6iDO1ffbJ1GkQq23SHT4VeZ?=
 =?us-ascii?Q?uqCFb8ZFcAapfbIwP5AwuG8UgOHcqQdanMBDxX5A?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a256bbf4-336f-4554-51ee-08dcc2909ba7
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB5487.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 09:55:52.3663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q2uYEBw3pI/h8OJApgjX2IWBal0/gqcjFpokv19jyFTfWaaT6y3thoGfoWT1Kr0swx6jpRFCM4sLWbVSrANvJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6617

Use time_after_eq macro instead of using
jiffies directly to handle wraparound.
The modifications made compared to the previous version are as follows:
1. Remove extra '+' in the header.

Signed-off-by: Chen Yufan <chenyufan@vivo.com>
---
 fs/ceph/caps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 808c9c048..6a55825c3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -17,6 +17,7 @@
 #include "crypto.h"
 #include <linux/ceph/decode.h>
 #include <linux/ceph/messenger.h>
+#include <linux/jiffies.h>
 
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


