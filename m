Return-Path: <ceph-devel+bounces-3409-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 235E2B223D5
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 11:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08BB23AFA2A
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 09:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9C02EA47E;
	Tue, 12 Aug 2025 09:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ilgl4UcP"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C3A2EA17B
	for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 09:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754992670; cv=none; b=JlX1nW9ngLefsf6FRMsSVDuRJQz0yaE3IcZdi9+mNyH7jYAar3XDNPaaFwT8ivKo6vDeQyc2xCTXWQX4eMXPz+MScObbkYoR6q9Mte1mNf6GZ2Nk6BDqXBita0K2J1ww1EcRL3kro2SYRHPRFvIwBGhJKN7WKEywjE1HWb5CSPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754992670; c=relaxed/simple;
	bh=nVn0POSwkcWMaC1jbZnEy37aapLqX1FOpohl7cvgnzg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=shGtov7qeJtAPQ2AX3GEO8xrcrv4SPs3rSe6uVdRjBVFT4QUfleOYirYCVsPlA7Xw6/1EQZr2RMSehbaNBmHzZhZ9kcTdf1Ocq+r1cF5bDMvbwAOHgY4VOpwc6UaKil8FYetLCRi61NrxGl0BKjP6K+s7Lh5ba6Y/zZREhdcaO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ilgl4UcP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754992667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C1x/OfrbyvlivDoeYkRGWs+/omb3R/XBJnFzS6asuSk=;
	b=ilgl4UcPeCbU82vC4zMBpQI/VsC/xAu8Wr15YRXfc17PzhPCp00nJB+k0GdWxz1xId3HSY
	cQ+M31S0b3gzv5RiMHXBiGmkjM98fErcf3bcIo9iMvJXHbiq0C2ftTRkW46f9bccsdrQdl
	CXN8w8B8hl79d9T5vScndnvuQDKz2fo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-SFhzt4fMOCWTHy8fnjOhwg-1; Tue, 12 Aug 2025 05:57:44 -0400
X-MC-Unique: SFhzt4fMOCWTHy8fnjOhwg-1
X-Mimecast-MFC-AGG-ID: SFhzt4fMOCWTHy8fnjOhwg_1754992664
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ae98864f488so543734066b.0
        for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 02:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754992663; x=1755597463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C1x/OfrbyvlivDoeYkRGWs+/omb3R/XBJnFzS6asuSk=;
        b=AO5CeRJbOo/0IjNdI0m0CN968bbBRV+lY7SRdNyo3Z9MxxN9nJ+X3NKKSTp47WcLtC
         lK0g1TEHcQAjn0gk7DJq/vCy1CV/cVWvcClEOBQv/umasU+FZoE0az3n3ReAnB+itTof
         eVJ168401ZhsdFZscYkC9oF7JsrdZlidorkyGxDvRFYbwOe2jZFH3rfUJ9P1NXosMZjP
         HIPUgTe+S+v/TJ3/jNlzoCof/L/wWiZWv9Iz+/9WKcOXKG1qoJFWZRwtj+CJwIvEv3fn
         0+XREkCtHATDoGPsmYnbdKdC3SvNpG4WZXDzUtsV2Ll8UX9evKScXJ+zvU8ZYZkBIbDJ
         cXRQ==
X-Gm-Message-State: AOJu0Yy0soU9i5OvGVwujCg9pQ0kHQMhWH/ohz0kDmwXAkZq/L5ejJ7+
	gNb4hmdfzHdmhNCzxlLUugcauC5YCzDzkERMIEtf5uka6JAgNdQ48T3h9/s3ygcIfsUjjOTT/f1
	MyeJ+CGq3xOGgpvQFZ0jgkXnsP4NMY4bHPVUpvWvLCbu4IlyFJ8X7Anxkpv600+ALpx6Ci6WnSF
	NM0V4HAvjpYqot1u2j6ju74oMYLu0cAJwNqiZjdWkcCc3uRTJyDA==
X-Gm-Gg: ASbGnct3/GhmnKr1JW+mEzu6gR3Qi8TJQBzHShwoPmSyayBRdCR3BQ+mbC/Ddo/dd/1
	xDD8TXqTf8M/Eqm/01yZMo3ufPyymfvUx1mFZRJlQv/2/3Foo6an7evIFxJOYQ5/Knr56pPENxz
	8e66ly5jwm48DAYQOJ+Jv/9wqwO6sxYV8QAEE8iQIspMR8qaTNvv8Wc6VGCjsWfWznkS3d4tY0p
	lltiPqej8E1CvlFc0Jg7oHVRh8xGTfrX9P9rofTab/TSQfn+ACBZ5mCbH12EPbS3IoltSILMoGO
	KcdbgRUUcMa0syrGH61SyzBcOmz+mJtST4mZIOScK6zTrvnKQsPbJO63POHJVOGpB1ZV50EGCA=
	=
X-Received: by 2002:a17:907:1c0f:b0:ade:9b6d:779f with SMTP id a640c23a62f3a-afa1e12ec39mr234739466b.32.1754992663228;
        Tue, 12 Aug 2025 02:57:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4H6r1rDXLB4/W9J+K5dQYmeE2JLHMHIw2xHSDqxHJoSowoENjgFZeVCZOYOrhQKyjZFVIQQ==
X-Received: by 2002:a17:907:1c0f:b0:ade:9b6d:779f with SMTP id a640c23a62f3a-afa1e12ec39mr234736466b.32.1754992662712;
        Tue, 12 Aug 2025 02:57:42 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a21c0a4sm2180821466b.109.2025.08.12.02.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 02:57:42 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH v4 0/2] ceph: fix client race conditions with stale r_parent
Date: Tue, 12 Aug 2025 09:57:37 +0000
Message-Id: <20250812095739.3194337-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series addresses client-side race conditions in the Ceph filesystem
where the cached parent directory inode (r_parent) can become stale during
concurrent operations like rename, leading to incorrect state application.

The first patch adds validation during reply processing to ensure the cached
parent directory inode matches the directory info in MDS replies. It refactors
the path building API to use a structured approach and prevents applying state
changes to incorrect directory inodes.

The second patch addresses cases where r_parent becomes stale between request
creation and message sending when the parent directory's i_rwsem is not locked.
It validates that r_parent matches the encoded parent inode and updates to the
correct inode if a mismatch is detected, with appropriate warnings for this

Alex Markuze (2):
  ceph: fix client race condition validating r_parent before applying
    state
  ceph: fix client race condition where r_parent becomes stale before
    sending message

 fs/ceph/debugfs.c    |  14 ++--
 fs/ceph/dir.c        |  17 ++---
 fs/ceph/file.c       |  24 +++----
 fs/ceph/inode.c      |  59 ++++++++++++++--
 fs/ceph/mds_client.c | 165 ++++++++++++++++++++++++++-----------------
 fs/ceph/mds_client.h |  18 +++--
 6 files changed, 189 insertions(+), 108 deletions(-)

-- 
2.34.1


