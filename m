Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D1A1A2246
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 14:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgDHMsJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 08:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgDHMsJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Apr 2020 08:48:09 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9CC2051A;
        Wed,  8 Apr 2020 12:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586350087;
        bh=dF8dHlzk3bcm1ETug3kWLwdhdbIxP6evPSFrG49m/bo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J24lK/wUvtnEXf3bdS+7aZsKcWpxnlXqexLmGUF/PYHVFLOOcfUs031bTsCh+Ka09
         HSWA0sRYUqd7aOn3VEVthqDxEVfoYP1/JYYwXnnTi9mZh1ivlS6nyWsbYuVWHHWff+
         RI4z5ql/YzBxSjtmGT5wd/nt555ZjHl0VhgAYVwg=
Message-ID: <7114ea60738d083e618ac35beb840afeea74fce1.camel@kernel.org>
Subject: Re: [bug report] ceph: attempt to do async create when possible
From:   Jeff Layton <jlayton@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 08 Apr 2020 08:48:05 -0400
In-Reply-To: <20200408112201.GN2066@kadam>
References: <20200408111734.GA252918@mwanda> <20200408112201.GN2066@kadam>
Content-Type: multipart/mixed; boundary="=-QuOjH1hvVegpupHIFW8M"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--=-QuOjH1hvVegpupHIFW8M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2020-04-08 at 14:22 +0300, Dan Carpenter wrote:
> On Wed, Apr 08, 2020 at 02:17:34PM +0300, Dan Carpenter wrote:
> > Hello Jeff Layton,
> > 
> > The patch 9a8d03ca2e2c: "ceph: attempt to do async create when
> > possible" from Nov 27, 2019, leads to the following static checker
> > warning:
> > 
> > 	fs/ceph/file.c:540 ceph_async_create_cb()
> > 	error: uninitialized symbol 'base'.
> 
> Sorry, see the unlink function as well.
> 
>     fs/ceph/dir.c:1072 ceph_async_unlink_cb()
>     error: uninitialized symbol 'pathlen'.
> 
> regards,
> dan carpenter
> 

Many thanks, Dan!

I think the right thing to do is probably to just make
ceph_mdsc_free_path not do anything when it gets a IS_ERR value. At the
same time, this is also an error path, so we might as well initialize
the values we're passing into ceph_mdsc_build_path to make sure the
warnings look sane. See the attached two patches.

Since this code is not upstream yet, I'll probably just move the first
one to be before the async create/delete patches go in, and squash the
second one into the respective patches that add that functionality so we
don't have any regressions.

Sound ok?
-- 
Jeff Layton <jlayton@kernel.org>

--=-QuOjH1hvVegpupHIFW8M
Content-Disposition: attachment;
	filename*0=0001-ceph-have-ceph_mdsc_free_path-ignore-ERR_PTR-values.patc;
	filename*1=h
Content-Type: text/x-patch;
	name="0001-ceph-have-ceph_mdsc_free_path-ignore-ERR_PTR-values.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAwNmU4OTI5NjEwMTNjZmJkNmY0ODIzOTc5NDY2OWJhMzRiODEyMDUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPgpEYXRl
OiBXZWQsIDggQXByIDIwMjAgMDg6NDA6MzMgLTA0MDAKU3ViamVjdDogW1BBVENIIDEvMl0gY2Vw
aDogaGF2ZSBjZXBoX21kc2NfZnJlZV9wYXRoIGlnbm9yZSBFUlJfUFRSIHZhbHVlcwoKVGhpcyBt
YWtlcyB0aGUgZXJyb3IgaGFuZGxpbmcgc2ltcGxlciBpbiBzb21lIGNhbGxlcnMuCgpTaWduZWQt
b2ZmLWJ5OiBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPgotLS0KIGZzL2NlcGgvbWRz
X2NsaWVudC5oIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2VwaC9tZHNfY2xpZW50LmggYi9mcy9jZXBoL21kc19j
bGllbnQuaAppbmRleCAxYjQwZjMwZTBhOGUuLjc1NGUwNjgyMzk4ZSAxMDA2NDQKLS0tIGEvZnMv
Y2VwaC9tZHNfY2xpZW50LmgKKysrIGIvZnMvY2VwaC9tZHNfY2xpZW50LmgKQEAgLTUzMSw3ICs1
MzEsNyBAQCBleHRlcm4gdm9pZCBjZXBoX21kc2NfcHJlX3Vtb3VudChzdHJ1Y3QgY2VwaF9tZHNf
Y2xpZW50ICptZHNjKTsKIAogc3RhdGljIGlubGluZSB2b2lkIGNlcGhfbWRzY19mcmVlX3BhdGgo
Y2hhciAqcGF0aCwgaW50IGxlbikKIHsKLQlpZiAocGF0aCkKKwlpZiAocGF0aCAmJiAhSVNfRVJS
KHBhdGgpKQogCQlfX3B1dG5hbWUocGF0aCAtIChQQVRIX01BWCAtIDEgLSBsZW4pKTsKIH0KIAot
LSAKMi4yNS4yCgo=


--=-QuOjH1hvVegpupHIFW8M
Content-Disposition: attachment;
	filename*0=0002-SQUASH-initialize-path-and-base-values-in-async-diro.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0002-SQUASH-initialize-path-and-base-values-in-async-diro.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAwNjZmNjlkZmQ3OGEyMGFkOWFhNWY3ZTM4N2RhNjg4NmM4NDEwY2UyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPgpEYXRl
OiBXZWQsIDggQXByIDIwMjAgMDg6NDE6MzggLTA0MDAKU3ViamVjdDogW1BBVENIIDIvMl0gU1FV
QVNIOiBpbml0aWFsaXplIHBhdGggYW5kIGJhc2UgdmFsdWVzIGluIGFzeW5jIGRpcm9wcwogY2In
cwoKUmVwb3J0ZWQtYnk6IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4K
U2lnbmVkLW9mZi1ieTogSmVmZiBMYXl0b24gPGpsYXl0b25Aa2VybmVsLm9yZz4KLS0tCiBmcy9j
ZXBoL2Rpci5jICB8IDQgKystLQogZnMvY2VwaC9maWxlLmMgfCA0ICsrLS0KIDIgZmlsZXMgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2Nl
cGgvZGlyLmMgYi9mcy9jZXBoL2Rpci5jCmluZGV4IDlkMDJkNGZlYjY5My4uMzlmNTMxMTQwNGIw
IDEwMDY0NAotLS0gYS9mcy9jZXBoL2Rpci5jCisrKyBiL2ZzL2NlcGgvZGlyLmMKQEAgLTEwNTcs
OCArMTA1Nyw4IEBAIHN0YXRpYyB2b2lkIGNlcGhfYXN5bmNfdW5saW5rX2NiKHN0cnVjdCBjZXBo
X21kc19jbGllbnQgKm1kc2MsCiAKIAkvKiBJZiBvcCBmYWlsZWQsIG1hcmsgZXZlcnlvbmUgaW52
b2x2ZWQgZm9yIGVycm9ycyAqLwogCWlmIChyZXN1bHQpIHsKLQkJaW50IHBhdGhsZW47Ci0JCXU2
NCBiYXNlOworCQlpbnQgcGF0aGxlbiA9IDA7CisJCXU2NCBiYXNlID0gMDsKIAkJY2hhciAqcGF0
aCA9IGNlcGhfbWRzY19idWlsZF9wYXRoKHJlcS0+cl9kZW50cnksICZwYXRobGVuLAogCQkJCQkJ
ICAmYmFzZSwgMCk7CiAKZGlmZiAtLWdpdCBhL2ZzL2NlcGgvZmlsZS5jIGIvZnMvY2VwaC9maWxl
LmMKaW5kZXggM2ExYmQxM2RlODRmLi4xNjA2NDRkZGFlZWQgMTAwNjQ0Ci0tLSBhL2ZzL2NlcGgv
ZmlsZS5jCisrKyBiL2ZzL2NlcGgvZmlsZS5jCkBAIC01MjksOCArNTI5LDggQEAgc3RhdGljIHZv
aWQgY2VwaF9hc3luY19jcmVhdGVfY2Ioc3RydWN0IGNlcGhfbWRzX2NsaWVudCAqbWRzYywKIAog
CWlmIChyZXN1bHQpIHsKIAkJc3RydWN0IGRlbnRyeSAqZGVudHJ5ID0gcmVxLT5yX2RlbnRyeTsK
LQkJaW50IHBhdGhsZW47Ci0JCXU2NCBiYXNlOworCQlpbnQgcGF0aGxlbiA9IDA7CisJCXU2NCBi
YXNlID0gMDsKIAkJY2hhciAqcGF0aCA9IGNlcGhfbWRzY19idWlsZF9wYXRoKHJlcS0+cl9kZW50
cnksICZwYXRobGVuLAogCQkJCQkJICAmYmFzZSwgMCk7CiAKLS0gCjIuMjUuMgoK


--=-QuOjH1hvVegpupHIFW8M--

