Return-Path: <ceph-devel+bounces-2650-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 69036A33274
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2025 23:24:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 517367A0827
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2025 22:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A30F250BF8;
	Wed, 12 Feb 2025 22:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OzGeSb2E"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E68020FA85
	for <ceph-devel@vger.kernel.org>; Wed, 12 Feb 2025 22:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739399066; cv=none; b=OjDQnX7KgCm/Ff0YsZcvJ1O2cZXOOa+tcXj05P8emd78EqwGn1rlEiOuHUFnM6BUSlgdABZ4meRJ5d95vEvyzOitdEyb8xQ4bMgSJvL8pRz/rvnMfzAumOonWpEWhzg/f5GJhfDzshd7lbKq9Vw0uVctmMgxl1g2VCiitrbpEi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739399066; c=relaxed/simple;
	bh=o9Rvw5bGAnROKjad7sMpqrfxb3P+iaNsiQvl674qxYA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FKYtDb2CJ93n5CDIQnzmBc0ejjdr8OhWDXlEN2qxUpjL2mejMBAsTKkpMOfxIlTOqqJdFNOVUp7YJhsYpo9voHfroN1wRS469d0/znX1VN0ABcDeO+ml/BTabd1pB9gTMiemeaiwvdRCamAFPggknOxwS27FSvaT+bEDjsPUmDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OzGeSb2E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739399063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=j/hFCuHm3dQy3yCXNlW7/z5EXWgYM+xOP2nJGIBn15Q=;
	b=OzGeSb2EkLPMNfsX22SHdGiiBgTHM5kdZ5teqBvsEHe4MNjoHWNXGzKlpGT3Q5188sbV0n
	4JJwkMOYAq/B/C1/dX/wNhVHrLhz/o9LQVYMmGVEMUkdBeRhb7ggH62eLLgtAh+/WqYwZJ
	r3osx30Eb5nUsOguZAh5VyCTSRP31us=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-iPLvlH5hPsCaSV9rKTnwgQ-1; Wed,
 12 Feb 2025 17:24:18 -0500
X-MC-Unique: iPLvlH5hPsCaSV9rKTnwgQ-1
X-Mimecast-MFC-AGG-ID: iPLvlH5hPsCaSV9rKTnwgQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25E25180087B;
	Wed, 12 Feb 2025 22:24:13 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.92])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CBFAE19560A3;
	Wed, 12 Feb 2025 22:24:05 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Max Kellermann <max.kellermann@ionos.com>,
	Steve French <sfrench@samba.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeff Layton <jlayton@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
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
Subject: [PATCH 0/3] netfs: Miscellaneous fixes
Date: Wed, 12 Feb 2025 22:23:58 +0000
Message-ID: <20250212222402.3618494-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi Christian,

Here are some miscellaneous fixes and changes for netfslib, if you could
pull them:

 (1) Fix a number of read-retry hangs, including:

     (a) Incorrect getting/putting of references on subreqs as we retry
     	 them.

     (b) Failure to track whether a last old subrequest in a retried set is
     	 superfluous.

     (c) Inconsistency in the usage of wait queues used for subrequests
     	 (ie. using clear_and_wake_up_bit() whilst waiting on a private
     	 waitqueue).

     	 (Note that waitqueue consistency also needs looking at for
     	 netfs_io_request structs.)

 (2) Add stats counters for retries and publish in /proc/fs/netfs/stats.
     This is not a fix per se, but is useful in debugging and shouldn't
     otherwise change the operation of the code.

 (3) Fix the ordering of queuing subrequests with respect to setting the
     request flag that says we've now queued them all.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

David Howells (3):
  netfs: Fix a number of read-retry hangs
  netfs: Add retry stat counters
  netfs: Fix setting NETFS_RREQ_ALL_QUEUED to be after all subreqs
    queued

 fs/netfs/buffered_read.c     | 19 +++++++++++-----
 fs/netfs/internal.h          |  4 ++++
 fs/netfs/read_collect.c      |  6 +++--
 fs/netfs/read_retry.c        | 43 +++++++++++++++++++++++++++---------
 fs/netfs/stats.c             |  9 ++++++++
 fs/netfs/write_issue.c       |  1 +
 fs/netfs/write_retry.c       |  2 ++
 include/linux/netfs.h        |  2 +-
 include/trace/events/netfs.h |  4 +++-
 9 files changed, 70 insertions(+), 20 deletions(-)


