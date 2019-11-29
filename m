Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8CE810D279
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Nov 2019 09:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfK2IaW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 Nov 2019 03:30:22 -0500
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:65518
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbfK2IaW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 03:30:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiuCRwg5sQRksjeSIxreZIz3JzBgkQujVof1tJcvxHNrDjYQqvsJN5LpxttRBd2VwBUru9IXbzFkLIHMFhYAxWD1g/D6pk8dNCmAPCQZKrTTHMHNTVJnEm1iEmZJ8eYtqKclcT0DHzHK+UMNOvUD36MMXp3zBwtnuygu0uaSW80Y1B73PC2C9yJrQED9dLcWfdHYPktyVUkcF0Sa42TU/UIx+/xj27Vn0xFle6mdkXCfjGOiGwkJDigmYQoqz8Hqcu/sfvhSR5NGnXRYWK3SH7w/T1OX3GnSzYLgXFFeqU6iD+vyZvoWCYQL16Zaf6scPbYmjbYAjrioNUKSiJucmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+3kXEet3pouGo8VXyR+cPtaL56wR93b/DqdsloWpo8=;
 b=Eu1vKF8S9ZLfOjRmFjRc5C1lp3WxdfIW0UnukxilExL1Zn2mtx1xFCDG294hbe94fV6AyPTI4Ixy8PG2lBXzLyJWdAr63t8Aoh7gsYQeJ/KlfNG3Ofww44WcpLDodFJhoXdmp+Ucoi3bV7lUQWQ7znYdi6UiEDmO/gAnW8uTLSaFpBBM7sfKHKXHE1QvfEkuEU792QRh6F4SdBKI8lbQztKH+MEKK/KcUufPMPtAAC5MeT7ousBHjRvJHY9AqYn/Ne2mnQl7dkphzEvekiRXdGi5sElFvd9P2A3kgF46CM+h4kwni7qCOyZchFnWzGWA8pQ15C6Dpd0k8x2lpT4T1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.38.82.194) smtp.rcpttodomain=gmail.com smtp.mailfrom=dtu.dk; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=dtu.dk;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dtu.dk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+3kXEet3pouGo8VXyR+cPtaL56wR93b/DqdsloWpo8=;
 b=4Y+Ay2sn6x084oUjjOor2fTxWvD8+Ak9z9/PMrRHhgb3y1LpEI0pWC1v20lMwXHw9eFx/LoXU12kHCtsj8AsVAcPDtRlBpq/Lt9gbwf3Au/nV5Hm+/NwwoiMvp5rsS1Vm2H2HRoYvvI2RVqTccEOwuDlVPECq5VFmgYqXlQ8+cI=
Received: from AM6P192CA0019.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::32)
 by DB7P192MB0267.EURP192.PROD.OUTLOOK.COM (2603:10a6:5:7::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Fri, 29 Nov 2019 08:30:16 +0000
Received: from VE1EUR01FT040.eop-EUR01.prod.protection.outlook.com
 (2a01:111:f400:7e01::202) by AM6P192CA0019.outlook.office365.com
 (2603:10a6:209:83::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2495.19 via Frontend
 Transport; Fri, 29 Nov 2019 08:30:16 +0000
Authentication-Results: spf=pass (sender IP is 192.38.82.194)
 smtp.mailfrom=dtu.dk; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=dtu.dk;
Received-SPF: Pass (protection.outlook.com: domain of dtu.dk designates
 192.38.82.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.38.82.194; helo=mail.win.dtu.dk;
Received: from mail.win.dtu.dk (192.38.82.194) by
 VE1EUR01FT040.mail.protection.outlook.com (10.152.3.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2495.18 via Frontend Transport; Fri, 29 Nov 2019 08:30:16 +0000
Received: from ait-pexsrv08.win.dtu.dk (192.38.82.201) by
 ait-pexsrv01.win.dtu.dk (192.38.82.194) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1779.2; Fri, 29 Nov 2019 09:30:14 +0100
Received: from ait-pexsrv03.win.dtu.dk (192.38.82.196) by
 ait-pexsrv08.win.dtu.dk (192.38.82.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1779.2; Fri, 29 Nov 2019 09:30:14 +0100
Received: from ait-pexsrv03.win.dtu.dk ([192.38.82.196]) by
 ait-pexsrv03.win.dtu.dk ([192.38.82.196]) with mapi id 15.01.1779.007; Fri,
 29 Nov 2019 09:30:14 +0100
From:   Frank Schilder <frans@dtu.dk>
To:     Vincent Godin <vince.mlist@gmail.com>,
        Anthony D'Atri <aad@dreamsnake.net>,
        "ceph-users@ceph.io" <ceph-users@ceph.io>,
        "Ceph Development" <ceph-devel@vger.kernel.org>
Subject: Re: [ceph-users] Re: mimic 13.2.6 too much broken connexions
Thread-Topic: [ceph-users] Re: mimic 13.2.6 too much broken connexions
Thread-Index: AQHVpVaXXCV6MIT0KUu/Fi+rW5b8Kaeh0Wve
Date:   Fri, 29 Nov 2019 08:30:13 +0000
Message-ID: <8c4c081a83e640e9bfaaa6679590cefa@dtu.dk>
References: <CAL2-6b+A2tQd=pMoXRewK2KeakDpy0X40vDg0OTWk-ZAm5RfmA@mail.gmail.com>
 <62E3E7FC-DEB5-4EBC-8945-F7FF43C6433C@dreamsnake.net>,<CAL2-6b+wKe0X1BB2Wts9Q7RX_BQiVk0MaA0=k1LXV_hGwezb5Q@mail.gmail.com>
In-Reply-To: <CAL2-6b+wKe0X1BB2Wts9Q7RX_BQiVk0MaA0=k1LXV_hGwezb5Q@mail.gmail.com>
Accept-Language: en-GB, da-DK, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.38.82.8]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.38.82.194;IPV:CAL;SCL:-1;CTRY:DK;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39860400002)(136003)(45924002)(199004)(189003)(70206006)(305945005)(26005)(3846002)(6116002)(102836004)(7736002)(186003)(70586007)(36756003)(11346002)(66574012)(8676002)(229853002)(356004)(246002)(4001150100001)(86362001)(956004)(6246003)(53546011)(446003)(436003)(426003)(76130400001)(2616005)(2501003)(47776003)(24736004)(76176011)(66066001)(5660300002)(478600001)(7696005)(50466002)(2486003)(23676004)(14444005)(53416004)(336012)(786003)(106002)(110136005)(26826003)(316002)(8976002)(108616005)(8936002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7P192MB0267;H:mail.win.dtu.dk;FPR:;SPF:Pass;LANG:en;PTR:ait-pexsrv01.win.dtu.dk;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20ccd05b-cd2c-48d5-b7b1-08d774a65cd1
X-MS-TrafficTypeDiagnostic: DB7P192MB0267:
X-Microsoft-Antispam-PRVS: <DB7P192MB02677A0AD60DE3C89ACCFEBCD6460@DB7P192MB0267.EURP192.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0236114672
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0VkUlXdZAj7LNA/7RvIyoegnkic5mR7gyS++S1E1hz16S7py3gE/K9W2zUY6C1RoQGevS5zWpM15DpKnuHZLXOLhzcoGR+6DgriJm0bC4U8AQHhFzC9BEdf/uJl6bG0C5BmI2VItxGvo+rXdk5LRgpqB/PYo4QgHNW0JnX+fEhpUAVkiGnMbKaUDJ9Xro8tObfqTN8IGcdA43gGb2upGHM9HRifYp5S31AAjk0/Z6psHzpOVpoh2Z4OI+2c2jDw78oduEBE3Vr73CBU61GgAnwiSHqnI1JB8y30UNJgPPwZ57pnu3Kc3W4bq6IkwmQWx4YbbkElnEF01sBI9G5IaVDEuIEO42s6G/P+6vVNAz/va61LTzA8F5yDL3pibY0kfraucgSdmy0vhpbyhrMqMBgTZc4A3Ps39QhHURJTg5QUVMaCUPxCdEVBwgOarDXCfeChXYyubyJhxmROm9mj2w==
X-OriginatorOrg: dtu.dk
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2019 08:30:16.6195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ccd05b-cd2c-48d5-b7b1-08d774a65cd1
X-MS-Exchange-CrossTenant-Id: f251f123-c9ce-448e-9277-34bb285911d9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f251f123-c9ce-448e-9277-34bb285911d9;Ip=[192.38.82.194];Helo=[mail.win.dtu.dk]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7P192MB0267
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

SG93IGxhcmdlIGlzIHlvdXIgYXJwIGNhY2hlPyBXZSBoYXZlIHNlZW4gY2VwaCBkcm9wcGluZyBj
b25uZWN0aW9ucyBhcyBzb29uIGFzIHRoZSBsZXZlbC0yIG5ldHdvcmsgKGRpcmVjdCBuZWlnaGJv
dXJzKSBpcyBsYXJnZXIgdGhhbiB0aGUgYXJwIGNhY2hlLiBXZSBhZGp1c3RlZCB0aGUgZm9sbG93
aW5nIHNldHRpbmdzOg0KDQojIEluY3JlYXNlIEFSUCBjYWNoZSBzaXplIHRvIGFjY29tbW9kYXRl
IGxhcmdlIGxldmVsLTIgY2xpZW50IG5ldHdvcmsuDQpuZXQuaXB2NC5uZWlnaC5kZWZhdWx0Lmdj
X3RocmVzaDEgPSAxMDI0DQpuZXQuaXB2NC5uZWlnaC5kZWZhdWx0LmdjX3RocmVzaDIgPSAyMDQ4
DQpuZXQuaXB2NC5uZWlnaC5kZWZhdWx0LmdjX3RocmVzaDMgPSA0MDk2DQoNCkFub3RoZXIgaW1w
b3J0YW50IGdyb3VwIG9mIHBhcmFtZXRlcnMgZm9yIFRDUCBjb25uZWN0aW9ucyBzZWVtcyB0byBi
ZSB0aGVzZSwgd2l0aCBvdXIgdmFsdWVzOg0KDQojIyBJbmNyZWFzZSBudW1iZXIgb2YgaW5jb21p
bmcgY29ubmVjdGlvbnMuIFRoZSB2YWx1ZSBjYW4gYmUgcmFpc2VkIHRvIGJ1cnN0cyBvZiByZXF1
ZXN0LCBkZWZhdWx0IGlzIDEyOA0KbmV0LmNvcmUuc29tYXhjb25uID0gMjA0OA0KIyMgSW5jcmVh
c2UgbnVtYmVyIG9mIGluY29taW5nIGNvbm5lY3Rpb25zIGJhY2tsb2csIGRlZmF1bHQgaXMgMTAw
MA0KbmV0LmNvcmUubmV0ZGV2X21heF9iYWNrbG9nID0gNTAwMDANCiMjIE1heGltdW0gbnVtYmVy
IG9mIHJlbWVtYmVyZWQgY29ubmVjdGlvbiByZXF1ZXN0cywgZGVmYXVsdCBpcyAxMjgNCm5ldC5p
cHY0LnRjcF9tYXhfc3luX2JhY2tsb2cgPSAzMDAwMA0KDQpXaXRoIHRoaXMsIHdlIGdvdCByaWQg
b2YgZHJvcHBlZCBjb25uZWN0aW9ucyBpbiBhIGNsdXN0ZXIgb2YgMjAgY2VwaCBub2RlcyBhbmQg
Y2EuIDU1MCBjbGllbnQgbm9kZXMsIGFjY291bnRpbmcgZm9yIGFib3V0IDE1MDAgYWN0aXZlIGNl
cGggY2xpZW50cywgMTQwMCBjZXBoZnMgYW5kIDE3MCBSQkQgaW1hZ2VzLg0KDQpCZXN0IHJlZ2Fy
ZHMsDQoNCj09PT09PT09PT09PT09PT09DQpGcmFuayBTY2hpbGRlcg0KQUlUIFJpc8O4IENhbXB1
cw0KQnlnbmluZyAxMDksIHJ1bSBTMTQNCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXw0KRnJvbTogVmluY2VudCBHb2RpbiA8dmluY2UubWxpc3RAZ21haWwuY29tPg0K
U2VudDogMjcgTm92ZW1iZXIgMjAxOSAyMDoxMToyMw0KVG86IEFudGhvbnkgRCdBdHJpOyBjZXBo
LXVzZXJzQGNlcGguaW87IENlcGggRGV2ZWxvcG1lbnQNClN1YmplY3Q6IFtjZXBoLXVzZXJzXSBS
ZTogbWltaWMgMTMuMi42IHRvbyBtdWNoIGJyb2tlbiBjb25uZXhpb25zDQoNCklmIGl0IHdhcyBh
IG5ldHdvcmsgaXNzdWUsIHRoZSBjb3VudGVycyBzaG91bGQgZXhwbG9zZSAoYXMgaSBzYWlkLA0K
d2l0aCBhIGxvZyBsZXZlbCBvZiA1IG9uIHRoZSBtZXNzZW5nZXIsIHdlIG9ic2VydmVkIG1vcmUg
dGhlbiA4MCAwMDANCmxvc3N5IGNoYW5uZWxzIHBlciBtaW51dGUpIGJ1dCBub3RoaW5nIGFibm9y
bWFsIGlzIHJlbGV2YW50IG9uIHRoZQ0KY291bnRlcnMgKG9uIHN3aXRjaHMgYW5kIHNlcnZlcnMp
DQpPbiB0aGUgc3dpdGNocyAgbm8gZHJvcCwgbm8gY3JjIGVycm9yLCBubyBwYWNrZXQgbG9zcywg
b25seSBzb21lDQpvdXRwdXQgZGlzY2FyZHMgYnV0IG5vdCBlbm91Z2ggdG8gYmUgc2lnbmlmaWNh
bnQuIE9uIHRoZSBOSUNzIG9uIHRoZQ0Kc2VydmVycyB2aWEgZXRodG9vbCAtUywgbm90aGluZyBp
cyByZWxldmFudC4NCkFuZCBhcyBpIHNhaWQsIGFuIG90aGVyIG1pbWljIGNsdXN0ZXIgd2l0aCBk
aWZmZXJlbnQgaGFyZHdhcmUgaGFzIHRoZQ0Kc2FtZSBiZWhhdmlvcg0KQ2VwaCB1c2VzIGNvbm5l
eGlvbnMgcG9vbHMgZnJvbSBob3N0IHRvIGhvc3QgYnV0IGhvdyBkb2VzIGl0IGNoZWNrIHRoZQ0K
YXZhaWxhYmlsaXR5IG9mIHRoZXNlIGNvbm5leGlvbnMgb3ZlciB0aGUgdGltZSA/DQpBbmQgYXMg
dGhlIG5ldHdvcmsgZG9lc24ndCBzZWVtIHRvIGJlIGd1aWx0eSwgd2hhdCBjYW4gZXhwbGFpbiB0
aGVzZQ0KYnJva2VuIGNoYW5uZWxzID8NCg0KTGUgbWVyLiAyNyBub3YuIDIwMTkgw6AgMTk6MDUs
IEFudGhvbnkgRCdBdHJpIDxhYWRAZHJlYW1zbmFrZS5uZXQ+IGEgw6ljcml0IDoNCj4NCj4gQXJl
IHlvdSBib25kaW5nIE5JQyBwb3J0cz8gICBJZiBzbyBkbyB5b3UgaGF2ZSB0aGUgY29ycmVjdCBo
YXNoIHBvbGljeSBkZWZpbmVkPyBIYXZlIHlvdSBsb29rZWQgYXQgdGhlICpzd2l0Y2gqIHNpZGUg
Zm9yIHBhY2tldCBsb3NzLCBDUkMgZXJyb3JzLCBldGM/ICAgV2hhdCB5b3UgcmVwb3J0IGNvdWxk
IGJlIGNvbnNpc3RlbnQgd2l0aCB0aGlzLiAgU2luY2UgdGhlIGhvc3QgIGludGVyZmFjZSBmb3Ig
YSBnaXZlbiBjb25uZWN0aW9uIHdpbGwgdmFyeSBieSB0aGUgYm9uZCBoYXNoLCBzb21lIE9TRCBj
b25uZWN0aW9ucyB3aWxsIHVzZSBvbmUgcG9ydCBhbmQgc29tZSB0aGUgb3RoZXIuICAgU28gaWYg
b25lIHBvcnQgaGFzIHN3aXRjaCBzaWRlIGVycm9ycywgb3IgaXMgYmxhY2tob2xlZCBvbiB0aGUg
c3dpdGNoLCB5b3UgY291bGQgc2VlIHNvbWUgaGVhcnQgYmVhdGluZyBpbXBhY3RlZCBidXQgbm90
IG90aGVycy4NCj4NCj4gQWxzbyBtYWtlIHN1cmUgeW91IGhhdmUgdGhlIG9wdGltYWwgcmVwb3J0
ZXJzIHZhbHVlLg0KPg0KPiA+IE9uIE5vdiAyNywgMjAxOSwgYXQgNzozMSBBTSwgVmluY2VudCBH
b2RpbiA8dmluY2UubWxpc3RAZ21haWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IO+7v1RpbGwgaSBz
dWJtaXQgdGhlIG1haWwgYmVsb3cgZmV3IGRheXMgYWdvLCB3ZSBmb3VuZCBzb21lIGNsdWVzDQo+
ID4gV2Ugb2JzZXJ2ZWQgYSBsb3Qgb2YgbG9zc3kgY29ubmV4aW9uIGxpa2UgOg0KPiA+IGNlcGgt
b3NkLjkubG9nOjIwMTktMTEtMjcgMTE6MDM6NDkuMzY5IDdmNmJiNzdkMDcwMCAgMCAtLQ0KPiA+
IDE5Mi4xNjguNC4xODE6NjgxOC8yMjgxNDE1ID4+IDE5Mi4xNjguNC40MTowLzE5NjI4MDk1MTgN
Cj4gPiBjb25uKDB4NTYzOTc5YTlmNjAwIDo2ODE4ICAgcz1TVEFURV9BQ0NFUFRJTkdfV0FJVF9D
T05ORUNUX01TR19BVVRIDQo+ID4gcGdzPTAgY3M9MCBsPTEpLmhhbmRsZV9jb25uZWN0X21zZyBh
Y2NlcHQgcmVwbGFjaW5nIGV4aXN0aW5nIChsb3NzeSkNCj4gPiBjaGFubmVsIChuZXcgb25lIGxv
c3N5PTEpDQo+ID4gV2UgcmFpc2VkIHRoZSBsb2cgb2YgdGhlIG1lc3NlbmdlciB0byA1LzUgYW5k
IG9ic2VydmVkIGZvciB0aGUgd2hvbGUNCj4gPiBjbHVzdGVyIG1vcmUgdGhhbiA4MCAwMDAgbG9z
c3kgY29ubmV4aW9uIHBlciBtaW51dGUgISEhDQo+ID4gV2UgYWRqdXN0ZWQgIHRoZSAibXNfdGNw
X3JlYWRfdGltZW91dCIgZnJvbSA5MDAgdG8gNjAgc2VjIHRoZW4gbm8gbW9yZQ0KPiA+IGxvc3N5
IGNvbm5leGlvbiBpbiBsb2dzIG5vciBoZWFsdGggY2hlY2sgZmFpbGVkDQo+ID4gSXQncyBqdXN0
IGEgd29ya2Fyb3VuZCBidXQgdGhlcmUgaXMgYSByZWFsIHByb2JsZW0gd2l0aCB0aGVzZSBicm9r
ZW4NCj4gPiBzZXNzaW9ucyBhbmQgaXQgbGVhZHMgdG8gdHdvDQo+ID4gYXNzZXJ0aW9ucyA6DQo+
ID4gLSBDZXBoIHRha2UgdG9vIG11Y2ggdGltZSB0byBkZXRlY3QgYnJva2VuIHNlc3Npb24gYW5k
IHNob3VsZCByZWN5Y2xlIHF1aWNrZXIgIQ0KPiA+IC0gVGhlIHJlYXNvbnMgZm9yIHRoZXNlIGJy
b2tlbiBzZXNzaW9ucyA/DQo+ID4NCj4gPiBXZSBoYXZlIGEgb3RoZXIgbWltaWMgY2x1c3RlciBv
biBkaWZmZXJlbnQgaGFyZHdhcmUgYW5kIG9ic2VydmVkIHRoZQ0KPiA+IHNhbWUgYmVoYXZpb3Ig
OiBsb3Qgb2YgbG9zc3kgc2Vzc2lvbnMsIHNsb3cgb3BzIGFuZCBjby4NCj4gPiBTeW1wdG9tcyBh
cmUgdGhlIHNhbWUgOg0KPiA+IC0gc29tZSBPU0RzIG9uIG9uZSBob3N0IGhhdmUgbm8gcmVzcG9u
c2UgZnJvbSBhbiBvdGhlciBvc2Qgb24gYSBkaWZmZXJlbnQgaG9zdHMNCj4gPiAtIGFmdGVyIHNv
bWUgdGltZSwgc2xvdyBvcHMgYXJlIGRldGVjdGVkDQo+ID4gLSBzb21ldGltZSBpdCBsZWFkcyB0
byBpb2Jsb2NrZWQNCj4gPiAtIGFmdGVyIGFib3V0IDE1bW4gdGhlIHByb2JsZW0gdmFuaXNoDQo+
ID4NCj4gPiAtLS0tLS0tLS0tLQ0KPiA+DQo+ID4gSGVscCBvbiBkaWFnIG5lZWRlZCA6IGhlYXJ0
YmVhdF9mYWlsZWQNCj4gPg0KPiA+IFdlIGVuY291bnRlciBhIHN0cmFuZ2UgYmVoYXZpb3Igb24g
b3VyIE1pbWljIDEzLjIuNiBjbHVzdGVyLiBBIGFueQ0KPiA+IHRpbWUsIGFuZCB3aXRob3V0IGFu
eSBsb2FkLCBzb21lIE9TRHMgYmVjb21lIHVucmVhY2hhYmxlIGZyb20gb25seQ0KPiA+IHNvbWUg
aG9zdHMuIEl0IGxhc3QgMTAgbW4gYW5kIHRoZW4gdGhlIHByb2JsZW0gdmFuaXNoLg0KPiA+IEl0
ICdzIG5vdCBhbHdheXMgdGhlIHNhbWUgT1NEcyBhbmQgdGhlIHNhbWUgaG9zdHMuIFRoZXJlIGlz
IG5vIG5ldHdvcmsNCj4gPiBmYWlsdXJlIG9uIGFueSBvZiB0aGUgaG9zdCAoYmVjYXVzZSBvbmx5
IHNvbWUgT1NEcyBiZWNvbWUgdW5yZWFjaGFibGUpDQo+ID4gbm9yIGRpc2sgZnJlZXplIGFzIHdl
IGNhbiBzZWUgaW4gb3VyIGdyYWZhbmEgZGFzaGJvYXJkLiBMb2dzIG1lc3NhZ2UNCj4gPiBhcmUg
Og0KPiA+IGZpcnN0IG1zZyA6DQo+ID4gMjAxOS0xMS0yNCAwOToxOTo0My4yOTIgN2ZhOTk4MGZj
NzAwIC0xIG9zZC41OTYgMTQ2NDgxDQo+ID4gaGVhcnRiZWF0X2NoZWNrOiBubyByZXBseSBmcm9t
IDE5Mi4xNjguNi4xMTI6NjgxNyBvc2QuMzk0IHNpbmNlIGJhY2sNCj4gPiAyMDE5LTExLTI0IDA5
OjE5OjIyLjc2MTE0MiBmcm9udCAyMDE5LTExLTI0IDA5OjE5OjM5Ljc2OTEzOCAoY3V0b2ZmDQo+
ID4gMjAxOS0xMS0yNCAwOToxOToyMy4yOTM0MzYpDQo+ID4gbGFzdCBtc2c6DQo+ID4gMjAxOS0x
MS0yNCAwOTozMDozMy43MzUgN2Y2MzIzNTRmNzAwIC0xIG9zZC41OTEgMTQ2NDgxDQo+ID4gaGVh
cnRiZWF0X2NoZWNrOiBubyByZXBseSBmcm9tIDE5Mi4xNjguNi4xMjM6NjgyOCBvc2QuNjAwIHNp
bmNlIGJhY2sNCj4gPiAyMDE5LTExLTI0IDA5OjI3OjA1LjI2OTMzMCBmcm9udCAyMDE5LTExLTI0
IDA5OjMwOjMzLjIxNDg3NCAoY3V0b2ZmDQo+ID4gMjAxOS0xMS0yNCAwOTozMDoxMy43MzY1MTcp
DQo+ID4gRHVyaW5nIHRoaXMgdGltZSwgMyBob3N0cyB3ZXJlIGludm9sdmVkIDogaG9zdC0xOCwg
aG9zdC0yMCBhbmQgaG9zdC0zMCA6DQo+ID4gaG9zdC0zMCBpcyB0aGUgb25seSBvbmUgd2hvIGNh
bid0IHNlZSBvc2RzIDM0NiwzNTYsYW5kIDM1MiBvbiBob3N0LTE4DQo+ID4gaG9zdC0zMCBpcyB0
aGUgb25seSBvbmUgd2hvIGNhbid0IHNlZSBvc2RzIDM4NyBhbmQgMzk0IG9uIGhvc3QtMjANCj4g
PiBob3N0LTE4IGlzIHRoZSBvbmx5IG9uZSB3aG8gY2FuJ3Qgc2VlIG9zZHMgNTgzLCA1ODUsIDU5
MSBhbmQgNTk3IG9uIGhvc3QtMzANCj4gPiBXZSBjYW4ndCBzZWUgYW55IHN0cmFuZ2UgYmVoYXZp
b3Igb24gaG9zdHMgMTgsIDIwIGFuZCAzMCBpbiBvdXIgbm9kZQ0KPiA+IGV4cG9ydGVyIGRhdGEg
ZHVyaW5nIHRoaXMgdGltZQ0KPiA+IEFueSBpZGVhcyBvciBhZHZpY2VzID8NCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQpjZXBoLXVzZXJzIG1haWxpbmcg
bGlzdCAtLSBjZXBoLXVzZXJzQGNlcGguaW8NClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwg
dG8gY2VwaC11c2Vycy1sZWF2ZUBjZXBoLmlvDQo=
