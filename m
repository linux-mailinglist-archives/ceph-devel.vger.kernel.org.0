Return-Path: <ceph-devel+bounces-4462-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A06D3990E
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Jan 2026 19:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F49530056D6
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Jan 2026 18:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D9C258EE0;
	Sun, 18 Jan 2026 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9d6lnp8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jqGA+qUb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37972248B3
	for <ceph-devel@vger.kernel.org>; Sun, 18 Jan 2026 18:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768760695; cv=none; b=RTklf6YtU0qIeT41O97tHUV4WUFwgbNNjLFUXXaAg4wKtlTC6doJmkw+HXvcJh177dgBdHdQC1V7P7iLTySZfEVuTxXjTJjzNta8wUHBT+tanT0EiowBpJX27+Wiif/cbG0YcjxsppGC7JPcpqDd8J8aziY6boOpJMq5xZx/jIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768760695; c=relaxed/simple;
	bh=nPEhPkD10hC+GpsZeDFNJSEYHmw8sFy68AY4FhVYwR8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ibWIqJPXxMMh+0PnE+5kk/wegN4WDKJNTghx5ohxfEA84kSys47zx21HVrhfEbnktWpM0s60MvuyW1AWV9ABfKhndZA9bhzFSd6TOzSvjY9rZk1TtNLYb0ydeFTGOs1E2s7mnaLUOWU+aKab+m7IZKs36RUFiHwz75lR/CVsut4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J9d6lnp8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jqGA+qUb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768760692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w1+GT9EQxbeHPApupCoRMAMRZESisIrjFxYmz2JRtDA=;
	b=J9d6lnp8uJgP9nIB1eiQRLd+uoAWgtJoD2aRLmovtaM+MRMI3faGDc4D0avxvLydGMvH12
	3VrclLreinqAL3LlCix9ierTq2HXFclc41DIFAFlCLKKW2MdzQlWd8ErHf0QfoXzg31xNw
	ryGpXbDVjd0bgLUIc7mF19FWSkAttW4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-d-XvUYH1Ocejd692YvrVhg-1; Sun, 18 Jan 2026 13:24:51 -0500
X-MC-Unique: d-XvUYH1Ocejd692YvrVhg-1
X-Mimecast-MFC-AGG-ID: d-XvUYH1Ocejd692YvrVhg_1768760690
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b801784f406so381470066b.0
        for <ceph-devel@vger.kernel.org>; Sun, 18 Jan 2026 10:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768760690; x=1769365490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w1+GT9EQxbeHPApupCoRMAMRZESisIrjFxYmz2JRtDA=;
        b=jqGA+qUbZ1z8Z+tCXOusGqfTwxzIfTSFFVnNUCRSq5KDrIAlOVtQ+OWer/keV+iHki
         xwnYPjx3NEriAfSUzGkiRAHYh5h02xFz4N1erVjqT9+oSSMZyjHEUFcgbfDh5uqRT4ml
         EaUlbE0mQ/EUBnDtgCh4WQGsbGiOmOqVNBAXn2f3YY0QC8gHm/ScG0MaUS9mmB73/E7E
         EZzX7MNH1KztBOrllNrqWLFbRiI8jcl/BbCTy26hoLFKAykLVliM5zgndOBqPEiDcY/f
         jyWx0Q7Te9PR0P0lwt4o2z7lx8DdifrEhhw/AcSPq5Oh4g9Wke9++rq78nx6HSFTBR7b
         CT9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768760690; x=1769365490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1+GT9EQxbeHPApupCoRMAMRZESisIrjFxYmz2JRtDA=;
        b=uO/yWbX4aLCTvfbdMMgomx6D7KJ6sc4JMf34aNwk0guL5jLFX8XrDQYiUKBMXtj60S
         QS5Z3loyXzapAXTUKmXs2pLNwUiaQxS09QxkN9L85Iip33uHsPJ9icwq1H5xK0GOYfqZ
         j1SDCiQI1dtvWVLYR2Z7NmaHf+HcZo2XeABfllHSL14fe1i3w4vir91OPgYmYazVpr1B
         GXaGKRZdT2CozhLuakw89O6DnXO+bKOGlQKPAXAL2Zc4WzK3FtvZQetpDg4QujVs1hXR
         Rnt8OFBn3Uuc/nexyK6jpzL8Hvi6ZlqRIY+vR4vW3N4Nzd6dLavLy4CSBfDjDH2Hs9/4
         A2Kw==
X-Gm-Message-State: AOJu0YxWRQWKzk5DWNCr7lb4TPNYEarEr4MOsV3KNgAFyVm1HkEa2L3c
	sSCeIOUBXlYN0eB9lnxini1Bva9RUXVXQMHV2D8Jwah/2QFRcfTyp0N/y2t/LAEitolfd1zCyFd
	+eLwy44op0AiSOLMQ/DqJWHYZaj6IftbyHofdBRJBs9YVojGzkm/irSN6oBgP5TsV/j8FWUKPxo
	uG44bf7WmZWa9RiGv31zTNJv6tAq8CrjjyRgF6GJ6bXE7OhiI=
X-Gm-Gg: AY/fxX6C97ZEnMkfsqjeWehv3QgJ8TWqWuCA4PRyPzTA9A+ckPPWRSy6a5wP5LXDP/f
	EAjXvHG1FWpyl42rYHAIBtwu4eYiO6SXlyHVZ/MX02ntigo/U7kyQT6wPUVEpSv6/igqovElMJc
	LKgAc9gMjZgyAqNho7uD4a8X9W+7AhhzaClwEuxjV8V6AHM9kqJ4v80ZxAFYqRsXuCi9X7XvJKX
	6ZBzDvhZ9fB9gYU4Rxsmr5D0xYNE+iuSYHvI6hd3GkgtES1JbRgC15SVxvIqvvtqxttJvaDeynv
	tCKhaMhbef5/xxQq6xjR8pNEh+hfWeW4G8hH12NVGY4iRjdDeLfS89nrxegAYbYXSEWAYPlqCI6
	O/I00VlTGRXjG1Z/IPWQffYHOa41zd+YtO/QLBLl0lIg=
X-Received: by 2002:a17:907:d8f:b0:b87:d44:81d with SMTP id a640c23a62f3a-b8793035657mr715401866b.45.1768760690086;
        Sun, 18 Jan 2026 10:24:50 -0800 (PST)
X-Received: by 2002:a17:907:d8f:b0:b87:d44:81d with SMTP id a640c23a62f3a-b8793035657mr715399666b.45.1768760689451;
        Sun, 18 Jan 2026 10:24:49 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b879513e8d1sm907624666b.2.2026.01.18.10.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 10:24:49 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH v5 0/2] ceph: add subvolume metrics reporting support
Date: Sun, 18 Jan 2026 18:24:43 +0000
Message-Id: <20260118182446.3514417-1-amarkuze@redhat.com>
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

Note: The InodeStat v8 handling patch (forward-compatible handling for
the versioned optmetadata field) is now in the base tree, so this series
starts with v9 parsing.

Patch 1 adds support for parsing the subvolume_id field from InodeStat
v9 and storing it in the inode structure for later use. This patch also
introduces CEPH_SUBVOLUME_ID_NONE constant (value 0) for unknown/unset
state and enforces subvolume_id immutability with WARN_ON_ONCE if
attempting to change an already-set subvolume_id.

Patch 2 adds the complete subvolume metrics infrastructure:
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

Debugfs additions in Patch 2:
- metrics/subvolumes: displays last sent and pending subvolume metrics
- metrics/metric_features: displays MDS session feature negotiation
  status, showing which metric-related features are enabled (including
  METRIC_COLLECT and SUBVOLUME_METRICS)

Changes since v4:
- Merged CEPH_SUBVOLUME_ID_NONE and WARN_ON_ONCE immutability check
  into patch 1 (previously split across patches 2 and 3)
- Removed unused 'cl' variable from parse_reply_info_in() that would
  cause compiler warning
- Added read I/O recording in finish_netfs_read() for netfs read path
- Simplified subvolume_metrics_dump() to use direct rb-tree iteration
  instead of intermediate snapshot allocation
- InodeStat v8 patch now in base tree, reducing series from 3 to 2
  patches

Changes since v3:
- merged CEPH_SUBVOLUME_ID_NONE patch into its predecessor

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


Alex Markuze (2):
  ceph: parse subvolume_id from InodeStat v9 and store in inode
  ceph: add subvolume metrics collection and reporting

 fs/ceph/Makefile            |   2 +-
 fs/ceph/addr.c              |  14 ++
 fs/ceph/debugfs.c           | 157 +++++++++++++++++
 fs/ceph/file.c              |  68 +++++++-
 fs/ceph/inode.c             |  41 +++++
 fs/ceph/mds_client.c        |  72 ++++++--
 fs/ceph/mds_client.h        |  14 +-
 fs/ceph/metric.c            | 183 ++++++++++++++++++-
 fs/ceph/metric.h            |  39 ++++-
 fs/ceph/subvolume_metrics.c | 416 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/subvolume_metrics.h |  97 +++++++++++
 fs/ceph/super.c             |   8 +
 fs/ceph/super.h             |  11 ++
 13 files changed, 1094 insertions(+), 28 deletions(-)
 create mode 100644 fs/ceph/subvolume_metrics.c
 create mode 100644 fs/ceph/subvolume_metrics.h

--
2.34.1


