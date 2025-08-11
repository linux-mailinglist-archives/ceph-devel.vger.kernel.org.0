Return-Path: <ceph-devel+bounces-3390-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A57B204EC
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 12:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8EAE7A780B
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 10:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DBC224B01;
	Mon, 11 Aug 2025 10:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z4fqz4aK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5B9222582
	for <ceph-devel@vger.kernel.org>; Mon, 11 Aug 2025 10:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907004; cv=none; b=qxzi5qSO4UYwdJRjXbSxOQ3RUgaZC4xbjxJI7NH5hyj4Lr/72x08DfdvVW8u9OiIma1RAU4AE7CNvN/zi+HWnf2sef5DsAGDQ6ajv23w2pBsBPG9MpxPJjVmGcAu5HAxhg0s4rg6QGQaQsiQd3iWhz1dCTE66qQf/CX9yABAWpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907004; c=relaxed/simple;
	bh=ArzdlRRjJmGeM53R6VRcLqZjX7N9evotnkSHizSx02w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qPRRNCrUrhn8NVQQPGl5xaBzWi69TQpE12+Pp03rmVaOVDzF1RhQMVSWeDlb5gz6ofjnduyBWzqRMYsNvHBtivwZCHVvxJgrIXbtlA9u4YsEJm2MTKO2DKowKw3DV+cKZiB/rOerPsRhdLeBzF0mmpviB7iJDQiJQnSqJ5wTNY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z4fqz4aK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754907002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rBrzknqAgzd7JukeAoXkv0pdIP1fZcHbaMe4XwjCqzM=;
	b=Z4fqz4aKrcBRdkiv0zVnocJTCR1NP68G51a5egOOp5WFYRxGc98h07KvtE60xtjfqUPOz1
	URBOIgzmEKY6htLqa/dEwKXDGTF/pYFqyfGx29Zu+/YE6SkqoWbwgBLUavpA6IfbZmRQ12
	lhHoLyNLmehPKarwHFWzZXysqGrwT7w=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-cr_QqqdGORe0SomA7oQYUA-1; Mon, 11 Aug 2025 06:10:01 -0400
X-MC-Unique: cr_QqqdGORe0SomA7oQYUA-1
X-Mimecast-MFC-AGG-ID: cr_QqqdGORe0SomA7oQYUA_1754907000
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-61599108233so5228462eaf.1
        for <ceph-devel@vger.kernel.org>; Mon, 11 Aug 2025 03:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907000; x=1755511800;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rBrzknqAgzd7JukeAoXkv0pdIP1fZcHbaMe4XwjCqzM=;
        b=Unm25fT4jZZug5RobXPQOLjv0Q9wZAUuTHrCDk6zlaO16JZnDnIMuzSXSmjaaGjHRC
         tUJnYxk8lANOSqgksbI1WHzoi95zt9BmIUTZMIbRQ2JGd6JAKRa5ulbdele0GApodedi
         CFd6q80kA7uFqfZSCK15UVhr6rN8Y3SLRCv+7ff8B1j2ODiNGrQbBBDH4qDU1NUnLpHC
         tOXFEADjLrFOjPHPssOq0/298QaV8RKD55byUBAfMAiXYojP5PpmBnrAiDdzbV2bQ39r
         pAZrYyToTahUF0zQGcimYUL8DMuPmTCoOyk6ceeKJazqYKsLfYURZyg4jrflvrtrh+j5
         dpQA==
X-Gm-Message-State: AOJu0YwZtLbTvhhx3yd85lyoLJ3SGUsVCC0cS/cmdpE8nStvNlmyQsL1
	IG53BH+jdwmei8lveY7mucwPTaehq7wPl3lBgqU1F0JgUUJ28sVgZPcwrLOvugjTUHA2RsP9MgB
	r+75zuLrSoIRFqTikB8xbYWKM4q2Fw4eiaWkGgxVGUZth0Ju6rBZAQ0qW5n/DwcC9N7Cv21itJy
	cJ1TjbYEJmQiglIfhDZkItYdphRfwo2fdobjNOBruCbLropt7QdQ==
X-Gm-Gg: ASbGnctoN3mFTqtevoyNHvpIRFPYdLe5u11zMq1HE37tSj2wfujpFhaGBRJ6ngEG9Yx
	/NCb8uSBKcWm5mrkGJxRZPSS0Ab199IfCEIzQKopiOfYT1WLGjVlqoM3dY7Ax6iOTHQv7OLn2YC
	TVF9bbf+aCNXyu1Xk3w+ZuphNZGQjEFKhBHoKsMv2G33qtRAuAfjnGejfN0ytossm7Mq1HrmIFg
	mgWczEBood+32xX9djWwXGDk4iWeCW4KKU56oO22qgix1fRskSZ//+pL5i/e20qc1CEZVvYofbM
	Xv87VwFpKdvCrqpkSH/s6Cjq2moBBhhjLB+iyp75UG+Be8jPIUB8F3ynN+Isdbl/832gAcMCiQ=
	=
X-Received: by 2002:a05:6820:4808:b0:615:85cc:339 with SMTP id 006d021491bc7-61b6ed3c184mr5812275eaf.2.1754907000202;
        Mon, 11 Aug 2025 03:10:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHq2QQ7oXiIdgHaW5DRAGfOw5NbYt0mkKjXsuUywxvqtTNhy/9JeYZPPIHYotzuYg4v2A5y8w==
X-Received: by 2002:a05:6820:4808:b0:615:85cc:339 with SMTP id 006d021491bc7-61b6ed3c184mr5812260eaf.2.1754906999859;
        Mon, 11 Aug 2025 03:09:59 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-61b84cb7630sm849522eaf.19.2025.08.11.03.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 03:09:59 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH v3 0/2] ceph: fix client race conditions with stale r_parent
Date: Mon, 11 Aug 2025 10:09:51 +0000
Message-Id: <20250811100953.3103970-1-amarkuze@redhat.com>
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
rare but problematic condition.

Alex Markuze (2):
  ceph: fix client race condition validating r_parent before applying
    state
  ceph: fix client race condition where r_parent becomes stale before
    sending message

 fs/ceph/debugfs.c    |  14 ++--
 fs/ceph/dir.c        |  17 ++---
 fs/ceph/file.c       |  24 +++----
 fs/ceph/inode.c      |  59 +++++++++++++++--
 fs/ceph/mds_client.c | 148 +++++++++++++++++++++++++++----------------
 fs/ceph/mds_client.h |  12 +++-
 6 files changed, 182 insertions(+), 92 deletions(-)

-- 
2.34.1


