Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680F021DCA8
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jul 2020 18:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgGMQdn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jul 2020 12:33:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25697 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730449AbgGMQdm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jul 2020 12:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594658020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RsKlZPL79lsVIpqG5GEJIOHq0XzcTHkHZqx9vAFcpIs=;
        b=W2+5ISbyyT6lGjMealOkLVZrIAUgUMqAbFKJ91lOgOVCcyrCYMIY1CxSnHxQo+rL/TxBcb
        nYyYQpcVFsQhCKIcT1wSQKLBbcr9wVXJXZUAhmPJQzz+hsn78msINUyQ5s0j/ofd548oq/
        3weESqJrZ6iUKaJtTQk9d8l7Palq6Y0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-TF_sxZHTPhqKDZsdug7vmg-1; Mon, 13 Jul 2020 12:33:35 -0400
X-MC-Unique: TF_sxZHTPhqKDZsdug7vmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A12A8027F3;
        Mon, 13 Jul 2020 16:33:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-113.rdu2.redhat.com [10.10.112.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36A045D9DC;
        Mon, 13 Jul 2020 16:33:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 15/32] cachefiles: trace: Log coherency checks
From:   David Howells <dhowells@redhat.com>
To:     Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Dave Wysochanski <dwysocha@redhat.com>, dhowells@redhat.com,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 13 Jul 2020 17:33:29 +0100
Message-ID: <159465800942.1376674.11074050532334474977.stgit@warthog.procyon.org.uk>
In-Reply-To: <159465784033.1376674.18106463693989811037.stgit@warthog.procyon.org.uk>
References: <159465784033.1376674.18106463693989811037.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add a cachefiles tracepoint that logs the result of coherency management
when the coherency data on a file in the cache is checked or committed.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/xattr.c             |   45 ++++++++++++++++++++++--------
 include/trace/events/cachefiles.h |   56 +++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 5b2f6da91cc8..17c16c2bd07e 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -125,12 +125,21 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object,
 	ret = vfs_setxattr(dentry, cachefiles_xattr_cache,
 			   buf, sizeof(struct cachefiles_xattr) + len,
 			   xattr_flags);
-	kfree(buf);
-	if (ret < 0 && ret != -ENOMEM)
-		cachefiles_io_error_obj(
-			object,
-			"Failed to set xattr with error %d", ret);
+	if (ret < 0) {
+		trace_cachefiles_coherency(object, d_inode(dentry)->i_ino,
+					   0,
+					   cachefiles_coherency_set_fail);
+		if (ret != -ENOMEM)
+			cachefiles_io_error_obj(
+				object,
+				"Failed to set xattr with error %d", ret);
+	} else {
+		trace_cachefiles_coherency(object, d_inode(dentry)->i_ino,
+					   0,
+					   cachefiles_coherency_set_ok);
+	}
 
+	kfree(buf);
 	_leave(" = %d", ret);
 	return ret;
 }
@@ -144,7 +153,9 @@ int cachefiles_check_auxdata(struct cachefiles_object *object)
 	struct dentry *dentry = object->dentry;
 	unsigned int len = object->fscache.cookie->aux_len, tlen;
 	const void *p = fscache_get_aux(object->fscache.cookie);
-	ssize_t ret;
+	enum cachefiles_coherency_trace why;
+	ssize_t xlen;
+	int ret = -ESTALE;
 
 	ASSERT(dentry);
 	ASSERT(d_backing_inode(dentry));
@@ -154,14 +165,24 @@ int cachefiles_check_auxdata(struct cachefiles_object *object)
 	if (!buf)
 		return -ENOMEM;
 
-	ret = vfs_getxattr(dentry, cachefiles_xattr_cache, buf, tlen);
-	if (ret == tlen &&
-	    buf->type == object->fscache.cookie->type &&
-	    memcmp(buf->data, p, len) == 0)
+	xlen = vfs_getxattr(dentry, cachefiles_xattr_cache, buf, tlen);
+	if (xlen != tlen) {
+		if (xlen == -EIO)
+			cachefiles_io_error_obj(
+				object,
+				"Failed to read aux with error %zd", xlen);
+		why = cachefiles_coherency_check_xattr;
+	} else if (buf->type != object->fscache.cookie->type) {
+		why = cachefiles_coherency_check_type;
+	} else if (memcmp(buf->data, p, len) != 0) {
+		why = cachefiles_coherency_check_aux;
+	} else {
+		why = cachefiles_coherency_check_ok;
 		ret = 0;
-	else
-		ret = -ESTALE;
+	}
 
+	trace_cachefiles_coherency(object, d_inode(dentry)->i_ino,
+				   0, why);
 	kfree(buf);
 	return ret;
 }
diff --git a/include/trace/events/cachefiles.h b/include/trace/events/cachefiles.h
index 0aa3f3126f6e..bf588c3f4a07 100644
--- a/include/trace/events/cachefiles.h
+++ b/include/trace/events/cachefiles.h
@@ -24,6 +24,19 @@ enum cachefiles_obj_ref_trace {
 	cachefiles_obj_ref__nr_traces
 };
 
+enum cachefiles_coherency_trace {
+	cachefiles_coherency_check_aux,
+	cachefiles_coherency_check_content,
+	cachefiles_coherency_check_dirty,
+	cachefiles_coherency_check_len,
+	cachefiles_coherency_check_objsize,
+	cachefiles_coherency_check_ok,
+	cachefiles_coherency_check_type,
+	cachefiles_coherency_check_xattr,
+	cachefiles_coherency_set_fail,
+	cachefiles_coherency_set_ok,
+};
+
 #endif
 
 /*
@@ -56,6 +69,18 @@ enum cachefiles_obj_ref_trace {
 	EM(cachefiles_obj_put_wait_retry,	"PUT wait_retry")	\
 	E_(cachefiles_obj_put_wait_timeo,	"PUT wait_timeo")
 
+#define cachefiles_coherency_traces					\
+	EM(cachefiles_coherency_check_aux,	"BAD aux ")		\
+	EM(cachefiles_coherency_check_content,	"BAD cont")		\
+	EM(cachefiles_coherency_check_dirty,	"BAD dirt")		\
+	EM(cachefiles_coherency_check_len,	"BAD len ")		\
+	EM(cachefiles_coherency_check_objsize,	"BAD osiz")		\
+	EM(cachefiles_coherency_check_ok,	"OK      ")		\
+	EM(cachefiles_coherency_check_type,	"BAD type")		\
+	EM(cachefiles_coherency_check_xattr,	"BAD xatt")		\
+	EM(cachefiles_coherency_set_fail,	"SET fail")		\
+	E_(cachefiles_coherency_set_ok,		"SET ok  ")
+
 /*
  * Export enum symbols via userspace.
  */
@@ -66,6 +91,7 @@ enum cachefiles_obj_ref_trace {
 
 cachefiles_obj_kill_traces;
 cachefiles_obj_ref_traces;
+cachefiles_coherency_traces;
 
 /*
  * Now redefine the EM() and E_() macros to map the enums to the strings that
@@ -295,6 +321,36 @@ TRACE_EVENT(cachefiles_mark_buried,
 		      __print_symbolic(__entry->why, cachefiles_obj_kill_traces))
 	    );
 
+TRACE_EVENT(cachefiles_coherency,
+	    TP_PROTO(struct cachefiles_object *obj,
+		     ino_t ino,
+		     int content,
+		     enum cachefiles_coherency_trace why),
+
+	    TP_ARGS(obj, ino, content, why),
+
+	    /* Note that obj may be NULL */
+	    TP_STRUCT__entry(
+		    __field(unsigned int,			obj	)
+		    __field(enum cachefiles_coherency_trace,	why	)
+		    __field(int,				content	)
+		    __field(u64,				ino	)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->obj	= obj->fscache.debug_id;
+		    __entry->why	= why;
+		    __entry->content	= content;
+		    __entry->ino	= ino;
+			   ),
+
+	    TP_printk("o=%08x %s i=%llx c=%u",
+		      __entry->obj,
+		      __print_symbolic(__entry->why, cachefiles_coherency_traces),
+		      __entry->ino,
+		      __entry->content)
+	    );
+
 #endif /* _TRACE_CACHEFILES_H */
 
 /* This part must be outside protection */


