Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48348105F3D
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Nov 2019 05:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKVEeR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 23:34:17 -0500
Received: from m9a0003g.houston.softwaregrp.com ([15.124.64.68]:32823 "EHLO
        m9a0003g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbfKVEeR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 23:34:17 -0500
Received: FROM m9a0003g.houston.softwaregrp.com (15.121.0.191) BY m9a0003g.houston.softwaregrp.com WITH ESMTP;
 Fri, 22 Nov 2019 04:33:36 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 22 Nov 2019 04:32:49 +0000
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (15.124.72.12) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 22 Nov 2019 04:32:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msnNfezcLlZOM9bgQXGKV4Upnuv25NgBUW87Hk1T0m2tYki3yFPCFVrTIapKpZZXm59m/oreFWyiwLFQiFE1kpXBANQMppPn+X/yPs5ONfyBNi89OGnHzuHoBGDjBvr33vJ9wgvrluJYjM3QNRUSXBZ6a/wkfC7CBfuOM7AJ7IijXSi/J+yKPNfamme3DmOmHDlNtngDQ9vIQoyfy0+MXO/cJBZnp3DPqXJ4PNRxEqg+g/ttsr+iPH7TxwZm8HSTnXG0bBMS1oEMcYDw18sWJeNXtF70gdGPfR83pS64BZII01HZxfvE0vtJ0bimAfqA+WiTEx9xninFKnSbEYTHmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okk3EXUP3WJERCm2s/MXFEDI/Pa5+0ApGSqzOdj4if4=;
 b=JZPq24T4Nkya+gzPt8zDqEBdsGKbnLH++JiHcKtmWCeaxBufRgp+zKjvvxovQVqcjN0b3bsHBrR3DLUPftjrmG9UUZLWtXGLuQXQq2PU5yQK6A+Xwigf5PfB/VkXIzL/kNc4XSb/8yEzig03XjEnA/7jpPOobS133X8CET+p90zOgj2/Tm6ZjAulvdO6yw66+svOrc7M3UDn+sP2SsvcO/6IeiXVriadU3LXxGclZShFifutqaYuQ3E8xXg47xH12NIsd7EiwHyu3MyUQlJdtgPyyUDs0hWrO4YYBEjxRnlD3eV53iHyVMNXX/GblLTp0ANc3lltg7yh54JSc5V4iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MWHPR1801MB1934.namprd18.prod.outlook.com (10.164.204.165) by
 MWHPR1801MB1935.namprd18.prod.outlook.com (10.164.204.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 04:32:48 +0000
Received: from MWHPR1801MB1934.namprd18.prod.outlook.com
 ([fe80::6d26:d3b:e1e5:8bae]) by MWHPR1801MB1934.namprd18.prod.outlook.com
 ([fe80::6d26:d3b:e1e5:8bae%5]) with mapi id 15.20.2474.018; Fri, 22 Nov 2019
 04:32:48 +0000
From:   David Byte <dbyte@suse.com>
To:     Kyle Bader <kyle.bader@gmail.com>
CC:     Mark Nelson <mnelson@redhat.com>, Sage Weil <sage@newdream.net>,
        "Muhammad Ahmad" <muhammad.ahmad@seagate.com>,
        "dev@ceph.io" <dev@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: device class : nvme
Thread-Topic: device class : nvme
Thread-Index: AQHVoLS+yZOpb+/6fU+hUvgWHDjKcKeWM6YAgAAGB4CAAAB1gIAABZKAgABaqoA=
Date:   Fri, 22 Nov 2019 04:32:48 +0000
Message-ID: <962E08FC-4604-46CD-9D8D-49901736E06A@suse.com>
References: <CAFMfnwry8a-p-Un0A+-h-rbKA8V=U5zmFdX8VN_fFPpr7pWZpw@mail.gmail.com>
In-Reply-To: <CAFMfnwry8a-p-Un0A+-h-rbKA8V=U5zmFdX8VN_fFPpr7pWZpw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=dbyte@suse.com; 
x-originating-ip: [63.157.109.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e823b702-66d6-4bbf-2f83-08d76f05077f
x-ms-traffictypediagnostic: MWHPR1801MB1935:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MWHPR1801MB193508D2C3B338C3E7724DD1CB490@MWHPR1801MB1935.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(199004)(189003)(305945005)(6512007)(91956017)(6486002)(66446008)(33656002)(66946007)(66476007)(6306002)(66066001)(2906002)(66556008)(7736002)(6116002)(76116006)(446003)(11346002)(3846002)(36756003)(2616005)(6436002)(9886003)(14444005)(229853002)(8936002)(256004)(81156014)(81166006)(8676002)(25786009)(966005)(14454004)(102836004)(53546011)(64756008)(508600001)(71190400001)(26005)(5660300002)(99286004)(86362001)(76176011)(54906003)(186003)(6506007)(71200400001)(4326008)(316002)(6916009)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR1801MB1935;H:MWHPR1801MB1934.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VxQChNYOhEOpDA49tcZkV8OvR0RaQ0mmUIIs2+WvkdzL+vl2RHrLPsj+xQfBRiZufougqzMs1JiKp2Cq2T7ithUTcacWZ20xvNj3JcneEJpdI3Op6godvO4D2tQ1NxbURfPsZKG6XYOLyo2DJFAbFVZVTnYLqsQZcHjrAZJQvUa/sQNBJ91uKftfNFHHmxZAVy+UFcJULZYL3/Frxy79oTUNPHy4AVsUuUmLlTx3H+rcbEsNluGJ5cgo0B74Kvw1sVUwzz4KJK8STPNd3wg44887J8QP6XJp/DFLw7Q8rumctoO05skWZ6pO6ovZAHuy3VM7D8Z8EnjDkdSWwrUpddAl8mGhjcYUVEWwJxBVC3M72EtS1/ZbewsrM0FmQfAb9LerSf6D1rDj/k0EoWnFt+hY45JJpVxbkLAuoFf/eN277miRYzojcLlDcPR/nnP5NS/aGDLE6AXEZpANGu0skTwRcpNCrDkQBHfBDbEVLgo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <49D780FB1C42FB448316768B639EB3C3@MicroFocusInternational.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e823b702-66d6-4bbf-2f83-08d76f05077f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 04:32:48.5511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HSm/nYXv8O7rJINy3ix3Xt/g3ZttHuNpfAES5mlu28/ZzdSfa8alyePQ/0Tt7/pH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1935
X-OriginatorOrg: suse.com
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

VGhlIG52bWUgZGV2aWNlcyBzaG93IHVwIGFzIHNzZCwgc28gSSBoYXZlIHRvIG1hbnVhbGx5IHJl
Y2xhc3NpZnkgdGhlbSBvbiBteSBjbHVzdGVyLiANCg0KU2VudCBmcm9tIG15IGlQaG9uZS4gVHlw
b3MgYXJlIEFwcGxlJ3MgZmF1bHQuIA0KDQo+IE9uIE5vdiAyMSwgMjAxOSwgYXQgNDoxMCBQTSwg
S3lsZSBCYWRlciA8a3lsZS5iYWRlckBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4g77u/V2Ugc3Nk
IGRldmljZSBjbGFzcyBvbiByb29rLWNlcGggYnVpbHQgY2x1c3RlcnMgb24gbTUgaW5zdGFuY2Vz
DQo+IChkZXZpY2VzIGFwcGVhciBhcyBudm1lKQ0KPiANCj4+IE9uIFRodSwgTm92IDIxLCAyMDE5
IGF0IDI6NDggUE0gTWFyayBOZWxzb24gPG1uZWxzb25AcmVkaGF0LmNvbT4gd3JvdGU6DQo+PiAN
Cj4+IA0KPj4+IE9uIDExLzIxLzE5IDQ6NDYgUE0sIE1hcmsgTmVsc29uIHdyb3RlOg0KPj4+IE9u
IDExLzIxLzE5IDQ6MjUgUE0sIFNhZ2UgV2VpbCB3cm90ZToNCj4+Pj4gQWRkaW5nIGRldkBjZXBo
LmlvDQo+Pj4+IA0KPj4+PiBPbiBUaHUsIDIxIE5vdiAyMDE5LCBNdWhhbW1hZCBBaG1hZCB3cm90
ZToNCj4+Pj4+IFdoaWxlIHRyeWluZyB0byByZXNlYXJjaCBob3cgY3J1c2ggbWFwcyBhcmUgdXNl
ZC9tb2RpZmllZCBJIHN0dW1ibGVkDQo+Pj4+PiB1cG9uIHRoZXNlIGRldmljZSBjbGFzc2VzLg0K
Pj4+Pj4gaHR0cHM6Ly9jZXBoLmlvL2NvbW11bml0eS9uZXctbHVtaW5vdXMtY3J1c2gtZGV2aWNl
LWNsYXNzZXMvDQo+Pj4+PiANCj4+Pj4+IEkgd2FudGVkIHRvIGhpZ2hsaWdodCB0aGF0IGhhdmlu
ZyBudm1lIGFzIGEgc2VwYXJhdGUgY2xhc3Mgd2lsbA0KPj4+Pj4gZXZlbnR1YWxseSBicmVhayBh
bmQgc2hvdWxkIGJlIHJlbW92ZWQuDQo+Pj4+PiANCj4+Pj4+IFRoZXJlIGlzIGFscmVhZHkgYSBw
dXNoIHdpdGhpbiB0aGUgaW5kdXN0cnkgdG8gY29uc29saWRhdGUgZnV0dXJlDQo+Pj4+PiBjb21t
YW5kIHNldHMgYW5kIE5WTWUgd2lsbCBsaWtlbHkgYmUgaXQuIEluIG90aGVyIHdvcmRzLCBOVk1l
IEhERHMgYXJlDQo+Pj4+PiBub3QgdG9vIGZhciBvZmYuIEluIGZhY3QsIHRoZSByZWNlbnQgT2N0
b2JlciBPQ1AgRjJGIGRpc2N1c3NlZCB0aGlzDQo+Pj4+PiB0b3BpYyBpbiBkZXRhaWwuDQo+Pj4+
PiANCj4+Pj4+IElmIHRoZSBjbGFzc2lmaWNhdGlvbiBpcyBiYXNlZCBvbiBwZXJmb3JtYW5jZSB0
aGVuIGNvbW1hbmQgc2V0DQo+Pj4+PiAoU0FUQS9TQVMvTlZNZSkgaXMgcHJvYmFibHkgbm90IHRo
ZSByaWdodCBjbGFzc2lmaWNhdGlvbi4NCj4+Pj4gSSBvcGVuZWQgYSBQUiB0aGF0IGRvZXMgdGhp
czoNCj4+Pj4gDQo+Pj4+ICAgIGh0dHBzOi8vZ2l0aHViLmNvbS9jZXBoL2NlcGgvcHVsbC8zMTc5
Ng0KPj4+PiANCj4+Pj4gSSBjYW4ndCByZW1lbWJlciBzZWVpbmcgJ252bWUnIGFzIGEgZGV2aWNl
IGNsYXNzIG9uIGFueSByZWFsIGNsdXN0ZXI7DQo+Pj4+IHRoZQ0KPj4+PiBleGNlcHRvaW4gaXMg
bXkgYmFzZW1lbnQgb25lLCBhbmQgSSB0aGluayB0aGUgb25seSByZWFzb24gaXQgZW5kZWQgdXAN
Cj4+Pj4gdGhhdA0KPj4+PiB3YXkgd2FzIGJlY2F1c2UgSSBkZXBsb3llZCBibHVlc3RvcmUgKnZl
cnkqIGVhcmx5IG9uICh3aXRoIGNlcGgtZGlzaykNCj4+Pj4gYW5kDQo+Pj4+IHRoZSBpc19udm1l
KCkgZGV0ZWN0aW9uIGhlbHBlciBkb2Vzbid0IHdvcmsgd2l0aCBMVk0uICBUaGF0J3MgbXkNCj4+
Pj4gdGhlb3J5IGF0DQo+Pj4+IGxlYXN0Li4gY2FuIGFueWJvZHkgd2l0aCBibHVlc3RvcmUgb24g
TlZNZSBkZXZpY2VzIGNvbmZpcm0/IERvZXMgYW55Ym9keQ0KPj4+PiBzZWUgY2xhc3MgJ252bWUn
IGRldmljZXMgaW4gdGhlaXIgY2x1c3Rlcj8NCj4+Pj4gDQo+Pj4+IFRoYW5rcyENCj4+Pj4gc2Fn
ZQ0KPj4+PiANCj4+PiANCj4+PiBIZXJlJ3Mgd2hhdCB3ZSd2ZSBnb3Qgb24gdGhlIG5ldyBwZXJm
b3JtYW5jZSBub2RlcyB3aXRoIEludGVsIE5WTWUNCj4+PiBkcml2ZXM6DQo+Pj4gDQo+Pj4gDQo+
Pj4gSUQgIENMQVNTIFdFSUdIVCAgIFRZUEUgTkFNRQ0KPj4+IC0xICAgICAgIDY0LjAwMDAwIHJv
b3QgZGVmYXVsdA0KPj4+IC0zICAgICAgIDY0LjAwMDAwICAgICByYWNrIGxvY2FscmFjaw0KPj4+
IC0yICAgICAgICA4LjAwMDAwICAgICAgICAgaG9zdCBvMDMNCj4+PiAgMCAgIHNzZCAgMS4wMDAw
MCAgICAgICAgICAgICBvc2QuMA0KPj4+ICAxICAgc3NkICAxLjAwMDAwICAgICAgICAgICAgIG9z
ZC4xDQo+Pj4gIDIgICBzc2QgIDEuMDAwMDAgICAgICAgICAgICAgb3NkLjINCj4+PiAgMyAgIHNz
ZCAgMS4wMDAwMCAgICAgICAgICAgICBvc2QuMw0KPj4+ICA0ICAgc3NkICAxLjAwMDAwICAgICAg
ICAgICAgIG9zZC40DQo+Pj4gIDUgICBzc2QgIDEuMDAwMDAgICAgICAgICAgICAgb3NkLjUNCj4+
PiAgNiAgIHNzZCAgMS4wMDAwMCAgICAgICAgICAgICBvc2QuNg0KPj4+ICA3ICAgc3NkICAxLjAw
MDAwICAgICAgICAgICAgIG9zZC43DQo+Pj4gDQo+Pj4gDQo+Pj4gTWFyaw0KPj4+IA0KPj4gDQo+
PiBJIHNob3VsZCBwcm9iYWJseSBjbGFyaWZ5IHRoYXQgdGhpcyBjbHVzdGVyIHdhcyBidWlsdCB3
aXRoIGNidCB0aG91Z2ghDQo+PiANCj4+IA0KPj4gTWFyaw0KPj4gX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCj4+IERldiBtYWlsaW5nIGxpc3QgLS0gZGV2
QGNlcGguaW8NCj4+IFRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8gZGV2LWxlYXZlQGNl
cGguaW8NCg==
