Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37309177BE8
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Mar 2020 17:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgCCQ2r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Mar 2020 11:28:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:47368 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbgCCQ2r (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 11:28:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 08:28:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="287035804"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Mar 2020 08:28:33 -0800
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 3 Mar 2020 08:28:33 -0800
Received: from cdsmsx152.ccr.corp.intel.com (172.17.4.41) by
 fmsmsx109.amr.corp.intel.com (10.18.116.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 3 Mar 2020 08:28:32 -0800
Received: from cdsmsx102.ccr.corp.intel.com ([169.254.2.116]) by
 CDSMSX152.ccr.corp.intel.com ([169.254.6.127]) with mapi id 14.03.0439.000;
 Wed, 4 Mar 2020 00:28:30 +0800
From:   "Chen, Haochuan Z" <haochuan.z.chen@intel.com>
To:     Gregory Farnum <gfarnum@redhat.com>
CC:     "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "dev@ceph.io" <dev@ceph.io>
Subject: RE: question for ceph study
Thread-Topic: question for ceph study
Thread-Index: AdXxd290JfXpZ+igRgeZvlpwmk4HDv//e0MA//94y7A=
Date:   Tue, 3 Mar 2020 16:28:29 +0000
Message-ID: <56829C2A36C2E542B0CCB9854828E4D8562BAF24@CDSMSX102.ccr.corp.intel.com>
References: <56829C2A36C2E542B0CCB9854828E4D8562BAEEB@CDSMSX102.ccr.corp.intel.com>
 <CAJ4mKGZR2Vrbc=OhR-i3bo7US544fRQ+2=W92JdqCsYED_oAWg@mail.gmail.com>
In-Reply-To: <CAJ4mKGZR2Vrbc=OhR-i3bo7US544fRQ+2=W92JdqCsYED_oAWg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.17.6.105]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

R3JlYXQgdGhhbmtzIEdyZWchDQoNCk9uZSBtb3JlIHF1ZXN0aW9uLCBtYWdpYyBpcyBjcmVhdGVk
IGJ5IGNlcGgtbW9uIC0tbWtmcz8gDQoNCk1hcnRpbiwgQ2hlbg0KSU9URywgU29mdHdhcmUgRW5n
aW5lZXINCjAyMS02MTE2NDMzMA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTog
R3JlZ29yeSBGYXJudW0gPGdmYXJudW1AcmVkaGF0LmNvbT4gDQpTZW50OiBXZWRuZXNkYXksIE1h
cmNoIDQsIDIwMjAgMTI6MjQgQU0NClRvOiBDaGVuLCBIYW9jaHVhbiBaIDxoYW9jaHVhbi56LmNo
ZW5AaW50ZWwuY29tPg0KQ2M6IGNlcGgtZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBkZXZAY2VwaC5p
bw0KU3ViamVjdDogUmU6IHF1ZXN0aW9uIGZvciBjZXBoIHN0dWR5DQoNCkl0J3MganVzdCBhbiBh
cmJpdHJhcnkgdmFsdWUgdG8gdHJ5IGFuZCBpZGVudGlmeSB0aGUgc3RvcmUgaXMgcmVhbGx5IHRo
ZXJlLiBJICp0aGluayogaXQncyBtb3N0bHkgYWJvdXQgZ3VhcmFudGVlaW5nIHRoYXQgdGhlIG1v
bml0b3Igc3RvcmUgaGFzIGJlZW4gY29tcGxldGVseSBzZXQgdXAgKGllLCB0aGUgc3RvcmUgaXMg
ZnVsbHkgY3JlYXRlZCBhbmQgeW91IGNhbiB1c2UgaXQpLCBidXQgSSBtYXkgYmUgZm9yZ2V0dGlu
ZyBzb21ldGhpbmcuDQoNCkJ1dCBpdCdzIG9mIHZlcnkgbGl0dGxlIGltcG9ydGFuY2UgaW4gdGhl
IG9yZGluYXJ5IGNvdXJzZSBvZiBldmVudHMuDQotR3JlZw0KDQpPbiBUdWUsIE1hciAzLCAyMDIw
IGF0IDg6MjAgQU0gQ2hlbiwgSGFvY2h1YW4gWiA8aGFvY2h1YW4uei5jaGVuQGludGVsLmNvbT4g
d3JvdGU6DQo+DQo+IEhpDQo+DQo+DQo+DQo+IEkgYW0gYSByb29raWUsIG9uZSBxdWVzdGlvbi4g
d2hhdCdzIG1hZ2ljIGluIG1vbml0b3IgZGF0YT8gV2hhdOKAmXMgdGhlIHVzYWdlIG9mIG1hZ2lj
Pw0KPg0KPg0KPg0KPiBUaGFua3MNCj4NCj4NCj4NCj4gTWFydGluLCBDaGVuDQo+DQo+IElPVEcs
IFNvZnR3YXJlIEVuZ2luZWVyDQo+DQo+IDAyMS02MTE2NDMzMA0KPg0KPg0KPg0KPiBfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBEZXYgbWFpbGluZyBs
aXN0IC0tIGRldkBjZXBoLmlvDQo+IFRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8gZGV2
LWxlYXZlQGNlcGguaW8NCg0K
