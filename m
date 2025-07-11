Return-Path: <ceph-devel+bounces-3306-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 643EAB0201B
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 17:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48AF5B427AE
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 15:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365302EA485;
	Fri, 11 Jul 2025 15:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1+RXhgB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BD22EA157
	for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752246621; cv=none; b=YmvM2V4w3CmvCxcG4SOvEbDk1XswKqmVZo7zCBBsYWuMlVMYGpQHMQmc3SX4pYp090sZr88FuHrOWVtSOR45ow9Afs1sWWEdTTCI+lQ6qrowiowhYQdbEzOiEsj0spm4pbDTG7ADdpKLBEMFuewwNvvxA4/LGFlxDXJuwKRphgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752246621; c=relaxed/simple;
	bh=vl5/+yZjr/5bLFxQsllWnUlwlQ8txEkCdIKXTXUNMmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OlUUM/BrHBEubzCkWECSNXHG4NoJadK9rCgzG/jeE5N0DPhQ1OuyfSE4Mhtas0duEgLXmNt2NbQd3Nf+SIC/f0zaXXkE+2STWhBuVPSoOxTkz+Ts8WwRCUTlowtqLjOQSFAkw16hdCyT8aTFlTjW55IaPMwKWgLxkpryX/nTkCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1+RXhgB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752246618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1Wi1ac6epZO5NoWEvSel2tFSY9RY1xohxrC8k+pRSGw=;
	b=Q1+RXhgBgxauyO3b+0gjlaUdcnvW5MNYBL6tgOA32Dk1c8OPqYSC9yZDHQkQTG+P4ni36e
	04SYNVaqbUSQIqpAMl8I/r9+B1sVfwt6gK+eEgVpNriYEcOZ7D738mD6ovRwh2Hbq4a2ec
	6VJCEuP42qC0fDp1rpBqsZT5ZmkfHDE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-8CWVbDW_MRW249P7RwTGIw-1; Fri,
 11 Jul 2025 11:10:15 -0400
X-MC-Unique: 8CWVbDW_MRW249P7RwTGIw-1
X-Mimecast-MFC-AGG-ID: 8CWVbDW_MRW249P7RwTGIw_1752246612
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DFC2D18011EE;
	Fri, 11 Jul 2025 15:10:11 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.2])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7CAB71956094;
	Fri, 11 Jul 2025 15:10:08 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] netfs: Fix use of fscache with ceph
Date: Fri, 11 Jul 2025 16:09:59 +0100
Message-ID: <20250711151005.2956810-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi Christian,

Here are a couple of patches that fix the use of fscaching with ceph:

 (1) Fix the read collector to mark the write request that it creates to copy
     data to the cache with NETFS_RREQ_OFFLOAD_COLLECTION so that it will run
     the write collector on a workqueue as it's meant to run in the background
     and the app isn't going to wait for it.

 (2) Fix the read collector to wake up the copy-to-cache write request after
     it sets NETFS_RREQ_ALL_QUEUED if the write request doesn't have any
     subrequests left on it.  ALL_QUEUED indicates that there won't be any
     more subreqs coming and the collector should clean up - except that an
     event is needed to trigger that, but it only gets events from subreq
     termination and so the last event can beat us to setting ALL_QUEUED.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

David Howells (2):
  netfs: Fix copy-to-cache so that it performs collection with
    ceph+fscache
  netfs: Fix race between cache write completion and ALL_QUEUED being
    set

 fs/netfs/read_pgpriv2.c      |  5 +++++
 include/trace/events/netfs.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)


