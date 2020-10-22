Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F2929646B
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Oct 2020 20:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368950AbgJVSGF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Oct 2020 14:06:05 -0400
Received: from mail-am6eur05on2063.outbound.protection.outlook.com ([40.107.22.63]:61313
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S368910AbgJVSGF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 14:06:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlVob4zItJIvQZMKospe53rYYhG0/N+LymEYc2fPvAJhAGo1cheSeO5S2RlaGF7TnQ/2ITKjd7ajfm47mqNOndGAR3US3RzAHlutIHlsXiQ+iQCrHXdXNwsF6l0If73U+5vutb6rGKX5BNJCy7v3WD/Xhn1y7kPc3PNldK3wxD7Nc+7x3rb89qpVCisHpspd+jsncqWGp5rD5RImn89MmpjcCsvdA7Vddhw4IL0CYuUPiQ3T5n5YqRru4yhWdTwd9FM7asETLU440VTDkR0AGoMgoAsFX1T/Cv74FUwXwLBAtfN4BgRw6CL7dGV70WHhnzq+yG97nvHTgclMc7V4BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F45Fbzx0sbmQMEr3n217TTSTpvE24XIqRhxneYwKNtM=;
 b=W+tpkEh6niqwKzbWo/bpzWHA3ni6qW9H4LWEMBfxhUpJhqTHISU8k8t08Xr4I7rG0WrVK8hPucgZDo+S+sav17O1BdDc09qkt5cvKoTS7JXn9tqdGuc3Wa1R3uPL3HqluJmYmRa0piLbVD7O+EqejmfcTwXGJoTC9iQJORpB9TNEeaADMRj1qoXP9bWgqd3/QMa9PfVCxpjJnUdP98YgzMZV+RSTIwNWVsYbajm7nfUdN14Pgq4vlAgAcVFF+fotM587+3H8hZmSihYNaa6G6EbDKkvuNZWEnN1oGkEP4fIY1s+y+iSZphCC8yoKVc46ErXgKMaWfNz1qusnYcbagQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.38.82.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=dtu.dk;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=dtu.dk; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dtu.dk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F45Fbzx0sbmQMEr3n217TTSTpvE24XIqRhxneYwKNtM=;
 b=t12HxaOyRZky4Q935Ep/DID/bZ4mhdNciXCM3pD4xJrBZlbDaHKDgetgfAMAcphsGVIBKUI8BoM6Q79csoC/zBltCBeNbOc0UQbAodWfFc+Mvp/XZo8wHjYCr2IKJp/sMSCbi1+0IXP7TH3v5FqCXPGllnH+OWUO1zoZQ+sjcqg=
Received: from AM5PR0402CA0001.eurprd04.prod.outlook.com
 (2603:10a6:203:90::11) by AM0P192MB0258.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 22 Oct
 2020 18:06:01 +0000
Received: from HE1EUR01FT025.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:203:90:cafe::3b) by AM5PR0402CA0001.outlook.office365.com
 (2603:10a6:203:90::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend
 Transport; Thu, 22 Oct 2020 18:06:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.38.82.195)
 smtp.mailfrom=dtu.dk; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=dtu.dk;
Received-SPF: Pass (protection.outlook.com: domain of dtu.dk designates
 192.38.82.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.38.82.195; helo=mail.win.dtu.dk;
Received: from mail.win.dtu.dk (192.38.82.195) by
 HE1EUR01FT025.mail.protection.outlook.com (10.152.0.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.3499.18 via Frontend Transport; Thu, 22 Oct 2020 18:06:00 +0000
Received: from ait-pexsrv07.win.dtu.dk (192.38.82.200) by
 ait-pexsrv02.win.dtu.dk (192.38.82.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 22 Oct 2020 20:05:59 +0200
Received: from ait-pexsrv03.win.dtu.dk (192.38.82.196) by
 ait-pexsrv07.win.dtu.dk (192.38.82.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 22 Oct 2020 20:05:59 +0200
Received: from ait-pexsrv03.win.dtu.dk ([192.38.82.196]) by
 ait-pexsrv03.win.dtu.dk ([192.38.82.196]) with mapi id 15.01.2106.003; Thu,
 22 Oct 2020 20:05:57 +0200
From:   Frank Schilder <frans@dtu.dk>
To:     Dan van der Ster <dan@vanderster.com>,
        David C <dcsysengineer@gmail.com>
CC:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Subject: Re: [ceph-users] Re: Urgent help needed please - MDS offline
Thread-Topic: [ceph-users] Re: Urgent help needed please - MDS offline
Thread-Index: AQHWqHDE5uFBnESm3UKg2DWv2H02h6mjfd4AgAAIl4CAAAJyAIAABFAAgAAZ8YCAAAKQgIAAI/38///qTQCAAAHLgIAAATMAgAABXYCAAC4Q9w==
Date:   Thu, 22 Oct 2020 18:05:57 +0000
Message-ID: <29f9da3105b34397bbaf59471a448077@dtu.dk>
References: <CACo-D_AU21TT6wcuUXTDquUY1UtSb265ga+0SAvU2S-RCWmzTw@mail.gmail.com>
 <CABZ+qq=n8XFYNtrJKThG3OViYa12pVMU4b5eVr58ZFHxbAod=A@mail.gmail.com>
 <CACo-D_DhNDXAyOjJR6W9JYhZP7m9pfbh7q-G1nDMJhHskdtOXQ@mail.gmail.com>
 <CABZ+qqk1ii6sjK4izGb-ReZdUDy4U-7gRj6ywFxzHkpEGuOOHQ@mail.gmail.com>
 <CACo-D_D6abDxhwUY2ZdkFbdwTPduhKbvtK7+7GFL5VWQJbZ7xw@mail.gmail.com>
 <CABZ+qqkB_daQ+yfq+CR3Ye+8t+gv_QuavNWNRJzxP6Og5VKROg@mail.gmail.com>
 <CACo-D_BxGq2-Dq6FahNXPN6rj3BeoKmJuq6j5Nhqzcx74URqHg@mail.gmail.com>
 <CABZ+qqmvn-Yd3ZhPd3q4-RFtqjGgeHLCMwVvjMLJ4fmtxY9-gA@mail.gmail.com>
 <1867678ff367465eb7a6767a62b45764@dtu.dk>
 <CACo-D_Cjb0TF47ZwYYAXkpnYWN-9eAXtc4K3fGaC=ZLUvHzLRA@mail.gmail.com>
 <CABZ+qqn6FJGU_a7-+Qiqt0YxbfMxN-Bj8X_kcfD+X8P6idRCmA@mail.gmail.com>
 <CACo-D_DCHENXaPntE_T+R7L7yfUVMx9K-KHu40oyd-dKPc_kEg@mail.gmail.com>,<CABZ+qqkGQKHx=VzvDVjDvG_m7C8PpfbiuRM3+-b5_8yLwgNbFg@mail.gmail.com>
In-Reply-To: <CABZ+qqkGQKHx=VzvDVjDvG_m7C8PpfbiuRM3+-b5_8yLwgNbFg@mail.gmail.com>
Accept-Language: en-GB, da-DK, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.38.82.8]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51bd8c6c-8a6b-403c-b89e-08d876b52242
X-MS-TrafficTypeDiagnostic: AM0P192MB0258:
X-Microsoft-Antispam-PRVS: <AM0P192MB02587497633E8CF460D5C648D61D0@AM0P192MB0258.EURP192.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TO9cs8hIPwVHxmhKe7iR72v3GsAX1SgOHpTKeV+5v9KTRH3nYG7A4BY4jW3sQgHwa+AfjBPjzxlI9+9Lu0GEi1+YvrGLgvwmhQvmzEFpWpYLipvGRtgfKz4MDT5PcSq9YUO5FJNYhmP1i8cRf4hcAlAq8boICzSvmxMcsD+YROlC4N5hlDSeR9HQLkvtXpS8iQ1qr5XLz+DRo4Sbk/dtzLIm1LTpJHdEqyDO/oNMi8ZUk6AMvjEzNAtv5lLyBsyzN039zmYPfFNAJbnsHqhV7SxkDntZdDcgkdpOUacT0xF288ci+UwOR8fOrVpSBB01NsepVdqnPF1SfAvBGDAkjfb5i9P7ZE3x2jfrYn6sarFl8cL0Lc5Yxs6Ga7rvcQ6LPyYaIyjuHhKg/xYntfgWTQ==
X-Forefront-Antispam-Report: CIP:192.38.82.195;CTRY:DK;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.win.dtu.dk;PTR:ait-pexsrv02.win.dtu.dk;CAT:NONE;SFS:(136003)(39840400004)(376002)(396003)(346002)(46966005)(82310400003)(316002)(356005)(4744005)(70206006)(47076004)(70586007)(108616005)(86362001)(110136005)(54906003)(5660300002)(26005)(786003)(2616005)(4326008)(8676002)(426003)(2906002)(8976002)(478600001)(336012)(36756003)(24736004)(8936002)(186003)(7696005)(956004);DIR:OUT;SFP:1101;
X-OriginatorOrg: dtu.dk
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2020 18:06:00.8381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51bd8c6c-8a6b-403c-b89e-08d876b52242
X-MS-Exchange-CrossTenant-Id: f251f123-c9ce-448e-9277-34bb285911d9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f251f123-c9ce-448e-9277-34bb285911d9;Ip=[192.38.82.195];Helo=[mail.win.dtu.dk]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT025.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P192MB0258
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The post was titled "mds behind on trimming - replay until memory exhausted=
".

> Load up with swap and try the up:replay route.
> Set the beacon to 100000 until it finishes.

Good point! The MDS will not send beacons for a long time. Same was necessa=
ry in the other case.

Good luck!
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Frank Schilder
AIT Ris=F8 Campus
Bygning 109, rum S14
