Return-Path: <ceph-devel+bounces-4220-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8622ECD94DD
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Dec 2025 13:38:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E36093049B09
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Dec 2025 12:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D46E337117;
	Tue, 23 Dec 2025 12:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HPmUhukL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fmeTWbfb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2545F336EFE
	for <ceph-devel@vger.kernel.org>; Tue, 23 Dec 2025 12:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766493322; cv=none; b=MTt2gCpBodaKlf0TJFJzCEcOwiTG13WTL+qQ1/s9K/88xGvWrMBMak2a3ugK9g9LeKPxcneW9x3v6sPyI+j/uZhHS1VB7L+Pnp0pJPQsiTwDHAaKLTYYMefDhNvR0dmsdDBDsav1uNCwrrpeSQhBMWFWGeqjk/JMwHO3YjbQzj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766493322; c=relaxed/simple;
	bh=B4xyzwDKGxq/vyrw5rw3MiyV1PFc/MXbtlIPEadsNuw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mq4GDVgUCKH4g3lRBDCxRTUyKapk461esc4kRkiOD5+OlXfiEyPY/iBRw3m/V0OrBQszOUTWifB3A+20QKFmpAaELoA1jLO+olRzZGHTi1JaFOQjGKOjA3xz3A6BSaBGgqyaQhRWMvCuX/WREYrakYmzRGGnnm2I4PAMlXFvJxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HPmUhukL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fmeTWbfb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766493319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jcDCLLxng0aZwTmIpvTEU2QWfymaHSnvSLSvvAB+tII=;
	b=HPmUhukLm73eOAeqE0V5YujP/jNLNWKte1UWe/dyyWL12ZlPgGu2Eob3VWSWPqRJfYji1S
	Z8/V7j4E1oU3qFrWzbC1qvLNBL5zHPl7Mu4zduKx80HZFImQaW4N5EQPVSiUL0u4vcyyaI
	0oQLq59GsAiR6q8Kq9sciQWZEheatvk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-VaxJZoc-PhCSxz_CK55_lw-1; Tue, 23 Dec 2025 07:35:17 -0500
X-MC-Unique: VaxJZoc-PhCSxz_CK55_lw-1
X-Mimecast-MFC-AGG-ID: VaxJZoc-PhCSxz_CK55_lw_1766493317
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b7ff8a27466so570305566b.3
        for <ceph-devel@vger.kernel.org>; Tue, 23 Dec 2025 04:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766493316; x=1767098116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcDCLLxng0aZwTmIpvTEU2QWfymaHSnvSLSvvAB+tII=;
        b=fmeTWbfbgVJoJMDuiSRZCwCXMQiikuA/IoAACTkk7uPGtohWm3gh/WrmCahH4TysOZ
         aEWHxKNhULlkaPLjN2JMuBYS/qAd3aTmCAJIzz9bM1AuOtSkcNMFmUHfYK+wgzknH3U7
         BQW5Xc9iP/xpVgVlbZj+pnkyzGF7kl4pTxgqp+6edsY53NhFVA0wgg0k1rKk57WHpRtE
         Cs/Zck95WG2B3BFN/t6Q9lBvuecez3e6jOXOtgeuhz0aLA/w4aWaj6nfmbE88f/fWEjL
         EGdQEhElIQR8o2c81TYpr0h74qiK4Wu7xMszP+cEP4a0ZQjrvp16L3dHZv3xziHg7AnM
         LtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766493316; x=1767098116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jcDCLLxng0aZwTmIpvTEU2QWfymaHSnvSLSvvAB+tII=;
        b=m8VVAy5dfgjapdcL7C8UQNQo777MXWN9ch5Q8c9idf03vKOXSBUvs0Y/4/Nvl2ltmF
         J+suV75lHZhyVEYrN7Og6XoWbVB9AO+1V7cZTRSbWymAaAi77pseAsm0AbCFWEzokbE9
         Sei0RQhRho2Mt17/PMJttCSBqURlRokaAlWGSDTRiduV+LVNOEa6JhFtLL1dbGgczu4m
         llWeSDMWj0HDfU0Dx9f+O0ZbUW5lXLWWmIfwrQC32QS5OYkCfyQXZia/VtuyLlsrQBiz
         2hnkVrsVV9Ba6at6gismdUjEeGKY0y5mNFNVLnDrvjLLZw+XkrstvSzBJ+9Vuh2qB1mb
         ia7g==
X-Gm-Message-State: AOJu0YxWYtvyK/VVoSSQgjnIx1xtWJ37I66VSfqGGJwkJz4nhjpt5Lxg
	jw0Smmj87zuBgt54GVpQjGMR92uI9a6HOUIbmS9SVQNtaA8MXx0OA9SK+/ODmZMMSN+C1Py4iIk
	/yvEAqEm2Ouo6FbUyFWj5j13Fnw/TaJVF0dcshNRWXgY45bbcdXLscV/GxCp+eXhinXRXYenuTF
	qbx8hJbZORjh03lYhhgtpTzuKjC+Ko8Af+cOAPD0HtnILlC2gokg==
X-Gm-Gg: AY/fxX4ARvGzJrVPjqw923aPM+RGCG2rgyaY18atWd8F0k9OaDOO5hW62iXyHkViA68
	bg+sNJex3WfG9DKH0UmeSl1Z6i0W0JerrULsn7HtCGJ6o9UfMVmYaWvl080PToXPlQDFV5PWjnu
	fQrUn35Q9I72QSM7thKH/QGgiKBKsOpC/EkFq+7975kZyutXzq8vmQIA5pMYCqHzKhruCD5S5Co
	621AutM2J5QuGgPqlpWZUbiOvIDdiN2JC84uXpdq+fxBWDPfEKgAopiefeQwrDDCW7gI3a/+A2/
	qo2PV8BiNCjZIkeGh2EdMA4ScXSOSR79Ruku7p+HNOK0sjg/H3rLPlN8e+MS8fzbbF2Y2rmd8fP
	hlqzO53lRQnF3DlEM4jHSemPwMeYUUhToDDWHrQfc19k=
X-Received: by 2002:a17:907:3d42:b0:b73:a0b9:181a with SMTP id a640c23a62f3a-b80371df391mr1542383666b.54.1766493316428;
        Tue, 23 Dec 2025 04:35:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExrun+Zq0TkoEnG1zYuJwmjwgqz7edHNFpN5rqW3xzlyjFGy/KN5Wd1rXi9RQhM5Hdz3CgBQ==
X-Received: by 2002:a17:907:3d42:b0:b73:a0b9:181a with SMTP id a640c23a62f3a-b80371df391mr1542380666b.54.1766493315965;
        Tue, 23 Dec 2025 04:35:15 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f13847sm1353357366b.57.2025.12.23.04.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 04:35:15 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH v4 1/3] ceph: handle InodeStat v8 versioned field in reply parsing
Date: Tue, 23 Dec 2025 12:35:08 +0000
Message-Id: <20251223123510.796459-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251223123510.796459-1-amarkuze@redhat.com>
References: <20251223123510.796459-1-amarkuze@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add forward-compatible handling for the new versioned field introduced
in InodeStat v8. This patch only skips the field without using it,
preparing for future protocol extensions.

The v8 encoding adds a versioned sub-structure that needs to be properly
decoded and skipped to maintain compatibility with newer MDS versions.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/mds_client.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1740047aef0f..d7d8178e1f9a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -231,6 +231,26 @@ static int parse_reply_info_in(void **p, void *end,
 						      info->fscrypt_file_len, bad);
 			}
 		}
+
+		/*
+		 * InodeStat encoding versions:
+		 *   v1-v7: various fields added over time
+		 *   v8: added optmetadata (versioned sub-structure containing
+		 *       optional inode metadata like charmap for case-insensitive
+		 *       filesystems). The kernel client doesn't support
+		 *       case-insensitive lookups, so we skip this field.
+		 *   v9: added subvolume_id (parsed below)
+		 */
+		if (struct_v >= 8) {
+			u32 v8_struct_len;
+
+			/* skip optmetadata versioned sub-structure */
+			ceph_decode_skip_8(p, end, bad);  /* struct_v */
+			ceph_decode_skip_8(p, end, bad);  /* struct_compat */
+			ceph_decode_32_safe(p, end, v8_struct_len, bad);
+			ceph_decode_skip_n(p, end, v8_struct_len, bad);
+		}
+
 		*p = end;
 	} else {
 		/* legacy (unversioned) struct */
-- 
2.34.1


