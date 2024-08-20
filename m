Return-Path: <ceph-devel+bounces-1703-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B292795910C
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Aug 2024 01:21:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E16B285CC0
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Aug 2024 23:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A851C825D;
	Tue, 20 Aug 2024 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGstn2nf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4C518E035
	for <ceph-devel@vger.kernel.org>; Tue, 20 Aug 2024 23:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724196082; cv=none; b=gItLndtUlC5/ZsKw4Cm+fjTH611Qyf3Wp83kkP7heBY+hPc6C9pC2g1frzQRnYQGSm5NdmsfK/G+xp4LSHIYo8ekhARFn3fKcLSLpXScfCGdz6ZnLY5dsLdhXF+/kxgRRT8/TcP+euGKDpoh0tatYc3TriadB6YaOthU6viKRMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724196082; c=relaxed/simple;
	bh=VIiPmwmjpJuuOg36PkDA9EDqjYYvPo2xpfcKotIB4Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RwhWoteHlUhWMHuHMZx4CQoI5ZUlypo9Hesjr0HX7MNImcGvGcwomI5HaUEso/5L6sHM/Fe8KHjAMeZ0l4IrofJ6tO77S0dOcc5mcXEYzuGq/nTk28vsvBEpaxLORZbFsHvjU+zCMHnjaOSVuzgp/Mm7K8kddnbBhBzPJ/qF1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGstn2nf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724196079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fCjK9t7HkWPXdjZnzcV3YJhj3lK29P+RVZIMnJ9iM+Q=;
	b=KGstn2nfktKJhnwx+/uiiKUBMxa63m9+PKXZjI3eJUyZOaxD7wW5jnAEaXJUBSbSI14DBn
	cJc+ZM1u5JARl6Vw3DwairttQU5Ourwhht/sKQi5JLQ/pwx6QP4MWZWdzzYlkBbnOo0/II
	/040/tPf0zP8Y0my6xE+JVgcg2zZvZw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-IHAldsebOD2s3EiBWC1CDA-1; Tue,
 20 Aug 2024 19:21:16 -0400
X-MC-Unique: IHAldsebOD2s3EiBWC1CDA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 259D41955F40;
	Tue, 20 Aug 2024 23:21:13 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.30])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C53DE19560AA;
	Tue, 20 Aug 2024 23:21:07 +0000 (UTC)
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
Subject: [PATCH 0/4] mm, netfs, afs: Truncation fixes
Date: Wed, 21 Aug 2024 00:20:54 +0100
Message-ID: <20240820232105.3792638-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi Christian,

Here are some fixes for truncation, netfslib and afs that I discovered whilst
trying Pankaj Raghav's minimum folio order patchset:

 (1) Fix truncate to make it honour AS_RELEASE_ALWAYS in a couple of places
     that got missed.

 (2) Fix duplicated editing of a partially invalidated folio in afs's
     post-setattr edit phase.

 (3) Fix netfs_release_folio() to indicate that the folio is busy if the
     folio is dirty (as does iomap).

 (4) Fix the trimming of a folio that contain streaming-write data when
     truncation occurs into or past that folio

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

David Howells (4):
  mm: Fix missing folio invalidation calls during truncation
  afs: Fix post-setattr file edit to do truncation correctly
  netfs: Fix netfs_release_folio() to say no if folio dirty
  netfs: Fix trimming of streaming-write folios in netfs_inval_folio()

 fs/afs/inode.c  | 11 +++++++---
 fs/netfs/misc.c | 53 +++++++++++++++++++++++++++++++++++--------------
 mm/truncate.c   |  4 ++--
 3 files changed, 48 insertions(+), 20 deletions(-)


