Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B05E8E017
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Aug 2019 23:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfHNVo0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Aug 2019 17:44:26 -0400
Received: from mail-eopbgr680137.outbound.protection.outlook.com ([40.107.68.137]:4022
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbfHNVoZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 17:44:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqh0K55z78oQ7yoKP8uDx0rfgQY5u+W4R/ilZ7VoLD8H5IVGJM59Xpz4OBA0IW4fny/atE3I2whdBHgOy34TpM1Lsf6oTot6HDgdCWZQjGu43++3khxLChiOvz6Ab4vA87I68EYApT5rLqGFXPWZM7YgH6PTMxazYUiVxLEQ6IZLnViTy7lU5vTzOPqBCuK8DJ36b7+Uk0S1BmTUbYzF3NDEwyk9cPEfZHkv76iG4QTeEycNPuA8d7QwbTyVA/fe0IVSKrnA6N7udUPRBfRjEoRsUcuD7C81EabasaoqV7gEJUsNeDVweYyeb0WMGSFKesLmRJI8YSjB5NZII2sUSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pa874Tn0WX2DUQTB3RHdyV61iz6njUNcfXNv2rOYBeo=;
 b=R/62Z4ZGAUK8X1Th337EWRA6INA6PVNNc0/pwb+uS1o93eBowXRn/32++wusiCTl81hwE5R5B0E/8PSaQAbmHRAXYkdYg/CUFxP/7JnQ9uoKePiio4FUWLqgy1VithZsHhGgu+3Hugrix8quHXahFvIG++4sxb+NpDTqxKgGCaUirmI+lohfwKR9CZovVTZsATfI84ToSpX5obxScPKMy4Pr58aKt0qgTo7kPRXrka2ZA8Nbf9MagQhiBQyJHjv9kmuPYTU35zAGgA/mfndb0taQ19li3J/kQKF/eEGgQvSYSI98L5eLjgh2zyiS1X5GSg3Z5Vx86o7wDU3oYv32yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=godaddy.com; dmarc=pass action=none header.from=godaddy.com;
 dkim=pass header.d=godaddy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secureservernet.onmicrosoft.com;
 s=selector2-secureservernet-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pa874Tn0WX2DUQTB3RHdyV61iz6njUNcfXNv2rOYBeo=;
 b=gr4enNbBYg85HDvD+t/0n3m1mCxJriCRcgmNrHQHwt08+pJ2z6eouzCoYwtRIvDUn83oTi0qejv8xWBOG5SPIH9eHwRQdY8mL4T3rC4fwtZH1lbDb8/98EYsnt6063J/dp2MynKZA2g2kf4KA/hmfZ63bsA/89tTN2TcNS8ApNo=
Received: from MW2PR02MB3689.namprd02.prod.outlook.com (52.132.177.22) by
 MW2PR02MB3835.namprd02.prod.outlook.com (52.132.178.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Wed, 14 Aug 2019 21:44:19 +0000
Received: from MW2PR02MB3689.namprd02.prod.outlook.com
 ([fe80::790d:fa14:b860:8727]) by MW2PR02MB3689.namprd02.prod.outlook.com
 ([fe80::790d:fa14:b860:8727%7]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 21:44:19 +0000
From:   Bryan Stillwell <bstillwell@godaddy.com>
To:     "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: backfill_toofull seen on cluster where the most full OSD is at 1%
Thread-Topic: backfill_toofull seen on cluster where the most full OSD is at
 1%
Thread-Index: AQHVUultPlvyAehnREi8NQlVkcobEQ==
Date:   Wed, 14 Aug 2019 21:44:19 +0000
Message-ID: <B44994A6-D75F-4793-8599-7C3B7C53B3AB@godaddy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=bstillwell@godaddy.com; 
x-originating-ip: [73.181.96.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c453a277-5a4b-4c3f-ba54-08d721008fdb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MW2PR02MB3835;
x-ms-traffictypediagnostic: MW2PR02MB3835:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MW2PR02MB38356ADFDDB02FD31A722676DFAD0@MW2PR02MB3835.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(199004)(189003)(66556008)(486006)(6512007)(99286004)(6916009)(5640700003)(6306002)(476003)(6486002)(64756008)(316002)(81156014)(81166006)(66446008)(14454004)(33656002)(66476007)(6506007)(6436002)(76116006)(186003)(91956017)(966005)(2616005)(66946007)(2501003)(26005)(305945005)(7736002)(86362001)(102836004)(478600001)(3846002)(256004)(2351001)(71190400001)(8676002)(14444005)(36756003)(71200400001)(8936002)(5660300002)(2906002)(53936002)(66066001)(6116002)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR02MB3835;H:MW2PR02MB3689.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: godaddy.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vAyWbCqhxRv2fhvsfBy1yjiJZv+8Y2Paq8E5rZsLJOaY4tkD/gpjq8s2602OLnTwuRVSAt0Cf5saVWqMGUvtHme/K/U36BIj8BACYB6sq8jvelPsv37+e+P34euUszIUhQXKSSZJqJB6hVkUf9+a5LNbqARgW9GnYx5rOAZ5rqKGglYnzdsxjEkaCphZEZweAa9uRZo86BCLOd+rB64k9/cd3Nk5OMs8rMjHc2g++P4IVook2wjghLZAK1H6CC3YuSl/LGoVh3F0OSWGWNWX5MtPUeplxCZU6IVRy+aKYPc37SVoYYIBpSNXaKlnhSKSoySzfj/fS6/E3f3qRQKr1yYteBaW6tMRYpuZhPCwbHBUnG96YaD0cbwvb4Qv2D/c/BXn8ywJJI993h9kB87DZ3/yv0DLdkkmu/xjDXhYU60=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A08968F54285A947B794D19CDDFC6537@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: godaddy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c453a277-5a4b-4c3f-ba54-08d721008fdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 21:44:19.3213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d5f1622b-14a3-45a6-b069-003f8dc4851f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zmjEzgp1vXp5+BTBNx18Wg23c1RbYa4xPepNKS9WGqsadvw9YPODNYkiF0bNWy2Yxp+iv9Nt3J3IISddXlMSRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3835
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We've run into this issue on the first two clusters after upgrading them to=
 Nautilus (14.2.2).

When marking a single OSD back in to the cluster some PGs will switch to th=
e active+remapped+backfill_wait+backfill_toofull state for a while and then=
 it goes away after some of the other PGs finish backfilling.  This is rath=
er odd because all the data on the cluster could fit on a single drive, but=
 we have over 100 of them:

# ceph -s
  cluster:
    id:     XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
    health: HEALTH_ERR
            Degraded data redundancy (low space): 1 pg backfill_toofull

  services:
    mon: 3 daemons, quorum a1cephmon002,a1cephmon003,a1cephmon004 (age 21h)
    mgr: a1cephmon002(active, since 21h), standbys: a1cephmon003, a1cephmon=
004
    mds: cephfs:2 {0=3Da1cephmon002=3Dup:active,1=3Da1cephmon003=3Dup:activ=
e} 1 up:standby
    osd: 143 osds: 142 up, 142 in; 106 remapped pgs
    rgw: 11 daemons active (radosgw.a1cephrgw008, radosgw.a1cephrgw009, rad=
osgw.a1cephrgw010, radosgw.a1cephrgw011, radosgw.a1tcephrgw002, radosgw.a1t=
cephrgw003, radosgw.a1tcephrgw004, radosgw.a1tcephrgw005, radosgw.a1tcephrg=
w006, radosgw.a1tcephrgw007, radosgw.a1tcephrgw008)

  data:
    pools:   19 pools, 5264 pgs
    objects: 1.45M objects, 148 GiB
    usage:   658 GiB used, 436 TiB / 437 TiB avail
    pgs:     44484/4351770 objects misplaced (1.022%)
             5158 active+clean
             104  active+remapped+backfill_wait
             1    active+remapped+backfilling
             1    active+remapped+backfill_wait+backfill_toofull

  io:
    client:   19 MiB/s rd, 13 MiB/s wr, 431 op/s rd, 509 op/s wr


I searched the archives, but most of the other people had more full cluster=
s where sometimes this state could be valid.  This bug report seems similar=
, but the fix was just to make it a warning instead of an error:

https://tracker.ceph.com/issues/39555


So I've created a new tracker ticket to troubleshoot this issue:

https://tracker.ceph.com/issues/4125


Let me know what you guys think,

Bryan=
