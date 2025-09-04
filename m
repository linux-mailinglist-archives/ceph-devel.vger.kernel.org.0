Return-Path: <ceph-devel+bounces-3515-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35181B4384A
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 12:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F1973A138F
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 10:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBF1301473;
	Thu,  4 Sep 2025 10:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sk+vC29x"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94C62FB60E
	for <ceph-devel@vger.kernel.org>; Thu,  4 Sep 2025 10:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756980701; cv=none; b=UHNdJ1eBLyA6BlSzdQ+zcIDUeRS8K32gBX1amAmgCZoNvMG6F8Ed/7CBqD8Iq6LOU9p/PXXwQhxQqvqj45UU7iCSB6WqvLasmBaq9yBq8lrCp6qSUXq3UAp1BD1IWQEkDyBZnDUW7fKsS3hVqh5zyL4iLkGIC34dtH53gtCZJlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756980701; c=relaxed/simple;
	bh=n+QGcGzoBiJgZToYbMEXGvMAS6ROjQPgsKc23+B2XY4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JLWLXHb2iXQ6uprDvHt9S6MLW13GD57px5vAkUwgzG2Z4OFoK5yKhzpuYdkaJTqJRKJ4NF1ijZyUnxzB8wrtsM1QPz+QT59rpXIYmxpYxkBxmfQFNf/FTjKroH50RD/s7uNPfuINAk1XwpU05Qh3uNNb1bOYD0ReMG/EuqnWoFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sk+vC29x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756980698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dTuny/fJgLeScyncMXmVM+uPwGn8xgCwGJTov4rkZVE=;
	b=Sk+vC29xiEWhW0YxTYz0mSyZo9lX869LlOnpVEabf9NzbMvJ4g3WQ3BlcZxISZTIYcoMI4
	FZbtCJX7dgrxtHQyIkIq/8/G/SQFBwAnLK+H4pm4mzzaB+a+m/BIQwgOvOILhVyioilQsm
	p+ZSIZVhmAMDJGzl5UGestrqbTnGfR8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-JTjZUvpdNxeDdt1N-3QyIw-1; Thu, 04 Sep 2025 06:11:37 -0400
X-MC-Unique: JTjZUvpdNxeDdt1N-3QyIw-1
X-Mimecast-MFC-AGG-ID: JTjZUvpdNxeDdt1N-3QyIw_1756980697
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-803d02bd834so110669885a.1
        for <ceph-devel@vger.kernel.org>; Thu, 04 Sep 2025 03:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756980697; x=1757585497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dTuny/fJgLeScyncMXmVM+uPwGn8xgCwGJTov4rkZVE=;
        b=UNKPjBCMMyRG3DcdIpYSYtihhImz5Lqs+qQYE0UUFdnH9lifLUb1pNlOouztnNVbIo
         ZFeBc+fLfmkmyPjB37qgpOMJ5+YwnCySaq/25qwyyGtGsiOQhLG2T/SRnKbua1qSdQlu
         2EnSUZHflNmZBjdQw4+LDWmWhxJrrocSTH7Kfy5ur2M9DkvxTq8Wp1N57y7ojeEz+KbM
         knQYHwbLC1u36B2jCqTODNkl1R6lKt3NQXcIeMNBvx7PNGacf0AT5YyXumHjDafJiN2h
         ZyXLWxFdzxgdrkrOmDpofWiLYSB8wiwDx5ZUeSwJ5CqUO0eG1CuSxnlNnUNo/aROy7zS
         CGOQ==
X-Gm-Message-State: AOJu0YwwdpZcqEtWkStJLRLUxfak0MlgyT/F3aKMb5/VyYTs6lPiOkDS
	Dv+kw9x6kZaoHJu7S21xybvZS548Fh4DTxoiYad4hnmLyuKOcmH0KT3gGFinKHAfmXEf+oUpvxY
	Gyxn2dz2vrD36BLfd1d0IcG62OmEJwvMUvDYpcAkzjpqTmhCdIc2lIPmstXCFF+NtdFvguHHpvt
	IjCFIZoODwBi0Hztc9hdMkTwJLFRtpEqOxvQASjmbWZ3/LmCOJ2A==
X-Gm-Gg: ASbGncsLNJLGTZVpTVBlR3MML8WPgpo9m+PLOQ+fYc6oBx7geNe7HXFQ1BVp+N5ucnT
	4KP0ElMVRqPatZjev+1Jjqh7Q3lEolWD16ZsHAGIU4kIzdw78Rsh4QSfnXr9XUF6fcVex/meFLk
	7geKdNMCFxWlxfAcxjnEfn0BwFanypKXSEYKNdH+gW8wUIkukNMjYuSuCWevhDFgPFSgHHd82/A
	6seWKMd//czAHIP3mpM9BoEorCY3NDAGEKvByT6rxhYUcA92Cek8u9Galm4u4Z+urcaJUECeNLj
	YcoOwEY6UgBVOjZJlQJCraBPYx+saWt/1hF3DoaUKe0Pi5vng3wv4jOiPIZzgN0zjejgG9oE0g=
	=
X-Received: by 2002:a05:6214:2aad:b0:728:4af1:e4f2 with SMTP id 6a1803df08f44-7284af1ee6cmr24816356d6.1.1756980696857;
        Thu, 04 Sep 2025 03:11:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfRbfza5Si0J+blacYdsGGMX0Q3pPy9+XsQjds1RVc77U866tJIM9i75eMIudFk0VLe06B5w==
X-Received: by 2002:a05:6214:2aad:b0:728:4af1:e4f2 with SMTP id 6a1803df08f44-7284af1ee6cmr24816036d6.1.1756980696212;
        Thu, 04 Sep 2025 03:11:36 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720ad2c9f5esm45683216d6.22.2025.09.04.03.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 03:11:35 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH v2 1/2] ceph/mdsc: Move CEPH_CAP_PIN reference when r_parent is updated
Date: Thu,  4 Sep 2025 10:11:31 +0000
Message-Id: <20250904101131.1258532-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the parent directory lock is not held, req->r_parent can become stale and is updated to point to the correct inode.
However, the associated CEPH_CAP_PIN reference was not being adjusted.
The CEPH_CAP_PIN is a reference on an inode that is tracked for accounting purposes.
Moving this pin is important to keep the accounting balanced. When the pin was not moved from the old parent to the new one, it created two problems:
The reference on the old, stale parent was never released, causing a reference leak.
A reference for the new parent was never acquired, creating the risk of a reference underflow later in ceph_mdsc_release_request().
This patch corrects the logic by releasing the pin from the old parent and acquiring it for the new parent when r_parent is switched.
This ensures reference accounting stays balanced.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/mds_client.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ce0c129f4651..4e5926f36e8d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3053,12 +3053,19 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	 */
 	if (!parent_locked && req->r_parent && path_info1.vino.ino &&
 	    ceph_ino(req->r_parent) != path_info1.vino.ino) {
+		struct inode *old_parent = req->r_parent;
 		struct inode *correct_dir = ceph_get_inode(mdsc->fsc->sb, path_info1.vino, NULL);
 		if (!IS_ERR(correct_dir)) {
 			WARN_ONCE(1, "ceph: r_parent mismatch (had %llx wanted %llx) - updating\n",
-				  ceph_ino(req->r_parent), path_info1.vino.ino);
-			iput(req->r_parent);
+			          ceph_ino(old_parent), path_info1.vino.ino);
+			/*
+			 * Transfer CEPH_CAP_PIN from the old parent to the new one.
+			 * The pin was taken earlier in ceph_mdsc_submit_request().
+			 */
+			ceph_put_cap_refs(ceph_inode(old_parent), CEPH_CAP_PIN);
+			iput(old_parent);
 			req->r_parent = correct_dir;
+			ceph_get_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
 		}
 	}
 
-- 
2.34.1


