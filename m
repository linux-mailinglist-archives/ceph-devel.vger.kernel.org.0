Return-Path: <ceph-devel+bounces-2489-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CB1A140E2
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2025 18:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA6CD7A2F8B
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2025 17:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770B5137930;
	Thu, 16 Jan 2025 17:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b="WF1zj028"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lesviallon.fr (89-95-58-186.abo.bbox.fr [89.95.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F871428E7
	for <ceph-devel@vger.kernel.org>; Thu, 16 Jan 2025 17:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.95.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737048706; cv=none; b=AAs6LqHzhbAW4B39kpGx+rSBFgTVXYvuvAjX+wNZ17XclzSU0S84OOOi0xMIuRJLRnNpXWYPBJEJ5VXyVfsZIOLv+dUWQW2OLQanekDRiEgPWBlmBsKEFuM8AWVGkPF9/f5jhTFS6VF/LMTI/bpNFfJdznB84UQRdbW57SiwJro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737048706; c=relaxed/simple;
	bh=LIYCkQ7p3wKdd8QZ0EKklvH8xpPkwQAJkF+Irh0dmjc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=UdhnEjETJuacllBSjEgBw2FD1K12T2YTsiFaENQ+CxBaF7onsHuIWexVp4hm3xxtQP7m3gwHWtfa03bRWjwsJDLHnAjbGA4JKU+wFnWzMC8gJL/G9Ddu69j7Ysn4SJlyUAFQwuAgJvy4ShwOBCBVOQ1GhM2g/1e7BtuGOKsWWxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr; spf=pass smtp.mailfrom=lesviallon.fr; dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b=WF1zj028; arc=none smtp.client-ip=89.95.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lesviallon.fr
Date: Thu, 16 Jan 2025 18:31:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lesviallon.fr;
	s=dkim; t=1737048694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LIYCkQ7p3wKdd8QZ0EKklvH8xpPkwQAJkF+Irh0dmjc=;
	b=WF1zj028Hb7zE4dnuGFXdrIv3RqaTgGpuOnHHMM2+oKhGnrwaDNtaCXVE1lwqrWwMViIYl
	9H5q4C7Od7uFiSsITapiGB4CHWjRCWFCXX8EN0/A2t1qoyGy9e/L7l5oPdhG514Sd+3lIh
	Bmpu0gEzNdBMDQFKK/W8Cj37xAEV2kA=
Authentication-Results: lesviallon.fr;
	auth=pass smtp.mailfrom=antoine@lesviallon.fr
From: Antoine Viallon <antoine@lesviallon.fr>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
 "idryomov@gmail.com" <idryomov@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: RE: [PATCH v2] ceph: fix memory leak in ceph_mds_auth_match()
Disposition-Notification-To: Antoine Viallon <antoine@lesviallon.fr>
X-Confirm-Reading-To: Antoine Viallon <antoine@lesviallon.fr>
Return-Receipt-To: Antoine Viallon <antoine@lesviallon.fr>
In-Reply-To: <187c44868453c865ea363753456a06916a4424b7.camel@ibm.com>
References: <20250114123806.2339159-1-antoine@lesviallon.fr> <20250114224514.2399813-1-antoine@lesviallon.fr> <9cd7c8f4c194fcb8c63c818f2155a9b4f55ce682.camel@ibm.com> <CAOi1vP-zzoBrJF=rSLVRLdE_=pk8A5UWmQwQV0VhvdnzsPijkg@mail.gmail.com> <187c44868453c865ea363753456a06916a4424b7.camel@ibm.com>
Message-ID: <A6CF52B9-65F9-4C7B-962B-F45F78E0A1B6@lesviallon.fr>
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

Thank you very much Ilya,
your patch is clearer indeed=2E

I'm also wondering if the allocation itself could be avoided=2E
In any case, it is good enough for now :)

Antoine Viallon

