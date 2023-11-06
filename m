Return-Path: <ceph-devel+bounces-43-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 070617E1962
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 05:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 360D61C20A78
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 04:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9242D442B;
	Mon,  6 Nov 2023 04:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgCRHTvN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3869F8F64
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 04:32:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D286CA4
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 20:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699245177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fr5M2jkj7jrN2aEUHB5pv/CM9VJZCySkCDHmb5noEgg=;
	b=bgCRHTvN8xrI6FvgvXMUqPezB0a80z0AtMljqKfqAqKLhhT2gmxG6CAMEuM+bpFKYdGzNw
	OQQCHJAeEuGqLoRHCNzKvHbOM532ua8qnB1GLcW0WJ3xqXsMXRF0YXGQvTBKcfL7rvXcJI
	U9/rW90HW8wzdE/GxYuXS+cIN30Sh+Y=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-NKAKrA2oNsecQIHq948Y7A-1; Sun, 05 Nov 2023 23:32:44 -0500
X-MC-Unique: NKAKrA2oNsecQIHq948Y7A-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2804e851d5cso3511580a91.0
        for <ceph-devel@vger.kernel.org>; Sun, 05 Nov 2023 20:32:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699245162; x=1699849962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fr5M2jkj7jrN2aEUHB5pv/CM9VJZCySkCDHmb5noEgg=;
        b=nxil9DovMo4bwAsZjX69LjP+AvTVi0fI1ggzAHZEYEeX1IGqyuy+dz/NiAl+r7qxwW
         noGk2RnfslcMLdRMb2vh94obEr+t0QCcF2AA/jK3fOtopcAEw7yKJP6F7BZDaudI0gJ6
         85qZiaAfayCfD8b2GcDk4FJSM9TPq+Y+i2CYeTp3gMKZg10BCh+bou+V4oPxmC7PGL/V
         b9tZIxFwa3caPVspavh5NVkL+/4I/u6uCLScCSE23P7Qa5mRYEHVpDvUGGCjP0ynjRdS
         Lnf0i1eD5VQaY9bI7xthqMHDrq7Pyk+YMaox8ADhTuD/zxcH6RyLZC6MViKL1jUc472O
         2gJg==
X-Gm-Message-State: AOJu0YxQfUegN9r4JUf2RpPVuEA9g2E1baRKuauIdbpqwTsqofmmhvXJ
	z+E7k/bxAyssBhgdNIBi2SVOB3vNf0kZEOIsg4YSYlrAjqTQBnsViS0h566LMEa1sN5cKEAkNAI
	yjJB5m5XPX/CRaNmr/WtC9EPl4xG8dOaVCikyHIYVDp6U906FqWI91AJVRc++x6TT5sJHgNM2iY
	87o+Uihg==
X-Received: by 2002:a17:90a:1948:b0:280:2613:c378 with SMTP id 8-20020a17090a194800b002802613c378mr21030828pjh.40.1699245162046;
        Sun, 05 Nov 2023 20:32:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6jmMp1h+oiM4kNM0wzVOdpFgOG95yRnEiFl6Q0xwex441QwuXm4dtmhd7DmMfkqHrSGE/rg==
X-Received: by 2002:a17:90a:1948:b0:280:2613:c378 with SMTP id 8-20020a17090a194800b002802613c378mr21030813pjh.40.1699245161686;
        Sun, 05 Nov 2023 20:32:41 -0800 (PST)
Received: from h3ckers-pride.redhat.com ([106.51.169.35])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902f54800b001bbb8d5166bsm4855397plf.123.2023.11.05.20.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Nov 2023 20:32:40 -0800 (PST)
From: Venky Shankar <vshankar@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: xiubli@redhat.com,
	mchangir@redhat.com,
	Venky Shankar <vshankar@redhat.com>
Subject: [PATCH] ceph: reinitialize mds feature bit even when session in open
Date: Mon,  6 Nov 2023 10:02:32 +0530
Message-ID: <20231106043232.321783-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following along the same lines as per the user-space fix. Right
now this isn't really an issue with the ceph kernel driver because
of the feature bit laginess, however, that can change over time
(when the new snaprealm info type is ported to the kernel driver)
and depending on the MDS version that's being upgraded can cause
message decoding issues - so, fix that early on.

URL: Fixes: http://tracker.ceph.com/issues/63188
Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a7bffb030036..e1136009b44a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4189,12 +4189,12 @@ static void handle_session(struct ceph_mds_session *session,
 			pr_info_client(cl, "mds%d reconnect success\n",
 				       session->s_mds);
 
+		session->s_features = features;
 		if (session->s_state == CEPH_MDS_SESSION_OPEN) {
 			pr_notice_client(cl, "mds%d is already opened\n",
 					 session->s_mds);
 		} else {
 			session->s_state = CEPH_MDS_SESSION_OPEN;
-			session->s_features = features;
 			renewed_caps(mdsc, session, 0);
 			if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
 				     &session->s_features))
-- 
2.39.3


