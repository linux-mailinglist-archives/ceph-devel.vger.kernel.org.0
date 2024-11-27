Return-Path: <ceph-devel+bounces-2205-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D597F9DAED4
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2024 22:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B37328207E
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2024 21:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7912036E7;
	Wed, 27 Nov 2024 21:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="KSVW4EeW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2FE18858A
	for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2024 21:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732742434; cv=none; b=fUDQf1XAI3BbDrTzFVj7fWnCTj1PrQFRWUMY2Q7TZsggxmjxuXufRBO06ZnTLvVqbcgTewLZFQBjQkGhcaVV436gZuJJjsxCEN2W3Xkb11Goc6FtscYjmfOjHTrtureNgWZiDA8QJxfzqHG14pJLhsXDV/qne/a2g+YRUJkQqVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732742434; c=relaxed/simple;
	bh=m393FgBxZLWdYj7lNp0m3T+NbDxlfPibCRLFVAz8ZJE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SDCELnoiEAVxd3yomO9ggupx+lxDbMDtWp/+wwzkx3aJpZfYV/HUe2Xt2XKiAR7Ifu1Ttg1ErPbz1l245sIYyFotrt/y9sh+5MoUmALWNqFPsYuDzfne9cfwZ4ta0+zp1s7YhcvL8yYb75fub3D5+oD6/2Yz/5gvglEgQoSsWmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=KSVW4EeW; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-434a742481aso910755e9.3
        for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2024 13:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732742429; x=1733347229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MKfdXKuCNixmLGJZzJm5npXP+Iz02BGU7+wRejyTvW0=;
        b=KSVW4EeWSbf+BLRBTw/i0D9gRf1e8+Ytf8PGNYSFdrmRHFCo2Gg5yGB64ER50L8YPs
         OCV9d5Fu5cJMmiyU3HZhxoYJT0jhdT3dR54xFO2EWGC5FnlZ6sbr6GwZ6WKJ2/rxcDZp
         lNHUWqrYI8V1iSqrCI+ip6Rl/aT5GTrc5yLxtqcs8CO8H7zrjQQdI9D8s8HvAhfLP5q3
         cYKqtH4PcCDoD/yfQ5C1cRzFGrJnPOwOUvSZHlFhZllS3v3CGKRrWxKwI7YL4m5ox3+m
         gdx9BiDe3gTIF5RpBZGXVQnyzLd2gha92VIkXxELzxZm6eCDFLo31OkCPfUPohijBFac
         KP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732742429; x=1733347229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MKfdXKuCNixmLGJZzJm5npXP+Iz02BGU7+wRejyTvW0=;
        b=gqyWcfNh6xe+7AcciF4KFVXxkHSMqtJokrroErzfxvJnCm9MqKO7fbj2OEys+NMXrj
         V9+6QA4eGwLZmfyOFei5bcDa4b9ZyMhxT9c1IApq3jocFD7D9lmbHcHwClCg+s6mHD0r
         5hOa+jbHrOLS4nisnGSJwIS+XKBhncPOhelX1R0svJvKL/sfOy5FnQAd8vQL9AVkhpaj
         HDlUwkmV0i7VA+2Fuk8tEYTU91umZ5ngQj9AQ55ix3bpE4rjNA8z4FDsX9Wannh/eUm5
         ApzRYdGbs/ZXA2aYClt4SzmfA69GBTDsihgnvctSye4sJAj0vdIazlq87G0yI/kLRMs4
         TMxw==
X-Forwarded-Encrypted: i=1; AJvYcCVEQnVZfPtap691FHg1Z6Aw6dMtMzS9LqBloKgWt6GlfAP/RltBTCRwJn6BfkA7ft8iWoufS+yyJscJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyFpKHp1arUHaxE5cgMqCbhfdj/FEeaQk0rRhg0k2ECHh3vrrOG
	VfYUeo23vq56RTtHJ4vfaSbF4txernKjTc7Y6UO4RkY4bKOsuS2I6h+a/Zy+C6Q=
X-Gm-Gg: ASbGncuOMbs6PWsIE0Xzhs/7IKEou0QiNnU6aJcbmWPUGTmc5BDwEP+m07YicCKf4De
	JqMmkToI03ddI00fxGriIEi8MwSIfLGy61Ua+cR/sOigQfic1ytSzLhAmXFCNGjnyypsmO9vA5l
	ISRI9lBH07NnwVZc7ZL+JgvOq53GsOXgm2VDyfoYGpaqxxn2MFg0lyytjqIfXoL+yZ7qtIGZPYY
	AtHooj9rjS3y+lWI+557GT3J+jFEI5PhGxht+4kIv3+mu1eO3Z5lrz9VtWJdAjSvt6ueSKc0Qbd
	YI3/hMwk3m8RwS6C8xS7kBSrlRHUxut+7oCwcsXcJwfgVVWNOw==
X-Google-Smtp-Source: AGHT+IF57YQtZ6lX5ZxXc1iWwXjbntR0Vs7l+BNHyIQrT+euNq+feqoSBOd+EPlVv7DePMeGEUZXCg==
X-Received: by 2002:a05:600c:3b1d:b0:433:c76d:d57e with SMTP id 5b1f17b1804b1-434a9dbc43dmr41458265e9.5.1732742429636;
        Wed, 27 Nov 2024 13:20:29 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2c8700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2c:8700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434aa74fec9sm31929615e9.6.2024.11.27.13.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 13:20:29 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: amarkuze@redhat.com,
	xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
Date: Wed, 27 Nov 2024 22:20:27 +0100
Message-ID: <20241127212027.2704515-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In two `break` statements, the call to ceph_release_page_vector() was
missing, leaking the allocation from ceph_alloc_page_vector().

Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4b8d59ebda00..24d0f1cc9aac 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1134,6 +1134,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			extent_cnt = __ceph_sparse_read_ext_count(inode, read_len);
 			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
 			if (ret) {
+				ceph_release_page_vector(pages, num_pages);
 				ceph_osdc_put_request(req);
 				break;
 			}
@@ -1168,6 +1169,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 					op->extent.sparse_ext_cnt);
 			if (fret < 0) {
 				ret = fret;
+				ceph_release_page_vector(pages, num_pages);
 				ceph_osdc_put_request(req);
 				break;
 			}
-- 
2.45.2


