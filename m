Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3144B19530F
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Mar 2020 09:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgC0Ign (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 Mar 2020 04:36:43 -0400
Received: from mail-eopbgr1300055.outbound.protection.outlook.com ([40.107.130.55]:1680
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbgC0Igm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 27 Mar 2020 04:36:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwi+G7QMiNeKnvoYzHFdJkoKxhVtdtRTmg+yJ2gHFmoHWYbmr9uPVmJxUyPp0J1cUYqY6v/kKcYMHP9xYVmr0ijROL5GAyCVNQXMF5NKngqhreGpb2IK/8czr1opi0WZL93rv4TZSoPH8ugapeiLi+F1ChWustkRhDIM9V/s8IS9XbF0yue4xKE5QXKeKuR8d974xjBXNPH8o30TJwPwhTHNG7Gv5JcuiAq1lRMOkvRStYspKGQC3yNz4PNslTJkTA5FIH+UgHh1NjOd6nijUnOLItLaM7tUXwkQSNSjTOkhzvy7aLx3LGsFzpcTFktmnuXncD2hLqaYcZCFGV+obg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBE9U5BcmItCF4MOwduLCX0HZ/KF3+NGrWUVYOafdgc=;
 b=EDyWd+IoBFH2YgWCnmAlsQLjqOhK4gIOreEf2KdtUxllJmFJO+dJ3V0bGaAN5+eKtASh6iw2AZwYF4rDyJTPGMAniYNH/ms8rynAgEetxVISeFs/LmvCGQo64MJh+/kASBxSsXwoFWi0sZd5WNkXfRhapHoC+zMPkq2u/IOLqXKdeEMl05WHwfuu1r/g6fKnfxb+INeJwypYETF7Y36p3aWDg/G8yZgWZD0Lc7sJjABIfy1PirDav9mLfxV0yLh9VLfd7Gai/WSVVRQ5fKQnNchLOupbDzVBXJkOHgSYojpPVFc3PjOhWAIvnrELc16J82wdBKgJ20DWL2AP8Bn9yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oppoglobal.onmicrosoft.com; s=selector1-oppoglobal-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBE9U5BcmItCF4MOwduLCX0HZ/KF3+NGrWUVYOafdgc=;
 b=KwhDVlztmm5PJ4POuf+psbn2PBfgfbL76jcdr3UteUIat/MZE4dvN4aMkpkjwB6+IU+7OVk2TD9/UDpszd3WIkyxgplUyONnAAJcQD1IY3kmMq7fU1YJz2QhcxVsgbgTWy79X3mGIh0i0xvhBOPRUcEYjMpu1iAvZo+m1DxAc2I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=chenanqing@oppo.com; 
Received: from HK0PR02MB2563.apcprd02.prod.outlook.com (52.133.210.11) by
 HK0SPR01MB0008.apcprd02.prod.outlook.com (20.177.30.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Fri, 27 Mar 2020 08:36:35 +0000
Received: from HK0PR02MB2563.apcprd02.prod.outlook.com
 ([fe80::4078:fbe4:9043:d61e]) by HK0PR02MB2563.apcprd02.prod.outlook.com
 ([fe80::4078:fbe4:9043:d61e%2]) with mapi id 15.20.2835.023; Fri, 27 Mar 2020
 08:36:35 +0000
Date:   Fri, 27 Mar 2020 04:36:32 -0400
From:   chenanqing@oppo.com
To:     chenanqing@oppo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ceph-devel@vger.kernel.org,
        kuba@kernel.org, sage@redhat.com, jlayton@kernel.org,
        idryomov@gmail.com
Message-ID: <5e7dbb10.ulraq/ljeOm297+z%chenanqing@oppo.com>
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: HK2PR0401CA0016.apcprd04.prod.outlook.com
 (2603:1096:202:2::26) To HK0PR02MB2563.apcprd02.prod.outlook.com
 (2603:1096:203:25::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from master (58.252.5.69) by HK2PR0401CA0016.apcprd04.prod.outlook.com (2603:1096:202:2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Fri, 27 Mar 2020 08:36:34 +0000
X-Originating-IP: [58.252.5.69]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5a0020f-4a00-40cb-bc7b-08d7d229f5bc
X-MS-TrafficTypeDiagnostic: HK0SPR01MB0008:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0SPR01MB0008FDC2C20AE3780C3D4141ABCC0@HK0SPR01MB0008.apcprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR02MB2563.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(39860400002)(376002)(396003)(136003)(8936002)(186003)(81166006)(478600001)(81156014)(26005)(52116002)(16526019)(6496006)(316002)(66476007)(9686003)(5660300002)(66556008)(66946007)(86362001)(2616005)(6486002)(2906002)(956004)(36756003)(1670200006)(25626001)(11606004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oppo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/x1z3n494YqMNnUiMYJV+GA7vi/JcpraGFkEIuF4LtpEKXUA7xdcuN1CVi+ph3YhlOqvlEkr+SNyk8lkiSF7l8YJA6CTbTGUBGEHFiFMMHeqatUFGh93R1J1a6f4oRKeNMtdtALcxa1WbmqVge7gEne4CTvQwtiQzCTEouufoQo7nDclABVV9Qnla/dvTSpAEOGJ9h41EQW/AmrzYhCcd/SJUqjHE4T77/8gcWu8VLjQcM9sZr3mmkCe+/OeY0DgxHsWp09ipJ+CbwnYCUefnX7s7aFpSkIx9ZFNlHCfUHmM8UWCMdmGo2Grv+qdznoRa5UpY4jtmRGiwJq1dkySPzeI/sdNiT3ti3XW86RaGcbAVgsdLtPZGeqXLgndBAYpD+sWvRSrKjI/AnITpFpQKIwyqX/ET3MTOIg2yLXbV2ohMJ8cR/YhcRNlzO8ofxlF3d+6ATekb7XsCMFQYcB+Ixh1v1KzNZSMRbHS/gDTZz1J+SZGOaDHRtNIUabqeGsyl+pyf/++x633guLyw9nA8PiCCxeE4hkaHzWJ6vQLgw=
X-MS-Exchange-AntiSpam-MessageData: kYwkmZSmduwT27ce7yxZcXhJiIU/9O8Kafe4CuAphANW4SPwYZaAPYHTmGYV+uF8G1+jCFdkSQsAHagBkStFhjTZyTJLOKbrGZfnSe74fbz5cWEbu84sB2WZJ7Wfwy36LrmpPU/ud7Bfh9ktoOrCeA==
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a0020f-4a00-40cb-bc7b-08d7d229f5bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 08:36:35.6342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXz3zG3tU0ULzNY/N5lLA+XSpr3k/7FW9+ZXtnb5UmvfejGGj8UELxFenYt8gDYTgXf1b7aeYISvdaNoYGLwWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0SPR01MB0008
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Chen Anqing <chenanqing@oppo.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>,
        Sage Weil <sage@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        chenanqing@oppo.com
Subject: [PATCH] libceph: we should take compound page into account also
Date: Fri, 27 Mar 2020 04:36:30 -0400
Message-Id: <20200327083630.36296-1-chenanqing@oppo.com>
X-Mailer: git-send-email 2.18.2

the patch is occur at a real crash,which slab is
come from a compound page,so we need take the compound page
into account also.
fixed commit 7e241f647dc7 ("libceph: fall back to sendmsg for slab pages")'

Signed-off-by: Chen Anqing <chenanqing@oppo.com>
---
 net/ceph/messenger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index f8ca5edc5f2c..e08c1c334cd9 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -582,7 +582,7 @@ static int ceph_tcp_sendpage(struct socket *sock, struc=
t page *page,
         * coalescing neighboring slab objects into a single frag which
         * triggers one of hardened usercopy checks.
         */
-       if (page_count(page) >=3D 1 && !PageSlab(page))
+       if (page_count(page) >=3D 1 && !PageSlab(compound_head(page)))
                sendpage =3D sock->ops->sendpage;
        else
                sendpage =3D sock_no_sendpage;
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
