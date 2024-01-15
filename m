Return-Path: <ceph-devel+bounces-524-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A200082DAFB
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jan 2024 15:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5020E2823BB
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jan 2024 14:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28FB117596;
	Mon, 15 Jan 2024 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cbk/FolB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F61F17585
	for <ceph-devel@vger.kernel.org>; Mon, 15 Jan 2024 14:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705327642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=6UGAmvnN9vu20rSCuTfIMI8NQtf87J3Pzjj0y1Zo8sg=;
	b=Cbk/FolBqvb8RzCoVCO7wMOiX6WrzDMUn9DJCwGoFmWkqfe87o/V9/lYTksx8m9Hw2++0J
	qhq+t3D5uZ8EWU6AgeYdWLTVmHGbpNYGr4JvMciOY3ZkkPgmhZLMmPWdJNo+xiHBOX2wTM
	KjjssLmpqQ0nyYzeQwQYi8eh5I6YAc8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-GRhk1qCuPcigwF9PoRAraA-1; Mon, 15 Jan 2024 09:07:20 -0500
X-MC-Unique: GRhk1qCuPcigwF9PoRAraA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D08685A58A;
	Mon, 15 Jan 2024 14:07:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A408D1C060B2;
	Mon, 15 Jan 2024 14:07:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
    Greg Farnum <gfarnum@redhat.com>,
    Venky Shankar <vshankar@redhat.com>
cc: dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
    ceph-devel@vger.kernel.org
Subject: Modifying and fixing(?) the per-inode snap handling in ceph
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2546439.1705327638.1@warthog.procyon.org.uk>
Date: Mon, 15 Jan 2024 14:07:18 +0000
Message-ID: <2546440.1705327638@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Hi, Ilya, Xiubo, Greg,

I'm trying to finish my patches to make ceph work with netfslib and I'm
wondering if snap handling on inodes can be made easier to work with.  Also, I
think there may be a bug in the interaction between ceph_queue_cap_snap() and
writable mmaps.

What I would like to do is to make page/folio->private point at the
ceph_cap_snap struct instead of pointing to ceph_snap_context.  This makes it
easier to fish the metadata details out in ceph when netfslib asks it to
perform a write operation.

Netfslib has the capability to pass an netfs_group struct through the API, and
I currently have this subclassed by ceph_snap_context, but that doesn't
directly carry sufficient information as I presume that's a global thing and
not an inode-specific thing.

However, it looks like capsnaps don't always exist, even on dirty inodes...

So what I'm thinking is:

 (1) Make struct ceph_cap_snap a subclass of netfs_group.  This would allow
     netfslib to manipulate them and attach them to dirty pages and do
     selective writeback.

 (2) Always keep a ceph_cap_snap on a dirty inode.  It can be treated
     specially when it's the only snap and at the head.

 (3) Offload some of the fields from ceph_inode_info into ceph_cap_snap
     (eg. truncate_size and truncate_seq) and update them directly there.

 (4) On entry to any sort of write routine, see if we need a new capsnap for
     that inode and, if so, create one.  This would include ->write_iter(),
     ->page_mkwrite(), ->setattr(), possibly ->setxattr(),

 (5) In queue_realm_cap_snaps(), mark the capsnap as being obsolete and call
     unmap_mapping_pages() on each inode to force ->page_mkwrite() to be
     called[!] on further modification.

     queue_realm_cap_snaps() doesn't then need to create a new snapcap; this
     can be left to the various write routines.

     [!] This would fix the aforementioned potential bug whereby someone can
     continue writing to the inode even though a new snap has happened.

 (6) ceph_writepages() calls netfs_writepages_group() to flush out pages with
     the matching group, stepping through the capsnap list on the inode.

Any thoughts on whether this would work?  If I can do this, I can reduce
get_oldest_context() to almost nothing and don't need the ceph_writeback_ctl
struct anymore (I think).

Thanks,
David


