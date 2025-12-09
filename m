Return-Path: <ceph-devel+bounces-4168-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F20CAEE64
	for <lists+ceph-devel@lfdr.de>; Tue, 09 Dec 2025 05:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1A1330204BC
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Dec 2025 04:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B86F2D3A70;
	Tue,  9 Dec 2025 04:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="KFSZsLwt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D68E277818;
	Tue,  9 Dec 2025 04:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765255254; cv=none; b=j83xVfGknpdBRjAtLN/0WY8lmwazqBpn1IN8ACqDn7/Gdir8t3HhkX207KCR9tsIRWMo1eZQjfUBS2E1OW9ZZmUoBDdAN0lmau1JO4Cdy6Zf1VXXx4edWfhheE40Z+aQWsrcrCXbSDDspmPWUGXq1b/4ycAkYAAjgkNF9Cffcmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765255254; c=relaxed/simple;
	bh=b/lyRAfMAhaznejR+3YOxto/1WRFoywG4m0D6+y0xfM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=B92I5hQweJG8DDT+qT1J2na1YpztJsaKTKeZ2QNOba5ohyga/kwz89OaYU1BabA2Y8RlIq4c34IwdWcq8YnJEaz8i1BB2rrcY3+hdgJ3O7b5I4PryC0/C2oFFMllo7NZolCFF92t/d1BTNeUk0b4IujfRYGqrdp9Bls/XUMgb7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=KFSZsLwt; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=b/lyRAfMAhaznejR+3YOxto/1WRFoywG4m0D6+y0xfM=; b=K
	FSZsLwtXn9EqCBD2IFAAVeWcrT6LQgHmVNOpNf/FubOlMPJvfi5RO9H8WAKt4+VE
	7eGsOwD201zHWIvcPkFKJgKn0irJSmByVA08zsEfDm4+lE2k6Jpu5+Ok2FclZMNG
	5XNBJR7nrAebmEUAo9Cy+jS5OhKkrwKRUzymlOGotQ=
Received: from 00107082$163.com ( [111.35.191.189] ) by
 ajax-webmail-wmsvr-40-136 (Coremail) ; Tue, 9 Dec 2025 12:40:21 +0800 (CST)
Date: Tue, 9 Dec 2025 12:40:21 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Mal Haak" <malcolm@haak.id.au>
Cc: linux-kernel@vger.kernel.org, surenb@google.com, xiubli@redhat.com,
	idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: Possible memory leak in 6.17.7
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20250723(a044bf12) Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <20251209090831.13c7a639@xps15mal>
References: <20251110182008.71e0858b@xps15mal>
 <20251208110829.11840-1-00107082@163.com>
 <20251209090831.13c7a639@xps15mal>
X-NTES-SC: AL_Qu2dB/6eukop5ymYZ+kZnEYQheY4XMKyuPkg1YJXOp80sSbyyxwQWFpAB3rx8fmtKTqrkjOvUSZf2/Z/QbZUbr5ujdSov4nFh4MsVxh95GCy
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <17469653.4a75.19b01691299.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:iCgvCgCnc3A2qDdpNec0AA--.1358W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbCxhZfCmk3qDb9hQAA39
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkF0IDIwMjUtMTItMDkgMDc6MDg6MzEsICJNYWwgSGFhayIgPG1hbGNvbG1AaGFhay5pZC5hdT4g
d3JvdGU6Cj5PbiBNb24sICA4IERlYyAyMDI1IDE5OjA4OjI5ICswODAwCj5EYXZpZCBXYW5nIDww
MDEwNzA4MkAxNjMuY29tPiB3cm90ZToKPgo+PiBPbiBNb24sIDEwIE5vdiAyMDI1IDE4OjIwOjA4
ICsxMDAwCj4+IE1hbCBIYWFrIDxtYWxjb2xtQGhhYWsuaWQuYXU+IHdyb3RlOgo+PiA+IEhlbGxv
LAo+PiA+IAo+PiA+IEkgaGF2ZSBmb3VuZCBhIG1lbW9yeSBsZWFrIGluIDYuMTcuNyBidXQgSSBh
bSB1bnN1cmUgaG93IHRvIHRyYWNrIGl0Cj4+ID4gZG93biBlZmZlY3RpdmVseS4KPj4gPiAKPj4g
PiAgIAo+PiAKPj4gSSB0aGluayB0aGUgYG1lbW9yeSBhbGxvY2F0aW9uIHByb2ZpbGluZ2AgZmVh
dHVyZSBjYW4gaGVscC4KPj4gaHR0cHM6Ly9kb2NzLmtlcm5lbC5vcmcvbW0vYWxsb2NhdGlvbi1w
cm9maWxpbmcuaHRtbAo+PiAKPj4gWW91IHdvdWxkIG5lZWQgdG8gYnVpbGQgYSBrZXJuZWwgd2l0
aCAKPj4gQ09ORklHX01FTV9BTExPQ19QUk9GSUxJTkc9eQo+PiBDT05GSUdfTUVNX0FMTE9DX1BS
T0ZJTElOR19FTkFCTEVEX0JZX0RFRkFVTFQ9eQo+PiAKPj4gQW5kIGNoZWNrIC9wcm9jL2FsbG9j
aW5mbyBmb3IgdGhlIHN1c3BpY2lvdXMgYWxsb2NhdGlvbnMgd2hpY2ggdGFrZQo+PiBtb3JlIG1l
bW9yeSB0aGFuIGV4cGVjdGVkLgo+PiAKPj4gKEkgb25jZSBjYXVnaHQgYSBudmlkaWEgZHJpdmVy
IG1lbW9yeSBsZWFrLikKPj4gCj4+IAo+PiBGWUkKPj4gRGF2aWQKPj4gCj4KPlRoYW5rIHlvdSBm
b3IgeW91ciBzdWdnZXN0aW9uLiBJIGhhdmUgc29tZSByZXN1bHRzLgo+Cj5SYW4gdGhlIHJzeW5j
IHdvcmtsb2FkIGZvciBhYm91dCA5IGhvdXJzLiBJdCBzdGFydGVkIHRvIGxvb2sgbGlrZSBpdAo+
d2FzIGhhcHBlbmluZy4KPiMgc21lbSAtcHcKPkFyZWEgICAgICAgICAgICAgICAgICAgICAgICAg
ICBVc2VkICAgICAgQ2FjaGUgICBOb25jYWNoZSAKPmZpcm13YXJlL2hhcmR3YXJlICAgICAgICAg
ICAgIDAuMDAlICAgICAgMC4wMCUgICAgICAwLjAwJSAKPmtlcm5lbCBpbWFnZSAgICAgICAgICAg
ICAgICAgIDAuMDAlICAgICAgMC4wMCUgICAgICAwLjAwJSAKPmtlcm5lbCBkeW5hbWljIG1lbW9y
eSAgICAgICAgODAuNDYlICAgICA2NS44MCUgICAgIDE0LjY2JSAKPnVzZXJzcGFjZSBtZW1vcnkg
ICAgICAgICAgICAgIDAuMzUlICAgICAgMC4xNiUgICAgICAwLjE5JSAKPmZyZWUgbWVtb3J5ICAg
ICAgICAgICAgICAgICAgMTkuMTklICAgICAxOS4xOSUgICAgICAwLjAwJSAKPiMgc29ydCAtZyAv
cHJvYy9hbGxvY2luZm98dGFpbHxudW1mbXQgLS10bz1pZWMKPiAgICAgICAgIDIyTSAgICAgNTYw
OSBtbS9tZW1vcnkuYzoxMTkwIGZ1bmM6Zm9saW9fcHJlYWxsb2MgCj4gICAgICAgICAyM00gICAg
IDE5MzIgZnMveGZzL3hmc19idWYuYzoyMjYgW3hmc10KPmZ1bmM6eGZzX2J1Zl9hbGxvY19iYWNr
aW5nX21lbSAKPiAgICAgICAgIDI0TSAgICAyNDEzNSBmcy94ZnMveGZzX2ljYWNoZS5jOjk3IFt4
ZnNdIGZ1bmM6eGZzX2lub2RlX2FsbG9jIAo+ICAgICAgICAgMjdNICAgICA2NjkzIG1tL21lbW9y
eS5jOjExOTIgZnVuYzpmb2xpb19wcmVhbGxvYyAKPiAgICAgICAgIDU4TSAgICAxNDc4NCBtbS9w
YWdlX2V4dC5jOjI3MSBmdW5jOmFsbG9jX3BhZ2VfZXh0IAo+ICAgICAgICAyNThNICAgICAgMTI5
IG1tL2todWdlcGFnZWQuYzoxMDY5IGZ1bmM6YWxsb2NfY2hhcmdlX2ZvbGlvIAo+ICAgICAgICA0
MzBNICAgNzcwNzg4IGxpYi94YXJyYXkuYzozNzggZnVuYzp4YXNfYWxsb2MgCj4gICAgICAgIDU0
NU0gICAgMzY0NDQgbW0vc2x1Yi5jOjMwNTkgZnVuYzphbGxvY19zbGFiX3BhZ2UgCj4gICAgICAg
IDkuOEcgIDI1NjM2MTcgbW0vcmVhZGFoZWFkLmM6MTg5IGZ1bmM6cmFjdGxfYWxsb2NfZm9saW8g
Cj4gICAgICAgICAyMEcgIDUxNjQwMDQgbW0vZmlsZW1hcC5jOjIwMTIgZnVuYzpfX2ZpbGVtYXBf
Z2V0X2ZvbGlvIAo+Cj4KPlNvIEkgc3RvcHBlZCB0aGUgd29ya2xvYWQgYW5kIGRyb3BwZWQgY2Fj
aGVzIHRvIGNvbmZpcm0uCj4KPiMgZWNobyAzID4gL3Byb2Mvc3lzL3ZtL2Ryb3BfY2FjaGVzCj4j
IHNtZW0gLXB3Cj5BcmVhICAgICAgICAgICAgICAgICAgICAgICAgICAgVXNlZCAgICAgIENhY2hl
ICAgTm9uY2FjaGUgCj5maXJtd2FyZS9oYXJkd2FyZSAgICAgICAgICAgICAwLjAwJSAgICAgIDAu
MDAlICAgICAgMC4wMCUgCj5rZXJuZWwgaW1hZ2UgICAgICAgICAgICAgICAgICAwLjAwJSAgICAg
IDAuMDAlICAgICAgMC4wMCUgCj5rZXJuZWwgZHluYW1pYyBtZW1vcnkgICAgICAgIDMzLjQ1JSAg
ICAgIDAuMDklICAgICAzMy4zNiUgCj51c2Vyc3BhY2UgbWVtb3J5ICAgICAgICAgICAgICAwLjM2
JSAgICAgIDAuMTYlICAgICAgMC4xOSUgCj5mcmVlIG1lbW9yeSAgICAgICAgICAgICAgICAgIDY2
LjIwJSAgICAgNjYuMjAlICAgICAgMC4wMCUgCj4jIHNvcnQgLWcgL3Byb2MvYWxsb2NpbmZvfHRh
aWx8bnVtZm10IC0tdG89aWVjCj4gICAgICAgICAxMk0gICAgIDI5ODcgbW0vZXhlY21lbS5jOjQx
IGZ1bmM6ZXhlY21lbV92bWFsbG9jIAo+ICAgICAgICAgMTJNICAgICAgICAzIGtlcm5lbC9kbWEv
cG9vbC5jOjk2IGZ1bmM6YXRvbWljX3Bvb2xfZXhwYW5kIAo+ICAgICAgICAgMTNNICAgICAgNzUx
IG1tL3NsdWIuYzozMDYxIGZ1bmM6YWxsb2Nfc2xhYl9wYWdlIAo+ICAgICAgICAgMTZNICAgICAg
ICA4IG1tL2todWdlcGFnZWQuYzoxMDY5IGZ1bmM6YWxsb2NfY2hhcmdlX2ZvbGlvIAo+ICAgICAg
ICAgMThNICAgICA0MzU1IG1tL21lbW9yeS5jOjExOTAgZnVuYzpmb2xpb19wcmVhbGxvYyAKPiAg
ICAgICAgIDI0TSAgICAgNjExOSBtbS9tZW1vcnkuYzoxMTkyIGZ1bmM6Zm9saW9fcHJlYWxsb2Mg
Cj4gICAgICAgICA1OE0gICAgMTQ3ODQgbW0vcGFnZV9leHQuYzoyNzEgZnVuYzphbGxvY19wYWdl
X2V4dCAKPiAgICAgICAgIDYxTSAgICAxNTQ0OCBtbS9yZWFkYWhlYWQuYzoxODkgZnVuYzpyYWN0
bF9hbGxvY19mb2xpbyAKPiAgICAgICAgIDc5TSAgICAgNjcyNiBtbS9zbHViLmM6MzA1OSBmdW5j
OmFsbG9jX3NsYWJfcGFnZSAKPiAgICAgICAgIDExRyAgMjY3NDQ4OCBtbS9maWxlbWFwLmM6MjAx
MiBmdW5jOl9fZmlsZW1hcF9nZXRfZm9saW8KPgo+U28gaWYgSSdtIHJlYWRpbmcgdGhpcyBjb3Jy
ZWN0bHkgc29tZXRoaW5nIGlzIGNhdXNpbmcgZm9saW9zIGNvbGxlY3QKPmFuZCBub3QgYmUgYWJs
ZSB0byBiZSBmcmVlZD8KCkNDIGNlcGhmcywgbWF5YmUgc29tZW9uZSBjb3VsZCBoYXZlIGFuIGVh
c3kgcmVhZGluZyBvdXQgb2YgdGhvc2UgZm9saW8gdXNhZ2UKCgo+Cj5BbHNvIGl0J3MgY2xlYXIg
dGhhdCBzb21lIG9mIHRoZSBmb2xpbydzIGFyZSBjb3VudGluZyBhcyBjYWNoZSBhbmQgc29tZQo+
YXJlbid0LiAKPgo+TGlrZSBJIHNhaWQgNi4xNyBhbmQgNi4xOCBib3RoIGhhdmUgdGhlIGlzc3Vl
LiA2LjEyIGRvZXMgbm90LiBJJ20gbm93Cj5nb2luZyB0byBtYW51YWxseSB3YWxrIHRocm91Z2gg
cHJldmlvdXMga2VybmVsIHJlbGVhc2VzIGFuZCBmaW5kCj53aGVyZSBpdCBmaXJzdCBzdGFydHMg
aGFwcGVuaW5nIHB1cmVseSBiZWNhdXNlIEknbSBoYXZpbmcgaXNzdWVzCj5idWlsZGluZyBlYXJs
aWVyIGtlcm5lbHMgZHVlIHRvIHJ1c3Qgc3R1ZmYgYW5kIG90aGVyIHB5dGhvbgo+aW5jb21wYXRp
YmlsaXRpZXMgbWFraW5nIGRvaW5nIGEgZ2l0LWJpc2VjdCBhIGJpdCBmdW4uCj4KPkknbGwgZG8g
aXQgdGhlIHBhY2thZ2VzIHdheSB1bnRpbCBJIGdldCBjbG9zZXIsIHRoZW4gc29sdmUgdGhlIGJ1
aWxkCj5pc3N1ZXMuIAo+Cj5UaGFua3MsCj5NYWwKPgo=

