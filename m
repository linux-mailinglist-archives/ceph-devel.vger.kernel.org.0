Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD0B74339E
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Jun 2023 06:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjF3Edb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Jun 2023 00:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjF3Eda (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 30 Jun 2023 00:33:30 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2099.outbound.protection.outlook.com [40.92.98.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E3F1FC3
        for <ceph-devel@vger.kernel.org>; Thu, 29 Jun 2023 21:33:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpWkIE7CbdJmoNoRcDADbrApz9UO/AB7W1nJNiIxlv2w0Uvmiv8IIaDLLrZ/knUBn+JWV2sP1SyQkJnlyjYId41f7EQ2JYNZTGlw4oR/NzhL6bmEBD2EeY756harGLmwwE964ALug8Z/BtgopSTWpwRMtwVtTqapjhxc5xBaXyLze4p6RYkLkOnHQFckVADXLBaPgFQu2Xa4yArNEUd1APQDn9LeIr0CTkwOyPlsMX9ufuJG9Nfp6cAXetSLGRRsd1BZPLvYe5PGeEes4+rQtQOTuusaaN1F62skl8Y2qtJt4iU1qhV40ckoBlbA5R/ydJopVUsAEWZmHtr55p4jVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMsXIM9bVVm5GBeuG+4pWUUfWaKiaYyoRayiK4bNsxQ=;
 b=hG6/RsJa0ka7ZWpMvupgIkJwM2fzi3UBD7+R5NjIu028HSbQAZQi4TBJHTHWXRJKr78ROOhA3CDPMe2fMLzlesm9J8dQFOLtk+uLAGkWR9wPSnFEQilLOT0n/j9woikN4N56esDPoV3eAUGdlAXVnuQyfTE2oy0jYbFJ6eZoZt0nlOdanL8sKYqlO5NH6XN3ZrsekPGybW16eAWoI04dJCg1DSZ2H8Ez4ysZPRfmir6zY/P9pVlaxdmMJYn501PdDekakDYZM3NRDMdqUw5c+xta/K9tDBjvo4wE3e1FLQeN6LhSiDkJxS0mG7q1UuqAiyhHSIEx01OELu06cFCahA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMsXIM9bVVm5GBeuG+4pWUUfWaKiaYyoRayiK4bNsxQ=;
 b=rjGhCoaYANBLZDxxVBiZ+OzKYGHpM9NECW4O5cCup8gyWiFo4CHa5eSLr/7zZEHtT7SBSyIA4tr2x7pIZz/2plYQb/CS92WT4cezrxMCMAkc7TcQ5t4DzwbSOvc/eSc5GCg/2ldGUk4gwFlM5z+Q/YiHHi2TmzdEeHpEEqiBw8U1MPHfnaMXJA29iZvHKNc2HFnWEL7WiMOiDQ8By2V5YMHtDtaKPzTRK2UfEf8erEcKoLRCBoPlB8aUM9MIbKMwYAHK6GzjapAchBKVHAM4PC1KqDCDFse5vgw6MrpK310gV3x7GrAb/5BZpWC8xvhKTYYGa/pxxsYR1YCnVNzpPQ==
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:180::6)
 by TYVP286MB3104.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Fri, 30 Jun
 2023 04:33:25 +0000
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387]) by OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387%7]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 04:33:25 +0000
From:   Hu Weiwen <huww98@outlook.com>
To:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Milind Changire <mchangir@redhat.com>,
        Hu Weiwen <huww98@outlook.com>
Subject: [PATCH v2 3/4] ceph: delay parsing of source after all options
Date:   Fri, 30 Jun 2023 12:31:17 +0800
Message-ID: <OSZP286MB20611ACB739BBEAF3B26E851C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.37.0.windows.1
In-Reply-To: <OSZP286MB2061AF068B5B9462B1A8E461C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
References: <OSZP286MB2061AF068B5B9462B1A8E461C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [P9Y1PxySJninHQf5cxCDS0A6JcMs9LcEtsfGvjEKrrwh35RyW/vgLh9tS9D3g8Ub]
X-ClientProxiedBy: TYCP286CA0018.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::9) To OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:180::6)
X-Microsoft-Original-Message-ID: <20230630043117.808-3-huww98@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZP286MB2061:EE_|TYVP286MB3104:EE_
X-MS-Office365-Filtering-Correlation-Id: d7ff26cf-a1cd-4bf5-ebdc-08db79232496
X-MS-Exchange-SLBlob-MailProps: AZnQBsB9XmriMkceEMr8g80clrkPP2EpeK/4mJkdXPOfHrkRcGE0Ejs+d7n1lPbkWzeBH0W8QcUdqzNRZLjywtIHzRNlYeJ3pmDWsFfjR29A9EGi8oR+wQxWa7QLOy8Ldgl/wm3+0YXkQb1JN4Gnt4PY5Pn9e8BQ/Xjodz7XbLJXXC4vY96vmx0ToVjkuQmLUbrB4Gf7TneBbXHOahnZosmAMVJz7SceEFG2UoXe1a3FI/9NIj91A+mlncjBiVm8GnX4B/qaKvnzoMYEERJjB7Ac2zF5i6KFqzD0/VOI5CB+iMJXQoq92ztOTwwg6Zim4z+AOJ5raujhjNXP9tAs+RoltI7WbqzmbsasahPCzzn3R0b4w6rF20RImp7O+3x3cE8OlurLkLo7/3v5DsG3luaYFaxcmO3p7dzwG+MBEanQmtL50gTIIjM19LOkVALh+B3tMHI6OcxyaL8CU7TqYardRS4Y7eD00AKS8ZnMt2vw46MOcCOH8ois8a2N4fURSPsIQTnI4p72FJUD8BTVULTZB+YoLLHBK0vmxEX3b5q5/w37b4NWiSO04RSjk7bMxUhKZbCxT8IQ09IYOG8u+Se8yd1HUe/LDXGCUVG8+bvd+W6fQmEGXx6K213kdHYIxH4oKlla2ZfQgtdyJpEYwR5NcNbXaKVLnaUtjxTP9uDGQ7NMN6Gu4uk3hLboqyIYPc9QDxLxBsBY9V96Bhvvck/VsvT2BBtX7anLIfrkJJvtRutKJnPSwfSbe0j921YBwiYJwqCv8vM=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFPjiPbSqgJ4cR0mTVwYyQsYemvtj/LMNorIxspQeYj67jyusLpSvrIRNzmlh7tpUnWW658aLAYONmXQYdxEtO/dueHhgjkk64e5Ok6j1bhzVXQsl+0s+rh88TKQ10yr1GRlaJAASVqIjo+UNwPUymVGfWu1atYzFfRy6FHivv7E5ylORbL/E7JzuXJOVfQU/Bt18N0oG+VEjR/NYGvIotdBv/Kc7WxwfF3LAnqYCfgbY5YpXe2UCdADGco03RFisWbrLeP5dqc6ER76QigCuGrKpP2EfSyJMPja3I2H5ZJxp2rbk1pZ+/PDl5DFtLstifSDPD2+TB5GvtYXCUaLtTnbBF2qodMKXqrv9TAK+5eM5R5tajrN8xmy5TenRp1AHWsBa8LwszOhaDPJ4LoY7ryuiaEwFGLthjc2X9sn84lCljRhjt4oPonPXs1+E8oMk8QaMiofHzTWlgTRbiUBPD5g+slbs0fXfMWGHZmxFZMq/JqzcACA411b5uyrV+La8JKQHIYPt5YfQ0wb5dazqM8m5SVFF3wvignBYD4WPex4P6X6nL5RwVvo1Rs5L0n0GKGBclVbXRdBJFAKiDrYYYhGZfeeJdd6794BDkDTcwcm+gpNhnofrRvvDp3zzwV2
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s7LAQUmGmT7DXvGgUi7jxwkQAAJJlDV7blbR+VrOlKnBkBlI0fY6x4fniYKn?=
 =?us-ascii?Q?4bwySd4bgfukjJKhBna4ufO2d+T53N/B8XczUm+tI0ZwJ8pWAwaiHJ6nBp3v?=
 =?us-ascii?Q?i/Kvi9SS4syzXeYDqON0gpMG1JVlXX5D+1QspKz/eSKiOqaFh89xGYGAkxaW?=
 =?us-ascii?Q?9xBnXDsurxlB6EOUkPjkDKLTtto+JioJ4MeT+ffRS/dFXYZ4yyEooI1RTmAb?=
 =?us-ascii?Q?RbPeQV3smUxG4aZp6OK6O4PU0MV0fc4m5RY8UxJbIJs26N/TYugKQptupqkz?=
 =?us-ascii?Q?GKz/4PDxV8szgCqGEpkmjcFNAKmPQBagpkEEMaQy8ZffVcL0Iws/PIKekTXo?=
 =?us-ascii?Q?acwyS+gCopVA4fn0m8K4A5BxTdtw7TqAQycDq6HK9IshDaErbGwgLuZorBC8?=
 =?us-ascii?Q?x55vuNusRGAhNzCtyA6PM+w1GzegS/ZMtw3pHNisNJaunFjZc7MB+NaPF+xl?=
 =?us-ascii?Q?UzDg5T7UYjMxwU+0LFLcKGO2XQ+h04eNm0ts3KqYnyVhXmW2eRE6sIff7+Ws?=
 =?us-ascii?Q?rO7KwM4owK4JdCiDfvtZGDeAHDO8j8bShvpzL124mh/jdUBWm0Th9J7pc+DA?=
 =?us-ascii?Q?pdKBM7xfuDUs9R9NnGy9pcg9qSe8ePB3+xpUUVDcL9no8e5lLL+Xj+5HpYJw?=
 =?us-ascii?Q?OW8hgz4PNX3MrcS4HLsBBUzPyqfKlWeZB3ZGcF8iIn+mXDilpWp2aaPxUdWa?=
 =?us-ascii?Q?x1CYMozIsYYo171Yk2j9itAEICfjQn4BH7eQA3tEZZCrwzWAxfW8fBC409Ct?=
 =?us-ascii?Q?3IiraV4FurRFGQPK/FKJXx3dXr/AOF05fsmUgB0vjqwme7H/SY4a/jogoR0z?=
 =?us-ascii?Q?qos7EW/HLtZuCbOFzL73/UOSKqA4AxqtrI4C2Jxh+kn/5OvbRNZoMYH8ReO5?=
 =?us-ascii?Q?CgGvBUeEy2uK/J5D38+fU9zcQQfwUWBnhi+mIYrmsox5SSMlfLw56Q6Lyt7z?=
 =?us-ascii?Q?55dK6SLUR/r//KLO1hNHDheF2ilAVshpvAOyunAj3GE/iq7NCrgVJh2Akyv1?=
 =?us-ascii?Q?VYLKt6qf+X773oCiaJiR2r8igsmB1lVXKe3O52Th/ZY8U3oEdmxR8oyBQRy/?=
 =?us-ascii?Q?8u4JsImbXIazJD/455BtOzPzSvk8QRU5AHXfGH2MNYkJj1x5Oa1tMCDjGIAj?=
 =?us-ascii?Q?jYMey32lo2nyU53iBBkFe3uSehgp1OxR7pV6cSCSTpfU+1kgi+Eq/DBSRDf1?=
 =?us-ascii?Q?P5zOeDaugbkv6KPZN1kngvK2LXf8D3TJzW9J2vGHWnaYrUMWavnXYJsuOUst?=
 =?us-ascii?Q?jZmct/uqp9vFvenXGQgI1ZiZdmpFISZhqFq0wc6dlg=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ff26cf-a1cd-4bf5-ebdc-08db79232496
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 04:33:25.3463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVP286MB3104
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

Ensure the name, fsid, and mds_namespace in source are consistent with
these in options.

Signed-off-by: Hu Weiwen <huww98@outlook.com>
---
 fs/ceph/super.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 3d36ee4543ed..e66867efd811 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -149,7 +149,6 @@ enum {
 	Opt_snapdirname,
 	Opt_mds_namespace,
 	Opt_recover_session,
-	Opt_source,
 	Opt_mon_addr,
 	/* string args above */
 	Opt_dirstat,
@@ -202,7 +201,6 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_flag_no ("require_active_mds",		Opt_require_active_mds),
 	fsparam_u32	("rsize",			Opt_rsize),
 	fsparam_string	("snapdirname",			Opt_snapdirname),
-	fsparam_string	("source",			Opt_source),
 	fsparam_string	("mon_addr",			Opt_mon_addr),
 	fsparam_u32	("wsize",			Opt_wsize),
 	fsparam_flag_no	("wsync",			Opt_wsync),
@@ -337,11 +335,11 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
  *     <server_spec> is <ip>[:<port>]
  *     <path> is optional, but if present must begin with '/'
  */
-static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
+static int ceph_parse_source(struct fs_context *fc)
 {
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
-	char *dev_name = param->string, *dev_name_end;
+	const char *dev_name = fc->source, *dev_name_end;
 	int ret;
 
 	dout("%s '%s'\n", __func__, dev_name);
@@ -383,8 +381,6 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 			return ret;
 	}
 
-	fc->source = param->string;
-	param->string = NULL;
 	return 0;
 }
 
@@ -443,10 +439,6 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		else
 			BUG();
 		break;
-	case Opt_source:
-		if (fc->source)
-			return invalfc(fc, "Multiple sources specified");
-		return ceph_parse_source(param, fc);
 	case Opt_mon_addr:
 		return ceph_parse_mon_addr(param, fc);
 	case Opt_wsize:
@@ -1220,6 +1212,10 @@ static int ceph_get_tree(struct fs_context *fc)
 
 	if (!fc->source)
 		return invalfc(fc, "No source");
+	err = ceph_parse_source(fc);
+	if (err < 0)
+		return err;
+
 	if (fsopt->new_dev_syntax && !fsopt->mon_addr)
 		return invalfc(fc, "No monitor address");
 
@@ -1301,6 +1297,12 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
 	struct ceph_fs_client *fsc = ceph_sb_to_client(fc->root->d_sb);
+	int err;
+
+	/* validate source and options are still consistent */
+	err = ceph_parse_source(fc);
+	if (err < 0)
+		return err;
 
 	if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
 		ceph_set_mount_opt(fsc, ASYNC_DIROPS);
-- 
2.25.1

