Return-Path: <ceph-devel+bounces-572-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C666D83070D
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 14:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A03AB23E75
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 13:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83C71F602;
	Wed, 17 Jan 2024 13:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5EzCfm9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DAB1EB3A
	for <ceph-devel@vger.kernel.org>; Wed, 17 Jan 2024 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705497972; cv=none; b=WwOx4jAIEUZ4gB+EFtt+FoV+g0Xz9obDBenzBhc9zX6csTZ7XjNivog36sUPyLX2jumTjO4xrh1hHpyQeoWY1/SBPOqL3vuaGHYAyscl/SlL1BYbhHzfZYyrBTkmarQeyW5ysv0zSQtuE6h9mCzio7b1xQy7fdS0gKgdSTCWgps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705497972; c=relaxed/simple;
	bh=OPOoP9UgIckMad4MC0xQT4ogrYoDI41gySdqC4ReyPA=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:
	 Organization:From:In-Reply-To:References:To:cc:Subject:
	 MIME-Version:Content-Type:Content-ID:Date:Message-ID:X-Scanned-By;
	b=MitJKdN0yRCs853hwPfqGxeL85C+Ic6kkr6e8B35Qbmprq63Wd5EbU/WO6fddxLlWJBaYqAmUZ7o3lpsfg4iXohBF/+SuPkdcl6w3eUHdoOzrqjqOFTz3bq1XwyTaBOrMDuklg3Mn/oShM1IysRShxenih/jfq0MIa4os+pUSXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I5EzCfm9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705497969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FsSzWO6NIq2VcxMsblj4BWBZVF2ZpmLB+3az7ONnZQM=;
	b=I5EzCfm9hUCtnnXY2b+EDvFDl4ruxCWFd9vFymzSQ8OspC6olIG+A2CHlawJ6YfXUHa6Qw
	4L0QCRvQ+U+l9NINtZTjEaQp4UZqKUJc3/hCx/3RaWi5AjA+RM6Ve4ndumaN3CwU2LwLz1
	GoVt20M1CEZT9PpYcNgTi+jiRcP7OBw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-Oe-laUu7NUWY9jmEaxHoOQ-1; Wed, 17 Jan 2024 08:26:06 -0500
X-MC-Unique: Oe-laUu7NUWY9jmEaxHoOQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63A7B867943;
	Wed, 17 Jan 2024 13:26:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63FC3492BC6;
	Wed, 17 Jan 2024 13:25:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240116-flsplit-v1-2-c9d0f4370a5d@kernel.org>
References: <20240116-flsplit-v1-2-c9d0f4370a5d@kernel.org> <20240116-flsplit-v1-0-c9d0f4370a5d@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
cc: Christian Brauner <brauner@kernel.org>,
    Alexander Viro <viro@zeniv.linux.org.uk>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Latchesar Ionkov <lucho@ionkov.net>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Christian Schoenebeck <linux_oss@crudebyte.com>,
    David Howells <dhowells@redhat.com>,
    Marc Dionne <marc.dionne@auristor.com>, Xiubo Li <xiubli@redhat.com>,
    Ilya Dryomov <idryomov@gmail.com>,
    Alexander Aring <aahringo@redhat.com>,
    David Teigland <teigland@redhat.com>,
    Miklos Szeredi <miklos@szeredi.hu>,
    Andreas Gruenbacher <agruenba@redhat.com>,
    Trond Myklebust <trond.myklebust@hammerspace.com>,
    Anna Schumaker <anna@kernel.org>,
    Chuck Lever <chuck.lever@oracle.com>, Neil Brown <neilb@suse.de>,
    Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>,
    Tom Talpey <tom@talpey.com>, Jan Kara <jack@suse.cz>,
    Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
    Joseph Qi <joseph.qi@linux.alibaba.com>,
    Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
    Ronnie Sahlberg <lsahlber@redhat.com>,
    Shyam Prasad N <sprasad@microsoft.com>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Sergey Senozhatsky <senozhatsky@chromium.org>,
    Steven Rostedt <rostedt@goodmis.org>,
    Masami Hiramatsu <mhiramat@kernel.org>,
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
    linux-kernel@vger.kernel.org, v9fs@lists.linux.dev,
    linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
    gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
    linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
    linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] filelock: add coccinelle scripts to move fields to struct file_lock_core
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2782046.1705497954.1@warthog.procyon.org.uk>
Date: Wed, 17 Jan 2024 13:25:54 +0000
Message-ID: <2782047.1705497954@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Do we need to keep these coccinelle scripts for posterity?  Or can they just
be included in the patch description of the patch that generates them?

David


