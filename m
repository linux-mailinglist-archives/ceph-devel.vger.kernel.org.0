Return-Path: <ceph-devel+bounces-1732-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2484C95D2C1
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2024 18:13:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55F081C2338E
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2024 16:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE4B0189BB8;
	Fri, 23 Aug 2024 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iFHqCbKo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA94F18F2DD
	for <ceph-devel@vger.kernel.org>; Fri, 23 Aug 2024 16:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724429544; cv=none; b=O6jSfvWN9cKaj6qOjSl7brod7gQVwozxknKxfMqRzbdZHdskvOWy7BtJbzrkI2J03+TDjcRVHksaERiGEx+I6MlnRD2nTHw2im5IG8P6QFeYMrh7R+a6CKzfYJZ+1l5uCe3xuOVW6/BjAMZL4KXCadBKGeKFHOX9mkZDSs773Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724429544; c=relaxed/simple;
	bh=YhI6CxlWCORlDxctY9pY5VBmdy/ejL3oCVkww5SRZNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mJxoLTpueeGhlbHHQsHZD/FjsdRSa3BXpXj6VxKZsIBxJVpmpA5CGjDjUugXzQQlNWQ2gzBdDApqwFbpiPEu8FzpH1OLRN6iwxG9thoaPdnPvDCSRBhBFsz2nDJjhX2YubdFdtaMp3GELi+jKq3cS85iQBOx2zxSrnwdGkQxOaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iFHqCbKo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724429541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HWel4fAjhn1F/3o1FewTt4dI8XNtgDdoQ8ZZC3V8mew=;
	b=iFHqCbKooy+RLm6qP5xxbEstZFxbXgEONALenoW9ptmN7jrpHg617tFNZ0BfEKpljSiMi6
	iPkJ8n2qs+vFNfrNyhGxsFGCyfk/g0GNhIKt5PmeN00eF50nBGEIXW5oAoqwNLU/cpc4ib
	Hs3wRQHMprnKNsJUHKlyv9UclLWm3DI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-pE1nOUCvOMGmvIxiOZwJjA-1; Fri,
 23 Aug 2024 12:12:19 -0400
X-MC-Unique: pE1nOUCvOMGmvIxiOZwJjA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6137B1954B06;
	Fri, 23 Aug 2024 16:12:16 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.30])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 047D71955F41;
	Fri, 23 Aug 2024 16:12:11 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
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
Subject: [PATCH 0/5] netfs, cifs: Further fixes
Date: Fri, 23 Aug 2024 17:12:01 +0100
Message-ID: <20240823161209.434705-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi Christian, Steve,

Here are some more fixes to cifs and one to netfs:

 (1) Fix cifs FALLOC_FL_PUNCH_HOLE support as best I can.  If it's going to
     punch a hole in dirty data in the pagecacne, invalidating that data
     may result in the EOF not being moved correctly.  The set-zero and the
     eof-move RPC ops really need compounding to avoid third-party
     interference.

 (2) Adjust three debugging output statements.  Not strictly a fix, so
     could be dropped.  Including the subreq ID in some extra debug lines
     helps a bit, though.

 (3) Fix netfslib's short read retry to reset the buffer iterator otherwise
     the wrong part of the buffer may get written on.

 (4) Further fix the early EOF detection in cifs read.

 (5) Further fixes for cifs credit handling.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

David Howells (5):
  cifs: Fix FALLOC_FL_PUNCH_HOLE support
  netfs, cifs: Improve some debugging bits
  netfs: Fix missing iterator reset on retry of short read
  cifs: Fix short read handling
  cifs: Fix credit handling

 fs/netfs/io.c           |  3 ++-
 fs/smb/client/file.c    |  9 +++++++++
 fs/smb/client/smb2ops.c | 34 ++++++++++++++++++++++++++++++----
 fs/smb/client/smb2pdu.c | 12 ++----------
 fs/smb/client/trace.h   |  1 +
 5 files changed, 44 insertions(+), 15 deletions(-)


