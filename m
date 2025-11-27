Return-Path: <ceph-devel+bounces-4119-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABB9C8E91A
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 14:48:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26EFB3A9091
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 13:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 629DE1DEFE8;
	Thu, 27 Nov 2025 13:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USmr4w2h";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PN1LTKmr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EE61E9B35
	for <ceph-devel@vger.kernel.org>; Thu, 27 Nov 2025 13:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764251200; cv=none; b=B+2wNkWjhbuei3pkQACSK67bKYtnFPZ7l9oG8Ypte6oJtvKKwE5eSmQkaVLQcgbbmkfmc5LVXKodYVmJXsfsYQA1yicL5bYrXxs6C3sFHJroF3/FgMtm/7BH7WsI02JQn1Rl1UoAJx/Hy7HDDc+1CKl2IC/SSejFO1McuHAgPM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764251200; c=relaxed/simple;
	bh=5dipwLKkDiBsRMZLfhAnVuPcmN43TKBFde0jxNTHluk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jclAZgUtNc3ICR5tgFy8kktU2Sm0lj3sx9OSHkjC/pRkHoUBtXrs/GbZ8XPo7WnnA6ty17YjPpOdgaBHZeFWOnGiONQoLeBHBjxGrUuGB886FDmBoVHeOLpl3YjsXmwdUkWJIENt7cEbFS9IkCn/1k0pla9pbm/MpJ/oPvFUCBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USmr4w2h; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PN1LTKmr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764251197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qG4JU08EewP6ExK6olKFMFYTlaVeyVu1KHFPXyo0UwU=;
	b=USmr4w2h9XKboM4jJq17UzoNvm3jvtgqx0T0IANMCxMAmuftuDE3U/lA2/Dlp+Kp1T3Rwt
	sVrxBrXdop4lOpIl1FzCuyzgfnJs+m8tkypmwUCDlA3e3ZvYotiLkNpmMotTSF9548P3IV
	kyiDYvshKQzxcH0M0arV6ERhTgaSUFk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-_LVfc9TEMRG8c4xXTn2fBQ-1; Thu, 27 Nov 2025 08:46:36 -0500
X-MC-Unique: _LVfc9TEMRG8c4xXTn2fBQ-1
X-Mimecast-MFC-AGG-ID: _LVfc9TEMRG8c4xXTn2fBQ_1764251196
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-88236279bd9so19373286d6.3
        for <ceph-devel@vger.kernel.org>; Thu, 27 Nov 2025 05:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764251196; x=1764855996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qG4JU08EewP6ExK6olKFMFYTlaVeyVu1KHFPXyo0UwU=;
        b=PN1LTKmrUyubcpi85Gqce66oIs0Y8F0OvQlkZX8G1YKeIjZBlE1P4rFdSQ+coTDav+
         vHSyHyRkDuH1ak55QcrQPVC1SXUcICfasgWKVMmK1RYgP+jMW6pDZBcaXL+aa1+CiK8u
         GHLPtZpEbcTGrcpUrIWD7ksmRDqXyZ8867RBemsOpe7R0H45dSFJT70motEDAvrNmqII
         ZSTCXgp8bgh1PIgEJFOfupTban3VPE3bnyU+SJVT81SBKtx9LWRgNHWvYmLjg1a2XAZZ
         UyoMjA4t2J/bb4Y+g13atEaY3FoyF/PcrdRfdpO+anPBDlCTCg2QFLXL0u4q8IOYnza9
         krwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764251196; x=1764855996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qG4JU08EewP6ExK6olKFMFYTlaVeyVu1KHFPXyo0UwU=;
        b=shUk6MMeZM4Bux0u+CCcDLicBlllvV5WmnnEUXeu5NygXCGce5dp272qfezqOXdvPn
         A0CCya2gk2Z0CiG4Qccfv+wMa+8YJdSIM3Fp6b5UHmeenKdZnt3fz5qkooT4oNXzfBl+
         4cB1jkgTCZCq//jJ77oMWKL+Ou6vLs7PbRsxIlEuYHItWkxVvJSgxDB8012LuvyPc8vd
         sgFQhAxC/V+2x1AoT6XMdGGnxSuFR17gsuKjJN8kLW/QDZwwdlV1uGr5JGc+1P+lk0qB
         vBJdDTCjU7HxlgTDxa8JIj7pv0GnirZtZyz+KOo6NYzZvfPRzl8S6jbRFddUR9RkwhID
         iGCA==
X-Gm-Message-State: AOJu0YxH2lmV04r6gm2vsrnFWKWIOXAjBWoo2Q6Met3xNb76o9/Tc6Fu
	y4XX25IM4bxoj2oVu91IjDCBMWeGITw/H7AIsZRY3bFunJi4GNFZ/1as4BkYIAvAezqKGITCYMA
	4tL8BQDp8INz6nq3rXqWhlp8C7ahLqozEdsPCUGtLohPcDlpc2cFk/lUc1P5QUJu2LB3scZmPvO
	CcSVi088fXM7JpqrFntQQVBBYcD27ONbYNEikXYE41smngPpU=
X-Gm-Gg: ASbGnctGcf6Ad4G7SGqDdyLstS7mvIwyT6h08PZTmgR5MggGIinUw2q+n6jxb7ADDcm
	JCpq7CSXALq8k7Xc8OM0ZPvl5K17WB/1RbW4hqoZyTA3aAm9CgbkTSQl1QZFRyWvd7C8TPFjJbQ
	9kWNORGyFn813e+y3eaO49Q5TEAggWPoWX7RCxDDjNy9f6H+bp1rXFy335WUoV0QlOZL2bujeGR
	4qkrRTR3jKgMs8dRsK5VrQiZnBSF6qOli3hsyJFM4hn9xIAvV9hEfvk8FcHMZz+Rq1dlLcH8V4w
	Se4rrtBKLTfkbqYKjN+hJXVlzU24sNYosuHkTgca+aI1qtAGrFYFsqeMEmg0J9dsNK7+/tx0JQd
	MJN2kixtBs7iGrs+JOqC4Ji4vHgIJsQ6FBvpumuxJn7A=
X-Received: by 2002:a05:6214:4a92:b0:880:5042:e38c with SMTP id 6a1803df08f44-8847c489835mr334184196d6.2.1764251195665;
        Thu, 27 Nov 2025 05:46:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHqWeHXCjb/kCGdMUdI6ewfC9LvuQ759Fj3jgY7OAEH5ltonEXOAax4cuy5Kt1MRIRZFCCJbQ==
X-Received: by 2002:a05:6214:4a92:b0:880:5042:e38c with SMTP id 6a1803df08f44-8847c489835mr334183756d6.2.1764251195230;
        Thu, 27 Nov 2025 05:46:35 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524fd33fsm9932946d6.24.2025.11.27.05.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 05:46:34 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH 0/3] ceph: add subvolume metrics reporting support
Date: Thu, 27 Nov 2025 13:46:17 +0000
Message-Id: <20251127134620.2035796-1-amarkuze@redhat.com>
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

Alex Markuze (3):
  ceph: handle InodeStat v8 versioned field in reply parsing
  ceph: parse subvolume_id from InodeStat v9 and store in inode
  ceph: add subvolume metrics collection and reporting

 fs/ceph/Makefile            |   2 +-
 fs/ceph/addr.c              |  10 +
 fs/ceph/debugfs.c           | 153 ++++++++++++++
 fs/ceph/file.c              |  58 ++++-
 fs/ceph/inode.c             |  19 ++
 fs/ceph/mds_client.c        |  89 ++++++--
 fs/ceph/mds_client.h        |  14 +-
 fs/ceph/metric.c            | 172 ++++++++++++++-
 fs/ceph/metric.h            |  27 ++-
 fs/ceph/subvolume_metrics.c | 407 ++++++++++++++++++++++++++++++++++++
 fs/ceph/subvolume_metrics.h |  68 ++++++
 fs/ceph/super.c             |   1 +
 fs/ceph/super.h             |   3 +
 13 files changed, 997 insertions(+), 26 deletions(-)
 create mode 100644 fs/ceph/subvolume_metrics.c
 create mode 100644 fs/ceph/subvolume_metrics.h

-- 
2.34.1


