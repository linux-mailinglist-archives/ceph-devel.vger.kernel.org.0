Return-Path: <ceph-devel+bounces-4187-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 66496CC5C4C
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Dec 2025 03:28:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0FA1D3002D0B
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Dec 2025 02:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10DA025DAEA;
	Wed, 17 Dec 2025 02:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b="LHNPO6qA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.haak.id.au (mail.haak.id.au [172.105.183.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDD525A357;
	Wed, 17 Dec 2025 02:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.105.183.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765938531; cv=none; b=OF+ZLFbnbFbG056Gi+pJ3cp994ImEpTc0iHA12aaESpnXZLy4wKQxrT+yjeul9cH+zhGR8fdL2eRRpHnCnBMNz0sr9kK06BXpdq9a/74WitJ3b5WLIn67IykkCpPhoFat/EEiuYgLYhAx1mSuDwOT5Ih9fatcm0wqGpC/L3yJxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765938531; c=relaxed/simple;
	bh=54Gy0kdNXJG+usm00/9nZDhYPdIQGpauyEeXcWMwDLE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5t4Wir4lM9VekIFfL1+JOhip+2f5tiLCC/H7rBBOqR+tvo1ATB4qP4Q/RnGXXLaVsdtgQB8DV9IEVDlv4C3AYIsE0tN364YDAPpj1CZ3ahKp9AMsjCUeqcBfEPn4zbbHISaTdn+JLTOjJEsUGEPhnKVmMLksAHrLn4hGXXRtMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au; spf=pass smtp.mailfrom=haak.id.au; dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b=LHNPO6qA; arc=none smtp.client-ip=172.105.183.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=haak.id.au
Received: from xps15mal (180-150-104-78.b49668.bne.static.aussiebb.net [180.150.104.78])
	by mail.haak.id.au (Postfix) with ESMTPSA id ECC48833C5;
	Wed, 17 Dec 2025 12:28:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=haak.id.au; s=202002;
	t=1765938522; bh=54Gy0kdNXJG+usm00/9nZDhYPdIQGpauyEeXcWMwDLE=;
	h=Date:From:To:Subject:From;
	b=LHNPO6qAK9EQthVJh0zO/D6zcgKy63Tr3kzoez7JpVH9mEWan6sM7ZbauKRd99CGD
	 Yutrv1sv4jKEDL0Lw2Bhqkc/Lujv+fZMLiTnXHORMq6vFIvTrs3841rAydxMmQqBX8
	 XgSlpnwoDXqWzZcwzzbizaiFDwBBtO0AywFX6jhVCiizO58dEFcjgp+wlAA7oXQvy7
	 bfr3LULE2sVDGyyQgfskafav/zc+nDYjkHiKrp2X3G3vC8+99AQSOVWfhlzQV7vsH8
	 DjDh3SZ9w1Fp9s2IfzU/zMSqXbUBIJgJ5jBOlCvd9MsrxcpyGV/OMHJvtw+gELufo4
	 ecs2THKen92gw==
Date: Wed, 17 Dec 2025 12:28:38 +1000
From: Mal Haak <malcolm@haak.id.au>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "00107082@163.com" <00107082@163.com>, Xiubo Li <xiubli@redhat.com>,
 David Howells <dhowells@redhat.com>, "ceph-devel@vger.kernel.org"
 <ceph-devel@vger.kernel.org>, "surenb@google.com" <surenb@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "netfs@lists.linux.dev" <netfs@lists.linux.dev>, "pc@manguebit.org"
 <pc@manguebit.org>, "idryomov@gmail.com" <idryomov@gmail.com>
Subject: Re: Possible memory leak in 6.17.7
Message-ID: <20251217122838.3748ea92@xps15mal>
In-Reply-To: <ec3b777ba176a6ca4738da8c62c030577a4e58eb.camel@ibm.com>
References: <20251110182008.71e0858b@xps15mal>
	<20251208110829.11840-1-00107082@163.com>
	<20251209090831.13c7a639@xps15mal>
	<17469653.4a75.19b01691299.Coremail.00107082@163.com>
	<20251210234318.5d8c2d68@xps15mal>
	<2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com>
	<20251211142358.563d9ac3@xps15mal>
	<8c8e8dc4d30a8ca37a57d7f29c5f29cdf7a904ee.camel@ibm.com>
	<20251216112647.39ac2295@xps15mal>
	<63fa6bc2.6afc.19b25f618ad.Coremail.00107082@163.com>
	<20251216170918.5f7848cc@xps15mal>
	<20251216215527.61c2e16f@xps15mal>
	<5845dde.b3e3.19b2718bc89.Coremail.00107082@163.com>
	<10b5964a.b798.19b272f1b79.Coremail.00107082@163.com>
	<ec3b777ba176a6ca4738da8c62c030577a4e58eb.camel@ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Dec 2025 01:56:52 +0000
Viacheslav Dubeyko <Slava.Dubeyko@ibm.com> wrote:

> Hi Mal,
>=20
> On Tue, 2025-12-16 at 20:42 +0800, David Wang wrote:
> > At 2025-12-16 20:18:11, "David Wang" <00107082@163.com> wrote: =20
> > >=20
> > >  =20
>=20
> <skipped>
>=20
> > > >=20
> > > >  =20
> > > > > > >=20
> > > > > > > I've have been trying to narrow down a consistent
> > > > > > > reproducer that's as fast as my production workload. (It
> > > > > > > crashes a 32GB VM in 2hrs) And I haven't got it quite as
> > > > > > > fast. I think the dd workload is too well behaved.=20
> > > > > > >=20
> > > > > > > I can confirm the issue appeared in the major patch set
> > > > > > > that was applied as part of the 6.15 kernel. So during
> > > > > > > the more complete pages to folios switch and that nothing
> > > > > > > has changed in the bug behaviour since then. I did have a
> > > > > > > look at all the diffs from 6.14 to 6.18 on addr.c and
> > > > > > > didn't see any changes post 6.15 that looked like they
> > > > > > > would impact the bug behavior.=20
> > > > > > >=20
> > > > > > > Again, I'm not super familiar with the CephFS code but to
> > > > > > > hazard a guess, but I think that the web download
> > > > > > > workload triggers things faster suggests that unaligned
> > > > > > > writes might make things worse. But again, I'm not 100%
> > > > > > > sure. I can't find a reproducer as fast as downloading a
> > > > > > > dataset. Rsync of lots and lots of tiny files is a tad
> > > > > > > faster than the dd case.
> > > > > > >=20
> > > > > > > I did see some changes in ceph_check_page_before_write
> > > > > > > where the previous code unlocked pages and then continued
> > > > > > > where as the changed folio code just returns ENODATA and
> > > > > > > doesn't unlock anything with most of the rest of the
> > > > > > > logic unchanged. This might be perfectly fine, but in my,
> > > > > > > admittedly limited, reading of the code I couldn't figure
> > > > > > > out where anything that was locked prior to this being
> > > > > > > called would get unlocked like it did prior to the
> > > > > > > change. Again, I could be miles off here and one of the
> > > > > > > bulk reclaim/unlock passes that was added might be
> > > > > > > cleaning this up correctly or some other functional
> > > > > > > change might take care of this, but it looks to be
> > > > > > > potentially in the code path I'm excising and it has had
> > > > > > > some unlock logic changed.=20
> > > > > > >=20
> > > > > > > I've spent most of my time trying to find a solid quick
> > > > > > > reproducer. Not that it takes long to start leaking
> > > > > > > folios, but I wanted something that aggressively
> > > > > > > triggered it so a small vm would oom quickly and when
> > > > > > > combined with crash_on_oom it could potentially be used
> > > > > > > for regression testing by way of "did vm crash?".
> > > > > > >=20
> > > > > > > I'm not sure if it will super help, but I'll provide what
> > > > > > > details I can about the actual workload that really sets
> > > > > > > it off. It's a python based tool for downloading
> > > > > > > datasets. Datasets are split into N chunks and the tool
> > > > > > > downloads them in parallel 100 at a time until all N
> > > > > > > chunks are down. The compressed dataset is then unpacked
> > > > > > > and reassembled for use with workloads.=20
> > > > > > >=20
> > > > > > > This is replicating a common home folder usecase in HPC.
> > > > > > > CephFS is very attractive for home folders due to it's
> > > > > > > "NFS-like" utility and performance. And many tools use a
> > > > > > > similar method for fetching large datasets. Tools are
> > > > > > > frequently written in python or go.=20
> > > > > > >=20
> > > > > > > None of my customers have hit this yet, not have any
> > > > > > > enterprise customers as none have moved to a new enough
> > > > > > > kernel yet due to slow upgrade cycles. Even Proxmox have
> > > > > > > only just started testing on a kernel version > 6.14.=20
> > > > > > >=20
> > > > > > > I'm more than happy to help however I can with testing. I
> > > > > > > can run instrumented kernels or test patches or whatever
> > > > > > > you need. I am sorry I haven't been able to produce a
> > > > > > > super clean, fast reproducer (my test cluster at home is
> > > > > > > all spinners and only 500TB usable). But I figured I
> > > > > > > needed to get the word out asap as distros and soon
> > > > > > > customers are going to be moving past 6.12-6.14 kernels
> > > > > > > as the 5-7 year update cycle marches on. Especially those
> > > > > > > wanting to take full advantage of CacheFS and encryption
> > > > > > > functionality.=20
> > > > > > >=20
> > > > > > > Again thanks for looking at this and do reach out if I
> > > > > > > can help in anyway. I am in the ceph slack if it's faster
> > > > > > > to reach out that way.
> > > > > > >  =20
> > > > >  =20
>=20
> Could you please add your CephFS kernel client's mount options into
> the ticket [1]?
>=20
> Thanks a lot,
> Slava.
>=20
> [1]=C2=A0https://tracker.ceph.com/issues/74156=20

I've updated the ticket.=20

I am curious about the differences between your test setup and my
actual setup in terms of capacity and hardware.=20

I can provide crash dumps if it is helpful.

Thanks=20

Mal

