Return-Path: <ceph-devel+bounces-2566-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBA68A20F4E
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2025 17:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F9F11617F1
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2025 16:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2AC27452;
	Tue, 28 Jan 2025 16:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KEz6VxZL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01E119DF52
	for <ceph-devel@vger.kernel.org>; Tue, 28 Jan 2025 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738083467; cv=none; b=p5hQW0K3cZrlip2nt+PuYLZCCWslQbsy/iCsyBjjfHjMu7MUggzJ006S38g8GXQGqlM4eJIEcXWw9baC2U57/f6E18qp1bUmE1Id+s8hvdjsDYNqXT3L7lV9b1wvEpanrqRSrOtERvt5DlL2rjzU6dIW+zIrH3KQFTYG2r7BH9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738083467; c=relaxed/simple;
	bh=WkQMBcFuRW6ef2IaWD3Z19F0wcZ8/roOdwXXTwuxa14=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=o+nPusfoOLMp2gilVURIjqKSYtpNrSLefM4jip1STjSg4xtkhNAAaov2GCC834ddQp1aZQOwj1qpguuZLVu7kZnUpZLxS0YpoXTIdKLQ3GT3NadycaDU6KelQ1DJ4xf0itlgpkOA1zl39TqtOfGurp3yPWdBukonNf4QyH1EG1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KEz6VxZL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738083464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCd2G6M1CpUFEZB2/TWmNd3ZWsfTS2NQgah/TGwhkmk=;
	b=KEz6VxZLSr6H3+P/L7IFqcm6FNYST78Dd5zqcpe1AumHUP67tEFyV5UvkdZT39OegYLMyx
	Zt99/KOjib3/14vDvKlqztwuaXXnkPt5SVTmBtpO+ZoIkO1aEO+HithcYV0DyvxVjvPknI
	J85FJ28spRJONvbQ4naXzbElELEUyvo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-o2GdQTibNlSKU_z9_4JMRw-1; Tue,
 28 Jan 2025 11:57:41 -0500
X-MC-Unique: o2GdQTibNlSKU_z9_4JMRw-1
X-Mimecast-MFC-AGG-ID: o2GdQTibNlSKU_z9_4JMRw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B956B1801883;
	Tue, 28 Jan 2025 16:57:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.56])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D563D195608E;
	Tue, 28 Jan 2025 16:57:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3406497.1738080815@warthog.procyon.org.uk>
References: <3406497.1738080815@warthog.procyon.org.uk> <c79589542404f2b73bcdbdc03d65aed0df17d799.camel@ibm.com> <20250117035044.23309-1-slava@dubeyko.com> <988267.1737365634@warthog.procyon.org.uk> <CAO8a2SgkzNQN_S=nKO5QXLG=yQ=x-AaKpFvDoCKz3B_jwBuALQ@mail.gmail.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: dhowells@redhat.com, "idryomov@gmail.com" <idryomov@gmail.com>,
    Alex Markuze <amarkuze@redhat.com>,
    "slava@dubeyko.com" <slava@dubeyko.com>,
    "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
    "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH v2] ceph: Fix kernel crash in generic/397 test
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jan 2025 16:57:35 +0000
Message-ID: <3469649.1738083455@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


David Howells <dhowells@redhat.com> wrote:

> > So, is suggested fix correct or not? If it is not, then which solution
> > could be the right fix here?
>=20
> It'll probably do.  I can't reproduce the issue because I keep hitting a =
hang
> (which I'm trying to debug).

Actually, the hang only seems to be happening with KASAN; non-KASAN seems to
go without crashing - except that the filename handling is screwed:

generic/397       - output mismatch (see /root/xfstests-dev/results//generi=
c/397.out.bad)
    --- tests/generic/397.out   2024-09-12 12:36:14.167441927 +0100
    +++ /root/xfstests-dev/results//generic/397.out.bad 2025-01-28 16:51:03=
.583414909 +0000
    @@ -1,13 +1,27 @@
     QA output created by 397
    +Only in /xfstest.scratch/edir: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy>Xx=EF=BF=BD=EF=BF=BD=EF=BF=BD=D7=84=EF=BF=BD=
=EF=BF=BDz]=EF=BF=BDF=C2=A8h=EF=BF=BD=EF=BF=BD=DD=95=EF=BF=BD=C2=A9M=EF=BF=
=BD=EF=BF=BD=EF=BF=BDUP=C2=B3\=EF=BF=BD
    +Only in /xfstest.scratch/ref_dir: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
    +Only in /xfstest.scratch/edir: +mHXwVcuhV3fcBS7kmbPmA
    +Only in /xfstest.scratch/edir: 8eVfRGNiQlxQ7bFdyyE+AA
    +Only in /xfstest.scratch/edir: ANIxymzfodiFr5DMRbVVtw
    +Only in /xfstest.scratch/edir: Br7L2ajr28IeGcjUD+xeTKOV3BLG9+At3L7poBk=
NSOuo8SZ64W3ulcTKtnxy5ZqMwbQ9kUHd+4Y7VVG6zrxWMmfGOv2KQ4PHyx+FDY4B5NQileJawm=
Bw65oCdofnbycn6Mm10+S2EpqErf30Cl0vgHNTwSn2jExBJhuMjGa2kg7G1DLdgs9dzJZyPzOyV=
vjCnlbTbMV1uQ29e5QhZBuZGwqIxecfweAmr,fD2R,QWh5W5reU
    ...

Mounting the volume manually and looking inside seems to show that the
filenames in the filesystem are looking correct:

	andromeda# ls /xfstest.scratch/scratch/ref_dir/
	a
	abcdefghijklmnopqrstuvwxyz
	empty
	subdir/
	symlink@
	symlink2@
	symlink3@
	yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

but I can't tell if that's because it's correctly decrypting them there - or
whether they're actually stored unencrypted.

So it's entirely possible that due to the filename wrangling being screwed,
I'm not hitting the problem.

David


