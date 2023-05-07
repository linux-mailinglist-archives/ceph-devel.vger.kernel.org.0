Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887536F9AC2
	for <lists+ceph-devel@lfdr.de>; Sun,  7 May 2023 19:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjEGR4I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 7 May 2023 13:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjEGR4G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 7 May 2023 13:56:06 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2031.outbound.protection.outlook.com [40.92.98.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74392D50
        for <ceph-devel@vger.kernel.org>; Sun,  7 May 2023 10:56:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbqHueXb9DH/3kplGHCn0zS8Sren8SdC6m60olKWAEtgvsRvSDRNIA9o7Z/yVNYzK0PoKzSqDTmtOCDRSOFon/m0G401l38miULmxl8sBSENiC9Rk4OAxwVuHFfo7OeeiZuyPvrCvi9Ksef1YN5CRr9z2wgqShos2Y835KYGrroos4wYYuYQIRz2/BdyDBWwcvzvbEt89GQjEE4tB3dldyOHBx5JtttXQGgipXpwGwsZUNyZM0yPsU7czN7+sdei31aYkoKfVzaJJdC0MGi9q2ys50ufvYd22hm1glZq8IAT2DR/SSjdrft2ZIn70AXfTpWK4ooRqNiz46Z7I2hdjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SRDtaGdt2/6sK6FxdX5m8CKiWIGMeoS8voZ9oV98+4Y=;
 b=cLSeqEXfuz8u9gSGtLFQnKAs6jdFj25pbSpFd+BTBYTUoup7hW56tmfcDUhgIZBxsm8odZw5dyovyuAw0RhPkntLj37RQ9lmhe67KJrsIyKOK/l2fNeHS7NTqbpkcQrGkJYahrg+vnH7ccmatas3skxtzembG9OEygVqSOgVr/txJkiYjthSBt3auJnCB2+mydQ7JTZ5p6pQKUBxHM0LkOhlwEOEXVRgi83hl+PQneF0jJbBQlMcROtPmbHk1xR8P1YNceOlAq6l1XbobngPtkpBufWANTDKFFnboJHy5pN4jPE2tQ0ky+Wb57hS9D80VKqjwEpgluzdpL0c6LViHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRDtaGdt2/6sK6FxdX5m8CKiWIGMeoS8voZ9oV98+4Y=;
 b=kFlQIJEJt/z7bHl7gRG6ZLWumetPZw2mZPqv539TGKLsaEGR/6aAfFV583GBvvBFcVacsIjQf05JgZdyIR6HmnjfR+6Y+4f3yIssx6gxZ+ISvjGz6RtxDyMfh0XCpGOOnWejMPJ9j3gaR5ZsfVB37uW5wk4cVtJ+hQOWQ8DSEtsoVvLGY7PmYcLp90TyRSo/GvgNK1zbtxP4ix8mtzylTUqnHJPkHlQtJZXIaoDbTpvSsMyZWYJSb+NEMlnhQqYOUTaXdhjno8SEEfXOhlg7kXw1j/xNwQoe1mvvj6kkJ2ldRituODCCJgF32hINkEMzEx7NEWvCQ75xIw3k8mccsQ==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by OS3P286MB2567.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:1fa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Sun, 7 May
 2023 17:56:01 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.032; Sun, 7 May 2023
 17:56:01 +0000
From:   Hu Weiwen <huww98@outlook.com>
To:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH 3/3] libceph: reject mismatching name and fsid
Date:   Mon,  8 May 2023 01:55:03 +0800
Message-ID: <TYCP286MB2066D19A68A9176E289BB4FDC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [jSPRQhFXM6Ozvf5IyVDEVUjzzzOs80bP]
X-ClientProxiedBy: BY5PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::46) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <20230507175503.2271-3-huww98@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|OS3P286MB2567:EE_
X-MS-Office365-Filtering-Correlation-Id: 783528b9-459d-45d4-d749-08db4f24519c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E/natYHQCywiIz5yIxly+7xYgoSicy6tWELAZ2z99YgRcprDtiGyhoFxjnYT8HmiWAT7IQxkPMrA9RIKpYTZuG+hvZLwQdjdelppw05H5K+/rMWAbnAaL4JGeVfaL5xRqembs5UzG9u14u+JlJUg8QCJCsw65GHwQiTkEtb9j+HEAPtgyRQEVrnxgXa3OLLkiS4Q03NRQwoc56YFfzYk/ODGztcM6tdX++Flz8BJ/SIXt1xP3Sx2Bm2qZ6fzh1ErDurF4rTqSp0t9ERIEY4GHgv4paPGW2Cue8cos11D997WT3zlDanXncnV/lxZp67gQUBvDJmmYk5l9rw6VzE6hsBtszvDozNDoqL6BZKdrtj3I5CL6a6dqa+pdtGLTPP6uuVAb/D7vp6g0Ng8lfpm9m2Ci58m3GTGiP4uWrURNisostPzvslnYCr7TPbJ+xN3LNXssBPLHdeIztAWla+KH2utTmWiubpoRQT7hqeecg7I4p87w2B5oFOUozbPF1q6aAwlQHC4boKF3ak6boN47nu/HUzPSbHJnj9Z6NGsAjD8+DDc04RFpUJEok8EH/Mg
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N1bbq2cJm8TJ0QcUTnXaU22Exp3KWMjFy8rqSHGHgvaTdbGS7xgFPRZKOUJj?=
 =?us-ascii?Q?Bdl7KJp6lYf/xLfSBVX2Yw3hPSG8dkeph5Yk6/7QjOo7uASK4tvYWQv/m4iQ?=
 =?us-ascii?Q?x/ltwcZNH2nf5SepxP5u3BnslaPaH+xj+3QvxrL1CWvGgbgRxfYCC9d3FkGp?=
 =?us-ascii?Q?i544/S9L29dyXtKIL2V6Wcm/THxcT8F++YrnaKbzjPLBjvMb26raMzxIv7fK?=
 =?us-ascii?Q?x7YAuRpE8gba4JQUNAz4p8hdhNaSGEIqrj5DXCN4hbXtlkgVjHYReYMrJ1SJ?=
 =?us-ascii?Q?1q8GD4WajQmIGiJ20ETZ05pFb/7tC0kEkn6QCWIfkEDmRHAyTy8lNyOi0Y4s?=
 =?us-ascii?Q?HZBNQE7nRGzYyT3Mp83rnxKN/dogniPb+ws4W7ttbOSl7vyrFvh08nJpX+Uj?=
 =?us-ascii?Q?xlQDZmLV4X5u8PvfBc7gWisLoUBMUH+jJxllv9qSP3MScC3eGpGIiUXAUUJp?=
 =?us-ascii?Q?0bPs/6r6sCkJ/k9XWf6DRB59vZV0c+B74h2vN8o8xxS2yHKTP2L7qrgYmJsw?=
 =?us-ascii?Q?NM/8agetI+JswzsUCINUrthv9mwgo0EMR9wFhnZFSUCIg/ghYJq5SazYc2Ad?=
 =?us-ascii?Q?vpq1rDuo27dd6pA7EbhvUDUB3XEQYDMNdQSDZLBupmR5XrzwCh5I+2NUw5v/?=
 =?us-ascii?Q?bsAaj541LxZ7NtbV4wmExFJFrYxfKVmWkvKK/dA9sUP5Obv4PFSkdK0S6wfv?=
 =?us-ascii?Q?X1trogcv9pb7jTXZRFhL8r44n+Bt0Qi202LIuM6Z5D1rGD2OwQgzirSc5y1L?=
 =?us-ascii?Q?ufoUDwLufijzegFHoZdzxdF/NEb+dWpj8wrE5W7wcF8EgMAOMVy8LLwFuOgr?=
 =?us-ascii?Q?JUtEBmDYRNfrD7FO7FiquopK6YZPmGNuiRRBtUPyLA+fKGTnQtXpgZi2ONJc?=
 =?us-ascii?Q?pAoEs9b949DnRBFzDUZznCVyKodRtVHo7FmJsJxFCW8eBvfaMZu2trt/4l+j?=
 =?us-ascii?Q?Cxrz5F3s7bl3BIuKN7TYDLmxMZDIUWyqwGYlTOcV80CMPr2a61ZxMsjWeBIp?=
 =?us-ascii?Q?7IBnqJ5d+KzB8AVw2S90c+mFDV5GPp86vhClPBQEsPBHMEFVITcVjIjI4mjy?=
 =?us-ascii?Q?PjzZauMUDqLnyeCZxfpk8MOQs3y7UzyfdA+JTMBja/sEUO/+6kLtnaYDkOIX?=
 =?us-ascii?Q?KQjtefmGvpoltqEQeEIaLZBDXqUpjlMiv/shN9ko+tTKMGlkIK0MscWYimW0?=
 =?us-ascii?Q?T6pT4ox+v4amrBUkVuhAhix434l+wo+GKgbprQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783528b9-459d-45d4-d749-08db4f24519c
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2023 17:56:01.6165
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

These are present in the device spec of cephfs. So they should be
treated as immutable.  Also reject `mount()' calls where options and
device spec are inconsistent.

Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
---
 net/ceph/ceph_common.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 4c6441536d55..c59c5ccc23a8 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -440,17 +440,33 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		break;
 
 	case Opt_fsid:
-		err = ceph_parse_fsid(param->string, &opt->fsid);
+	{
+		struct ceph_fsid fsid;
+
+		err = ceph_parse_fsid(param->string, &fsid);
 		if (err) {
 			error_plog(&log, "Failed to parse fsid: %d", err);
 			return err;
 		}
-		opt->flags |= CEPH_OPT_FSID;
+
+		if (!(opt->flags & CEPH_OPT_FSID)) {
+			opt->fsid = fsid;
+			opt->flags |= CEPH_OPT_FSID;
+		} else if (ceph_fsid_compare(&opt->fsid, &fsid)) {
+			error_plog(&log, "fsid already set to %pU",
+				   &opt->fsid);
+			return -EINVAL;
+		}
 		break;
+	}
 	case Opt_name:
-		kfree(opt->name);
-		opt->name = param->string;
-		param->string = NULL;
+		if (!opt->name) {
+			opt->name = param->string;
+			param->string = NULL;
+		} else if (strcmp(opt->name, param->string)) {
+			error_plog(&log, "name already set to %s", opt->name);
+			return -EINVAL;
+		}
 		break;
 	case Opt_secret:
 		ceph_crypto_key_destroy(opt->key);
-- 
2.25.1

