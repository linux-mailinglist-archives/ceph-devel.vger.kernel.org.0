Return-Path: <ceph-devel+bounces-2932-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74334A613A1
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 15:29:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6DCF8834B7
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 14:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440D3201016;
	Fri, 14 Mar 2025 14:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V87eoUnL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B294201103
	for <ceph-devel@vger.kernel.org>; Fri, 14 Mar 2025 14:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741962580; cv=none; b=A5A+g09w3HfeUGWZGCHhidYiyVu7KaJM0AF5FZ4sVTGOBQshiApLXWyYgGheOh9ikesg76PaTf2E6Y2YnKOsq0RHqvipCRB8H1I3Fzh6SCU6xhcHyjsjl3puu7F+y73NHsnr0/QZpAGD1VwBtWuEu1rrcxJUQUWAjPIcM3Da89Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741962580; c=relaxed/simple;
	bh=R6wQ0LPfcx42FNFMKtt9za93ud9ZG98gPvD1W2Kuj78=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ZdKgI0P/VqngyKlrgbJfuDae8lJGqGB4EHFpgQtah/8W4tzP7ED5CsDX9ZBbMW4s2ovjRcQCoH/3a001PbEp+T0q3t0FNQawPzPNYxQhtfzbO34JhNlOBKV6i1yrBZb5s3TfaH9QcwC0jazbOknw/PtGKDVdL8Jms3UALC+hWAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V87eoUnL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741962577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5tIDoj/y5fM9MSgiH5M4CLkNpbhiFRyI3coVYCB0FXo=;
	b=V87eoUnLmrojWvKpv5HFmv3excKpyua6JlYWrB0kqz9faWBuWwTKSqaRROPBtXu/O63QP/
	PqO7GtNXzB4rHr0RI7+DRW4QIHcF2HBfUtGV2gTBg+4DeeQ1pjbmJ5IQo3bIqpvuqpca2C
	wV6TiijB7GsIleI04X5OymbGwbCpFyk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-fexmGXzqMz6qUiGgEEifAw-1; Fri,
 14 Mar 2025 10:29:35 -0400
X-MC-Unique: fexmGXzqMz6qUiGgEEifAw-1
X-Mimecast-MFC-AGG-ID: fexmGXzqMz6qUiGgEEifAw_1741962574
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2DDD19560AF;
	Fri, 14 Mar 2025 14:29:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 244861828A87;
	Fri, 14 Mar 2025 14:29:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOi1vP-0yKFKKhy9i2Zmd5coZ59vMMNu2upkZLWvR2sgxWafAw@mail.gmail.com>
References: <CAOi1vP-0yKFKKhy9i2Zmd5coZ59vMMNu2upkZLWvR2sgxWafAw@mail.gmail.com> <1722309.1741949485@warthog.procyon.org.uk>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: dhowells@redhat.com, Viacheslav Dubeyko <slava@dubeyko.com>,
    Alex Markuze <amarkuze@redhat.com>, Jeff Layton <jlayton@kernel.org>,
    ceph-devel@vger.kernel.org
Subject: Re: What are the I/O boundaries for read/write to a ceph object?
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1771619.1741962570.1@warthog.procyon.org.uk>
Date: Fri, 14 Mar 2025 14:29:30 +0000
Message-ID: <1771620.1741962570@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Ilya,

Ilya Dryomov <idryomov@gmail.com> wrote:

> > Can you tell me what the I/O boundaries are for splitting up a read or a
> > write request into separate subrequests?
> >
> > Does each RPC call need to fit within the bounds of an object or does it
> > need to fit within the bounds of a stripe/block?
>
> Within the bounds of a RADOS object.

Okay, thanks.

> > Can a vectored read/write access multiple objects/blocks?
> 
> I'm not sure what "vectored" means in this context,

Where rather than issuing, say, a read data RPC with a single range to read, I
can give it a list of non-contiguous regions to read.  I might do this, for
example, if the VM issues a readahead request for a non-contiguous set of
folios that fill in the gaps around a folio already present in the pagecache.

> but a single read/write coming from the VFS may need to access multiple
> RADOS objects.  Assuming that the object size is 4M (default), the simplest
> example is a request for 8192 bytes at 4190208 offset in the file.

netfslib allows for a request to be split up into a number of subrequests,
where each subrequest can be of a different size and may access a different
server or fscache.  What I need to make the ->prepare_read() function do is,
for the specified starting point in the given file, return how many bytes we
can possibly read before we have to issue the next subrequest.

I currently have this (note this isn't what is in the patches I posted
yesterday):

	static int ceph_netfs_prepare_read(struct netfs_io_subrequest *subreq)
	{
		struct netfs_io_request *rreq = subreq->rreq;
		struct ceph_inode_info *ci = ceph_inode(rreq->inode);
		struct ceph_fs_client *fsc =
			ceph_inode_to_fs_client(rreq->inode);
		const struct ceph_file_layout *layout = &ci->i_layout;

		size_t blocksize = layout->stripe_unit;
		size_t blockoff = subreq->start & (blocksize - 1);

		/* Truncate the extent at the end of the current block */
		rreq->io_streams[0].sreq_max_len =
			umin(blocksize - blockoff,
			     fsc->mount_options->rsize);

		return 0;
	}

where "rreq->io_streams[0].sreq_max_len" gets set to the maximum length we can
make the next subrequest.  I've made a number of assumptions here that I don't
know are valid:

 - The I/O block size is the stripe unit size.
 - Blocks are all the same size.
 - Blocks are a power-of-2 size.

> > What I'm trying to do is to avoid using ceph_calc_file_object_mapping() as
> > it does a bunch of 128-bit divisions for which I don't need the answers.
> > I only need xlen - and really, I just need the limits of the read or write
> > I can make.
> 
> I don't think ceph_calc_file_object_mapping() can be avoided in the
> general case.  With non-default ("fancy") striping, given for example
> stripe_unit=64K and stripe_count=5, a single 64K * 6 = 384K request at
> offset 0 in the file would need to access 5 RADOS objects, with the
> first object/RPC delivering 128K and the other four objects/RPCs 64K
> each.

ceph_calc_file_object_mapping() seems to assume that the stripe_unit size and
the object_size are fixed.  Is this something that might change?

Would you object to me putting an additional function in libceph next to that
one that just gets me that span of the block containing the specified file
position?

Thanks,
David


