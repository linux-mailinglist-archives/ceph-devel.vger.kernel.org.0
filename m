Return-Path: <ceph-devel+bounces-1773-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D4171963364
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2024 23:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F5C4B21164
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2024 21:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEA71ACDE6;
	Wed, 28 Aug 2024 21:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dTa//KC8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D449A1AC437
	for <ceph-devel@vger.kernel.org>; Wed, 28 Aug 2024 21:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724878992; cv=none; b=E7BA83exfX7rHdjAHD1K86WaRpoQGLQengjmHCDE0y57g/FBd+LaqFlE3PuSiliQ3dntZ7Dw/aTKm8ae12MGwjAkU81tZiwx5Mk8MXGsRkLRD4K/LnZ+TlvXlapzRzDYMoNM8qk2gjy2frnG/0Tqo2S3EqiFh781mitue6FbKx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724878992; c=relaxed/simple;
	bh=VV17+nS8C1q2KfvL5zDpbmlRmgEDHZV0Gqx+Dv4LhVM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p1i/cCOpegVcX3xx3XDBlMqBuKG/ohzSNi+NYkYQ46WemDajnK0CghOQDezgyzwbJ+yVp02i2FMSHzgGNWOhkPd0zTls138htEuTZhrqkvQfQ0YG0N2U2vte3Pfxj4PB8tut7lInAlChr1/nFDfj4moduRuswoJvkG5g0kDo6SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dTa//KC8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724878989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XFobmMcyik8XghRtkh2gK9+MeaxVAEEC6pZ/c4IMu/w=;
	b=dTa//KC87CEVLTQiBjAHqViZFy2jVuiZowN/osivePWnBch4xS8h8uwHnf4cu8LfiXEdnx
	DtLq2fYZF45TCSiA6TPk838jML6iMgfOHsV4ZsrkPWThYlmG7kEmCC82L+d6lhxqeFd49b
	OwNV2LM+RzJ8jpv7DegHZkDq51wJfwQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-pWU2m7E2O3W_VVpN-j_iRQ-1; Wed,
 28 Aug 2024 17:03:04 -0400
X-MC-Unique: pWU2m7E2O3W_VVpN-j_iRQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 413511955D47;
	Wed, 28 Aug 2024 21:03:00 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.30])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8C48D1955BED;
	Wed, 28 Aug 2024 21:02:53 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
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
Subject: [PATCH 0/6] mm, netfs, cifs: Miscellaneous fixes
Date: Wed, 28 Aug 2024 22:02:41 +0100
Message-ID: <20240828210249.1078637-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Christian, Steve,

Firstly, here are some fixes to DIO read handling and the retrying of
reads, particularly in relation to cifs:

 (1) Fix the missing credit renegotiation in cifs on the retrying of reads.
     The credits we had ended with the original read (or the last retry)
     and to perform a new read we need more credits otherwise the server
     can reject our read with EINVAL.

 (2) Fix the handling of short DIO reads to avoid ENODATA when the read
     retry tries to access a portion of the file after the EOF.

Secondly, some patches fixing cifs copy and zero offload:

 (3) Fix cifs_file_copychunk_range() to not try to partially invalidate
     folios that are only partly covered by the range, but rather flush
     them back and invalidate them.

 (4) Fix filemap_invalidate_inode() to use the correct invalidation
     function so that it doesn't leave partially invalidated folios hanging
     around (which may hide part of the result of an offloaded copy).

 (5) Fix smb3_zero_data() to correctly handle zeroing of data that's
     buffered locally but not yet written back and with the EOF position on
     the server short of the local EOF position.

     Note that this will also affect afs and 9p, particularly with regard
     to direct I/O writes.

And finally, here's an adjustment to debugging statements:

 (6) Adjust three debugging output statements.  Not strictly a fix, so
     could be dropped.  Including the subreq ID in some extra debug lines
     helps a bit, though.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

David Howells (6):
  cifs: Fix lack of credit renegotiation on read retry
  netfs, cifs: Fix handling of short DIO read
  cifs: Fix copy offload to flush destination region
  mm: Fix filemap_invalidate_inode() to use
    invalidate_inode_pages2_range()
  cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target
    region
  netfs, cifs: Improve some debugging bits

 fs/netfs/io.c            | 21 +++++++++++++-------
 fs/smb/client/cifsfs.c   | 21 ++++----------------
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 37 ++++++++++++++++++++++++++++++++----
 fs/smb/client/smb2ops.c  | 26 +++++++++++++++++++------
 fs/smb/client/smb2pdu.c  | 41 +++++++++++++++++++++++++---------------
 fs/smb/client/trace.h    |  1 +
 include/linux/netfs.h    |  1 +
 mm/filemap.c             |  2 +-
 9 files changed, 101 insertions(+), 50 deletions(-)


