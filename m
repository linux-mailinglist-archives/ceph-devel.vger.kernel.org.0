Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7EA488BC1
	for <lists+ceph-devel@lfdr.de>; Sun,  9 Jan 2022 19:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbiAISv3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 9 Jan 2022 13:51:29 -0500
Received: from stumail2.scut.edu.cn ([202.38.213.12]:51550 "EHLO
        mail.scut.edu.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234502AbiAISv2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 9 Jan 2022 13:51:28 -0500
X-Greylist: delayed 1998 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jan 2022 13:51:27 EST
Received: by ajax-webmail-main (Coremail) ; Mon, 10 Jan 2022 02:50:30 +0800
 (GMT+08:00)
X-Originating-IP: [125.216.246.30]
Date:   Mon, 10 Jan 2022 02:50:30 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?6IOh546u5paH?= <sehuww@mail.scut.edu.cn>
To:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: dmesg: mdsc_handle_reply got x on session mds1 not mds0
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn stumaildemo.scut.edu.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <1eddfcdd.3386.17e402d7e9f.Coremail.sehuww@mail.scut.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwDHnvR2LtthuoudAA--.4457W
X-CM-SenderInfo: qsqrljqqwxllyrt6zt1loo2ulxwovvfxof0/1tbiAQABBlepTBw+v
        QAAsr
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

SGkgY2VwaCBkZXZlbG9wZXJzLAoKVG9kYXkgd2UgZ290IG9uZSBvZiBvdXIgT1NEIGhvc3RzIGhh
bmcgb24gT09NLiBTb21lIE9TRHMgd2VyZSBmbGFwcGluZyBhbmQgZXZlbnR1YWxseSB3ZW50IGRv
d24gYW5kIG91dC4gVGhlIHJlY292ZXJ5IGNhdXNlZCBvbmUgT1NEIHRvIGdvIGZ1bGwsIHdoaWNo
IGlzIHVzZWQgaW4gYm90aCBjZXBoZnMgbWV0YWRhdGEgYW5kIGRhdGEgcG9vbHMuCgpUaGUgc3Ry
YW5nZSB0aGluZyBpczoKKiBNYW55IG9mIG91ciB1c2VycyByZXBvcnQgdW5leHBlY3RlZCDigJxQ
ZXJtaXNzaW9uIGRlbmllZOKAnSBlcnJvciB3aGVuIGNyZWF0aW5nIG5ldyBmaWxlcwoqIGRtZXNn
IGhhcyBzb21lIHN0cmFuZ2UgZXJyb3IgKHNlZSBleGFtcGxlcyBiZWxvdykuIER1cmluZyB0aGF0
IHRpbWUsIG5vIHNwZWNpYWwgbG9ncyBvbiBib3RoIGFjdGl2ZSBNRFNlcy4KKiBUaGUgYWJvdmUg
dHdvIHN0cmFuZ2UgdGhpbmdzIGhhcHBlbnMgQkVGT1JFIHRoZSBPU0QgZ290IGZ1bGwuCgpKYW4g
MDkgMDE6Mjc6MTMgZ3B1MDI3IGtlcm5lbDogbGliY2VwaDogb3NkOSB1cApKYW4gMDkgMDE6Mjc6
MTMgZ3B1MDI3IGtlcm5lbDogbGliY2VwaDogb3NkMTAgdXAKSmFuIDA5IDAxOjI4OjU1IGdwdTAy
NyBrZXJuZWw6IGxpYmNlcGg6IG9zZDkgZG93bgpKYW4gMDkgMDE6Mjg6NTUgZ3B1MDI3IGtlcm5l
bDogbGliY2VwaDogb3NkMTAgZG93bgpKYW4gMDkgMDE6MzI6MzUgZ3B1MDI3IGtlcm5lbDogbGli
Y2VwaDogb3NkNiB3ZWlnaHQgMHgwIChvdXQpCkphbiAwOSAwMTozMjozNSBncHUwMjcga2VybmVs
OiBsaWJjZXBoOiBvc2QxNiB3ZWlnaHQgMHgwIChvdXQpCkphbiAwOSAwMTozNDoxOCBncHUwMjcg
a2VybmVsOiBsaWJjZXBoOiBvc2QxIHdlaWdodCAweDAgKG91dCkKSmFuIDA5IDAxOjM5OjIwIGdw
dTAyNyBrZXJuZWw6IGxpYmNlcGg6IG9zZDkgd2VpZ2h0IDB4MCAob3V0KQpKYW4gMDkgMDE6Mzk6
MjAgZ3B1MDI3IGtlcm5lbDogbGliY2VwaDogb3NkMTAgd2VpZ2h0IDB4MCAob3V0KQpKYW4gMDkg
MDE6NTM6MDcgZ3B1MDI3IGtlcm5lbDogY2VwaDogbWRzY19oYW5kbGVfcmVwbHkgZ290IDMwNDA4
OTkxIG9uIHNlc3Npb24gbWRzMSBub3QgbWRzMApKYW4gMDkgMDE6NTM6MTQgZ3B1MDI3IGtlcm5l
bDogY2VwaDogbWRzY19oYW5kbGVfcmVwbHkgZ290IDMwNDA5ODI5IG9uIHNlc3Npb24gbWRzMSBu
b3QgbWRzMApKYW4gMDkgMDE6NTM6MTUgZ3B1MDI3IGtlcm5lbDogY2VwaDogbWRzY19oYW5kbGVf
cmVwbHkgZ290IDMwNDA5OTI1IG9uIHNlc3Npb24gbWRzMSBub3QgbWRzMApKYW4gMDkgMDE6NTM6
MjggZ3B1MDI3IGtlcm5lbDogY2VwaDogbWRzY19oYW5kbGVfcmVwbHkgZ290IDMwNDExNDE2IG9u
IHNlc3Npb24gbWRzMSBub3QgbWRzMApKYW4gMDkgMDI6MDU6MDcgZ3B1MDI3IGtlcm5lbDogY2Vw
aDogbWRzY19oYW5kbGVfcmVwbHkgZ290IDMwNDE3NzQyIG9uIHNlc3Npb24gbWRzMCBub3QgbWRz
MQpKYW4gMDkgMDI6NDg6NTIgZ3B1MDI3IGtlcm5lbDogY2VwaDogbWRzY19oYW5kbGVfcmVwbHkg
Z290IDMwNDQ5MTc3IG9uIHNlc3Npb24gbWRzMSBub3QgbWRzMApKYW4gMDkgMDI6NDk6MTcgZ3B1
MDI3IGtlcm5lbDogY2VwaDogbWRzY19oYW5kbGVfcmVwbHkgZ290IDMwNDUyNzUwIG9uIHNlc3Np
b24gbWRzMSBub3QgbWRzMAoKQWZ0ZXIgcmVhZGluZyB0aGUgY29kZSwgdGhlIHJlcGxpZXMgYXJl
IHVuZXhwZWN0ZWQgYW5kIGp1c3QgZHJvcHBlZC4gQW55IGlkZWFzIGFib3V0IGhvdyB0aGlzIGNv
dWxkIGhhcHBlbj8gQW5kIGlzIHRoZXJlIGFueXRoaW5nIEkgbmVlZCB0byB3b3JyeSBhYm91dD8g
KFRoZSBjbHVzdGVyIGlzIG5vdyByZWNvdmVyZWQgYW5kIGxvb2tzIGdvb2QpCgpUaGUgY2xpZW50
cyBhcmUgVWJ1bnR1IDIwLjA0IHdpdGgga2VybmVsIDUuMTEuMC00My1nZW5lcmljLiBDZXBoIHZl
cnNpb24gaXMgMTYuMi43LiBObyBhY3RpdmUgTURTIHJlc3RhcnRzIGR1cmluZyB0aGF0IHRpbWUu
IFN0YW5kYnktcmVwbGF5IE1EU2VzIGRpZCByZXN0YXJ0LCB3aGljaCBzaG91bGQgYmUgZml4ZWQg
YnkgbXkgUFIgaHR0cHM6Ly9naXRodWIuY29tL2NlcGgvY2VwaC9wdWxsLzQ0NTAxIC4gQnV0IEkg
ZG9u4oCZdCBrbm93IGlmIGl0IGlzIHJlbGF0ZWQgdG8gdGhlIGlzc3VlIGhlcmUuCgpTb3JyeSBp
ZiB5b3Ugc2VlIHRoaXMgdHdpY2UuIEkgcmVzZW5kIGl0IGFmdGVyIHN1YnNjcmliaW5nIHRvIGRl
dkBjZXBoLmlvCgpSZWdhcmRzLApXZWl3ZW4gSHU=
