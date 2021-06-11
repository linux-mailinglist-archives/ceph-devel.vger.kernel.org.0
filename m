Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2693A44B5
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 17:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhFKPOL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 11:14:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhFKPOL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 11:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623424332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s82f1RJE5dBr2h5T3lvpv8FHEO/7j+hUbPOTCqhPc9s=;
        b=f5z1fvrdXhYB7MVIBhHDvcCA8zqi4nCz7pfO0bTEaoFX5RYmteQeihN77fZUM81hMmiKdA
        MRhs5UvrieKu/pRMm7576GM8c3hdwllpX/9Hid6RKvq64G9/n+Xfd5lTP3gdSmn/SlflXL
        la7VumcE9SaRpHXV2d6SkEGgVr0SIiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-uuIFZtvTPJOCg7g4HZhxKQ-1; Fri, 11 Jun 2021 11:12:09 -0400
X-MC-Unique: uuIFZtvTPJOCg7g4HZhxKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B72310A83EA;
        Fri, 11 Jun 2021 15:11:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 302682B0A6;
        Fri, 11 Jun 2021 15:11:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <a24c3c070c9fc3529a51f00f9ccc3d0abdd0b821.camel@kernel.org>
References: <a24c3c070c9fc3529a51f00f9ccc3d0abdd0b821.camel@kernel.org> <20200916173854.330265-1-jlayton@kernel.org> <20200916173854.330265-6-jlayton@kernel.org> <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org> <m2h7i45vzl.fsf@discipline.rit.edu>
To:     Jeff Layton <jlayton@kernel.org>, willy@infradead.org
Cc:     dhowells@redhat.com, Andrew W Elble <aweits@rit.edu>,
        ceph-devel@vger.kernel.org, pfmeec@rit.edu,
        linux-cachefs@redhat.com
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into ceph_write_begin
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <66263.1623424309.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 11 Jun 2021 16:11:49 +0100
Message-ID: <66264.1623424309@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> wrote:

> On Fri, 2021-06-11 at 10:14 -0400, Andrew W Elble wrote:
> > We're seeing file corruption while running 5.10, bisected to 1cc169907=
0bd:
> > =

> > > > +static int ceph_write_begin(struct file *file, struct address_spa=
ce *mapping,
> > > > +			    loff_t pos, unsigned len, unsigned flags,
> > > > +			    struct page **pagep, void **fsdata)
> > =

> > <snip>
> > =

> > > > +		/*
> > > > +		 * In some cases we don't need to read at all:
> > > > +		 * - full page write
> > > > +		 * - write that lies completely beyond EOF
> > > > +		 * - write that covers the the page from start to EOF or beyond=
 it
> > > > +		 */
> > > > +		if ((pos_in_page =3D=3D 0 && len =3D=3D PAGE_SIZE) ||
> > > > +		    (pos >=3D i_size_read(inode)) ||
> > =

> > Shouldn't this be '((pos & PAGE_MASK) >=3D i_size_read(inode)) ||' ?
> > =

> > Seems like fs/netfs/read_helper.c currently has the same issue?

That's not quite right either.  page may be larger than PAGE_MASK if
grab_cache_page_write_begin() returns a THP (if that's possible).

Maybe:

	(pos & thp_size(page) - 1) >=3D i_size_read(inode)

Really, we want something like thp_pos().  Maybe Willy has something like =
that
up his sleeve.

In fact, in netfs_write_begin(), index and pos_in_page should be calculate=
d
after grab_cache_page_write_begin() has been called, just in case the new =
page
extends before the page containing the requested position.

David

