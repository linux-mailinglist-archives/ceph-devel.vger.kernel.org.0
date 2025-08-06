Return-Path: <ceph-devel+bounces-3356-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC80FB1C3C3
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Aug 2025 11:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 022591897CBB
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Aug 2025 09:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190B328A707;
	Wed,  6 Aug 2025 09:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="dQsZCbzJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32B6289345
	for <ceph-devel@vger.kernel.org>; Wed,  6 Aug 2025 09:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754473745; cv=none; b=CmgnN4zyDAEK5W+8jKYfUVSrL7ys4sLkHQ0j02bquHEJ0Ry5IZk2X8lbjUfY+mvlq+W+8ihzXECqx8Fx71vHOblySv0KzATh5AKWLV+THx+tk/6Z0FCOaQwH25dFTnuBdAPQV5DjBfhhPDqyo5MnYvzmo2SxmgjoTtG37i8+Sc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754473745; c=relaxed/simple;
	bh=1YGQQ5oF6wdBoCReT6qqnw64tGjUt8KNamcQDHOlm4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXU5Wh31uBDLQyBnb3HrqQo8wDCWExQAyxDApgh8ozNsjlmkFdczEK1Ot2v+EPEiMpmsvCQZ20P54ZEElY0TcCchldbrWQUobwEtggaVtxBO4UdvtljfbD7k2DTfxDt3b5JYERHuqHSGjNBMyO7/jOCHC9SPPle9dUFSha6VN4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=dQsZCbzJ; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-615622ed70fso10142030a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 06 Aug 2025 02:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1754473741; x=1755078541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GG5PLhncHW4/uYRe700ffa/jWZYkRzoUW2i3d4oIBMU=;
        b=dQsZCbzJHqZo7u04UFrtYYvgoy1+yQRVNu3jophpgQtf51al/f21p7l6ULmvJqnSKK
         2NkiUZdOzcTZxnlZx1ZFYRa4oWeDXYhCkKjPKy089b3hFN0gZjHVWIf0rP4cM8eKygGj
         PkHKO24bca2x26gmgPcYe0c7H/ufamumM3aJOT0OvAc5so2b5wp3bPL3TzRlqt1noF+K
         AzzgshvACcvEaijCzj9RwcsIVRMcmt2/Kfl06/qHYtktKQyP+/zMGQcOhbO1taKiHQrg
         5Rlk2YOjdnKmKefXZUKK16q1pHLzIb1rupH0BKHG++ND9/T5GM8Kje2qKhwqz/ktioq5
         J/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754473741; x=1755078541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GG5PLhncHW4/uYRe700ffa/jWZYkRzoUW2i3d4oIBMU=;
        b=m7t+EWSSCgRSeSqoo0ErJgp+vOAc4oukji7F+dAJ7jw0nAqqp61G6jUlE0Utt5cDBA
         2YUXWEOPgLYrl2HnoyNuuWB6Vix6l9g23O2p+5UJ/1tkq4batoeUaAJve/9on/Ck1PVi
         +nm74REY+R5/DnztUEyCQ8m/ElFNg88/SjS6jsdXdAEvhlfDItyBmCQsXhMX1an4XWb2
         Qua8n3GS6QzMsmkC78Op4Fw91peW9Cz6sgOQmjr21AmUtBx1tx1MtgyzhIYvAU+u8Cj/
         cI3h/vkgU/mZbKa4EC+AzeHlZDN1yQFXEHUZ+/nr/4W8QErVB5cqT09uvBrwYVhakPC1
         pP/A==
X-Forwarded-Encrypted: i=1; AJvYcCUGHskJsVwvyPs8H2czDivM7xPIYrkvU1Wak4JBieH2+LFwTUMUuncm9bboPpcsXyVoBaeeJX9Buegx@vger.kernel.org
X-Gm-Message-State: AOJu0YzW3oDSo55T/JECUHDqwm3pXuJxBt8xrizFmaH5SYUSfdWFzK4l
	qfjTWHKwMJJIdMCRFtF1UpM7AyN/7ogqQGDmBzqu3iKh49/1Ywlc0qiiNe/yj2Jh+Do=
X-Gm-Gg: ASbGncv3yw/OKiOP623JJAXs8qzwJfXLR4dVwVu8GMIEZqawWCCJ2lyIrGefH6bQTCK
	kejAjl17fi9i8Z7C7l+YiU7clrkuklYYkYi7XXWo3jJg3mcWDvMJ70aRV9/fK1ETOaHjOkvFYy9
	6wayNhXo788WxW7VuB+jaM6VDez3ucKl7vpl9RkP+Mafdvj+XORtGWBd2KGGeJC/BPLGhghwHli
	+pz6IxBsmSWEzMwFm5+iKYRWbuqY7L3O8gCi+FR6DbVFO3aohfrY4fe7LQ69ZP1V8rDWHOiaLHG
	wxjbDrJB6b87nWfjrzrtlsRNsdwCyIlT8gHi9g+ACUVp8/7Oh+Dat3eCoP1BrD8+oM6h3F1+7us
	SubPqJ7yepJpZaZiu3aloCtYh5CTjzQJmSuVnIpOwj51Yf6fltfwwUEDj+hNHqeXljq8bD/X5PK
	Pnle5jkkPhJcx7xin9u8UHkg==
X-Google-Smtp-Source: AGHT+IEXaSar5Vg+LOV4tJVM3fSmFUEov8B5F8P/UBBCyNn8SgY7LaRxMuVf+6MM4Sqi4/YSucIRwA==
X-Received: by 2002:a17:907:3f99:b0:ae3:c767:da11 with SMTP id a640c23a62f3a-af990463606mr179892866b.50.1754473740927;
        Wed, 06 Aug 2025 02:49:00 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f12d500023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f12:d500:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f00247sm10139093a12.9.2025.08.06.02.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 02:49:00 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 1/3] net/ceph/messenger: ceph_con_get_out_msg() returns the message pointer
Date: Wed,  6 Aug 2025 11:48:53 +0200
Message-ID: <20250806094855.268799-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250806094855.268799-1-max.kellermann@ionos.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The caller in messenger_v1.c loads it anyway, so let's keep the
pointer in the register instead of reloading it from memory.  This
eliminates a tiny bit of unnecessary overhead.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/ceph/messenger.h | 2 +-
 net/ceph/messenger.c           | 4 ++--
 net/ceph/messenger_v1.c        | 3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 1717cc57cdac..57fa70c6edfb 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -548,7 +548,7 @@ void ceph_addr_set_port(struct ceph_entity_addr *addr, int p);
 void ceph_con_process_message(struct ceph_connection *con);
 int ceph_con_in_msg_alloc(struct ceph_connection *con,
 			  struct ceph_msg_header *hdr, int *skip);
-void ceph_con_get_out_msg(struct ceph_connection *con);
+struct ceph_msg *ceph_con_get_out_msg(struct ceph_connection *con);
 
 /* messenger_v1.c */
 int ceph_con_v1_try_read(struct ceph_connection *con);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d1b5705dc0c6..7ab2176b977e 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2109,7 +2109,7 @@ int ceph_con_in_msg_alloc(struct ceph_connection *con,
 	return ret;
 }
 
-void ceph_con_get_out_msg(struct ceph_connection *con)
+struct ceph_msg *ceph_con_get_out_msg(struct ceph_connection *con)
 {
 	struct ceph_msg *msg;
 
@@ -2140,7 +2140,7 @@ void ceph_con_get_out_msg(struct ceph_connection *con)
 	 * message or in case of a fault.
 	 */
 	WARN_ON(con->out_msg);
-	con->out_msg = ceph_msg_get(msg);
+	return con->out_msg = ceph_msg_get(msg);
 }
 
 /*
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 0cb61c76b9b8..eebe4e19d75a 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -210,8 +210,7 @@ static void prepare_write_message(struct ceph_connection *con)
 			&con->v1.out_temp_ack);
 	}
 
-	ceph_con_get_out_msg(con);
-	m = con->out_msg;
+	m = ceph_con_get_out_msg(con);
 
 	dout("prepare_write_message %p seq %lld type %d len %d+%d+%zd\n",
 	     m, con->out_seq, le16_to_cpu(m->hdr.type),
-- 
2.47.2


