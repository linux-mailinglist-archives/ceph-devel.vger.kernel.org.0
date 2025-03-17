Return-Path: <ceph-devel+bounces-2944-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D13A64D5E
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Mar 2025 12:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7DF97A35D0
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Mar 2025 11:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3072A2376F9;
	Mon, 17 Mar 2025 11:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J3aBP1bv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2F321B9D6
	for <ceph-devel@vger.kernel.org>; Mon, 17 Mar 2025 11:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742212388; cv=none; b=FeXYsBHQ3FTfyhBBFKL3TvKeiuSeBSC92+FYmliRLSymIhXaqJBgLEWKDwL0+2zxN0DSW/KvE5Xh5T1MydaXCWjh/5L7Miy0YQgxG0Sc0f4/L2CZvdTxG0xaafDCiiQ09bQtCKZPWVfUXtr/rup+3NFXV3ZihV4zPRdX36Gbu2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742212388; c=relaxed/simple;
	bh=5kErYDQm5IeYb+fhyjZg6NjqMDCo2JxgEGxd2Qz+a3Q=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ABsmGpwWrhZ0gzx8K0zyH0AFY5HihoW/Chq0oIJQAml1i+1sxvidlyWfnD7mcjT0aw8abFxok0/v0+9HP45N0wJqlTxU//CLJVrDhHOM5vcMONz2dhjtLyVIY2/p+MTyBJaQiuyAvGGwTXMomcNEMwexLcagg5v3FAf+TfDJ91c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J3aBP1bv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742212385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YcQ5Y3qi8I25j6PFVriuZX0AXowSo1CEZ8WifhltYCQ=;
	b=J3aBP1bvy1FljZt3MxIHkdsNsFk4kTbIhCxveJ3yZBrlmv8DSsqvazup7I+fiyx6FrFJvc
	Ki5z5WPTHXc7aeyrGZTDXupZ4aUf23HVEgzrgtef/v0EWfDLdoe6n7UbjIVPvIMDgNGjc6
	X8lctNC8pb9EJrwgOcUx6asHufNA7ac=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-VFydDtk5ObakTPaIGfce_g-1; Mon,
 17 Mar 2025 07:53:04 -0400
X-MC-Unique: VFydDtk5ObakTPaIGfce_g-1
X-Mimecast-MFC-AGG-ID: VFydDtk5ObakTPaIGfce_g_1742212383
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C34DF195605A;
	Mon, 17 Mar 2025 11:53:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 55A711800946;
	Mon, 17 Mar 2025 11:52:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <a62918950646701cb9bb2ab0a32c87b53e2f102e.camel@dubeyko.com>
References: <a62918950646701cb9bb2ab0a32c87b53e2f102e.camel@dubeyko.com> <20250313233341.1675324-1-dhowells@redhat.com> <20250313233341.1675324-5-dhowells@redhat.com>
To: slava@dubeyko.com
Cc: dhowells@redhat.com, Alex Markuze <amarkuze@redhat.com>,
    Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>,
    Dongsheng Yang <dongsheng.yang@easystack.cn>,
    ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
    Slava.Dubeyko@ibm.com
Subject: Re: [RFC PATCH 04/35] ceph: Convert ceph_mds_request::r_pagelist to a databuf
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Mar 2025 11:52:58 +0000
Message-ID: <2161520.1742212378@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

slava@dubeyko.com wrote:

> > -		err =3D ceph_pagelist_reserve(pagelist, len +
> > val_size1 + 8);
> > +		err =3D ceph_databuf_reserve(dbuf, len + val_size1 +
> > 8,
> > +					=C2=A0=C2=A0 GFP_KERNEL);
>=20
> I know that it's simple change. But this len + val_size1 + 8 looks
> confusing, anyway. What this hardcoded 8 means? :)

You tell me.  The '8' is pre-existing.

> > -	if (req->r_pagelist) {
> > -		iinfo.xattr_len =3D req->r_pagelist->length;
> > -		iinfo.xattr_data =3D req->r_pagelist->mapped_tail;
> > +	if (req->r_dbuf) {
> > +		iinfo.xattr_len =3D ceph_databuf_len(req->r_dbuf);
> > +		iinfo.xattr_data =3D kmap_ceph_databuf_page(req-
> > >r_dbuf, 0);
>=20
> Possibly, it's in another patch. Have we removed req->r_pagelist from
> the structure?

See patch 20 "libceph: Remove ceph_pagelist".

It cannot be removed here as the kernel must still compile and work at this
point.

> Do we always have memory pages in ceph_databuf? How
> kmap_ceph_databuf_page() will behave if it's not memory page.

Are there other sorts of pages?

> Maybe, we need to hide kunmap_local() into something like
> kunmap_ceph_databuf_page()?

Actually, probably better to rename kmap_ceph_databuf_page() to
kmap_local_ceph_databuf().

> Maybe, it makes sense to call something like ceph_databuf_length()
> instead of low level access to dbuf->nr_bvec?

Sounds reasonable.  Better to hide the internal workings.

> > +	if (as_ctx->dbuf) {
> > +		req->r_dbuf =3D as_ctx->dbuf;
> > +		as_ctx->dbuf =3D NULL;
>=20
> Maybe, we need something like swap() method? :)

I could point out that you were complaining about ceph_databuf_get() return=
ing
a pointer than a void;-).

> > +	dbuf =3D ceph_databuf_req_alloc(2, 0, GFP_KERNEL);
>=20
> So, do we allocate 2 items of zero length here?

You don't.  One is the bvec[] count (2) and one is that amount of memory to
preallocate (0) and attach to that bvec[].

Now, it may make sense to split the API calls to handle a number of differe=
nt
scenarios, e.g.: request with just protocol, no pages; request with just
pages; request with both protocol bits and page list.

> > +	if (ceph_databuf_insert_frag(dbuf, 0, sizeof(*header),
> > GFP_KERNEL) < 0)
> > +		goto out;
> > +	if (ceph_databuf_insert_frag(dbuf, 1, PAGE_SIZE, GFP_KERNEL)
> > < 0)
> >  		goto out;
> >=20=20
> > +	iov_iter_bvec(&iter, ITER_DEST, &dbuf->bvec[1], 1, len);
>=20
> Is it correct &dbuf->bvec[1]? Why do we work with item #1? I think it
> looks confusing.

Because you have a protocol element (in dbuf->bvec[0]) and a buffer (in
dbuf->bvec[1]).

An iterator is attached to the buffer and the iterator then conveys it to
__ceph_sync_read() as the destination.

If you look a few lines further on in the patch, you can see the first
fragment being accessed:

> +	header =3D kmap_ceph_databuf_page(dbuf, 0);
> +

Note that, because the read buffer is very likely a whole page, I split them
into separate sections rather than trying to allocate an order-1 page as th=
at
would be more likely to fail.

> > -		header.data_len =3D cpu_to_le32(8 + 8 + 4);
> > -		header.file_offset =3D 0;
> > +		header->data_len =3D cpu_to_le32(8 + 8 + 4);
>=20
> The same problem of understanding here for me. What this hardcoded 8 +
> 8 + 4 value means? :)

You need to ask a ceph expert.  This is nothing specifically to do with my
changes.  However, I suspect it's the size of the message element.

> > -		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
> > +		p =3D kmap_ceph_databuf_page(dbuf, 1);
>=20
> Maybe, we need to introduce some constants to address #0 and #1 pages?
> Because, #0 it's header and I assume #1 is some content.

Whilst that might be useful, I don't know that the 0 and 1... being header =
and
content respectively always hold.  I haven't checked, but there could even =
be
a protocol trailer in some cases as well.

> > -	err =3D ceph_pagelist_reserve(pagelist,
> > -				=C2=A0=C2=A0=C2=A0 4 * 2 + name_len + as_ctx-
> > >lsmctx.len);
> > +	err =3D ceph_databuf_reserve(dbuf, 4 * 2 + name_len + as_ctx-
> > >lsmctx.len,
> > +				=C2=A0=C2=A0 GFP_KERNEL);
>=20
> The 4 * 2 + name_len + as_ctx->lsmctx.len looks unclear to me. It wil
> be good to have some well defined constants here.

Again, nothing specifically to do with my changes.

David


