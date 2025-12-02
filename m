Return-Path: <ceph-devel+bounces-4138-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D0C2C9C0F1
	for <lists+ceph-devel@lfdr.de>; Tue, 02 Dec 2025 16:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C4833A96D1
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Dec 2025 15:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B522332572D;
	Tue,  2 Dec 2025 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UALpyLHA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ntJPrTHX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A04A325496
	for <ceph-devel@vger.kernel.org>; Tue,  2 Dec 2025 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691084; cv=none; b=ZuDCYJykC1sA3x2gWLblEVt32Tlcridh9aVRCgqol9/bybmWiHVfTAKevA3xvrjbdKqFkbop+By59cTcj+wZJZtcvoClMYSFCm+s4ZPrA3BGvOBcdB7QWGE764p1axk5DAoKGq4PRcEmOoQmGt3ZsrlhTNXkN8nX+XCp+26m93g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691084; c=relaxed/simple;
	bh=B4xyzwDKGxq/vyrw5rw3MiyV1PFc/MXbtlIPEadsNuw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KLr3QL0tFme84NaFKK0WsnkdXgBcSqt2mIkLf35VhZSb14e9NTj4Q6zG7joDw3boMawuLsIEIMEBbMcJ3/p1RSkUaHzuQ1FpOvCDkQcm64rvnaeF4kqQbugO2SQJrsfKIa1XOlhwwnqcz0VLk/YfI7TEqxaFhYnuSV6pU8T/6AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UALpyLHA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ntJPrTHX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764691080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jcDCLLxng0aZwTmIpvTEU2QWfymaHSnvSLSvvAB+tII=;
	b=UALpyLHAc9MdstXlaV27J2cGlD7AJk2Erp5ba//LZRB9XEEOHwN0UXm5FEhf4qRwc+ed0Z
	holPQO8Gklkvr+jde8SG8YXHM3uJUReHbCzxrQ8EX3bN0IjCrhNdLwfmWt3YFIK7md4Ulm
	nFwbKHN9SzdjD3sIZO82FWLblPHeLcU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-1FNBNcaMOxyE1tv5_8vbNA-1; Tue, 02 Dec 2025 10:57:58 -0500
X-MC-Unique: 1FNBNcaMOxyE1tv5_8vbNA-1
X-Mimecast-MFC-AGG-ID: 1FNBNcaMOxyE1tv5_8vbNA_1764691077
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b7270cab7eeso471277066b.1
        for <ceph-devel@vger.kernel.org>; Tue, 02 Dec 2025 07:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764691076; x=1765295876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcDCLLxng0aZwTmIpvTEU2QWfymaHSnvSLSvvAB+tII=;
        b=ntJPrTHX/gUiVAVx4QWdb24IJ2iBM05XetdGLBWY8CC6EkG8trhLZRLlnHKgwusdjq
         eDrxBWxW3Hc9F5JOU6YuN+ayw945Rs9OC148ZGt8QFxgi9Hrkp8IreszHu0ERMHwRGbh
         Drwtyyu4t3CNPw7Cp+EoSB1GDY491aXU9IhM96iOmPzQYuXcP+DOmxV3mZlVcSftRGS4
         pYjjZy4bX6E12prFrm0OAHYMy/n3g3iC/qM8GtFdsoVLac6k5cWfndG17eqidOaYGjcP
         AJmPN0mChdSNt60rqUAjP5gNg578IrLXwGvw+Nt29CC6jn5F+s28cUm+nIrP2IlMOCEC
         dA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691076; x=1765295876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jcDCLLxng0aZwTmIpvTEU2QWfymaHSnvSLSvvAB+tII=;
        b=KaG30rAUeYXjxH4ZeTMGZjhEfhevWpXE4pWVwsazPbDQROp+6iDg+njewiGSKEDbLR
         97ausHaB9QtK64YqQG0AbNHL/IbS+8Ib3DAa0dngNmP0EnpgW4ybhQNS43P0S6fF5MgI
         7o9VID9Tt7KrRqDFarsuD55xEn0kR/zyeEI6MrEXss1btYc+mfTlO5wv50ty+uIAfWST
         U4MN8UO9R5jGuFayE3VlZ//63R+54z8lftgJU/KmbVna+gV1UBqzdah8bAMWEsswQOy1
         hn5aDdei57puJEamZjaSM4uvp7UItHSLMEAOZkRVLWIhhDrmh/GO5gDoN8iWvY8Gv/9V
         /RZg==
X-Gm-Message-State: AOJu0Yw3coQycmG9AQWJtGnbD6ZhEjvvVvAoLkymHzKrqtbsh0yO2F6K
	HRql7NzrzcUzvt8FzArUcYGyhOx1/HL1zO67ZXOZN/Su2L0froCuy0WycQTmETcU65ML4TdSu2f
	9NWFnjY/HKQY2y45lWVM2zyLs/62ujLQjMDga2k7S42pCI0//rcmHCgl275wA0tZxR0JBLIbawl
	fTiSIUkFUUSSV8Z+QthQkxeIyvcZZ8KEzZE5MyLd5txIODPIXSaQAB
X-Gm-Gg: ASbGncsPaCOevdKdARsdd/yUudJCDyVPkFoCzuVKBhZJx7WmbdPw3pAMqZv2j1iCi2M
	+XfRdQ+Rn6QCFDUuSSwp9DQyW56dWdJAwEbO1QOm6wN0O+d8/Qyd0J3uHscRg9efmTdQgM/l4Go
	HZATCnrxWz0+D4Y39iwMp9ARP/QFC8uzQ4hGCYViCRVhLLEIA8yOvkeRuEg96Vtcdxeb6oNIkv0
	xaYqC6lV1r2yuDgi2oAk9ahMl9zSqWhStddvEaw9BHS/6DZ5Wgrdy78ubghyWMfh6UGvewp9poS
	mcMrah7b2txAtwCGd8es7/mvIpAKDowU+DoYH0nDHolhJ0ao2CC6u9J1XLR2T3jwBPY+865VrwC
	FxkGd7rxEvdMmTgCRhugQxgkNMjtytDmJtGATM0u1I7A=
X-Received: by 2002:a17:906:6a0d:b0:b73:6838:802c with SMTP id a640c23a62f3a-b76c555af37mr3217148966b.42.1764691076582;
        Tue, 02 Dec 2025 07:57:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG8DAKvgNQ4AiYWOBCevqR0FcuMTS7aYizAyEt6RtRcIesRf9HBpeD+CBkrEzjRs79N9bz4QQ==
X-Received: by 2002:a17:906:6a0d:b0:b73:6838:802c with SMTP id a640c23a62f3a-b76c555af37mr3217145266b.42.1764691076125;
        Tue, 02 Dec 2025 07:57:56 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f59eb3f6sm1520702366b.55.2025.12.02.07.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 07:57:55 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH v2 1/3] ceph: handle InodeStat v8 versioned field in reply parsing
Date: Tue,  2 Dec 2025 15:57:48 +0000
Message-Id: <20251202155750.2565696-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251202155750.2565696-1-amarkuze@redhat.com>
References: <20251202155750.2565696-1-amarkuze@redhat.com>
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


