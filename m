Return-Path: <ceph-devel+bounces-4136-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DE28CC9C0DC
	for <lists+ceph-devel@lfdr.de>; Tue, 02 Dec 2025 16:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 712A64E3F87
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Dec 2025 15:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B191324B28;
	Tue,  2 Dec 2025 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LnMY6FMm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gTTeoTFE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE1D3242C1
	for <ceph-devel@vger.kernel.org>; Tue,  2 Dec 2025 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691081; cv=none; b=ESw4iM43OYqwUFjupOvXYFp3KxMYeHTOn+h+vkSp+eK0cNz4dJ+6XXFloudeHM6ukEJmJZs/Hxf/4Td97XriaDEniZhHj7IR9DbpVC2E2qBlBaCUGYwi1Oy68BE3PjDsVu//eEhar17e4hjcgDt2X5oHQ3mR3qf1/2a7J1yuC0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691081; c=relaxed/simple;
	bh=rX2IgrIqcF6IEM7gSm025k9RsEr644ZeRcwFDAA/X3o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DqpYuccS9xcFHBroKC3GK5IIuAwpk/M3J8ojcd2w33A3VI+eqHmAmuJT8z15ADrt70nd+CGneaXbmlx3bK7e6Uumdvsnd5QsuyGJLWo+NP1KBxiSMYoewwUSNsFnO3a/fCGKxc20VL3Vsn4StLZm5kYdjyhK5GmJoTiYPeDi63I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LnMY6FMm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gTTeoTFE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764691078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K+JZDDX0YSxfiuatTCZt13y1SraeSniBJJpMPYFkVF4=;
	b=LnMY6FMmXyDL9U5vGFQ/3P3RUHyHo6saMKIsrv+k12Fu5SjY7w7pNu6c+8KLK7SRH3tMe7
	Z7CzrJMGlMLTYJTpCa+pRRb9NTkqM2KBgltrNQqwAkrRgNbbNiqOL69VZ2AQiNOiluP8Mw
	FvyXLbep6+tGohrVAxSI2+Q5Nrf0/TU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-CkcnFjmeME-8bCkxcRdQxQ-1; Tue, 02 Dec 2025 10:57:56 -0500
X-MC-Unique: CkcnFjmeME-8bCkxcRdQxQ-1
X-Mimecast-MFC-AGG-ID: CkcnFjmeME-8bCkxcRdQxQ_1764691075
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b7178ad1a7dso724198866b.1
        for <ceph-devel@vger.kernel.org>; Tue, 02 Dec 2025 07:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764691075; x=1765295875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K+JZDDX0YSxfiuatTCZt13y1SraeSniBJJpMPYFkVF4=;
        b=gTTeoTFEJwZhffMkG7/NaU5/eKG+I7H5Ns0FR66iOu3Vgsj89r66Hm8JsyEWW6N3Wj
         FGJG7ijQ34sRzHZhY1m6T77Q+eSCKT7TCMEH93CsltO1h5VMbDdeuvtWwgi7Tjz/7GGi
         NWJjUIMoZgjjYpQvoN/OHSz97t8br9U4+wQBTlI8rNZo+Fhvh8QgSHgrhsm1A8nb/Vi0
         JtuvpO6axSL5KU5wVpkWUsr+/iXIcXuvTMqjk2EqopRIsUkb46phC0alVlroduXkiTgL
         dhIZ5IkneDNg5jrVwg/ypjU//dfAnx4Kyi7SYt2aNQM0UztK4M4RPvG4gMVbLtDnFg4f
         ujQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691075; x=1765295875;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+JZDDX0YSxfiuatTCZt13y1SraeSniBJJpMPYFkVF4=;
        b=RaKZWNiN0x/8oXsWyhqLXPICE5TM2y40mUt7mMOMJIhxx51taK2T/nglEcyndA19gd
         BcSUwy4Rq1s0n+cqaSSxVROteVpc6ACzuqu2XL2f3VMkkblQfysA8vBk4xyhvESCkVUW
         7zn1iG2YyZvD3xdUn2FWVhjWmNzQJVonIjKILC2lojoXp9BOT3J+3nOKEfuOTR+j8vxK
         Kbgayypu1E7/WyMnb7D1uDmt2xVeDL3uB+cDrGusP9RvOBsExR5jJADXWAGW7KpsZniz
         DwxLwMU0skEEU0eIVu9xngVGt5kaUdRq1CjaKrSh2UOgxhUJeqEEkKyGr88p6Qowp5cF
         ih6g==
X-Gm-Message-State: AOJu0YyzQu40iTeTM6/3x0cJJnE/Yq/Alc+QgeN2VeDtIIDTFZIDqrQo
	LLzcwrWS51pfrKhikvGALwhY3udNivjdOAzpWhXFPID5ac0TDTqYZtBdhAH69QUv3+wfuS6bZEA
	g0qqKV03SFG9P1I9j16GFC9Z3ZvwHM1Hm46RStSYsh0s3C0onNr7zo0Ayy8zUz/WYEzhim54aQ9
	1iHgyxz5DYZFfu7RthYnKey8xIZsaIWV5acJR1/XJaRxeUcdR3Q2GO
X-Gm-Gg: ASbGncsi9E1tjp/4i9ygc7PWQUWqFwf4clzG/IdnPdDFqN0VIbSge65i4uiW2ni0iSC
	eCYAA64Lk9r0EuuDNxI5mVZLt0kgPxA5+ogbVC4mQcJjKLTjGjSthGxzl5F0IEauvEObXuJw5kU
	w3yr63z478vO1ZsZjRkLMfTHgmolT85u2fxNLSn1Npf6hYITLZc9ZTMDkNoGwXhI71ffnt/aihj
	4xSGedBRmYq7JyCV+FCHTPNTKkeBTyl0HXpdHcWrgUg6w4HI/5ZKeonLPnVSOaS87ey/sSo0PFE
	GA0bIgNYWfBhanPs/dNaztG6TTntraXY7H/35KzVVm31bmLPMzwC2JUKcZ3qtvPVtUIlRoXwoi2
	tahczOzDO4Y+v2aWR9Sjx6TAET2IQs1FwdokkpFGM5f0=
X-Received: by 2002:a17:907:dab:b0:b73:4fbb:37a2 with SMTP id a640c23a62f3a-b7671514106mr4644536166b.5.1764691074788;
        Tue, 02 Dec 2025 07:57:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5ff5Bo0B6oODeYs3rbb9HOcwAKRRqHzyGe5AJPxl7y2wdD/DgKiLMe7eRGyww7j929rXNTg==
X-Received: by 2002:a17:907:dab:b0:b73:4fbb:37a2 with SMTP id a640c23a62f3a-b7671514106mr4644532866b.5.1764691074313;
        Tue, 02 Dec 2025 07:57:54 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f59eb3f6sm1520702366b.55.2025.12.02.07.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 07:57:53 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH v2 0/3] ceph: add subvolume metrics reporting support
Date: Tue,  2 Dec 2025 15:57:47 +0000
Message-Id: <20251202155750.2565696-1-amarkuze@redhat.com>
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
encoding added a versioned "optmetadata" field (this is the actual field
name in the MDS C++ code - short for "optional metadata"). This field
contains optional inode metadata such as charmap for case-insensitive/
case-preserving file systems. The kernel client does not currently
support case-insensitive lookups, so this field is skipped rather than
parsed. This ensures forward compatibility with newer MDS servers
without requiring the full case-insensitivity feature implementation.

Patch 2 adds support for parsing the subvolume_id field from InodeStat
v9 and storing it in the inode structure for later use. Following the
FUSE client convention, subvolume_id of 0 indicates unknown/unset
(the MDS only sends non-zero subvolume IDs for inodes within subvolumes).

Patch 3 adds the complete subvolume metrics infrastructure:
- CEPHFS_FEATURE_SUBVOLUME_METRICS feature flag for MDS negotiation
- Red-black tree based metrics tracker for efficient per-subvolume
  aggregation
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

Changes since v1:
- Fixed unused variable warnings in patch 1 (v8_struct_v, v8_struct_compat)
  reported by kernel test robot. Now uses ceph_decode_skip_8() instead of
  ceph_decode_8_safe() since we only need to skip the versioned field header.
- Added comprehensive comment explaining InodeStat encoding versions v1-v9.
- Clarified that "optmetadata" is the actual field name in MDS C++ code.
- Added comments documenting that subvolume_id of 0 means unknown/unset,
  following the FUSE client convention.
- Fixed smatch warning in subvolume_metrics_show() where mdsc was assumed
  to potentially be NULL but later dereferenced unconditionally.

Alex Markuze (3):
  ceph: handle InodeStat v8 versioned field in reply parsing
  ceph: parse subvolume_id from InodeStat v9 and store in inode
  ceph: add subvolume metrics collection and reporting

 fs/ceph/Makefile            |   2 +-
 fs/ceph/addr.c              |  10 +
 fs/ceph/debugfs.c           | 153 ++++++++++++++
 fs/ceph/file.c              |  58 ++++-
 fs/ceph/inode.c             |  23 ++
 fs/ceph/mds_client.c        |  97 +++++++--
 fs/ceph/mds_client.h        |  14 +-
 fs/ceph/metric.c            | 172 ++++++++++++++-
 fs/ceph/metric.h            |  27 ++-
 fs/ceph/subvolume_metrics.c | 408 ++++++++++++++++++++++++++++++++++++
 fs/ceph/subvolume_metrics.h |  68 ++++++
 fs/ceph/super.c             |   1 +
 fs/ceph/super.h             |   3 +
 13 files changed, 1010 insertions(+), 26 deletions(-)
 create mode 100644 fs/ceph/subvolume_metrics.c
 create mode 100644 fs/ceph/subvolume_metrics.h

-- 
2.34.1


