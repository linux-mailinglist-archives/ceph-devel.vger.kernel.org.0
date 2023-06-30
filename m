Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B72474339C
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Jun 2023 06:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjF3Ecz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Jun 2023 00:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjF3Ecx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 30 Jun 2023 00:32:53 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn20821.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::821])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3CA1BCC
        for <ceph-devel@vger.kernel.org>; Thu, 29 Jun 2023 21:32:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RN9H9sgGlbjE4TpbpD2lligPmeL6GX39Uy79mJntKLtVz58+coog45Y6CiIf21Ve4H8tyGCf7qxPYdLl23lclIXZ8ECjYB7p4xaTxf4UPkgJdzg3J1WVPahGqGUBSepVMeNy/pAvQSO+us3ZY2eHGexGbtPKWxmWeVK0uxsoPwduywMCmc5NmAfJdI+tmcgqH1pbCsK+Hwftu15vFDapKZtdmFL7AsQB1tbLCJfl8VYd1YV90Qz2izyLGAVC9dz+zBE5yWyucYACGgWzPLJ30vs8/8vb4owYqKP9ZRCklPk4vo8nzUnl4L/byJ32MxSnHVodpKA9a6MdgwNPrNQpBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ti76pspkndoDJEU86V0p3Rb9Qc9FKmes/YA3uPzysD4=;
 b=UjRpNIH/1++BOXBGlORSlugqpt5arxaPTzdpLCipf+1xfNpP0cgqabCu8WjqttTxdlexFsLVHlIpAYESiO9dAW7ZpyVMqf2RiJRLT422F7nf86WpMDZihWO8fMt4JXIX4v7mYQlPOBCgYs5dilpe13nlhVXcgWRral360NfKPihNb5d/TCD/+UcV8TWte0e85fXWKnQzvaV/cyHUm3mVMcyS9kyD7jTr4WwvcXfajbiuhhaQ8Boe1RPt6yZnxAGHUZdB9g3kFwht40BYEW6G6QNcsBMJ/YSWmX5yLkk+q0zsxcdYe6FX5L5SIr/ai659stxnf4mW7Unz3yPrDWdnmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ti76pspkndoDJEU86V0p3Rb9Qc9FKmes/YA3uPzysD4=;
 b=LJTDHl6ST9pzebgtxO6tqOnLT8Y40gPM+11Tk0loC7dlv6tOfQ7VKNlQCAGLqy/s40VzAk8Pw37tySNPqhHVtHwYQ12LtqBP0k/g+y3PSlbPOXFIqK8jPOmdNvG9t2qyw002CS0SjsplpEiYZDqhpuzjmwCHpeOlE2Ouklak9UeSRsPxrOgs9QFlePVACVzJjQWT3Dy2GsWOLj01bfpKfs/JxUD4OTs834ctRPidrqicgmY84kYQEx+5QG66eckmpk4dL3g+IxVVOnvk75URO7dxxvw1zqvMsgyqomEAFSi0cVdXNAF/HtyoxQpybpMg7/HLuyLKp/+SbJHbiTJSjw==
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:180::6)
 by TYVP286MB3104.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Fri, 30 Jun
 2023 04:32:44 +0000
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387]) by OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387%7]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 04:32:44 +0000
From:   Hu Weiwen <huww98@outlook.com>
To:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Milind Changire <mchangir@redhat.com>,
        Hu Weiwen <huww98@outlook.com>
Subject: [PATCH v2 2/4] ceph: save name and fsid in mount source
Date:   Fri, 30 Jun 2023 12:31:15 +0800
Message-ID: <OSZP286MB206153D62F11413F199948A8C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.37.0.windows.1
In-Reply-To: <OSZP286MB2061AF068B5B9462B1A8E461C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
References: <OSZP286MB2061AF068B5B9462B1A8E461C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [DbI5iPeJsbszmN2HH/q559/L9uesn6UvnCF05SVqOfWBJpeBEg264VgUDjA8AR2s]
X-ClientProxiedBy: TYCP286CA0018.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::9) To OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:180::6)
X-Microsoft-Original-Message-ID: <20230630043117.808-2-huww98@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZP286MB2061:EE_|TYVP286MB3104:EE_
X-MS-Office365-Filtering-Correlation-Id: a3b4daff-8c98-4457-800a-08db79230c12
X-MS-Exchange-SLBlob-MailProps: AZnQBsB9XmriMkceEMr8g80clrkPP2EpPRBdXDaE0qpjX3HoYn6s3vUnZwOFcG9Q/VHNNuGSj2bWRsyrhWJBDiTferCMauL3aN28MPDj4XuPpnlh4fJxMT7N1zvS7g2OQeq52zAS/KmpXSLeo4xMRVRsZo30V/3xyzE1aRff5h//3eYYYciC7PGzq+BwCGadk0JmsVLka/VTTGEMwl/Cub11MB9KchoBYafZ0PJazCqu/j+nzUVqHA4nsTDly6QGbwODHwpVGxWEYKLNcfpNAsQXxxqaV+xUmLv2Q5Ei925wyz9d7t2YZQ2y3tdIpcgSO2FJGKE0viugJsvYgS9bKNHI97iYsV9Zpz64DpsiOcP+q9BjvN3nh6Q1orZPVi+opQ3FrTqU00BzY3AdfuDDF5PRDQMSrPrWW4smPY/jO0ID2lles4jkiWYHs611RX/p8PQm1rjrPkypQzw3pxTT9mEOssakngZbf+qDTkPdF6CKIC8gudssZs1PGcj+nF7qi9xwnxaq7j4/yBE2OI3YjBKT9edKpvYrV3j6h8wDz+fay/CFZGpV99L1EWnGPOxlMhsQjLO9F5JMK00kO+UGiTdjZRW+ie+3rcHGJwOkrPQ2f8A1zFs8b3WqXaKMSoxN7Ab3eoSbb+VoF+I9UzEKNYOFJYCVFcfNa+uupsCkwJ69wwZIvWChQjUiYw7OpEUSpqu4ibAxBCN6rZhVwRWqPS+b+5KMgH+cwhZ732DYb2k/poZSffhjzlp7X1JeBXmWQt6Ml2w7Aps=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0btD7ug8tWahq+MRBmTTfE7gpElcmCpI9SDVMjjC2CVHp1KIBRhAAuEVSVicHNoQXpRSdSv+MUNahhCy3Zz0hEcARtk8vxJ3UIz0NPP1/SmG9wGzoBdYHYkViKL1OjswE2ElMr//Cg0cJwmXMvrF7a6EKt6a/NQehVOr0mBLA3m3kyw2Wr2sGsLu13q5157MoKucIDwZH8y62fltSYac/nnutIQe2nRnrZhq1BjKPnM6j/v5buKPNGMcatb2gz0NI07MZpNdBxUfUyXP0K3qXgdBtwvkSQeHCjJw5gYroRj+sWvsgAXNIm7RmYnia7UXSBvSsJyFJp6SlEt2EILg+z/f82R72NQUlwLxdRVg48UeplIOVon5ceLTTcLBtwESZYRtFi3htsxUEQFM2WJxuncR7VTS0Qdbdk2IZES1NpU4SBXalCdDUHtp+XncBlnq+ulhgZxxbzJUOb5ba80tIZkvGov3ppPQwxCTL+6vHu/wSvOjg8Kip1LmSDCzUwHSL8MEgVbLgu+n9h1xxKhx3lYryv6lnC8lUT/1zDEwYzqCvTjYFrTy+glHa5MZyozoEcjouxQO58ur/yWyAYbRJ6c42yUOvN1bunfbNjAmgKZjNXkaQswWgC1Exh0bzJI+
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jilzEnm1xI2vsxonMvAQke6UaleHgS4JpOfN0VeoLEYS5GA+fRCZks/XzyRt?=
 =?us-ascii?Q?qJsu8rnqKcIaJ0PHCyvCm4r5BS7nOHQNSNly35sFRoRxFuLK06VAlAvRsMB/?=
 =?us-ascii?Q?Ze9DAUFHRNEH7jxOZXv1iPNCaEwx8Jg6HHFG5E1+nrMNk+2AIDo9iFfZgYdh?=
 =?us-ascii?Q?1jhwEiOvbdtW3X+SqMJXmBRZIs9QJbyy1M0CxQrOl61R3J1XVVwB2i6mPnIY?=
 =?us-ascii?Q?HjZkBOAmqk4i5RMwc/3bmLBa1omvgGZG+WsiTKpyLVAFlL9f7PXP1x/GSnqD?=
 =?us-ascii?Q?+Bkxmy6C9ShiBJyDD7AUe/OBjfA8sT1AWNDCKToAiQNuepw5bNYsYR3DPNt1?=
 =?us-ascii?Q?jAzqPq9LdwFB590a/ezVK63OGZrQQf/44ryEHeYVZpP4POMzJdQQ0V8G3A+V?=
 =?us-ascii?Q?QV5lg4y4qZNEhqyRpGh8Es1ODjf3Bd45oaRJZGHgpa596/GZ+LVZKgQ5jAT4?=
 =?us-ascii?Q?78v2KbDAZhJXxG8zriHMxK/uJLuzhE0I92kJ/o5TXKbtsQy45uyH3f7IXJmc?=
 =?us-ascii?Q?9UEMDn8ZR1OqBE21TopEhXtowPhKQg+SFmwIhqhI5TZZ97SYnN6OgwY/cH/w?=
 =?us-ascii?Q?Vh0fqvHRGi7j2ZmRm0gmqVR2nWIcsusWsS4L4nrXPMRxySY7FE/PVMedKPvg?=
 =?us-ascii?Q?Gnzf4g480HVVV9prI+TRnIlch5jrXbLb0hsDZO611QOdzOluc5LgRa/3/m9E?=
 =?us-ascii?Q?qCDaNKw53TrwGF+TmvsBMu6op8NlFFybbCt0CCkHvVQABj8zR7frh1tAoMZS?=
 =?us-ascii?Q?NEeo82IsptxArcc4eE8FUbsvdrLC6++1QpTAv8eAqVOOn568SVdvJFQ0lATq?=
 =?us-ascii?Q?pirPAw+RKsEy81edHnein12YYoXHIXKGCATCQNPd173Rwsmyp+Ld4Fdtm7Dg?=
 =?us-ascii?Q?W+i1uGeRbz+EvJ/FlseUPFFxr30Hu1SaOrvJmzEIT5h8c0dy6yoUdenjR0va?=
 =?us-ascii?Q?LCIu9r6DrSz1uyFL1UO7lbNwXRKYQsktWQJojqCUB4dUMFQxquShe14WaiFn?=
 =?us-ascii?Q?nOdavj2ksGHQUvYMfyzMZqQYhguDbTgQjsgNKoonSRYbF19DrK2nY8KExgr3?=
 =?us-ascii?Q?2mTH3ZzWIuvFFOulSC0AoL3aAghHmtUizw2mefw4u2ZTD360978VVI1Qi+Dm?=
 =?us-ascii?Q?l6nV53rPcmJRrj49Od6yxdqK4o17Z6N0iN9mIWA86L95C2emoEg5EfMdNX+Y?=
 =?us-ascii?Q?x7My9MDlGm1sItUnZE/a+YXuzf8TM74Ln1X2R5Va+XEJu8cjx++qji9XIRcT?=
 =?us-ascii?Q?EPTZkLkWZQVcDg8E83BjMCZqOdnZtq1/psmuPN2mQQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b4daff-8c98-4457-800a-08db79230c12
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 04:32:44.3120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVP286MB3104
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We have name and fsid in the new device syntax.  It is confusing that
the kernel accept these info but do not take them into account when
connecting to the cluster.

Although the mount.ceph helper program will extract the name from device
spec and pass it as name options, these changes are still useful if we
don't have that program installed, or if we want to call `mount()'
directly.

Signed-off-by: Hu Weiwen <huww98@outlook.com>
---
 fs/ceph/super.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9185ff00bb61..3d36ee4543ed 100644
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
+		return invalfc(fc, "Mismatching cluster FSID between mount source and options");
+	}
 
 	++fs_name_start; /* start of file system name */
 	len = dev_name_end - fs_name_start;
@@ -294,10 +301,20 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 		if (!fsopt->mds_namespace)
 			return -ENOMEM;
 	} else if (!strstrn_equals(fsopt->mds_namespace, fs_name_start, len)) {
-		return invalfc(fc, "Mismatching mds_namespace");
+		return invalfc(fc, "Mismatching mds_namespace between mount source and options");
 	}
 	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
 
+	len = fsid_start - dev_name - 1;
+	if (!copts->name) {
+		copts->name = kstrndup(dev_name, len, GFP_KERNEL);
+		if (!copts->name)
+			return -ENOMEM;
+	} else if (!strstrn_equals(copts->name, dev_name, len)) {
+		return invalfc(fc, "Mismatching cephx name between mount source and options");
+	}
+	dout("cephx name '%s'\n", copts->name);
+
 	fsopt->new_dev_syntax = true;
 	return 0;
 }
-- 
2.25.1

