Return-Path: <ceph-devel+bounces-2985-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7AA2A6AA13
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Mar 2025 16:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABCD78A799A
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Mar 2025 15:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75EAB1E9B0B;
	Thu, 20 Mar 2025 15:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ps3+GrkA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38321E500C
	for <ceph-devel@vger.kernel.org>; Thu, 20 Mar 2025 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742485102; cv=none; b=nF8JULq6XNGs6qS5irepQkZsnLNyXmbYycMNrkyRGkhR3UCvxh6J/pFIj9UNbDY2noQ+kHJyFETGsjcu3kGgNuqCDvNYIaqcWQCdXFTf+Vi0NdrvVM8jNtQk9fj11yfOrMusclsiYeFcsA+w7iuF/W8AIIZIbDhgvRnou7WGML8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742485102; c=relaxed/simple;
	bh=uRdiTVbQkm4pvbxGi/kkATI+pxb9e8rW3KQUa7Y7oGE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=PItBlmFrJ2+CN3K+p94T9CxPddhnAZ/4atQqpRuLBExacG7TH/xBrUO7zCnC5xW78whUjMOgqpzzHjbyHMqoNylNyK57MzJ2BysGCo9st5nqDRvNibzrnf2MjNf/3YI2V2kyP8kbwwUddLmtCaFptiP40faTNHg/g85cscmL/e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ps3+GrkA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742485099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jfSEIrY/qgegWJTIRwrY+ragQR0uVn2TNvXZB6uD0e8=;
	b=Ps3+GrkAxMU2CbrHKBnD8yeCYqAUZz1RCJNAJRboT+CK9LW8B3+6hl3JTJHp0zGacw7+nb
	uxALD/52w1Kghy7xBkqlpY+W9J9xOIEc2HPQu1/2ESnnb3hEZEiYte/fY6l0+cF+SvEYNT
	vo7Fy0Hl+14woLiAH+IQ7SzrFuHnrY4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-7-UAd8ssNKi_alG6mQXI0A-1; Thu,
 20 Mar 2025 11:38:15 -0400
X-MC-Unique: 7-UAd8ssNKi_alG6mQXI0A-1
X-Mimecast-MFC-AGG-ID: 7-UAd8ssNKi_alG6mQXI0A_1742485093
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B138E180AF4C;
	Thu, 20 Mar 2025 15:38:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BB3361955BFE;
	Thu, 20 Mar 2025 15:38:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4c30dae500352e31a47ecfa34d60f4a8c015297e.camel@ibm.com>
References: <4c30dae500352e31a47ecfa34d60f4a8c015297e.camel@ibm.com> <20250313233341.1675324-1-dhowells@redhat.com> <20250313233341.1675324-34-dhowells@redhat.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: dhowells@redhat.com, Alex Markuze <amarkuze@redhat.com>,
    "slava@dubeyko.com" <slava@dubeyko.com>,
    "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
    "idryomov@gmail.com" <idryomov@gmail.com>,
    "jlayton@kernel.org" <jlayton@kernel.org>,
    "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
    "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
    "dongsheng.yang@easystack.cn" <dongsheng.yang@easystack.cn>,
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 33/35] ceph: Use netfslib [INCOMPLETE]
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3174102.1742485088.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 20 Mar 2025 15:38:08 +0000
Message-ID: <3174103.1742485088@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com> wrote:

> > +		fret =3D ceph_fscrypt_decrypt_pages(inode, &page[pgidx],
> > +						 off + pgsoff, ext->len);
> > +		dout("%s: [%d] 0x%llx~0x%llx fret %d\n", __func__, i,
> > +				ext->off, ext->len, fret);
> > +		if (fret < 0) {
> =

> Possibly, I am missing some logic here. But do we really need to introdu=
ce fret?
> Why we cannot user ret here? =

> =

> > +			if (ret =3D=3D 0)
> > +				ret =3D fret;
> > +			break;
> > +		}
> > +		ret =3D pgsoff + fret;

Because ret holds the amount of data so far decrypted.  We should only ret=
urn
an error if we didn't decrypt any (ie. ret =3D=3D 0 at the time of error).

> > +static int ceph_init_request(struct netfs_io_request *rreq, struct fi=
le *file)
> > +{
> > +	struct ceph_io_request *priv =3D container_of(rreq, struct ceph_io_r=
equest, rreq);
> > +	struct inode *inode =3D rreq->inode;
> > +	struct ceph_client *cl =3D ceph_inode_to_client(inode);
> > +	struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
> > +	int got =3D 0, want =3D CEPH_CAP_FILE_CACHE;
> > +	int ret =3D 0;
> > +
> > +	rreq->rsize =3D 1024 * 1024;
> =

> Why do we hardcoded rreq->rsize value?
> =

> struct ceph_mount_options {
> 	unsigned int flags;
> =

> 	unsigned int wsize;            /* max write size */
> 	unsigned int rsize;            /* max read size */
> 	unsigned int rasize;           /* max readahead */
> 	unsigned int congestion_kb;    /* max writeback in flight */
> 	unsigned int caps_wanted_delay_min, caps_wanted_delay_max;
> 	int caps_max;
> 	unsigned int max_readdir;       /* max readdir result (entries) */
> 	unsigned int max_readdir_bytes; /* max readdir result (bytes) */
> =

> 	bool new_dev_syntax;
> =

> 	/*
> 	 * everything above this point can be memcmp'd; everything below
> 	 * is handled in compare_mount_options()
> 	 */
> =

> 	char *snapdir_name;   /* default ".snap" */
> 	char *mds_namespace;  /* default NULL */
> 	char *server_path;    /* default NULL (means "/") */
> 	char *fscache_uniq;   /* default NULL */
> 	char *mon_addr;
> 	struct fscrypt_dummy_policy dummy_enc_policy;
> };
> =

> Why we don't use fsc->mount_options->rsize?

Actually, I should get rid of rreq->rsize since there's now a function,
->prepare_read() to deal with this.

> > +	loff_t limit =3D max(i_size_read(inode), fsc->max_file_size);
> =

> Do we need to take into account the quota max bytes here?

Could be.

> > +/*
> > + * Size of allocations for default netfs_io_(sub)request object slabs=
 and
> > + * mempools.  If a filesystem's request and subrequest objects fit wi=
thin this
> > + * size, they can use these otherwise they must provide their own.
> > + */
> > +#define NETFS_DEF_IO_REQUEST_SIZE (sizeof(struct netfs_io_request) + =
24)
> =

> Why do we hardcode 24 here? What's about named constant? And why namely =
24?
> =

> > +#define NETFS_DEF_IO_SUBREQUEST_SIZE (sizeof(struct netfs_io_subreque=
st) + 16)
> =

> The same question about 16.

See the comment.  24 allows three extra words and 16 two.  Actually, I sho=
uld
probably express it as a multiple of sizeof(long).  But this allows netfsl=
ib
to allocate (sub)request structs for ceph from the default mempool by allo=
wing
a little bit of extra space.

David


