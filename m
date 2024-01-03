Return-Path: <ceph-devel+bounces-455-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A2B1822CAB
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jan 2024 13:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD203284127
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jan 2024 12:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6431A18ECD;
	Wed,  3 Jan 2024 12:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AT5Td98Y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0D618EB0
	for <ceph-devel@vger.kernel.org>; Wed,  3 Jan 2024 12:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704283706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xn3hPmKlXFLs1haHAodNqDYoLKo2JnMk0c6eSg9WYzE=;
	b=AT5Td98YhH5DVj8AA3Q3H043oKTOVgfg9H/pF+8I4xez/VOFhMyh89g05oCHGmXYcSMoXL
	XGgP+LO82USNCYaEfqt1jNIJ8SDQru5aBOc/+SaJYOBNR+nc44JQLjns5wYvB8Me1/ntRP
	RrVVRrnjC/N3f3TzVis1LdDex9Dg/tk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-464-ipNzNXHGPhaBuxD3VhW4ZQ-1; Wed,
 03 Jan 2024 07:08:23 -0500
X-MC-Unique: ipNzNXHGPhaBuxD3VhW4ZQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F9663C025B4;
	Wed,  3 Jan 2024 12:08:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C516D492BE6;
	Wed,  3 Jan 2024 12:08:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZZULNQAZ0n0WQv7p@codewreck.org>
References: <ZZULNQAZ0n0WQv7p@codewreck.org> <20231221132400.1601991-1-dhowells@redhat.com> <20231221132400.1601991-41-dhowells@redhat.com>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
    Steve French <smfrench@gmail.com>,
    Matthew Wilcox <willy@infradead.org>,
    Marc Dionne <marc.dionne@auristor.com>,
    Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Ilya Dryomov <idryomov@gmail.com>,
    Christian Brauner <christian@brauner.io>, linux-cachefs@redhat.com,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-mm@kvack.org, netdev@vger.kernel.org,
    linux-kernel@vger.kernel.org, Latchesar Ionkov <lucho@ionkov.net>,
    Christian Schoenebeck <linux_oss@crudebyte.com>
Subject: Re: [PATCH v5 40/40] 9p: Use netfslib read/write_iter
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <354049.1704283697.1@warthog.procyon.org.uk>
Date: Wed, 03 Jan 2024 12:08:18 +0000
Message-ID: <354050.1704283698@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Dominique Martinet <asmadeus@codewreck.org> wrote:

> I've also manually confirmed one of the big improvements I'd been asking
> for (that writes in cached modes, which used to be chunked to 4k, and
> are now properly aggregated, so e.g 'dd bs=1M count=1' will properly
> issue a minimal number of TWRITE calls capped by msize) -- this is
> great!

After the merge window, we can look at enabling multipage folios for 9p.

> I've noticed we don't cache xattrs are all,

I haven't given this any particular thought.  We could attach them to the
cachefile object as xattrs, but it means you have to do two xattr lookups in
the event of a cache miss.

At this point, I'm going to ask Christian to stack the extra patch on his
branch rather than folding it down and retagging.

> I've got a couple of questions below, but:

I'll address those separately.

> Tested-by: Dominique Martinet <asmadeus@codewreck.org>
> Acked-by: Dominique Martinet <asmadeus@codewreck.org>

Thanks!

David


