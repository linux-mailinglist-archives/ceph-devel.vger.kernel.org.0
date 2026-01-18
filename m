Return-Path: <ceph-devel+bounces-4463-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A2ED39913
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Jan 2026 19:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0AC8E30051B6
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Jan 2026 18:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD402FD68A;
	Sun, 18 Jan 2026 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUTNbPod";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LWiHCYIN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494FA2248B3
	for <ceph-devel@vger.kernel.org>; Sun, 18 Jan 2026 18:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768760697; cv=none; b=WocgR06MLbrqjyq0B4tAMeM0raS8ABlArxG7l58dJAnBgyOhW1BaFIpgFOhZ67LDaCmGiqryQRaXPVoRVvxf561f8FckcIfQajXxam5cZ0lLYzctJOk4SalDxkuigkYMORk+mh6Gq7D3+V+9ovK3WfdPk+uITOPLGG5AS5fXgy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768760697; c=relaxed/simple;
	bh=B4xyzwDKGxq/vyrw5rw3MiyV1PFc/MXbtlIPEadsNuw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pFU4MZXqy7uFLHVs4ZVyOzciq/Q1o1UKh8dVIr63NLoxvZuOu+2URQZ39oHa2zz9/fcvQoFZTYqVCnK9UF57+kO3bKwdKSNCZWW1JS4liLtnVFbPIKYsZXmirwj7xgklDvLt1Pkso1ipG1d9biUfY3oj4TxY0Mp2qFTPyhL+HtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RUTNbPod; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LWiHCYIN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768760695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jcDCLLxng0aZwTmIpvTEU2QWfymaHSnvSLSvvAB+tII=;
	b=RUTNbPodIsbl75Jm5TVnX043QYRd22rTzNoAMY11GZI9oGBUkjU3gBSPQ3aK3viUo6Mn05
	blD06c6nwW27Gfb7JoLEGr3FK5jROyyrMEHeivjqBPzHnO2odvdLa9XZLvICn0GayOkLtY
	Bll1zNNYi/pyUrubCOtn1Cu3gQi8oq0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-VZaejnDfMCW_0j5AcxQbow-1; Sun, 18 Jan 2026 13:24:53 -0500
X-MC-Unique: VZaejnDfMCW_0j5AcxQbow-1
X-Mimecast-MFC-AGG-ID: VZaejnDfMCW_0j5AcxQbow_1768760692
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-655ad4e971cso2831437a12.2
        for <ceph-devel@vger.kernel.org>; Sun, 18 Jan 2026 10:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768760692; x=1769365492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcDCLLxng0aZwTmIpvTEU2QWfymaHSnvSLSvvAB+tII=;
        b=LWiHCYINKJThgM2k5S9KKgs/TwnO7kQLvlMWjchP2klwGUtIlCIKEDX1b3R7jAdqU/
         YnN0JxjHFVEPTWWddT1lAXcj8pfMWrz4NAIPg4mAQWhMawKG5vLZSOsHXPuoVwbF55dk
         htrsrIZ3qGYmYq/osNCwzVXbS1GPj0iQu/MYA2F0j3p7UYx6rNtp8X42jCFDKUtXmF9s
         5vTAy+Xuy2UYnxheBT7p5DLycREacGau++8mMr4wDtS1XOZyfGsYR8/EHDMOlfiGW3Oy
         T0uoAAxbH2YZ0KtPFTx/p5onnnWBWYJ6zW7pea0XHl5bWI62ErcesaZlPgk8ro/3w5OZ
         GxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768760692; x=1769365492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jcDCLLxng0aZwTmIpvTEU2QWfymaHSnvSLSvvAB+tII=;
        b=eUf/TS/8TOWUovLk9RvP9zzbzVEpWJtmyCmqmwgA0u1ZajQfGWE+zlCbZIPi6A3zQY
         o8kRkZ2vO+yYgj8P1gBwWMp7MRzS/0/BDQPLT8xQLaCweSqbQdBdvjEz9y3jHtyLgBf5
         MwuBZPN6UAwR50RMyhV6AjsAq50bcPV3+eD/Nn64Zwotl54vfdmFaPDoEbjsw6uC+Oqd
         DZwogHHP+HpP0J16DQdLzGk9BYkv0EE5lTeEJC1+tzbSFQ4E0J8FtrNygU/T6SanZDeX
         CDzBfbhMpQbGXLE4SGZc+teY0YG4dMnOklA493W26jeupWjYPHuJLU6nP+MBKIIRWC8X
         QUYg==
X-Gm-Message-State: AOJu0Ywzs7ixCBxWCR8rQ6EgeR3XEMUgo75Vgk0GSaZi6RmM9Jqa3rSH
	XmQ9mU0xQwxWvVBHIpW0tZZbaPFfQ2Hot0yzUYkK68wSqNkGCjlvzgZ+65TKztMciiEMwV6Xqqi
	U92sqJ+ZXuRde7lYNA5m+18vGUZ6rXBxzXzt5Qet3T6gyoEJwxbBhP7/dfxkPEOI2vaaTKwqTro
	AjmM5k9QRKsuu9oDReykhb8/Wq2VnEHoEj0XTQFoFaezV+RIw=
X-Gm-Gg: AY/fxX4aJUCpHvZqZ3uTW06tJDH5jAAG1xeQGKMazYPNB4R9scLj2ooPB918wfQ6oC7
	Egl0+mYeKyGcdg7jDS2Nz8r4s+roUBa9RZ4e4Va76zXw/6R6vZyQTW54RGUsHkhFm8fcuv3q9xi
	b8lZvIdTYFXLDeIdLEr4D++xVNXaMsMlVQwvn/fuNgDce/la+04XLtarg8I1siAG1ob8IiWIx90
	EoFdZeQi9iZ6oc9YQBo25LmwSpnNjUz6tSkkQLwIbTUyl5trqAoVTS2latQioEwNcAIx9cWnEQ+
	wnD0Z0s32sqqKwVZR6hLjquOw8dz1rcq9QxVLvmpod3xP6d23HbbEAwKS4L5GV4/PjIBohs2pXf
	cJNOxjY8md4EG62CVo0dXyuJmi/MFv5ExmU+VnpX8CWw=
X-Received: by 2002:a17:907:7212:b0:b86:edaf:5553 with SMTP id a640c23a62f3a-b8796bb20f6mr815437866b.59.1768760692215;
        Sun, 18 Jan 2026 10:24:52 -0800 (PST)
X-Received: by 2002:a17:907:7212:b0:b86:edaf:5553 with SMTP id a640c23a62f3a-b8796bb20f6mr815435666b.59.1768760691744;
        Sun, 18 Jan 2026 10:24:51 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b879513e8d1sm907624666b.2.2026.01.18.10.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 10:24:51 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH v5 1/3] ceph: handle InodeStat v8 versioned field in reply parsing
Date: Sun, 18 Jan 2026 18:24:44 +0000
Message-Id: <20260118182446.3514417-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260118182446.3514417-1-amarkuze@redhat.com>
References: <20260118182446.3514417-1-amarkuze@redhat.com>
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


