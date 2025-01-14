Return-Path: <ceph-devel+bounces-2439-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61157A1105C
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 19:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 762291669A3
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 18:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0431F9F52;
	Tue, 14 Jan 2025 18:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b="T+v+KwmX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lesviallon.fr (89-95-58-186.abo.bbox.fr [89.95.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85621D54E2
	for <ceph-devel@vger.kernel.org>; Tue, 14 Jan 2025 18:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.95.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736880114; cv=none; b=W8EZh73jX2zj5Ej/WRsdCdGOWjRgxLYT0kb4tL7PAgCPs47GX4X1l1lR+x3lCqNqLWGDD2Wc7o3NBlWeeCTM7vBZVW/9Hhl8h8L+pZCfI8DmUD6hkEZ/v2S1aS/snk8Oe1xUL2QqexGAs0BgmEISOnFkdr8LBzHWp6ojv63M+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736880114; c=relaxed/simple;
	bh=BkP7XgE5EfYp5mGcy39nYckaoSg3DKXwWb+TVWPxOkE=;
	h=Date:From:To:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=RU+yIjL0fEPN3pATBszWoYekSi/anX0KCobjjTPgeFMv1jgf2DlpssQp6OiinFJldb0/W2GSqcCawjeeqdXtjwp0CkYLY0ltR1LPQXov8QmDxqZ8jvxnvunnX3cX0wJ/2VaqOK4FwblPcTAw+Z61tRnciYXdJRqCsuY2yUSF00s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr; spf=pass smtp.mailfrom=lesviallon.fr; dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b=T+v+KwmX; arc=none smtp.client-ip=89.95.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lesviallon.fr
Date: Tue, 14 Jan 2025 19:41:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lesviallon.fr;
	s=dkim; t=1736880106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BkP7XgE5EfYp5mGcy39nYckaoSg3DKXwWb+TVWPxOkE=;
	b=T+v+KwmXjFUpaa9uXS+St90gT9YeStHELt6kq8x924Yi+o7psMpTXUFqrGTWqvjtjI4y1I
	IukbLzBNBmaQALStp99mH+OwxKInAODTpifGSjgku3LGpU4baz2W7oP0EmrdAwwMhJyDmb
	RRs8F0DnKSGhthqkj1B7xI8nxgTfqbs=
Authentication-Results: lesviallon.fr;
	auth=pass smtp.mailfrom=antoine@lesviallon.fr
From: Antoine Viallon <antoine@lesviallon.fr>
To: ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: fix memory leak in ceph_mds_auth_match()
Disposition-Notification-To: Antoine Viallon <antoine@lesviallon.fr>
X-Confirm-Reading-To: Antoine Viallon <antoine@lesviallon.fr>
Return-Receipt-To: Antoine Viallon <antoine@lesviallon.fr>
In-Reply-To: <20250114123806.2339159-1-antoine@lesviallon.fr>
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
Message-ID: <20780B04-AAB9-47EC-9A48-FF4A51C922F9@lesviallon.fr>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Autocrypt: addr=antoine@lesviallon.fr; prefer-encrypt=mutual; keydata=
 mQENBFsTKV8BCAC5m5cLL2RhcJK5H8kWmrwJ9TwlqAPIPe0+7Nr9D9vbyqoW4O407aBxspWZIpwx
 e+1fhocUlKVC8UYiD3PuTNoOAwbdypsahrFPSytFk4rFQ17KYJKc4SLClTJ76JzGSGux5fHoASjM
 GH5t4UY3dEzU7bNvGKsmbFFmZJ8XxSzae2FedPptNZ1NNK8Fd5ymD0o0sC+JFeHvgolhDqdkvhIc
 3wW++SoPwRx2tIwoeIErMmZzG/dBbPfrEXmNmAtuqo3+CSk3ETFdV0W5laTUNl42rBmTBiGD6+48
 AqzT36sJwP9ILcTPz0r3aKY8oJNgSiRuE1dkwo/9J9lopQe0YQm1ABEBAAG0J0FudG9pbmUgVmlh
 bGxvbiA8YW50b2luZUBsZXN2aWFsbG9uLmZyPokBVAQTAQgAPgIbAwULCQgHAgYVCgkICwIEFgID
 AQIeAQIXgBYhBErEoo1yCPxvK1FeqdEmsTq1VeFvBQJmorugBQkRMyzBAAoJENEmsTq1VeFvs5EI
 AIsijg474qXk599K0b7EozfFiGuyg3Ms5iW8or3bqFHC4yr/XGEuhQt9Z/Dvr+AtpL7dAfoZl35d
 We1EzqE/IVaiIzwTRa2MSsXflusKn3Pc+JC2Jrz7ZrtnZu5F8YqGoD2oFsKSkPQ6kxf6opxNZbhd
 DO24D8zWl/nDjOvYJPhaZt2Kyv9VLe92ParyaKrD3zUYD5SXmdL44H/4D7fAsk6PxrCblUe0EoDF
 sq5mRby19bCRXkOzO+5u0FYcJSjcuZf8kMnW+z7z2lYxYkPqydTGg83QyNDmvhxtcs3FGn5AlIwa
 gg6IUHTJbf2SqYBVRsM3k2orXD73uZKDHos2lLe4OARkh43CEgorBgEEAZdVAQUBAQdArgn71jEI
 do7NGz5mHA4sbew+O3OCJc5VVPE6eO2stCADAQgHiQE8BBgBCAAmFiEESsSijXII/G8rUV6p0Sax
 OrVV4W8FAmSHjcICGwwFCQeEzgAACgkQ0SaxOrVV4W9Aqwf+O/neol0KyvO8oyvacXUEIrhDPPsa
 mkTjqsT72qZIPwFL6K8cNhqk09wtMVN9dElN6xKCToPp+0IDOepvmc0MC/BnhYpU9DSN6e57yX3i
 hPWy2Zlry3sn1iv6sxT9l8N2N4XZTOA6HL8C7wFTp9MDpD4ZTDTBc7jq/kT3qeIcSqZK7WKvE7jy
 /WuycpesDf7zsyGed1JyYy3ierguZuVS55ll7Od212ND9GjAetQl49vHujz2OPDp7Kh09+HBBkWl
 1T1bjlGKXSaZJjdZ1ULJY2J5mfs3lN3uwBihwURyQcyhlLLVB3CaaJsJ4wlUXl87LyHpyXMSCDrA
 NL9Ty9GwFw==
X-Spamd-Bar: /

Addendum: The relevant bug report can be found here: <https://tracker=2Ecep=
h=2Ecom/issues/69535>

