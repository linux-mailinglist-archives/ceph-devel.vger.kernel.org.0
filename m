Return-Path: <ceph-devel+bounces-1817-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AED197ED9C
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Sep 2024 17:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C64B281DCF
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Sep 2024 15:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B29A19D093;
	Mon, 23 Sep 2024 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkrWtsyQ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C8D14A08D
	for <ceph-devel@vger.kernel.org>; Mon, 23 Sep 2024 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727104097; cv=none; b=bMYf85Ft1t19hQpgianwxFSeSvKA+tFWYKMLloU+8l00sLvpnjDiO8EK7FufqgHBJbtBgBH0fjLLkHtMIeXguwN8RAckInOIRUP1mi6dYjg9mCWqj1CUZCvMTUOvJXYkeDJsdAVWo1TNiu+QVgo2MfihuBQ1agGnp1P4v5ITpOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727104097; c=relaxed/simple;
	bh=/GNlxMRLpq91WxvczmAyf92nZZLDG814e6S03oDyT64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R8qtGo6u21F5JXChdZ+O6sfRpCPhIxxh71DXhYpbqNANFAt3mCeWjgPLQRfk+ejZ2urJxqWZG2g4OiJzlbkUIO0FQ7QwFIsTCUAwR9jymIZ+0bMo4KV0eSh93wAbFDkCpMhI8ir70vr33WHaR7NDsBnwxKUw+FJDXD/1+L1xqP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkrWtsyQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727104094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=deDp5fXNcCneGmSM6E3aF14XvR7SODlrONWVXGCHh5M=;
	b=fkrWtsyQri3M4rRt79ynI8bBFKN3dr0J+jfuubN+wB11jRmEICglYF4lKAhSoVBD2zFqYt
	XB62BnlVGXrWMzsCSwG+T2WW+TZVX3Pn9rHYBFPkumAi1H9GKbxtzGj2diI6hzimSlqg03
	PRS4mRLibwmODEN3WrKbCIpfGFZx0Dw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-4y-C8U9DPSq2ZrlXAofqpQ-1; Mon,
 23 Sep 2024 11:08:09 -0400
X-MC-Unique: 4y-C8U9DPSq2ZrlXAofqpQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29E0C18EB2E2;
	Mon, 23 Sep 2024 15:08:06 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.145])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1ACE8194328E;
	Mon, 23 Sep 2024 15:07:59 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <sfrench@samba.org>,
	Marc Dionne <marc.dionne@auristor.com>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
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
Subject: [PATCH 0/8] netfs, afs, cifs: Miscellaneous fixes/changes
Date: Mon, 23 Sep 2024 16:07:44 +0100
Message-ID: <20240923150756.902363-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Christian, Steve, Marc,

Here are some miscellaneous fixes and changes for netfslib and the afs and
cifs filesystems, some of which are already in the vfs or cifs trees, but I
thought I'd repost them all for completeness, starting with netfs:

 (1) Fix the update of mtime and ctime for mmapped files.

 (2) Drop the was_async argument from netfs_read_subreq_terminated().

then afs:

 (3) Wire up afs_retry_request() so that writeback rotates through the
     available keys.

 (4) Remove some unused defs.

 (5) Fix a potential infinite loop in the server rotation code.

 (6) Fix an oops that can occur when a server responds, but we decide the
     operation failed (e.g. an abort).

and then cifs:

 (7) Fix reversion of the I/O iterator causing cryptographically signed
     transport reception to fail.

 (8) Alter the write tracepoints to display netfs request info.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

David Howells (6):
  netfs: Fix mtime/ctime update for mmapped writes
  netfs: Drop the was_async arg from netfs_read_subreq_terminated()
  afs: Fix missing wire-up of afs_retry_request()
  afs: Fix the setting of the server responding flag
  cifs: Fix reversion of the iter in cifs_readv_receive().
  cifs: Make the write_{enter,done,err} tracepoints display netfs info

Marc Dionne (1):
  afs: Fix possible infinite loop with unresponsive servers

Thorsten Blum (1):
  afs: Remove unused struct and function prototype

 fs/9p/vfs_addr.c          |  3 +-
 fs/afs/afs_vl.h           |  9 ----
 fs/afs/file.c             | 16 ++++---
 fs/afs/fs_operation.c     |  2 +-
 fs/afs/fs_probe.c         |  4 +-
 fs/afs/fsclient.c         |  2 +-
 fs/afs/rotate.c           | 11 +++--
 fs/afs/yfsclient.c        |  2 +-
 fs/ceph/addr.c            | 13 ++++--
 fs/netfs/buffered_read.c  | 16 +++----
 fs/netfs/buffered_write.c |  1 +
 fs/netfs/direct_read.c    |  2 +-
 fs/netfs/internal.h       |  2 +-
 fs/netfs/objects.c        | 17 ++++++-
 fs/netfs/read_collect.c   | 95 ++++++++++++++++-----------------------
 fs/netfs/read_retry.c     |  2 +-
 fs/nfs/fscache.c          |  6 ++-
 fs/nfs/fscache.h          |  3 +-
 fs/smb/client/cifssmb.c   | 10 +----
 fs/smb/client/connect.c   |  6 +--
 fs/smb/client/file.c      |  3 +-
 fs/smb/client/smb2ops.c   |  9 ++--
 fs/smb/client/smb2pdu.c   | 32 ++++++-------
 fs/smb/client/trace.h     |  6 +--
 fs/smb/client/transport.c |  3 --
 include/linux/netfs.h     |  7 ++-
 26 files changed, 139 insertions(+), 143 deletions(-)


