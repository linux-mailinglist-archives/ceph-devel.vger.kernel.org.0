Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DCB6F9AC1
	for <lists+ceph-devel@lfdr.de>; Sun,  7 May 2023 19:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjEGR4A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 7 May 2023 13:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjEGRz6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 7 May 2023 13:55:58 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2078.outbound.protection.outlook.com [40.92.98.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6BA2D5A
        for <ceph-devel@vger.kernel.org>; Sun,  7 May 2023 10:55:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvpVGKdYyiFslaUvb0urfeaHAy7aoGQEfhf2sZuBj4BbNPdU53iky0ENdT5NlDRhU6vGgKmyAtaNSrtUl+BvX5bpQfiwcTiN7iYm3D9UmRLOJOZigKCkj7QQZnbxH95f8kiQozOmVTaA4g/iaJjzGrwoMtffcNrn5zrH9dh9M5WSw6djduId8d9V9h24Upxl0mWj8gzaA7AMceJAVoXaUqVIrwZMidwjRO9EWLgAAWsBt9ynzm578piKfg9Bdpn5vV2Rri1CmQ31JST8qXE0aO9P3SlFDGy5j7JQ+TcxeJONi0ZFqI49dsTX/xiqDAdI/LhCsi9U7Gc5ROlOds2R/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dljNDeKBZpr8V9Y2xjpt41bszf2ggxqge9/3DaLellM=;
 b=WEwDfy8ch7ykJH/IaP3CxNK21oTW+BZt93UhYKL2tgENxRNpP9dSpbg/WufQk7lPZERJhp2YwdJjWR6hNjP3G0sazkDoz0BooRDUmMqzAjKiM7+3hoHnl6o08vJPh2tb7rJ5I4ZBtHECf7jpmFfl1ybwrWx8rUh5CLcDLph9Nk7YmBkOUGp1jjMS42zmjun3NijIVmUa7NdcqZpw22crhd9yvyGLtd7b7Ugz01zm4hDU1aZOxuE3CfUp4brgwtiQjgIch/UH5D+EynrTTlxWZNW/Jo7PgaH/XPgVD//cofvK0cNQlOYrsdopUVCab/vw30FX3XRxhxMAMpxtXAnX2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dljNDeKBZpr8V9Y2xjpt41bszf2ggxqge9/3DaLellM=;
 b=ESuU5mcg4fD+nsRDaSDe9av49dAIqeodXPi/dLY17CR6LM3MOHurv9tt3f5I78T5bNQ1uABw7iG8XF891/5o3AV5GO6mYLhjrcPu5JzQSRCt2WQqqt8GrOHCDLie9d/in+hV2k8rmfr3NeJF0JRK9JrhhYqdBmodtyKX8SQKyZOwOOaCuxcBbD+S78JoN5KJuM9kQzv/PvRPZD8lFDVpw3NeM8WW6fsXoTF2cehKDftv2ONG5Md+vbDSjz4wB/lVd01aGOnFReUfrLT7PtU+qoyYdpmPz9fl1OS+/ExRRC87CnhC6HASRNbOJp0snAYSV+ao+x4UrIhwFUMb9u3T6g==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by OS3P286MB2567.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:1fa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Sun, 7 May
 2023 17:55:53 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.032; Sun, 7 May 2023
 17:55:53 +0000
From:   Hu Weiwen <huww98@outlook.com>
To:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH 2/3] ceph: save name and fsid in mount source
Date:   Mon,  8 May 2023 01:55:02 +0800
Message-ID: <TYCP286MB206604655F7CAB7C50C6218FC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [DrpjcnO5JzNGwxT7AVaZDez40YW26uez]
X-ClientProxiedBy: BY5PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::46) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <20230507175503.2271-2-huww98@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|OS3P286MB2567:EE_
X-MS-Office365-Filtering-Correlation-Id: a401ee80-3b2a-4663-cf1f-08db4f244cce
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1dmCNUf4xnHAPSGfacaop2COJUYlAUUonmnSSTypGFw8+wO/CdZC5k+zMYIok/9B+XBE72aNEI+xzY7E/W7tkCnGKhUs7WuScCk/rgAFRrckSWTMTpy3J2+A7NxQL5F4haBKv0aNGSYfKctZzS1FuhR9aJyiEAqYHg5TYNcyt47+TExtND+9vcDBMbRzj4F8ztUw/18KBJIU9b1Kgv/RIFF8Kk6KN8Wm1RFdik63XZ5exx6uhOQLVfrkMa2H3jHywVVZCpAhXSPnlrA6oH/aVbe9ti/u7VFxSuRYmsAzHZIZkOIWO2LoRqooml63XP8EV9DDnrQPBRJpcv/ddcSe527bHZwThxArJsJCCNTGBmae8yRA33lZQ23XAPT87HnIHI96RG0wt+ELKcuLlJi4QYlWKaEu+9HdFRYTZ7bNhXrsU+gqWExELlhEi5lNGnu/qx0WS7iVbjC4L2yP4eRe6FQGte/zJoxQpcRHe9swBeLWxkg8Gvt8KBgeUzrO5t/XnDAC016EpjHXDxPFd03ixpXkC53j9SYF+sZdFO33eDJ/SMNJ5PHB+dVmj9V+DGVr
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6DxyEf57HAyfN0UVYk+mNoBbpTi0hqp/TZ30bbi1EtgLddRzV2s7rrvK8bW9?=
 =?us-ascii?Q?BH6j/Fg2+YVGKURYx5gAOpegReMNsLZUwDgfS6FxuHrNmC76DYIVT3Zyieh1?=
 =?us-ascii?Q?PSO4kq3tCqBQWwWQ5LSQMI8/mXTe3q7Qv9iw04pJ/r7lGk1nRucd3x7otH3H?=
 =?us-ascii?Q?s3ghz6snpZL54rHk40GVxv6BHrRPIkjJq4yT+HSyl2ULhhBzsKgrp2UMLC6X?=
 =?us-ascii?Q?TF97M1pdOdmIcntsACtPCX/M4NqyBW6N7LSwWn4HiPgsPuN+7jaKcDWmls8H?=
 =?us-ascii?Q?ZdV1Idx9XEfcotvtPcXL/WwLCDWdzFAJfkHHaQ2dbOLtfM9QhKvSae/+BFqS?=
 =?us-ascii?Q?MU4fOTX25awFfEAdOjFFV7okc0dUJ77pdBwdjd1wIa3d9tFLdP26uF4zQ+Ux?=
 =?us-ascii?Q?c4XfNBYsh0De77YqoV6Du/+/XD74vMmijDLJ+K0ARWdBlkTvCy+Bkr1MyOWA?=
 =?us-ascii?Q?94RApUiwb8sbrMWdxqiiErzbFXLziijUFakVoVSvlncUw5EAyc/rluqM1dq1?=
 =?us-ascii?Q?rt2VThhw6Pws+E4mk/MezeXVmGTmhSntAAhPM+Ph5wrmFJKNghHBpDTxLzRY?=
 =?us-ascii?Q?v0RI+uJwuFQLvaa8gqYt9FXucs0uM8zeOwabnSWGRERsbCyU4ceEKHOKvXhF?=
 =?us-ascii?Q?pxR8ZRAXmFg17ZLzWehSuklo5VwfXY0eKZVIF5RbSHiN2yY3SN66pHswLxm0?=
 =?us-ascii?Q?tyK+64s77HFr+AZASti0ZN0hBNJ/kulMVSqoXywa7uQ8k4VVkFuXgPwM8qkL?=
 =?us-ascii?Q?HAou0M6NM0V7njqi4MEakMoh0VFQvFOsuqkZMfRCRybRxytWvdAhy/G02Q1r?=
 =?us-ascii?Q?+DO5WcVmjsI61c7NAhQ5CIwfNZprRBUMYtwJP7k6VD5BaQpUbXylRrOi1nfH?=
 =?us-ascii?Q?W7WwT5aZgJLNa/ClMGF/YPwZPNYKMjp3kj5wpT7mby6jAPYBU/cjYP9RhV12?=
 =?us-ascii?Q?C9DW83rtlt+zNCaAGToufu+GJyKHLhFN/foYGo3XbOyUeaUMlGUiinQD4IoF?=
 =?us-ascii?Q?XUSO2RAYprSsCh8lV5Tq7U0be1pqOQ4Remy011Wpz/ckNl/l2Anzh11PgeCR?=
 =?us-ascii?Q?bf/lYx9f1q6zMG6OjRA2YXguht/sCsAFVfCIgciu3sSnfVdSmlmg7DLozXOo?=
 =?us-ascii?Q?621gMHcxcOkhXAyVVO3GSGhaa7GQQGABMskoA3ThBt+KdKirtrOU7LtyoE1e?=
 =?us-ascii?Q?WCZKJmr1ox+2YMmuP7msDdb1KMWixmbB1qUmYg=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a401ee80-3b2a-4663-cf1f-08db4f244cce
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2023 17:55:53.5514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB2567
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Hu Weiwen <sehuww@mail.scut.edu.cn>

We have name and fsid in the new device syntax.  It is confusing that
the kernel accept these info but do not take them into account when
connecting to the cluster.

Although the mount.ceph helper program will extract the name from device
spec and pass it as name options, these changes are still useful if we
don't have that program installed, or if we want to call `mount()'
directly.

Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
---
 fs/ceph/super.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 4e1f4031e888..74636b9383b8 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -267,6 +267,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	struct ceph_fsid fsid;
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
+	struct ceph_options *copts = pctx->copts;
 	char *fsid_start, *fs_name_start;
 
 	if (*dev_name_end != '=') {
@@ -285,6 +286,12 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 
 	if (ceph_parse_fsid(fsid_start, &fsid))
 		return invalfc(fc, "Invalid FSID");
+	if (!(copts->flags & CEPH_OPT_FSID)) {
+		copts->fsid = fsid;
+		copts->flags |= CEPH_OPT_FSID;
+	} else if (ceph_fsid_compare(&fsid, &copts->fsid)) {
+		return invalfc(fc, "Mismatching cluster FSID");
+	}
 
 	++fs_name_start; /* start of file system name */
 	len = dev_name_end - fs_name_start;
@@ -298,6 +305,16 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	}
 	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
 
+	len = fsid_start - dev_name - 1;
+	if (!copts->name) {
+		copts->name = kstrndup(dev_name, len, GFP_KERNEL);
+		if (!copts->name)
+			return -ENOMEM;
+	} else if (!strstrn_equals(copts->name, dev_name, len)) {
+		return invalfc(fc, "Mismatching cephx name");
+	}
+	dout("cephx name '%s'\n", copts->name);
+
 	fsopt->new_dev_syntax = true;
 	return 0;
 }
-- 
2.25.1

