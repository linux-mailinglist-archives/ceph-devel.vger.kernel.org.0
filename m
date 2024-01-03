Return-Path: <ceph-devel+bounces-459-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F90822F08
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jan 2024 14:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55A281C2353E
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jan 2024 13:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66961A27A;
	Wed,  3 Jan 2024 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EDzdTuCL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F170A1A27D
	for <ceph-devel@vger.kernel.org>; Wed,  3 Jan 2024 13:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704290366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6dAWkrI8v4YS0rv7Bi/6xzx13i604x2fNTwwBvd0CnM=;
	b=EDzdTuCLRu9QIUAoUDIzMpveOmJb1nvDxih1sQIefa3VTHFakuVjMV8stqcY35dTJgLe/o
	YgtoOx2C+mqOk5QEMeyBhs1N/cJElNjKgtQbXw+0dNmf0XU9UlIHVF/lSkOA76nf+Si29q
	V4kP258mMREtuEE0h4KOy5qfFqnSONY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-faj2gZTSNqKsLFzR_ZyENA-1; Wed, 03 Jan 2024 08:59:23 -0500
X-MC-Unique: faj2gZTSNqKsLFzR_ZyENA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDA55845DC1;
	Wed,  3 Jan 2024 13:59:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B5F0940C6EB9;
	Wed,  3 Jan 2024 13:59:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZZVctju5TEjS218p@codewreck.org>
References: <ZZVctju5TEjS218p@codewreck.org> <20231221132400.1601991-41-dhowells@redhat.com> <20231221132400.1601991-1-dhowells@redhat.com> <292837.1704232179@warthog.procyon.org.uk>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: dhowells@redhat.com, Eric Van Hensbergen <ericvh@kernel.org>,
    Latchesar Ionkov <lucho@ionkov.net>,
    Jeff Layton <jlayton@kernel.org>, Steve French <smfrench@gmail.com>,
    Matthew Wilcox <willy@infradead.org>,
    Marc Dionne <marc.dionne@auristor.com>,
    Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Ilya Dryomov <idryomov@gmail.com>,
    Christian Brauner <christian@brauner.io>, linux-cachefs@redhat.com,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-mm@kvack.org, netdev@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    Christian Schoenebeck <linux_oss@crudebyte.com>
Subject: Re: [PATCH] 9p: Fix initialisation of netfs_inode for 9p
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <357812.1704290358.1@warthog.procyon.org.uk>
Date: Wed, 03 Jan 2024 13:59:18 +0000
Message-ID: <357813.1704290358@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Dominique Martinet <asmadeus@codewreck.org> wrote:

> Would it make sense to just always update netfs's ctx->remote_i_size in
> the various stat2inode calls instead?

Yeah, that's probably a good idea.

David


