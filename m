Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8ECF74339F
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Jun 2023 06:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjF3Edi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Jun 2023 00:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjF3Edg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 30 Jun 2023 00:33:36 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2035.outbound.protection.outlook.com [40.92.98.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD55F1991
        for <ceph-devel@vger.kernel.org>; Thu, 29 Jun 2023 21:33:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqvBnJqs87wm8LzrY2mCwZqQYST0RrGaZtfT5GRaE+VVh6PV1o9i4vKi3RP0I2v6LJER5cuRiLUi+GG5rrtO6BD4l+U14TsURVTdJpIn2CZ7sOhr686YkpDHECdLVYQ1DOGw+1bgkrarVlqdIIgQfoJ8V+Bwqh0hWO7SmgUTYJ3X+0gaOSkihd3RAqpFlbWwUZa4swlX3/3PXXUn7+Nzvb5uXiCsIvWfJGo85lLY9F70U9KHx1ZVfPGU79zHzjmHZdJUEk3k984fPmgb20KTJdrpNuQHqEJQhMywXDW+Sb3TMUhAjA1xv+KYDs4PXGzvwPNeMQmESZSGqTapyCy2FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1HRK8LULbCKN8V/de2Xj8SA8CDQeJt/EX5pIMo6RCGs=;
 b=e9IHgTPercFEhKxPrFBMoFXYh9liw6oqWMVGI2DotDrB2nQv/bGfuxHBwYnl6YWWBjPZWplVccAUCU3F03tPCeVnoMs+Xelplvf03kg3xqvhbB4I3A7VhCv3tD9OsZOldPbYayRzjZJx5LymN1J4m9AOOQnVdCpJHcDly+cnLuviZsxZAMQb6n8dSnMkZ9II11fTaeSu3X8LxxjdvST2kuxtXncWHKOfl8OhBzHkPS7KNFBUgDQq3Z0HP4IRyLJOAl4O7Fz3lN7mIr6fOEYHb44wCYvyTQSpUbobNmuLBhAf2oDj/EDaAb4fviENCRur8JkKOEvj7j15Vu+HU2NFNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HRK8LULbCKN8V/de2Xj8SA8CDQeJt/EX5pIMo6RCGs=;
 b=avjr7/GUznJWxpDiei8TFG3l2lyeVm42y5fTZGYHulmVNM1pm2gxCkOXT/Hl5M2v6GHYpjAHiGaG32FE0jvpaKSF9Z2xv3rS9O3j2t11L9pwIme2dGP8ghXLvCYoK/tvIRoU/Mn95u9tvYXRTVJ4NHJb9NUtdmltBHaqCnueFoNn+inlA9+5auYBcXYij1FjmwNc9ZOfN9YWvevCBv41Mh5jao5krtmSEn7iKYtJJ1EzsW/dvVLfVHCiYH2LTBIhBjR3z81n130bBnrOleoStbolAmQauPvMSN9xt9v2sMxW3g9sPSR4SsaTTKX3qSUSFpfGJECl6nkFZLG1hTLImQ==
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:180::6)
 by TYVP286MB3104.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Fri, 30 Jun
 2023 04:33:32 +0000
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387]) by OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387%7]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 04:33:32 +0000
From:   Hu Weiwen <huww98@outlook.com>
To:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Milind Changire <mchangir@redhat.com>,
        Hu Weiwen <huww98@outlook.com>
Subject: [PATCH v2 4/4] ceph: allow mds_namespace to appear multiple times
Date:   Fri, 30 Jun 2023 12:31:18 +0800
Message-ID: <OSZP286MB2061102C184A68C0CED86D83C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.37.0.windows.1
In-Reply-To: <OSZP286MB2061AF068B5B9462B1A8E461C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
References: <OSZP286MB2061AF068B5B9462B1A8E461C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [pAfvguyz4MJYm0DSq8WImqrJ6zbZmkXeIeJAozzvYCOexI5TA3Uoq4M5FZIufYeY]
X-ClientProxiedBy: TYCP286CA0018.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::9) To OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:180::6)
X-Microsoft-Original-Message-ID: <20230630043117.808-4-huww98@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZP286MB2061:EE_|TYVP286MB3104:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9900f0-dfd8-4df2-bd30-08db7923290c
X-MS-Exchange-SLBlob-MailProps: AZnQBsB9XmriMkceEMr8g80clrkPP2EpJyaAv0Smh8r89MNBty/8vPmbTk5mjjiDhN+SoyBvco/lB0n1Nwe5GEY71HqsSsFCIClObVNkxpCpY6ffwPBT9ugdwAa/RekY1/Fyh3HwX+XS0tEQlKDDOUfUe4XWzDvpT0JUhLCe6pjoZAdUtj27kmhOyiiNBvXV1W7I0R2poF8mdAjZTE5PynAYRK8TbWxTUPF0s8cSonlMVOZOGmtT593ZWA45PIQV0ykTHw/k3xafihmoticL0i3qPFpC9JOAA6yd75NS3yOPj+ZvQwWYqX70F1PobwKewvCTAzCWPiHhXr23BhA+JVl16+Vqly6nFj4txGh03YtzC+vHmtMbtPUwyrKm7U18VrrKimIL40LLq1hYK7JSpOxdslwlYiPBn73Zt/EoE2RpGsTFr/hDL+WGCOhSdnYiPtqvXlkM7LQKdRAstpy+3nl7UhcSbEyGo/oEaBS2DMut/ZyXyDnXCyB6IPkjZYnW6dkOekUQsxSrP9zioFp98OGpbRmtFLDWBi5QpSg7Ib8rzYY84e+Wclh171NEt2hQPUxJ74YMuazLQ/ENyhEwFCeh3XJE/lR0AEkCTj+0aJHincRYYHz3beBgBHt+QRTS6EvJFsgbXsndaShIGj7QwVwxIr7tF5K43R59PS1SIVZEluYvN3KXRJTXARYqqlGNGb/3gmwKd8MaElougzCrcXDQzW6quOYtXKhQcIguzco+K/Myj/rjKckfVI0YLHJj45Fkhz1Ibno=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hqCFXEz/eyvWDnI9aDFx9BO6yspaoJn6IIMMrNf1F4RPdeU5nfxN08G2a0+/YyyUe9vLRBtmRdHEbi/Kgo60VjvExX2hU+GsG+er+V1BAMT6hJT4zDjXntSK9Npn3h8t3/1KGL9E7NmgEJ4CJoOQrWcMcA9K2V1gAa/++c+mpiPBhq99j9L89xRsy82ouI43DTsewl7t5SIKQtTUVvuRZ0a9JyN5bDx4IHzfEBqXQZUPH2TBkNARLOjrCMi7hgEP8U4Z4CKn7NcpkSS7434+X9iUwl/OsqeEgoGYweq0SxhfDsoJGKoIp5PxLbLciSkl91/igMAu19CKM16fKVNsj6HP4lkZCUozpDHyF9Ku4DUME4s2+KKLN+cQ+znn0XrpuAcWXczqJTOGgaSkPxHVwMh9vMxlMUh+CvF0jsearwTVby9HahAT/uD1zUbscXiTUQKZ3801I7a1Bp2mQmrwupYVe9TqCq5SebDmv2W6WR/Hwx5/t/ztJEkfyEtnFhV6niVPr5JoTneex1F7G2HacCWbvnWOpEma6eUwGunz7+oOTV81dWIw5mJuLjViWL8V1mVeN5NdMJmug73OJ8Vx9VFm/ka5s1HhIKEwhpIa1T5faEQVHeiXWpeAzizr8rqu
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aBvtyzL626AbC4QbFjMnhuWEbm4AXd6x/co/MhJyIVgcPBD+V+O+Ugwia4h9?=
 =?us-ascii?Q?GkJuqlWraIRLdx97f15/+4p4v1Yb4+OKsFYFuZVThX5mgfmruqx+S8gtFk0a?=
 =?us-ascii?Q?YhXsVvi+KvuvFF0nBeP00K3cWl2Otd6nkI4XiV5tc10E1qq+6QaLUC6jjH1e?=
 =?us-ascii?Q?nvrsVlyMDAVn7CnvjFW/mL4rRy6KENL1TmWDQpYuUO6uBPK07PqmIwTf3FDB?=
 =?us-ascii?Q?2e/+SQYOjj/JtRFZ++77zsIB3YYjqpg+YZqu5tiHz8ruPD+lxweecKSMAlV5?=
 =?us-ascii?Q?x1tvGxG38qSSrXuylsVt4H/p/CfRbSdfwr3vF1vQt55FsAYlRQ4RyX/RV6ue?=
 =?us-ascii?Q?DCAJ9vsdpj9m04O+1wno2GORuefJ1EBeenQWMb/ieVCE1NvF4Mgzucs7o2sP?=
 =?us-ascii?Q?DYaFX7pPyVNePPcAEVMjdwuaC/rV0nJscaS3uv7JPVPz5UuuobnDbse+P8e5?=
 =?us-ascii?Q?9InCI/9PFvsQix4mtZvMSAQLv3A95uUh0WZoClO1z+A4qgcfMNbPGuN3el5Y?=
 =?us-ascii?Q?QWQjztwDVeqpHIlwCzIdoGXZrekvVPHgzBbUEM7iIRqiZHFKbrq6mVGJ6qEV?=
 =?us-ascii?Q?np61HSmpLmdncE1cgZ5byJ/6HbjnY3k/H8tqWVA5fC410GyPvvS48t1Ky6G+?=
 =?us-ascii?Q?o5SOKPqemcFb8hOZCUwOgSh69ysY5kedcbioHXakhnfNEuB8+6HZXLNWJ5GA?=
 =?us-ascii?Q?LxX51KfqVFpX88Z/cUJYDRV0uyxqJJdQWTY4M6oTrB4w0vDF6pbcbaT6lcse?=
 =?us-ascii?Q?zNl9bdQzqj++BU4h7IKVTK+JRbSCs/NEVUGUa1vDkfgmcEHk0qHuB913hXaj?=
 =?us-ascii?Q?08vQW1hynjgmFKHDEOqze6JYna0JL9jVYGM8qFIRIcgb2Wkb+Qd5gz+Zg6vM?=
 =?us-ascii?Q?HMT55kLmawursu+Vukytt3BnfwhIWjiVoZNp22eeZDzDClgLVx+PRlA+eqdO?=
 =?us-ascii?Q?jg66ahf6rK+D5Ei/0HU0T0TpPnDMN39NLb7nSthguSqh0BWbRfMGgLnxl637?=
 =?us-ascii?Q?ntu/lPCCtEhf+Sp6xVVX22M7KAJy+Rz9rdsJ4+JhqFbv01jjPap0t4M8z/e3?=
 =?us-ascii?Q?IRhfS49r9BCw4cxHkxknhjI+0Q/RLcU56TMjpkQ0pU4Ig8gmcS32b4QSud9S?=
 =?us-ascii?Q?tR9kcze/tw7vzjJ3HkA37Rsct3E+kGrJXEtP/yvfc4HhVanR+5KxlmNi57sK?=
 =?us-ascii?Q?vZLmFBhT09JDk/N6OZ6VQaZ/r/m/JXqDMPVjqZ8e7XOt27wRRazmG7zL7YNR?=
 =?us-ascii?Q?1T8CGE1UPk9+C7VI9kJBm3mYzrRsHaKi9E5cN4CMZw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9900f0-dfd8-4df2-bd30-08db7923290c
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 04:33:32.8653
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

To be consistent with other options.  It will still be rejected if its
final value is inconsistent with mount source.

Signed-off-by: Hu Weiwen <huww98@outlook.com>
---
 fs/ceph/super.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index e66867efd811..96aba62fdcba 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -423,12 +423,9 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		param->string = NULL;
 		break;
 	case Opt_mds_namespace:
-		if (!fsopt->mds_namespace) {
-			fsopt->mds_namespace = param->string;
-			param->string = NULL;
-		} else if (strcmp(fsopt->mds_namespace, param->string)) {
-			return invalfc(fc, "Mismatching mds_namespace");
-		}
+		kfree(fsopt->mds_namespace);
+		fsopt->mds_namespace = param->string;
+		param->string = NULL;
 		break;
 	case Opt_recover_session:
 		mode = result.uint_32;
-- 
2.25.1

