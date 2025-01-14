Return-Path: <ceph-devel+bounces-2441-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C2BA113EC
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 23:13:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22E81188B11B
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 22:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FA8204590;
	Tue, 14 Jan 2025 22:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b="Zuo9JdCg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lesviallon.fr (89-95-58-186.abo.bbox.fr [89.95.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D681487DD
	for <ceph-devel@vger.kernel.org>; Tue, 14 Jan 2025 22:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.95.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736892808; cv=none; b=MiMc3JzUSb+VHkBL4z5N0v2f35pzgyooYcwNmgstlu4e/lKa16JWRDN0gafmwaShRYu5/f4C17rkPgktSDFbGt1SLYD4vjZ0oo9f83dgfuQH4vAE0PIcBvYAnRQWtmviitCXjHNOkz0wE5xZZXXnReMAAAEUmdEDTl5WweLOF1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736892808; c=relaxed/simple;
	bh=FsHIFEuOAmDsayPyf2Ol3ORcCDQmmTPu8pghoNyrKWU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=efrw/BZ/PvMygNJodAqWoYnNKB03gHNRfAgFdgNA568Wcbe4oh3wzTsn0bbnd7KWd7BvbgitYckjkVF8+KTFWGM8ayV6rMcynojxPMS6qRkwiaShJQ+SEcxyooYpO/Mgr6NZ1eIf32rscqHNn9+mFSU/acvZ/IObBnt2amfN3Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr; spf=pass smtp.mailfrom=lesviallon.fr; dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b=Zuo9JdCg; arc=none smtp.client-ip=89.95.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lesviallon.fr
Message-ID: <e0867174-3c3f-4ddb-b84b-12706e0c63bf@lesviallon.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lesviallon.fr;
	s=dkim; t=1736892801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FsHIFEuOAmDsayPyf2Ol3ORcCDQmmTPu8pghoNyrKWU=;
	b=Zuo9JdCgbvw2w4wqk4AC1KrVzv/pXQzkgKwuYEXtIclJgRaGx7mU5JR5PPQMn0pw+MDtOf
	svWHOkx1BANME39X1NQbBQ0DhugQNIGODBZY/kOj8B32XUWw1eA3n86NYay3abY5KOoQJu
	kegbFbLwI/8ms97Hib7jo84grCu7QEQ=
Authentication-Results: lesviallon.fr;
	auth=pass smtp.mailfrom=antoine@lesviallon.fr
Date: Tue, 14 Jan 2025 23:13:20 +0100
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Antoine Viallon <antoine@lesviallon.fr>
Subject: Re: [PATCH] ceph: fix memory leak in ceph_mds_auth_match()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, ceph-devel@vger.kernel.org
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
 <4f32ab766770af99ce9585bdb54e875f7e656588.camel@ibm.com>
Content-Language: en-US
Autocrypt: addr=antoine@lesviallon.fr; keydata=
 xsBNBFsTKV8BCAC5m5cLL2RhcJK5H8kWmrwJ9TwlqAPIPe0+7Nr9D9vbyqoW4O407aBxspWZ
 Ipwxe+1fhocUlKVC8UYiD3PuTNoOAwbdypsahrFPSytFk4rFQ17KYJKc4SLClTJ76JzGSGux
 5fHoASjMGH5t4UY3dEzU7bNvGKsmbFFmZJ8XxSzae2FedPptNZ1NNK8Fd5ymD0o0sC+JFeHv
 golhDqdkvhIc3wW++SoPwRx2tIwoeIErMmZzG/dBbPfrEXmNmAtuqo3+CSk3ETFdV0W5laTU
 Nl42rBmTBiGD6+48AqzT36sJwP9ILcTPz0r3aKY8oJNgSiRuE1dkwo/9J9lopQe0YQm1ABEB
 AAHNJ0FudG9pbmUgVmlhbGxvbiA8YW50b2luZUBsZXN2aWFsbG9uLmZyPsLAlAQTAQgAPgIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBErEoo1yCPxvK1FeqdEmsTq1VeFvBQJmorug
 BQkRMyzBAAoJENEmsTq1VeFvs5EIAIsijg474qXk599K0b7EozfFiGuyg3Ms5iW8or3bqFHC
 4yr/XGEuhQt9Z/Dvr+AtpL7dAfoZl35dWe1EzqE/IVaiIzwTRa2MSsXflusKn3Pc+JC2Jrz7
 ZrtnZu5F8YqGoD2oFsKSkPQ6kxf6opxNZbhdDO24D8zWl/nDjOvYJPhaZt2Kyv9VLe92Pary
 aKrD3zUYD5SXmdL44H/4D7fAsk6PxrCblUe0EoDFsq5mRby19bCRXkOzO+5u0FYcJSjcuZf8
 kMnW+z7z2lYxYkPqydTGg83QyNDmvhxtcs3FGn5AlIwagg6IUHTJbf2SqYBVRsM3k2orXD73
 uZKDHos2lLfOOARkh43CEgorBgEEAZdVAQUBAQdArgn71jEIdo7NGz5mHA4sbew+O3OCJc5V
 VPE6eO2stCADAQgHwsB8BBgBCAAmFiEESsSijXII/G8rUV6p0SaxOrVV4W8FAmSHjcICGwwF
 CQeEzgAACgkQ0SaxOrVV4W9Aqwf+O/neol0KyvO8oyvacXUEIrhDPPsamkTjqsT72qZIPwFL
 6K8cNhqk09wtMVN9dElN6xKCToPp+0IDOepvmc0MC/BnhYpU9DSN6e57yX3ihPWy2Zlry3sn
 1iv6sxT9l8N2N4XZTOA6HL8C7wFTp9MDpD4ZTDTBc7jq/kT3qeIcSqZK7WKvE7jy/Wuycpes
 Df7zsyGed1JyYy3ierguZuVS55ll7Od212ND9GjAetQl49vHujz2OPDp7Kh09+HBBkWl1T1b
 jlGKXSaZJjdZ1ULJY2J5mfs3lN3uwBihwURyQcyhlLLVB3CaaJsJ4wlUXl87LyHpyXMSCDrA
 NL9Ty9GwFw==
In-Reply-To: <4f32ab766770af99ce9585bdb54e875f7e656588.camel@ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------FUJ04TvlZQH8MiSmGF5jqdtx"
X-Spamd-Bar: /

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------FUJ04TvlZQH8MiSmGF5jqdtx
Content-Type: multipart/mixed; boundary="------------pA51O7qA5WlGZ9qBziE1aP1l";
 protected-headers="v1"
From: Antoine Viallon <antoine@lesviallon.fr>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, ceph-devel@vger.kernel.org
Message-ID: <e0867174-3c3f-4ddb-b84b-12706e0c63bf@lesviallon.fr>
Subject: Re: [PATCH] ceph: fix memory leak in ceph_mds_auth_match()
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
 <4f32ab766770af99ce9585bdb54e875f7e656588.camel@ibm.com>
In-Reply-To: <4f32ab766770af99ce9585bdb54e875f7e656588.camel@ibm.com>

--------------pA51O7qA5WlGZ9qBziE1aP1l
Content-Type: multipart/mixed; boundary="------------Mw7zwFxg9HsNh4bsvk14Tovf"

--------------Mw7zwFxg9HsNh4bsvk14Tovf
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGVsbG8gVmlhY2hlc2xhdiwNCnRoYW5rcyBmb3IgeW91ciByZXZpZXcuDQoNCk9uIDE0LzAx
LzIwMjUgMjA6MTcsIFZpYWNoZXNsYXYgRHViZXlrbyB3cm90ZToNCg0KPiBEb2VzIGl0IGV4
aXN0IGFueSB3YXkgdG8gcmVwcm9kdWNlIHRoZSBpc3N1ZSBpbiBzdGFibGUgbWFubmVyPyBD
b3VsZA0KPiB5b3UgcGxlYXNlIHNoYXJlIGFueSBzdGVwcyB0byByZXBlYXQgaXQ/IEl0IHdp
bGwgYmUgZ3JlYXQgdG8gaGF2ZSB0aGlzDQo+IGRlc2NyaXB0aW9uIGluIHRoZSBwYXRjaCBj
b21tZW50Lg0KDQpUaGlzIGlzc3VlIGNhbiBwcm9iYWJseSBiZSByZXByb2R1Y2VkIGJ5IGhh
dmluZyBhIENlcGhGUyBzdWJ2b2x1bWVncm91cCANCmJlIG1vdW50ZWQgdG8gYSBrZXJuZWwg
Q2VwaCBjbGllbnQgKHZlcnNpb24gNi4xMi44KSwgd2hlcmUgdGhlIGF1dGggDQpjcmVkZW50
aWFscyBhcmUgc2NvcGVkIHRvIGEgc3BlY2lmaWMgcGF0aDoNCg0KY2xpZW50LnNlcnZpY2Vz
Og0KCWtleTogUkVEQUNURUQNCgljYXBzOiBbbWRzXSBhbGxvdyBydyBmc25hbWU9Y2VwaGZz
IHBhdGg9L3ZvbHVtZXMvDQogICAgICAgICBjYXBzOiBbbW9uXSBhbGxvdyByIGZzbmFtZT1j
ZXBoZnMNCiAgICAgICAgIGNhcHM6IFtvc2RdIGFsbG93IHJ3IHRhZyBjZXBoZnMgZGF0YT1j
ZXBoZnMNCg0KVGhlbiwgeW91IHNpbXBseSBuZWVkIHRvIHRyaWdnZXIgYSBsb3Qgb2YgZmls
ZSBwZXJtaXNzaW9uIGNoZWNrIChlaXRoZXIgDQpieSB1c2luZyB0aGUgRlMgZm9yIGxvbmcg
b3IgZG9pbmcgTE9TRiBJL08pLiBUaGlzIGNvdWxkIGJlIHByb2JhYmx5IGJlIA0KZG9uZSBi
eSBkb2luZzoNCg0KICAgICBzZXEgMSAxMDAwMDAgfCB4YXJncyAtUDMyIC0tcmVwbGFjZSB0
b3VjaCANCi9wYXRoL3RvL3lvdXIvY2VwaGZzL21vdW50L2ZpbGUte30NCiAgICAgc2VxIDEg
MTAwMDAwIHwgeGFyZ3MgLVAzMiAtLXJlcGxhY2UgY2F0IA0KL3BhdGgvdG8veW91ci9jZXBo
ZnMvbW91bnQvZmlsZS17fQ0KDQpUaGUgaWRlYSBpcyB0byBwbGFjZSB5b3Vyc2VsZiBpbiBh
IHNpdHVhdGlvbiB3aGVyZSB0aGUgdGFyZ2V0IHBhdGggYmVpbmcgDQptYXRjaGVkIGJ5IGNl
cGhfbWRzX2F1dGhfbWF0Y2ggZG9lcyBub3QgY29udGFpbiB5b3VyIGNyZWRlbnRpYWwgKGF1
dGgpIA0KcGF0aCBBVCBBTEwuIFRoaXMgY2FuIGJlIGRvbmUgd2hlbiBtb3VudGluZyBhIHN1
YnZvbHVtZWdyb3VwLCBmb3IgaW5zdGFuY2U6DQoNCglzZXJ2aWNlc0AwMDAwMDAwMC0wMDAw
LTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAuY2VwaGZzPS92b2x1bWVzL2NvbnRhaW5lcnMgY2Vw
aCBydyxub2F0aW1lLG5hbWU9c2VydmljZXMsc2VjcmV0PTxoaWRkZW4+LG1zX21vZGU9cHJl
ZmVyLWNyYyxtb3VudF90aW1lb3V0PTMwMCxhY2wsbW9uX2FkZHI9W1JFREFDVEVEXQ0KDQpT
aW5jZSB5b3UgbmV2ZXIgZW50ZXIgDQpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51
eC92Ni4xMy1yYzMvc291cmNlL2ZzL2NlcGgvbWRzX2NsaWVudC5jI0w1Njk3IA0Kb3IgDQpo
dHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92Ni4xMy1yYzMvc291cmNlL2ZzL2Nl
cGgvbWRzX2NsaWVudC5jI0w1NzAzLCANCnlvdSBuZXZlciBmcmVlIF90cGF0aCAod2hhdGV2
ZXIgZnJlZV90cGF0aCdzIHZhbHVlIG1pZ2h0IGJlKS4NCg0KPiBBcyBmYXIgYXMgSSBjYW4g
c2VlLCB3ZSBoYXZlIHNldmVyYWwga2ZyZWUoKSBjYWxscyBpbiB0aGUgbG9naWMgb2YgdGhp
cw0KPiBtZXRob2Q6DQo+ICgxKQ0KPiBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51
eC92Ni4xMy1yYzMvc291cmNlL2ZzL2NlcGgvbWRzX2NsaWVudC5jI0w1Njk3DQo+ICgyKQ0K
PiBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92Ni4xMy1yYzMvc291cmNlL2Zz
L2NlcGgvbWRzX2NsaWVudC5jI0w1NzAzDQo+IA0KPiBBbmQgeW91IGFyZSBhZGRpbmcgdGhl
IHRoaXJkIGNhbGwuIEkgYmVsaWV2ZSB0aGF0IGl0IHdpbGwgYmUgbXVjaA0KPiBjbGVhbmVy
IHNvbHV0aW9uIGlmIHdlIGhhdmUgb25seSBvbmUga2ZyZWUoKSBjYWxsIGFuZCBnb3RvIGZy
b20gYWxsDQo+IG90aGVyIHBsYWNlcy4gQ291bGQgeW91IHBsZWFzZSByZXdvcmsgeW91ciBm
aXg/DQoNCkkgYWJzb2x1dGVseSBhZ3JlZSwgYW5kIHdhcyB0aGlua2luZyB0aGUgc2FtZSB0
aGluZy4gSSdsbCByZXdvcmsgbXkgDQpwYXRjaCB0byBzaW1wbGlmeSB0aGlzIGtmcmVlIHBh
dGguDQoNCj4gVGhhbmtzLA0KPiBTbGF2YS4NCg0KVGhhbmsgeW91LA0KQW50b2luZSBWaWFs
bG9uDQoNCg==
--------------Mw7zwFxg9HsNh4bsvk14Tovf
Content-Type: application/pgp-keys; name="OpenPGP_0xD126B13AB555E16F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xD126B13AB555E16F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFsTKV8BCAC5m5cLL2RhcJK5H8kWmrwJ9TwlqAPIPe0+7Nr9D9vbyqoW4O40
7aBxspWZIpwxe+1fhocUlKVC8UYiD3PuTNoOAwbdypsahrFPSytFk4rFQ17KYJKc
4SLClTJ76JzGSGux5fHoASjMGH5t4UY3dEzU7bNvGKsmbFFmZJ8XxSzae2FedPpt
NZ1NNK8Fd5ymD0o0sC+JFeHvgolhDqdkvhIc3wW++SoPwRx2tIwoeIErMmZzG/dB
bPfrEXmNmAtuqo3+CSk3ETFdV0W5laTUNl42rBmTBiGD6+48AqzT36sJwP9ILcTP
z0r3aKY8oJNgSiRuE1dkwo/9J9lopQe0YQm1ABEBAAHNSUFudG9pbmUgVmlhbGxv
biAoTWlycm9pciBkZSBtb24gbWFpbCBHTWFpbCkgPGFudG9pbmUuZ21haWxAbGVz
dmlhbGxvbi5mcj7CwJQEEwEIAD4WIQRKxKKNcgj8bytRXqnRJrE6tVXhbwUCX0fb
UgIbAwUJCWYBgAULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRDRJrE6tVXhb2JV
CACFAj8mX/ExTFxRVHm2SE2p0VTPIjcOWqKJnhHIpStf9evYckL+ezK6QSaqY50O
F3HCPUQHOR3+Dds8pa9Hyh9ZQKmIqvd4G5HBZ1fJcRLh1yjeexjj37JWt+UbMw1T
/5XRXLwjGBoHt5Tn/VXp3pMPd52KmHi4svO4Cj/kczvud6bccfTDmmHFSL5JOnmT
pENVs0nWidrArzbwrmhXfSWDCBNkU52tCXkz2ab8OywgS9VyEBE4RLj3YoN/sAs+
fnm61X1zHfjBYb97dqlMgiiDAtEEE22aROtYBVG0QtBNQQuC5HsQZBrBTqM5ezL+
FFGUisGjUy3pIAFt229ihzlXwsCUBBMBCAA+AhsDBQsJCAcCBhUKCQgLAgQWAgMB
Ah4BAheAFiEESsSijXII/G8rUV6p0SaxOrVV4W8FAmaiu6AFCREzLMEACgkQ0Sax
OrVV4W+aSwf/VqoKpdpa2nCL8WuS7F5iOVzh9NcoidGnzuprPHWi9l5gF+UCZCWs
GKpnYnhNbDVZEfDM0dyviBjKM8rfrn5J0uNjXRz/Nq0ufrDqX6EJ6lbVoVHnIO0Q
49sbO9HyNwy3GeHJwKGPhNojia44NUsYWmnIO0r4QNwQ7BVRANnumRQQJvIm0lvt
4Nijhjluykkx0q3ul/FVhyOy5COZDypsGA7ShtxnOJQLU7KIB35p1fcwancp7l2Z
FeqIF+Ra4YabBzLGWxO7lblvGXDnsa7hBMwnH2HEVsqxm1NYj7IPyd6RYRoDR5BE
ve3BaQcaV1d3CPsk6D1PtiOZTSeBJt8yS80nQW50b2luZSBWaWFsbG9uIDxhbnRv
aW5lQGxlc3ZpYWxsb24uZnI+wsCXBBMBCABBAhsDBQkJZgGABQsJCAcCBhUKCQgL
AgQWAgMBAh4BAheAFiEESsSijXII/G8rUV6p0SaxOrVV4W8FAl9H29ACGQEACgkQ
0SaxOrVV4W9r8Af7BzerDuPuDmiBHm5i4zeoJ/55BuzETNLziILIqIBQC5yEqkTo
jhSQX3mcyz/xMKMJEdC6hEEDeBRKH99xHPDkT+JVn78N1h3MKjMPpqcrvZEXtwt1
9B7zQ15GeK6NU2bsWg7XOWWhmClbrNyOe7Jt2cgftftUEj1+izcaq2eCJK2t5M8d
xx9Xfw0IFsb8YCcCBmKa5FQEuBW+8Q0zYwLi8MpntdVzxMI9MU8kuO8qudn5olEZ
sFB5P3AXwaa2LQEd3fBN0BhppNiFh1uY6Iqa5aFNEVpQOjcZOgfgD/SmBmKqIoAO
LJA00krpdpy2rd9OWTKzlByR5o0mDAtEABH718LAlAQTAQgAPhYhBErEoo1yCPxv
K1FeqdEmsTq1VeFvBQJd0CN+AhsDBQkJZgGABQsJCAcCBhUKCQgLAgQWAgMBAh4B
AheAAAoJENEmsTq1VeFv0OwH/2hWbpl8VJj92ED1dAnGdS0tUyThA3qRm9X4HxVT
ptOlIuDVq8ySLAlLZXdR0eVEdop+D6UEfjMQcBaE2Hic7wjIQMmiMxKZ5TL2hU6h
Ker3DcKDQOdwUGm3Vby8tcbWxbub6E8goIRiDV5tZvq1GLUnXHu/XATo+pX3/rcH
1grl/p4ouqytZp0mvDKLlWibu84Ykp9gVtUvL4EFA0LzUFNVaAoYiM7vOH1f98Ky
sJoJ6ZPxe9t7z6KvtMuxJX+dQXlf8meOW+jwIIjSvGvbo9qpm1sYOjgIkieutHPO
zzPOWC9s7eGPP0AUN6y7eKAWKbRhYVbETTE8Fy0/C3q2U0zCwJQEEwEIAD4CGwMF
CwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQRKxKKNcgj8bytRXqnRJrE6tVXhbwUC
ZIeK8AUJC1WVEQAKCRDRJrE6tVXhb7ZfB/9S5B8XLnTgk7vji2cYKwr/3HNm4fG2
PMVeBLxOyqbCmWZtYoCFkc4onX/oi9L68V37x5dnJsiu1fMZbOdfx2UzPfx1ZBqw
WWYTBXBKdxX7MP7t09zOyFc0mRXyxbdSjLmEZFXp79rQloH8oR1U+45JeA3WaiHx
K1joJ6Yn/0DuFplUgrB+g+ANdO174YKvMXukaRDOEUesJ6A1KmBCYsjz7iaihtM3
LTM5N5Tb+rmceKUd/Vs7UvVgv75QdH+jCnAkyCe18lMBz83Aro0n6mqpJeJxDGkc
M0k2RkKm5qrkq0IvpWHVD7D23ZEhOmKGvdyve0exQN7IYW5hJXa41oaWwsCUBBMB
CAA+AhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEESsSijXII/G8rUV6p0Sax
OrVV4W8FAmaiu6AFCREzLMEACgkQ0SaxOrVV4W+zkQgAiyKODjvipeTn30rRvsSj
N8WIa7KDcyzmJbyivduoUcLjKv9cYS6FC31n8O+v4C2kvt0B+hmXfl1Z7UTOoT8h
VqIjPBNFrYxKxd+W6wqfc9z4kLYmvPtmu2dm7kXxioagPagWwpKQ9DqTF/qinE1l
uF0M7bgPzNaX+cOM69gk+Fpm3YrK/1Ut73Y9qvJoqsPfNRgPlJeZ0vjgf/gPt8Cy
To/GsJuVR7QSgMWyrmZFvLX1sJFeQ7M77m7QVhwlKNy5l/yQydb7PvPaVjFiQ+rJ
1MaDzdDI0Oa+HG1yzcUafkCUjBqCDohQdMlt/ZKpgFVGwzeTaitcPve5koMeizaU
t80rQW50b2luZSBWaWFsbG9uIDxhbnRvaW5lLnZpYWxsb25AZ21haWwuY29tPsLA
lAQTAQgAPhYhBErEoo1yCPxvK1FeqdEmsTq1VeFvBQJbEylfAhsDBQkJZgGABQsJ
CAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJENEmsTq1VeFv2fYIALToeNLbiUwgWd20
CGRvoMFHxwG73HQscrVkLLGiPOc0v0EuCZOIFvvc4WW0LqasE9sY5037PXUuIA7a
QTNOqg7iKu5F9SAlgOrUPgl6daUmcdFqM6HBZt3VQBYRpFexCSTD3y7VeAnUX0at
ux4BSI3P6f6WH0LviSXGkW+ONNUuR1xJzHNxjC2Q6J2YPz28XyFu6Nm8/92RX7O9
e013FczXu71CeLQw1JqDf3PIAX9XqHiy85UUAgRXf3+ZD+R0Dv5N6okY42DY/i1/
G4sl9oKTq5KPgxp+6dWUYIeS2TVTeaXMV3wYss9kIYf2/ecxZ2aVHvp8aUkHZe7L
77miEHXCwJQEEwEIAD4CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQRKxKKN
cgj8bytRXqnRJrE6tVXhbwUCZIeK8AUJC1WVEQAKCRDRJrE6tVXhbwGXB/9ly0ZF
QO97R02DPDZezCPxwk8YR9ze9Y3S7x9JT0DcDChtvSsTjcC0BGa0Y/Ksswg+xs91
VD/Lurr9yYa2Iy5m1NF8T12E8PqCVGHXwkHliKng9lrIZm3AkyA9+7/+C2mIeoNj
gV/4aofRRXO1L6cpQbYPmm7YiYAG7AO1sUAlpl/YC8wJ8qPklfzlHKUQvZjbXTvl
KaOHsp73X42P+Gm+z7ROWp61AHE8c7KAAQLFfKG2kgp9kJFgiNkMTgk3yBwWBfAW
NWlhsu9g/RtcqkrJAA46DPpfN/frVmKaWjj4iOigc2lWsy+/KEoNGvOS4Fqf0hLO
xXkYD/5f7y+0/PxAwsCUBBMBCAA+AhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheA
FiEESsSijXII/G8rUV6p0SaxOrVV4W8FAmaiu6AFCREzLMEACgkQ0SaxOrVV4W/c
bgf/dDDCcl3rPhKR+4ayNZNlBVCjWdFcT2Aqz2qYpNOC2NWV7z2PXnqoi4WqDKcP
EJpSE3njDR0aqIiZdJhd/PvjkZWIFC74Ur1dWi2pNrUoz/HSfks8x3IEJrJFeUEv
6YQ23ux1lrlQ9plFVSHEK/GdWLnb15DovKhHJbA7ivtW031FNyP18EFe9YBF+AHm
x/lJm4xlbLBryxB5UpC03pr8eE6g17L3PjT7h7OSufgaF2i/H3xZljZAklXii6wD
O2H1/rCcjzKC5pytT4LpmbfMqcnDwX28wgTAsTShx7Z32XnLA19CYYSXV8hk8n4r
+9X2oTMzIWnWIHIG1gvm6XrCoM0jYW50b2luZS52aWFsbG9uQHRlbGVjb20tc3Vk
cGFyaXMuZXXCwJQEEwEIAD4WIQRKxKKNcgj8bytRXqnRJrE6tVXhbwUCXc4aWAIb
AwUJCWYBgAULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRDRJrE6tVXhb38rB/0V
6k/t+pEByJ5quyIY50RtfMJPmBxpkFYVGvbaPbqs8NYX67IpDkPNccXdjFRmZXZL
Z+xszXYaIGoWSwop45foY6gN39DFTgLrkpy9k7aQcsvGWx42ZYG+Mov+uxp6vdyS
c09n+/tD2kl0nP13MNmViWlV3Gz7JD8cRjo7IT+C89kVHgex4Gpj9HWstxFwMtyM
/h4wKpFst1hF3nge046pQToemgb97jQ7Kq5HQUObFVEhTUsHJVLEK2QDWroxkubn
9wP5VJw32XgiBPuS5VG2roqNn9YwvwT9iO+YaH1UpGknIjD4d4r+pU8lWqcG68KK
hQUfJCm9YNzSe1do5e+kwsCUBBMBCAA+BQsJCAcCBhUKCQgLAgQWAgMBAh4BAheA
BQkLVZURFiEESsSijXII/G8rUV6p0SaxOrVV4W8FAmSUDxkCGwMACgkQ0SaxOrVV
4W9lJwf+LamDAz94zV/tYMlieGTnemfb7dSJQMMNcxDonDxQwL9B9CndyXQq9Vsy
zeh3uS+fzOdA1MBqMtuOWyzl1+uhTMlqQUMsx2cJpjVLnJMc5ha9jVhM7l3f1sPh
cjXZMgiIzUb7H2IyjljdgB6awnI0TNfDN3YAoBjx8HLZhJnUzNrnUmUOY6XaB82P
RSelWLkJ6TLLbkZopc+hbgbuZGClPNAVSYooEx+A7/Fs86G75Yoxi8AlSt1Y6cBa
TD9EcmkXM374Ar88cZTZf9DG1DhKNitoU9SpMRdBXHvpzAAXSwe64OKvFfdVXXs8
5FcwBtKwxLJXg3WisqgSRN+6wkW6U8LAlAQTAQgAPgULCQgHAgYVCgkICwIEFgID
AQIeAQIXgAIbAxYhBErEoo1yCPxvK1FeqdEmsTq1VeFvBQJmorugBQkRMyzBAAoJ
ENEmsTq1VeFvMYgH/03uv8j82ObH2b8qZxEQ7QHcg9b8PbDuo9OB/N2cvNtVqSmP
WdNzOVQLNJG3hK40rfJ801S8nMrN5LyJ9ylzMsjGi5vSPR4Xm+DfvA1qy+UhwL/k
u0KpYvsgf81pNB9keCDscUx5AQgQ96k+PycaUvCT+XToiWMXo88lrDScc1EYoxEe
iD/E/AykKmz33c05Zkij1QMqOWnPLKk1r7gT7MOPh8884YnIALwgO0kZVNwK3xXn
E3RV6SKckl6AvvYN5XKcMzsLd6FLK+TqKFAOFnekvUyJjxN6TQaWeFWtDOjDHVns
CGrC0RQ177WJikP5menQwvHjDwLtQmRomQCDGjDR/wAAIS//AAAhKgEQAAEBAAAA
AAAAAAAAAAAA/9j/4AAQSkZJRgABAQEAWQBXAAD/2wBDABIMDRANCxIQDhAUExIV
GywdGxgYGzYnKSAsQDlEQz85Pj1HUGZXR0thTT0+WXlaYWltcnNyRVV9hnxvhWZw
cm7/2wBDARMUFBsXGzQdHTRuST5Jbm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5u
bm5ubm5ubm5ubm5ubm5ubm5ubm5ubm7/wAARCAEgANcDASIAAhEBAxEB/8QAHwAA
AQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9
AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJico
KSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJ
ipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi
4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcI
CQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKR
obHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldY
WVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0
tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMB
AAIRAxEAPwClJcPMAHckdcZ49OlRxKSxCgnAyfahY+A/boantbvyHKsgYScHiuJb
2JW+pCxZYwAwGO1RbWyDzgkc1cvIFifORyMgelAZBahCMEc7iKGk2Jq7sVlUsSBz
z2q3bhjGQRwDTUVFTIwCRnNC3aqMBcnBGaapXGo9yW3tVkkLzAgEHAPrUkuyHA24
Yd+5FVje5TuCOBUU12JAM8npWqpWKsid5scFgBnI+tBvNww+DjjpVB5QckDNRPKF
G4MQOM/WtFBLoFkaPmqrBtgAz0XpTbu8kYEQEIh6gcVnm6wckjB7YpVmDk+hHI/r
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
OsA0v1PL0bAX
=3DYh6h
-----END PGP PUBLIC KEY BLOCK-----

--------------Mw7zwFxg9HsNh4bsvk14Tovf--

--------------pA51O7qA5WlGZ9qBziE1aP1l--

--------------FUJ04TvlZQH8MiSmGF5jqdtx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQReIgXBRQE5Pgossc8Yb8Ne3rJXFgUCZ4bhgAUDAAAAAAAKCRAYb8Ne3rJXFqGS
APwPh9oAl4leucSGyRDV9t3PMt/4tb4Gmy6w1OLdp20jRwD/daFybE4CGfZJ3/uS+twJneIjKVLW
/ve1lw7VlL631A8=
=hJ76
-----END PGP SIGNATURE-----

--------------FUJ04TvlZQH8MiSmGF5jqdtx--

