Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4F54D4E5B
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Mar 2022 17:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbiCJQQV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Mar 2022 11:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241323AbiCJQQU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Mar 2022 11:16:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F282E190B6A
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 08:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646928918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOU92AtAA9qHsfo63bZdgdy40p1yYB+s0ukXBIMsfoE=;
        b=dxC6qNd+tgVnhC0b10c1AKDlueKzKdntD6eYybtA7QWbos1N6WExsA28izJ1an1iOuT0MV
        qBmVSb44kF6ZnICSUNam6H1OJpFEEfM7pNHB0HADOHJ5HsvQxV/I/ZbOJwbDVpPaFtR5Js
        oLe5WkA8tVUuQzh4aNzfBfCqdZcGrXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-GV3YzLnwN--QaPPEMualfg-1; Thu, 10 Mar 2022 11:15:13 -0500
X-MC-Unique: GV3YzLnwN--QaPPEMualfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 213BE1006AA6;
        Thu, 10 Mar 2022 16:15:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D01386599;
        Thu, 10 Mar 2022 16:15:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH v3 02/20] netfs: Generate enums from trace symbol mapping
 lists
From:   David Howells <dhowells@redhat.com>
To:     linux-cachefs@redhat.com
Cc:     Jeff Layton <jlayton@redhat.com>, dhowells@redhat.com,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 10 Mar 2022 16:15:06 +0000
Message-ID: <164692890614.2099075.12960653141802151575.stgit@warthog.procyon.org.uk>
In-Reply-To: <164692883658.2099075.5745824552116419504.stgit@warthog.procyon.org.uk>
References: <164692883658.2099075.5745824552116419504.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

netfs has a number of lists of symbols for use in tracing, listed in an
enum and then listed again in a symbol->string mapping for use with
__print_symbolic().  This is, however, redundant.

Instead, use the symbol->string mapping list to also generate the enum
where the enum is in the same file.

Changes
=======
ver #3)
 - #undef EM and E_ at the end of the trace file[1].

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
cc: linux-cachefs@redhat.com
Link: https://lore.kernel.org/r/c2f4b3dc107b106e04c48f54945a12715cccfdf3.camel@redhat.com/ [1]
Link: https://lore.kernel.org/r/164622980839.3564931.5673300162465266909.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/164678192454.1200972.4428834328108580460.stgit@warthog.procyon.org.uk/ # v2
Link: https://lore.kernel.org/r/CALF+zOkB38_MB5QwNUtqTU4WjMaLUJ5+Piwsn3pMxkO3d4J7Kg@mail.gmail.com/ # v2
---

 include/trace/events/netfs.h |   59 +++++++++++-------------------------------
 1 file changed, 16 insertions(+), 43 deletions(-)

diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index e6f4ebbb4c69..4d0bf02d490a 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -15,49 +15,6 @@
 /*
  * Define enums for tracing information.
  */
-#ifndef __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
-#define __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
-
-enum netfs_read_trace {
-	netfs_read_trace_expanded,
-	netfs_read_trace_readahead,
-	netfs_read_trace_readpage,
-	netfs_read_trace_write_begin,
-};
-
-enum netfs_rreq_trace {
-	netfs_rreq_trace_assess,
-	netfs_rreq_trace_done,
-	netfs_rreq_trace_free,
-	netfs_rreq_trace_resubmit,
-	netfs_rreq_trace_unlock,
-	netfs_rreq_trace_unmark,
-	netfs_rreq_trace_write,
-};
-
-enum netfs_sreq_trace {
-	netfs_sreq_trace_download_instead,
-	netfs_sreq_trace_free,
-	netfs_sreq_trace_prepare,
-	netfs_sreq_trace_resubmit_short,
-	netfs_sreq_trace_submit,
-	netfs_sreq_trace_terminated,
-	netfs_sreq_trace_write,
-	netfs_sreq_trace_write_skip,
-	netfs_sreq_trace_write_term,
-};
-
-enum netfs_failure {
-	netfs_fail_check_write_begin,
-	netfs_fail_copy_to_cache,
-	netfs_fail_read,
-	netfs_fail_short_readpage,
-	netfs_fail_short_write_begin,
-	netfs_fail_prepare_write,
-};
-
-#endif
-
 #define netfs_read_traces					\
 	EM(netfs_read_trace_expanded,		"EXPANDED ")	\
 	EM(netfs_read_trace_readahead,		"READAHEAD")	\
@@ -98,6 +55,20 @@ enum netfs_failure {
 	EM(netfs_fail_short_write_begin,	"short-write-begin")	\
 	E_(netfs_fail_prepare_write,		"prep-write")
 
+#ifndef __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
+#define __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
+
+#undef EM
+#undef E_
+#define EM(a, b) a,
+#define E_(a, b) a
+
+enum netfs_read_trace { netfs_read_traces } __mode(byte);
+enum netfs_rreq_trace { netfs_rreq_traces } __mode(byte);
+enum netfs_sreq_trace { netfs_sreq_traces } __mode(byte);
+enum netfs_failure { netfs_failures } __mode(byte);
+
+#endif
 
 /*
  * Export enum symbols via userspace.
@@ -258,6 +229,8 @@ TRACE_EVENT(netfs_failure,
 		      __entry->error)
 	    );
 
+#undef EM
+#undef E_
 #endif /* _TRACE_NETFS_H */
 
 /* This part must be outside protection */


