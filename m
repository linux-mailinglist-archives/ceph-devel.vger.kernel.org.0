Return-Path: <ceph-devel+bounces-3869-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B626C051FA
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 10:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1F0B1AE6096
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 08:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8566305E32;
	Fri, 24 Oct 2025 08:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ag3U+L2L"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DC73081A1
	for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 08:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761295417; cv=none; b=Bz/jyjbUtdHLR8WFttqWM0CkDZddVkcnBy1UWdSxS1ATCRMbyJpsxkGc/FZMeyRPIi1vJmDtE+H84xgMuq3wgcfchafYTjb8nq54Jn5nNcyvhB3iddrSmot63VojPKTxvz+4Sm/eh5fDihQdH0kP705GUhe6rpfxTY1QIsBdbW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761295417; c=relaxed/simple;
	bh=PvKlyAnryIqd3VAbwvtxJZvPGwNfOJJCeK9s6RPy9Ao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MPLcmiMXHpnmc9nTyqAEtrFzKzLIfRiaYbIdK4GKoPinyXv3qK0NXMTVkt/3nhBtZjqt4ho0scbVHjhZDRLBndwlnBVEPiXplkzzmIoj9TjDeMCyaLp3jjlEvLZC9CYdqIPeu5gQ7f3fT107T2JMRiZQuZEYHJQkCjgY0rsekhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ag3U+L2L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761295407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8DF2jegumg9tCM/orEAUNgFoG8v/+/yyfi05uU50moI=;
	b=Ag3U+L2LILGa61vxUgcbHdKLyR82uc1Q3uqbZL3MTsDIDFHoQN8lTEWVCJMk7puoyu4BB0
	NUeR4OjOe04vAJEie4Raf7UofdPeDAi1A5EPlyLWelksZjtPWeRLkixjoShAbUjbtmiAVN
	qK6q0KCYTbIg2BPLRF4krDNGQkBptEQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-7wp6vmB4PlS16SVGkeJrXw-1; Fri, 24 Oct 2025 04:43:24 -0400
X-MC-Unique: 7wp6vmB4PlS16SVGkeJrXw-1
X-Mimecast-MFC-AGG-ID: 7wp6vmB4PlS16SVGkeJrXw_1761295403
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-634700fe857so3616088a12.0
        for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 01:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761295402; x=1761900202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8DF2jegumg9tCM/orEAUNgFoG8v/+/yyfi05uU50moI=;
        b=RiByJa6nXS6sIxwr9pkEDqm2maOlI2WdBjALoP7kloRC7nuEPsNJ3k08hzXemVbyN/
         Ntw/UHH2KKnJ6Z8yH5mUxUjYMpmzMjlFMkt65oNaR4lcgKUrvaYMGvT3EW/AsZyZetwP
         VJDGyKZmWqIh49PMB40p6M5XmaxB+dMKWcjtc/eVhUcTyLrKsjuq0tNGoKxP8e67Qh5M
         oygjZs8S/tufbaXeUEOPQc92k4EZkoWRBDdtj0UIdH9iGn70vk6jtNoO/4qUeqg19PrB
         +bsYP1HrHq8A1hhczfAjTORiBnZ4d0Jfm8tLrNQhbCXV6PGLc0XetVJY7wLOOqeHm6gt
         BsKw==
X-Gm-Message-State: AOJu0YxgQLyTh6r8Cza/bWcGaFEoHjDXXRjmu6UpuHQAAhLuPwqEGIr/
	MQ8c2orpU2wZbsxGx5uPxTAgRkR7wXOjeiKAZmsFL60Hl0bjjNRGVTZAlhCngG8OPh8JW9yx87U
	TF3EbNHibi3SXjGv2j++qTniOSJ4G3kvWevnr9bmP/1P/3YIgxjghJ8Sf+iOf+pfm2BB6c55TG9
	BsHUwdx6n6CHEMTPtO9xL6gU59Wa72QfPQm1Gw5IIRXVlKBnl6IeZ+jIw=
X-Gm-Gg: ASbGncsiLq3o5BtTfOLdFyK/xFMwAgMdOMJL/5rcWMToh9pHrN4IJPoVcukaZ1KGXcJ
	GVcxqyTpy8vLKoegzVf8E16+2f/MfGNo3rEhswKMbtwwpbhrTojX4Z+GeaqCo2m88iRs3SD6NzM
	LNoExmBR4u+bp524YVbmP6nxs0KTtByUgcs1rkLQh+hC7tiJhte0C2BY8wUQWfVsVhfI/KWd22O
	s4slkfy7u2soHK6YEg5sd9EhA5cQih+OdUZgpWRgLvlwViDzu/NZHrQi7KT6YtDviLP16uQjirw
	azjAL9KYA0XPmoEOrOIMK4vozOAI+3o9C17fVF9g/oFPczKzqKV6wiCTOETYKpBqoslSKgpSnPi
	cDBQceqhdvNtIwuO2UdgvziIRZDVhwNRU
X-Received: by 2002:a17:907:6e89:b0:b6d:545e:44f6 with SMTP id a640c23a62f3a-b6d6bb0a38amr224590766b.12.1761295400561;
        Fri, 24 Oct 2025 01:43:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOBBFi+C63xC+IC3CnPqLeNvQtwpnoMKtjk0uFrBVw9TOu1PBE83EpthqzgFDi4oQsGuwtWw==
X-Received: by 2002:a17:907:6e89:b0:b6d:545e:44f6 with SMTP id a640c23a62f3a-b6d6bb0a38amr224578466b.12.1761295398433;
        Fri, 24 Oct 2025 01:43:18 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d010asm469226866b.11.2025.10.24.01.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 01:43:17 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com,
	amarkuze@redhat.com,
	akpm@linux-foundation.org,
	bsegall@google.com,
	david@redhat.com,
	dietmar.eggemann@arm.com,
	idryomov@gmail.com,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	kees@kernel.org,
	lorenzo.stoakes@oracle.com,
	mgorman@suse.de,
	mhocko@suse.com,
	rppt@kernel.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	surenb@google.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	vbabka@suse.cz,
	xiubli@redhat.com,
	Slava.Dubeyko@ibm.com
Subject: [RFC PATCH 5/5] ceph: Activate BLOG logging
Date: Fri, 24 Oct 2025 08:42:59 +0000
Message-Id: <20251024084259.2359693-6-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert all debug logging calls from dout/doutc to bout/boutc throughout
the Ceph filesystem code, enabling binary logging for improved performance
and reduced overhead on hot paths.

**Scope of changes:**
This commit is a mechanical transformation that replaces every instance of
the traditional text-based logging macros (dout/doutc) with their binary
logging equivalents (bout/boutc) across the entire Ceph client codebase.

**Modified subsystems:**
- **Address space operations** (addr.c): Page cache, writeback, readahead
- **Capability management** (caps.c): MDS capability tracking and revocation
- **Crypto operations** (crypto.c): Encryption context handling
- **Directory operations** (dir.c): Lookups, readdir, dcache management
- **Export operations** (export.c): NFS export support
- **File operations** (file.c): Open, read, write, mmap, fsync
- **Inode operations** (inode.c): Inode lifecycle, attribute updates
- **Ioctl operations** (ioctl.c): Special file operations
- **POSIX locks** (locks.c): File locking operations
- **MDS client** (mds_client.c): Metadata server communication and sessions
- **MDS map** (mdsmap.c): MDS cluster topology tracking
- **Quota management** (quota.c): Directory quota enforcement
- **Snapshot operations** (snap.c): Snapshot realm management
- **Superblock operations** (super.c): Mount, unmount, statfs
- **Extended attributes** (xattr.c): Getxattr, setxattr, listxattr

**ceph_debug.h modifications:**
Updated the debug header to define bout/boutc as the primary logging
interface when CONFIG_BLOG is enabled, with automatic fallback to dout/doutc
when BLOG is disabled. This ensures the code builds and runs correctly in
both configurations.

**Performance impact:**
Binary logging significantly reduces the overhead of debug logging by:
- Deferring string formatting to userspace deserialization time
- Using lock-free TLS contexts for log buffer allocation
- Eliminating sprintf overhead on hot paths
- Reducing cache pressure from format string processing

Debug logs can now be enabled in production with minimal performance impact,
providing valuable diagnostic data without the overhead of traditional text
logging. The binary format also enables more sophisticated analysis tools
and higher log throughput.

**Compatibility:**
The logging semantics remain identical - same log levels, same subsystem
filtering, same conditional logic. Existing log analysis workflows can be
adapted by deserializing BLOG buffers exported through debugfs (introduced
in the previous commit).

After this commit, the Ceph filesystem uses BLOG for all debug logging when
CONFIG_BLOG is enabled. Userspace tools can read binary logs from debugfs
and deserialize them back to human-readable format using the format strings
registered in the BLOG source ID registry.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/addr.c                  | 130 +++++++--------
 fs/ceph/caps.c                  | 242 +++++++++++++--------------
 fs/ceph/crypto.c                |  18 +--
 fs/ceph/dir.c                   |  88 +++++-----
 fs/ceph/export.c                |  20 +--
 fs/ceph/file.c                  | 130 +++++++--------
 fs/ceph/inode.c                 | 182 ++++++++++-----------
 fs/ceph/ioctl.c                 |   6 +-
 fs/ceph/locks.c                 |  22 +--
 fs/ceph/mds_client.c            | 278 ++++++++++++++++----------------
 fs/ceph/mdsmap.c                |   8 +-
 fs/ceph/quota.c                 |   2 +-
 fs/ceph/snap.c                  |  66 ++++----
 fs/ceph/super.c                 |  82 +++++-----
 fs/ceph/xattr.c                 |  42 ++---
 include/linux/ceph/ceph_debug.h |   6 +-
 16 files changed, 661 insertions(+), 661 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 322ed268f14a..c73cf32fa7d2 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -87,7 +87,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 	struct ceph_snap_context *snapc;
 
 	if (folio_test_dirty(folio)) {
-		doutc(cl, "%llx.%llx %p idx %lu -- already dirty\n",
+		boutc(cl, "%llx.%llx %p idx %lu -- already dirty\n",
 		      ceph_vinop(inode), folio, folio->index);
 		VM_BUG_ON_FOLIO(!folio_test_private(folio), folio);
 		return false;
@@ -114,7 +114,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (ci->i_wrbuffer_ref == 0)
 		ihold(inode);
 	++ci->i_wrbuffer_ref;
-	doutc(cl, "%llx.%llx %p idx %lu head %d/%d -> %d/%d "
+	boutc(cl, "%llx.%llx %p idx %lu head %d/%d -> %d/%d "
 	      "snapc %p seq %lld (%d snaps)\n",
 	      ceph_vinop(inode), folio, folio->index,
 	      ci->i_wrbuffer_ref-1, ci->i_wrbuffer_ref_head-1,
@@ -147,14 +147,14 @@ static void ceph_invalidate_folio(struct folio *folio, size_t offset,
 
 
 	if (offset != 0 || length != folio_size(folio)) {
-		doutc(cl, "%llx.%llx idx %lu partial dirty page %zu~%zu\n",
+		boutc(cl, "%llx.%llx idx %lu partial dirty page %zu~%zu\n",
 		      ceph_vinop(inode), folio->index, offset, length);
 		return;
 	}
 
 	WARN_ON(!folio_test_locked(folio));
 	if (folio_test_private(folio)) {
-		doutc(cl, "%llx.%llx idx %lu full dirty page\n",
+		boutc(cl, "%llx.%llx idx %lu full dirty page\n",
 		      ceph_vinop(inode), folio->index);
 
 		snapc = folio_detach_private(folio);
@@ -222,7 +222,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	ceph_update_read_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				 req->r_end_latency, osd_data->length, err);
 
-	doutc(cl, "result %d subreq->len=%zu i_size=%lld\n", req->r_result,
+	boutc(cl, "result %d subreq->len=%zu i_size=%lld\n", req->r_result,
 	      subreq->len, i_size_read(req->r_inode));
 
 	/* no object means success but no data */
@@ -395,7 +395,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 			goto out;
 	}
 
-	doutc(cl, "%llx.%llx pos=%llu orig_len=%zu len=%llu\n",
+	boutc(cl, "%llx.%llx pos=%llu orig_len=%zu len=%llu\n",
 	      ceph_vinop(inode), subreq->start, subreq->len, len);
 
 	/*
@@ -420,7 +420,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 
 		err = iov_iter_get_pages_alloc2(&subreq->io_iter, &pages, len, &page_off);
 		if (err < 0) {
-			doutc(cl, "%llx.%llx failed to allocate pages, %d\n",
+			boutc(cl, "%llx.%llx failed to allocate pages, %d\n",
 			      ceph_vinop(inode), err);
 			goto out;
 		}
@@ -452,7 +452,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		subreq->error = err;
 		netfs_read_subreq_terminated(subreq);
 	}
-	doutc(cl, "%llx.%llx result %d\n", ceph_vinop(inode), err);
+	boutc(cl, "%llx.%llx result %d\n", ceph_vinop(inode), err);
 }
 
 static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
@@ -494,12 +494,12 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
 	 */
 	ret = ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want, true, &got);
 	if (ret < 0) {
-		doutc(cl, "%llx.%llx, error getting cap\n", ceph_vinop(inode));
+		boutc(cl, "%llx.%llx, error getting cap\n", ceph_vinop(inode));
 		goto out;
 	}
 
 	if (!(got & want)) {
-		doutc(cl, "%llx.%llx, no cache cap\n", ceph_vinop(inode));
+		boutc(cl, "%llx.%llx, no cache cap\n", ceph_vinop(inode));
 		ret = -EACCES;
 		goto out;
 	}
@@ -629,7 +629,7 @@ get_oldest_context(struct inode *inode, struct ceph_writeback_ctl *ctl,
 
 	spin_lock(&ci->i_ceph_lock);
 	list_for_each_entry(capsnap, &ci->i_cap_snaps, ci_item) {
-		doutc(cl, " capsnap %p snapc %p has %d dirty pages\n",
+		boutc(cl, " capsnap %p snapc %p has %d dirty pages\n",
 		      capsnap, capsnap->context, capsnap->dirty_pages);
 		if (!capsnap->dirty_pages)
 			continue;
@@ -662,7 +662,7 @@ get_oldest_context(struct inode *inode, struct ceph_writeback_ctl *ctl,
 	}
 	if (!snapc && ci->i_wrbuffer_ref_head) {
 		snapc = ceph_get_snap_context(ci->i_head_snapc);
-		doutc(cl, " head snapc %p has %d dirty pages\n", snapc,
+		boutc(cl, " head snapc %p has %d dirty pages\n", snapc,
 		      ci->i_wrbuffer_ref_head);
 		if (ctl) {
 			ctl->i_size = i_size_read(inode);
@@ -733,7 +733,7 @@ static int write_folio_nounlock(struct folio *folio,
 	bool caching = ceph_is_cache_enabled(inode);
 	struct page *bounce_page = NULL;
 
-	doutc(cl, "%llx.%llx folio %p idx %lu\n", ceph_vinop(inode), folio,
+	boutc(cl, "%llx.%llx folio %p idx %lu\n", ceph_vinop(inode), folio,
 	      folio->index);
 
 	if (ceph_inode_is_shutdown(inode))
@@ -742,13 +742,13 @@ static int write_folio_nounlock(struct folio *folio,
 	/* verify this is a writeable snap context */
 	snapc = page_snap_context(&folio->page);
 	if (!snapc) {
-		doutc(cl, "%llx.%llx folio %p not dirty?\n", ceph_vinop(inode),
+		boutc(cl, "%llx.%llx folio %p not dirty?\n", ceph_vinop(inode),
 		      folio);
 		return 0;
 	}
 	oldest = get_oldest_context(inode, &ceph_wbc, snapc);
 	if (snapc->seq > oldest->seq) {
-		doutc(cl, "%llx.%llx folio %p snapc %p not writeable - noop\n",
+		boutc(cl, "%llx.%llx folio %p snapc %p not writeable - noop\n",
 		      ceph_vinop(inode), folio, snapc);
 		/* we should only noop if called by kswapd */
 		WARN_ON(!(current->flags & PF_MEMALLOC));
@@ -760,7 +760,7 @@ static int write_folio_nounlock(struct folio *folio,
 
 	/* is this a partial page at end of file? */
 	if (page_off >= ceph_wbc.i_size) {
-		doutc(cl, "%llx.%llx folio at %lu beyond eof %llu\n",
+		boutc(cl, "%llx.%llx folio at %lu beyond eof %llu\n",
 		      ceph_vinop(inode), folio->index, ceph_wbc.i_size);
 		folio_invalidate(folio, 0, folio_size(folio));
 		return 0;
@@ -770,7 +770,7 @@ static int write_folio_nounlock(struct folio *folio,
 		len = ceph_wbc.i_size - page_off;
 
 	wlen = IS_ENCRYPTED(inode) ? round_up(len, CEPH_FSCRYPT_BLOCK_SIZE) : len;
-	doutc(cl, "%llx.%llx folio %p index %lu on %llu~%llu snapc %p seq %lld\n",
+	boutc(cl, "%llx.%llx folio %p index %lu on %llu~%llu snapc %p seq %lld\n",
 	      ceph_vinop(inode), folio, folio->index, page_off, wlen, snapc,
 	      snapc->seq);
 
@@ -813,7 +813,7 @@ static int write_folio_nounlock(struct folio *folio,
 	osd_req_op_extent_osd_data_pages(req, 0,
 			bounce_page ? &bounce_page : &page, wlen, 0,
 			false, false);
-	doutc(cl, "%llx.%llx %llu~%llu (%llu bytes, %sencrypted)\n",
+	boutc(cl, "%llx.%llx %llu~%llu (%llu bytes, %sencrypted)\n",
 	      ceph_vinop(inode), page_off, len, wlen,
 	      IS_ENCRYPTED(inode) ? "" : "not ");
 
@@ -834,7 +834,7 @@ static int write_folio_nounlock(struct folio *folio,
 			wbc = &tmp_wbc;
 		if (err == -ERESTARTSYS) {
 			/* killed by SIGKILL */
-			doutc(cl, "%llx.%llx interrupted page %p\n",
+			boutc(cl, "%llx.%llx interrupted page %p\n",
 			      ceph_vinop(inode), folio);
 			folio_redirty_for_writepage(wbc, folio);
 			folio_end_writeback(folio);
@@ -842,12 +842,12 @@ static int write_folio_nounlock(struct folio *folio,
 		}
 		if (err == -EBLOCKLISTED)
 			fsc->blocklisted = true;
-		doutc(cl, "%llx.%llx setting mapping error %d %p\n",
+		boutc(cl, "%llx.%llx setting mapping error %d %p\n",
 		      ceph_vinop(inode), err, folio);
 		mapping_set_error(&inode->i_data, err);
 		wbc->pages_skipped++;
 	} else {
-		doutc(cl, "%llx.%llx cleaned page %p\n",
+		boutc(cl, "%llx.%llx cleaned page %p\n",
 		      ceph_vinop(inode), folio);
 		err = 0;  /* vfs expects us to return 0 */
 	}
@@ -887,7 +887,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 	unsigned int len = 0;
 	bool remove_page;
 
-	doutc(cl, "%llx.%llx rc %d\n", ceph_vinop(inode), rc);
+	boutc(cl, "%llx.%llx rc %d\n", ceph_vinop(inode), rc);
 	if (rc < 0) {
 		mapping_set_error(mapping, rc);
 		ceph_set_error_write(ci);
@@ -945,7 +945,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 				WARN_ON(atomic64_read(&mdsc->dirty_folios) < 0);
 			}
 
-			doutc(cl, "unlocking %p\n", page);
+			boutc(cl, "unlocking %p\n", page);
 
 			if (remove_page)
 				generic_error_remove_folio(inode->i_mapping,
@@ -953,7 +953,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 
 			unlock_page(page);
 		}
-		doutc(cl, "%llx.%llx wrote %llu bytes cleaned %d pages\n",
+		boutc(cl, "%llx.%llx wrote %llu bytes cleaned %d pages\n",
 		      ceph_vinop(inode), osd_data->length,
 		      rc >= 0 ? num_pages : 0);
 
@@ -1077,11 +1077,11 @@ int ceph_define_writeback_range(struct address_space *mapping,
 	if (!ceph_wbc->snapc) {
 		/* hmm, why does writepages get called when there
 		   is no dirty data? */
-		doutc(cl, " no snap context with dirty data?\n");
+		boutc(cl, " no snap context with dirty data?\n");
 		return -ENODATA;
 	}
 
-	doutc(cl, " oldest snapc is %p seq %lld (%d snaps)\n",
+	boutc(cl, " oldest snapc is %p seq %lld (%d snaps)\n",
 	      ceph_wbc->snapc, ceph_wbc->snapc->seq,
 	      ceph_wbc->snapc->num_snaps);
 
@@ -1094,13 +1094,13 @@ int ceph_define_writeback_range(struct address_space *mapping,
 			ceph_wbc->end = -1;
 			if (ceph_wbc->index > 0)
 				ceph_wbc->should_loop = true;
-			doutc(cl, " cyclic, start at %lu\n", ceph_wbc->index);
+			boutc(cl, " cyclic, start at %lu\n", ceph_wbc->index);
 		} else {
 			ceph_wbc->index = wbc->range_start >> PAGE_SHIFT;
 			ceph_wbc->end = wbc->range_end >> PAGE_SHIFT;
 			if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 				ceph_wbc->range_whole = true;
-			doutc(cl, " not cyclic, %lu to %lu\n",
+			boutc(cl, " not cyclic, %lu to %lu\n",
 				ceph_wbc->index, ceph_wbc->end);
 		}
 	} else if (!ceph_wbc->head_snapc) {
@@ -1110,7 +1110,7 @@ int ceph_define_writeback_range(struct address_space *mapping,
 		 * associated with 'snapc' get written */
 		if (ceph_wbc->index > 0)
 			ceph_wbc->should_loop = true;
-		doutc(cl, " non-head snapc, range whole\n");
+		boutc(cl, " non-head snapc, range whole\n");
 	}
 
 	ceph_put_snap_context(ceph_wbc->last_snapc);
@@ -1146,14 +1146,14 @@ int ceph_check_page_before_write(struct address_space *mapping,
 
 	/* only dirty folios, or our accounting breaks */
 	if (unlikely(!folio_test_dirty(folio) || folio->mapping != mapping)) {
-		doutc(cl, "!dirty or !mapping %p\n", folio);
+		boutc(cl, "!dirty or !mapping %p\n", folio);
 		return -ENODATA;
 	}
 
 	/* only if matching snap context */
 	pgsnapc = page_snap_context(&folio->page);
 	if (pgsnapc != ceph_wbc->snapc) {
-		doutc(cl, "folio snapc %p %lld != oldest %p %lld\n",
+		boutc(cl, "folio snapc %p %lld != oldest %p %lld\n",
 		      pgsnapc, pgsnapc->seq,
 		      ceph_wbc->snapc, ceph_wbc->snapc->seq);
 
@@ -1165,7 +1165,7 @@ int ceph_check_page_before_write(struct address_space *mapping,
 	}
 
 	if (folio_pos(folio) >= ceph_wbc->i_size) {
-		doutc(cl, "folio at %lu beyond eof %llu\n",
+		boutc(cl, "folio at %lu beyond eof %llu\n",
 		      folio->index, ceph_wbc->i_size);
 
 		if ((ceph_wbc->size_stable ||
@@ -1178,7 +1178,7 @@ int ceph_check_page_before_write(struct address_space *mapping,
 
 	if (ceph_wbc->strip_unit_end &&
 	    (folio->index > ceph_wbc->strip_unit_end)) {
-		doutc(cl, "end of strip unit %p\n", folio);
+		boutc(cl, "end of strip unit %p\n", folio);
 		return -E2BIG;
 	}
 
@@ -1304,7 +1304,7 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		if (!folio)
 			continue;
 
-		doutc(cl, "? %p idx %lu, folio_test_writeback %#x, "
+		boutc(cl, "? %p idx %lu, folio_test_writeback %#x, "
 			"folio_test_dirty %#x, folio_test_locked %#x\n",
 			folio, folio->index, folio_test_writeback(folio),
 			folio_test_dirty(folio),
@@ -1312,7 +1312,7 @@ int ceph_process_folio_batch(struct address_space *mapping,
 
 		if (folio_test_writeback(folio) ||
 		    folio_test_private_2(folio) /* [DEPRECATED] */) {
-			doutc(cl, "waiting on writeback %p\n", folio);
+			boutc(cl, "waiting on writeback %p\n", folio);
 			folio_wait_writeback(folio);
 			folio_wait_private_2(folio); /* [DEPRECATED] */
 			continue;
@@ -1338,7 +1338,7 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		}
 
 		if (!folio_clear_dirty_for_io(folio)) {
-			doutc(cl, "%p !folio_clear_dirty_for_io\n", folio);
+			boutc(cl, "%p !folio_clear_dirty_for_io\n", folio);
 			folio_unlock(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			continue;
@@ -1365,7 +1365,7 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		}
 
 		/* note position of first page in fbatch */
-		doutc(cl, "%llx.%llx will write folio %p idx %lu\n",
+		boutc(cl, "%llx.%llx will write folio %p idx %lu\n",
 		      ceph_vinop(inode), folio, folio->index);
 
 		fsc->write_congested = is_write_congestion_happened(fsc);
@@ -1507,7 +1507,7 @@ int ceph_submit_write(struct address_space *mapping,
 			osd_req_op_extent_dup_last(req, ceph_wbc->op_idx,
 						   cur_offset - offset);
 
-			doutc(cl, "got pages at %llu~%llu\n", offset, len);
+			boutc(cl, "got pages at %llu~%llu\n", offset, len);
 
 			osd_req_op_extent_osd_data_pages(req, ceph_wbc->op_idx,
 							 ceph_wbc->data_pages,
@@ -1548,7 +1548,7 @@ int ceph_submit_write(struct address_space *mapping,
 	if (IS_ENCRYPTED(inode))
 		len = round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
 
-	doutc(cl, "got pages at %llu~%llu\n", offset, len);
+	boutc(cl, "got pages at %llu~%llu\n", offset, len);
 
 	if (IS_ENCRYPTED(inode) &&
 	    ((offset | len) & ~CEPH_FSCRYPT_BLOCK_MASK)) {
@@ -1641,7 +1641,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 	if (wbc->sync_mode == WB_SYNC_NONE && fsc->write_congested)
 		return 0;
 
-	doutc(cl, "%llx.%llx (mode=%s)\n", ceph_vinop(inode),
+	boutc(cl, "%llx.%llx (mode=%s)\n", ceph_vinop(inode),
 	      wbc->sync_mode == WB_SYNC_NONE ? "NONE" :
 	      (wbc->sync_mode == WB_SYNC_ALL ? "ALL" : "HOLD"));
 
@@ -1681,7 +1681,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 							    ceph_wbc.end,
 							    ceph_wbc.tag,
 							    &ceph_wbc.fbatch);
-		doutc(cl, "pagevec_lookup_range_tag for tag %#x got %d\n",
+		boutc(cl, "pagevec_lookup_range_tag for tag %#x got %d\n",
 			ceph_wbc.tag, ceph_wbc.nr_folios);
 
 		if (!ceph_wbc.nr_folios && !ceph_wbc.locked_pages)
@@ -1700,7 +1700,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 		if (ceph_wbc.processed_in_fbatch) {
 			if (folio_batch_count(&ceph_wbc.fbatch) == 0 &&
 			    ceph_wbc.locked_pages < ceph_wbc.max_pages) {
-				doutc(cl, "reached end fbatch, trying for more\n");
+				boutc(cl, "reached end fbatch, trying for more\n");
 				goto get_more_pages;
 			}
 		}
@@ -1728,7 +1728,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 			ceph_wbc.done = true;
 
 release_folios:
-		doutc(cl, "folio_batch release on %d folios (%p)\n",
+		boutc(cl, "folio_batch release on %d folios (%p)\n",
 		      (int)ceph_wbc.fbatch.nr,
 		      ceph_wbc.fbatch.nr ? ceph_wbc.fbatch.folios[0] : NULL);
 		folio_batch_release(&ceph_wbc.fbatch);
@@ -1736,7 +1736,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 
 	if (ceph_wbc.should_loop && !ceph_wbc.done) {
 		/* more to do; loop back to beginning of file */
-		doutc(cl, "looping back to beginning of file\n");
+		boutc(cl, "looping back to beginning of file\n");
 		/* OK even when start_index == 0 */
 		ceph_wbc.end = ceph_wbc.start_index - 1;
 
@@ -1757,7 +1757,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 
 out:
 	ceph_put_snap_context(ceph_wbc.last_snapc);
-	doutc(cl, "%llx.%llx dend - startone, rc = %d\n", ceph_vinop(inode),
+	boutc(cl, "%llx.%llx dend - startone, rc = %d\n", ceph_vinop(inode),
 	      rc);
 
 	return rc;
@@ -1795,7 +1795,7 @@ ceph_find_incompatible(struct folio *folio)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
 	if (ceph_inode_is_shutdown(inode)) {
-		doutc(cl, " %llx.%llx folio %p is shutdown\n",
+		boutc(cl, " %llx.%llx folio %p is shutdown\n",
 		      ceph_vinop(inode), folio);
 		return ERR_PTR(-ESTALE);
 	}
@@ -1817,14 +1817,14 @@ ceph_find_incompatible(struct folio *folio)
 		if (snapc->seq > oldest->seq) {
 			/* not writeable -- return it for the caller to deal with */
 			ceph_put_snap_context(oldest);
-			doutc(cl, " %llx.%llx folio %p snapc %p not current or oldest\n",
+			boutc(cl, " %llx.%llx folio %p snapc %p not current or oldest\n",
 			      ceph_vinop(inode), folio, snapc);
 			return ceph_get_snap_context(snapc);
 		}
 		ceph_put_snap_context(oldest);
 
 		/* yay, writeable, do it now (without dropping folio lock) */
-		doutc(cl, " %llx.%llx folio %p snapc %p not current, but oldest\n",
+		boutc(cl, " %llx.%llx folio %p snapc %p not current, but oldest\n",
 		      ceph_vinop(inode), folio, snapc);
 		if (folio_clear_dirty_for_io(folio)) {
 			int r = write_folio_nounlock(folio, NULL);
@@ -1898,7 +1898,7 @@ static int ceph_write_end(const struct kiocb *iocb,
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 	bool check_cap = false;
 
-	doutc(cl, "%llx.%llx file %p folio %p %d~%d (%d)\n", ceph_vinop(inode),
+	boutc(cl, "%llx.%llx file %p folio %p %d~%d (%d)\n", ceph_vinop(inode),
 	      file, folio, (int)pos, (int)copied, (int)len);
 
 	if (!folio_test_uptodate(folio)) {
@@ -1971,7 +1971,7 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 
 	ceph_block_sigs(&oldset);
 
-	doutc(cl, "%llx.%llx %llu trying to get caps\n",
+	boutc(cl, "%llx.%llx %llu trying to get caps\n",
 	      ceph_vinop(inode), off);
 	if (fi->fmode & CEPH_FILE_MODE_LAZY)
 		want = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
@@ -1983,7 +1983,7 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 	if (err < 0)
 		goto out_restore;
 
-	doutc(cl, "%llx.%llx %llu got cap refs on %s\n", ceph_vinop(inode),
+	boutc(cl, "%llx.%llx %llu got cap refs on %s\n", ceph_vinop(inode),
 	      off, ceph_cap_string(got));
 
 	if ((got & (CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO)) ||
@@ -1992,7 +1992,7 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 		ceph_add_rw_context(fi, &rw_ctx);
 		ret = filemap_fault(vmf);
 		ceph_del_rw_context(fi, &rw_ctx);
-		doutc(cl, "%llx.%llx %llu drop cap refs %s ret %x\n",
+		boutc(cl, "%llx.%llx %llu drop cap refs %s ret %x\n",
 		      ceph_vinop(inode), off, ceph_cap_string(got), ret);
 	} else
 		err = -EAGAIN;
@@ -2034,7 +2034,7 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 		ret = VM_FAULT_MAJOR | VM_FAULT_LOCKED;
 out_inline:
 		filemap_invalidate_unlock_shared(mapping);
-		doutc(cl, "%llx.%llx %llu read inline data ret %x\n",
+		boutc(cl, "%llx.%llx %llu read inline data ret %x\n",
 		      ceph_vinop(inode), off, ret);
 	}
 out_restore:
@@ -2076,7 +2076,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	else
 		len = offset_in_folio(folio, size);
 
-	doutc(cl, "%llx.%llx %llu~%zd getting caps i_size %llu\n",
+	boutc(cl, "%llx.%llx %llu~%zd getting caps i_size %llu\n",
 	      ceph_vinop(inode), off, len, size);
 	if (fi->fmode & CEPH_FILE_MODE_LAZY)
 		want = CEPH_CAP_FILE_BUFFER | CEPH_CAP_FILE_LAZYIO;
@@ -2088,7 +2088,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	if (err < 0)
 		goto out_free;
 
-	doutc(cl, "%llx.%llx %llu~%zd got cap refs on %s\n", ceph_vinop(inode),
+	boutc(cl, "%llx.%llx %llu~%zd got cap refs on %s\n", ceph_vinop(inode),
 	      off, len, ceph_cap_string(got));
 
 	/* Update time before taking folio lock */
@@ -2137,7 +2137,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 			__mark_inode_dirty(inode, dirty);
 	}
 
-	doutc(cl, "%llx.%llx %llu~%zd dropping cap refs on %s ret %x\n",
+	boutc(cl, "%llx.%llx %llu~%zd dropping cap refs on %s ret %x\n",
 	      ceph_vinop(inode), off, len, ceph_cap_string(got), ret);
 	ceph_put_cap_refs_async(ci, got);
 out_free:
@@ -2173,7 +2173,7 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 		}
 	}
 
-	doutc(cl, "%p %llx.%llx len %zu locked_page %p\n", inode,
+	boutc(cl, "%p %llx.%llx len %zu locked_page %p\n", inode,
 	      ceph_vinop(inode), len, locked_page);
 
 	if (len > 0) {
@@ -2212,7 +2212,7 @@ int ceph_uninline_data(struct file *file)
 	inline_version = ci->i_inline_version;
 	spin_unlock(&ci->i_ceph_lock);
 
-	doutc(cl, "%llx.%llx inline_version %llu\n", ceph_vinop(inode),
+	boutc(cl, "%llx.%llx inline_version %llu\n", ceph_vinop(inode),
 	      inline_version);
 
 	if (ceph_inode_is_shutdown(inode)) {
@@ -2325,7 +2325,7 @@ int ceph_uninline_data(struct file *file)
 	}
 out:
 	ceph_free_cap_flush(prealloc_cf);
-	doutc(cl, "%llx.%llx inline_version %llu = %d\n",
+	boutc(cl, "%llx.%llx inline_version %llu = %d\n",
 	      ceph_vinop(inode), inline_version, err);
 	return err;
 }
@@ -2390,10 +2390,10 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 		goto out;
 
 	if (pool_ns)
-		doutc(cl, "pool %lld ns %.*s no perm cached\n", pool,
+		boutc(cl, "pool %lld ns %.*s no perm cached\n", pool,
 		      (int)pool_ns->len, pool_ns->str);
 	else
-		doutc(cl, "pool %lld no perm cached\n", pool);
+		boutc(cl, "pool %lld no perm cached\n", pool);
 
 	down_write(&mdsc->pool_perm_rwsem);
 	p = &mdsc->pool_perm_tree.rb_node;
@@ -2518,10 +2518,10 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 	if (!err)
 		err = have;
 	if (pool_ns)
-		doutc(cl, "pool %lld ns %.*s result = %d\n", pool,
+		boutc(cl, "pool %lld ns %.*s result = %d\n", pool,
 		      (int)pool_ns->len, pool_ns->str, err);
 	else
-		doutc(cl, "pool %lld result = %d\n", pool, err);
+		boutc(cl, "pool %lld result = %d\n", pool, err);
 	return err;
 }
 
@@ -2557,11 +2557,11 @@ int ceph_pool_perm_check(struct inode *inode, int need)
 check:
 	if (flags & CEPH_I_POOL_PERM) {
 		if ((need & CEPH_CAP_FILE_RD) && !(flags & CEPH_I_POOL_RD)) {
-			doutc(cl, "pool %lld no read perm\n", pool);
+			boutc(cl, "pool %lld no read perm\n", pool);
 			return -EPERM;
 		}
 		if ((need & CEPH_CAP_FILE_WR) && !(flags & CEPH_I_POOL_WR)) {
-			doutc(cl, "pool %lld no write perm\n", pool);
+			boutc(cl, "pool %lld no write perm\n", pool);
 			return -EPERM;
 		}
 		return 0;
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b1a8ff612c41..f479a4231b37 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -187,7 +187,7 @@ static void __ceph_unreserve_caps(struct ceph_mds_client *mdsc, int nr_caps)
 			mdsc->caps_avail_count += nr_caps;
 		}
 
-		doutc(mdsc->fsc->client,
+		boutc(mdsc->fsc->client,
 		      "caps %d = %d used + %d resv + %d avail\n",
 		      mdsc->caps_total_count, mdsc->caps_use_count,
 		      mdsc->caps_reserve_count, mdsc->caps_avail_count);
@@ -214,7 +214,7 @@ int ceph_reserve_caps(struct ceph_mds_client *mdsc,
 	struct ceph_mds_session *s;
 	LIST_HEAD(newcaps);
 
-	doutc(cl, "ctx=%p need=%d\n", ctx, need);
+	boutc(cl, "ctx=%p need=%d\n", ctx, need);
 
 	/* first reserve any caps that are already allocated */
 	spin_lock(&mdsc->caps_list_lock);
@@ -300,7 +300,7 @@ int ceph_reserve_caps(struct ceph_mds_client *mdsc,
 
 	spin_unlock(&mdsc->caps_list_lock);
 
-	doutc(cl, "ctx=%p %d = %d used + %d resv + %d avail\n", ctx,
+	boutc(cl, "ctx=%p %d = %d used + %d resv + %d avail\n", ctx,
 	      mdsc->caps_total_count, mdsc->caps_use_count,
 	      mdsc->caps_reserve_count, mdsc->caps_avail_count);
 	return err;
@@ -314,7 +314,7 @@ void ceph_unreserve_caps(struct ceph_mds_client *mdsc,
 	if (!ctx->count)
 		return;
 
-	doutc(cl, "ctx=%p count=%d\n", ctx, ctx->count);
+	boutc(cl, "ctx=%p count=%d\n", ctx, ctx->count);
 	spin_lock(&mdsc->caps_list_lock);
 	__ceph_unreserve_caps(mdsc, ctx->count);
 	ctx->count = 0;
@@ -363,7 +363,7 @@ struct ceph_cap *ceph_get_cap(struct ceph_mds_client *mdsc,
 	}
 
 	spin_lock(&mdsc->caps_list_lock);
-	doutc(cl, "ctx=%p (%d) %d = %d used + %d resv + %d avail\n", ctx,
+	boutc(cl, "ctx=%p (%d) %d = %d used + %d resv + %d avail\n", ctx,
 	      ctx->count, mdsc->caps_total_count, mdsc->caps_use_count,
 	      mdsc->caps_reserve_count, mdsc->caps_avail_count);
 	BUG_ON(!ctx->count);
@@ -389,7 +389,7 @@ void ceph_put_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap)
 	struct ceph_client *cl = mdsc->fsc->client;
 
 	spin_lock(&mdsc->caps_list_lock);
-	doutc(cl, "%p %d = %d used + %d resv + %d avail\n", cap,
+	boutc(cl, "%p %d = %d used + %d resv + %d avail\n", cap,
 	      mdsc->caps_total_count, mdsc->caps_use_count,
 	      mdsc->caps_reserve_count, mdsc->caps_avail_count);
 	mdsc->caps_use_count--;
@@ -502,7 +502,7 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
 
 	ci->i_hold_caps_max = round_jiffies(jiffies +
 					    opt->caps_wanted_delay_max * HZ);
-	doutc(mdsc->fsc->client, "%p %llx.%llx %lu\n", inode,
+	boutc(mdsc->fsc->client, "%p %llx.%llx %lu\n", inode,
 	      ceph_vinop(inode), ci->i_hold_caps_max - jiffies);
 }
 
@@ -519,7 +519,7 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
 {
 	struct inode *inode = &ci->netfs.inode;
 
-	doutc(mdsc->fsc->client, "%p %llx.%llx flags 0x%lx at %lu\n",
+	boutc(mdsc->fsc->client, "%p %llx.%llx flags 0x%lx at %lu\n",
 	      inode, ceph_vinop(inode), ci->i_ceph_flags,
 	      ci->i_hold_caps_max);
 	if (!mdsc->stopping) {
@@ -546,7 +546,7 @@ static void __cap_delay_requeue_front(struct ceph_mds_client *mdsc,
 {
 	struct inode *inode = &ci->netfs.inode;
 
-	doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode, ceph_vinop(inode));
+	boutc(mdsc->fsc->client, "%p %llx.%llx\n", inode, ceph_vinop(inode));
 	spin_lock(&mdsc->cap_delay_lock);
 	ci->i_ceph_flags |= CEPH_I_FLUSH;
 	if (!list_empty(&ci->i_cap_delay_list))
@@ -565,7 +565,7 @@ static void __cap_delay_cancel(struct ceph_mds_client *mdsc,
 {
 	struct inode *inode = &ci->netfs.inode;
 
-	doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode, ceph_vinop(inode));
+	boutc(mdsc->fsc->client, "%p %llx.%llx\n", inode, ceph_vinop(inode));
 	if (list_empty(&ci->i_cap_delay_list))
 		return;
 	spin_lock(&mdsc->cap_delay_lock);
@@ -604,7 +604,7 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 		if (issued & CEPH_CAP_FILE_SHARED)
 			atomic_inc(&ci->i_shared_gen);
 		if (S_ISDIR(ci->netfs.inode.i_mode)) {
-			doutc(cl, " marking %p NOT complete\n", inode);
+			boutc(cl, " marking %p NOT complete\n", inode);
 			__ceph_dir_clear_complete(ci);
 		}
 	}
@@ -663,7 +663,7 @@ void ceph_add_cap(struct inode *inode,
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	doutc(cl, "%p %llx.%llx mds%d cap %llx %s seq %d\n", inode,
+	boutc(cl, "%p %llx.%llx mds%d cap %llx %s seq %d\n", inode,
 	      ceph_vinop(inode), session->s_mds, cap_id,
 	      ceph_cap_string(issued), seq);
 
@@ -743,7 +743,7 @@ void ceph_add_cap(struct inode *inode,
 	actual_wanted = __ceph_caps_wanted(ci);
 	if ((wanted & ~actual_wanted) ||
 	    (issued & ~actual_wanted & CEPH_CAP_ANY_WR)) {
-		doutc(cl, "issued %s, mds wanted %s, actual %s, queueing\n",
+		boutc(cl, "issued %s, mds wanted %s, actual %s, queueing\n",
 		      ceph_cap_string(issued), ceph_cap_string(wanted),
 		      ceph_cap_string(actual_wanted));
 		__cap_delay_requeue(mdsc, ci);
@@ -762,7 +762,7 @@ void ceph_add_cap(struct inode *inode,
 		WARN_ON(ci->i_auth_cap == cap);
 	}
 
-	doutc(cl, "inode %p %llx.%llx cap %p %s now %s seq %d mds%d\n",
+	boutc(cl, "inode %p %llx.%llx cap %p %s now %s seq %d mds%d\n",
 	      inode, ceph_vinop(inode), cap, ceph_cap_string(issued),
 	      ceph_cap_string(issued|cap->issued), seq, mds);
 	cap->cap_id = cap_id;
@@ -795,7 +795,7 @@ static int __cap_is_valid(struct ceph_cap *cap)
 	ttl = cap->session->s_cap_ttl;
 
 	if (cap->cap_gen < gen || time_after_eq(jiffies, ttl)) {
-		doutc(cl, "%p %llx.%llx cap %p issued %s but STALE (gen %u vs %u)\n",
+		boutc(cl, "%p %llx.%llx cap %p issued %s but STALE (gen %u vs %u)\n",
 		      inode, ceph_vinop(inode), cap,
 		      ceph_cap_string(cap->issued), cap->cap_gen, gen);
 		return 0;
@@ -823,7 +823,7 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented)
 		cap = rb_entry(p, struct ceph_cap, ci_node);
 		if (!__cap_is_valid(cap))
 			continue;
-		doutc(cl, "%p %llx.%llx cap %p issued %s\n", inode,
+		boutc(cl, "%p %llx.%llx cap %p issued %s\n", inode,
 		      ceph_vinop(inode), cap, ceph_cap_string(cap->issued));
 		have |= cap->issued;
 		if (implemented)
@@ -873,11 +873,11 @@ static void __touch_cap(struct ceph_cap *cap)
 
 	spin_lock(&s->s_cap_lock);
 	if (!s->s_cap_iterator) {
-		doutc(cl, "%p %llx.%llx cap %p mds%d\n", inode,
+		boutc(cl, "%p %llx.%llx cap %p mds%d\n", inode,
 		      ceph_vinop(inode), cap, s->s_mds);
 		list_move_tail(&cap->session_caps, &s->s_caps);
 	} else {
-		doutc(cl, "%p %llx.%llx cap %p mds%d NOP, iterating over caps\n",
+		boutc(cl, "%p %llx.%llx cap %p mds%d NOP, iterating over caps\n",
 		      inode, ceph_vinop(inode), cap, s->s_mds);
 	}
 	spin_unlock(&s->s_cap_lock);
@@ -897,7 +897,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 	int have = ci->i_snap_caps;
 
 	if ((have & mask) == mask) {
-		doutc(cl, "mask %p %llx.%llx snap issued %s (mask %s)\n",
+		boutc(cl, "mask %p %llx.%llx snap issued %s (mask %s)\n",
 		      inode, ceph_vinop(inode), ceph_cap_string(have),
 		      ceph_cap_string(mask));
 		return 1;
@@ -908,7 +908,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 		if (!__cap_is_valid(cap))
 			continue;
 		if ((cap->issued & mask) == mask) {
-			doutc(cl, "mask %p %llx.%llx cap %p issued %s (mask %s)\n",
+			boutc(cl, "mask %p %llx.%llx cap %p issued %s (mask %s)\n",
 			      inode, ceph_vinop(inode), cap,
 			      ceph_cap_string(cap->issued),
 			      ceph_cap_string(mask));
@@ -920,7 +920,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 		/* does a combination of caps satisfy mask? */
 		have |= cap->issued;
 		if ((have & mask) == mask) {
-			doutc(cl, "mask %p %llx.%llx combo issued %s (mask %s)\n",
+			boutc(cl, "mask %p %llx.%llx combo issued %s (mask %s)\n",
 			      inode, ceph_vinop(inode),
 			      ceph_cap_string(cap->issued),
 			      ceph_cap_string(mask));
@@ -1129,13 +1129,13 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 
 	/* 'ci' being NULL means the remove have already occurred */
 	if (!ci) {
-		doutc(cl, "inode is NULL\n");
+		boutc(cl, "inode is NULL\n");
 		return;
 	}
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	doutc(cl, "%p from %p %llx.%llx\n", cap, inode, ceph_vinop(inode));
+	boutc(cl, "%p from %p %llx.%llx\n", cap, inode, ceph_vinop(inode));
 
 	mdsc = ceph_inode_to_fs_client(&ci->netfs.inode)->mdsc;
 
@@ -1148,7 +1148,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 	spin_lock(&session->s_cap_lock);
 	if (session->s_cap_iterator == cap) {
 		/* not yet, we are iterating over this very cap */
-		doutc(cl, "delaying %p removal from session %p\n", cap,
+		boutc(cl, "delaying %p removal from session %p\n", cap,
 		      cap->session);
 	} else {
 		list_del_init(&cap->session_caps);
@@ -1202,7 +1202,7 @@ void ceph_remove_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 
 	/* 'ci' being NULL means the remove have already occurred */
 	if (!ci) {
-		doutc(mdsc->fsc->client, "inode is NULL\n");
+		boutc(mdsc->fsc->client, "inode is NULL\n");
 		return;
 	}
 
@@ -1247,7 +1247,7 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
 	struct ceph_mds_client *mdsc = arg->session->s_mdsc;
 	struct ceph_osd_client *osdc = &mdsc->fsc->client->osdc;
 
-	doutc(mdsc->fsc->client,
+	boutc(mdsc->fsc->client,
 	      "%s %llx %llx caps %s wanted %s dirty %s seq %u/%u"
 	      " tid %llu/%llu mseq %u follows %lld size %llu/%llu"
 	      " xattr_ver %llu xattr_len %d\n",
@@ -1402,7 +1402,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 	revoking = cap->implemented & ~cap->issued;
 	retain &= ~revoking;
 
-	doutc(cl, "%p %llx.%llx cap %p session %p %s -> %s (revoking %s)\n",
+	boutc(cl, "%p %llx.%llx cap %p session %p %s -> %s (revoking %s)\n",
 	      inode, ceph_vinop(inode), cap, cap->session,
 	      ceph_cap_string(held), ceph_cap_string(held & retain),
 	      ceph_cap_string(revoking));
@@ -1625,7 +1625,7 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 	u64 oldest_flush_tid = 0;
 	u64 first_tid = 1, last_tid = 0;
 
-	doutc(cl, "%p %llx.%llx session %p\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p %llx.%llx session %p\n", inode, ceph_vinop(inode),
 	      session);
 
 	list_for_each_entry(capsnap, &ci->i_cap_snaps, ci_item) {
@@ -1641,7 +1641,7 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 
 		/* only flush each capsnap once */
 		if (capsnap->cap_flush.tid > 0) {
-			doutc(cl, "already flushed %p, skipping\n", capsnap);
+			boutc(cl, "already flushed %p, skipping\n", capsnap);
 			continue;
 		}
 
@@ -1673,7 +1673,7 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 		int ret;
 
 		if (!(cap && cap->session == session)) {
-			doutc(cl, "%p %llx.%llx auth cap %p not mds%d, stop\n",
+			boutc(cl, "%p %llx.%llx auth cap %p not mds%d, stop\n",
 			      inode, ceph_vinop(inode), cap, session->s_mds);
 			break;
 		}
@@ -1695,7 +1695,7 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 		refcount_inc(&capsnap->nref);
 		spin_unlock(&ci->i_ceph_lock);
 
-		doutc(cl, "%p %llx.%llx capsnap %p tid %llu %s\n", inode,
+		boutc(cl, "%p %llx.%llx capsnap %p tid %llu %s\n", inode,
 		      ceph_vinop(inode), capsnap, cf->tid,
 		      ceph_cap_string(capsnap->dirty));
 
@@ -1723,23 +1723,23 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
 	bool need_put = false;
 	int mds;
 
-	doutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
+	boutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
 	if (psession)
 		session = *psession;
 retry:
 	spin_lock(&ci->i_ceph_lock);
 	if (!(ci->i_ceph_flags & CEPH_I_FLUSH_SNAPS)) {
-		doutc(cl, " no capsnap needs flush, doing nothing\n");
+		boutc(cl, " no capsnap needs flush, doing nothing\n");
 		goto out;
 	}
 	if (!ci->i_auth_cap) {
-		doutc(cl, " no auth cap (migrating?), doing nothing\n");
+		boutc(cl, " no auth cap (migrating?), doing nothing\n");
 		goto out;
 	}
 
 	mds = ci->i_auth_cap->session->s_mds;
 	if (session && session->s_mds != mds) {
-		doutc(cl, " oops, wrong session %p mutex\n", session);
+		boutc(cl, " oops, wrong session %p mutex\n", session);
 		ceph_put_mds_session(session);
 		session = NULL;
 	}
@@ -1799,7 +1799,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 		return 0;
 	}
 
-	doutc(cl, "%p %llx.%llx %s dirty %s -> %s\n", inode,
+	boutc(cl, "%p %llx.%llx %s dirty %s -> %s\n", inode,
 	      ceph_vinop(inode), ceph_cap_string(mask),
 	      ceph_cap_string(was), ceph_cap_string(was | mask));
 	ci->i_dirty_caps |= mask;
@@ -1814,7 +1814,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 			ci->i_head_snapc = ceph_get_snap_context(
 				ci->i_snap_realm->cached_context);
 		}
-		doutc(cl, "%p %llx.%llx now dirty snapc %p auth cap %p\n",
+		boutc(cl, "%p %llx.%llx now dirty snapc %p auth cap %p\n",
 		      inode, ceph_vinop(inode), ci->i_head_snapc,
 		      ci->i_auth_cap);
 		BUG_ON(!list_empty(&ci->i_dirty_item));
@@ -1921,13 +1921,13 @@ static u64 __mark_caps_flushing(struct inode *inode,
 	BUG_ON(!ci->i_prealloc_cap_flush);
 
 	flushing = ci->i_dirty_caps;
-	doutc(cl, "flushing %s, flushing_caps %s -> %s\n",
+	boutc(cl, "flushing %s, flushing_caps %s -> %s\n",
 	      ceph_cap_string(flushing),
 	      ceph_cap_string(ci->i_flushing_caps),
 	      ceph_cap_string(ci->i_flushing_caps | flushing));
 	ci->i_flushing_caps |= flushing;
 	ci->i_dirty_caps = 0;
-	doutc(cl, "%p %llx.%llx now !dirty\n", inode, ceph_vinop(inode));
+	boutc(cl, "%p %llx.%llx now !dirty\n", inode, ceph_vinop(inode));
 
 	swap(cf, ci->i_prealloc_cap_flush);
 	cf->caps = flushing;
@@ -1970,13 +1970,13 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	if (inode->i_data.nrpages == 0 &&
 	    invalidating_gen == ci->i_rdcache_gen) {
 		/* success. */
-		doutc(cl, "%p %llx.%llx success\n", inode,
+		boutc(cl, "%p %llx.%llx success\n", inode,
 		      ceph_vinop(inode));
 		/* save any racing async invalidate some trouble */
 		ci->i_rdcache_revoking = ci->i_rdcache_gen - 1;
 		return 0;
 	}
-	doutc(cl, "%p %llx.%llx failed\n", inode, ceph_vinop(inode));
+	boutc(cl, "%p %llx.%llx failed\n", inode, ceph_vinop(inode));
 	return -1;
 }
 
@@ -2085,7 +2085,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 		}
 	}
 
-	doutc(cl, "%p %llx.%llx file_want %s used %s dirty %s "
+	boutc(cl, "%p %llx.%llx file_want %s used %s dirty %s "
 	      "flushing %s issued %s revoking %s retain %s %s%s%s%s\n",
 	     inode, ceph_vinop(inode), ceph_cap_string(file_wanted),
 	     ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
@@ -2109,10 +2109,10 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 	    (revoking & (CEPH_CAP_FILE_CACHE|
 			 CEPH_CAP_FILE_LAZYIO)) && /*  or revoking cache */
 	    !tried_invalidate) {
-		doutc(cl, "trying to invalidate on %p %llx.%llx\n",
+		boutc(cl, "trying to invalidate on %p %llx.%llx\n",
 		      inode, ceph_vinop(inode));
 		if (try_nonblocking_invalidate(inode) < 0) {
-			doutc(cl, "queuing invalidate\n");
+			boutc(cl, "queuing invalidate\n");
 			queue_invalidate = true;
 			ci->i_rdcache_revoking = ci->i_rdcache_gen;
 		}
@@ -2140,7 +2140,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 			cap_used &= ~ci->i_auth_cap->issued;
 
 		revoking = cap->implemented & ~cap->issued;
-		doutc(cl, " mds%d cap %p used %s issued %s implemented %s revoking %s\n",
+		boutc(cl, " mds%d cap %p used %s issued %s implemented %s revoking %s\n",
 		      cap->mds, cap, ceph_cap_string(cap_used),
 		      ceph_cap_string(cap->issued),
 		      ceph_cap_string(cap->implemented),
@@ -2149,7 +2149,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 		/* completed revocation? going down and there are no caps? */
 		if (revoking) {
 			if ((revoking & cap_used) == 0) {
-				doutc(cl, "completed revocation of %s\n",
+				boutc(cl, "completed revocation of %s\n",
 				      ceph_cap_string(cap->implemented & ~cap->issued));
 				goto ack;
 			}
@@ -2171,7 +2171,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 		}
 
 		if (flags & CHECK_CAPS_FLUSH_FORCE) {
-			doutc(cl, "force to flush caps\n");
+			boutc(cl, "force to flush caps\n");
 			goto ack;
 		}
 
@@ -2180,24 +2180,24 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 			/* request larger max_size from MDS? */
 			if (ci->i_wanted_max_size > ci->i_max_size &&
 			    ci->i_wanted_max_size > ci->i_requested_max_size) {
-				doutc(cl, "requesting new max_size\n");
+				boutc(cl, "requesting new max_size\n");
 				goto ack;
 			}
 
 			/* approaching file_max? */
 			if (__ceph_should_report_size(ci)) {
-				doutc(cl, "i_size approaching max_size\n");
+				boutc(cl, "i_size approaching max_size\n");
 				goto ack;
 			}
 		}
 		/* flush anything dirty? */
 		if (cap == ci->i_auth_cap) {
 			if ((flags & CHECK_CAPS_FLUSH) && ci->i_dirty_caps) {
-				doutc(cl, "flushing dirty caps\n");
+				boutc(cl, "flushing dirty caps\n");
 				goto ack;
 			}
 			if (ci->i_ceph_flags & CEPH_I_FLUSH_SNAPS) {
-				doutc(cl, "flushing snap caps\n");
+				boutc(cl, "flushing snap caps\n");
 				goto ack;
 			}
 		}
@@ -2449,7 +2449,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 		kfree(sessions);
 	}
 
-	doutc(cl, "%p %llx.%llx wait on tid %llu %llu\n", inode,
+	boutc(cl, "%p %llx.%llx wait on tid %llu %llu\n", inode,
 	      ceph_vinop(inode), req1 ? req1->r_tid : 0ULL,
 	      req2 ? req2->r_tid : 0ULL);
 	if (req1) {
@@ -2482,7 +2482,7 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	int ret, err;
 	int dirty;
 
-	doutc(cl, "%p %llx.%llx%s\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p %llx.%llx%s\n", inode, ceph_vinop(inode),
 	      datasync ? " datasync" : "");
 
 	ret = file_write_and_wait_range(file, start, end);
@@ -2494,7 +2494,7 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 
 	dirty = try_flush_caps(inode, &flush_tid);
-	doutc(cl, "dirty caps are %s\n", ceph_cap_string(dirty));
+	boutc(cl, "dirty caps are %s\n", ceph_cap_string(dirty));
 
 	err = flush_mdlog_and_wait_inode_unsafe_requests(inode);
 
@@ -2515,7 +2515,7 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	if (err < 0)
 		ret = err;
 out:
-	doutc(cl, "%p %llx.%llx%s result=%d\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p %llx.%llx%s result=%d\n", inode, ceph_vinop(inode),
 	      datasync ? " datasync" : "", ret);
 	return ret;
 }
@@ -2535,7 +2535,7 @@ int ceph_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int dirty;
 	int wait = (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync);
 
-	doutc(cl, "%p %llx.%llx wait=%d\n", inode, ceph_vinop(inode), wait);
+	boutc(cl, "%p %llx.%llx wait=%d\n", inode, ceph_vinop(inode), wait);
 	ceph_fscache_unpin_writeback(inode, wbc);
 	if (wait) {
 		err = ceph_wait_on_async_create(inode);
@@ -2601,7 +2601,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 		if (!cf->is_capsnap) {
 			struct cap_msg_args arg;
 
-			doutc(cl, "%p %llx.%llx cap %p tid %llu %s\n",
+			boutc(cl, "%p %llx.%llx cap %p tid %llu %s\n",
 			      inode, ceph_vinop(inode), cap, cf->tid,
 			      ceph_cap_string(cf->caps));
 			__prep_cap(&arg, cap, CEPH_CAP_OP_FLUSH,
@@ -2617,7 +2617,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 			struct ceph_cap_snap *capsnap =
 					container_of(cf, struct ceph_cap_snap,
 						    cap_flush);
-			doutc(cl, "%p %llx.%llx capsnap %p tid %llu %s\n",
+			boutc(cl, "%p %llx.%llx capsnap %p tid %llu %s\n",
 			      inode, ceph_vinop(inode), capsnap, cf->tid,
 			      ceph_cap_string(capsnap->dirty));
 
@@ -2648,7 +2648,7 @@ void ceph_early_kick_flushing_caps(struct ceph_mds_client *mdsc,
 	struct ceph_cap *cap;
 	u64 oldest_flush_tid;
 
-	doutc(cl, "mds%d\n", session->s_mds);
+	boutc(cl, "mds%d\n", session->s_mds);
 
 	spin_lock(&mdsc->cap_dirty_lock);
 	oldest_flush_tid = __get_oldest_flush_tid(mdsc);
@@ -2702,7 +2702,7 @@ void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
 
 	lockdep_assert_held(&session->s_mutex);
 
-	doutc(cl, "mds%d\n", session->s_mds);
+	boutc(cl, "mds%d\n", session->s_mds);
 
 	spin_lock(&mdsc->cap_dirty_lock);
 	oldest_flush_tid = __get_oldest_flush_tid(mdsc);
@@ -2737,7 +2737,7 @@ void ceph_kick_flushing_inode_caps(struct ceph_mds_session *session,
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	doutc(mdsc->fsc->client, "%p %llx.%llx flushing %s\n",
+	boutc(mdsc->fsc->client, "%p %llx.%llx flushing %s\n",
 	      inode, ceph_vinop(inode),
 	      ceph_cap_string(ci->i_flushing_caps));
 
@@ -2786,7 +2786,7 @@ void ceph_take_cap_refs(struct ceph_inode_info *ci, int got,
 		if (ci->i_wb_ref == 0)
 			ihold(inode);
 		ci->i_wb_ref++;
-		doutc(cl, "%p %llx.%llx wb %d -> %d (?)\n", inode,
+		boutc(cl, "%p %llx.%llx wb %d -> %d (?)\n", inode,
 		      ceph_vinop(inode), ci->i_wb_ref-1, ci->i_wb_ref);
 	}
 }
@@ -2820,7 +2820,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 	int have, implemented;
 	bool snap_rwsem_locked = false;
 
-	doutc(cl, "%p %llx.%llx need %s want %s\n", inode,
+	boutc(cl, "%p %llx.%llx need %s want %s\n", inode,
 	      ceph_vinop(inode), ceph_cap_string(need),
 	      ceph_cap_string(want));
 
@@ -2829,7 +2829,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 
 	if ((flags & CHECK_FILELOCK) &&
 	    (ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK)) {
-		doutc(cl, "%p %llx.%llx error filelock\n", inode,
+		boutc(cl, "%p %llx.%llx error filelock\n", inode,
 		      ceph_vinop(inode));
 		ret = -EIO;
 		goto out_unlock;
@@ -2850,7 +2850,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 
 	if (have & need & CEPH_CAP_FILE_WR) {
 		if (endoff >= 0 && endoff > (loff_t)ci->i_max_size) {
-			doutc(cl, "%p %llx.%llx endoff %llu > maxsize %llu\n",
+			boutc(cl, "%p %llx.%llx endoff %llu > maxsize %llu\n",
 			      inode, ceph_vinop(inode), endoff, ci->i_max_size);
 			if (endoff > ci->i_requested_max_size)
 				ret = ci->i_auth_cap ? -EFBIG : -EUCLEAN;
@@ -2861,7 +2861,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 		 * can get a final snapshot value for size+mtime.
 		 */
 		if (__ceph_have_pending_cap_snap(ci)) {
-			doutc(cl, "%p %llx.%llx cap_snap_pending\n", inode,
+			boutc(cl, "%p %llx.%llx cap_snap_pending\n", inode,
 			      ceph_vinop(inode));
 			goto out_unlock;
 		}
@@ -2880,7 +2880,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 		int not = want & ~(have & need);
 		int revoking = implemented & ~have;
 		int exclude = revoking & not;
-		doutc(cl, "%p %llx.%llx have %s but not %s (revoking %s)\n",
+		boutc(cl, "%p %llx.%llx have %s but not %s (revoking %s)\n",
 		      inode, ceph_vinop(inode), ceph_cap_string(have),
 		      ceph_cap_string(not), ceph_cap_string(revoking));
 		if (!exclude || !(exclude & CEPH_CAP_FILE_BUFFER)) {
@@ -2922,7 +2922,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 			spin_unlock(&s->s_cap_lock);
 		}
 		if (session_readonly) {
-			doutc(cl, "%p %llx.%llx need %s but mds%d readonly\n",
+			boutc(cl, "%p %llx.%llx need %s but mds%d readonly\n",
 			      inode, ceph_vinop(inode), ceph_cap_string(need),
 			      ci->i_auth_cap->mds);
 			ret = -EROFS;
@@ -2930,21 +2930,21 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 		}
 
 		if (ceph_inode_is_shutdown(inode)) {
-			doutc(cl, "%p %llx.%llx inode is shutdown\n",
+			boutc(cl, "%p %llx.%llx inode is shutdown\n",
 			      inode, ceph_vinop(inode));
 			ret = -ESTALE;
 			goto out_unlock;
 		}
 		mds_wanted = __ceph_caps_mds_wanted(ci, false);
 		if (need & ~mds_wanted) {
-			doutc(cl, "%p %llx.%llx need %s > mds_wanted %s\n",
+			boutc(cl, "%p %llx.%llx need %s > mds_wanted %s\n",
 			      inode, ceph_vinop(inode), ceph_cap_string(need),
 			      ceph_cap_string(mds_wanted));
 			ret = -EUCLEAN;
 			goto out_unlock;
 		}
 
-		doutc(cl, "%p %llx.%llx have %s need %s\n", inode,
+		boutc(cl, "%p %llx.%llx have %s need %s\n", inode,
 		      ceph_vinop(inode), ceph_cap_string(have),
 		      ceph_cap_string(need));
 	}
@@ -2961,7 +2961,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 	else if (ret == 1)
 		ceph_update_cap_hit(&mdsc->metric);
 
-	doutc(cl, "%p %llx.%llx ret %d got %s\n", inode,
+	boutc(cl, "%p %llx.%llx ret %d got %s\n", inode,
 	      ceph_vinop(inode), ret, ceph_cap_string(*got));
 	return ret;
 }
@@ -2980,7 +2980,7 @@ static void check_max_size(struct inode *inode, loff_t endoff)
 	/* do we need to explicitly request a larger max_size? */
 	spin_lock(&ci->i_ceph_lock);
 	if (endoff >= ci->i_max_size && endoff > ci->i_wanted_max_size) {
-		doutc(cl, "write %p %llx.%llx at large endoff %llu, req max_size\n",
+		boutc(cl, "write %p %llx.%llx at large endoff %llu, req max_size\n",
 		      inode, ceph_vinop(inode), endoff);
 		ci->i_wanted_max_size = endoff;
 	}
@@ -3202,7 +3202,7 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
 
 	if (!capsnap->need_flush &&
 	    !capsnap->writing && !capsnap->dirty_pages) {
-		doutc(cl, "%p follows %llu\n", capsnap, capsnap->follows);
+		boutc(cl, "%p follows %llu\n", capsnap, capsnap->follows);
 		BUG_ON(capsnap->cap_flush.tid > 0);
 		ceph_put_snap_context(capsnap->context);
 		if (!list_is_last(&capsnap->ci_item, &ci->i_cap_snaps))
@@ -3256,7 +3256,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 			put++;
 			check_flushsnaps = true;
 		}
-		doutc(cl, "%p %llx.%llx wb %d -> %d (?)\n", inode,
+		boutc(cl, "%p %llx.%llx wb %d -> %d (?)\n", inode,
 		      ceph_vinop(inode), ci->i_wb_ref+1, ci->i_wb_ref);
 	}
 	if (had & CEPH_CAP_FILE_WR) {
@@ -3297,7 +3297,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 	}
 	spin_unlock(&ci->i_ceph_lock);
 
-	doutc(cl, "%p %llx.%llx had %s%s%s\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p %llx.%llx had %s%s%s\n", inode, ceph_vinop(inode),
 	      ceph_cap_string(had), last ? " last" : "", put ? " put" : "");
 
 	switch (mode) {
@@ -3367,7 +3367,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 			ceph_put_snap_context(ci->i_head_snapc);
 			ci->i_head_snapc = NULL;
 		}
-		doutc(cl, "on %p %llx.%llx head %d/%d -> %d/%d %s\n",
+		boutc(cl, "on %p %llx.%llx head %d/%d -> %d/%d %s\n",
 		      inode, ceph_vinop(inode), ci->i_wrbuffer_ref+nr,
 		      ci->i_wrbuffer_ref_head+nr, ci->i_wrbuffer_ref,
 		      ci->i_wrbuffer_ref_head, last ? " LAST" : "");
@@ -3400,7 +3400,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				}
 			}
 		}
-		doutc(cl, "%p %llx.%llx cap_snap %p snap %lld %d/%d -> %d/%d %s%s\n",
+		boutc(cl, "%p %llx.%llx cap_snap %p snap %lld %d/%d -> %d/%d %s%s\n",
 		      inode, ceph_vinop(inode), capsnap, capsnap->context->seq,
 		      ci->i_wrbuffer_ref+nr, capsnap->dirty_pages + nr,
 		      ci->i_wrbuffer_ref, capsnap->dirty_pages,
@@ -3431,7 +3431,7 @@ static void invalidate_aliases(struct inode *inode)
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 	struct dentry *dn, *prev = NULL;
 
-	doutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
+	boutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
 	d_prune_aliases(inode);
 	/*
 	 * For non-directory inode, d_find_alias() only returns
@@ -3516,10 +3516,10 @@ static void handle_cap_grant(struct inode *inode,
 	if (IS_ENCRYPTED(inode) && size)
 		size = extra_info->fscrypt_file_size;
 
-	doutc(cl, "%p %llx.%llx cap %p mds%d seq %d %s\n", inode,
+	boutc(cl, "%p %llx.%llx cap %p mds%d seq %d %s\n", inode,
 	      ceph_vinop(inode), cap, session->s_mds, seq,
 	      ceph_cap_string(newcaps));
-	doutc(cl, " size %llu max_size %llu, i_size %llu\n", size,
+	boutc(cl, " size %llu max_size %llu, i_size %llu\n", size,
 	      max_size, i_size_read(inode));
 
 
@@ -3580,7 +3580,7 @@ static void handle_cap_grant(struct inode *inode,
 		inode->i_uid = make_kuid(&init_user_ns, le32_to_cpu(grant->uid));
 		inode->i_gid = make_kgid(&init_user_ns, le32_to_cpu(grant->gid));
 		ci->i_btime = extra_info->btime;
-		doutc(cl, "%p %llx.%llx mode 0%o uid.gid %d.%d\n", inode,
+		boutc(cl, "%p %llx.%llx mode 0%o uid.gid %d.%d\n", inode,
 		      ceph_vinop(inode), inode->i_mode,
 		      from_kuid(&init_user_ns, inode->i_uid),
 		      from_kgid(&init_user_ns, inode->i_gid));
@@ -3608,7 +3608,7 @@ static void handle_cap_grant(struct inode *inode,
 		u64 version = le64_to_cpu(grant->xattr_version);
 
 		if (version > ci->i_xattrs.version) {
-			doutc(cl, " got new xattrs v%llu on %p %llx.%llx len %d\n",
+			boutc(cl, " got new xattrs v%llu on %p %llx.%llx len %d\n",
 			      version, inode, ceph_vinop(inode), len);
 			if (ci->i_xattrs.blob)
 				ceph_buffer_put(ci->i_xattrs.blob);
@@ -3660,7 +3660,7 @@ static void handle_cap_grant(struct inode *inode,
 
 	if (ci->i_auth_cap == cap && (newcaps & CEPH_CAP_ANY_FILE_WR)) {
 		if (max_size != ci->i_max_size) {
-			doutc(cl, "max_size %lld -> %llu\n", ci->i_max_size,
+			boutc(cl, "max_size %lld -> %llu\n", ci->i_max_size,
 			      max_size);
 			ci->i_max_size = max_size;
 			if (max_size >= ci->i_wanted_max_size) {
@@ -3675,7 +3675,7 @@ static void handle_cap_grant(struct inode *inode,
 	wanted = __ceph_caps_wanted(ci);
 	used = __ceph_caps_used(ci);
 	dirty = __ceph_caps_dirty(ci);
-	doutc(cl, " my wanted = %s, used = %s, dirty %s\n",
+	boutc(cl, " my wanted = %s, used = %s, dirty %s\n",
 	      ceph_cap_string(wanted), ceph_cap_string(used),
 	      ceph_cap_string(dirty));
 
@@ -3698,7 +3698,7 @@ static void handle_cap_grant(struct inode *inode,
 	if (cap->issued & ~newcaps) {
 		int revoking = cap->issued & ~newcaps;
 
-		doutc(cl, "revocation: %s -> %s (revoking %s)\n",
+		boutc(cl, "revocation: %s -> %s (revoking %s)\n",
 		      ceph_cap_string(cap->issued), ceph_cap_string(newcaps),
 		      ceph_cap_string(revoking));
 		if (S_ISREG(inode->i_mode) &&
@@ -3720,11 +3720,11 @@ static void handle_cap_grant(struct inode *inode,
 		cap->issued = newcaps;
 		cap->implemented |= newcaps;
 	} else if (cap->issued == newcaps) {
-		doutc(cl, "caps unchanged: %s -> %s\n",
+		boutc(cl, "caps unchanged: %s -> %s\n",
 		      ceph_cap_string(cap->issued),
 		      ceph_cap_string(newcaps));
 	} else {
-		doutc(cl, "grant: %s -> %s\n", ceph_cap_string(cap->issued),
+		boutc(cl, "grant: %s -> %s\n", ceph_cap_string(cap->issued),
 		      ceph_cap_string(newcaps));
 		/* non-auth MDS is revoking the newly grant caps ? */
 		if (cap == ci->i_auth_cap &&
@@ -3852,7 +3852,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 		}
 	}
 
-	doutc(cl, "%p %llx.%llx mds%d seq %d on %s cleaned %s, flushing %s -> %s\n",
+	boutc(cl, "%p %llx.%llx mds%d seq %d on %s cleaned %s, flushing %s -> %s\n",
 	      inode, ceph_vinop(inode), session->s_mds, seq,
 	      ceph_cap_string(dirty), ceph_cap_string(cleaned),
 	      ceph_cap_string(ci->i_flushing_caps),
@@ -3876,16 +3876,16 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 					    &list_first_entry(&session->s_cap_flushing,
 							      struct ceph_inode_info,
 							      i_flushing_item)->netfs.inode;
-				doutc(cl, " mds%d still flushing cap on %p %llx.%llx\n",
+				boutc(cl, " mds%d still flushing cap on %p %llx.%llx\n",
 				      session->s_mds, inode, ceph_vinop(inode));
 			}
 		}
 		mdsc->num_cap_flushing--;
-		doutc(cl, " %p %llx.%llx now !flushing\n", inode,
+		boutc(cl, " %p %llx.%llx now !flushing\n", inode,
 		      ceph_vinop(inode));
 
 		if (ci->i_dirty_caps == 0) {
-			doutc(cl, " %p %llx.%llx now clean\n", inode,
+			boutc(cl, " %p %llx.%llx now clean\n", inode,
 			      ceph_vinop(inode));
 			BUG_ON(!list_empty(&ci->i_dirty_item));
 			drop = true;
@@ -3930,7 +3930,7 @@ void __ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	doutc(cl, "removing capsnap %p, %p %llx.%llx ci %p\n", capsnap,
+	boutc(cl, "removing capsnap %p, %p %llx.%llx ci %p\n", capsnap,
 	      inode, ceph_vinop(inode), ci);
 
 	list_del_init(&capsnap->ci_item);
@@ -3977,14 +3977,14 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
 	bool wake_ci = false;
 	bool wake_mdsc = false;
 
-	doutc(cl, "%p %llx.%llx ci %p mds%d follows %lld\n", inode,
+	boutc(cl, "%p %llx.%llx ci %p mds%d follows %lld\n", inode,
 	      ceph_vinop(inode), ci, session->s_mds, follows);
 
 	spin_lock(&ci->i_ceph_lock);
 	list_for_each_entry(iter, &ci->i_cap_snaps, ci_item) {
 		if (iter->follows == follows) {
 			if (iter->cap_flush.tid != flush_tid) {
-				doutc(cl, " cap_snap %p follows %lld "
+				boutc(cl, " cap_snap %p follows %lld "
 				      "tid %lld != %lld\n", iter,
 				      follows, flush_tid,
 				      iter->cap_flush.tid);
@@ -3993,7 +3993,7 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
 			capsnap = iter;
 			break;
 		} else {
-			doutc(cl, " skipping cap_snap %p follows %lld\n",
+			boutc(cl, " skipping cap_snap %p follows %lld\n",
 			      iter, iter->follows);
 		}
 	}
@@ -4046,7 +4046,7 @@ static bool handle_cap_trunc(struct inode *inode,
 	if (IS_ENCRYPTED(inode) && size)
 		size = extra_info->fscrypt_file_size;
 
-	doutc(cl, "%p %llx.%llx mds%d seq %d to %lld truncate seq %d\n",
+	boutc(cl, "%p %llx.%llx mds%d seq %d to %lld truncate seq %d\n",
 	      inode, ceph_vinop(inode), mds, seq, truncate_size, truncate_seq);
 	queue_trunc = ceph_fill_file_size(inode, issued,
 					  truncate_seq, truncate_size, size);
@@ -4085,7 +4085,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		target = -1;
 	}
 
-	doutc(cl, " cap %llx.%llx export to peer %d piseq %u pmseq %u\n",
+	boutc(cl, " cap %llx.%llx export to peer %d piseq %u pmseq %u\n",
 	      ceph_vinop(inode), target, t_issue_seq, t_mseq);
 retry:
 	down_read(&mdsc->snap_rwsem);
@@ -4120,7 +4120,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		/* already have caps from the target */
 		if (tcap->cap_id == t_cap_id &&
 		    ceph_seq_cmp(tcap->seq, t_issue_seq) < 0) {
-			doutc(cl, " updating import cap %p mds%d\n", tcap,
+			boutc(cl, " updating import cap %p mds%d\n", tcap,
 			      target);
 			tcap->cap_id = t_cap_id;
 			tcap->seq = t_issue_seq - 1;
@@ -4227,7 +4227,7 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 		peer = -1;
 	}
 
-	doutc(cl, " cap %llx.%llx import from peer %d piseq %u pmseq %u\n",
+	boutc(cl, " cap %llx.%llx import from peer %d piseq %u pmseq %u\n",
 	      ceph_vinop(inode), peer, piseq, pmseq);
 retry:
 	cap = __get_cap_for_mds(ci, mds);
@@ -4254,7 +4254,7 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 
 	ocap = peer >= 0 ? __get_cap_for_mds(ci, peer) : NULL;
 	if (ocap && ocap->cap_id == p_cap_id) {
-		doutc(cl, " remove export cap %p mds%d flags %d\n",
+		boutc(cl, " remove export cap %p mds%d flags %d\n",
 		      ocap, peer, ph->flags);
 		if ((ph->flags & CEPH_CAP_FLAG_AUTH) &&
 		    (ocap->seq != piseq ||
@@ -4448,14 +4448,14 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 
 	/* lookup ino */
 	inode = ceph_find_inode(mdsc->fsc->sb, vino);
-	doutc(cl, " caps mds%d op %s ino %llx.%llx inode %p seq %u iseq %u mseq %u\n",
+	boutc(cl, " caps mds%d op %s ino %llx.%llx inode %p seq %u iseq %u mseq %u\n",
 	      session->s_mds, ceph_cap_op_name(op), vino.ino, vino.snap, inode,
 	      seq, issue_seq, mseq);
 
 	mutex_lock(&session->s_mutex);
 
 	if (!inode) {
-		doutc(cl, " i don't have ino %llx\n", vino.ino);
+		boutc(cl, " i don't have ino %llx\n", vino.ino);
 
 		switch (op) {
 		case CEPH_CAP_OP_IMPORT:
@@ -4510,7 +4510,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	spin_lock(&ci->i_ceph_lock);
 	cap = __get_cap_for_mds(ceph_inode(inode), session->s_mds);
 	if (!cap) {
-		doutc(cl, " no cap on %p ino %llx.%llx from mds%d\n",
+		boutc(cl, " no cap on %p ino %llx.%llx from mds%d\n",
 		      inode, ceph_ino(inode), ceph_snap(inode),
 		      session->s_mds);
 		spin_unlock(&ci->i_ceph_lock);
@@ -4614,14 +4614,14 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 	unsigned long loop_start = jiffies;
 	unsigned long delay = 0;
 
-	doutc(cl, "begin\n");
+	boutc(cl, "begin\n");
 	spin_lock(&mdsc->cap_delay_lock);
 	while (!list_empty(&mdsc->cap_delay_list)) {
 		ci = list_first_entry(&mdsc->cap_delay_list,
 				      struct ceph_inode_info,
 				      i_cap_delay_list);
 		if (time_before(loop_start, ci->i_hold_caps_max - delay_max)) {
-			doutc(cl, "caps added recently.  Exiting loop");
+			boutc(cl, "caps added recently.  Exiting loop");
 			delay = ci->i_hold_caps_max;
 			break;
 		}
@@ -4633,7 +4633,7 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 		inode = igrab(&ci->netfs.inode);
 		if (inode) {
 			spin_unlock(&mdsc->cap_delay_lock);
-			doutc(cl, "on %p %llx.%llx\n", inode,
+			boutc(cl, "on %p %llx.%llx\n", inode,
 			      ceph_vinop(inode));
 			ceph_check_caps(ci, 0);
 			iput(inode);
@@ -4649,7 +4649,7 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 			break;
 	}
 	spin_unlock(&mdsc->cap_delay_lock);
-	doutc(cl, "done\n");
+	boutc(cl, "done\n");
 
 	return delay;
 }
@@ -4664,14 +4664,14 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
 	struct ceph_inode_info *ci;
 	struct inode *inode;
 
-	doutc(cl, "begin\n");
+	boutc(cl, "begin\n");
 	spin_lock(&mdsc->cap_dirty_lock);
 	while (!list_empty(&s->s_cap_dirty)) {
 		ci = list_first_entry(&s->s_cap_dirty, struct ceph_inode_info,
 				      i_dirty_item);
 		inode = &ci->netfs.inode;
 		ihold(inode);
-		doutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
+		boutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
 		spin_unlock(&mdsc->cap_dirty_lock);
 		ceph_wait_on_async_create(inode);
 		ceph_check_caps(ci, CHECK_CAPS_FLUSH);
@@ -4679,7 +4679,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
 		spin_lock(&mdsc->cap_dirty_lock);
 	}
 	spin_unlock(&mdsc->cap_dirty_lock);
-	doutc(cl, "done\n");
+	boutc(cl, "done\n");
 }
 
 void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
@@ -4695,12 +4695,12 @@ static void flush_cap_releases(struct ceph_mds_session *s)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 	struct ceph_client *cl = mdsc->fsc->client;
 
-	doutc(cl, "begin\n");
+	boutc(cl, "begin\n");
 	spin_lock(&s->s_cap_lock);
 	if (s->s_num_cap_releases)
 		ceph_flush_session_cap_releases(mdsc, s);
 	spin_unlock(&s->s_cap_lock);
-	doutc(cl, "done\n");
+	boutc(cl, "done\n");
 
 }
 
@@ -4808,7 +4808,7 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
 			struct ceph_mds_client *mdsc =
 				ceph_inode_to_fs_client(inode)->mdsc;
 
-			doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
+			boutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
 			      ceph_vinop(inode));
 			spin_lock(&mdsc->cap_delay_lock);
 			ci->i_ceph_flags |= CEPH_I_FLUSH;
@@ -4851,7 +4851,7 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
 	used = __ceph_caps_used(ci);
 	dirty = __ceph_caps_dirty(ci);
 
-	doutc(cl, "%p %llx.%llx mds%d used|dirty %s drop %s unless %s\n",
+	boutc(cl, "%p %llx.%llx mds%d used|dirty %s drop %s unless %s\n",
 	      inode, ceph_vinop(inode), mds, ceph_cap_string(used|dirty),
 	      ceph_cap_string(drop), ceph_cap_string(unless));
 
@@ -4875,7 +4875,7 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
 		if (force || (cap->issued & drop)) {
 			if (cap->issued & drop) {
 				int wanted = __ceph_caps_wanted(ci);
-				doutc(cl, "%p %llx.%llx cap %p %s -> %s, "
+				boutc(cl, "%p %llx.%llx cap %p %s -> %s, "
 				      "wanted %s -> %s\n", inode,
 				      ceph_vinop(inode), cap,
 				      ceph_cap_string(cap->issued),
@@ -4890,7 +4890,7 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
 				    !(wanted & CEPH_CAP_ANY_FILE_WR))
 					ci->i_requested_max_size = 0;
 			} else {
-				doutc(cl, "%p %llx.%llx cap %p %s (force)\n",
+				boutc(cl, "%p %llx.%llx cap %p %s (force)\n",
 				      inode, ceph_vinop(inode), cap,
 				      ceph_cap_string(cap->issued));
 			}
@@ -4907,7 +4907,7 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
 			*p += sizeof(*rel);
 			ret = 1;
 		} else {
-			doutc(cl, "%p %llx.%llx cap %p %s (noop)\n",
+			boutc(cl, "%p %llx.%llx cap %p %s (noop)\n",
 			      inode, ceph_vinop(inode), cap,
 			      ceph_cap_string(cap->issued));
 		}
@@ -4958,7 +4958,7 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	spin_lock(&dentry->d_lock);
 	if (ret && di->lease_session && di->lease_session->s_mds == mds) {
 		int len = dentry->d_name.len;
-		doutc(cl, "%p mds%d seq %d\n",  dentry, mds,
+		boutc(cl, "%p mds%d seq %d\n",  dentry, mds,
 		      (int)di->lease_seq);
 		rel->dname_seq = cpu_to_le32(di->lease_seq);
 		__ceph_mdsc_drop_dentry_lease(dentry);
@@ -4986,7 +4986,7 @@ static int remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	doutc(cl, "removing capsnaps, ci is %p, %p %llx.%llx\n",
+	boutc(cl, "removing capsnaps, ci is %p, %p %llx.%llx\n",
 	      ci, inode, ceph_vinop(inode));
 
 	while (!list_empty(&ci->i_cap_snaps)) {
@@ -5014,7 +5014,7 @@ int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invali
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	doutc(cl, "removing cap %p, ci is %p, %p %llx.%llx\n",
+	boutc(cl, "removing cap %p, ci is %p, %p %llx.%llx\n",
 	      cap, ci, inode, ceph_vinop(inode));
 
 	is_auth = (cap == ci->i_auth_cap);
diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 7026e794813c..16b2fd4be0ca 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -227,7 +227,7 @@ static struct inode *parse_longname(const struct inode *parent,
 	str++;
 	name_end = strrchr(str, '_');
 	if (!name_end) {
-		doutc(cl, "failed to parse long snapshot name: %s\n", str);
+		boutc(cl, "failed to parse long snapshot name: %s\n", str);
 		return ERR_PTR(-EIO);
 	}
 	*name_len = (name_end - str);
@@ -240,7 +240,7 @@ static struct inode *parse_longname(const struct inode *parent,
 	inode_number = name_end + 1;
 	ret = kstrtou64(inode_number, 10, &vino.ino);
 	if (ret) {
-		doutc(cl, "failed to parse inode number: %s\n", str);
+		boutc(cl, "failed to parse inode number: %s\n", str);
 		return ERR_PTR(ret);
 	}
 
@@ -250,7 +250,7 @@ static struct inode *parse_longname(const struct inode *parent,
 		/* This can happen if we're not mounting cephfs on the root */
 		dir = ceph_get_inode(parent->i_sb, vino, NULL);
 		if (IS_ERR(dir))
-			doutc(cl, "can't find inode %s (%s)\n", inode_number, name);
+			boutc(cl, "can't find inode %s (%s)\n", inode_number, name);
 	}
 	return dir;
 }
@@ -319,7 +319,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
 
 	/* base64 encode the encrypted name */
 	elen = ceph_base64_encode(cryptbuf, len, p);
-	doutc(cl, "base64-encoded ciphertext name = %.*s\n", elen, p);
+	boutc(cl, "base64-encoded ciphertext name = %.*s\n", elen, p);
 
 	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
 	WARN_ON(elen > 240);
@@ -483,7 +483,7 @@ int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
 {
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 
-	doutc(cl, "%p %llx.%llx len %u offs %u blk %llu\n", inode,
+	boutc(cl, "%p %llx.%llx len %u offs %u blk %llu\n", inode,
 	      ceph_vinop(inode), len, offs, lblk_num);
 	return fscrypt_decrypt_block_inplace(inode, page, len, offs, lblk_num);
 }
@@ -494,7 +494,7 @@ int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
 {
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 
-	doutc(cl, "%p %llx.%llx len %u offs %u blk %llu\n", inode,
+	boutc(cl, "%p %llx.%llx len %u offs %u blk %llu\n", inode,
 	      ceph_vinop(inode), len, offs, lblk_num);
 	return fscrypt_encrypt_block_inplace(inode, page, len, offs, lblk_num);
 }
@@ -571,7 +571,7 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 
 	/* Nothing to do for empty array */
 	if (ext_cnt == 0) {
-		doutc(cl, "%p %llx.%llx empty array, ret 0\n", inode,
+		boutc(cl, "%p %llx.%llx empty array, ret 0\n", inode,
 		      ceph_vinop(inode));
 		return 0;
 	}
@@ -595,7 +595,7 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 		}
 		fret = ceph_fscrypt_decrypt_pages(inode, &page[pgidx],
 						 off + pgsoff, ext->len);
-		doutc(cl, "%p %llx.%llx [%d] 0x%llx~0x%llx fret %d\n", inode,
+		boutc(cl, "%p %llx.%llx [%d] 0x%llx~0x%llx fret %d\n", inode,
 		      ceph_vinop(inode), i, ext->off, ext->len, fret);
 		if (fret < 0) {
 			if (ret == 0)
@@ -604,7 +604,7 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 		}
 		ret = pgsoff + fret;
 	}
-	doutc(cl, "ret %d\n", ret);
+	boutc(cl, "ret %d\n", ret);
 	return ret;
 }
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index d18c0eaef9b7..deaf121b2457 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -122,7 +122,7 @@ static int note_last_dentry(struct ceph_fs_client *fsc,
 	memcpy(dfi->last_name, name, len);
 	dfi->last_name[len] = 0;
 	dfi->next_offset = next_offset;
-	doutc(fsc->client, "'%s'\n", dfi->last_name);
+	boutc(fsc->client, "'%s'\n", dfi->last_name);
 	return 0;
 }
 
@@ -146,7 +146,7 @@ __dcache_find_get_entry(struct dentry *parent, u64 idx,
 		cache_ctl->folio = filemap_lock_folio(&dir->i_data, ptr_pgoff);
 		if (IS_ERR(cache_ctl->folio)) {
 			cache_ctl->folio = NULL;
-			doutc(cl, " folio %lu not found\n", ptr_pgoff);
+			boutc(cl, " folio %lu not found\n", ptr_pgoff);
 			return ERR_PTR(-EAGAIN);
 		}
 		/* reading/filling the cache are serialized by
@@ -197,7 +197,7 @@ static int __dcache_readdir(struct file *file,  struct dir_context *ctx,
 	u64 idx = 0;
 	int err = 0;
 
-	doutc(cl, "%p %llx.%llx v%u at %llx\n", dir, ceph_vinop(dir),
+	boutc(cl, "%p %llx.%llx v%u at %llx\n", dir, ceph_vinop(dir),
 	      (unsigned)shared_gen, ctx->pos);
 
 	/* search start position */
@@ -228,7 +228,7 @@ static int __dcache_readdir(struct file *file,  struct dir_context *ctx,
 			dput(dentry);
 		}
 
-		doutc(cl, "%p %llx.%llx cache idx %llu\n", dir,
+		boutc(cl, "%p %llx.%llx cache idx %llu\n", dir,
 		      ceph_vinop(dir), idx);
 	}
 
@@ -265,7 +265,7 @@ static int __dcache_readdir(struct file *file,  struct dir_context *ctx,
 		spin_unlock(&dentry->d_lock);
 
 		if (emit_dentry) {
-			doutc(cl, " %llx dentry %p %pd %p\n", di->offset,
+			boutc(cl, " %llx dentry %p %pd %p\n", di->offset,
 			      dentry, dentry, d_inode(dentry));
 			ctx->pos = di->offset;
 			if (!dir_emit(ctx, dentry->d_name.name,
@@ -327,14 +327,14 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 	unsigned frag = -1;
 	struct ceph_mds_reply_info_parsed *rinfo;
 
-	doutc(cl, "%p %llx.%llx file %p pos %llx\n", inode,
+	boutc(cl, "%p %llx.%llx file %p pos %llx\n", inode,
 	      ceph_vinop(inode), file, ctx->pos);
 	if (dfi->file_info.flags & CEPH_F_ATEND)
 		return 0;
 
 	/* always start with . and .. */
 	if (ctx->pos == 0) {
-		doutc(cl, "%p %llx.%llx off 0 -> '.'\n", inode,
+		boutc(cl, "%p %llx.%llx off 0 -> '.'\n", inode,
 		      ceph_vinop(inode));
 		if (!dir_emit(ctx, ".", 1, ceph_present_inode(inode),
 			    inode->i_mode >> 12))
@@ -349,7 +349,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		ino = ceph_present_inode(dentry->d_parent->d_inode);
 		spin_unlock(&dentry->d_lock);
 
-		doutc(cl, "%p %llx.%llx off 1 -> '..'\n", inode,
+		boutc(cl, "%p %llx.%llx off 1 -> '..'\n", inode,
 		      ceph_vinop(inode));
 		if (!dir_emit(ctx, "..", 2, ino, inode->i_mode >> 12))
 			return 0;
@@ -404,7 +404,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			frag = fpos_frag(ctx->pos);
 		}
 
-		doutc(cl, "fetching %p %llx.%llx frag %x offset '%s'\n",
+		boutc(cl, "fetching %p %llx.%llx frag %x offset '%s'\n",
 		      inode, ceph_vinop(inode), frag, dfi->last_name);
 		req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
 		if (IS_ERR(req))
@@ -458,7 +458,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			ceph_mdsc_put_request(req);
 			return err;
 		}
-		doutc(cl, "%p %llx.%llx got and parsed readdir result=%d"
+		boutc(cl, "%p %llx.%llx got and parsed readdir result=%d"
 		      "on frag %x, end=%d, complete=%d, hash_order=%d\n",
 		      inode, ceph_vinop(inode), err, frag,
 		      (int)req->r_reply_info.dir_end,
@@ -493,7 +493,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 				dfi->dir_ordered_count = req->r_dir_ordered_cnt;
 			}
 		} else {
-			doutc(cl, "%p %llx.%llx !did_prepopulate\n", inode,
+			boutc(cl, "%p %llx.%llx !did_prepopulate\n", inode,
 			      ceph_vinop(inode));
 			/* disable readdir cache */
 			dfi->readdir_cache_idx = -1;
@@ -521,7 +521,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 	}
 
 	rinfo = &dfi->last_readdir->r_reply_info;
-	doutc(cl, "%p %llx.%llx frag %x num %d pos %llx chunk first %llx\n",
+	boutc(cl, "%p %llx.%llx frag %x num %d pos %llx chunk first %llx\n",
 	      inode, ceph_vinop(inode), dfi->frag, rinfo->dir_nr, ctx->pos,
 	      rinfo->dir_nr ? rinfo->dir_entries[0].offset : 0LL);
 
@@ -553,7 +553,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			return -EIO;
 
 		ctx->pos = rde->offset;
-		doutc(cl, "%p %llx.%llx (%d/%d) -> %llx '%.*s' %p\n", inode,
+		boutc(cl, "%p %llx.%llx (%d/%d) -> %llx '%.*s' %p\n", inode,
 		      ceph_vinop(inode), i, rinfo->dir_nr, ctx->pos,
 		      rde->name_len, rde->name, &rde->inode.in);
 
@@ -566,7 +566,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			 * doesn't have enough memory, etc. So for next readdir
 			 * it will continue.
 			 */
-			doutc(cl, "filldir stopping us...\n");
+			boutc(cl, "filldir stopping us...\n");
 			return 0;
 		}
 
@@ -597,7 +597,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			kfree(dfi->last_name);
 			dfi->last_name = NULL;
 		}
-		doutc(cl, "%p %llx.%llx next frag is %x\n", inode,
+		boutc(cl, "%p %llx.%llx next frag is %x\n", inode,
 		      ceph_vinop(inode), frag);
 		goto more;
 	}
@@ -613,7 +613,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		spin_lock(&ci->i_ceph_lock);
 		if (dfi->dir_ordered_count ==
 				atomic64_read(&ci->i_ordered_count)) {
-			doutc(cl, " marking %p %llx.%llx complete and ordered\n",
+			boutc(cl, " marking %p %llx.%llx complete and ordered\n",
 			      inode, ceph_vinop(inode));
 			/* use i_size to track number of entries in
 			 * readdir cache */
@@ -621,14 +621,14 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			i_size_write(inode, dfi->readdir_cache_idx *
 				     sizeof(struct dentry*));
 		} else {
-			doutc(cl, " marking %llx.%llx complete\n",
+			boutc(cl, " marking %llx.%llx complete\n",
 			      ceph_vinop(inode));
 		}
 		__ceph_dir_set_complete(ci, dfi->dir_release_count,
 					dfi->dir_ordered_count);
 		spin_unlock(&ci->i_ceph_lock);
 	}
-	doutc(cl, "%p %llx.%llx file %p done.\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p %llx.%llx file %p done.\n", inode, ceph_vinop(inode),
 	      file);
 	return 0;
 }
@@ -695,7 +695,7 @@ static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int whence)
 
 	if (offset >= 0) {
 		if (need_reset_readdir(dfi, offset)) {
-			doutc(cl, "%p %llx.%llx dropping %p content\n",
+			boutc(cl, "%p %llx.%llx dropping %p content\n",
 			      inode, ceph_vinop(inode), file);
 			reset_readdir(dfi);
 		} else if (is_hash_order(offset) && offset > file->f_pos) {
@@ -733,7 +733,7 @@ struct dentry *ceph_handle_snapdir(struct ceph_mds_request *req,
 		struct inode *inode = ceph_get_snapdir(parent);
 
 		res = d_splice_alias(inode, dentry);
-		doutc(cl, "ENOENT on snapdir %p '%pd', linking to "
+		boutc(cl, "ENOENT on snapdir %p '%pd', linking to "
 		      "snapdir %p %llx.%llx. Spliced dentry %p\n",
 		      dentry, dentry, inode, ceph_vinop(inode), res);
 		if (res)
@@ -762,7 +762,7 @@ struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
 		/* no trace? */
 		err = 0;
 		if (!req->r_reply_info.head->is_dentry) {
-			doutc(cl,
+			boutc(cl,
 			      "ENOENT and no trace, dentry %p inode %llx.%llx\n",
 			      dentry, ceph_vinop(d_inode(dentry)));
 			if (d_really_is_positive(dentry)) {
@@ -803,7 +803,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	int mask;
 	int err;
 
-	doutc(cl, "%p %llx.%llx/'%pd' dentry %p\n", dir, ceph_vinop(dir),
+	boutc(cl, "%p %llx.%llx/'%pd' dentry %p\n", dir, ceph_vinop(dir),
 	      dentry, dentry);
 
 	if (dentry->d_name.len > NAME_MAX)
@@ -827,7 +827,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 		struct ceph_dentry_info *di = ceph_dentry(dentry);
 
 		spin_lock(&ci->i_ceph_lock);
-		doutc(cl, " dir %llx.%llx flags are 0x%lx\n",
+		boutc(cl, " dir %llx.%llx flags are 0x%lx\n",
 		      ceph_vinop(dir), ci->i_ceph_flags);
 		if (strncmp(dentry->d_name.name,
 			    fsc->mount_options->snapdir_name,
@@ -838,7 +838,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 		    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 			__ceph_touch_fmode(ci, mdsc, CEPH_FILE_MODE_RD);
 			spin_unlock(&ci->i_ceph_lock);
-			doutc(cl, " dir %llx.%llx complete, -ENOENT\n",
+			boutc(cl, " dir %llx.%llx complete, -ENOENT\n",
 			      ceph_vinop(dir));
 			d_add(dentry, NULL);
 			di->lease_shared_gen = atomic_read(&ci->i_shared_gen);
@@ -877,7 +877,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	}
 	dentry = ceph_finish_lookup(req, dentry, err);
 	ceph_mdsc_put_request(req);  /* will dput(dentry) */
-	doutc(cl, "result=%p\n", dentry);
+	boutc(cl, "result=%p\n", dentry);
 	return dentry;
 }
 
@@ -929,7 +929,7 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 		goto out;
 	}
 
-	doutc(cl, "%p %llx.%llx/'%pd' dentry %p mode 0%ho rdev %d\n",
+	boutc(cl, "%p %llx.%llx/'%pd' dentry %p mode 0%ho rdev %d\n",
 	      dir, ceph_vinop(dir), dentry, dentry, mode, rdev);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_MKNOD, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
@@ -1040,7 +1040,7 @@ static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		goto out;
 	}
 
-	doutc(cl, "%p %llx.%llx/'%pd' to '%s'\n", dir, ceph_vinop(dir), dentry,
+	boutc(cl, "%p %llx.%llx/'%pd' to '%s'\n", dir, ceph_vinop(dir), dentry,
 	      dest);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_SYMLINK, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
@@ -1110,10 +1110,10 @@ static struct dentry *ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	if (ceph_snap(dir) == CEPH_SNAPDIR) {
 		/* mkdir .snap/foo is a MKSNAP */
 		op = CEPH_MDS_OP_MKSNAP;
-		doutc(cl, "mksnap %llx.%llx/'%pd' dentry %p\n",
+		boutc(cl, "mksnap %llx.%llx/'%pd' dentry %p\n",
 		      ceph_vinop(dir), dentry, dentry);
 	} else if (ceph_snap(dir) == CEPH_NOSNAP) {
-		doutc(cl, "mkdir %llx.%llx/'%pd' dentry %p mode 0%ho\n",
+		boutc(cl, "mkdir %llx.%llx/'%pd' dentry %p mode 0%ho\n",
 		      ceph_vinop(dir), dentry, dentry, mode);
 		op = CEPH_MDS_OP_MKDIR;
 	} else {
@@ -1206,7 +1206,7 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
 	if (err)
 		return err;
 
-	doutc(cl, "%p %llx.%llx/'%pd' to '%pd'\n", dir, ceph_vinop(dir),
+	boutc(cl, "%p %llx.%llx/'%pd' to '%pd'\n", dir, ceph_vinop(dir),
 	      old_dentry, dentry);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LINK, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
@@ -1347,11 +1347,11 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 
 	if (ceph_snap(dir) == CEPH_SNAPDIR) {
 		/* rmdir .snap/foo is RMSNAP */
-		doutc(cl, "rmsnap %llx.%llx/'%pd' dn\n", ceph_vinop(dir),
+		boutc(cl, "rmsnap %llx.%llx/'%pd' dn\n", ceph_vinop(dir),
 		      dentry);
 		op = CEPH_MDS_OP_RMSNAP;
 	} else if (ceph_snap(dir) == CEPH_NOSNAP) {
-		doutc(cl, "unlink/rmdir %llx.%llx/'%pd' inode %llx.%llx\n",
+		boutc(cl, "unlink/rmdir %llx.%llx/'%pd' inode %llx.%llx\n",
 		      ceph_vinop(dir), dentry, ceph_vinop(inode));
 		op = d_is_dir(dentry) ?
 			CEPH_MDS_OP_RMDIR : CEPH_MDS_OP_UNLINK;
@@ -1400,7 +1400,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	    (req->r_dir_caps = get_caps_for_async_unlink(dir, dentry))) {
 		struct ceph_dentry_info *di = ceph_dentry(dentry);
 
-		doutc(cl, "async unlink on %llx.%llx/'%pd' caps=%s",
+		boutc(cl, "async unlink on %llx.%llx/'%pd' caps=%s",
 		      ceph_vinop(dir), dentry,
 		      ceph_cap_string(req->r_dir_caps));
 		set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
@@ -1487,7 +1487,7 @@ static int ceph_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (err)
 		return err;
 
-	doutc(cl, "%llx.%llx/'%pd' to %llx.%llx/'%pd'\n",
+	boutc(cl, "%llx.%llx/'%pd' to %llx.%llx/'%pd'\n",
 	      ceph_vinop(old_dir), old_dentry, ceph_vinop(new_dir),
 	      new_dentry);
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
@@ -1537,7 +1537,7 @@ void __ceph_dentry_lease_touch(struct ceph_dentry_info *di)
 	struct ceph_mds_client *mdsc = ceph_sb_to_fs_client(dn->d_sb)->mdsc;
 	struct ceph_client *cl = mdsc->fsc->client;
 
-	doutc(cl, "%p %p '%pd'\n", di, dn, dn);
+	boutc(cl, "%p %p '%pd'\n", di, dn, dn);
 
 	di->flags |= CEPH_DENTRY_LEASE_LIST;
 	if (di->flags & CEPH_DENTRY_SHRINK_LIST) {
@@ -1571,7 +1571,7 @@ void __ceph_dentry_dir_lease_touch(struct ceph_dentry_info *di)
 	struct ceph_mds_client *mdsc = ceph_sb_to_fs_client(dn->d_sb)->mdsc;
 	struct ceph_client *cl = mdsc->fsc->client;
 
-	doutc(cl, "%p %p '%pd' (offset 0x%llx)\n", di, dn, dn, di->offset);
+	boutc(cl, "%p %p '%pd' (offset 0x%llx)\n", di, dn, dn, di->offset);
 
 	if (!list_empty(&di->lease_list)) {
 		if (di->flags & CEPH_DENTRY_LEASE_LIST) {
@@ -1870,7 +1870,7 @@ static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags)
 					 CEPH_MDS_LEASE_RENEW, seq);
 		ceph_put_mds_session(session);
 	}
-	doutc(cl, "dentry %p = %d\n", dentry, valid);
+	boutc(cl, "dentry %p = %d\n", dentry, valid);
 	return valid;
 }
 
@@ -1935,7 +1935,7 @@ static int dir_lease_is_valid(struct inode *dir, struct dentry *dentry,
 			valid = 0;
 		spin_unlock(&dentry->d_lock);
 	}
-	doutc(cl, "dir %p %llx.%llx v%u dentry %p '%pd' = %d\n", dir,
+	boutc(cl, "dir %p %llx.%llx v%u dentry %p '%pd' = %d\n", dir,
 	      ceph_vinop(dir), (unsigned)atomic_read(&ci->i_shared_gen),
 	      dentry, dentry, valid);
 	return valid;
@@ -1958,7 +1958,7 @@ static int ceph_d_revalidate(struct inode *dir, const struct qstr *name,
 
 	inode = d_inode_rcu(dentry);
 
-	doutc(cl, "%p '%pd' inode %p offset 0x%llx nokey %d\n",
+	boutc(cl, "%p '%pd' inode %p offset 0x%llx nokey %d\n",
 	      dentry, dentry, inode, ceph_dentry(dentry)->offset,
 	      !!(dentry->d_flags & DCACHE_NOKEY_NAME));
 
@@ -1966,7 +1966,7 @@ static int ceph_d_revalidate(struct inode *dir, const struct qstr *name,
 
 	/* always trust cached snapped dentries, snapdir dentry */
 	if (ceph_snap(dir) != CEPH_NOSNAP) {
-		doutc(cl, "%p '%pd' inode %p is SNAPPED\n", dentry,
+		boutc(cl, "%p '%pd' inode %p is SNAPPED\n", dentry,
 		      dentry, inode);
 		valid = 1;
 	} else if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
@@ -2024,14 +2024,14 @@ static int ceph_d_revalidate(struct inode *dir, const struct qstr *name,
 				break;
 			}
 			ceph_mdsc_put_request(req);
-			doutc(cl, "%p '%pd', lookup result=%d\n", dentry,
+			boutc(cl, "%p '%pd', lookup result=%d\n", dentry,
 			      dentry, err);
 		}
 	} else {
 		percpu_counter_inc(&mdsc->metric.d_lease_hit);
 	}
 
-	doutc(cl, "%p '%pd' %s\n", dentry, dentry, valid ? "valid" : "invalid");
+	boutc(cl, "%p '%pd' %s\n", dentry, dentry, valid ? "valid" : "invalid");
 	if (!valid)
 		ceph_dir_clear_complete(dir);
 	return valid;
@@ -2070,7 +2070,7 @@ static void ceph_d_release(struct dentry *dentry)
 	struct ceph_dentry_info *di = ceph_dentry(dentry);
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(dentry->d_sb);
 
-	doutc(fsc->client, "dentry %p '%pd'\n", dentry, dentry);
+	boutc(fsc->client, "dentry %p '%pd'\n", dentry, dentry);
 
 	atomic64_dec(&fsc->mdsc->metric.total_dentries);
 
@@ -2096,7 +2096,7 @@ static void ceph_d_prune(struct dentry *dentry)
 	struct ceph_inode_info *dir_ci;
 	struct ceph_dentry_info *di;
 
-	doutc(cl, "dentry %p '%pd'\n", dentry, dentry);
+	boutc(cl, "dentry %p '%pd'\n", dentry, dentry);
 
 	/* do we have a valid parent? */
 	if (IS_ROOT(dentry))
diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index b2f2af104679..cba4cf18cdbd 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -87,7 +87,7 @@ static int ceph_encode_snapfh(struct inode *inode, u32 *rawfh, int *max_len,
 	*max_len = snap_handle_length;
 	ret = FILEID_BTRFS_WITH_PARENT;
 out:
-	doutc(cl, "%p %llx.%llx ret=%d\n", inode, ceph_vinop(inode), ret);
+	boutc(cl, "%p %llx.%llx ret=%d\n", inode, ceph_vinop(inode), ret);
 	return ret;
 }
 
@@ -112,7 +112,7 @@ static int ceph_encode_fh(struct inode *inode, u32 *rawfh, int *max_len,
 
 	if (parent_inode) {
 		struct ceph_nfs_confh *cfh = (void *)rawfh;
-		doutc(cl, "%p %llx.%llx with parent %p %llx.%llx\n", inode,
+		boutc(cl, "%p %llx.%llx with parent %p %llx.%llx\n", inode,
 		      ceph_vinop(inode), parent_inode, ceph_vinop(parent_inode));
 		cfh->ino = ceph_ino(inode);
 		cfh->parent_ino = ceph_ino(parent_inode);
@@ -120,7 +120,7 @@ static int ceph_encode_fh(struct inode *inode, u32 *rawfh, int *max_len,
 		type = FILEID_INO32_GEN_PARENT;
 	} else {
 		struct ceph_nfs_fh *fh = (void *)rawfh;
-		doutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
+		boutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
 		fh->ino = ceph_ino(inode);
 		*max_len = handle_length;
 		type = FILEID_INO32_GEN;
@@ -286,9 +286,9 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
 	ceph_mdsc_put_request(req);
 
 	if (want_parent) {
-		doutc(cl, "%llx.%llx\n err=%d\n", vino.ino, vino.snap, err);
+		boutc(cl, "%llx.%llx\n err=%d\n", vino.ino, vino.snap, err);
 	} else {
-		doutc(cl, "%llx.%llx parent %llx hash %x err=%d", vino.ino,
+		boutc(cl, "%llx.%llx parent %llx hash %x err=%d", vino.ino,
 		      vino.snap, sfh->parent_ino, sfh->hash, err);
 	}
 	/* see comments in ceph_get_parent() */
@@ -316,7 +316,7 @@ static struct dentry *ceph_fh_to_dentry(struct super_block *sb,
 	if (fh_len < sizeof(*fh) / BYTES_PER_U32)
 		return NULL;
 
-	doutc(fsc->client, "%llx\n", fh->ino);
+	boutc(fsc->client, "%llx\n", fh->ino);
 	return __fh_to_dentry(sb, fh->ino);
 }
 
@@ -409,7 +409,7 @@ static struct dentry *ceph_get_parent(struct dentry *child)
 		dn = __get_parent(child->d_sb, child, 0);
 	}
 out:
-	doutc(cl, "child %p %p %llx.%llx err=%ld\n", child, inode,
+	boutc(cl, "child %p %p %llx.%llx err=%ld\n", child, inode,
 	      ceph_vinop(inode), (long)PTR_ERR_OR_ZERO(dn));
 	return dn;
 }
@@ -435,7 +435,7 @@ static struct dentry *ceph_fh_to_parent(struct super_block *sb,
 	if (fh_len < sizeof(*cfh) / BYTES_PER_U32)
 		return NULL;
 
-	doutc(fsc->client, "%llx\n", cfh->parent_ino);
+	boutc(fsc->client, "%llx\n", cfh->parent_ino);
 	dentry = __get_parent(sb, NULL, cfh->ino);
 	if (unlikely(dentry == ERR_PTR(-ENOENT)))
 		dentry = __fh_to_dentry(sb, cfh->parent_ino);
@@ -540,7 +540,7 @@ static int __get_snap_name(struct dentry *parent, char *name,
 	if (req)
 		ceph_mdsc_put_request(req);
 	kfree(last_name);
-	doutc(fsc->client, "child dentry %p %p %llx.%llx err=%d\n", child,
+	boutc(fsc->client, "child dentry %p %p %llx.%llx err=%d\n", child,
 	      inode, ceph_vinop(inode), err);
 	return err;
 }
@@ -602,7 +602,7 @@ static int ceph_get_name(struct dentry *parent, char *name,
 		ceph_fname_free_buffer(dir, &oname);
 	}
 out:
-	doutc(mdsc->fsc->client, "child dentry %p %p %llx.%llx err %d %s%s\n",
+	boutc(mdsc->fsc->client, "child dentry %p %p %llx.%llx err %d %s%s\n",
 	      child, inode, ceph_vinop(inode), err, err ? "" : "name ",
 	      err ? "" : name);
 	ceph_mdsc_put_request(req);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 99b30f784ee2..ed0509b4574e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -50,7 +50,7 @@ static __le32 ceph_flags_sys2wire(struct ceph_mds_client *mdsc, u32 flags)
 #undef ceph_sys2wire
 
 	if (flags)
-		doutc(cl, "unused open flags: %x\n", flags);
+		boutc(cl, "unused open flags: %x\n", flags);
 
 	return cpu_to_le32(wire_flags);
 }
@@ -207,7 +207,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	struct ceph_file_info *fi;
 	int ret;
 
-	doutc(cl, "%p %llx.%llx %p 0%o (%s)\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p %llx.%llx %p 0%o (%s)\n", inode, ceph_vinop(inode),
 	      file, inode->i_mode, isdir ? "dir" : "regular");
 	BUG_ON(inode->i_fop->release != ceph_release);
 
@@ -275,12 +275,12 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
 		break;
 
 	case S_IFLNK:
-		doutc(cl, "%p %llx.%llx %p 0%o (symlink)\n", inode,
+		boutc(cl, "%p %llx.%llx %p 0%o (symlink)\n", inode,
 		      ceph_vinop(inode), file, inode->i_mode);
 		break;
 
 	default:
-		doutc(cl, "%p %llx.%llx %p 0%o (special)\n", inode,
+		boutc(cl, "%p %llx.%llx %p 0%o (special)\n", inode,
 		      ceph_vinop(inode), file, inode->i_mode);
 		/*
 		 * we need to drop the open ref now, since we don't
@@ -312,7 +312,7 @@ int ceph_renew_caps(struct inode *inode, int fmode)
 	    (!(wanted & CEPH_CAP_ANY_WR) || ci->i_auth_cap)) {
 		int issued = __ceph_caps_issued(ci, NULL);
 		spin_unlock(&ci->i_ceph_lock);
-		doutc(cl, "%p %llx.%llx want %s issued %s updating mds_wanted\n",
+		boutc(cl, "%p %llx.%llx want %s issued %s updating mds_wanted\n",
 		      inode, ceph_vinop(inode), ceph_cap_string(wanted),
 		      ceph_cap_string(issued));
 		ceph_check_caps(ci, 0);
@@ -345,7 +345,7 @@ int ceph_renew_caps(struct inode *inode, int fmode)
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
 	ceph_mdsc_put_request(req);
 out:
-	doutc(cl, "%p %llx.%llx open result=%d\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p %llx.%llx open result=%d\n", inode, ceph_vinop(inode),
 	      err);
 	return err < 0 ? err : 0;
 }
@@ -372,7 +372,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	int mask = MAY_READ;
 
 	if (fi) {
-		doutc(cl, "file %p is already opened\n", file);
+		boutc(cl, "file %p is already opened\n", file);
 		return 0;
 	}
 
@@ -386,7 +386,7 @@ int ceph_open(struct inode *inode, struct file *file)
 			return err;
 	}
 
-	doutc(cl, "%p %llx.%llx file %p flags %d (%d)\n", inode,
+	boutc(cl, "%p %llx.%llx file %p flags %d (%d)\n", inode,
 	      ceph_vinop(inode), file, flags, file->f_flags);
 	fmode = ceph_flags_to_mode(flags);
 	wanted = ceph_caps_for_mode(fmode);
@@ -437,7 +437,7 @@ int ceph_open(struct inode *inode, struct file *file)
 		int mds_wanted = __ceph_caps_mds_wanted(ci, true);
 		int issued = __ceph_caps_issued(ci, NULL);
 
-		doutc(cl, "open %p fmode %d want %s issued %s using existing\n",
+		boutc(cl, "open %p fmode %d want %s issued %s using existing\n",
 		      inode, fmode, ceph_cap_string(wanted),
 		      ceph_cap_string(issued));
 		__ceph_touch_fmode(ci, mdsc, fmode);
@@ -459,7 +459,7 @@ int ceph_open(struct inode *inode, struct file *file)
 
 	spin_unlock(&ci->i_ceph_lock);
 
-	doutc(cl, "open fmode %d wants %s\n", fmode, ceph_cap_string(wanted));
+	boutc(cl, "open fmode %d wants %s\n", fmode, ceph_cap_string(wanted));
 	req = prepare_open_request(inode->i_sb, flags, 0);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -473,7 +473,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	if (!err)
 		err = ceph_init_file(inode, file, req->r_fmode);
 	ceph_mdsc_put_request(req);
-	doutc(cl, "open result=%d on %llx.%llx\n", err, ceph_vinop(inode));
+	boutc(cl, "open result=%d on %llx.%llx\n", err, ceph_vinop(inode));
 out:
 	return err;
 }
@@ -728,7 +728,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 			      req->r_fmode, NULL);
 	up_read(&mdsc->snap_rwsem);
 	if (ret) {
-		doutc(cl, "failed to fill inode: %d\n", ret);
+		boutc(cl, "failed to fill inode: %d\n", ret);
 		ceph_dir_clear_complete(dir);
 		if (!d_unhashed(dentry))
 			d_drop(dentry);
@@ -736,7 +736,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 	} else {
 		struct dentry *dn;
 
-		doutc(cl, "d_adding new inode 0x%llx to 0x%llx/%s\n",
+		boutc(cl, "d_adding new inode 0x%llx to 0x%llx/%s\n",
 		      vino.ino, ceph_ino(dir), dentry->d_name.name);
 		ceph_dir_clear_ordered(dir);
 		ceph_init_inode_acls(inode, as_ctx);
@@ -787,7 +787,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	int err;
 	char *path;
 
-	doutc(cl, "%p %llx.%llx dentry %p '%pd' %s flags %d mode 0%o\n",
+	boutc(cl, "%p %llx.%llx dentry %p '%pd' %s flags %d mode 0%o\n",
 	      dir, ceph_vinop(dir), dentry, dentry,
 	      d_unhashed(dentry) ? "unhashed" : "hashed", flags, mode);
 
@@ -958,7 +958,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		goto out_req;
 	if (dn || d_really_is_negative(dentry) || d_is_symlink(dentry)) {
 		/* make vfs retry on splice, ENOENT, or symlink */
-		doutc(cl, "finish_no_open on dn %p\n", dn);
+		boutc(cl, "finish_no_open on dn %p\n", dn);
 		err = finish_no_open(file, dn);
 	} else {
 		if (IS_ENCRYPTED(dir) &&
@@ -969,7 +969,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			goto out_req;
 		}
 
-		doutc(cl, "finish_open on dn %p\n", dn);
+		boutc(cl, "finish_open on dn %p\n", dn);
 		if (req->r_op == CEPH_MDS_OP_CREATE && req->r_reply_info.has_create_ino) {
 			struct inode *newino = d_inode(dentry);
 
@@ -984,7 +984,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	iput(new_inode);
 out_ctx:
 	ceph_release_acl_sec_ctx(&as_ctx);
-	doutc(cl, "result=%d\n", err);
+	boutc(cl, "result=%d\n", err);
 	return err;
 }
 
@@ -995,7 +995,7 @@ int ceph_release(struct inode *inode, struct file *file)
 
 	if (S_ISDIR(inode->i_mode)) {
 		struct ceph_dir_file_info *dfi = file->private_data;
-		doutc(cl, "%p %llx.%llx dir file %p\n", inode,
+		boutc(cl, "%p %llx.%llx dir file %p\n", inode,
 		      ceph_vinop(inode), file);
 		WARN_ON(!list_empty(&dfi->file_info.rw_contexts));
 
@@ -1008,7 +1008,7 @@ int ceph_release(struct inode *inode, struct file *file)
 		kmem_cache_free(ceph_dir_file_cachep, dfi);
 	} else {
 		struct ceph_file_info *fi = file->private_data;
-		doutc(cl, "%p %llx.%llx regular file %p\n", inode,
+		boutc(cl, "%p %llx.%llx regular file %p\n", inode,
 		      ceph_vinop(inode), file);
 		WARN_ON(!list_empty(&fi->rw_contexts));
 
@@ -1054,7 +1054,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
 	u64 objver = 0;
 
-	doutc(cl, "on inode %p %llx.%llx %llx~%llx\n", inode,
+	boutc(cl, "on inode %p %llx.%llx %llx~%llx\n", inode,
 	      ceph_vinop(inode), *ki_pos, len);
 
 	if (ceph_inode_is_shutdown(inode))
@@ -1090,7 +1090,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		/* determine new offset/length if encrypted */
 		ceph_fscrypt_adjust_off_and_len(inode, &read_off, &read_len);
 
-		doutc(cl, "orig %llu~%llu reading %llu~%llu", off, len,
+		boutc(cl, "orig %llu~%llu reading %llu~%llu", off, len,
 		      read_off, read_len);
 
 		req = ceph_osdc_new_request(osdc, &ci->i_layout,
@@ -1145,7 +1145,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			objver = req->r_version;
 
 		i_size = i_size_read(inode);
-		doutc(cl, "%llu~%llu got %zd i_size %llu%s\n", off, len,
+		boutc(cl, "%llu~%llu got %zd i_size %llu%s\n", off, len,
 		      ret, i_size, (more ? " MORE" : ""));
 
 		/* Fix it to go to end of extent map */
@@ -1192,7 +1192,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			int zlen = min(len - ret, i_size - off - ret);
 			int zoff = page_off + ret;
 
-			doutc(cl, "zero gap %llu~%llu\n", off + ret,
+			boutc(cl, "zero gap %llu~%llu\n", off + ret,
 			      off + ret + zlen);
 			ceph_zero_page_vector_range(zoff, zlen, pages);
 			ret += zlen;
@@ -1238,7 +1238,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		if (last_objver)
 			*last_objver = objver;
 	}
-	doutc(cl, "result %zd retry_op %d\n", ret, *retry_op);
+	boutc(cl, "result %zd retry_op %d\n", ret, *retry_op);
 	return ret;
 }
 
@@ -1249,7 +1249,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	struct inode *inode = file_inode(file);
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 
-	doutc(cl, "on file %p %llx~%zx %s\n", file, iocb->ki_pos,
+	boutc(cl, "on file %p %llx~%zx %s\n", file, iocb->ki_pos,
 	      iov_iter_count(to),
 	      (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
 
@@ -1293,7 +1293,7 @@ static void ceph_aio_complete(struct inode *inode,
 	if (!ret)
 		ret = aio_req->total_len;
 
-	doutc(cl, "%p %llx.%llx rc %d\n", inode, ceph_vinop(inode), ret);
+	boutc(cl, "%p %llx.%llx rc %d\n", inode, ceph_vinop(inode), ret);
 
 	if (ret >= 0 && aio_req->write) {
 		int dirty;
@@ -1337,7 +1337,7 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
 
-	doutc(cl, "req %p inode %p %llx.%llx, rc %d bytes %u\n", req,
+	boutc(cl, "req %p inode %p %llx.%llx, rc %d bytes %u\n", req,
 	      inode, ceph_vinop(inode), rc, len);
 
 	if (rc == -EOLDSNAPC) {
@@ -1498,7 +1498,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
 
-	doutc(cl, "sync_direct_%s on file %p %lld~%u snapc %p seq %lld\n",
+	boutc(cl, "sync_direct_%s on file %p %lld~%u snapc %p seq %lld\n",
 	      (write ? "write" : "read"), file, pos, (unsigned)count,
 	      snapc, snapc ? snapc->seq : 0);
 
@@ -1511,7 +1511,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 					pos >> PAGE_SHIFT,
 					(pos + count - 1) >> PAGE_SHIFT);
 		if (ret2 < 0)
-			doutc(cl, "invalidate_inode_pages2_range returned %d\n",
+			boutc(cl, "invalidate_inode_pages2_range returned %d\n",
 			      ret2);
 
 		flags = /* CEPH_OSD_FLAG_ORDERSNAP | */ CEPH_OSD_FLAG_WRITE;
@@ -1723,7 +1723,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 	if (ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
 
-	doutc(cl, "on file %p %lld~%u snapc %p seq %lld\n", file, pos,
+	boutc(cl, "on file %p %lld~%u snapc %p seq %lld\n", file, pos,
 	      (unsigned)count, snapc, snapc->seq);
 
 	ret = filemap_write_and_wait_range(inode->i_mapping,
@@ -1768,7 +1768,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		last = (pos + len) != (write_pos + write_len);
 		rmw = first || last;
 
-		doutc(cl, "ino %llx %lld~%llu adjusted %lld~%llu -- %srmw\n",
+		boutc(cl, "ino %llx %lld~%llu adjusted %lld~%llu -- %srmw\n",
 		      ci->i_vino.ino, pos, len, write_pos, write_len,
 		      rmw ? "" : "no ");
 
@@ -1979,7 +1979,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 			left -= ret;
 		}
 		if (ret < 0) {
-			doutc(cl, "write failed with %d\n", ret);
+			boutc(cl, "write failed with %d\n", ret);
 			ceph_release_page_vector(pages, num_pages);
 			break;
 		}
@@ -1988,7 +1988,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 			ret = ceph_fscrypt_encrypt_pages(inode, pages,
 							 write_pos, write_len);
 			if (ret < 0) {
-				doutc(cl, "encryption failed with %d\n", ret);
+				boutc(cl, "encryption failed with %d\n", ret);
 				ceph_release_page_vector(pages, num_pages);
 				break;
 			}
@@ -2007,7 +2007,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 			break;
 		}
 
-		doutc(cl, "write op %lld~%llu\n", write_pos, write_len);
+		boutc(cl, "write op %lld~%llu\n", write_pos, write_len);
 		osd_req_op_extent_osd_data_pages(req, rmw ? 1 : 0, pages, write_len,
 						 offset_in_page(write_pos), false,
 						 true);
@@ -2038,7 +2038,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 					  req->r_end_latency, len, ret);
 		ceph_osdc_put_request(req);
 		if (ret != 0) {
-			doutc(cl, "osd write returned %d\n", ret);
+			boutc(cl, "osd write returned %d\n", ret);
 			/* Version changed! Must re-do the rmw cycle */
 			if ((assert_ver && (ret == -ERANGE || ret == -EOVERFLOW)) ||
 			    (!assert_ver && ret == -EEXIST)) {
@@ -2068,13 +2068,13 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 				pos >> PAGE_SHIFT,
 				(pos + len - 1) >> PAGE_SHIFT);
 		if (ret < 0) {
-			doutc(cl, "invalidate_inode_pages2_range returned %d\n",
+			boutc(cl, "invalidate_inode_pages2_range returned %d\n",
 			      ret);
 			ret = 0;
 		}
 		pos += len;
 		written += len;
-		doutc(cl, "written %d\n", written);
+		boutc(cl, "written %d\n", written);
 		if (pos > i_size_read(inode)) {
 			check_caps = ceph_inode_set_size(inode, pos);
 			if (check_caps)
@@ -2088,7 +2088,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		ret = written;
 		iocb->ki_pos = pos;
 	}
-	doutc(cl, "returning %d\n", ret);
+	boutc(cl, "returning %d\n", ret);
 	return ret;
 }
 
@@ -2113,7 +2113,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	int retry_op = 0, read = 0;
 
 again:
-	doutc(cl, "%llu~%u trying to get caps on %p %llx.%llx\n",
+	boutc(cl, "%llu~%u trying to get caps on %p %llx.%llx\n",
 	      iocb->ki_pos, (unsigned)len, inode, ceph_vinop(inode));
 
 	if (ceph_inode_is_shutdown(inode))
@@ -2142,7 +2142,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	    (iocb->ki_flags & IOCB_DIRECT) ||
 	    (fi->flags & CEPH_F_SYNC)) {
 
-		doutc(cl, "sync %p %llx.%llx %llu~%u got cap refs on %s\n",
+		boutc(cl, "sync %p %llx.%llx %llu~%u got cap refs on %s\n",
 		      inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len,
 		      ceph_cap_string(got));
 
@@ -2162,7 +2162,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		}
 	} else {
 		CEPH_DEFINE_RW_CONTEXT(rw_ctx, got);
-		doutc(cl, "async %p %llx.%llx %llu~%u got cap refs on %s\n",
+		boutc(cl, "async %p %llx.%llx %llu~%u got cap refs on %s\n",
 		      inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len,
 		      ceph_cap_string(got));
 		ceph_add_rw_context(fi, &rw_ctx);
@@ -2170,7 +2170,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		ceph_del_rw_context(fi, &rw_ctx);
 	}
 
-	doutc(cl, "%p %llx.%llx dropping cap refs on %s = %d\n",
+	boutc(cl, "%p %llx.%llx dropping cap refs on %s = %d\n",
 	      inode, ceph_vinop(inode), ceph_cap_string(got), (int)ret);
 	ceph_put_cap_refs(ci, got);
 
@@ -2233,7 +2233,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		/* hit EOF or hole? */
 		if (retry_op == CHECK_EOF && iocb->ki_pos < i_size &&
 		    ret < len) {
-			doutc(cl, "may hit hole, ppos %lld < size %lld, reading more\n",
+			boutc(cl, "may hit hole, ppos %lld < size %lld, reading more\n",
 			      iocb->ki_pos, i_size);
 
 			read += ret;
@@ -2265,7 +2265,7 @@ static ssize_t ceph_splice_read(struct file *in, loff_t *ppos,
 	int want = 0, got = 0;
 	CEPH_DEFINE_RW_CONTEXT(rw_ctx, 0);
 
-	dout("splice_read %p %llx.%llx %llu~%zu trying to get caps on %p\n",
+	bout("splice_read %p %llx.%llx %llu~%zu trying to get caps on %p\n",
 	     inode, ceph_vinop(inode), *ppos, len, inode);
 
 	if (ceph_inode_is_shutdown(inode))
@@ -2288,7 +2288,7 @@ static ssize_t ceph_splice_read(struct file *in, loff_t *ppos,
 		goto out_end;
 
 	if ((got & (CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO)) == 0) {
-		dout("splice_read/sync %p %llx.%llx %llu~%zu got cap refs on %s\n",
+		bout("splice_read/sync %p %llx.%llx %llu~%zu got cap refs on %s\n",
 		     inode, ceph_vinop(inode), *ppos, len,
 		     ceph_cap_string(got));
 
@@ -2297,7 +2297,7 @@ static ssize_t ceph_splice_read(struct file *in, loff_t *ppos,
 		return copy_splice_read(in, ppos, pipe, len, flags);
 	}
 
-	dout("splice_read %p %llx.%llx %llu~%zu got cap refs on %s\n",
+	bout("splice_read %p %llx.%llx %llu~%zu got cap refs on %s\n",
 	     inode, ceph_vinop(inode), *ppos, len, ceph_cap_string(got));
 
 	rw_ctx.caps = got;
@@ -2305,7 +2305,7 @@ static ssize_t ceph_splice_read(struct file *in, loff_t *ppos,
 	ret = filemap_splice_read(in, ppos, pipe, len, flags);
 	ceph_del_rw_context(fi, &rw_ctx);
 
-	dout("splice_read %p %llx.%llx dropping cap refs on %s = %zd\n",
+	bout("splice_read %p %llx.%llx dropping cap refs on %s = %zd\n",
 	     inode, ceph_vinop(inode), ceph_cap_string(got), ret);
 
 	ceph_put_cap_refs(ci, got);
@@ -2399,7 +2399,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (err)
 		goto out;
 
-	doutc(cl, "%p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
+	boutc(cl, "%p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
 	      inode, ceph_vinop(inode), pos, count,
 	      i_size_read(inode));
 	if (!(fi->flags & CEPH_F_SYNC) && !direct_lock)
@@ -2417,7 +2417,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	inode_inc_iversion_raw(inode);
 
-	doutc(cl, "%p %llx.%llx %llu~%zd got cap refs on %s\n",
+	boutc(cl, "%p %llx.%llx %llu~%zd got cap refs on %s\n",
 	      inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
 
 	if ((got & (CEPH_CAP_FILE_BUFFER|CEPH_CAP_FILE_LAZYIO)) == 0 ||
@@ -2478,13 +2478,13 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			ceph_check_caps(ci, CHECK_CAPS_FLUSH);
 	}
 
-	doutc(cl, "%p %llx.%llx %llu~%u  dropping cap refs on %s\n",
+	boutc(cl, "%p %llx.%llx %llu~%u  dropping cap refs on %s\n",
 	      inode, ceph_vinop(inode), pos, (unsigned)count,
 	      ceph_cap_string(got));
 	ceph_put_cap_refs(ci, got);
 
 	if (written == -EOLDSNAPC) {
-		doutc(cl, "%p %llx.%llx %llu~%u" "got EOLDSNAPC, retrying\n",
+		boutc(cl, "%p %llx.%llx %llu~%u" "got EOLDSNAPC, retrying\n",
 		      inode, ceph_vinop(inode), pos, (unsigned)count);
 		goto retry_snap;
 	}
@@ -2664,7 +2664,7 @@ static long ceph_fallocate(struct file *file, int mode,
 	loff_t endoff = 0;
 	loff_t size;
 
-	doutc(cl, "%p %llx.%llx mode %x, offset %llu length %llu\n",
+	boutc(cl, "%p %llx.%llx mode %x, offset %llu length %llu\n",
 	      inode, ceph_vinop(inode), mode, offset, length);
 
 	if (mode != (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -2805,7 +2805,7 @@ static int is_file_size_ok(struct inode *src_inode, struct inode *dst_inode,
 	 * inode.
 	 */
 	if (src_off + len > size) {
-		doutc(cl, "Copy beyond EOF (%llu + %zu > %llu)\n", src_off,
+		boutc(cl, "Copy beyond EOF (%llu + %zu > %llu)\n", src_off,
 		      len, size);
 		return -EOPNOTSUPP;
 	}
@@ -2927,7 +2927,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 				pr_notice_client(cl,
 					"OSDs don't support copy-from2; disabling copy offload\n");
 			}
-			doutc(cl, "returned %d\n", ret);
+			boutc(cl, "returned %d\n", ret);
 			if (bytes <= 0)
 				bytes = ret;
 			goto out;
@@ -2966,7 +2966,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 
 		if (ceph_fsid_compare(&src_fsc->client->fsid,
 				      &dst_fsc->client->fsid)) {
-			dout("Copying files across clusters: src: %pU dst: %pU\n",
+			bout("Copying files across clusters: src: %pU dst: %pU\n",
 			     &src_fsc->client->fsid, &dst_fsc->client->fsid);
 			return -EXDEV;
 		}
@@ -2997,7 +2997,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	    (src_ci->i_layout.stripe_count != 1) ||
 	    (dst_ci->i_layout.stripe_count != 1) ||
 	    (src_ci->i_layout.object_size != dst_ci->i_layout.object_size)) {
-		doutc(cl, "Invalid src/dst files layout\n");
+		boutc(cl, "Invalid src/dst files layout\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -3015,12 +3015,12 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	/* Start by sync'ing the source and destination files */
 	ret = file_write_and_wait_range(src_file, src_off, (src_off + len));
 	if (ret < 0) {
-		doutc(cl, "failed to write src file (%zd)\n", ret);
+		boutc(cl, "failed to write src file (%zd)\n", ret);
 		goto out;
 	}
 	ret = file_write_and_wait_range(dst_file, dst_off, (dst_off + len));
 	if (ret < 0) {
-		doutc(cl, "failed to write dst file (%zd)\n", ret);
+		boutc(cl, "failed to write dst file (%zd)\n", ret);
 		goto out;
 	}
 
@@ -3032,7 +3032,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	err = get_rd_wr_caps(src_file, &src_got,
 			     dst_file, (dst_off + len), &dst_got);
 	if (err < 0) {
-		doutc(cl, "get_rd_wr_caps returned %d\n", err);
+		boutc(cl, "get_rd_wr_caps returned %d\n", err);
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3047,7 +3047,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 					    dst_off >> PAGE_SHIFT,
 					    (dst_off + len) >> PAGE_SHIFT);
 	if (ret < 0) {
-		doutc(cl, "Failed to invalidate inode pages (%zd)\n",
+		boutc(cl, "Failed to invalidate inode pages (%zd)\n",
 			    ret);
 		ret = 0; /* XXX */
 	}
@@ -3069,7 +3069,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	 * starting at the src_off
 	 */
 	if (src_objoff) {
-		doutc(cl, "Initial partial copy of %u bytes\n", src_objlen);
+		boutc(cl, "Initial partial copy of %u bytes\n", src_objlen);
 
 		/*
 		 * we need to temporarily drop all caps as we'll be calling
@@ -3080,7 +3080,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 					src_objlen);
 		/* Abort on short copies or on error */
 		if (ret < (long)src_objlen) {
-			doutc(cl, "Failed partial copy (%zd)\n", ret);
+			boutc(cl, "Failed partial copy (%zd)\n", ret);
 			goto out;
 		}
 		len -= ret;
@@ -3102,7 +3102,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 			ret = bytes;
 		goto out_caps;
 	}
-	doutc(cl, "Copied %zu bytes out of %zu\n", bytes, len);
+	boutc(cl, "Copied %zu bytes out of %zu\n", bytes, len);
 	len -= bytes;
 	ret += bytes;
 
@@ -3130,13 +3130,13 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	 * there were errors in remote object copies (len >= object_size).
 	 */
 	if (len && (len < src_ci->i_layout.object_size)) {
-		doutc(cl, "Final partial copy of %zu bytes\n", len);
+		boutc(cl, "Final partial copy of %zu bytes\n", len);
 		bytes = splice_file_range(src_file, &src_off, dst_file,
 					  &dst_off, len);
 		if (bytes > 0)
 			ret += bytes;
 		else
-			doutc(cl, "Failed partial copy (%zd)\n", bytes);
+			boutc(cl, "Failed partial copy (%zd)\n", bytes);
 	}
 
 out:
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index a6e260d9e420..2dd295b49540 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -195,11 +195,11 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino,
 	}
 
 	if (!inode) {
-		doutc(cl, "no inode found for %llx.%llx\n", vino.ino, vino.snap);
+		boutc(cl, "no inode found for %llx.%llx\n", vino.ino, vino.snap);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	doutc(cl, "on %llx=%llx.%llx got %p new %d\n",
+	boutc(cl, "on %llx=%llx.%llx got %p new %d\n",
 	      ceph_present_inode(inode), ceph_vinop(inode), inode,
 	      !!(inode->i_state & I_NEW));
 	return inode;
@@ -255,7 +255,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 			inode->i_flags |= S_ENCRYPTED;
 			ci->fscrypt_auth_len = pci->fscrypt_auth_len;
 		} else {
-			doutc(cl, "Failed to alloc snapdir fscrypt_auth\n");
+			boutc(cl, "Failed to alloc snapdir fscrypt_auth\n");
 			ret = -ENOMEM;
 			goto err;
 		}
@@ -333,7 +333,7 @@ static struct ceph_inode_frag *__get_or_create_frag(struct ceph_inode_info *ci,
 	rb_link_node(&frag->node, parent, p);
 	rb_insert_color(&frag->node, &ci->i_fragtree);
 
-	doutc(cl, "added %p %llx.%llx frag %x\n", inode, ceph_vinop(inode), f);
+	boutc(cl, "added %p %llx.%llx frag %x\n", inode, ceph_vinop(inode), f);
 	return frag;
 }
 
@@ -390,7 +390,7 @@ static u32 __ceph_choose_frag(struct ceph_inode_info *ci, u32 v,
 
 		/* choose child */
 		nway = 1 << frag->split_by;
-		doutc(cl, "frag(%x) %x splits by %d (%d ways)\n", v, t,
+		boutc(cl, "frag(%x) %x splits by %d (%d ways)\n", v, t,
 		      frag->split_by, nway);
 		for (i = 0; i < nway; i++) {
 			n = ceph_frag_make_child(t, frag->split_by, i);
@@ -401,7 +401,7 @@ static u32 __ceph_choose_frag(struct ceph_inode_info *ci, u32 v,
 		}
 		BUG_ON(i == nway);
 	}
-	doutc(cl, "frag(%x) = %x\n", v, t);
+	boutc(cl, "frag(%x) = %x\n", v, t);
 
 	return t;
 }
@@ -450,13 +450,13 @@ static int ceph_fill_dirfrag(struct inode *inode,
 			goto out;
 		if (frag->split_by == 0) {
 			/* tree leaf, remove */
-			doutc(cl, "removed %p %llx.%llx frag %x (no ref)\n",
+			boutc(cl, "removed %p %llx.%llx frag %x (no ref)\n",
 			      inode, ceph_vinop(inode), id);
 			rb_erase(&frag->node, &ci->i_fragtree);
 			kfree(frag);
 		} else {
 			/* tree branch, keep and clear */
-			doutc(cl, "cleared %p %llx.%llx frag %x referral\n",
+			boutc(cl, "cleared %p %llx.%llx frag %x referral\n",
 			      inode, ceph_vinop(inode), id);
 			frag->mds = -1;
 			frag->ndist = 0;
@@ -481,7 +481,7 @@ static int ceph_fill_dirfrag(struct inode *inode,
 	frag->ndist = min_t(u32, ndist, CEPH_MAX_DIRFRAG_REP);
 	for (i = 0; i < frag->ndist; i++)
 		frag->dist[i] = le32_to_cpu(dirinfo->dist[i]);
-	doutc(cl, "%p %llx.%llx frag %x ndist=%d\n", inode,
+	boutc(cl, "%p %llx.%llx frag %x ndist=%d\n", inode,
 	      ceph_vinop(inode), frag->frag, frag->ndist);
 
 out:
@@ -546,7 +546,7 @@ static int ceph_fill_fragtree(struct inode *inode,
 		     frag_tree_split_cmp, NULL);
 	}
 
-	doutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
+	boutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
 	rb_node = rb_first(&ci->i_fragtree);
 	for (i = 0; i < nsplits; i++) {
 		id = le32_to_cpu(fragtree->splits[i].frag);
@@ -586,7 +586,7 @@ static int ceph_fill_fragtree(struct inode *inode,
 		if (frag->split_by == 0)
 			ci->i_fragtree_nsplits++;
 		frag->split_by = split_by;
-		doutc(cl, " frag %x split by %d\n", frag->frag, frag->split_by);
+		boutc(cl, " frag %x split by %d\n", frag->frag, frag->split_by);
 		prev_frag = frag;
 	}
 	while (rb_node) {
@@ -619,7 +619,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	if (!ci)
 		return NULL;
 
-	doutc(fsc->client, "%p\n", &ci->netfs.inode);
+	boutc(fsc->client, "%p\n", &ci->netfs.inode);
 
 	/* Set parameters for the netfs library */
 	netfs_inode_init(&ci->netfs, &ceph_netfs_ops, false);
@@ -738,7 +738,7 @@ void ceph_evict_inode(struct inode *inode)
 	struct ceph_inode_frag *frag;
 	struct rb_node *n;
 
-	doutc(cl, "%p ino %llx.%llx\n", inode, ceph_vinop(inode));
+	boutc(cl, "%p ino %llx.%llx\n", inode, ceph_vinop(inode));
 
 	percpu_counter_dec(&mdsc->metric.total_inodes);
 
@@ -762,7 +762,7 @@ void ceph_evict_inode(struct inode *inode)
 	 */
 	if (ci->i_snap_realm) {
 		if (ceph_snap(inode) == CEPH_NOSNAP) {
-			doutc(cl, " dropping residual ref to snap realm %p\n",
+			boutc(cl, " dropping residual ref to snap realm %p\n",
 			      ci->i_snap_realm);
 			ceph_change_snap_realm(inode, NULL);
 		} else {
@@ -811,7 +811,7 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 
 	if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) > 0 ||
 	    (truncate_seq == ci->i_truncate_seq && size > isize)) {
-		doutc(cl, "size %lld -> %llu\n", isize, size);
+		boutc(cl, "size %lld -> %llu\n", isize, size);
 		if (size > 0 && S_ISDIR(inode->i_mode)) {
 			pr_err_client(cl, "non-zero size for directory\n");
 			size = 0;
@@ -826,7 +826,7 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 			ceph_fscache_update(inode);
 		ci->i_reported_size = size;
 		if (truncate_seq != ci->i_truncate_seq) {
-			doutc(cl, "truncate_seq %u -> %u\n",
+			boutc(cl, "truncate_seq %u -> %u\n",
 			      ci->i_truncate_seq, truncate_seq);
 			ci->i_truncate_seq = truncate_seq;
 
@@ -856,14 +856,14 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 	 * anyway.
 	 */
 	if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) >= 0) {
-		doutc(cl, "truncate_size %lld -> %llu, encrypted %d\n",
+		boutc(cl, "truncate_size %lld -> %llu, encrypted %d\n",
 		      ci->i_truncate_size, truncate_size,
 		      !!IS_ENCRYPTED(inode));
 
 		ci->i_truncate_size = truncate_size;
 
 		if (IS_ENCRYPTED(inode)) {
-			doutc(cl, "truncate_pagecache_size %lld -> %llu\n",
+			boutc(cl, "truncate_pagecache_size %lld -> %llu\n",
 			      ci->i_truncate_pagecache_size, size);
 			ci->i_truncate_pagecache_size = size;
 		} else {
@@ -889,7 +889,7 @@ void ceph_fill_file_time(struct inode *inode, int issued,
 		      CEPH_CAP_XATTR_EXCL)) {
 		if (ci->i_version == 0 ||
 		    timespec64_compare(ctime, &ictime) > 0) {
-			doutc(cl, "ctime %lld.%09ld -> %lld.%09ld inc w/ cap\n",
+			boutc(cl, "ctime %lld.%09ld -> %lld.%09ld inc w/ cap\n",
 			     ictime.tv_sec, ictime.tv_nsec,
 			     ctime->tv_sec, ctime->tv_nsec);
 			inode_set_ctime_to_ts(inode, *ctime);
@@ -897,7 +897,7 @@ void ceph_fill_file_time(struct inode *inode, int issued,
 		if (ci->i_version == 0 ||
 		    ceph_seq_cmp(time_warp_seq, ci->i_time_warp_seq) > 0) {
 			/* the MDS did a utimes() */
-			doutc(cl, "mtime %lld.%09ld -> %lld.%09ld tw %d -> %d\n",
+			boutc(cl, "mtime %lld.%09ld -> %lld.%09ld tw %d -> %d\n",
 			     inode_get_mtime_sec(inode),
 			     inode_get_mtime_nsec(inode),
 			     mtime->tv_sec, mtime->tv_nsec,
@@ -912,14 +912,14 @@ void ceph_fill_file_time(struct inode *inode, int issued,
 			/* nobody did utimes(); take the max */
 			ts = inode_get_mtime(inode);
 			if (timespec64_compare(mtime, &ts) > 0) {
-				doutc(cl, "mtime %lld.%09ld -> %lld.%09ld inc\n",
+				boutc(cl, "mtime %lld.%09ld -> %lld.%09ld inc\n",
 				     ts.tv_sec, ts.tv_nsec,
 				     mtime->tv_sec, mtime->tv_nsec);
 				inode_set_mtime_to_ts(inode, *mtime);
 			}
 			ts = inode_get_atime(inode);
 			if (timespec64_compare(atime, &ts) > 0) {
-				doutc(cl, "atime %lld.%09ld -> %lld.%09ld inc\n",
+				boutc(cl, "atime %lld.%09ld -> %lld.%09ld inc\n",
 				     ts.tv_sec, ts.tv_nsec,
 				     atime->tv_sec, atime->tv_nsec);
 				inode_set_atime_to_ts(inode, *atime);
@@ -941,7 +941,7 @@ void ceph_fill_file_time(struct inode *inode, int issued,
 		}
 	}
 	if (warn) /* time_warp_seq shouldn't go backwards */
-		doutc(cl, "%p mds time_warp_seq %llu < %u\n", inode,
+		boutc(cl, "%p mds time_warp_seq %llu < %u\n", inode,
 		      time_warp_seq, ci->i_time_warp_seq);
 }
 
@@ -1009,7 +1009,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 	lockdep_assert_held(&mdsc->snap_rwsem);
 
-	doutc(cl, "%p ino %llx.%llx v %llu had %llu\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p ino %llx.%llx v %llu had %llu\n", inode, ceph_vinop(inode),
 	      le64_to_cpu(info->version), ci->i_version);
 
 	/* Once I_NEW is cleared, we can't change type or dev numbers */
@@ -1105,7 +1105,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		inode->i_mode = mode;
 		inode->i_uid = make_kuid(&init_user_ns, le32_to_cpu(info->uid));
 		inode->i_gid = make_kgid(&init_user_ns, le32_to_cpu(info->gid));
-		doutc(cl, "%p %llx.%llx mode 0%o uid.gid %d.%d\n", inode,
+		boutc(cl, "%p %llx.%llx mode 0%o uid.gid %d.%d\n", inode,
 		      ceph_vinop(inode), inode->i_mode,
 		      from_kuid(&init_user_ns, inode->i_uid),
 		      from_kgid(&init_user_ns, inode->i_gid));
@@ -1177,7 +1177,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		/* only update max_size on auth cap */
 		if ((info->cap.flags & CEPH_CAP_FLAG_AUTH) &&
 		    ci->i_max_size != le64_to_cpu(info->max_size)) {
-			doutc(cl, "max_size %lld -> %llu\n",
+			boutc(cl, "max_size %lld -> %llu\n",
 			    ci->i_max_size, le64_to_cpu(info->max_size));
 			ci->i_max_size = le64_to_cpu(info->max_size);
 		}
@@ -1318,7 +1318,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 			    (info_caps & CEPH_CAP_FILE_SHARED) &&
 			    (issued & CEPH_CAP_FILE_EXCL) == 0 &&
 			    !__ceph_dir_is_complete(ci)) {
-				doutc(cl, " marking %p complete (empty)\n",
+				boutc(cl, " marking %p complete (empty)\n",
 				      inode);
 				i_size_write(inode, 0);
 				__ceph_dir_set_complete(ci,
@@ -1328,7 +1328,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 			wake = true;
 		} else {
-			doutc(cl, " %p got snap_caps %s\n", inode,
+			boutc(cl, " %p got snap_caps %s\n", inode,
 			      ceph_cap_string(info_caps));
 			ci->i_snap_caps |= info_caps;
 		}
@@ -1399,7 +1399,7 @@ static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
 	long unsigned ttl = from_time + (duration * HZ) / 1000;
 	long unsigned half_ttl = from_time + (duration * HZ / 2) / 1000;
 
-	doutc(cl, "%p duration %lu ms ttl %lu\n", dentry, duration, ttl);
+	boutc(cl, "%p duration %lu ms ttl %lu\n", dentry, duration, ttl);
 
 	/* only track leases on regular dentries */
 	if (ceph_snap(dir) != CEPH_NOSNAP)
@@ -1538,14 +1538,14 @@ static int splice_dentry(struct dentry **pdn, struct inode *in)
 	}
 
 	if (realdn) {
-		doutc(cl, "dn %p (%d) spliced with %p (%d) inode %p ino %llx.%llx\n",
+		boutc(cl, "dn %p (%d) spliced with %p (%d) inode %p ino %llx.%llx\n",
 		      dn, d_count(dn), realdn, d_count(realdn),
 		      d_inode(realdn), ceph_vinop(d_inode(realdn)));
 		dput(dn);
 		*pdn = realdn;
 	} else {
 		BUG_ON(!ceph_dentry(dn));
-		doutc(cl, "dn %p attached to %p ino %llx.%llx\n", dn,
+		boutc(cl, "dn %p attached to %p ino %llx.%llx\n", dn,
 		      d_inode(dn), ceph_vinop(d_inode(dn)));
 	}
 	return 0;
@@ -1573,11 +1573,11 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 	struct inode *parent_dir = NULL;
 	int err = 0;
 
-	doutc(cl, "%p is_dentry %d is_target %d\n", req,
+	boutc(cl, "%p is_dentry %d is_target %d\n", req,
 	      rinfo->head->is_dentry, rinfo->head->is_target);
 
 	if (!rinfo->head->is_target && !rinfo->head->is_dentry) {
-		doutc(cl, "reply is empty!\n");
+		boutc(cl, "reply is empty!\n");
 		if (rinfo->head->result == 0 && req->r_parent)
 			ceph_invalidate_dir_request(req);
 		return 0;
@@ -1641,12 +1641,12 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
 retry_lookup:
 			dn = d_lookup(parent, &dname);
-			doutc(cl, "d_lookup on parent=%p name=%.*s got %p\n",
+			boutc(cl, "d_lookup on parent=%p name=%.*s got %p\n",
 			      parent, dname.len, dname.name, dn);
 
 			if (!dn) {
 				dn = d_alloc(parent, &dname);
-				doutc(cl, "d_alloc %p '%.*s' = %p\n", parent,
+				boutc(cl, "d_alloc %p '%.*s' = %p\n", parent,
 				      dname.len, dname.name, dn);
 				if (!dn) {
 					dput(parent);
@@ -1663,7 +1663,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			} else if (d_really_is_positive(dn) &&
 				   (ceph_ino(d_inode(dn)) != tvino.ino ||
 				    ceph_snap(d_inode(dn)) != tvino.snap)) {
-				doutc(cl, " dn %p points to wrong inode %p\n",
+				boutc(cl, " dn %p points to wrong inode %p\n",
 				      dn, d_inode(dn));
 				ceph_dir_clear_ordered(parent_dir);
 				d_delete(dn);
@@ -1740,30 +1740,30 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		have_lease = have_dir_cap ||
 			le32_to_cpu(rinfo->dlease->duration_ms);
 		if (!have_lease)
-			doutc(cl, "no dentry lease or dir cap\n");
+			boutc(cl, "no dentry lease or dir cap\n");
 
 		/* rename? */
 		if (req->r_old_dentry && req->r_op == CEPH_MDS_OP_RENAME) {
 			struct inode *olddir = req->r_old_dentry_dir;
 			BUG_ON(!olddir);
 
-			doutc(cl, " src %p '%pd' dst %p '%pd'\n",
+			boutc(cl, " src %p '%pd' dst %p '%pd'\n",
 			      req->r_old_dentry, req->r_old_dentry, dn, dn);
-			doutc(cl, "doing d_move %p -> %p\n", req->r_old_dentry, dn);
+			boutc(cl, "doing d_move %p -> %p\n", req->r_old_dentry, dn);
 
 			/* d_move screws up sibling dentries' offsets */
 			ceph_dir_clear_ordered(dir);
 			ceph_dir_clear_ordered(olddir);
 
 			d_move(req->r_old_dentry, dn);
-			doutc(cl, " src %p '%pd' dst %p '%pd'\n",
+			boutc(cl, " src %p '%pd' dst %p '%pd'\n",
 			      req->r_old_dentry, req->r_old_dentry, dn, dn);
 
 			/* ensure target dentry is invalidated, despite
 			   rehashing bug in vfs_rename_dir */
 			ceph_invalidate_dentry_lease(dn);
 
-			doutc(cl, "dn %p gets new offset %lld\n",
+			boutc(cl, "dn %p gets new offset %lld\n",
 			      req->r_old_dentry,
 			      ceph_dentry(req->r_old_dentry)->offset);
 
@@ -1777,9 +1777,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 
 		/* null dentry? */
 		if (!rinfo->head->is_target) {
-			doutc(cl, "null dentry\n");
+			boutc(cl, "null dentry\n");
 			if (d_really_is_positive(dn)) {
-				doutc(cl, "d_delete %p\n", dn);
+				boutc(cl, "d_delete %p\n", dn);
 				ceph_dir_clear_ordered(dir);
 				d_delete(dn);
 			} else if (have_lease) {
@@ -1808,7 +1808,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				goto done;
 			dn = req->r_dentry;  /* may have spliced */
 		} else if (d_really_is_positive(dn) && d_inode(dn) != in) {
-			doutc(cl, " %p links to %p %llx.%llx, not %llx.%llx\n",
+			boutc(cl, " %p links to %p %llx.%llx, not %llx.%llx\n",
 			      dn, d_inode(dn), ceph_vinop(d_inode(dn)),
 			      ceph_vinop(in));
 			d_invalidate(dn);
@@ -1820,7 +1820,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 					    rinfo->dlease, session,
 					    req->r_request_started);
 		}
-		doutc(cl, " final dn %p\n", dn);
+		boutc(cl, " final dn %p\n", dn);
 	} else if ((req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
 		    req->r_op == CEPH_MDS_OP_MKSNAP) &&
 	           test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags) &&
@@ -1831,7 +1831,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		BUG_ON(!dir);
 		BUG_ON(ceph_snap(dir) != CEPH_SNAPDIR);
 		BUG_ON(!req->r_dentry);
-		doutc(cl, " linking snapped dir %p to dn %p\n", in,
+		boutc(cl, " linking snapped dir %p to dn %p\n", in,
 		      req->r_dentry);
 		ceph_dir_clear_ordered(dir);
 
@@ -1863,7 +1863,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 	/* Drop extra ref from ceph_get_reply_dir() if it returned a new inode */
 	if (unlikely(!IS_ERR_OR_NULL(parent_dir) && parent_dir != req->r_parent))
 		iput(parent_dir);
-	doutc(cl, "done err=%d\n", err);
+	boutc(cl, "done err=%d\n", err);
 	return err;
 }
 
@@ -1889,7 +1889,7 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
 		in = ceph_get_inode(req->r_dentry->d_sb, vino, NULL);
 		if (IS_ERR(in)) {
 			err = PTR_ERR(in);
-			doutc(cl, "badness got %d\n", err);
+			boutc(cl, "badness got %d\n", err);
 			continue;
 		}
 		rc = ceph_fill_inode(in, NULL, &rde->inode, NULL, session,
@@ -1956,11 +1956,11 @@ static int fill_readdir_cache(struct inode *dir, struct dentry *dn,
 
 	if (req->r_dir_release_cnt == atomic64_read(&ci->i_release_count) &&
 	    req->r_dir_ordered_cnt == atomic64_read(&ci->i_ordered_count)) {
-		doutc(cl, "dn %p idx %d\n", dn, ctl->index);
+		boutc(cl, "dn %p idx %d\n", dn, ctl->index);
 		ctl->dentries[idx] = dn;
 		ctl->index++;
 	} else {
-		doutc(cl, "disable readdir cache\n");
+		boutc(cl, "disable readdir cache\n");
 		ctl->index = -1;
 	}
 	return 0;
@@ -2001,7 +2001,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 
 	if (rinfo->dir_dir &&
 	    le32_to_cpu(rinfo->dir_dir->frag) != frag) {
-		doutc(cl, "got new frag %x -> %x\n", frag,
+		boutc(cl, "got new frag %x -> %x\n", frag,
 			    le32_to_cpu(rinfo->dir_dir->frag));
 		frag = le32_to_cpu(rinfo->dir_dir->frag);
 		if (!rinfo->hash_order)
@@ -2009,10 +2009,10 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 	}
 
 	if (le32_to_cpu(rinfo->head->op) == CEPH_MDS_OP_LSSNAP) {
-		doutc(cl, "%d items under SNAPDIR dn %p\n",
+		boutc(cl, "%d items under SNAPDIR dn %p\n",
 		      rinfo->dir_nr, parent);
 	} else {
-		doutc(cl, "%d items under dn %p\n", rinfo->dir_nr, parent);
+		boutc(cl, "%d items under dn %p\n", rinfo->dir_nr, parent);
 		if (rinfo->dir_dir)
 			ceph_fill_dirfrag(d_inode(parent), rinfo->dir_dir);
 
@@ -2056,15 +2056,15 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 
 retry_lookup:
 		dn = d_lookup(parent, &dname);
-		doutc(cl, "d_lookup on parent=%p name=%.*s got %p\n",
+		boutc(cl, "d_lookup on parent=%p name=%.*s got %p\n",
 		      parent, dname.len, dname.name, dn);
 
 		if (!dn) {
 			dn = d_alloc(parent, &dname);
-			doutc(cl, "d_alloc %p '%.*s' = %p\n", parent,
+			boutc(cl, "d_alloc %p '%.*s' = %p\n", parent,
 			      dname.len, dname.name, dn);
 			if (!dn) {
-				doutc(cl, "d_alloc badness\n");
+				boutc(cl, "d_alloc badness\n");
 				err = -ENOMEM;
 				goto out;
 			}
@@ -2077,7 +2077,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			   (ceph_ino(d_inode(dn)) != tvino.ino ||
 			    ceph_snap(d_inode(dn)) != tvino.snap)) {
 			struct ceph_dentry_info *di = ceph_dentry(dn);
-			doutc(cl, " dn %p points to wrong inode %p\n",
+			boutc(cl, " dn %p points to wrong inode %p\n",
 			      dn, d_inode(dn));
 
 			spin_lock(&dn->d_lock);
@@ -2100,7 +2100,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		} else {
 			in = ceph_get_inode(parent->d_sb, tvino, NULL);
 			if (IS_ERR(in)) {
-				doutc(cl, "new_inode badness\n");
+				boutc(cl, "new_inode badness\n");
 				d_drop(dn);
 				dput(dn);
 				err = PTR_ERR(in);
@@ -2129,7 +2129,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 
 		if (d_really_is_negative(dn)) {
 			if (ceph_security_xattr_deadlock(in)) {
-				doutc(cl, " skip splicing dn %p to inode %p"
+				boutc(cl, " skip splicing dn %p to inode %p"
 				      " (security xattr deadlock)\n", dn, in);
 				iput(in);
 				skipped++;
@@ -2162,7 +2162,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		req->r_readdir_cache_idx = cache_ctl.index;
 	}
 	ceph_readdir_cache_release(&cache_ctl);
-	doutc(cl, "done\n");
+	boutc(cl, "done\n");
 	return err;
 }
 
@@ -2173,7 +2173,7 @@ bool ceph_inode_set_size(struct inode *inode, loff_t size)
 	bool ret;
 
 	spin_lock(&ci->i_ceph_lock);
-	doutc(cl, "set_size %p %llu -> %llu\n", inode, i_size_read(inode), size);
+	boutc(cl, "set_size %p %llu -> %llu\n", inode, i_size_read(inode), size);
 	i_size_write(inode, size);
 	ceph_fscache_update(inode);
 	inode->i_blocks = calc_inode_blocks(size);
@@ -2194,10 +2194,10 @@ void ceph_queue_inode_work(struct inode *inode, int work_bit)
 
 	ihold(inode);
 	if (queue_work(fsc->inode_wq, &ci->i_work)) {
-		doutc(cl, "%p %llx.%llx mask=%lx\n", inode,
+		boutc(cl, "%p %llx.%llx mask=%lx\n", inode,
 		      ceph_vinop(inode), ci->i_work_mask);
 	} else {
-		doutc(cl, "%p %llx.%llx already queued, mask=%lx\n",
+		boutc(cl, "%p %llx.%llx already queued, mask=%lx\n",
 		      inode, ceph_vinop(inode), ci->i_work_mask);
 		iput(inode);
 	}
@@ -2225,7 +2225,7 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	}
 
 	spin_lock(&ci->i_ceph_lock);
-	doutc(cl, "%p %llx.%llx gen %d revoking %d\n", inode,
+	boutc(cl, "%p %llx.%llx gen %d revoking %d\n", inode,
 	      ceph_vinop(inode), ci->i_rdcache_gen, ci->i_rdcache_revoking);
 	if (ci->i_rdcache_revoking != ci->i_rdcache_gen) {
 		if (__ceph_caps_revoking_other(ci, NULL, CEPH_CAP_FILE_CACHE))
@@ -2245,12 +2245,12 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	spin_lock(&ci->i_ceph_lock);
 	if (orig_gen == ci->i_rdcache_gen &&
 	    orig_gen == ci->i_rdcache_revoking) {
-		doutc(cl, "%p %llx.%llx gen %d successful\n", inode,
+		boutc(cl, "%p %llx.%llx gen %d successful\n", inode,
 		      ceph_vinop(inode), ci->i_rdcache_gen);
 		ci->i_rdcache_revoking--;
 		check = 1;
 	} else {
-		doutc(cl, "%p %llx.%llx gen %d raced, now %d revoking %d\n",
+		boutc(cl, "%p %llx.%llx gen %d raced, now %d revoking %d\n",
 		      inode, ceph_vinop(inode), orig_gen, ci->i_rdcache_gen,
 		      ci->i_rdcache_revoking);
 		if (__ceph_caps_revoking_other(ci, NULL, CEPH_CAP_FILE_CACHE))
@@ -2278,7 +2278,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 retry:
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_truncate_pending == 0) {
-		doutc(cl, "%p %llx.%llx none pending\n", inode,
+		boutc(cl, "%p %llx.%llx none pending\n", inode,
 		      ceph_vinop(inode));
 		spin_unlock(&ci->i_ceph_lock);
 		mutex_unlock(&ci->i_truncate_mutex);
@@ -2291,7 +2291,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	 */
 	if (ci->i_wrbuffer_ref_head < ci->i_wrbuffer_ref) {
 		spin_unlock(&ci->i_ceph_lock);
-		doutc(cl, "%p %llx.%llx flushing snaps first\n", inode,
+		boutc(cl, "%p %llx.%llx flushing snaps first\n", inode,
 		      ceph_vinop(inode));
 		filemap_write_and_wait_range(&inode->i_data, 0,
 					     inode->i_sb->s_maxbytes);
@@ -2303,7 +2303,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 
 	to = ci->i_truncate_pagecache_size;
 	wrbuffer_refs = ci->i_wrbuffer_ref;
-	doutc(cl, "%p %llx.%llx (%d) to %lld\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p %llx.%llx (%d) to %lld\n", inode, ceph_vinop(inode),
 	      ci->i_truncate_pending, to);
 	spin_unlock(&ci->i_ceph_lock);
 
@@ -2335,7 +2335,7 @@ static void ceph_inode_work(struct work_struct *work)
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 
 	if (test_and_clear_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask)) {
-		doutc(cl, "writeback %p %llx.%llx\n", inode, ceph_vinop(inode));
+		boutc(cl, "writeback %p %llx.%llx\n", inode, ceph_vinop(inode));
 		filemap_fdatawrite(&inode->i_data);
 	}
 	if (test_and_clear_bit(CEPH_I_WORK_INVALIDATE_PAGES, &ci->i_work_mask))
@@ -2430,7 +2430,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 
 	issued = __ceph_caps_issued(ci, NULL);
 
-	doutc(cl, "size %lld -> %lld got cap refs on %s, issued %s\n",
+	boutc(cl, "size %lld -> %lld got cap refs on %s, issued %s\n",
 	      i_size, attr->ia_size, ceph_cap_string(got),
 	      ceph_cap_string(issued));
 
@@ -2487,7 +2487,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 	 * If the Rados object doesn't exist, it will be set to 0.
 	 */
 	if (!objver) {
-		doutc(cl, "hit hole, ppos %lld < size %lld\n", pos, i_size);
+		boutc(cl, "hit hole, ppos %lld < size %lld\n", pos, i_size);
 
 		header.data_len = cpu_to_le32(8 + 8 + 4);
 		header.file_offset = 0;
@@ -2496,7 +2496,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
 		header.file_offset = cpu_to_le64(orig_pos);
 
-		doutc(cl, "encrypt block boff/bsize %d/%lu\n", boff,
+		boutc(cl, "encrypt block boff/bsize %d/%lu\n", boff,
 		      CEPH_FSCRYPT_BLOCK_SIZE);
 
 		/* truncate and zero out the extra contents for the last block */
@@ -2524,7 +2524,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 	}
 	req->r_pagelist = pagelist;
 out:
-	doutc(cl, "%p %llx.%llx size dropping cap refs on %s\n", inode,
+	boutc(cl, "%p %llx.%llx size dropping cap refs on %s\n", inode,
 	      ceph_vinop(inode), ceph_cap_string(got));
 	ceph_put_cap_refs(ci, got);
 	if (iov.iov_base)
@@ -2609,7 +2609,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		}
 	}
 
-	doutc(cl, "%p %llx.%llx issued %s\n", inode, ceph_vinop(inode),
+	boutc(cl, "%p %llx.%llx issued %s\n", inode, ceph_vinop(inode),
 	      ceph_cap_string(issued));
 #if IS_ENABLED(CONFIG_FS_ENCRYPTION)
 	if (cia && cia->fscrypt_auth) {
@@ -2621,7 +2621,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 			goto out;
 		}
 
-		doutc(cl, "%p %llx.%llx fscrypt_auth len %u to %u)\n", inode,
+		boutc(cl, "%p %llx.%llx fscrypt_auth len %u to %u)\n", inode,
 		      ceph_vinop(inode), ci->fscrypt_auth_len, len);
 
 		/* It should never be re-set once set */
@@ -2652,7 +2652,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	if (ia_valid & ATTR_UID) {
 		kuid_t fsuid = from_vfsuid(idmap, i_user_ns(inode), attr->ia_vfsuid);
 
-		doutc(cl, "%p %llx.%llx uid %d -> %d\n", inode,
+		boutc(cl, "%p %llx.%llx uid %d -> %d\n", inode,
 		      ceph_vinop(inode),
 		      from_kuid(&init_user_ns, inode->i_uid),
 		      from_kuid(&init_user_ns, attr->ia_uid));
@@ -2670,7 +2670,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	if (ia_valid & ATTR_GID) {
 		kgid_t fsgid = from_vfsgid(idmap, i_user_ns(inode), attr->ia_vfsgid);
 
-		doutc(cl, "%p %llx.%llx gid %d -> %d\n", inode,
+		boutc(cl, "%p %llx.%llx gid %d -> %d\n", inode,
 		      ceph_vinop(inode),
 		      from_kgid(&init_user_ns, inode->i_gid),
 		      from_kgid(&init_user_ns, attr->ia_gid));
@@ -2686,7 +2686,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		}
 	}
 	if (ia_valid & ATTR_MODE) {
-		doutc(cl, "%p %llx.%llx mode 0%o -> 0%o\n", inode,
+		boutc(cl, "%p %llx.%llx mode 0%o -> 0%o\n", inode,
 		      ceph_vinop(inode), inode->i_mode, attr->ia_mode);
 		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_mode = attr->ia_mode;
@@ -2703,7 +2703,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	if (ia_valid & ATTR_ATIME) {
 		struct timespec64 atime = inode_get_atime(inode);
 
-		doutc(cl, "%p %llx.%llx atime %lld.%09ld -> %lld.%09ld\n",
+		boutc(cl, "%p %llx.%llx atime %lld.%09ld -> %lld.%09ld\n",
 		      inode, ceph_vinop(inode),
 		      atime.tv_sec, atime.tv_nsec,
 		      attr->ia_atime.tv_sec, attr->ia_atime.tv_nsec);
@@ -2726,7 +2726,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		}
 	}
 	if (ia_valid & ATTR_SIZE) {
-		doutc(cl, "%p %llx.%llx size %lld -> %lld\n", inode,
+		boutc(cl, "%p %llx.%llx size %lld -> %lld\n", inode,
 		      ceph_vinop(inode), isize, attr->ia_size);
 		/*
 		 * Only when the new size is smaller and not aligned to
@@ -2780,7 +2780,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	if (ia_valid & ATTR_MTIME) {
 		struct timespec64 mtime = inode_get_mtime(inode);
 
-		doutc(cl, "%p %llx.%llx mtime %lld.%09ld -> %lld.%09ld\n",
+		boutc(cl, "%p %llx.%llx mtime %lld.%09ld -> %lld.%09ld\n",
 		      inode, ceph_vinop(inode),
 		      mtime.tv_sec, mtime.tv_nsec,
 		      attr->ia_mtime.tv_sec, attr->ia_mtime.tv_nsec);
@@ -2806,7 +2806,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	if (ia_valid & ATTR_CTIME) {
 		bool only = (ia_valid & (ATTR_SIZE|ATTR_MTIME|ATTR_ATIME|
 					 ATTR_MODE|ATTR_UID|ATTR_GID)) == 0;
-		doutc(cl, "%p %llx.%llx ctime %lld.%09ld -> %lld.%09ld (%s)\n",
+		boutc(cl, "%p %llx.%llx ctime %lld.%09ld -> %lld.%09ld (%s)\n",
 		      inode, ceph_vinop(inode),
 		      inode_get_ctime_sec(inode),
 		      inode_get_ctime_nsec(inode),
@@ -2829,7 +2829,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		}
 	}
 	if (ia_valid & ATTR_FILE)
-		doutc(cl, "%p %llx.%llx ATTR_FILE ... hrm!\n", inode,
+		boutc(cl, "%p %llx.%llx ATTR_FILE ... hrm!\n", inode,
 		      ceph_vinop(inode));
 
 	if (dirtied) {
@@ -2871,7 +2871,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		 */
 		err = ceph_mdsc_do_request(mdsc, NULL, req);
 		if (err == -EAGAIN && truncate_retry--) {
-			doutc(cl, "%p %llx.%llx result=%d (%s locally, %d remote), retry it!\n",
+			boutc(cl, "%p %llx.%llx result=%d (%s locally, %d remote), retry it!\n",
 			      inode, ceph_vinop(inode), err,
 			      ceph_cap_string(dirtied), mask);
 			ceph_mdsc_put_request(req);
@@ -2880,7 +2880,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		}
 	}
 out:
-	doutc(cl, "%p %llx.%llx result=%d (%s locally, %d remote)\n", inode,
+	boutc(cl, "%p %llx.%llx result=%d (%s locally, %d remote)\n", inode,
 	      ceph_vinop(inode), err, ceph_cap_string(dirtied), mask);
 
 	ceph_mdsc_put_request(req);
@@ -2977,12 +2977,12 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 	int err;
 
 	if (ceph_snap(inode) == CEPH_SNAPDIR) {
-		doutc(cl, "inode %p %llx.%llx SNAPDIR\n", inode,
+		boutc(cl, "inode %p %llx.%llx SNAPDIR\n", inode,
 		      ceph_vinop(inode));
 		return 0;
 	}
 
-	doutc(cl, "inode %p %llx.%llx mask %s mode 0%o\n", inode,
+	boutc(cl, "inode %p %llx.%llx mask %s mode 0%o\n", inode,
 	      ceph_vinop(inode), ceph_cap_string(mask), inode->i_mode);
 	if (!force && ceph_caps_issued_mask_metric(ceph_inode(inode), mask, 1))
 			return 0;
@@ -3010,7 +3010,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 		}
 	}
 	ceph_mdsc_put_request(req);
-	doutc(cl, "result=%d\n", err);
+	boutc(cl, "result=%d\n", err);
 	return err;
 }
 
@@ -3048,7 +3048,7 @@ int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
 	xattr_value = req->r_reply_info.xattr_info.xattr_value;
 	xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
 
-	doutc(cl, "xattr_value_len:%zu, size:%zu\n", xattr_value_len, size);
+	boutc(cl, "xattr_value_len:%zu, size:%zu\n", xattr_value_len, size);
 
 	err = (int)xattr_value_len;
 	if (size == 0)
@@ -3063,7 +3063,7 @@ int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
 put:
 	ceph_mdsc_put_request(req);
 out:
-	doutc(cl, "result=%d\n", err);
+	boutc(cl, "result=%d\n", err);
 	return err;
 }
 
diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 15cde055f3da..456600f6f34f 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -259,10 +259,10 @@ static long ceph_ioctl_lazyio(struct file *file)
 	spin_unlock(&ci->i_ceph_lock);
 
 	if (is_file_already_lazy) {
-		doutc(cl, "file %p %p %llx.%llx already lazy\n", file, inode,
+		boutc(cl, "file %p %p %llx.%llx already lazy\n", file, inode,
 		      ceph_vinop(inode));
 	} else {
-		doutc(cl, "file %p %p %llx.%llx marked lazy\n", file, inode,
+		boutc(cl, "file %p %p %llx.%llx marked lazy\n", file, inode,
 		      ceph_vinop(inode));
 
 		ceph_check_caps(ci, 0);
@@ -369,7 +369,7 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
 	int ret;
 
-	doutc(fsc->client, "file %p %p %llx.%llx cmd %s arg %lu\n", file,
+	boutc(fsc->client, "file %p %p %llx.%llx cmd %s arg %lu\n", file,
 	      inode, ceph_vinop(inode), ceph_ioctl_cmd_name(cmd), arg);
 	switch (cmd) {
 	case CEPH_IOC_GET_LAYOUT:
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index dd764f9c64b9..7ac7748d820a 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -112,7 +112,7 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
 
 	owner = secure_addr(fl->c.flc_owner);
 
-	doutc(cl, "rule: %d, op: %d, owner: %llx, pid: %llu, "
+	boutc(cl, "rule: %d, op: %d, owner: %llx, pid: %llu, "
 		    "start: %llu, length: %llu, wait: %d, type: %d\n",
 		    (int)lock_type, (int)operation, owner,
 		    (u64) fl->c.flc_pid,
@@ -149,7 +149,7 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
 
 	}
 	ceph_mdsc_put_request(req);
-	doutc(cl, "rule: %d, op: %d, pid: %llu, start: %llu, "
+	boutc(cl, "rule: %d, op: %d, pid: %llu, start: %llu, "
 	      "length: %llu, wait: %d, type: %d, err code %d\n",
 	      (int)lock_type, (int)operation, (u64) fl->c.flc_pid,
 	      fl->fl_start, length, wait, fl->c.flc_type, err);
@@ -177,7 +177,7 @@ static int ceph_lock_wait_for_completion(struct ceph_mds_client *mdsc,
 	if (!err)
 		return 0;
 
-	doutc(cl, "request %llu was interrupted\n", req->r_tid);
+	boutc(cl, "request %llu was interrupted\n", req->r_tid);
 
 	mutex_lock(&mdsc->mutex);
 	if (test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
@@ -263,7 +263,7 @@ int ceph_lock(struct file *file, int cmd, struct file_lock *fl)
 	if (ceph_inode_is_shutdown(inode))
 		return -ESTALE;
 
-	doutc(cl, "fl_owner: %p\n", fl->c.flc_owner);
+	boutc(cl, "fl_owner: %p\n", fl->c.flc_owner);
 
 	/* set wait bit as appropriate, then make command as Ceph expects it*/
 	if (IS_GETLK(cmd))
@@ -298,7 +298,7 @@ int ceph_lock(struct file *file, int cmd, struct file_lock *fl)
 	err = ceph_lock_message(CEPH_LOCK_FCNTL, op, inode, lock_cmd, wait, fl);
 	if (!err) {
 		if (op == CEPH_MDS_OP_SETFILELOCK && F_UNLCK != fl->c.flc_type) {
-			doutc(cl, "locking locally\n");
+			boutc(cl, "locking locally\n");
 			err = posix_lock_file(file, fl, NULL);
 			if (err) {
 				/* undo! This should only happen if
@@ -306,7 +306,7 @@ int ceph_lock(struct file *file, int cmd, struct file_lock *fl)
 				 * deadlock. */
 				ceph_lock_message(CEPH_LOCK_FCNTL, op, inode,
 						  CEPH_LOCK_UNLOCK, 0, fl);
-				doutc(cl, "got %d on posix_lock_file, undid lock\n",
+				boutc(cl, "got %d on posix_lock_file, undid lock\n",
 				      err);
 			}
 		}
@@ -329,7 +329,7 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
 	if (ceph_inode_is_shutdown(inode))
 		return -ESTALE;
 
-	doutc(cl, "fl_file: %p\n", fl->c.flc_file);
+	boutc(cl, "fl_file: %p\n", fl->c.flc_file);
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) {
@@ -366,7 +366,7 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
 			ceph_lock_message(CEPH_LOCK_FLOCK,
 					  CEPH_MDS_OP_SETFILELOCK,
 					  inode, CEPH_LOCK_UNLOCK, 0, fl);
-			doutc(cl, "got %d on locks_lock_file_wait, undid lock\n",
+			boutc(cl, "got %d on locks_lock_file_wait, undid lock\n",
 			      err);
 		}
 	}
@@ -395,7 +395,7 @@ void ceph_count_locks(struct inode *inode, int *fcntl_count, int *flock_count)
 			++(*flock_count);
 		spin_unlock(&ctx->flc_lock);
 	}
-	doutc(cl, "counted %d flock locks and %d fcntl locks\n",
+	boutc(cl, "counted %d flock locks and %d fcntl locks\n",
 	      *flock_count, *fcntl_count);
 }
 
@@ -426,7 +426,7 @@ static int lock_to_ceph_filelock(struct inode *inode,
 		cephlock->type = CEPH_LOCK_UNLOCK;
 		break;
 	default:
-		doutc(cl, "Have unknown lock type %d\n",
+		boutc(cl, "Have unknown lock type %d\n",
 		      lock->c.flc_type);
 		err = -EINVAL;
 	}
@@ -451,7 +451,7 @@ int ceph_encode_locks_to_buffer(struct inode *inode,
 	int seen_flock = 0;
 	int l = 0;
 
-	doutc(cl, "encoding %d flock and %d fcntl locks\n", num_flock_locks,
+	boutc(cl, "encoding %d flock and %d fcntl locks\n", num_flock_locks,
 	      num_fcntl_locks);
 
 	if (!ctx)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1740047aef0f..53084c7ca034 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -456,7 +456,7 @@ static int parse_reply_info_readdir(void **p, void *end,
 		ceph_decode_need(p, end, _name_len, bad);
 		_name = *p;
 		*p += _name_len;
-		doutc(cl, "parsed dir dname '%.*s'\n", _name_len, _name);
+		boutc(cl, "parsed dir dname '%.*s'\n", _name_len, _name);
 
 		if (info->hash_order)
 			rde->raw_hash = ceph_str_hash(ci->i_dir_layout.dl_dir_hash,
@@ -576,7 +576,7 @@ static int ceph_parse_deleg_inos(void **p, void *end,
 	u32 sets;
 
 	ceph_decode_32_safe(p, end, sets, bad);
-	doutc(cl, "got %u sets of delegated inodes\n", sets);
+	boutc(cl, "got %u sets of delegated inodes\n", sets);
 	while (sets--) {
 		u64 start, len;
 
@@ -595,7 +595,7 @@ static int ceph_parse_deleg_inos(void **p, void *end,
 					    DELEGATED_INO_AVAILABLE,
 					    GFP_KERNEL);
 			if (!err) {
-				doutc(cl, "added delegated inode 0x%llx\n", start - 1);
+				boutc(cl, "added delegated inode 0x%llx\n", start - 1);
 			} else if (err == -EBUSY) {
 				pr_warn_client(cl,
 					"MDS delegated inode 0x%llx more than once.\n",
@@ -878,7 +878,7 @@ int ceph_wait_on_conflict_unlink(struct dentry *dentry)
 	if (likely(!found))
 		return 0;
 
-	doutc(cl, "dentry %p:%pd conflict with old %p:%pd\n", dentry, dentry,
+	boutc(cl, "dentry %p:%pd conflict with old %p:%pd\n", dentry, dentry,
 	      found, found);
 
 	err = wait_on_bit(&di->flags, CEPH_DENTRY_ASYNC_UNLINK_BIT,
@@ -981,7 +981,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 		struct ceph_mds_session **sa;
 		size_t ptr_size = sizeof(struct ceph_mds_session *);
 
-		doutc(cl, "realloc to %d\n", newmax);
+		boutc(cl, "realloc to %d\n", newmax);
 		sa = kcalloc(newmax, ptr_size, GFP_NOFS);
 		if (!sa)
 			goto fail_realloc;
@@ -994,7 +994,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 		mdsc->max_sessions = newmax;
 	}
 
-	doutc(cl, "mds%d\n", mds);
+	boutc(cl, "mds%d\n", mds);
 	s->s_mdsc = mdsc;
 	s->s_mds = mds;
 	s->s_state = CEPH_MDS_SESSION_NEW;
@@ -1037,7 +1037,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 static void __unregister_session(struct ceph_mds_client *mdsc,
 			       struct ceph_mds_session *s)
 {
-	doutc(mdsc->fsc->client, "mds%d %p\n", s->s_mds, s);
+	boutc(mdsc->fsc->client, "mds%d %p\n", s->s_mds, s);
 	BUG_ON(mdsc->sessions[s->s_mds] != s);
 	mdsc->sessions[s->s_mds] = NULL;
 	ceph_con_close(&s->s_con);
@@ -1180,7 +1180,7 @@ static void __register_request(struct ceph_mds_client *mdsc,
 			return;
 		}
 	}
-	doutc(cl, "%p tid %lld\n", req, req->r_tid);
+	boutc(cl, "%p tid %lld\n", req, req->r_tid);
 	ceph_mdsc_get_request(req);
 	insert_request(&mdsc->request_tree, req);
 
@@ -1205,7 +1205,7 @@ static void __register_request(struct ceph_mds_client *mdsc,
 static void __unregister_request(struct ceph_mds_client *mdsc,
 				 struct ceph_mds_request *req)
 {
-	doutc(mdsc->fsc->client, "%p tid %lld\n", req, req->r_tid);
+	boutc(mdsc->fsc->client, "%p tid %lld\n", req, req->r_tid);
 
 	/* Never leave an unregistered request on an unsafe list! */
 	list_del_init(&req->r_unsafe_item);
@@ -1303,7 +1303,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 	if (req->r_resend_mds >= 0 &&
 	    (__have_session(mdsc, req->r_resend_mds) ||
 	     ceph_mdsmap_get_state(mdsc->mdsmap, req->r_resend_mds) > 0)) {
-		doutc(cl, "using resend_mds mds%d\n", req->r_resend_mds);
+		boutc(cl, "using resend_mds mds%d\n", req->r_resend_mds);
 		return req->r_resend_mds;
 	}
 
@@ -1320,7 +1320,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 			rcu_read_lock();
 			inode = get_nonsnap_parent(req->r_dentry);
 			rcu_read_unlock();
-			doutc(cl, "using snapdir's parent %p %llx.%llx\n",
+			boutc(cl, "using snapdir's parent %p %llx.%llx\n",
 			      inode, ceph_vinop(inode));
 		}
 	} else if (req->r_dentry) {
@@ -1341,7 +1341,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 			/* direct snapped/virtual snapdir requests
 			 * based on parent dir inode */
 			inode = get_nonsnap_parent(parent);
-			doutc(cl, "using nonsnap parent %p %llx.%llx\n",
+			boutc(cl, "using nonsnap parent %p %llx.%llx\n",
 			      inode, ceph_vinop(inode));
 		} else {
 			/* dentry target */
@@ -1361,7 +1361,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 	if (!inode)
 		goto random;
 
-	doutc(cl, "%p %llx.%llx is_hash=%d (0x%x) mode %d\n", inode,
+	boutc(cl, "%p %llx.%llx is_hash=%d (0x%x) mode %d\n", inode,
 	      ceph_vinop(inode), (int)is_hash, hash, mode);
 	ci = ceph_inode(inode);
 
@@ -1378,7 +1378,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 				get_random_bytes(&r, 1);
 				r %= frag.ndist;
 				mds = frag.dist[r];
-				doutc(cl, "%p %llx.%llx frag %u mds%d (%d/%d)\n",
+				boutc(cl, "%p %llx.%llx frag %u mds%d (%d/%d)\n",
 				      inode, ceph_vinop(inode), frag.frag,
 				      mds, (int)r, frag.ndist);
 				if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=
@@ -1393,7 +1393,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 			if (frag.mds >= 0) {
 				/* choose auth mds */
 				mds = frag.mds;
-				doutc(cl, "%p %llx.%llx frag %u mds%d (auth)\n",
+				boutc(cl, "%p %llx.%llx frag %u mds%d (auth)\n",
 				      inode, ceph_vinop(inode), frag.frag, mds);
 				if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=
 				    CEPH_MDS_STATE_ACTIVE) {
@@ -1418,7 +1418,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 		goto random;
 	}
 	mds = cap->session->s_mds;
-	doutc(cl, "%p %llx.%llx mds%d (%scap %p)\n", inode,
+	boutc(cl, "%p %llx.%llx mds%d (%scap %p)\n", inode,
 	      ceph_vinop(inode), mds,
 	      cap == ci->i_auth_cap ? "auth " : "", cap);
 	spin_unlock(&ci->i_ceph_lock);
@@ -1431,7 +1431,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 		*random = true;
 
 	mds = ceph_mdsmap_get_random_mds(mdsc->mdsmap);
-	doutc(cl, "chose random mds%d\n", mds);
+	boutc(cl, "chose random mds%d\n", mds);
 	return mds;
 }
 
@@ -1671,7 +1671,7 @@ static int __open_session(struct ceph_mds_client *mdsc,
 
 	/* wait for mds to go active? */
 	mstate = ceph_mdsmap_get_state(mdsc->mdsmap, mds);
-	doutc(mdsc->fsc->client, "open_session to mds%d (%s)\n", mds,
+	boutc(mdsc->fsc->client, "open_session to mds%d (%s)\n", mds,
 	      ceph_mds_state_name(mstate));
 	session->s_state = CEPH_MDS_SESSION_OPENING;
 	session->s_renew_requested = jiffies;
@@ -1718,7 +1718,7 @@ ceph_mdsc_open_export_target_session(struct ceph_mds_client *mdsc, int target)
 	struct ceph_mds_session *session;
 	struct ceph_client *cl = mdsc->fsc->client;
 
-	doutc(cl, "to mds%d\n", target);
+	boutc(cl, "to mds%d\n", target);
 
 	mutex_lock(&mdsc->mutex);
 	session = __open_export_target_session(mdsc, target);
@@ -1739,7 +1739,7 @@ static void __open_export_target_sessions(struct ceph_mds_client *mdsc,
 		return;
 
 	mi = &mdsc->mdsmap->m_info[mds];
-	doutc(cl, "for mds%d (%d targets)\n", session->s_mds,
+	boutc(cl, "for mds%d (%d targets)\n", session->s_mds,
 	      mi->num_export_targets);
 
 	for (i = 0; i < mi->num_export_targets; i++) {
@@ -1761,7 +1761,7 @@ static void detach_cap_releases(struct ceph_mds_session *session,
 
 	list_splice_init(&session->s_cap_releases, target);
 	session->s_num_cap_releases = 0;
-	doutc(cl, "mds%d\n", session->s_mds);
+	boutc(cl, "mds%d\n", session->s_mds);
 }
 
 static void dispose_cap_releases(struct ceph_mds_client *mdsc,
@@ -1783,7 +1783,7 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 	struct ceph_mds_request *req;
 	struct rb_node *p;
 
-	doutc(cl, "mds%d\n", session->s_mds);
+	boutc(cl, "mds%d\n", session->s_mds);
 	mutex_lock(&mdsc->mutex);
 	while (!list_empty(&session->s_unsafe)) {
 		req = list_first_entry(&session->s_unsafe,
@@ -1825,7 +1825,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	struct ceph_cap *old_cap = NULL;
 	int ret;
 
-	doutc(cl, "%p mds%d\n", session, session->s_mds);
+	boutc(cl, "%p mds%d\n", session, session->s_mds);
 	spin_lock(&session->s_cap_lock);
 	p = session->s_caps.next;
 	while (p != &session->s_caps) {
@@ -1856,7 +1856,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 		spin_lock(&session->s_cap_lock);
 		p = p->next;
 		if (!cap->ci) {
-			doutc(cl, "finishing cap %p removal\n", cap);
+			boutc(cl, "finishing cap %p removal\n", cap);
 			BUG_ON(cap->session != session);
 			cap->session = NULL;
 			list_del_init(&cap->session_caps);
@@ -1893,7 +1893,7 @@ static int remove_session_caps_cb(struct inode *inode, int mds, void *arg)
 	spin_lock(&ci->i_ceph_lock);
 	cap = __get_cap_for_mds(ci, mds);
 	if (cap) {
-		doutc(cl, " removing cap %p, ci is %p, inode is %p\n",
+		boutc(cl, " removing cap %p, ci is %p, inode is %p\n",
 		      cap, ci, &ci->netfs.inode);
 
 		iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
@@ -1918,7 +1918,7 @@ static void remove_session_caps(struct ceph_mds_session *session)
 	struct super_block *sb = fsc->sb;
 	LIST_HEAD(dispose);
 
-	doutc(fsc->client, "on %p\n", session);
+	boutc(fsc->client, "on %p\n", session);
 	ceph_iterate_session_caps(session, remove_session_caps_cb, fsc);
 
 	wake_up_all(&fsc->mdsc->cap_flushing_wq);
@@ -2001,7 +2001,7 @@ static void wake_up_session_caps(struct ceph_mds_session *session, int ev)
 {
 	struct ceph_client *cl = session->s_mdsc->fsc->client;
 
-	doutc(cl, "session %p mds%d\n", session, session->s_mds);
+	boutc(cl, "session %p mds%d\n", session, session->s_mds);
 	ceph_iterate_session_caps(session, wake_up_session_cb,
 				  (void *)(unsigned long)ev);
 }
@@ -2028,12 +2028,12 @@ static int send_renew_caps(struct ceph_mds_client *mdsc,
 	 * with its clients. */
 	state = ceph_mdsmap_get_state(mdsc->mdsmap, session->s_mds);
 	if (state < CEPH_MDS_STATE_RECONNECT) {
-		doutc(cl, "ignoring mds%d (%s)\n", session->s_mds,
+		boutc(cl, "ignoring mds%d (%s)\n", session->s_mds,
 		      ceph_mds_state_name(state));
 		return 0;
 	}
 
-	doutc(cl, "to mds%d (%s)\n", session->s_mds,
+	boutc(cl, "to mds%d (%s)\n", session->s_mds,
 	      ceph_mds_state_name(state));
 	msg = create_session_full_msg(mdsc, CEPH_SESSION_REQUEST_RENEWCAPS,
 				      ++session->s_renew_seq);
@@ -2049,7 +2049,7 @@ static int send_flushmsg_ack(struct ceph_mds_client *mdsc,
 	struct ceph_client *cl = mdsc->fsc->client;
 	struct ceph_msg *msg;
 
-	doutc(cl, "to mds%d (%s)s seq %lld\n", session->s_mds,
+	boutc(cl, "to mds%d (%s)s seq %lld\n", session->s_mds,
 	      ceph_session_state_name(session->s_state), seq);
 	msg = ceph_create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
 	if (!msg)
@@ -2087,7 +2087,7 @@ static void renewed_caps(struct ceph_mds_client *mdsc,
 				       session->s_mds);
 		}
 	}
-	doutc(cl, "mds%d ttl now %lu, was %s, now %s\n", session->s_mds,
+	boutc(cl, "mds%d ttl now %lu, was %s, now %s\n", session->s_mds,
 	      session->s_cap_ttl, was_stale ? "stale" : "fresh",
 	      time_before(jiffies, session->s_cap_ttl) ? "stale" : "fresh");
 	spin_unlock(&session->s_cap_lock);
@@ -2104,7 +2104,7 @@ static int request_close_session(struct ceph_mds_session *session)
 	struct ceph_client *cl = session->s_mdsc->fsc->client;
 	struct ceph_msg *msg;
 
-	doutc(cl, "mds%d state %s seq %lld\n", session->s_mds,
+	boutc(cl, "mds%d state %s seq %lld\n", session->s_mds,
 	      ceph_session_state_name(session->s_state), session->s_seq);
 	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_CLOSE,
 				      session->s_seq);
@@ -2182,7 +2182,7 @@ static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 	wanted = __ceph_caps_file_wanted(ci);
 	oissued = __ceph_caps_issued_other(ci, cap);
 
-	doutc(cl, "%p %llx.%llx cap %p mine %s oissued %s used %s wanted %s\n",
+	boutc(cl, "%p %llx.%llx cap %p mine %s oissued %s used %s wanted %s\n",
 	      inode, ceph_vinop(inode), cap, ceph_cap_string(mine),
 	      ceph_cap_string(oissued), ceph_cap_string(used),
 	      ceph_cap_string(wanted));
@@ -2225,7 +2225,7 @@ static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 			count = icount_read(inode);
 			if (count == 1)
 				(*remaining)--;
-			doutc(cl, "%p %llx.%llx cap %p pruned, count now %d\n",
+			boutc(cl, "%p %llx.%llx cap %p pruned, count now %d\n",
 			      inode, ceph_vinop(inode), cap, count);
 		} else {
 			dput(dentry);
@@ -2248,13 +2248,13 @@ int ceph_trim_caps(struct ceph_mds_client *mdsc,
 	struct ceph_client *cl = mdsc->fsc->client;
 	int trim_caps = session->s_nr_caps - max_caps;
 
-	doutc(cl, "mds%d start: %d / %d, trim %d\n", session->s_mds,
+	boutc(cl, "mds%d start: %d / %d, trim %d\n", session->s_mds,
 	      session->s_nr_caps, max_caps, trim_caps);
 	if (trim_caps > 0) {
 		int remaining = trim_caps;
 
 		ceph_iterate_session_caps(session, trim_caps_cb, &remaining);
-		doutc(cl, "mds%d done: %d / %d, trimmed %d\n",
+		boutc(cl, "mds%d done: %d / %d, trimmed %d\n",
 		      session->s_mds, session->s_nr_caps, max_caps,
 		      trim_caps - remaining);
 	}
@@ -2275,7 +2275,7 @@ static int check_caps_flush(struct ceph_mds_client *mdsc,
 			list_first_entry(&mdsc->cap_flush_list,
 					 struct ceph_cap_flush, g_list);
 		if (cf->tid <= want_flush_tid) {
-			doutc(cl, "still flushing tid %llu <= %llu\n",
+			boutc(cl, "still flushing tid %llu <= %llu\n",
 			      cf->tid, want_flush_tid);
 			ret = 0;
 		}
@@ -2294,12 +2294,12 @@ static void wait_caps_flush(struct ceph_mds_client *mdsc,
 {
 	struct ceph_client *cl = mdsc->fsc->client;
 
-	doutc(cl, "want %llu\n", want_flush_tid);
+	boutc(cl, "want %llu\n", want_flush_tid);
 
 	wait_event(mdsc->cap_flushing_wq,
 		   check_caps_flush(mdsc, want_flush_tid));
 
-	doutc(cl, "ok, flushed thru %llu\n", want_flush_tid);
+	boutc(cl, "ok, flushed thru %llu\n", want_flush_tid);
 }
 
 /*
@@ -2367,7 +2367,7 @@ static void ceph_send_cap_releases(struct ceph_mds_client *mdsc,
 			msg->front.iov_len += sizeof(*cap_barrier);
 
 			msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
-			doutc(cl, "mds%d %p\n", session->s_mds, msg);
+			boutc(cl, "mds%d %p\n", session->s_mds, msg);
 			ceph_con_send(&session->s_con, msg);
 			msg = NULL;
 		}
@@ -2387,7 +2387,7 @@ static void ceph_send_cap_releases(struct ceph_mds_client *mdsc,
 		msg->front.iov_len += sizeof(*cap_barrier);
 
 		msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
-		doutc(cl, "mds%d %p\n", session->s_mds, msg);
+		boutc(cl, "mds%d %p\n", session->s_mds, msg);
 		ceph_con_send(&session->s_con, msg);
 	}
 	return;
@@ -2423,10 +2423,10 @@ void ceph_flush_session_cap_releases(struct ceph_mds_client *mdsc,
 	ceph_get_mds_session(session);
 	if (queue_work(mdsc->fsc->cap_wq,
 		       &session->s_cap_release_work)) {
-		doutc(cl, "cap release work queued\n");
+		boutc(cl, "cap release work queued\n");
 	} else {
 		ceph_put_mds_session(session);
-		doutc(cl, "failed to queue cap release work\n");
+		boutc(cl, "failed to queue cap release work\n");
 	}
 }
 
@@ -2459,9 +2459,9 @@ void ceph_queue_cap_reclaim_work(struct ceph_mds_client *mdsc)
 		return;
 
         if (queue_work(mdsc->fsc->cap_wq, &mdsc->cap_reclaim_work)) {
-                doutc(cl, "caps reclaim work queued\n");
+                boutc(cl, "caps reclaim work queued\n");
         } else {
-                doutc(cl, "failed to queue caps release work\n");
+                boutc(cl, "failed to queue caps release work\n");
         }
 }
 
@@ -2484,9 +2484,9 @@ void ceph_queue_cap_unlink_work(struct ceph_mds_client *mdsc)
 		return;
 
         if (queue_work(mdsc->fsc->cap_wq, &mdsc->cap_unlink_work)) {
-                doutc(cl, "caps unlink work queued\n");
+                boutc(cl, "caps unlink work queued\n");
         } else {
-                doutc(cl, "failed to queue caps unlink work\n");
+                boutc(cl, "failed to queue caps unlink work\n");
         }
 }
 
@@ -2496,7 +2496,7 @@ static void ceph_cap_unlink_work(struct work_struct *work)
 		container_of(work, struct ceph_mds_client, cap_unlink_work);
 	struct ceph_client *cl = mdsc->fsc->client;
 
-	doutc(cl, "begin\n");
+	boutc(cl, "begin\n");
 	spin_lock(&mdsc->cap_delay_lock);
 	while (!list_empty(&mdsc->cap_unlink_delay_list)) {
 		struct ceph_inode_info *ci;
@@ -2510,7 +2510,7 @@ static void ceph_cap_unlink_work(struct work_struct *work)
 		inode = igrab(&ci->netfs.inode);
 		if (inode) {
 			spin_unlock(&mdsc->cap_delay_lock);
-			doutc(cl, "on %p %llx.%llx\n", inode,
+			boutc(cl, "on %p %llx.%llx\n", inode,
 			      ceph_vinop(inode));
 			ceph_check_caps(ci, CHECK_CAPS_FLUSH);
 			iput(inode);
@@ -2518,7 +2518,7 @@ static void ceph_cap_unlink_work(struct work_struct *work)
 		}
 	}
 	spin_unlock(&mdsc->cap_delay_lock);
-	doutc(cl, "done\n");
+	boutc(cl, "done\n");
 }
 
 /*
@@ -2733,7 +2733,7 @@ char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 		spin_lock(&cur->d_lock);
 		inode = d_inode(cur);
 		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
-			doutc(cl, "path+%d: %p SNAPDIR\n", pos, cur);
+			boutc(cl, "path+%d: %p SNAPDIR\n", pos, cur);
 			spin_unlock(&cur->d_lock);
 			parent = dget_parent(cur);
 		} else if (for_wire && inode && dentry != cur &&
@@ -2829,7 +2829,7 @@ char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 	else
 		path_info->vino.snap = CEPH_NOSNAP;
 
-	doutc(cl, "on %p %d built %llx '%.*s'\n", dentry, d_count(dentry),
+	boutc(cl, "on %p %d built %llx '%.*s'\n", dentry, d_count(dentry),
 	      base, PATH_MAX - 1 - pos, path + pos);
 	return path + pos;
 }
@@ -2907,11 +2907,11 @@ static int set_request_path_attr(struct ceph_mds_client *mdsc, struct inode *rin
 
 	if (rinode) {
 		r = build_inode_path(rinode, path_info);
-		doutc(cl, " inode %p %llx.%llx\n", rinode, ceph_ino(rinode),
+		boutc(cl, " inode %p %llx.%llx\n", rinode, ceph_ino(rinode),
 		      ceph_snap(rinode));
 	} else if (rdentry) {
 		r = build_dentry_path(mdsc, rdentry, rdiri, path_info, parent_locked);
-		doutc(cl, " dentry %p %llx/%.*s\n", rdentry, path_info->vino.ino,
+		boutc(cl, " dentry %p %llx/%.*s\n", rdentry, path_info->vino.ino,
 		      path_info->pathlen, path_info->path);
 	} else if (rpath || rino) {
 		path_info->vino.ino = rino;
@@ -2920,7 +2920,7 @@ static int set_request_path_attr(struct ceph_mds_client *mdsc, struct inode *rin
 		path_info->pathlen = rpath ? strlen(rpath) : 0;
 		path_info->freepath = false;
 
-		doutc(cl, " path %.*s\n", path_info->pathlen, rpath);
+		boutc(cl, " path %.*s\n", path_info->pathlen, rpath);
 	}
 
 	return r;
@@ -3337,7 +3337,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 		else
 			req->r_sent_on_mseq = -1;
 	}
-	doutc(cl, "%p tid %lld %s (attempt %d)\n", req, req->r_tid,
+	boutc(cl, "%p tid %lld %s (attempt %d)\n", req, req->r_tid,
 	      ceph_mds_op_name(req->r_op), req->r_attempts);
 
 	if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
@@ -3406,7 +3406,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 		nhead->ext_num_retry = cpu_to_le32(req->r_attempts - 1);
 	}
 
-	doutc(cl, " r_parent = %p\n", req->r_parent);
+	boutc(cl, " r_parent = %p\n", req->r_parent);
 	return 0;
 }
 
@@ -3447,29 +3447,29 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	}
 
 	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
-		doutc(cl, "metadata corrupted\n");
+		boutc(cl, "metadata corrupted\n");
 		err = -EIO;
 		goto finish;
 	}
 	if (req->r_timeout &&
 	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {
-		doutc(cl, "timed out\n");
+		boutc(cl, "timed out\n");
 		err = -ETIMEDOUT;
 		goto finish;
 	}
 	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
-		doutc(cl, "forced umount\n");
+		boutc(cl, "forced umount\n");
 		err = -EIO;
 		goto finish;
 	}
 	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_MOUNTING) {
 		if (mdsc->mdsmap_err) {
 			err = mdsc->mdsmap_err;
-			doutc(cl, "mdsmap err %d\n", err);
+			boutc(cl, "mdsmap err %d\n", err);
 			goto finish;
 		}
 		if (mdsc->mdsmap->m_epoch == 0) {
-			doutc(cl, "no mdsmap, waiting for map\n");
+			boutc(cl, "no mdsmap, waiting for map\n");
 			list_add(&req->r_wait, &mdsc->waiting_for_map);
 			return;
 		}
@@ -3490,7 +3490,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
 			err = -EJUKEBOX;
 			goto finish;
 		}
-		doutc(cl, "no mds or not active, waiting for map\n");
+		boutc(cl, "no mds or not active, waiting for map\n");
 		list_add(&req->r_wait, &mdsc->waiting_for_map);
 		return;
 	}
@@ -3506,7 +3506,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	}
 	req->r_session = ceph_get_mds_session(session);
 
-	doutc(cl, "mds%d session %p state %s\n", mds, session,
+	boutc(cl, "mds%d session %p state %s\n", mds, session,
 	      ceph_session_state_name(session->s_state));
 
 	/*
@@ -3598,7 +3598,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
 		spin_lock(&ci->i_ceph_lock);
 		cap = ci->i_auth_cap;
 		if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE && mds != cap->mds) {
-			doutc(cl, "session changed for auth cap %d -> %d\n",
+			boutc(cl, "session changed for auth cap %d -> %d\n",
 			      cap->session->s_mds, session->s_mds);
 
 			/* Remove the auth cap from old session */
@@ -3626,7 +3626,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	ceph_put_mds_session(session);
 finish:
 	if (err) {
-		doutc(cl, "early error %d\n", err);
+		boutc(cl, "early error %d\n", err);
 		req->r_err = err;
 		complete_request(mdsc, req);
 		__unregister_request(mdsc, req);
@@ -3650,7 +3650,7 @@ static void __wake_requests(struct ceph_mds_client *mdsc,
 		req = list_entry(tmp_list.next,
 				 struct ceph_mds_request, r_wait);
 		list_del_init(&req->r_wait);
-		doutc(cl, " wake request %p tid %llu\n", req,
+		boutc(cl, " wake request %p tid %llu\n", req,
 		      req->r_tid);
 		__do_request(mdsc, req);
 	}
@@ -3666,7 +3666,7 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
 	struct ceph_mds_request *req;
 	struct rb_node *p = rb_first(&mdsc->request_tree);
 
-	doutc(cl, "kick_requests mds%d\n", mds);
+	boutc(cl, "kick_requests mds%d\n", mds);
 	while (p) {
 		req = rb_entry(p, struct ceph_mds_request, r_node);
 		p = rb_next(p);
@@ -3676,7 +3676,7 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
 			continue; /* only new requests */
 		if (req->r_session &&
 		    req->r_session->s_mds == mds) {
-			doutc(cl, " kicking tid %llu\n", req->r_tid);
+			boutc(cl, " kicking tid %llu\n", req->r_tid);
 			list_del_init(&req->r_wait);
 			__do_request(mdsc, req);
 		}
@@ -3708,7 +3708,7 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 	if (req->r_inode) {
 		err = ceph_wait_on_async_create(req->r_inode);
 		if (err) {
-			doutc(cl, "wait for async create returned: %d\n", err);
+			boutc(cl, "wait for async create returned: %d\n", err);
 			return err;
 		}
 	}
@@ -3716,12 +3716,12 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 	if (!err && req->r_old_inode) {
 		err = ceph_wait_on_async_create(req->r_old_inode);
 		if (err) {
-			doutc(cl, "wait for async create returned: %d\n", err);
+			boutc(cl, "wait for async create returned: %d\n", err);
 			return err;
 		}
 	}
 
-	doutc(cl, "submit_request on %p for inode %p\n", req, dir);
+	boutc(cl, "submit_request on %p for inode %p\n", req, dir);
 	mutex_lock(&mdsc->mutex);
 	__register_request(mdsc, req, dir);
 	__do_request(mdsc, req);
@@ -3738,7 +3738,7 @@ int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
 	int err;
 
 	/* wait */
-	doutc(cl, "do_request waiting\n");
+	boutc(cl, "do_request waiting\n");
 	if (wait_func) {
 		err = wait_func(mdsc, req);
 	} else {
@@ -3752,14 +3752,14 @@ int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
 		else
 			err = timeleft;  /* killed */
 	}
-	doutc(cl, "do_request waited, got %d\n", err);
+	boutc(cl, "do_request waited, got %d\n", err);
 	mutex_lock(&mdsc->mutex);
 
 	/* only abort if we didn't race with a real reply */
 	if (test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
 		err = le32_to_cpu(req->r_reply_info.head->result);
 	} else if (err < 0) {
-		doutc(cl, "aborted request %lld with %d\n", req->r_tid, err);
+		boutc(cl, "aborted request %lld with %d\n", req->r_tid, err);
 
 		/*
 		 * ensure we aren't running concurrently with
@@ -3793,13 +3793,13 @@ int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
 	struct ceph_client *cl = mdsc->fsc->client;
 	int err;
 
-	doutc(cl, "do_request on %p\n", req);
+	boutc(cl, "do_request on %p\n", req);
 
 	/* issue */
 	err = ceph_mdsc_submit_request(mdsc, dir, req);
 	if (!err)
 		err = ceph_mdsc_wait_request(mdsc, req, NULL);
-	doutc(cl, "do_request %p done, result %d\n", req, err);
+	boutc(cl, "do_request %p done, result %d\n", req, err);
 	return err;
 }
 
@@ -3813,7 +3813,7 @@ void ceph_invalidate_dir_request(struct ceph_mds_request *req)
 	struct inode *old_dir = req->r_old_dentry_dir;
 	struct ceph_client *cl = req->r_mdsc->fsc->client;
 
-	doutc(cl, "invalidate_dir_request %p %p (complete, lease(s))\n",
+	boutc(cl, "invalidate_dir_request %p %p (complete, lease(s))\n",
 	      dir, old_dir);
 
 	ceph_dir_clear_complete(dir);
@@ -3856,11 +3856,11 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	mutex_lock(&mdsc->mutex);
 	req = lookup_get_request(mdsc, tid);
 	if (!req) {
-		doutc(cl, "on unknown tid %llu\n", tid);
+		boutc(cl, "on unknown tid %llu\n", tid);
 		mutex_unlock(&mdsc->mutex);
 		return;
 	}
-	doutc(cl, "handle_reply %p\n", req);
+	boutc(cl, "handle_reply %p\n", req);
 
 	/* correct session? */
 	if (req->r_session != session) {
@@ -3904,7 +3904,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 			 * response.  And even if it did, there is nothing
 			 * useful we could do with a revised return value.
 			 */
-			doutc(cl, "got safe reply %llu, mds%d\n", tid, mds);
+			boutc(cl, "got safe reply %llu, mds%d\n", tid, mds);
 
 			mutex_unlock(&mdsc->mutex);
 			goto out;
@@ -3914,7 +3914,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 		list_add_tail(&req->r_unsafe_item, &req->r_session->s_unsafe);
 	}
 
-	doutc(cl, "tid %lld result %d\n", tid, result);
+	boutc(cl, "tid %lld result %d\n", tid, result);
 	if (test_bit(CEPHFS_FEATURE_REPLY_ENCODING, &session->s_features))
 		err = parse_reply_info(session, msg, req, (u64)-1);
 	else
@@ -4019,7 +4019,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 			set_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags);
 		}
 	} else {
-		doutc(cl, "reply arrived after request %lld was aborted\n", tid);
+		boutc(cl, "reply arrived after request %lld was aborted\n", tid);
 	}
 	mutex_unlock(&mdsc->mutex);
 
@@ -4066,12 +4066,12 @@ static void handle_forward(struct ceph_mds_client *mdsc,
 	req = lookup_get_request(mdsc, tid);
 	if (!req) {
 		mutex_unlock(&mdsc->mutex);
-		doutc(cl, "forward tid %llu to mds%d - req dne\n", tid, next_mds);
+		boutc(cl, "forward tid %llu to mds%d - req dne\n", tid, next_mds);
 		return;  /* dup reply? */
 	}
 
 	if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
-		doutc(cl, "forward tid %llu aborted, unregistering\n", tid);
+		boutc(cl, "forward tid %llu aborted, unregistering\n", tid);
 		__unregister_request(mdsc, req);
 	} else if (fwd_seq <= req->r_num_fwd || (uint32_t)fwd_seq >= U32_MAX) {
 		/*
@@ -4091,7 +4091,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
 					   tid);
 	} else {
 		/* resend. forward race not possible; mds would drop */
-		doutc(cl, "forward tid %llu to mds%d (we resend)\n", tid, next_mds);
+		boutc(cl, "forward tid %llu to mds%d (we resend)\n", tid, next_mds);
 		BUG_ON(req->r_err);
 		BUG_ON(test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags));
 		req->r_attempts = 0;
@@ -4207,7 +4207,7 @@ static void handle_session(struct ceph_mds_session *session,
 
 	if (msg_version >= 6) {
 		ceph_decode_32_safe(&p, end, cap_auths_num, bad);
-		doutc(cl, "cap_auths_num %d\n", cap_auths_num);
+		boutc(cl, "cap_auths_num %d\n", cap_auths_num);
 
 		if (cap_auths_num && op != CEPH_SESSION_OPEN) {
 			WARN_ON_ONCE(op != CEPH_SESSION_OPEN);
@@ -4278,7 +4278,7 @@ static void handle_session(struct ceph_mds_session *session,
 			ceph_decode_8_safe(&p, end, cap_auths[i].match.root_squash, bad);
 			ceph_decode_8_safe(&p, end, cap_auths[i].readable, bad);
 			ceph_decode_8_safe(&p, end, cap_auths[i].writeable, bad);
-			doutc(cl, "uid %lld, num_gids %u, path %s, fs_name %s, root_squash %d, readable %d, writeable %d\n",
+			boutc(cl, "uid %lld, num_gids %u, path %s, fs_name %s, root_squash %d, readable %d, writeable %d\n",
 			      cap_auths[i].match.uid, cap_auths[i].match.num_gids,
 			      cap_auths[i].match.path, cap_auths[i].match.fs_name,
 			      cap_auths[i].match.root_squash,
@@ -4310,7 +4310,7 @@ static void handle_session(struct ceph_mds_session *session,
 
 	mutex_lock(&session->s_mutex);
 
-	doutc(cl, "mds%d %s %p state %s seq %llu\n", mds,
+	boutc(cl, "mds%d %s %p state %s seq %llu\n", mds,
 	      ceph_session_op_name(op), session,
 	      ceph_session_state_name(session->s_state), seq);
 
@@ -4389,7 +4389,7 @@ static void handle_session(struct ceph_mds_session *session,
 		break;
 
 	case CEPH_SESSION_FORCE_RO:
-		doutc(cl, "force_session_readonly %p\n", session);
+		boutc(cl, "force_session_readonly %p\n", session);
 		spin_lock(&session->s_cap_lock);
 		session->s_readonly = true;
 		spin_unlock(&session->s_cap_lock);
@@ -4446,7 +4446,7 @@ void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req)
 
 	dcaps = xchg(&req->r_dir_caps, 0);
 	if (dcaps) {
-		doutc(cl, "releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
+		boutc(cl, "releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
 		ceph_put_cap_refs(ceph_inode(req->r_parent), dcaps);
 	}
 }
@@ -4458,7 +4458,7 @@ void ceph_mdsc_release_dir_caps_async(struct ceph_mds_request *req)
 
 	dcaps = xchg(&req->r_dir_caps, 0);
 	if (dcaps) {
-		doutc(cl, "releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
+		boutc(cl, "releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
 		ceph_put_cap_refs_async(ceph_inode(req->r_parent), dcaps);
 	}
 }
@@ -4472,7 +4472,7 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
 	struct ceph_mds_request *req, *nreq;
 	struct rb_node *p;
 
-	doutc(mdsc->fsc->client, "mds%d\n", session->s_mds);
+	boutc(mdsc->fsc->client, "mds%d\n", session->s_mds);
 
 	mutex_lock(&mdsc->mutex);
 	list_for_each_entry_safe(req, nreq, &session->s_unsafe, r_unsafe_item)
@@ -4650,7 +4650,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 		err = 0;
 		goto out_err;
 	}
-	doutc(cl, " adding %p ino %llx.%llx cap %p %lld %s\n", inode,
+	boutc(cl, " adding %p ino %llx.%llx cap %p %lld %s\n", inode,
 	      ceph_vinop(inode), cap, cap->cap_id,
 	      ceph_cap_string(cap->issued));
 
@@ -4845,7 +4845,7 @@ static int encode_snap_realms(struct ceph_mds_client *mdsc,
 			ceph_pagelist_encode_32(pagelist, sizeof(sr_rec));
 		}
 
-		doutc(cl, " adding snap realm %llx seq %lld parent %llx\n",
+		boutc(cl, " adding snap realm %llx seq %lld parent %llx\n",
 		      realm->ino, realm->seq, realm->parent_ino);
 		sr_rec.ino = cpu_to_le64(realm->ino);
 		sr_rec.seq = cpu_to_le64(realm->seq);
@@ -4900,7 +4900,7 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 	session->s_state = CEPH_MDS_SESSION_RECONNECTING;
 	session->s_seq = 0;
 
-	doutc(cl, "session %p state %s\n", session,
+	boutc(cl, "session %p state %s\n", session,
 	      ceph_session_state_name(session->s_state));
 
 	atomic_inc(&session->s_cap_gen);
@@ -5057,7 +5057,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 	unsigned long targets[DIV_ROUND_UP(CEPH_MAX_MDS, sizeof(unsigned long))] = {0};
 	struct ceph_client *cl = mdsc->fsc->client;
 
-	doutc(cl, "new %u old %u\n", newmap->m_epoch, oldmap->m_epoch);
+	boutc(cl, "new %u old %u\n", newmap->m_epoch, oldmap->m_epoch);
 
 	if (newmap->m_info) {
 		for (i = 0; i < newmap->possible_max_rank; i++) {
@@ -5073,7 +5073,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		oldstate = ceph_mdsmap_get_state(oldmap, i);
 		newstate = ceph_mdsmap_get_state(newmap, i);
 
-		doutc(cl, "mds%d state %s%s -> %s%s (session %s)\n",
+		boutc(cl, "mds%d state %s%s -> %s%s (session %s)\n",
 		      i, ceph_mds_state_name(oldstate),
 		      ceph_mdsmap_is_laggy(oldmap, i) ? " (laggy)" : "",
 		      ceph_mds_state_name(newstate),
@@ -5182,7 +5182,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 				continue;
 			}
 		}
-		doutc(cl, "send reconnect to export target mds.%d\n", i);
+		boutc(cl, "send reconnect to export target mds.%d\n", i);
 		mutex_unlock(&mdsc->mutex);
 		send_mds_reconnect(mdsc, s);
 		ceph_put_mds_session(s);
@@ -5198,7 +5198,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		if (s->s_state == CEPH_MDS_SESSION_OPEN ||
 		    s->s_state == CEPH_MDS_SESSION_HUNG ||
 		    s->s_state == CEPH_MDS_SESSION_CLOSING) {
-			doutc(cl, " connecting to export targets of laggy mds%d\n", i);
+			boutc(cl, " connecting to export targets of laggy mds%d\n", i);
 			__open_export_target_sessions(mdsc, s);
 		}
 	}
@@ -5237,7 +5237,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 	struct qstr dname;
 	int release = 0;
 
-	doutc(cl, "from mds%d\n", mds);
+	boutc(cl, "from mds%d\n", mds);
 
 	if (!ceph_inc_mds_stopping_blocker(mdsc, session))
 		return;
@@ -5255,19 +5255,19 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 
 	/* lookup inode */
 	inode = ceph_find_inode(sb, vino);
-	doutc(cl, "%s, ino %llx %p %.*s\n", ceph_lease_op_name(h->action),
+	boutc(cl, "%s, ino %llx %p %.*s\n", ceph_lease_op_name(h->action),
 	      vino.ino, inode, dname.len, dname.name);
 
 	mutex_lock(&session->s_mutex);
 	if (!inode) {
-		doutc(cl, "no inode %llx\n", vino.ino);
+		boutc(cl, "no inode %llx\n", vino.ino);
 		goto release;
 	}
 
 	/* dentry */
 	parent = d_find_alias(inode);
 	if (!parent) {
-		doutc(cl, "no parent dentry on inode %p\n", inode);
+		boutc(cl, "no parent dentry on inode %p\n", inode);
 		WARN_ON(1);
 		goto release;  /* hrm... */
 	}
@@ -5341,7 +5341,7 @@ void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
 	struct inode *dir;
 	int len = sizeof(*lease) + sizeof(u32) + NAME_MAX;
 
-	doutc(cl, "identry %p %s to mds%d\n", dentry, ceph_lease_op_name(action),
+	boutc(cl, "identry %p %s to mds%d\n", dentry, ceph_lease_op_name(action),
 	      session->s_mds);
 
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_LEASE, len, GFP_NOFS, false);
@@ -5428,7 +5428,7 @@ void inc_session_sequence(struct ceph_mds_session *s)
 	if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
 		int ret;
 
-		doutc(cl, "resending session close request for mds%d\n", s->s_mds);
+		boutc(cl, "resending session close request for mds%d\n", s->s_mds);
 		ret = request_close_session(s);
 		if (ret < 0)
 			pr_err_client(cl, "unable to close session to mds%d: %d\n",
@@ -5461,7 +5461,7 @@ static void delayed_work(struct work_struct *work)
 	int renew_caps;
 	int i;
 
-	doutc(mdsc->fsc->client, "mdsc delayed_work\n");
+	boutc(mdsc->fsc->client, "mdsc delayed_work\n");
 
 	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
 		return;
@@ -5606,20 +5606,20 @@ static void wait_requests(struct ceph_mds_client *mdsc)
 	if (__get_oldest_req(mdsc)) {
 		mutex_unlock(&mdsc->mutex);
 
-		doutc(cl, "waiting for requests\n");
+		boutc(cl, "waiting for requests\n");
 		wait_for_completion_timeout(&mdsc->safe_umount_waiters,
 				    ceph_timeout_jiffies(opts->mount_timeout));
 
 		/* tear down remaining requests */
 		mutex_lock(&mdsc->mutex);
 		while ((req = __get_oldest_req(mdsc))) {
-			doutc(cl, "timed out on tid %llu\n", req->r_tid);
+			boutc(cl, "timed out on tid %llu\n", req->r_tid);
 			list_del_init(&req->r_wait);
 			__unregister_request(mdsc, req);
 		}
 	}
 	mutex_unlock(&mdsc->mutex);
-	doutc(cl, "done\n");
+	boutc(cl, "done\n");
 }
 
 void send_flush_mdlog(struct ceph_mds_session *s)
@@ -5634,7 +5634,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
 		return;
 
 	mutex_lock(&s->s_mutex);
-	doutc(cl, "request mdlog flush to mds%d (%s)s seq %lld\n",
+	boutc(cl, "request mdlog flush to mds%d (%s)s seq %lld\n",
 	      s->s_mds, ceph_session_state_name(s->s_state), s->s_seq);
 	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_FLUSH_MDLOG,
 				      s->s_seq);
@@ -5661,14 +5661,14 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 	u32 gid, tlen, len;
 	int i, j;
 
-	doutc(cl, "fsname check fs_name=%s  match.fs_name=%s\n",
+	boutc(cl, "fsname check fs_name=%s  match.fs_name=%s\n",
 	      fs_name, auth->match.fs_name ? auth->match.fs_name : "");
 	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
 		/* fsname mismatch, try next one */
 		return 0;
 	}
 
-	doutc(cl, "match.uid %lld\n", auth->match.uid);
+	boutc(cl, "match.uid %lld\n", auth->match.uid);
 	if (auth->match.uid != MDS_AUTH_UID_ANY) {
 		if (auth->match.uid != caller_uid)
 			return 0;
@@ -5708,7 +5708,7 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 			bool free_tpath = false;
 			int m, n;
 
-			doutc(cl, "server path %s, tpath %s, match.path %s\n",
+			boutc(cl, "server path %s, tpath %s, match.path %s\n",
 			      spath, tpath, auth->match.path);
 			if (spath && (m = strlen(spath)) != 1) {
 				/* mount path + '/' + tpath + an extra space */
@@ -5732,7 +5732,7 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 				_tpath[tlen - 1] = '\0';
 				tlen -= 1;
 			}
-			doutc(cl, "_tpath %s\n", _tpath);
+			boutc(cl, "_tpath %s\n", _tpath);
 
 			/*
 			 * In case first == _tpath && tlen == len:
@@ -5762,7 +5762,7 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 		}
 	}
 
-	doutc(cl, "matched\n");
+	boutc(cl, "matched\n");
 	return 1;
 }
 
@@ -5776,7 +5776,7 @@ int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath, int mask)
 	bool root_squash_perms = true;
 	int i, err;
 
-	doutc(cl, "tpath '%s', mask %d, caller_uid %d, caller_gid %d\n",
+	boutc(cl, "tpath '%s', mask %d, caller_uid %d, caller_gid %d\n",
 	      tpath, mask, caller_uid, caller_gid);
 
 	for (i = 0; i < mdsc->s_cap_auths_num; i++) {
@@ -5802,23 +5802,23 @@ int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath, int mask)
 
 	put_cred(cred);
 
-	doutc(cl, "root_squash_perms %d, rw_perms_s %p\n", root_squash_perms,
+	boutc(cl, "root_squash_perms %d, rw_perms_s %p\n", root_squash_perms,
 	      rw_perms_s);
 	if (root_squash_perms && rw_perms_s == NULL) {
-		doutc(cl, "access allowed\n");
+		boutc(cl, "access allowed\n");
 		return 0;
 	}
 
 	if (!root_squash_perms) {
-		doutc(cl, "root_squash is enabled and user(%d %d) isn't allowed to write",
+		boutc(cl, "root_squash is enabled and user(%d %d) isn't allowed to write",
 		      caller_uid, caller_gid);
 	}
 	if (rw_perms_s) {
-		doutc(cl, "mds auth caps readable/writeable %d/%d while request r/w %d/%d",
+		boutc(cl, "mds auth caps readable/writeable %d/%d while request r/w %d/%d",
 		      rw_perms_s->readable, rw_perms_s->writeable,
 		      !!(mask & MAY_READ), !!(mask & MAY_WRITE));
 	}
-	doutc(cl, "access denied\n");
+	boutc(cl, "access denied\n");
 	return -EACCES;
 }
 
@@ -5828,7 +5828,7 @@ int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath, int mask)
  */
 void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 {
-	doutc(mdsc->fsc->client, "begin\n");
+	boutc(mdsc->fsc->client, "begin\n");
 	mdsc->stopping = CEPH_MDSC_STOPPING_BEGIN;
 
 	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
@@ -5843,7 +5843,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 	ceph_msgr_flush();
 
 	ceph_cleanup_quotarealms_inodes(mdsc);
-	doutc(mdsc->fsc->client, "done\n");
+	boutc(mdsc->fsc->client, "done\n");
 }
 
 /*
@@ -5858,7 +5858,7 @@ static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *md
 	struct rb_node *n;
 
 	mutex_lock(&mdsc->mutex);
-	doutc(cl, "want %lld\n", want_tid);
+	boutc(cl, "want %lld\n", want_tid);
 restart:
 	req = __get_oldest_req(mdsc);
 	while (req && req->r_tid <= want_tid) {
@@ -5892,7 +5892,7 @@ static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *md
 			} else {
 				ceph_put_mds_session(s);
 			}
-			doutc(cl, "wait on %llu (want %llu)\n",
+			boutc(cl, "wait on %llu (want %llu)\n",
 			      req->r_tid, want_tid);
 			wait_for_completion(&req->r_safe_completion);
 
@@ -5911,7 +5911,7 @@ static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *md
 	}
 	mutex_unlock(&mdsc->mutex);
 	ceph_put_mds_session(last_session);
-	doutc(cl, "done\n");
+	boutc(cl, "done\n");
 }
 
 void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
@@ -5922,7 +5922,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
 	if (READ_ONCE(mdsc->fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN)
 		return;
 
-	doutc(cl, "sync\n");
+	boutc(cl, "sync\n");
 	mutex_lock(&mdsc->mutex);
 	want_tid = mdsc->last_tid;
 	mutex_unlock(&mdsc->mutex);
@@ -5939,7 +5939,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
 	}
 	spin_unlock(&mdsc->cap_dirty_lock);
 
-	doutc(cl, "sync want tid %lld flush_seq %lld\n", want_tid, want_flush);
+	boutc(cl, "sync want tid %lld flush_seq %lld\n", want_tid, want_flush);
 
 	flush_mdlog_and_wait_mdsc_unsafe_requests(mdsc, want_tid);
 	wait_caps_flush(mdsc, want_flush);
@@ -5966,7 +5966,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 	int i;
 	int skipped = 0;
 
-	doutc(cl, "begin\n");
+	boutc(cl, "begin\n");
 
 	/* close sessions */
 	mutex_lock(&mdsc->mutex);
@@ -5984,7 +5984,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 	}
 	mutex_unlock(&mdsc->mutex);
 
-	doutc(cl, "waiting for sessions to close\n");
+	boutc(cl, "waiting for sessions to close\n");
 	wait_event_timeout(mdsc->session_close_wq,
 			   done_closing_sessions(mdsc, skipped),
 			   ceph_timeout_jiffies(opts->mount_timeout));
@@ -6013,7 +6013,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 	cancel_work_sync(&mdsc->cap_unlink_work);
 	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
 
-	doutc(cl, "done\n");
+	boutc(cl, "done\n");
 }
 
 void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
@@ -6021,7 +6021,7 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 	struct ceph_mds_session *session;
 	int mds;
 
-	doutc(mdsc->fsc->client, "force umount\n");
+	boutc(mdsc->fsc->client, "force umount\n");
 
 	mutex_lock(&mdsc->mutex);
 	for (mds = 0; mds < mdsc->max_sessions; mds++) {
@@ -6052,7 +6052,7 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 
 static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
 {
-	doutc(mdsc->fsc->client, "stop\n");
+	boutc(mdsc->fsc->client, "stop\n");
 	/*
 	 * Make sure the delayed work stopped before releasing
 	 * the resources.
@@ -6085,7 +6085,7 @@ static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
 void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 {
 	struct ceph_mds_client *mdsc = fsc->mdsc;
-	doutc(fsc->client, "%p\n", mdsc);
+	boutc(fsc->client, "%p\n", mdsc);
 
 	if (!mdsc)
 		return;
@@ -6099,7 +6099,7 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	fsc->mdsc = NULL;
 	kfree(mdsc);
-	doutc(fsc->client, "%p done\n", mdsc);
+	boutc(fsc->client, "%p done\n", mdsc);
 }
 
 void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
@@ -6117,7 +6117,7 @@ void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 	ceph_decode_need(&p, end, sizeof(u32), bad);
 	epoch = ceph_decode_32(&p);
 
-	doutc(cl, "epoch %u\n", epoch);
+	boutc(cl, "epoch %u\n", epoch);
 
 	/* struct_v, struct_cv, map_len, epoch, legacy_client_fscid */
 	ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 3, bad);
@@ -6193,12 +6193,12 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 		return;
 	epoch = ceph_decode_32(&p);
 	maplen = ceph_decode_32(&p);
-	doutc(cl, "epoch %u len %d\n", epoch, (int)maplen);
+	boutc(cl, "epoch %u len %d\n", epoch, (int)maplen);
 
 	/* do we need it? */
 	mutex_lock(&mdsc->mutex);
 	if (mdsc->mdsmap && epoch <= mdsc->mdsmap->m_epoch) {
-		doutc(cl, "epoch %u <= our %u\n", epoch, mdsc->mdsmap->m_epoch);
+		boutc(cl, "epoch %u <= our %u\n", epoch, mdsc->mdsmap->m_epoch);
 		mutex_unlock(&mdsc->mutex);
 		return;
 	}
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 2c7b151a7c95..d4768d3b0b78 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -236,7 +236,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 			*p = info_end;
 		}
 
-		doutc(cl, "%d/%d %lld mds%d.%d %s %s%s\n", i+1, n, global_id,
+		boutc(cl, "%d/%d %lld mds%d.%d %s %s%s\n", i+1, n, global_id,
 		      mds, inc, ceph_pr_addr(&addr),
 		      ceph_mds_state_name(state), laggy ? "(laggy)" : "");
 
@@ -246,7 +246,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		}
 
 		if (state <= 0) {
-			doutc(cl, "got incorrect state(%s)\n",
+			boutc(cl, "got incorrect state(%s)\n",
 			      ceph_mds_state_name(state));
 			continue;
 		}
@@ -399,10 +399,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		ceph_decode_64_safe(p, end, m->m_max_xattr_size, bad_ext);
 	}
 bad_ext:
-	doutc(cl, "m_enabled: %d, m_damaged: %d, m_num_laggy: %d\n",
+	boutc(cl, "m_enabled: %d, m_damaged: %d, m_num_laggy: %d\n",
 	      !!m->m_enabled, !!m->m_damaged, m->m_num_laggy);
 	*p = end;
-	doutc(cl, "success epoch %u\n", m->m_epoch);
+	boutc(cl, "success epoch %u\n", m->m_epoch);
 	return m;
 nomem:
 	err = -ENOMEM;
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index d90eda19bcc4..60465e6a9887 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -164,7 +164,7 @@ static struct inode *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
 	}
 
 	if (IS_ERR(in)) {
-		doutc(cl, "Can't lookup inode %llx (err: %ld)\n", realm->ino,
+		boutc(cl, "Can't lookup inode %llx (err: %ld)\n", realm->ino,
 		      PTR_ERR(in));
 		qri->timeout = jiffies + secs_to_jiffies(60); /* XXX */
 	} else {
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index c65f2b202b2b..025f033f30f6 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -138,7 +138,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
 	__insert_snap_realm(&mdsc->snap_realms, realm);
 	mdsc->num_snap_realms++;
 
-	doutc(mdsc->fsc->client, "%llx %p\n", realm->ino, realm);
+	boutc(mdsc->fsc->client, "%llx %p\n", realm->ino, realm);
 	return realm;
 }
 
@@ -163,7 +163,7 @@ static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
 		else if (ino > r->ino)
 			n = n->rb_right;
 		else {
-			doutc(cl, "%llx %p\n", r->ino, r);
+			boutc(cl, "%llx %p\n", r->ino, r);
 			return r;
 		}
 	}
@@ -192,7 +192,7 @@ static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
 	struct ceph_client *cl = mdsc->fsc->client;
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
 
-	doutc(cl, "%p %llx\n", realm, realm->ino);
+	boutc(cl, "%p %llx\n", realm, realm->ino);
 
 	rb_erase(&realm->node, &mdsc->snap_realms);
 	mdsc->num_snap_realms--;
@@ -306,7 +306,7 @@ static int adjust_snap_realm_parent(struct ceph_mds_client *mdsc,
 		if (IS_ERR(parent))
 			return PTR_ERR(parent);
 	}
-	doutc(cl, "%llx %p: %llx %p -> %llx %p\n", realm->ino, realm,
+	boutc(cl, "%llx %p: %llx %p -> %llx %p\n", realm->ino, realm,
 	      realm->parent_ino, realm->parent, parentino, parent);
 	if (realm->parent) {
 		list_del_init(&realm->child_item);
@@ -365,7 +365,7 @@ static int build_snap_context(struct ceph_mds_client *mdsc,
 	    realm->cached_context->seq == realm->seq &&
 	    (!parent ||
 	     realm->cached_context->seq >= parent->cached_context->seq)) {
-		doutc(cl, "%llx %p: %p seq %lld (%u snaps) (unchanged)\n",
+		boutc(cl, "%llx %p: %p seq %lld (%u snaps) (unchanged)\n",
 		      realm->ino, realm, realm->cached_context,
 		      realm->cached_context->seq,
 		      (unsigned int)realm->cached_context->num_snaps);
@@ -405,7 +405,7 @@ static int build_snap_context(struct ceph_mds_client *mdsc,
 
 	sort(snapc->snaps, num, sizeof(u64), cmpu64_rev, NULL);
 	snapc->num_snaps = num;
-	doutc(cl, "%llx %p: %p seq %lld (%u snaps)\n", realm->ino, realm,
+	boutc(cl, "%llx %p: %p seq %lld (%u snaps)\n", realm->ino, realm,
 	      snapc, snapc->seq, (unsigned int) snapc->num_snaps);
 
 	ceph_put_snap_context(realm->cached_context);
@@ -460,7 +460,7 @@ static void rebuild_snap_realms(struct ceph_mds_client *mdsc,
 
 		last = build_snap_context(mdsc, _realm, &realm_queue,
 					  dirty_realms);
-		doutc(cl, "%llx %p, %s\n", realm->ino, realm,
+		boutc(cl, "%llx %p, %s\n", realm->ino, realm,
 		      last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
 
 		/* is any child in the list ? */
@@ -557,13 +557,13 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 		   as no new writes are allowed to start when pending, so any
 		   writes in progress now were started before the previous
 		   cap_snap.  lucky us. */
-		doutc(cl, "%p %llx.%llx already pending\n", inode,
+		boutc(cl, "%p %llx.%llx already pending\n", inode,
 		      ceph_vinop(inode));
 		goto update_snapc;
 	}
 	if (ci->i_wrbuffer_ref_head == 0 &&
 	    !(dirty & (CEPH_CAP_ANY_EXCL|CEPH_CAP_FILE_WR))) {
-		doutc(cl, "%p %llx.%llx nothing dirty|writing\n", inode,
+		boutc(cl, "%p %llx.%llx nothing dirty|writing\n", inode,
 		      ceph_vinop(inode));
 		goto update_snapc;
 	}
@@ -584,13 +584,13 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 	} else {
 		if (!(used & CEPH_CAP_FILE_WR) &&
 		    ci->i_wrbuffer_ref_head == 0) {
-			doutc(cl, "%p %llx.%llx no new_snap|dirty_page|writing\n",
+			boutc(cl, "%p %llx.%llx no new_snap|dirty_page|writing\n",
 			      inode, ceph_vinop(inode));
 			goto update_snapc;
 		}
 	}
 
-	doutc(cl, "%p %llx.%llx cap_snap %p queuing under %p %s %s\n",
+	boutc(cl, "%p %llx.%llx cap_snap %p queuing under %p %s %s\n",
 	      inode, ceph_vinop(inode), capsnap, old_snapc,
 	      ceph_cap_string(dirty), capsnap->need_flush ? "" : "no_flush");
 	ihold(inode);
@@ -624,7 +624,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 	list_add_tail(&capsnap->ci_item, &ci->i_cap_snaps);
 
 	if (used & CEPH_CAP_FILE_WR) {
-		doutc(cl, "%p %llx.%llx cap_snap %p snapc %p seq %llu used WR,"
+		boutc(cl, "%p %llx.%llx cap_snap %p snapc %p seq %llu used WR,"
 		      " now pending\n", inode, ceph_vinop(inode), capsnap,
 		      old_snapc, old_snapc->seq);
 		capsnap->writing = 1;
@@ -643,7 +643,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 		ci->i_head_snapc = NULL;
 	} else {
 		ci->i_head_snapc = ceph_get_snap_context(new_snapc);
-		doutc(cl, " new snapc is %p\n", new_snapc);
+		boutc(cl, " new snapc is %p\n", new_snapc);
 	}
 	spin_unlock(&ci->i_ceph_lock);
 
@@ -677,7 +677,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 	capsnap->truncate_size = ci->i_truncate_size;
 	capsnap->truncate_seq = ci->i_truncate_seq;
 	if (capsnap->dirty_pages) {
-		doutc(cl, "%p %llx.%llx cap_snap %p snapc %p %llu %s "
+		boutc(cl, "%p %llx.%llx cap_snap %p snapc %p %llu %s "
 		      "s=%llu still has %d dirty pages\n", inode,
 		      ceph_vinop(inode), capsnap, capsnap->context,
 		      capsnap->context->seq,
@@ -691,7 +691,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 	 * And trigger to flush the buffer immediately.
 	 */
 	if (ci->i_wrbuffer_ref) {
-		doutc(cl, "%p %llx.%llx cap_snap %p snapc %p %llu %s "
+		boutc(cl, "%p %llx.%llx cap_snap %p snapc %p %llu %s "
 		      "s=%llu used WRBUFFER, delaying\n", inode,
 		      ceph_vinop(inode), capsnap, capsnap->context,
 		      capsnap->context->seq, ceph_cap_string(capsnap->dirty),
@@ -701,7 +701,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 	}
 
 	ci->i_ceph_flags |= CEPH_I_FLUSH_SNAPS;
-	doutc(cl, "%p %llx.%llx cap_snap %p snapc %p %llu %s s=%llu\n",
+	boutc(cl, "%p %llx.%llx cap_snap %p snapc %p %llu %s s=%llu\n",
 	      inode, ceph_vinop(inode), capsnap, capsnap->context,
 	      capsnap->context->seq, ceph_cap_string(capsnap->dirty),
 	      capsnap->size);
@@ -727,7 +727,7 @@ static void queue_realm_cap_snaps(struct ceph_mds_client *mdsc,
 	struct inode *lastinode = NULL;
 	struct ceph_cap_snap *capsnap = NULL;
 
-	doutc(cl, "%p %llx inode\n", realm, realm->ino);
+	boutc(cl, "%p %llx inode\n", realm, realm->ino);
 
 	spin_lock(&realm->inodes_with_caps_lock);
 	list_for_each_entry(ci, &realm->inodes_with_caps, i_snap_realm_item) {
@@ -766,7 +766,7 @@ static void queue_realm_cap_snaps(struct ceph_mds_client *mdsc,
 
 	if (capsnap)
 		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
-	doutc(cl, "%p %llx done\n", realm, realm->ino);
+	boutc(cl, "%p %llx done\n", realm, realm->ino);
 }
 
 /*
@@ -795,7 +795,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
 
-	doutc(cl, "deletion=%d\n", deletion);
+	boutc(cl, "deletion=%d\n", deletion);
 more:
 	realm = NULL;
 	rebuild_snapcs = 0;
@@ -825,7 +825,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	rebuild_snapcs += err;
 
 	if (le64_to_cpu(ri->seq) > realm->seq) {
-		doutc(cl, "updating %llx %p %lld -> %lld\n", realm->ino,
+		boutc(cl, "updating %llx %p %lld -> %lld\n", realm->ino,
 		      realm, realm->seq, le64_to_cpu(ri->seq));
 		/* update realm parameters, snap lists */
 		realm->seq = le64_to_cpu(ri->seq);
@@ -849,15 +849,15 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 		rebuild_snapcs = 1;
 	} else if (!realm->cached_context) {
-		doutc(cl, "%llx %p seq %lld new\n", realm->ino, realm,
+		boutc(cl, "%llx %p seq %lld new\n", realm->ino, realm,
 		      realm->seq);
 		rebuild_snapcs = 1;
 	} else {
-		doutc(cl, "%llx %p seq %lld unchanged\n", realm->ino, realm,
+		boutc(cl, "%llx %p seq %lld unchanged\n", realm->ino, realm,
 		      realm->seq);
 	}
 
-	doutc(cl, "done with %llx %p, rebuild_snapcs=%d, %p %p\n", realm->ino,
+	boutc(cl, "done with %llx %p, rebuild_snapcs=%d, %p %p\n", realm->ino,
 	      realm, rebuild_snapcs, p, e);
 
 	/*
@@ -946,7 +946,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	struct inode *inode;
 	struct ceph_mds_session *session = NULL;
 
-	doutc(cl, "begin\n");
+	boutc(cl, "begin\n");
 	spin_lock(&mdsc->snap_flush_lock);
 	while (!list_empty(&mdsc->snap_flush_list)) {
 		ci = list_first_entry(&mdsc->snap_flush_list,
@@ -961,7 +961,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	spin_unlock(&mdsc->snap_flush_lock);
 
 	ceph_put_mds_session(session);
-	doutc(cl, "done\n");
+	boutc(cl, "done\n");
 }
 
 /**
@@ -1048,7 +1048,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	trace_len = le32_to_cpu(h->trace_len);
 	p += sizeof(*h);
 
-	doutc(cl, "from mds%d op %s split %llx tracelen %d\n", mds,
+	boutc(cl, "from mds%d op %s split %llx tracelen %d\n", mds,
 	      ceph_snap_op_name(op), split, trace_len);
 
 	down_write(&mdsc->snap_rwsem);
@@ -1080,7 +1080,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 				goto out;
 		}
 
-		doutc(cl, "splitting snap_realm %llx %p\n", realm->ino, realm);
+		boutc(cl, "splitting snap_realm %llx %p\n", realm->ino, realm);
 		for (i = 0; i < num_split_inos; i++) {
 			struct ceph_vino vino = {
 				.ino = le64_to_cpu(split_inos[i]),
@@ -1105,12 +1105,12 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 			 */
 			if (ci->i_snap_realm->created >
 			    le64_to_cpu(ri->created)) {
-				doutc(cl, " leaving %p %llx.%llx in newer realm %llx %p\n",
+				boutc(cl, " leaving %p %llx.%llx in newer realm %llx %p\n",
 				      inode, ceph_vinop(inode), ci->i_snap_realm->ino,
 				      ci->i_snap_realm);
 				goto skip_inode;
 			}
-			doutc(cl, " will move %p %llx.%llx to split realm %llx %p\n",
+			boutc(cl, " will move %p %llx.%llx to split realm %llx %p\n",
 			      inode, ceph_vinop(inode), realm->ino, realm);
 
 			ceph_get_snap_realm(mdsc, realm);
@@ -1211,7 +1211,7 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
 	}
 	spin_unlock(&mdsc->snapid_map_lock);
 	if (exist) {
-		doutc(cl, "found snapid map %llx -> %x\n", exist->snap,
+		boutc(cl, "found snapid map %llx -> %x\n", exist->snap,
 		      exist->dev);
 		return exist;
 	}
@@ -1256,12 +1256,12 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
 	if (exist) {
 		free_anon_bdev(sm->dev);
 		kfree(sm);
-		doutc(cl, "found snapid map %llx -> %x\n", exist->snap,
+		boutc(cl, "found snapid map %llx -> %x\n", exist->snap,
 		      exist->dev);
 		return exist;
 	}
 
-	doutc(cl, "create snapid map %llx -> %x\n", sm->snap, sm->dev);
+	boutc(cl, "create snapid map %llx -> %x\n", sm->snap, sm->dev);
 	return sm;
 }
 
@@ -1308,7 +1308,7 @@ void ceph_trim_snapid_map(struct ceph_mds_client *mdsc)
 	while (!list_empty(&to_free)) {
 		sm = list_first_entry(&to_free, struct ceph_snapid_map, lru);
 		list_del(&sm->lru);
-		doutc(cl, "trim snapid map %llx -> %x\n", sm->snap, sm->dev);
+		boutc(cl, "trim snapid map %llx -> %x\n", sm->snap, sm->dev);
 		free_anon_bdev(sm->dev);
 		kfree(sm);
 	}
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index ad0cf177e75a..91d7da043b0e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -46,10 +46,10 @@ static void ceph_put_super(struct super_block *s)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(s);
 
-	doutc(fsc->client, "begin\n");
+	boutc(fsc->client, "begin\n");
 	ceph_fscrypt_free_dummy_policy(fsc);
 	ceph_mdsc_close_sessions(fsc->mdsc);
-	doutc(fsc->client, "done\n");
+	boutc(fsc->client, "done\n");
 }
 
 static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -60,7 +60,7 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int i, err;
 	u64 data_pool;
 
-	doutc(fsc->client, "begin\n");
+	boutc(fsc->client, "begin\n");
 	if (fsc->mdsc->mdsmap->m_num_data_pg_pools == 1) {
 		data_pool = fsc->mdsc->mdsmap->m_data_pg_pools[0];
 	} else {
@@ -114,7 +114,7 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	/* fold the fs_cluster_id into the upper bits */
 	buf->f_fsid.val[1] = monc->fs_cluster_id;
 
-	doutc(fsc->client, "done\n");
+	boutc(fsc->client, "done\n");
 	return 0;
 }
 
@@ -124,17 +124,17 @@ static int ceph_sync_fs(struct super_block *sb, int wait)
 	struct ceph_client *cl = fsc->client;
 
 	if (!wait) {
-		doutc(cl, "(non-blocking)\n");
+		boutc(cl, "(non-blocking)\n");
 		ceph_flush_dirty_caps(fsc->mdsc);
 		ceph_flush_cap_releases(fsc->mdsc);
-		doutc(cl, "(non-blocking) done\n");
+		boutc(cl, "(non-blocking) done\n");
 		return 0;
 	}
 
-	doutc(cl, "(blocking)\n");
+	boutc(cl, "(blocking)\n");
 	ceph_osdc_sync(&fsc->client->osdc);
 	ceph_mdsc_sync(fsc->mdsc);
-	doutc(cl, "(blocking) done\n");
+	boutc(cl, "(blocking) done\n");
 	return 0;
 }
 
@@ -277,7 +277,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	const char *fsid_start, *fs_name_start;
 
 	if (*dev_name_end != '=') {
-		dout("separator '=' missing in source");
+		bout("separator '=' missing in source");
 		return -EINVAL;
 	}
 
@@ -289,7 +289,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	opts->name = kstrndup(name_start, len, GFP_KERNEL);
 	if (!opts->name)
 		return -ENOMEM;
-	dout("using %s entity name", opts->name);
+	bout("using %s entity name", opts->name);
 
 	++fsid_start; /* start of cluster fsid */
 	fs_name_start = strchr(fsid_start, '.');
@@ -308,7 +308,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	fsopt->mds_namespace = kstrndup(fs_name_start, len, GFP_KERNEL);
 	if (!fsopt->mds_namespace)
 		return -ENOMEM;
-	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
+	bout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
 
 	fsopt->new_dev_syntax = true;
 	return 0;
@@ -339,7 +339,7 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 	char *dev_name = param->string, *dev_name_end;
 	int ret;
 
-	dout("'%s'\n", dev_name);
+	bout("'%s'\n", dev_name);
 	if (!dev_name || !*dev_name)
 		return invalfc(fc, "Empty source");
 
@@ -363,16 +363,16 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 	if (dev_name_end < dev_name)
 		return invalfc(fc, "Path missing in source");
 
-	dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
+	bout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
 	if (fsopt->server_path)
-		dout("server path '%s'\n", fsopt->server_path);
+		bout("server path '%s'\n", fsopt->server_path);
 
-	dout("trying new device syntax");
+	bout("trying new device syntax");
 	ret = ceph_parse_new_source(dev_name, dev_name_end, fc);
 	if (ret) {
 		if (ret != -EINVAL)
 			return ret;
-		dout("trying old device syntax");
+		bout("trying old device syntax");
 		ret = ceph_parse_old_source(dev_name, dev_name_end, fc);
 		if (ret)
 			return ret;
@@ -411,7 +411,7 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		return ret;
 
 	token = fs_parse(fc, ceph_mount_parameters, param, &result);
-	dout("%s: fs_parse '%s' token %d\n",__func__, param->key, token);
+	bout("%s: fs_parse '%s' token %d\n",__func__, param->key, token);
 	if (token < 0)
 		return token;
 
@@ -617,7 +617,7 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 
 static void destroy_mount_options(struct ceph_mount_options *args)
 {
-	dout("destroy_mount_options %p\n", args);
+	bout("destroy_mount_options %p\n", args);
 	if (!args)
 		return;
 
@@ -881,7 +881,7 @@ static void flush_fs_workqueues(struct ceph_fs_client *fsc)
 
 static void destroy_fs_client(struct ceph_fs_client *fsc)
 {
-	doutc(fsc->client, "%p\n", fsc);
+	boutc(fsc->client, "%p\n", fsc);
 
 	spin_lock(&ceph_fsc_lock);
 	list_del(&fsc->metric_wakeup);
@@ -896,7 +896,7 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
 	ceph_destroy_client(fsc->client);
 
 	kfree(fsc);
-	dout("%s: %p done\n", __func__, fsc);
+	bout("%s: %p done\n", __func__, fsc);
 }
 
 /*
@@ -1018,7 +1018,7 @@ void ceph_umount_begin(struct super_block *sb)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
 
-	doutc(fsc->client, "starting forced umount\n");
+	boutc(fsc->client, "starting forced umount\n");
 
 	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
 	__ceph_umount_begin(fsc);
@@ -1052,7 +1052,7 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
 	struct dentry *root;
 
 	/* open dir */
-	doutc(cl, "opening '%s'\n", path);
+	boutc(cl, "opening '%s'\n", path);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
 	if (IS_ERR(req))
 		return ERR_CAST(req);
@@ -1072,13 +1072,13 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
 	if (err == 0) {
 		struct inode *inode = req->r_target_inode;
 		req->r_target_inode = NULL;
-		doutc(cl, "success\n");
+		boutc(cl, "success\n");
 		root = d_make_root(inode);
 		if (!root) {
 			root = ERR_PTR(-ENOMEM);
 			goto out;
 		}
-		doutc(cl, "success, root dentry is %p\n", root);
+		boutc(cl, "success, root dentry is %p\n", root);
 	} else {
 		root = ERR_PTR(err);
 	}
@@ -1142,7 +1142,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
 	unsigned long started = jiffies;  /* note the start time */
 	struct dentry *root;
 
-	doutc(cl, "mount start %p\n", fsc);
+	boutc(cl, "mount start %p\n", fsc);
 	mutex_lock(&fsc->client->mount_mutex);
 
 	if (!fsc->sb->s_root) {
@@ -1165,7 +1165,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
 		if (err)
 			goto out;
 
-		doutc(cl, "mount opening path '%s'\n", path);
+		boutc(cl, "mount opening path '%s'\n", path);
 
 		ceph_fs_debugfs_init(fsc);
 
@@ -1180,7 +1180,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
 	}
 
 	fsc->mount_state = CEPH_MOUNT_MOUNTED;
-	doutc(cl, "mount success\n");
+	boutc(cl, "mount success\n");
 	mutex_unlock(&fsc->client->mount_mutex);
 	return root;
 
@@ -1196,7 +1196,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
 	struct ceph_client *cl = fsc->client;
 	int ret;
 
-	doutc(cl, "%p\n", s);
+	boutc(cl, "%p\n", s);
 
 	s->s_maxbytes = MAX_LFS_FILESIZE;
 
@@ -1233,29 +1233,29 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
 	struct ceph_client *cl = fsc->client;
 
-	doutc(cl, "%p\n", sb);
+	boutc(cl, "%p\n", sb);
 
 	if (compare_mount_options(fsopt, opt, fsc)) {
-		doutc(cl, "monitor(s)/mount options don't match\n");
+		boutc(cl, "monitor(s)/mount options don't match\n");
 		return 0;
 	}
 	if ((opt->flags & CEPH_OPT_FSID) &&
 	    ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
-		doutc(cl, "fsid doesn't match\n");
+		boutc(cl, "fsid doesn't match\n");
 		return 0;
 	}
 	if (fc->sb_flags != (sb->s_flags & ~SB_BORN)) {
-		doutc(cl, "flags differ\n");
+		boutc(cl, "flags differ\n");
 		return 0;
 	}
 
 	if (fsc->blocklisted && !ceph_test_mount_opt(fsc, CLEANRECOVER)) {
-		doutc(cl, "client is blocklisted (and CLEANRECOVER is not set)\n");
+		boutc(cl, "client is blocklisted (and CLEANRECOVER is not set)\n");
 		return 0;
 	}
 
 	if (fsc->mount_state == CEPH_MOUNT_SHUTDOWN) {
-		doutc(cl, "client has been forcibly unmounted\n");
+		boutc(cl, "client has been forcibly unmounted\n");
 		return 0;
 	}
 
@@ -1296,7 +1296,7 @@ static int ceph_get_tree(struct fs_context *fc)
 		ceph_compare_super;
 	int err;
 
-	dout("ceph_get_tree\n");
+	bout("ceph_get_tree\n");
 
 	if (!fc->source)
 		return invalfc(fc, "No source");
@@ -1330,9 +1330,9 @@ static int ceph_get_tree(struct fs_context *fc)
 	if (ceph_sb_to_fs_client(sb) != fsc) {
 		destroy_fs_client(fsc);
 		fsc = ceph_sb_to_fs_client(sb);
-		dout("get_sb got existing client %p\n", fsc);
+		bout("get_sb got existing client %p\n", fsc);
 	} else {
-		dout("get_sb using new client %p\n", fsc);
+		bout("get_sb using new client %p\n", fsc);
 		err = ceph_setup_bdi(sb, fsc);
 		if (err < 0)
 			goto out_splat;
@@ -1344,7 +1344,7 @@ static int ceph_get_tree(struct fs_context *fc)
 		goto out_splat;
 	}
 
-	doutc(fsc->client, "root %p inode %p ino %llx.%llx\n", res,
+	boutc(fsc->client, "root %p inode %p ino %llx.%llx\n", res,
 		    d_inode(res), ceph_vinop(d_inode(res)));
 	fc->root = fsc->sb->s_root;
 	return 0;
@@ -1362,7 +1362,7 @@ static int ceph_get_tree(struct fs_context *fc)
 out:
 	destroy_fs_client(fsc);
 out_final:
-	dout("ceph_get_tree fail %d\n", err);
+	bout("ceph_get_tree fail %d\n", err);
 	return err;
 }
 
@@ -1528,7 +1528,7 @@ static void ceph_kill_sb(struct super_block *s)
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	bool wait;
 
-	doutc(cl, "%p\n", s);
+	boutc(cl, "%p\n", s);
 
 	ceph_mdsc_pre_umount(mdsc);
 	flush_fs_workqueues(fsc);
@@ -1646,7 +1646,7 @@ static int __init init_ceph(void)
 
 static void __exit exit_ceph(void)
 {
-	dout("exit_ceph\n");
+	bout("exit_ceph\n");
 	unregister_filesystem(&ceph_fs_type);
 	destroy_caches();
 }
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 537165db4519..fb04bd5b1c22 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -70,7 +70,7 @@ static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 
 	pool_ns = ceph_try_get_string(ci->i_layout.pool_ns);
 
-	doutc(cl, "%p\n", &ci->netfs.inode);
+	boutc(cl, "%p\n", &ci->netfs.inode);
 	down_read(&osdc->lock);
 	pool_name = ceph_pg_pool_name_by_id(osdc->osdmap, pool);
 	if (pool_name) {
@@ -629,7 +629,7 @@ static int __set_xattr(struct ceph_inode_info *ci,
 		xattr->should_free_name = update_xattr;
 
 		ci->i_xattrs.count++;
-		doutc(cl, "count=%d\n", ci->i_xattrs.count);
+		boutc(cl, "count=%d\n", ci->i_xattrs.count);
 	} else {
 		kfree(*newxattr);
 		*newxattr = NULL;
@@ -657,10 +657,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
 	if (new) {
 		rb_link_node(&xattr->node, parent, p);
 		rb_insert_color(&xattr->node, &ci->i_xattrs.index);
-		doutc(cl, "p=%p\n", p);
+		boutc(cl, "p=%p\n", p);
 	}
 
-	doutc(cl, "added %p %llx.%llx xattr %p %.*s=%.*s%s\n", inode,
+	boutc(cl, "added %p %llx.%llx xattr %p %.*s=%.*s%s\n", inode,
 	      ceph_vinop(inode), xattr, name_len, name, min(val_len,
 	      MAX_XATTR_VAL_PRINT_LEN), val,
 	      val_len > MAX_XATTR_VAL_PRINT_LEN ? "..." : "");
@@ -692,13 +692,13 @@ static struct ceph_inode_xattr *__get_xattr(struct ceph_inode_info *ci,
 		else {
 			int len = min(xattr->val_len, MAX_XATTR_VAL_PRINT_LEN);
 
-			doutc(cl, "%s found %.*s%s\n", name, len, xattr->val,
+			boutc(cl, "%s found %.*s%s\n", name, len, xattr->val,
 			      xattr->val_len > len ? "..." : "");
 			return xattr;
 		}
 	}
 
-	doutc(cl, "%s not found\n", name);
+	boutc(cl, "%s not found\n", name);
 
 	return NULL;
 }
@@ -744,14 +744,14 @@ static char *__copy_xattr_names(struct ceph_inode_info *ci,
 	struct ceph_inode_xattr *xattr = NULL;
 
 	p = rb_first(&ci->i_xattrs.index);
-	doutc(cl, "count=%d\n", ci->i_xattrs.count);
+	boutc(cl, "count=%d\n", ci->i_xattrs.count);
 
 	while (p) {
 		xattr = rb_entry(p, struct ceph_inode_xattr, node);
 		memcpy(dest, xattr->name, xattr->name_len);
 		dest[xattr->name_len] = '\0';
 
-		doutc(cl, "dest=%s %p (%s) (%d/%d)\n", dest, xattr, xattr->name,
+		boutc(cl, "dest=%s %p (%s) (%d/%d)\n", dest, xattr, xattr->name,
 		      xattr->name_len, ci->i_xattrs.names_size);
 
 		dest += xattr->name_len + 1;
@@ -769,13 +769,13 @@ void __ceph_destroy_xattrs(struct ceph_inode_info *ci)
 
 	p = rb_first(&ci->i_xattrs.index);
 
-	doutc(cl, "p=%p\n", p);
+	boutc(cl, "p=%p\n", p);
 
 	while (p) {
 		xattr = rb_entry(p, struct ceph_inode_xattr, node);
 		tmp = p;
 		p = rb_next(tmp);
-		doutc(cl, "next p=%p (%.*s)\n", p, xattr->name_len, xattr->name);
+		boutc(cl, "next p=%p (%.*s)\n", p, xattr->name_len, xattr->name);
 		rb_erase(tmp, &ci->i_xattrs.index);
 
 		__free_xattr(xattr);
@@ -804,7 +804,7 @@ static int __build_xattrs(struct inode *inode)
 	int err = 0;
 	int i;
 
-	doutc(cl, "len=%d\n",
+	boutc(cl, "len=%d\n",
 	      ci->i_xattrs.blob ? (int)ci->i_xattrs.blob->vec.iov_len : 0);
 
 	if (ci->i_xattrs.index_version >= ci->i_xattrs.version)
@@ -889,7 +889,7 @@ static int __get_required_blob_size(struct ceph_inode_info *ci, int name_size,
 	int size = 4 + ci->i_xattrs.count*(4 + 4) +
 			     ci->i_xattrs.names_size +
 			     ci->i_xattrs.vals_size;
-	doutc(cl, "c=%d names.size=%d vals.size=%d\n", ci->i_xattrs.count,
+	boutc(cl, "c=%d names.size=%d vals.size=%d\n", ci->i_xattrs.count,
 	      ci->i_xattrs.names_size, ci->i_xattrs.vals_size);
 
 	if (name_size)
@@ -913,7 +913,7 @@ struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci)
 	struct ceph_buffer *old_blob = NULL;
 	void *dest;
 
-	doutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
+	boutc(cl, "%p %llx.%llx\n", inode, ceph_vinop(inode));
 	if (ci->i_xattrs.dirty) {
 		int need = __get_required_blob_size(ci, 0, 0);
 
@@ -1010,7 +1010,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	req_mask = __get_request_mask(inode);
 
 	spin_lock(&ci->i_ceph_lock);
-	doutc(cl, "%p %llx.%llx name '%s' ver=%lld index_ver=%lld\n", inode,
+	boutc(cl, "%p %llx.%llx name '%s' ver=%lld index_ver=%lld\n", inode,
 	      ceph_vinop(inode), name, ci->i_xattrs.version,
 	      ci->i_xattrs.index_version);
 
@@ -1072,7 +1072,7 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
 	int err;
 
 	spin_lock(&ci->i_ceph_lock);
-	doutc(cl, "%p %llx.%llx ver=%lld index_ver=%lld\n", inode,
+	boutc(cl, "%p %llx.%llx ver=%lld index_ver=%lld\n", inode,
 	      ceph_vinop(inode), ci->i_xattrs.version,
 	      ci->i_xattrs.index_version);
 
@@ -1134,7 +1134,7 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
 			flags |= CEPH_XATTR_REMOVE;
 	}
 
-	doutc(cl, "name %s value size %zu\n", name, size);
+	boutc(cl, "name %s value size %zu\n", name, size);
 
 	/* do request */
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
@@ -1163,10 +1163,10 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
 	req->r_num_caps = 1;
 	req->r_inode_drop = CEPH_CAP_XATTR_SHARED;
 
-	doutc(cl, "xattr.ver (before): %lld\n", ci->i_xattrs.version);
+	boutc(cl, "xattr.ver (before): %lld\n", ci->i_xattrs.version);
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
 	ceph_mdsc_put_request(req);
-	doutc(cl, "xattr.ver (after): %lld\n", ci->i_xattrs.version);
+	boutc(cl, "xattr.ver (after): %lld\n", ci->i_xattrs.version);
 
 out:
 	if (pagelist)
@@ -1236,7 +1236,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 	required_blob_size = __get_required_blob_size(ci, name_len, val_len);
 	if ((ci->i_xattrs.version == 0) || !(issued & CEPH_CAP_XATTR_EXCL) ||
 	    (required_blob_size > mdsc->mdsmap->m_max_xattr_size)) {
-		doutc(cl, "sync version: %llu size: %d max: %llu\n",
+		boutc(cl, "sync version: %llu size: %d max: %llu\n",
 		      ci->i_xattrs.version, required_blob_size,
 		      mdsc->mdsmap->m_max_xattr_size);
 		goto do_sync;
@@ -1252,7 +1252,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 		}
 	}
 
-	doutc(cl, "%p %llx.%llx name '%s' issued %s\n", inode,
+	boutc(cl, "%p %llx.%llx name '%s' issued %s\n", inode,
 	      ceph_vinop(inode), name, ceph_cap_string(issued));
 	__build_xattrs(inode);
 
@@ -1262,7 +1262,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 
 		spin_unlock(&ci->i_ceph_lock);
 		ceph_buffer_put(old_blob); /* Shouldn't be required */
-		doutc(cl, " pre-allocating new blob size=%d\n",
+		boutc(cl, " pre-allocating new blob size=%d\n",
 		      required_blob_size);
 		blob = ceph_buffer_new(required_blob_size, GFP_NOFS);
 		if (!blob)
diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
index 5f904591fa5f..fadf9e18754b 100644
--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -19,7 +19,7 @@
 	pr_debug("%.*s %12.12s:%-4d : " fmt,				\
 		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
 		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
-#  define doutc(client, fmt, ...)					\
+#  define boutc(client, fmt, ...)					\
 	pr_debug("%.*s %12.12s:%-4d : [%pU %llu] " fmt,			\
 		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
 		 kbasename(__FILE__), __LINE__,				\
@@ -29,7 +29,7 @@
 /* faux printk call just to see any compiler warnings. */
 #  define dout(fmt, ...)					\
 		no_printk(KERN_DEBUG fmt, ##__VA_ARGS__)
-#  define doutc(client, fmt, ...)				\
+#  define boutc(client, fmt, ...)				\
 		no_printk(KERN_DEBUG "[%pU %llu] " fmt,		\
 			  &client->fsid,			\
 			  client->monc.auth->global_id,		\
@@ -42,7 +42,7 @@
  * or, just wrap pr_debug
  */
 # define dout(fmt, ...)	pr_debug(" " fmt, ##__VA_ARGS__)
-# define doutc(client, fmt, ...)					\
+# define boutc(client, fmt, ...)					\
 	pr_debug(" [%pU %llu] %s: " fmt, &client->fsid,			\
 		 client->monc.auth->global_id, __func__, ##__VA_ARGS__)
 
-- 
2.34.1


