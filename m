Return-Path: <ceph-devel+bounces-614-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97AB3836392
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 13:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCE451C231A6
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 12:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B7D3F8FB;
	Mon, 22 Jan 2024 12:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LH6hopOf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448C13F8D0
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 12:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705927162; cv=none; b=W3L5fKvD/aT0TvvIxGW6kqBkfymNQ9KE6NxsTzaooLf1wzmJXTnWdpOi5mcq7lHNZ+0fXyx3GdU8HrhM9zubJeCZF22kCdpvWixWuaAAcHSOBuD5b9p0HTb77YkWbSXRyho5tPpHf99V+XEyUDta1mi5sDeRFu3lkEWXb4tDYFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705927162; c=relaxed/simple;
	bh=JB0Vh1YbYo63PFWH26WwfxyAN6WsDsnz7f+l6o3Bvjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mb4r91kAWiUb7cNz2l6ja9RrdsWh2jxrmY2rrG8RWGd5UOrQXcnady1mCTquhtXz1xgTAOmldJRxET69fO28jRA0MtpobkUOUTQjv5vFNrEzeCnrKR/3wzg38t9hVzZKCZpX9ZHmh0MFDVo8l7hrALroeVT1hJyDHyqg7EVnzTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LH6hopOf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705927159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+FTT++75kJXAyd2owaIPHDCXA7EuMAyWq5EQhzAnWG4=;
	b=LH6hopOfvOKUvISY5go17GlHuQQmHvWpCt6GgVzCPeetsjOzkHWMWDFGXnE5Yxq0rhqWyL
	PiPGN0eQzC5dbZKbqgYvVRacgV3iTE1f5CyJwcmg4Ncr0arIyKU8ZDMd3q4FH56/xAowH6
	LvUGQfFSHDnvesQNaeCsVEL+FeHl65s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-DdMXm9N_PYeHTA5eKTR1gw-1; Mon, 22 Jan 2024 07:39:14 -0500
X-MC-Unique: DdMXm9N_PYeHTA5eKTR1gw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47D1F88D286;
	Mon, 22 Jan 2024 12:39:13 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 573461C060B1;
	Mon, 22 Jan 2024 12:39:11 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
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
	linux-kernel@vger.kernel.org,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>
Subject: [PATCH 08/10] afs: Fix error handling with lookup via FS.InlineBulkStatus
Date: Mon, 22 Jan 2024 12:38:41 +0000
Message-ID: <20240122123845.3822570-9-dhowells@redhat.com>
In-Reply-To: <20240122123845.3822570-1-dhowells@redhat.com>
References: <20240122123845.3822570-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

When afs does a lookup, it tries to use FS.InlineBulkStatus to preemptively
look up a bunch of files in the parent directory and cache this locally, on
the basis that we might want to look at them too (for example if someone
does an ls on a directory, they may want want to then stat every file
listed).

FS.InlineBulkStatus can be considered a compound op with the normal abort
code applying to the compound as a whole.  Each status fetch within the
compound is then given its own individual abort code - but assuming no
error that prevents the bulk fetch from returning the compound result will
be 0, even if all the constituent status fetches failed.

At the conclusion of afs_do_lookup(), we should use the abort code from the
appropriate status to determine the error to return, if any - but instead
it is assumed that we were successful if the op as a whole succeeded and we
return an incompletely initialised inode, resulting in ENOENT, no matter
the actual reason.  In the particular instance reported, a vnode with no
permission granted to be accessed is being given a UAEACCES abort code
which should be reported as EACCES, but is instead being reported as
ENOENT.

Fix this by abandoning the inode (which will be cleaned up with the op) if
file[1] has an abort code indicated and turn that abort code into an error
instead.

Whilst we're at it, add a tracepoint so that the abort codes of the
individual subrequests of FS.InlineBulkStatus can be logged.  At the moment
only the container abort code can be 0.

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Reported-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 fs/afs/dir.c               | 12 +++++++++---
 include/trace/events/afs.h | 25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index eface67ccc06..b5b8de521f99 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -716,6 +716,8 @@ static void afs_do_lookup_success(struct afs_operation *op)
 			break;
 		}
 
+		if (vp->scb.status.abort_code)
+			trace_afs_bulkstat_error(op, &vp->fid, i, vp->scb.status.abort_code);
 		if (!vp->scb.have_status && !vp->scb.have_error)
 			continue;
 
@@ -905,12 +907,16 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry,
 		afs_begin_vnode_operation(op);
 		afs_wait_for_operation(op);
 	}
-	inode = ERR_PTR(afs_op_error(op));
 
 out_op:
 	if (!afs_op_error(op)) {
-		inode = &op->file[1].vnode->netfs.inode;
-		op->file[1].vnode = NULL;
+		if (op->file[1].scb.status.abort_code) {
+			afs_op_accumulate_error(op, -ECONNABORTED,
+						op->file[1].scb.status.abort_code);
+		} else {
+			inode = &op->file[1].vnode->netfs.inode;
+			op->file[1].vnode = NULL;
+		}
 	}
 
 	if (op->file[0].scb.have_status)
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 8d73171cb9f0..08f2c93d6b16 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -1071,6 +1071,31 @@ TRACE_EVENT(afs_file_error,
 		      __print_symbolic(__entry->where, afs_file_errors))
 	    );
 
+TRACE_EVENT(afs_bulkstat_error,
+	    TP_PROTO(struct afs_operation *op, struct afs_fid *fid, unsigned int index, s32 abort),
+
+	    TP_ARGS(op, fid, index, abort),
+
+	    TP_STRUCT__entry(
+		    __field_struct(struct afs_fid,	fid)
+		    __field(unsigned int,		op)
+		    __field(unsigned int,		index)
+		    __field(s32,			abort)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->op = op->debug_id;
+		    __entry->fid = *fid;
+		    __entry->index = index;
+		    __entry->abort = abort;
+			   ),
+
+	    TP_printk("OP=%08x[%02x] %llx:%llx:%x a=%d",
+		      __entry->op, __entry->index,
+		      __entry->fid.vid, __entry->fid.vnode, __entry->fid.unique,
+		      __entry->abort)
+	    );
+
 TRACE_EVENT(afs_cm_no_server,
 	    TP_PROTO(struct afs_call *call, struct sockaddr_rxrpc *srx),
 


