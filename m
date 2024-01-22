Return-Path: <ceph-devel+bounces-636-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 433CC83763B
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 23:34:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD4C0B22FF5
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 22:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5761738FB3;
	Mon, 22 Jan 2024 22:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OMtH8mAR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F80D38F95
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 22:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705962771; cv=none; b=hFkvxYV9mN2Z8SMcCAz0moqET7cgENC0MjwMaVeGrc7BBs2RNd2JA85H3QT1yfW/kPrvAQFcypmTW5IiHlfApbT2A5kliOQMbKrHHococGjrMC/B3RUXHPbv+sQM7dpVUFTVmz/HzTNQM3l/vGqT4K+qfwONyQCdbuu0N0GXzVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705962771; c=relaxed/simple;
	bh=dBNU2+LVkE55FYFG/WjTfMApHZmROR3sCYtSv/humlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMeNFKh1fOoa2q8rHaLJZGvM6yJgduMkLFa+DZmHet8zLl/KepN4RGFqtjswA/Plr2DCvj5/suEvlfX/Z9dCPW/FjI5c431yOn7FCdX0Whb12Eqo3ehge1Xu49RCHj2EfW/Ka8/SIwu2RvJhSoNv/pCVbIT6kLvNfW/vR1fjcE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OMtH8mAR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705962768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+7nRZBtb5KDB8wnGQb/hos72IWYUGI+6olZnmjBvpQE=;
	b=OMtH8mARUbRsQh9mqRxr/WSxUJbCh1mT7IMbyaqmuyYFRa4TGPN57OvUUztYQHA5qOaGOW
	jOFYxz7MCuSfYf0oeGlNHwh+9OYaM2UxPLaQxAxVxdpllHJBtfF6Gp5f09G3lXYwHFa1yO
	9D4UX0J44nya4kSlLlLlt3XwpWJJ4TE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-212-Tq0oefjDMG-ND3l08DWx1w-1; Mon,
 22 Jan 2024 17:32:43 -0500
X-MC-Unique: Tq0oefjDMG-ND3l08DWx1w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 419341C04181;
	Mon, 22 Jan 2024 22:32:42 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C03651121312;
	Mon, 22 Jan 2024 22:32:39 +0000 (UTC)
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
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 03/10] cifs: Don't use certain unnecessary folio_*() functions
Date: Mon, 22 Jan 2024 22:32:16 +0000
Message-ID: <20240122223230.4000595-4-dhowells@redhat.com>
In-Reply-To: <20240122223230.4000595-1-dhowells@redhat.com>
References: <20240122223230.4000595-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Filesystems should use folio->index and folio->mapping, instead of
folio_index(folio), folio_mapping() and folio_file_mapping() since
they know that it's in the pagecache.

Change this automagically with:

perl -p -i -e 's/folio_mapping[(]([^)]*)[)]/\1->mapping/g' fs/smb/client/*.c
perl -p -i -e 's/folio_file_mapping[(]([^)]*)[)]/\1->mapping/g' fs/smb/client/*.c
perl -p -i -e 's/folio_index[(]([^)]*)[)]/\1->index/g' fs/smb/client/*.c

Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Ronnie Sahlberg <lsahlber@redhat.com>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 3a213432775b..90da81d0372a 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -87,7 +87,7 @@ void cifs_pages_written_back(struct inode *inode, loff_t start, unsigned int len
 			continue;
 		if (!folio_test_writeback(folio)) {
 			WARN_ONCE(1, "bad %x @%llx page %lx %lx\n",
-				  len, start, folio_index(folio), end);
+				  len, start, folio->index, end);
 			continue;
 		}
 
@@ -120,7 +120,7 @@ void cifs_pages_write_failed(struct inode *inode, loff_t start, unsigned int len
 			continue;
 		if (!folio_test_writeback(folio)) {
 			WARN_ONCE(1, "bad %x @%llx page %lx %lx\n",
-				  len, start, folio_index(folio), end);
+				  len, start, folio->index, end);
 			continue;
 		}
 
@@ -151,7 +151,7 @@ void cifs_pages_write_redirty(struct inode *inode, loff_t start, unsigned int le
 	xas_for_each(&xas, folio, end) {
 		if (!folio_test_writeback(folio)) {
 			WARN_ONCE(1, "bad %x @%llx page %lx %lx\n",
-				  len, start, folio_index(folio), end);
+				  len, start, folio->index, end);
 			continue;
 		}
 
@@ -2651,7 +2651,7 @@ static void cifs_extend_writeback(struct address_space *mapping,
 				continue;
 			if (xa_is_value(folio))
 				break;
-			if (folio_index(folio) != index)
+			if (folio->index != index)
 				break;
 			if (!folio_try_get_rcu(folio)) {
 				xas_reset(&xas);
@@ -2899,7 +2899,7 @@ static int cifs_writepages_region(struct address_space *mapping,
 					goto skip_write;
 			}
 
-			if (folio_mapping(folio) != mapping ||
+			if (folio->mapping != mapping ||
 			    !folio_test_dirty(folio)) {
 				start += folio_size(folio);
 				folio_unlock(folio);


