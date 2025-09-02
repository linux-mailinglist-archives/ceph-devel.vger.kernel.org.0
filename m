Return-Path: <ceph-devel+bounces-3501-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82AADB40DA4
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 21:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 009731B272D7
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 19:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD1E30C35A;
	Tue,  2 Sep 2025 19:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="r1Pqyo+i"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6042DC354
	for <ceph-devel@vger.kernel.org>; Tue,  2 Sep 2025 19:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756840150; cv=none; b=Mr2VODSBQyuMR6+yO7pq6wPIAcaYLFxuOMbYJpoTqheHKyFADn6OHqC14lFzECMOyQQjQpuRRdQE6aBLHRUU5PKda/zsdLvmlo9dTnef/v2NdsLjCJPk9z8j8whRnNzSWqQ555+yOjnvcqq0Ll03ulZcIdN373bN3RI+eBvaNk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756840150; c=relaxed/simple;
	bh=gjGgx7UzJvuEyQuXnBwthfDf5jaQSwUQg9LipixWID0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cpsqaG5S0x2DpmWVKyqg/nwuYjsD53+eiS6v2G3MR++lrVkGoAl9Y+yfurRiu0zu9iSTeLnQR9cYS1uCsYAG1vlb45WNZImbfzvNizr/0CYs7tv4MYEZUormRuSUQ9lkcy6b3BV6IdmIRhsbJMyhntE+o4fDJnrN9gKw5ZDCc6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=r1Pqyo+i; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-72290cfcf5eso20235727b3.3
        for <ceph-devel@vger.kernel.org>; Tue, 02 Sep 2025 12:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1756840145; x=1757444945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pfhTRMxc3w4sI+Ws9TMxQJGhGxzrh9QlIlnNCmqZ880=;
        b=r1Pqyo+ihikKuZBpYgFjx0h1ivqYwY8pGnqxl/yZBVBX7x2Q9x1HzR7YFSP7pcMZoS
         Fh0rNLD3tEiM4j3zYvfZnAII5LTBgCv6G8qLzbgjnBg8w0ByC+33yz+1B3BG0WBW8TQl
         zneGavQ953giy4CA8W5pKLXXhH6EixCfP0xI0qkFWYmbCgZLQSRM1HYE9EwGdASAPZzC
         SuQRB4S847noPpq6t1X3i3Pes3pnbsmx2MvUDwdxOu4JFm3BrJ7Ss8yIbJYakdXFJfr2
         biEuHz1c6crMRR/6AdgPUNaErlpLWzbbSfDpCEcRmC6L6QpVqOJHnVTZxxXEV7kLO83q
         sYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756840145; x=1757444945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfhTRMxc3w4sI+Ws9TMxQJGhGxzrh9QlIlnNCmqZ880=;
        b=Zh1fTukQNyC27UVoIWfVYnvoIGJX6uVopWgdy5KvxuJMfCr+kzItGwfHzQu4IZlixp
         wjNWgrHRZmLdt4dZOUuZ15lw5FVtcQiKfp8AR5E2EPvJbKiWjbyj8ORo+jHv73dLBXPp
         4J0iEps7wjmjvUSif29yHjAnLI1kA4yKdc3AeE+n09OguesOe4/7by8qq7ZzKP7NnKH3
         csBmy2NMyrqRnn/MTIiGP+1dXb9fNRnD6ET3ZVN3ceQjvz4IbeCjx6lIerE8w13eIgDG
         nm2aNZVFYlTJSaXzdAM6w6gSf1yM5wMK0vRhlpUkMOmZ4pDMmDoMO5t3CYu63hw2qARQ
         Aj/Q==
X-Gm-Message-State: AOJu0YyihUInAfmJTnlXADljHDp591jkt8LyvwRvugd27dTmYJAtVac0
	AujnraO7qXOpRtBltaY2wNIwL+OxZUAUe51yqepE1UEjckwmp/HPxsxdeIPlSfADmlArrPq/kHn
	BlM7nz6rcOg==
X-Gm-Gg: ASbGncsU1Z+pLgE8JOci1a/NGLwEbxjW8QmOT3dvX7BRhlucSaqGDAyNSaYo4BKtMkn
	i4zw3XmYdGbyN3j8oBiLeGnSmlji/zHU+LOJfy+z/VVpqfXzRa/fQp022eWS8PmkniNF7/VgWgJ
	w4+3o98xxTB5q40oZLqplajme/m7yUD4MW2atEgjW3EC6u1XvQGirOeSIYdWpghYQmzNXWENzue
	NLL3E4IzGRNJsSdYYOmtiAtEwmcU2hi++AXxfKUFD0xdD96inlPcAXC6+U02Ux8D6ddjVR4SmfY
	jNfbGM77ZvQNnm3MjqrAj4N8WLll3VU6/jwDXy08I555OnBnS3QqNao65vKqulLdaJQLPmpiL8t
	r0TaSF6qxyQxypRO/vEMzjQ3XwKjakyNGKNWeHOs=
X-Google-Smtp-Source: AGHT+IGKmAkpxRyQdHljA2XIyxBhLTt0nmxyvM8eiqBA5oGrXxrshIKoAfdtOjvA5NjNy829Lp+vGQ==
X-Received: by 2002:a05:690c:f03:b0:71f:ff0c:c96a with SMTP id 00721157ae682-72276406d4bmr152569777b3.24.1756840145112;
        Tue, 02 Sep 2025 12:09:05 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:5abd:b705:e7b:f18d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a8502869sm7321657b3.35.2025.09.02.12.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 12:09:04 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org,
	amarkuze@redhat.com
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [PATCH v2] ceph: cleanup in ceph_alloc_readdir_reply_buffer()
Date: Tue,  2 Sep 2025 12:08:45 -0700
Message-ID: <20250902190844.125833-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The Coverity Scan service has reported potential issue
in ceph_alloc_readdir_reply_buffer() [1]. If order could
be negative one, then it expects the issue in the logic:

num_entries = (PAGE_SIZE << order) / size;

Technically speaking, this logic [2] should prevent from
making the order variable negative:

if (!rinfo->dir_entries)
    return -ENOMEM;

However, the allocation logic requires some cleanup.
This patch makes sure that calculated bytes count
will never exceed ULONG_MAX before get_order()
calculation. And it adds the checking of order
variable on negative value to guarantee that second
half of the function's code will never operate by
negative value of order variable even if something
will be wrong or to be changed in the first half of
the function's logic.

v2
Alex Markuze suggested to add unlikely() macro
for introduced condition checks.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1198252
[2] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/mds_client.c#L2553

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 fs/ceph/mds_client.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0f497c39ff82..992987801753 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2532,6 +2532,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 	struct ceph_mount_options *opt = req->r_mdsc->fsc->mount_options;
 	size_t size = sizeof(struct ceph_mds_reply_dir_entry);
 	unsigned int num_entries;
+	u64 bytes_count;
 	int order;
 
 	spin_lock(&ci->i_ceph_lock);
@@ -2540,7 +2541,11 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 	num_entries = max(num_entries, 1U);
 	num_entries = min(num_entries, opt->max_readdir);
 
-	order = get_order(size * num_entries);
+	bytes_count = (u64)size * num_entries;
+	if (unlikely(bytes_count > ULONG_MAX))
+		bytes_count = ULONG_MAX;
+
+	order = get_order((unsigned long)bytes_count);
 	while (order >= 0) {
 		rinfo->dir_entries = (void*)__get_free_pages(GFP_KERNEL |
 							     __GFP_NOWARN |
@@ -2550,7 +2555,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 			break;
 		order--;
 	}
-	if (!rinfo->dir_entries)
+	if (!rinfo->dir_entries || unlikely(order < 0))
 		return -ENOMEM;
 
 	num_entries = (PAGE_SIZE << order) / size;
-- 
2.51.0


