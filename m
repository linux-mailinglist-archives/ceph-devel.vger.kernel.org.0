Return-Path: <ceph-devel+bounces-2335-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E1F9F0E0C
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Dec 2024 14:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9913716B888
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Dec 2024 13:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23DB1E04A1;
	Fri, 13 Dec 2024 13:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gFcncDkQ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A8D1EE7AF
	for <ceph-devel@vger.kernel.org>; Fri, 13 Dec 2024 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734097897; cv=none; b=fZT7lge0g5KHF3TJ4W1I+m0gv955AYsvcjshS5eykXlAM9+MDl4+qk51nHIbXdKUELcYHjhZv7fKObHH09mqju1agbKY+zq1Nltmmr7YcKxLqS+WpdB/0Sz399NqwuVv4aUk4qKv3SCYqpGJW21jQ1pcCvcQJFw+yYb8FP9XAZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734097897; c=relaxed/simple;
	bh=SrqCMAuMjlWi8sIixKN4Dar0oa3TrmkaDfBeGAAPycg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQg76iPjKV8YCyIsMY3DRQ+gpt7H5/FZdbr43TYa7IDRoJSnyQpYO+n/X3460oAfadqQU+mCUmJTIS/Y/0UWzJSFXqlS6XaFKu5aCpXAkBZ19bTvJf9oqS6QDGymngull3SGvfL4q9qeoMQeh/auIFc3F82au6Bht4DET96qE84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gFcncDkQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734097893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1v5Uahl/uBNImxZaUKZS5taSNKrtxd0nK3bDl+BkV8=;
	b=gFcncDkQScyof+oZWSXMb8Uj0dNkyguo4wg2n5Zd76UMxbvtlZjSHs23Uio68rTlPl+KXk
	by5rmukTvE6soTdYUbACScuDCdeQSK/JEnxqwFtNIPECCRWDwycnCFLInVLgS0h6I+NPTn
	JAW1c2Cmkk3mLtmbZtKPqunVyrmD43c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-iuxIXFenMlSlR7jWS7DojA-1; Fri,
 13 Dec 2024 08:51:30 -0500
X-MC-Unique: iuxIXFenMlSlR7jWS7DojA-1
X-Mimecast-MFC-AGG-ID: iuxIXFenMlSlR7jWS7DojA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 059B41955F08;
	Fri, 13 Dec 2024 13:51:28 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.48])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 056F31956086;
	Fri, 13 Dec 2024 13:51:22 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] netfs: Fix the (non-)cancellation of copy when cache is temporarily disabled
Date: Fri, 13 Dec 2024 13:50:10 +0000
Message-ID: <20241213135013.2964079-11-dhowells@redhat.com>
In-Reply-To: <20241213135013.2964079-1-dhowells@redhat.com>
References: <20241213135013.2964079-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

When the caching for a cookie is temporarily disabled (e.g. due to a DIO
write on that file), future copying to the cache for that file is disabled
until all fds open on that file are closed.  However, if netfslib is using
the deprecated PG_private_2 method (such as is currently used by ceph), and
decides it wants to copy to the cache, netfs_advance_write() will just bail
at the first check seeing that the cache stream is unavailable, and
indicate that it dealt with all the content.

This means that we have no subrequests to provide notifications to drive
the state machine or even to pin the request and the request just gets
discarded, leaving the folios with PG_private_2 set.

Fix this by jumping directly to cancel the request if the cache is not
available.  That way, we don't remove mark3 from the folio_queue list and
netfs_pgpriv2_cancel() will clean up the folios.

This was found by running the generic/013 xfstest against ceph with an
active cache and the "-o fsc" option passed to ceph.  That would usually
hang

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Reported-by: Max Kellermann <max.kellermann@ionos.com>
Closes: https://lore.kernel.org/r/CAKPOu+_4m80thNy5_fvROoxBm689YtA0dZ-=gcmkzwYSY4syqw@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Xiubo Li <xiubli@redhat.com>
cc: netfs@lists.linux.dev
cc: ceph-devel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_pgpriv2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index ba5af89d37fa..54d5004fec18 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -170,6 +170,10 @@ void netfs_pgpriv2_write_to_the_cache(struct netfs_io_request *rreq)
 
 	trace_netfs_write(wreq, netfs_write_trace_copy_to_cache);
 	netfs_stat(&netfs_n_wh_copy_to_cache);
+	if (!wreq->io_streams[1].avail) {
+		netfs_put_request(wreq, false, netfs_rreq_trace_put_return);
+		goto couldnt_start;
+	}
 
 	for (;;) {
 		error = netfs_pgpriv2_copy_folio(wreq, folio);


