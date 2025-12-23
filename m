Return-Path: <ceph-devel+bounces-4222-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F017CD94EC
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Dec 2025 13:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B5AFF3097216
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Dec 2025 12:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B82128C860;
	Tue, 23 Dec 2025 12:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CgcBtOvI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ys72Qdq6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631D4336EFE
	for <ceph-devel@vger.kernel.org>; Tue, 23 Dec 2025 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766493326; cv=none; b=qqMBacO8ZXDTlZoWPfCHJqoqVkCQBWij2iLUrymA4jt5XNRz3fQRSUXB/C+rKRGkugy9/L1M7HEuszuzNNLDcNQehHC2TsUMNU/84z9oPL5RQ3Pk99WhfLDOPDz9hVf0HP4ZPewPqzWAKq9y16DJTgWWSsGEjK3pvdUnIhq6en0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766493326; c=relaxed/simple;
	bh=Zp7ZrL2wpTgCqD6NJHJeQG5+50UDDeLVh65DlTT+dUs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GanQjdntnJfgAvSK5ui3Ep7/k0ZhuGow8GgDTIVVkTdiXy4ncRO8ubtNzaKF244joMzSlreAbGJb2qvldY0pYNwLOkTA04lmOIXbZVDpxBxL/i5NLxVDDacW+QIq4/od/c6SKe+Bg2nTnKKbFVkO9L1BG4V5i2iQ16C3m090WiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CgcBtOvI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ys72Qdq6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766493323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DSdWHgvhJGn7RbB2GAuzD8Ky9Z74RCwiMxPz6+Zvz2U=;
	b=CgcBtOvIo0Kt+KP4lSs7ZEXt5eWPuSbL/RYdZqRRVKLxgSYi5EVdGnQHX4clhlzb+6P3XE
	tlxrDFHhWXaXipJIkbjOBc6bPAos9hOxgCgFjXEj71PVR+mg6Nq4IUoXFUn4NjKq5x2GOu
	UkLtU+fMhT/jzKEn4Wvxb647vD66or8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-apWZiWqoOZWjfRX1RJp3NA-1; Tue, 23 Dec 2025 07:35:22 -0500
X-MC-Unique: apWZiWqoOZWjfRX1RJp3NA-1
X-Mimecast-MFC-AGG-ID: apWZiWqoOZWjfRX1RJp3NA_1766493321
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b70b1778687so448322366b.0
        for <ceph-devel@vger.kernel.org>; Tue, 23 Dec 2025 04:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766493321; x=1767098121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DSdWHgvhJGn7RbB2GAuzD8Ky9Z74RCwiMxPz6+Zvz2U=;
        b=Ys72Qdq6MflKu8mb9RHlev1G4tszGDNp/iE4CuWamV+IuojpG9EiDFMrKqCFO+4U//
         DP/ZPALI+FzaeW486BuebLop7hYxx3JOp6rxOtNYtp/QatzG3sZOysoS4lE80Md4/L6n
         EVN57SHCZ0g6j0GF2U97sIBUUhtxSMEpaNg0qFUPNeBfgCLw6wRbILOIq5wgpI9GfCho
         7QL/Iu9nbD/KwwRVB/vxb2zzYtYybYfH34yFaeiKuseJYhtPxe9grTBVYMPw92jSzFn3
         UQY25Ew5QAUYeqBzLl1BTQzoR5VapIei36BXF+wOZ8vxyTPf0hRarr41vox5zNIHZZCq
         Ez/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766493321; x=1767098121;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSdWHgvhJGn7RbB2GAuzD8Ky9Z74RCwiMxPz6+Zvz2U=;
        b=MXtiscDEi3EijOtsggWrJ8bXUuY/3vdtpe+wf6ijmFjyN/rMsaehvb8LEs6E1CjUfM
         JXsDl2ZkZQcroqnt/PU8LdXmM+kWsnp9ZiQAwL7UtlKsFRyUVqi39ESZPoMw8fAcMlM/
         azPdEIP5lIiReb5eGdJzTkFaEunBn5Hc6A1Kq9ZiWh+U2zCDOMyb0ZcQlbudieRRZsQ1
         kZbzw8KNlh7yATnpL8s6pHW2AZXK1TqJ8fec3o4h8Z3JF6lQ/E2BghpoIE1DtsXp8J5g
         HuGkclIp8E0ndhCDEKYmA4BDY3aSl4fIK+WPdnKgR4qyt8QgmqeBcz8ZBh+2zahAtEm6
         mZDw==
X-Gm-Message-State: AOJu0Yzn3nXTEOaz5KPOxI9kL3zIc8OS4oCxK4bfhF1PtN2BrCTPEdoI
	IWtXbIKVL0euDqxji7SCiB8hNajSphzOekINcQgMUOiot4mDV5UUlznliqnXVO+yZC9ZttXmFIn
	aGUDeWvgjAfveYZyIMfZunujaLWVrHfJ60p4/tL+zl6skbKRX9FGPFlitWPgz5prAna5uoBlk+z
	KEOcHyeUq92I048/+AKdiqFhRMwh1gstvQV6O58AHpjdvNN/m2RN0k
X-Gm-Gg: AY/fxX6bCKo6zd80n3SUFprx7RUgNIiE+GnNmk+MnLlzpFanYTQy3Elw4SnGbkSkkE4
	Z8qsCZfccThoIUK9VbujMFRv0OAZFeevDzl1O/x98f17QbEx/UjnJpeGp6svlQL801qObL2axHJ
	1bn0fIrQi2Rauhvx00nFXE6Aqjqr7msSDGG/N9m5KoRrl6t9P0qi0olUk1KynNzZt+9ZStQJLjD
	ykBlKadsozsJsLxk/DBZwwQMJff7DE8nk8IjPJcxUhspOySuhZU+NndmTgaFfxbkSVfnF4cxBz9
	jBpXrpp6PZislXWRfMWUJ3zEsGWK34Q1KBPh6MhONROti5SJJ4CPhj1uC7guThfOgN8zPStY7O7
	twCk6vdAqylMP2DqRL7OJoMlLudtcCBgLa+bQIsJvqT0=
X-Received: by 2002:a17:907:1b1d:b0:b76:5393:758d with SMTP id a640c23a62f3a-b8037155d9bmr1284616466b.34.1766493315745;
        Tue, 23 Dec 2025 04:35:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCy7k4ESHeDFd6TWUY2NNtfU0x+/Yhc1CTnCq/hakeZ5Idg+9TpsHj8IPpnNy89S/S1lnDrw==
X-Received: by 2002:a17:907:1b1d:b0:b76:5393:758d with SMTP id a640c23a62f3a-b8037155d9bmr1284614366b.34.1766493315210;
        Tue, 23 Dec 2025 04:35:15 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f13847sm1353357366b.57.2025.12.23.04.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 04:35:14 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH v4 0/3]  ceph: add subvolume metrics reporting support
Date: Tue, 23 Dec 2025 12:35:07 +0000
Message-Id: <20251223123510.796459-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for per-subvolume I/O metrics collection
and reporting to the MDS. This enables administrators to monitor I/O
patterns at the subvolume granularity, which is useful for multi-tenant
CephFS deployments where different subvolumes may be allocated to
different users or applications.

The implementation requires protocol changes to receive the subvolume_id
from the MDS (InodeStat v9), and introduces a new metrics type
(CLIENT_METRIC_TYPE_SUBVOLUME_METRICS) for reporting aggregated I/O
statistics back to the MDS.

Patch 1 adds forward-compatible handling for InodeStat v8. The MDS v8
encoding added a versioned optmetadata field containing optional inode
metadata such as charmap (for case-insensitive/case-preserving file
systems). The kernel client does not currently support case-insensitive
lookups, so this field is skipped rather than parsed. This ensures
forward compatibility with newer MDS servers without requiring the
full case-insensitivity feature implementation.

Patch 2 adds support for parsing the subvolume_id field from InodeStat
v9 and storing it in the inode structure for later use.

Patch 3 adds the complete subvolume metrics infrastructure:
- CEPHFS_FEATURE_SUBVOLUME_METRICS feature flag for MDS negotiation
- Red-black tree based metrics tracker for efficient per-subvolume
  aggregation with kmem_cache for entry allocations
- Wire format encoding matching the MDS C++ AggregatedIOMetrics struct
- Integration with the existing CLIENT_METRICS message
- Recording of I/O operations from file read/write and writeback paths
- Debugfs interfaces for monitoring

Metrics tracked per subvolume include:
- Read/write operation counts
- Read/write byte counts
- Read/write latency sums (for average calculation)

The metrics are periodically sent to the MDS as part of the existing
metrics reporting infrastructure when the MDS advertises support for
the SUBVOLUME_METRICS feature.

Debugfs additions in Patch 3:
- metrics/subvolumes: displays last sent and pending subvolume metrics
- metrics/metric_features: displays MDS session feature negotiation
  status, showing which metric-related features are enabled (including
  METRIC_COLLECT and SUBVOLUME_METRICS)

Patch 3 introduces CEPH_SUBVOLUME_ID_NONE constant and enforces
subvolume_id immutability. Following the FUSE client convention,
0 means unknown/unset. Once an inode has a valid (non-zero) subvolume_id,
it should not change during the inode's lifetime.

Changes since v3:
- merged CEPH_SUBVOLUME_ID_NONE patch into its prediseccor

Changes since v2:
- Add CEPH_SUBVOLUME_ID_NONE constant (value 0) for unknown/unset state
- Add WARN_ON_ONCE if attempting to change already-set subvolume_id
- Add documentation for struct ceph_session_feature_desc ('bit' field)
- Change pr_err() to pr_info() for "metrics disabled" message
- Use pr_warn_ratelimited() instead of manual __ratelimit()
- Add documentation comments to ceph_subvol_metric_snapshot and
  ceph_subvolume_metrics_tracker structs
- Use kmemdup_array() instead of kmemdup() for overflow checking
- Add comments explaining ret > 0 checks for read metrics (EOF handling)
- Use kmem_cache for struct ceph_subvol_metric_rb_entry allocations
- Add comment explaining seq_file error handling in dump function

Changes since v1:
- Fixed unused variable warnings (v8_struct_v, v8_struct_compat) by
  using ceph_decode_skip_8() instead of ceph_decode_8_safe()
- Added detailed comment explaining InodeStat encoding versions v1-v9
- Clarified that "optmetadata" is the actual field name in MDS C++ code
- Aligned subvolume_id handling with FUSE client convention (0 = unknown)


Alex Markuze (3):
  ceph: handle InodeStat v8 versioned field in reply parsing
  ceph: parse subvolume_id from InodeStat v9 and store in inode
  ceph: add subvolume metrics collection and reporting

 fs/ceph/Makefile            |   2 +-
 fs/ceph/addr.c              |  10 +
 fs/ceph/debugfs.c           | 159 +++++++++++++
 fs/ceph/file.c              |  68 +++++-
 fs/ceph/inode.c             |  41 ++++
 fs/ceph/mds_client.c        |  94 ++++++--
 fs/ceph/mds_client.h        |  14 +-
 fs/ceph/metric.c            | 173 ++++++++++++++-
 fs/ceph/metric.h            |  27 ++-
 fs/ceph/subvolume_metrics.c | 432 ++++++++++++++++++++++++++++++++++++
 fs/ceph/subvolume_metrics.h |  97 ++++++++
 fs/ceph/super.c             |   8 +
 fs/ceph/super.h             |  11 +
 13 files changed, 1108 insertions(+), 28 deletions(-)
 create mode 100644 fs/ceph/subvolume_metrics.c
 create mode 100644 fs/ceph/subvolume_metrics.h

-- 
2.34.1


