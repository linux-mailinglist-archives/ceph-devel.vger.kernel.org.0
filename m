Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201B874339A
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Jun 2023 06:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjF3EcT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Jun 2023 00:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjF3EcQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 30 Jun 2023 00:32:16 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2094.outbound.protection.outlook.com [40.92.99.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE451991
        for <ceph-devel@vger.kernel.org>; Thu, 29 Jun 2023 21:32:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATYlzzWBSkofK5ujq++6d0pn3MBxokLQG0bwUtXQtm50gKqqqrlGcn71zd/r4xX+7IKtC95wd9256rbN74SQOa1Gp8qlGMu/Uox38+EaELL8dda/3919GgQ+67DmbF7cIEQbxcPNTy0TLXzX3OQBAtBsPSQ/JJP282usG7RZOtZhdsC5NSIYPJ8lXD+0qRpRRB6kWtpJzjBnT8lTWaJstTRBmCgYsn+1CnwhRm9twfCEpSjbS94Q9H5h8ZZb28inGmnY6gwX3oE9RWqatDwn3lZUPhBjPBYDDG8MOBUHlAkJIwfXmOJcQ//Qj4V1Tkq23V1JiAaz4fNprOr0ndOu+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zz192BCbRWjAyVN7vgp6u7HW6mi9dh3hSsqJYGmrA9c=;
 b=bwhU4pimwa1GWLPuwXcqff8Mb6SjrV/gSSH6+apR/JZXZ9VdTItEWknx8PSfFaIRoarKeiS4YjY1gRtA1ZZwP4FRvdiPxoLWFtWG6c6Fj5EHb0mFk3RwL/59VWMrPTSS26N8gdCN/32dNxQE9SgO+HxQxFDBBi/ANqDLFwWWZtOXaFhJXV22OQ7IDhmzItndv/9O2qXqW3PUFa/Pcy6D/scEHKl4JnJOrn5FqOs6HXJ63RWdzHstbfnDz06peS4pPumQlqCJIvzab0jqwdwJ9raxLZtWhrNx3jnhSWpqKPfll+dg1BrdLIm094c8Bdnd0h1PPRTSBUUku1SVo3rqUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zz192BCbRWjAyVN7vgp6u7HW6mi9dh3hSsqJYGmrA9c=;
 b=P2OH4J3Nk1buNB84r7In60fsCLinGqi2RLisQ1k3XOkyj04swFYnu67Z7wYFtxRYvULrVU+EmwP47602VeKvimE741HiItyzGBuf+n2oZOf7RU3erLUun9jS9Y/mJVGfmDN9hqaH4rEHQD7jt0vVIyz0kO0/6eLqc3fryWubzZKQzCxWJpqJrDZ7gIMekoDDy9wqCjna6Tj5l+3A0tqPX6eKOYw49QPYLoAw5houRJ3xcRPiZ8HxcaYalDp1rML2PyaKCdPjmcCQ/uF2hO1OM04DvznN+zEar3v3TBZCXQEBhRI8RlsOpH55Wf9Uiq2qLQa9naBQ5LYB8OTWw5TgYg==
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:180::6)
 by TYVP286MB3104.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Fri, 30 Jun
 2023 04:32:06 +0000
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387]) by OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387%7]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 04:32:06 +0000
From:   Hu Weiwen <huww98@outlook.com>
To:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Milind Changire <mchangir@redhat.com>,
        Hu Weiwen <huww98@outlook.com>
Subject: [PATCH v2 1/4] ceph: refactor mds_namespace comparing
Date:   Fri, 30 Jun 2023 12:31:14 +0800
Message-ID: <OSZP286MB2061CF70BC0BEDC14015C8EBC02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.37.0.windows.1
In-Reply-To: <OSZP286MB2061AF068B5B9462B1A8E461C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
References: <OSZP286MB2061AF068B5B9462B1A8E461C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [aQiQDq3aCETGBbhXnpMcc9PsOjEhl6XXei33S5RlWMMHAA21c7qBfkC/4bzYJjAj]
X-ClientProxiedBy: TYCP286CA0018.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::9) To OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:180::6)
X-Microsoft-Original-Message-ID: <20230630043117.808-1-huww98@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZP286MB2061:EE_|TYVP286MB3104:EE_
X-MS-Office365-Filtering-Correlation-Id: 7be1de52-1fbd-4dc0-9bc5-08db7922f550
X-MS-Exchange-SLBlob-MailProps: znQPCv1HvwUykhYCLh9DY1CjAm5WozgfRwn+o4EQ56EuCLDwElT1aTkka6HxDeooC3ez6y8Hf/IyOpoMi5K9qeFOEwkJgPZ318vOcjdxTW/SBP6bbt6p+jxsXDIDUobyF6VhEia03Hd/PDolJqu2YVGC0tHe4howcfT/uLWaYe4f8rXyAn63hCa2jxHPoGJTpujF7nQ/IP2/rniAFGmv7Syeiplf7KA6HUN8mixXk8xppPK5QgK1kAayhh/m02Jv7iaz7HQdu1qqJszSCiALNaH/K/Mpl8LZuwyVwrlKg6RIJDOFO2BOqo3duyoADVVfpJvNOHGzECLhGeIdbQUUVIkFFc0yBobGXhW4LdybXFzQrDNil/I6a0b7uky5S+O504wlcTv7bQBaVRqk2AskTwIxOR2pUUouYpOOuLrTRyiVQdzvyu3ZQ3LHj/iBxwrBPEMs8PXR40jMUucYw7DSZeeJy2/QEv8V0enc0skI5hVdr9ruho5MqZmL5MRe5pF9rGu192izKcggwtMmeJKK9FRE2WP7fVDFiZQBCxggs7GkaIiTSDMm4kdMGZiUG6YSXHRK/PQo6TKd2AvhlX9EuFiX6Fq736hVJkD3pmMnuGBJTK8Y9JQnTKpjzHn9rFta+EtuCmB2kZ24Jfw5TnRS1erL7rpGuWlljq5t78rwMyXczqqKz2e2JoMi129ABzuXsaVQFBjG+yG5YYeLXw1qr/8YXfaLRXOufTzRgXZ+Q8au5LUtbTFo8WR+t/6L67ercm4i7mLgab8=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCviKBjym44KJNkfW5OIynYz1riS0+ABPpY5KnvpUvWcoypcVN1VrqMNdVRQg981zlFeGGev932nl7DlxVKXczHgOLCLeiVelIgcNRpJlJdAgx3cKp1xMELC2x2nWLpa7tEZrzZ6fTwvVfO9l9BPARw+mAfe5cDIN3hXZxA9K28TogyyPKFBT0Jyua7E3nMM6a2BzGbp7T05OlOn9mr8p45btZtBfsQtpCT+Zs96WFfLffvfmouOXhYbhcc7QBlsaI67gP3gxCC25nHNuLr7Jt7G1ZBc6yL0Qs0tCQaYeVBFNdt7TZUReVJVp3pdQ1C+lqBqFvMFRxWUuBgYTP/j4/7VKUcKw19JNtwySRYQVZB9DwWHlt+o9nUiPVNFVExyggHkpTaPItXOCURYStm7T9E0rSE59jBzsWu9i+U2tgpOttHaBiFrCclgODl/bGPiW4HlwNDryqI114v/NNxK8ng4sHoAJZ6RHOeuQsJdxbN6u0CPo6wcRXBKRDY70s8ulCLwwcp8qvhh/hfdnrqza/ZStYT/MnlWj5OIQ15JJhy2sslxO7IcQ2qG/qF5nfziI2Y88uROiQ6L369MWNrQzYbHqU2CUf26LyopYhkiNdSs6wiq0otawdmfxX7OklF8
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ql/FmeKRpevjwSglKf8tRGo5VXrlJCNX0YzY7W7sEGr4fihwqIq5gRQ4lfUv?=
 =?us-ascii?Q?xo4CHmL8ol7DQHe96vDKMePXY1gvvuS8fNaiAr/v/1pcmxXfzyTBi1wxDSk9?=
 =?us-ascii?Q?4QczLkROiCoTJWLpcw9LVK8zUihV7NmOP8eNnkFrPnoI4ZsuIymhyfQKm61J?=
 =?us-ascii?Q?Cgs+CgO44U6dMdcUE0Zch2IFtCJFQ9xxzU0LKxnYbZp0JRMWWobbqzB3spRh?=
 =?us-ascii?Q?giJKQTjwMnDHKIkxx2dDcnHPf8f0D02eHhiykoFPoLL8/pmsaR/Xo1ce/KUA?=
 =?us-ascii?Q?BPgW7Ho8d6md7T2jImWm99KexRu/VjSt5EGFQXBw2oUyZ6w1+oHgp694S8dh?=
 =?us-ascii?Q?VIsedRsd+5APDgTZTQKwvAaMy/C3QxViq/fZtjxTO3JtoeVJfON1NQBD5fKi?=
 =?us-ascii?Q?Ws82twaemFDpB/7q7Pi7zh4mwQeK2v8buyCGzeiNw98vXRjSsOA37xGsxW1s?=
 =?us-ascii?Q?XTT4UZBjbwUkxMqOFp0OJTkOCvv1sejhiVGZoXvvFh3Ox/x+h+w0reNZAu0v?=
 =?us-ascii?Q?rJEPDklOOReyDMFcb6GkdhFLO8SFPsLV4hA5NhYc5hKdGWLy3HQpiEWnSAoh?=
 =?us-ascii?Q?dN1HCOo28izSdr21TE1AZYk2xzLcilBa6m9FnXa4vcQRaoUzV5q/4YCbvOeT?=
 =?us-ascii?Q?Yq5m8kE6JuqGARnxws4OGtBo0WPBe328IH5I3gTh8sntM1IItnSeewD6AlIn?=
 =?us-ascii?Q?tfv78p7/r20OCa7dmwuZuD7lgOOKxTTcNQ2xAjNrp+oVrWJk8BB7O2jWlyVR?=
 =?us-ascii?Q?J4a2ug4A8K3nFb8Q5ZTqhcvpR1mmc2uxeA14HDP9A7a7/TzhUuOr8/0vjibf?=
 =?us-ascii?Q?wJ9bWvlBLPMVPgHk8JSgdkYTU1HhkrDg7wcwnN2JWopule+EflyjYptFqDUQ?=
 =?us-ascii?Q?UCcKnvns+Df5heyRjKh0dByIIhuoESdSC5i5l3ds6UqMwGlGNdKUun+2LjAl?=
 =?us-ascii?Q?xXsyasI+D7oW2k/fzjsN4mjqGu2r+pSCGF76Z52B+LqgfLDMSe//TDtGRG2q?=
 =?us-ascii?Q?jHDpEK+GrGHEhz977h5JlxswO8ginoRHzsBGXwHOwEFgxOQqgxvjOCBLhkPK?=
 =?us-ascii?Q?9Pwb+FZynrWCm3Ul8UmnrH9xIFcGkyUZ2FjwNZ6prJ6gtdtvMqU7QaIP0MP4?=
 =?us-ascii?Q?UR5ZRqBUevDZHRLDcRDkRPpzvidcJQY/dAkJJ5jV0BwBO+ohq41QPwx07b01?=
 =?us-ascii?Q?kIH5m5PfPm1Vd7V/uOW4moMmaqbFRanhWDaCT18dtgq5b8APwOId2Bf1aTfd?=
 =?us-ascii?Q?rL2s+knTIKjNQTa3wdif1iaIuLWZModP/B+OHBP6Sw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be1de52-1fbd-4dc0-9bc5-08db7922f550
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 04:32:06.1399
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

Same logic, slightly less code.  Make the following changes easier.

Signed-off-by: Hu Weiwen <huww98@outlook.com>
---
 fs/ceph/super.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 3fc48b43cab0..9185ff00bb61 100644
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
+	return !strncmp(s1, s2, len2) && s1[len2] == '\0';
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

