Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74B41953BA
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Mar 2020 10:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgC0JUL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 Mar 2020 05:20:11 -0400
Received: from mail-eopbgr1300084.outbound.protection.outlook.com ([40.107.130.84]:63273
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbgC0JUL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 27 Mar 2020 05:20:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eP0wRE2qoI9ZW4dyummDtMSh/AgGm1kZ+SKmXFOrZ5K913Bb4gFmDBbhdukw5iz4u2i/fUKEe4VRWc0rRZSYkgkRvBQzljX6vbnlKdFuMiGQFB5mJMqE6bwiAQ0+YzdNAnetBTuCFk76fSQNuZ/plHwH+z9E5pxdE75/gFMwJh0VREiG9qP6C1Jni1jZtC9BTD/eiMKe5U6eXCqnz+wTtaYpe1hv39Q0sZSLRrpikIYg9FNboqX4kESYzbXae7F9O0NKiNJSvkpT/juPOxiXxT0fPpw6BMnm7WMNPeTU6xzJ+L8SU0yzH0ZWhmeq27IBGPn2Q/z8839s2dQWyL2Y+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ors8Y6esGbrtbsRquYSvz+tU/XN4lHc2ms16inOSiuA=;
 b=S22lFIUCJXl1cwXdXOljy0hI18fxppYLBWctqg2sTup8GNTeEiBovjoSe0SOZykJYwjSwefFEXtYMvYGF0axl3OElQbr3oWl7DOyi87Vze6jA0BvS+mH3XO4FcjHlFcgusjevECl8ckRDtnu1b3DeRfz8q2dwNigQY2C+HCsS5kajnVymUg6V4z4FiOSW2MYUn3CEZ5O9kfy3mZ1JSVG9IG9OQk4eR6umlosf99BNnqJMa/Ka6CffHWrbRjDVQEMr9b5+XhkyRmWG8iVjr1T+oDbaQOT8eEGekWoXcxZr5FNUR/RVqcroYGilBHzFH05ix+pGepciVx1legLgmKsqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oppoglobal.onmicrosoft.com; s=selector1-oppoglobal-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ors8Y6esGbrtbsRquYSvz+tU/XN4lHc2ms16inOSiuA=;
 b=UUtMhka0PfTnoJ1HlUEqWVEQ3C/+OtSA4DYd7h0jDUAmDKEOV9O6nflAkVmHGmg16hlzx4JSl3jGaShMzvqNt0bfTXLPmdTXZGX9T74HSQUSWHOQfJXvXauxO3h8uhDvikgWR0xQLVDJWnhhZWwGUDEWNDBbpLD/+Tw7MVMSiOc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=chenanqing@oppo.com; 
Received: from HK0PR02MB2563.apcprd02.prod.outlook.com (52.133.210.11) by
 HK0PR02MB3393.apcprd02.prod.outlook.com (20.177.69.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Fri, 27 Mar 2020 09:20:06 +0000
Received: from HK0PR02MB2563.apcprd02.prod.outlook.com
 ([fe80::4078:fbe4:9043:d61e]) by HK0PR02MB2563.apcprd02.prod.outlook.com
 ([fe80::4078:fbe4:9043:d61e%2]) with mapi id 15.20.2835.023; Fri, 27 Mar 2020
 09:20:06 +0000
Date:   Fri, 27 Mar 2020 05:20:03 -0400
From:   chenanqing@oppo.com
To:     chenanqing@oppo.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        ceph-devel@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, cleech@redhat.com, lduncan@suse.com
Message-ID: <5e7dc543.vYG3wru8B/me1sOV%chenanqing@oppo.com>
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: HKAPR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:203:d0::18) To HK0PR02MB2563.apcprd02.prod.outlook.com
 (2603:1096:203:25::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from master (58.252.5.69) by HKAPR04CA0008.apcprd04.prod.outlook.com (2603:1096:203:d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Fri, 27 Mar 2020 09:20:04 +0000
X-Originating-IP: [58.252.5.69]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8238515b-22cf-4369-6d93-08d7d23009bf
X-MS-TrafficTypeDiagnostic: HK0PR02MB3393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR02MB3393BC7C71EBBE23EF7BFBA2ABCC0@HK0PR02MB3393.apcprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR02MB2563.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(346002)(376002)(39860400002)(366004)(136003)(316002)(5660300002)(186003)(26005)(16526019)(36756003)(9686003)(956004)(2616005)(86362001)(81166006)(81156014)(8936002)(2906002)(66946007)(478600001)(52116002)(6496006)(66556008)(6486002)(66476007)(1670200006)(25626001)(11606004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oppo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMe2c6UfTB6phpnbQ3JBdCCUhWeaejQVrHFl9SPfn2IIFR/ay6vW3Pz3sOFYAV2NAWPV2XasaQuqiGgmqnFH2hsPDUZkOessiFs7VVLVKjm/j0BgeZ/qZHm9uh+F36bRR43RTF2k4TF7Wt7uvKhO8Eobb4NrVE2rkGG6OPiHoor5kSOVUVc5BPASx1bxtPutUod+jazRLlKFEmmGHMEEEuo5qyXeugDRaLM0R4X6AX8AM+onXyhgwoaIYdlSZqPXqOdEu1nEI7zWuNcfZ8nJqCIo+rsDp10gw7aYtIWI0zdZt+BC7+B8izLdhBCkZt/PSpcyDYpIgFZ7ZgeoiEZwLqMsYACgMw1Lha2aND+8dmqJc54Nk2bzAGL7xcsRaCwpw1AU9TOSoE/1XbZ7+mAPbeVMZ+y1Y//wN+Vov0ZG9286zwWHJ6UapdG7zGlZTEDxvQx/XiEADOrubhm/qoZ0rXHClXIq08K0h0yDbylju6iJ8wP2UyCxnDNKY5GWBSXD6zCo+2s7OtOWbk+6wR03mognibp3kOWaIwQAP/FXdhc=
X-MS-Exchange-AntiSpam-MessageData: ezZ4vsxAPhSF0cK+F+Ihb50vVFCS9gPP9BQW/glPhuDoJVkxb9BuIQxDjzA4kktr+8qez4Zgvz52dUAbU2DdhEVIPQLXYM824FTPB5rT/Eud2Z93Wjtvzx8kdfaRY1Tu6bauNVYFJ8nYP29iaPLcgA==
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8238515b-22cf-4369-6d93-08d7d23009bf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 09:20:06.2246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7alaUVwRQ5dAsv6piV9e3YPbOWkiNef2/K48MpfvYcjGEisMlRx3JwEVeGCYILURiKz55kzrq9ySCCER8egx6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR02MB3393
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Chen Anqing <chenanqing@oppo.com>
To: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        ceph-devel@vger.kernel.org,
        open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        chenanqing@oppo.com
Subject: [PATCH] scsi: libiscsi: we should take compound page into account =
also
Date: Fri, 27 Mar 2020 05:20:01 -0400
Message-Id: <20200327092001.56879-1-chenanqing@oppo.com>
X-Mailer: git-send-email 2.18.2

the patch is occur at a real crash,which slab is
come from a compound page,so we need take the compound page
into account also.
fixed commit 08b11eaccfcf ("scsi: libiscsi: fall back to
sendmsg for slab pages").

Signed-off-by: Chen Anqing <chenanqing@oppo.com>
---
 drivers/scsi/libiscsi_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 6ef93c7af954..98304e5e1f6f 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -128,7 +128,8 @@ static void iscsi_tcp_segment_map(struct iscsi_segment =
*segment, int recv)
         * coalescing neighboring slab objects into a single frag which
         * triggers one of hardened usercopy checks.
         */
-       if (!recv && page_count(sg_page(sg)) >=3D 1 && !PageSlab(sg_page(sg=
)))
+       if (!recv && page_count(sg_page(sg)) >=3D 1 &&
+           !PageSlab(compound_head(sg_page(sg))))
                return;

        if (recv) {
--
2.18.2

________________________________
OPPO

=E6=9C=AC=E7=94=B5=E5=AD=90=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=
=BB=B6=E5=90=AB=E6=9C=89OPPO=E5=85=AC=E5=8F=B8=E7=9A=84=E4=BF=9D=E5=AF=86=
=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E9=99=90=E4=BA=8E=E9=82=AE=E4=BB=B6=E6=
=8C=87=E6=98=8E=E7=9A=84=E6=94=B6=E4=BB=B6=E4=BA=BA=E4=BD=BF=E7=94=A8=EF=BC=
=88=E5=8C=85=E5=90=AB=E4=B8=AA=E4=BA=BA=E5=8F=8A=E7=BE=A4=E7=BB=84=EF=BC=89=
=E3=80=82=E7=A6=81=E6=AD=A2=E4=BB=BB=E4=BD=95=E4=BA=BA=E5=9C=A8=E6=9C=AA=E7=
=BB=8F=E6=8E=88=E6=9D=83=E7=9A=84=E6=83=85=E5=86=B5=E4=B8=8B=E4=BB=A5=E4=BB=
=BB=E4=BD=95=E5=BD=A2=E5=BC=8F=E4=BD=BF=E7=94=A8=E3=80=82=E5=A6=82=E6=9E=9C=
=E6=82=A8=E9=94=99=E6=94=B6=E4=BA=86=E6=9C=AC=E9=82=AE=E4=BB=B6=EF=BC=8C=E8=
=AF=B7=E7=AB=8B=E5=8D=B3=E4=BB=A5=E7=94=B5=E5=AD=90=E9=82=AE=E4=BB=B6=E9=80=
=9A=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=BA=BA=E5=B9=B6=E5=88=A0=E9=99=A4=E6=9C=AC=
=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E3=80=82

This e-mail and its attachments contain confidential information from OPPO,=
 which is intended only for the person or entity whose address is listed ab=
ove. Any use of the information contained herein in any way (including, but=
 not limited to, total or partial disclosure, reproduction, or disseminatio=
n) by persons other than the intended recipient(s) is prohibited. If you re=
ceive this e-mail in error, please notify the sender by phone or email imme=
diately and delete it!
