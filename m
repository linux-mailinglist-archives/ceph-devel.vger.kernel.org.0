Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A15E21DD7E
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jul 2020 18:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgGMQjA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jul 2020 12:39:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58658 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730652AbgGMQi5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Jul 2020 12:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594658335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hBqsUy2masEpa+uY5TjuNpXWjnW0S3sDVF3PP2vI20s=;
        b=CVsaTzku9pJCXbtNIMRDUWi3cOSNus80LNxuK7ohtfxaBWsqft9iCuwqJqd2u+EYcpCnWx
        QAzarzGiQ3Hk7z4yrOfZRnvxNsoURmoAi3U259xjR/4t1i+BFfpVPZ5vq9AMywHJxCHFyu
        OpSgMKQigwu02onm8Ga3AJrfMQfwIoo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-K7doxlJWMZ237TzMS3ZXzA-1; Mon, 13 Jul 2020 12:38:51 -0400
X-MC-Unique: K7doxlJWMZ237TzMS3ZXzA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E7B71080;
        Mon, 13 Jul 2020 16:38:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-113.rdu2.redhat.com [10.10.112.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E089D6FDD1;
        Mon, 13 Jul 2020 16:38:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 09/13] afs: Wait on PG_fscache before modifying/releasing a
 page
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
Date:   Mon, 13 Jul 2020 17:38:44 +0100
Message-ID: <159465832417.1377938.3571599385208729791.stgit@warthog.procyon.org.uk>
In-Reply-To: <159465821598.1377938.2046362270225008168.stgit@warthog.procyon.org.uk>
References: <159465821598.1377938.2046362270225008168.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

PG_fscache is going to be used to indicate that a page is being written to
the cache, and that the page should not be modified or released until it's
finished.

Make afs_invalidatepage() and afs_releasepage() wait for it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/file.c  |    7 +++++++
 fs/afs/write.c |    9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 8baafe655433..2f9a7369b77b 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -580,6 +580,13 @@ static int afs_releasepage(struct page *page, gfp_t gfp_flags)
 
 	/* deny if page is being written to the cache and the caller hasn't
 	 * elected to wait */
+#ifdef CONFIG_AFS_FSCACHE
+	if (PageFsCache(page)) {
+		if (!(gfp_flags & __GFP_DIRECT_RECLAIM) || !(gfp_flags & __GFP_FS))
+			return false;
+	}
+#endif
+
 	if (PagePrivate(page)) {
 		priv = page_private(page);
 		trace_afs_page_dirty(vnode, tracepoint_string("rel"),
diff --git a/fs/afs/write.c b/fs/afs/write.c
index d9de0dc877ca..73e2f4c93512 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -125,6 +125,10 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
 		SetPageUptodate(page);
 	}
 
+#ifdef CONFIG_AFS_FSCACHE
+	wait_on_page_fscache(page);
+#endif
+
 	/* page won't leak in error case: it eventually gets cleaned off LRU */
 	*pagep = page;
 
@@ -849,6 +853,11 @@ vm_fault_t afs_page_mkwrite(struct vm_fault *vmf)
 	/* Wait for the page to be written to the cache before we allow it to
 	 * be modified.  We then assume the entire page will need writing back.
 	 */
+#ifdef CONFIG_AFS_FSCACHE
+	if (PageFsCache(vmf->page) &&
+	    wait_on_page_bit_killable(vmf->page, PG_fscache) < 0)
+		return VM_FAULT_RETRY;
+#endif
 
 	if (PageWriteback(vmf->page) &&
 	    wait_on_page_bit_killable(vmf->page, PG_writeback) < 0)


