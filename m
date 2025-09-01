Return-Path: <ceph-devel+bounces-3496-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 599C8B3EAB7
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Sep 2025 17:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C3EA481389
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Sep 2025 15:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DF932F773;
	Mon,  1 Sep 2025 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QP1aiEL0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908F432F76D
	for <ceph-devel@vger.kernel.org>; Mon,  1 Sep 2025 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756739699; cv=none; b=HeU+eEpoxIsL7f7F9C2OC1KaH28cX58zGbvnX557r5NmHh7TVhTU2+infE9IBWCHYVuWKwnMBX+srMch1j+Yh1bYru5rwUBczbqHVdsxlamev6A/Ca+HAks3RVKBiCUhVWpdjMG4wemh5b/E8dY+qVzhl1pDwHLnDO3t3Q8P6Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756739699; c=relaxed/simple;
	bh=6qMh0KDCJNwTdqjfkdAMug2wJ6BOezze1tS85Zw9uMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M5fJj4s2BB+I5yUTvQF++4tCzunMTpX6WIeJ5qxh6Sj8pWIgjYgV1C3PQdSqRtlbnTayEv0hOHuDlm9qBH91jC7BKo10jPjtO2iFZHEVFzBrWBtBiO+UFcjZ2nO2JgspaEu8lGqP1byJcDTL5djAsAsaMmG7YmxhBF+mFwSpZxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QP1aiEL0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ym5UK/Mx15ICfCms4UjVMy/cz1F+8Lwq03O7rLyNqnk=;
	b=QP1aiEL0aUOJP6a5910dCbncuAKyfA5XrOkSLYHMuzQT+2Fe4LSnYfGW1aoO5SaviwrCdh
	005rAOIPS/ONZuOf2z5tsFTYzCjmFdFIxYpD9sgsGbei+Gp34kyO3k4pGyEQt6cO7z7PQK
	cbUFmF13KNCuT5gD/4b4vmwtpS35krY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-d9BK8vR4M96uoMnzF1d50A-1; Mon, 01 Sep 2025 11:14:55 -0400
X-MC-Unique: d9BK8vR4M96uoMnzF1d50A-1
X-Mimecast-MFC-AGG-ID: d9BK8vR4M96uoMnzF1d50A_1756739695
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e87069063aso1466897985a.3
        for <ceph-devel@vger.kernel.org>; Mon, 01 Sep 2025 08:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756739695; x=1757344495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ym5UK/Mx15ICfCms4UjVMy/cz1F+8Lwq03O7rLyNqnk=;
        b=czQQiCNurlvFjJGmBYGhaSAC2nbo6HobQ4DCn0KmYzbwNBSCt/XZZoTgg9cWkDkkCE
         TzYtUWYGwKroGPyfZhv4yDkt6z0bHXsd4A7BbLtfYIbb0uKhNkXy6LrC8U/jjqMT29Kz
         Lpr36InfjvUj677EjoQTg8ZSfjirvE8Bh6eKGviu729HCVyL7sCP4vbLvWqtL5LYP8mY
         ZEpZ3Nlft9uD8qG7igD2lmCYPMUClVXEB//inazwiGrZzwQbfH3HbKH8NueOje5M7ZCg
         vq1yuJ2SO1NAOhGAp2VxE75E86OIXSkO5flZlZqalnCvdgc4z9XxmvBBApEJh8geOtrS
         yklQ==
X-Gm-Message-State: AOJu0Yzssaw3oqnOAU9oZ9Tm7GEvKpXlc9I4ciqa7zvElVNGeEwP8dLi
	eymB9MS6p5prMODOJtp5HfuFAJsEI9+BPO/2dAQQwXnGvZa2n8WdO+KKcQGqbl4WRcC6XFmhBSN
	kTc75IW4IfdFq2vHXfJpKD33T8Q7xzipae9sw1+fRojjSsZ/NJv7yFPjlv94sF10eqiaBevbjez
	H4yrs2YE4BKE3g8YCdWPxoseO2vzRskBMnstMO9B8g0DQi99yFUg==
X-Gm-Gg: ASbGncvX+0LP2dcLVa+TTEsGyvvDgaOQ/bxa+5igaA7Hv4wFrhHsOCpJ5BoRN/irlqk
	im5NN8gIfK+Y8bkfPA3+yNwgglOVmJ6tUYKObt7jHebInWrI0lfq547zScQzW+Sx6WLyUkeleeB
	JiNKlT0ZJD6oc3pmRBJQD49gA1pA1hgJoAUkwA4e5KeYik538TQ3i/0mORxcU97BFYST7h+KAVs
	3fAO74p6WQII/MUbAueAQBtzk4assfhxDsGgu26454RUfINrUcz4wcQQNMqu7CrXWwQmNYvuz2n
	tbqCeIsJLrvCMAgwR+1wOpqsLByndKmyfqrYXiQ2JRZFzJbki73lvx/HLS0RKoHJU7gXdL5Mzg=
	=
X-Received: by 2002:a05:622a:259b:b0:4b2:f2b0:32f4 with SMTP id d75a77b69052e-4b31dcc27camr87769691cf.82.1756739694588;
        Mon, 01 Sep 2025 08:14:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoSuUWq8d1895qWYOM3TzW432SYmyk5JdQIz0QDRVbZIJavWFSwqVy3xw01uX0V5tPr4oIyA==
X-Received: by 2002:a05:622a:259b:b0:4b2:f2b0:32f4 with SMTP id d75a77b69052e-4b31dcc27camr87769091cf.82.1756739693926;
        Mon, 01 Sep 2025 08:14:53 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b30b67894bsm64286011cf.33.2025.09.01.08.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 08:14:53 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 1/2] ceph/mds_client: transfer CEPH_CAP_PIN when updating r_parent on mismatch
Date: Mon,  1 Sep 2025 15:14:47 +0000
Message-Id: <20250901151448.726098-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the parent directory lock is not held, req->r_parent can become stale between dentry lookup and request encoding.
The client updates r_parent to the correct inode based on the encoded path, but previously did not adjust CEPH_CAP_PIN references.

Release the pin from the old parent and acquire it for the new parent when switching r_parent, ensuring reference accounting stays balanced and avoiding leaks or underflows later in ceph_mdsc_release_request().

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
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


