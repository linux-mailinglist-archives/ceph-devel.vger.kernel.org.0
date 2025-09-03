Return-Path: <ceph-devel+bounces-3511-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FDEB418EA
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 10:42:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1254B16686B
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 08:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B272EC090;
	Wed,  3 Sep 2025 08:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="GGqHvE0n"
X-Original-To: ceph-devel@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FC52E1C64;
	Wed,  3 Sep 2025 08:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756888972; cv=none; b=SQkWeg+n2oE5d5/1JhQZYega/Dp+gczJqZVeQCP42igbf+gfg62Hr3fUiq7zQqpapdhhIJQ96OL1pCPuvKmPvxKoUFtIb0o7KKcoLiorGurXAIGinzY6RDJlZwlPbGll71O/GIHC0sQd7tfW9nLSQ5lqPOfxzU0Ke3vpfX6IRmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756888972; c=relaxed/simple;
	bh=AnX3Nm/Hvm5UD05uWR99Rsk/kTDou0vWJ9s+CdVO7EI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dhgkE2yJocg3Dc4zQnFBGXRc+4n45dhdd2oVMw2g1WE1JLxIBuZsbuhA5hqJnhUa2Ili5UjiyWMo2j1Jr5WvjhCAZ+2QdYnQlvQVAnxGcUQSN73OqD9J+qLh7BOs32IrU5flt8zZ5mfC+KzyV2kMNGSTIq6ECmSAuvpHNKoxI5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=GGqHvE0n; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OPb6tBH44k/DmMeysehj8wmGKP+Wv+tsELAL90Q2HU8=; b=GGqHvE0nnxpvT2q3PVKrLRxuMT
	36WB26N/KclLNsfgzayFFOrz4nm1X1uurjJXwMXTRKYKKSlW3Q0eBgleYaRg8Fl37MmviC9w3zrdj
	7MLqQP3BjVE7zpFyGnQoza0EnAZY4BHbNR0vY9eAId/6Kt22XOlzOszlkwakwhIIwE3Fn7l8nSU+s
	sl2wZWZQINb/on+oVoQGilQIgnwPQCYpZVrZCib86Yg/qAz6RU6W1ATln07J+kD68ifXIJkJLnSUG
	jmpGiD3eWewHb3Wg5xLGlfy1ylWc3SAkxhIne2UqNlrXIwDutvrgirjvr5hjJS4Wh0F8DYjUJT4zU
	FHv+fBbw==;
Received: from bl17-145-117.dsl.telepac.pt ([188.82.145.117] helo=localhost)
	by fanzine2.igalia.com with utf8esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1utj4k-0066Ck-E7; Wed, 03 Sep 2025 10:42:42 +0200
From: Luis Henriques <luis@igalia.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,  "409411716@gms.tku.edu.tw"
 <409411716@gms.tku.edu.tw>,  Xiubo Li <xiubli@redhat.com>,
  "idryomov@gmail.com" <idryomov@gmail.com>,
  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
  "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH] ceph: optimize ceph_base64_encode() with block processing
In-Reply-To: <aLf34hrnwULGA+0m@visitorckw-System-Product-Name> (Kuan-Wei
	Chiu's message of "Wed, 3 Sep 2025 16:10:10 +0800")
References: <20250830132822.7827-1-409411716@gms.tku.edu.tw>
	<fce1adab2b450097edbcea3ec83420257997ec00.camel@ibm.com>
	<aLdcNhKrPXxaEUtm@visitorckw-System-Product-Name>
	<f4f33ae461e0f1cf2f28d1c22546bd67cd9c4da3.camel@ibm.com>
	<aLf0eJcvCj9zcn-g@igalia.com>
	<aLf34hrnwULGA+0m@visitorckw-System-Product-Name>
Date: Wed, 03 Sep 2025 09:42:42 +0100
Message-ID: <87tt1kdj0d.fsf@wotan.olymp>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03 2025, Kuan-Wei Chiu wrote:

> On Wed, Sep 03, 2025 at 08:55:36AM +0100, Luis Henriques wrote:
>> On Tue, Sep 02, 2025 at 09:21:14PM +0000, Viacheslav Dubeyko wrote:
>> > On Wed, 2025-09-03 at 05:05 +0800, Kuan-Wei Chiu wrote:
>> > > On Tue, Sep 02, 2025 at 07:37:22PM +0000, Viacheslav Dubeyko wrote:
>> > > > On Sat, 2025-08-30 at 21:28 +0800, Guan-Chun Wu wrote:
>> > > > > Previously, ceph_base64_encode() used a bitstream approach, hand=
ling one
>> > > > > input byte at a time and performing extra bit operations. While =
correct,
>> > > > > this method was suboptimal.
>> > > > >=20
>> > > >=20
>> > > > Sounds interesting!
>> > > >=20
>> > > > Is ceph_base64_decode() efficient then?
>> > > > Do we have something in crypto library of Linux kernel? Maybe we c=
an use
>> > > > something efficient enough from there?
>> > > >=20
>> > > Hi Viacheslav,
>> > >=20
>> > > FYI, we already have base64 encode/decode implementations in
>> > > lib/base64.c. As discussed in another thread [1], I think we can put
>> > > the optimized version there and have users switch to call the library
>> > > functions.
>> > >=20
>> > > [1]: https://lore.kernel.org/lkml/38753d95-8503-4b72-9590-cb129aa49a=
41@t-8ch.de/=20=20
>> > >=20
>> > >=20
>> >=20
>> > Sounds great! Generalized version of this algorithm is much better than
>> > supporting some implementation in Ceph code.
>>=20
>> Please note that ceph can not use the default base64 implementation beca=
use
>> it uses the '_' character in the encoding, as explained in commit
>>=20
>>   64e86f632bf1 ("ceph: add base64 endcoding routines for encrypted names=
")
>>=20
>> That's why it implements it's own version according to an IMAP RFC, which
>> uses '+' and ',' instead of '-' and '_'.
>>=20
> Perhaps we could modify the API to allow users to provide a custom
> base64 table or an extra parameter to specify which RFC standard to use
> for encoding/decoding?

Yes, sure.  That should work as well.  If I remember correctly, I didn't
bother doing that back then because ceph was the only place that needed a
custom base64.  But I not really sure, that was long ago.

Cheers,
--=20
Lu=C3=ADs

