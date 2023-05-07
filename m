Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA016F9AC0
	for <lists+ceph-devel@lfdr.de>; Sun,  7 May 2023 19:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjEGRzq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 7 May 2023 13:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjEGRzp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 7 May 2023 13:55:45 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2079.outbound.protection.outlook.com [40.92.98.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AF32724
        for <ceph-devel@vger.kernel.org>; Sun,  7 May 2023 10:55:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4dtIRlhgXaOHMXeDmjCzNDNCx26eS+mZNKjM6UPQvz5/NnnDmFaJD241dvFj0bwxnAj3hWv8a7tpJMvpiuZn9H/rkpPpjL5zzqj9nJ874a+MB2fU2HCEvYyLas+hTohcymP5xurSWLy3SPjnRHUUS09elWwcievquCich8BtRMViI+YV7GYuV/aovGSsDfzx5yxNpa1oZpwDMoleAcu+L23g/t32jJTvf4zDa7r2dlKUU+DpSeuHaGyYmj51eyVgo+8K0tnoKbexBvszoAsGcUEulMk9/ro/92kug0NjRkBT7+8oczwNJhI2QwHvHk72wn5rre65nNkke2IAJn3Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wcnDqUQNlL9ErpFI02tqLpa8uPA4XEgOkocBF/y4A4=;
 b=gWNwkaY3Z05yp4c5MDU9ppuKpK8L4MEeJoRAs/cNLQpHJRMXYRnEgHES4giSOTn7vjJsKwBe6AxRet+3tnxD1psP/FhO6IC68nBIe6oiu5U0FJCLvjuZSNf+FuiKqPqPktW0jawqMTiixvnyeagOfhZMPAcbRx5qnRVLutpd549zfEs3rHpxKv+FCyEQzZVm9V0/7LkWGrZGeycSBtASi0mEk7+Ref7PeVvof2XYH52b9e7lkUiDYJVYeDWAI/u8F80BylOn4t8OLV+Kal/km6t2tIJ3GeJCyCVFmK0B0s7e7kE5C8nlCqWxivZruZNe7kxpyw0fiQ9rmkexIvjwig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wcnDqUQNlL9ErpFI02tqLpa8uPA4XEgOkocBF/y4A4=;
 b=gdFdgQhWbwZvQorYQIRckyTZPsuUgtBiJpZ3e1Ip+2GGUaCirwVGyd5G6piWiTs7U7+voYVCqs7NxyR05/I74zM8G4DzBbFByz98cHkDbhxFGWVSMd9zyWQgq/fboRVwUnmxubB2VNuX4dv8KZuo9QkeTMXfdWlunxj/rJwpqI0g4AGgHm4hWm+RHsQkZPsscYTBhwSfT1LJDKnRZNFbn6PkrnCjCvyx0pTfN0qF7coeQGU486UhbdW76oeni08gN/tiNioSe1HjdpBp9pMjYlrCDO6qySGogW+tcdz5TvMl8dPh1SNkedxixP5dgmmwDjr/A8PI7U5EGGBCBz3Ecg==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by OS3P286MB2567.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:1fa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Sun, 7 May
 2023 17:55:40 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.032; Sun, 7 May 2023
 17:55:40 +0000
From:   Hu Weiwen <huww98@outlook.com>
To:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH 1/3] ceph: refactor mds_namespace comparing
Date:   Mon,  8 May 2023 01:55:01 +0800
Message-ID: <TYCP286MB2066C89FCBD9FB30AFDF2D70C0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [JhdFp3A4Ic87ldqm/7nU1a6frjcXngtC]
X-ClientProxiedBy: BY5PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::46) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <20230507175503.2271-1-huww98@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|OS3P286MB2567:EE_
X-MS-Office365-Filtering-Correlation-Id: 8beab207-b3be-4dc7-4aed-08db4f244514
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5IrkVdKPZCsZRWgxcDKeExkGGL4SKUmYqsXOmAjkJSEvqC0tiVpdCaaTfD0EIorHqQ+lyZkH6w+CehSFEjTfyG3d6eVc0wqZDvDUy+pmcBgj/92G1bFTXAzJqm7/GAwNEutI0zdUOEBNaEIdPHrnHgp7cJ4vx7JfILxVUZpcViQQxfFbauB8zpP2iHWX5tCgF0wY5afibTGcVcUMUakXhgP7RLscpMqAQlqYRUk50dFpFk3CMZJpOmuLjiuXd80MtXhtNw6Nfr6zBONyccFnksZCIQzWdlcjBY059Mb1bW2Gq3ZNK7SRky2GH09RvaKJQZBFOzyPuAtIYFb9gxB0vzMOmLEpTI0tuePhFCgNU8OHv062YDDZ3o3OqfzfZCusko1aWmP9OqeBLvk4k31wLQMItDq1+5KvMZ7cB0TLHjOH4A+yt7GF41eCY6NN9KPquCZ+ueYdm2GMZr0WOy6pg1rb+OxgBbpr7evSvKxtaGmslp9GIlLJg2DjLIocFyA6fZ1SxMlCbBgUjcj34nUEaYsHHQWPNxkXkrw9pZGWTyQ84QuePwlK5TDL31H54AO
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ePvvDzc+DUQGg8rfgAYSuEQ5EzvfKtnzr+JLzzWZ1dxqqQClkWil4sKqPVTr?=
 =?us-ascii?Q?V+/MhTmUA6THezUPPj0MraxO4BXI3C4mADgd27FI3v60Blku7MPoipTyPWdn?=
 =?us-ascii?Q?IjtvbECXpbopkzQB3vY3LYrh+iVAkQaEmdom38WB34WMEB+I8/B2JewgIzAV?=
 =?us-ascii?Q?cn1m7YoaxeF7KSQ9Mzn9MNLh2eQU7gnkFj+6DFlLPquI4Ha2rIChC/OKmR1t?=
 =?us-ascii?Q?SQh8vxrX6YRdSw5jE7mZB7wKtCr056cO62xy4qabcATVQyyvAZAr8vQs17ov?=
 =?us-ascii?Q?iiA3wX2BizUxRFq57bNXC8njrKduUMjOJ3/PRsmVlK4q+FbDRVApkxUcVmXN?=
 =?us-ascii?Q?DAAQqmCwXPbP8pOEWYNYKfMO3/yAZXcvPVNHyv6p9EIHWybSmxfRotf44zMP?=
 =?us-ascii?Q?/A6Ml8zOThqTm9b71qxQ9HgTN0ZndC15jPz4/nunXAVgesrQm4Vs9NF52pLv?=
 =?us-ascii?Q?XmMomUd3+aTpcw5PyAOPt1zy1gSi875vqUUA83bsI0qBthah+acAhoDHMP1D?=
 =?us-ascii?Q?8CELQ97W6KNOTsFdsAaQ0AxDQwCv35s0P0OeGw/XurR8nPov/75awcIom83x?=
 =?us-ascii?Q?xVSiYHr7V94CeRf8xFKbR0Py/aBjkbF66uoiUzskV9Lg63ILTYegywV7/4oT?=
 =?us-ascii?Q?/ZdF7TMLbWsdmbHSodD5Y8shdy4UajPDR9G0sBhxIdnZj/TD+k85HztDhuPf?=
 =?us-ascii?Q?X5OPaK/96lbC32qkDymUWwaQTOyZXFreT9/MYKhDlpYVN1U4JrnJDfue7KEN?=
 =?us-ascii?Q?KlVgSifGQUY5jOtN+WfnYTXEDS2Qb3AvxPa3rn6La43yT7+KNRFVWQhuhLeK?=
 =?us-ascii?Q?G7KgwUo+a5gktS1zgj3shGbBhfJw7M8GT0xlaWq19O5LYltLJgENYQAYcE3k?=
 =?us-ascii?Q?kHkwSxxEHVV6mqOw8HbwCqQZnEVhUEAeocKHjgOEzmTZAVIfcdIAH0kGJkEM?=
 =?us-ascii?Q?m8he4Aj8lrpH7AaIvQbfAhVmSrlutGx8iOMG80r7Q3uvZyQdR+sF07oC2pl9?=
 =?us-ascii?Q?ONq+lFeEY5a+Nd35HhZsBAISLSbNU1FaXxdu6EA2JUAhqHBSxkK+tnFhGHCQ?=
 =?us-ascii?Q?m2bJh83tgEqILm+MpUDJwe849JCIBt00h3k8hm8x+Twm+9+6vGlFSJfvLAkn?=
 =?us-ascii?Q?bOewhXRVEjVIzE+ikVVZEnwd0GxOzNtz2CaQcmtN3fWeTq2jU23RVMZ1x1oS?=
 =?us-ascii?Q?NW2XNmmEDcVibQaUed9Uf/VLAmS2vWQRDYUHXw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8beab207-b3be-4dc7-4aed-08db4f244514
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2023 17:55:40.7076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB2567
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Hu Weiwen <sehuww@mail.scut.edu.cn>

Same logic, slightly less code.  Make the following changes easier.

Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
---
 fs/ceph/super.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 3fc48b43cab0..4e1f4031e888 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -235,18 +235,10 @@ static void canonicalize_path(char *path)
 	path[j] = '\0';
 }
 
-/*
- * Check if the mds namespace in ceph_mount_options matches
- * the passed in namespace string. First time match (when
- * ->mds_namespace is NULL) is treated specially, since
- * ->mds_namespace needs to be initialized by the caller.
- */
-static int namespace_equals(struct ceph_mount_options *fsopt,
-			    const char *namespace, size_t len)
+/* check if s1 (null terminated) equals to s2 (with length len2) */
+static int strstrn_equals(const char *s1, const char *s2, size_t len2)
 {
-	return !(fsopt->mds_namespace &&
-		 (strlen(fsopt->mds_namespace) != len ||
-		  strncmp(fsopt->mds_namespace, namespace, len)));
+	return !strncmp(s1, s2, len2) && strlen(s1) == len2;
 }
 
 static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
@@ -297,12 +289,13 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	++fs_name_start; /* start of file system name */
 	len = dev_name_end - fs_name_start;
 
-	if (!namespace_equals(fsopt, fs_name_start, len))
+	if (!fsopt->mds_namespace) {
+		fsopt->mds_namespace = kstrndup(fs_name_start, len, GFP_KERNEL);
+		if (!fsopt->mds_namespace)
+			return -ENOMEM;
+	} else if (!strstrn_equals(fsopt->mds_namespace, fs_name_start, len)) {
 		return invalfc(fc, "Mismatching mds_namespace");
-	kfree(fsopt->mds_namespace);
-	fsopt->mds_namespace = kstrndup(fs_name_start, len, GFP_KERNEL);
-	if (!fsopt->mds_namespace)
-		return -ENOMEM;
+	}
 	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
 
 	fsopt->new_dev_syntax = true;
@@ -417,11 +410,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		param->string = NULL;
 		break;
 	case Opt_mds_namespace:
-		if (!namespace_equals(fsopt, param->string, strlen(param->string)))
+		if (!fsopt->mds_namespace) {
+			fsopt->mds_namespace = param->string;
+			param->string = NULL;
+		} else if (strcmp(fsopt->mds_namespace, param->string)) {
 			return invalfc(fc, "Mismatching mds_namespace");
-		kfree(fsopt->mds_namespace);
-		fsopt->mds_namespace = param->string;
-		param->string = NULL;
+		}
 		break;
 	case Opt_recover_session:
 		mode = result.uint_32;
-- 
2.25.1

