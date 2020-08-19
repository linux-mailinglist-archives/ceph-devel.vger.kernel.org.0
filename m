Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBDD249917
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 11:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgHSJMF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 05:12:05 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3484 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726630AbgHSJME (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 05:12:04 -0400
Received: from dggeme701-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 494607D03E04ADF6B140;
        Wed, 19 Aug 2020 17:12:02 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme701-chm.china.huawei.com (10.1.199.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 19 Aug 2020 17:12:02 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Wed, 19 Aug 2020 17:12:01 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Ilya Dryomov <idryomov@gmail.com>
CC:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: Convert to use the preferred fallthrough macro
Thread-Topic: [PATCH] ceph: Convert to use the preferred fallthrough macro
Thread-Index: AdZ2CIBSTTAHQIOHYEu6sY48YQCZSg==
Date:   Wed, 19 Aug 2020 09:12:01 +0000
Message-ID: <20c98648546841528d72bdd62308b415@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.142]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

SWx5YSBEcnlvbW92IDxpZHJ5b21vdkBnbWFpbC5jb20+IHdyb3RlOg0KPk9uIFdlZCwgQXVnIDE5
LCAyMDIwIGF0IDEwOjUzIEFNIE1pYW9oZSBMaW4gPGxpbm1pYW9oZUBodWF3ZWkuY29tPiB3cm90
ZToNCj4+DQo+PiBDb252ZXJ0IHRoZSB1c2VzIG9mIGZhbGx0aHJvdWdoIGNvbW1lbnRzIHRvIGZh
bGx0aHJvdWdoIG1hY3JvLg0KPj4NCj4NCj5IaSBNaWFvaGUsDQo+DQo+SSd2ZSBhbHJlYWR5IGRv
bmUgdGhhdCwgZm9sZGluZyBpbnRvIHlvdXIgcHJldmlvdXMgcGF0Y2g6DQo+DQo+ICBodHRwczov
L2dpdGh1Yi5jb20vY2VwaC9jZXBoLWNsaWVudC9jb21taXQvM2YxOWFlODk1NDdkZjFiOGNjYmEz
NTlhMmY3ZGRiYTBmMTA4ZmZiZA0KPg0KPlRoYW5rcywNCj4NCj4gICAgICAgICAgICAgICAgSWx5
YQ0KDQpNYW55IHRoYW5rcy4gSSB0aG91Z2h0IEkgd2FzIHJlcXVlc3RlZCB0byBkbyB0aGlzLiBN
eSBtaXN0YWtlLiA6KQ0KDQo=
