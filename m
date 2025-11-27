Return-Path: <ceph-devel+bounces-4120-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 335CCC8E8F3
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 14:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AB0CA4E3F23
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 13:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32CF818A6CF;
	Thu, 27 Nov 2025 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PmaZM2OJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BAt7CWsb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE0D1DEFE8
	for <ceph-devel@vger.kernel.org>; Thu, 27 Nov 2025 13:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764251206; cv=none; b=tJ3oQ37PVwL+beofgYMf7zIYkmmcCBK5HPodL/BpLMHxoJxSzY+sw7z1/UQ0GkwkYKZpJYzBzKTts/BkXyTWpFRELamaTBnnJKjyAZzQnTM5w1rUdbXLP1iMsjzEaKOseQNoZ103/rCi9FbM6pxwpM9aki2+EkbWF3Kxiep4fDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764251206; c=relaxed/simple;
	bh=+Pt8YKjNHobik7IJ+2UzEXYahr20AHIVvarIQ797e6E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NOTgDcfQS23/QYSm+76ZJaWqKX0O7OZtQICJS6qhy4b9V5yvVYpQC/lLHuaqBmdhCznubD93qy/EWAF41TboQfnd5ZIDkto3n2lFd/K912rnWJIPjEw5ICVBWXj1FaUP0visH5CdCduJghhn1O5U8TM3DHsYk5g2L/yTz7w/0+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PmaZM2OJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BAt7CWsb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764251203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tYozc2QXCzpsGSOXkY8fPFQDc+gxi7zXP5QXCFhtgLc=;
	b=PmaZM2OJKjR8vLPDaWJAkQo8OYFU2Pk6ylpHqql20C+aU5pyvCDe9BCeqik3RdF/F0ussi
	+X5Q/+2+mxM3Q5+N5BXgpbak+G9ERjcrmXmMmyyhOeLowNZRAdjn2QSJxK2Lr1JVVZUch9
	E+lc/Bm2IC8uXaBaQUMye5dau1z2p/0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-VyHTzFfEMeeGuBObr5ABGQ-1; Thu, 27 Nov 2025 08:46:42 -0500
X-MC-Unique: VyHTzFfEMeeGuBObr5ABGQ-1
X-Mimecast-MFC-AGG-ID: VyHTzFfEMeeGuBObr5ABGQ_1764251202
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-88051c72070so15557216d6.1
        for <ceph-devel@vger.kernel.org>; Thu, 27 Nov 2025 05:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764251202; x=1764856002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYozc2QXCzpsGSOXkY8fPFQDc+gxi7zXP5QXCFhtgLc=;
        b=BAt7CWsb+aFt5aJYcr3b1WDpGOBNtJ57t8cc+DMMlovJ9UlWvFVph0SfZXinZqDZ6G
         5MK9NIme4arjEtTq0jzYfZZSG9F/RMhZTAgPwlDBbeOxuJD5iyNeCGqHUkBjPzpqa14l
         JqHQvx1yLB3W9X/F15wok6xtQvXFqCKstN1miMMrgRjfAg5xl5oA2Bmx7tA9FYzggUs5
         7DGUXOil9ZA5gq9bVZmxUhFesUDKj5gPOpDgWEJp6xdrSPfK7W/B2NqU2wKjSqxrpGyY
         vfapiAKHyZnAbVvtmA4acdU9UmFWSez+/coFJhZByQ4zBZHepQf6EOIcpwhpmMK4zv0c
         NPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764251202; x=1764856002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tYozc2QXCzpsGSOXkY8fPFQDc+gxi7zXP5QXCFhtgLc=;
        b=ryq4sLfv0xI5hc/G4Geu801A2Zo4fKGll3jOc3BlKneQ7IrexUs0o/Zku82Qh6ZEOg
         +xeXFy/muYA/xEs/+e4T3ew9TuYLQOBV+SKi7hiqkvRloM5pRScT1loiymWeH7Qcor/R
         kE7e5Guc5wqnzjl4k3hAerFdoXfC2c6NG50bQ8u2C2v4FEyX2se2xlfGkFXR5eJemYlg
         r+m9ybVIMyDpCEuOHqyGqJcXC548oerSnV1PaER3zTFtY+9AsHOE06i722fbSb4FkXgR
         kRjDdbqZtUweGyzXWEhDMhuUpG8796PqQqgeoe6gP/kqsXBEmkwzpgN8h9BVXJXd3CDs
         0dYw==
X-Gm-Message-State: AOJu0YwunYHsta9SFNaZj67jBDKH3HtbxLPzJ036nWMy5bm1pUeMTpVM
	KKLjmjLJ5SBDQ6G0zwgR33TRMRCXoaui3uKbIbpdW/B1CsXcXY8FngbYID1otYM5oX3v9ODeTne
	2EXvhZTK2WuHg0Go3755cG+66GFYb3j/b3QCP681F0OPjvWOxhnyQZplkGitD26us6EKpphL315
	d7ovD8ENHcb+f9RWH5ODi++3DDDuf97083BVYqbt82pMQeNCO3JA==
X-Gm-Gg: ASbGnctTDnhnIqkTjPOYQ0hsYfwjBLQe3dzP2CR+21v/2HUGkWWxw9ZjowAy6xcPjgO
	wSf/GVJ8lY9+StFF09927Lh5jlA++oT2Gl5hgDASvQZG7sHSNevIAdOEGFfrHi3UvwXv/kymT3Y
	29rI7VqGFjxtE9WUNeXygLd1pNMSyDpvd9jpuKVruMMqU75SUHnT60rtq4gCxJsxo2qh54uQ4qg
	/Ol1r4jawZFBtWpfn8HljOT0GtIrmV60lok2eyRDLX3JiWIcGKL+P70TnvEltxl+bp9gg2nVjoJ
	zMI5nxldEbACmm7Q9ufq1kaz2ZMsH2BFHu08erN26tN3YkVhAeTprS09iS7PKFfp+psK0RoW2zv
	L+1ZEG+BkmkPYXZPzumVSeUgE+adNRiXDiQR4wPASLvk=
X-Received: by 2002:a05:6214:ace:b0:7c6:2778:2f8 with SMTP id 6a1803df08f44-8847c521d40mr332714686d6.47.1764251201708;
        Thu, 27 Nov 2025 05:46:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFa2DmAJl9qldD/UA/PQmeybzFtzeTjryoUMyCvO4Q7g2eNNSASL1fsMbZ7y0bByB1xtohMiQ==
X-Received: by 2002:a05:6214:ace:b0:7c6:2778:2f8 with SMTP id 6a1803df08f44-8847c521d40mr332714306d6.47.1764251201292;
        Thu, 27 Nov 2025 05:46:41 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524fd33fsm9932946d6.24.2025.11.27.05.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 05:46:41 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH 1/3] ceph: handle InodeStat v8 versioned field in reply parsing
Date: Thu, 27 Nov 2025 13:46:18 +0000
Message-Id: <20251127134620.2035796-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251127134620.2035796-1-amarkuze@redhat.com>
References: <20251127134620.2035796-1-amarkuze@redhat.com>
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
 fs/ceph/mds_client.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1740047aef0f..32561fc701e5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -231,6 +231,18 @@ static int parse_reply_info_in(void **p, void *end,
 						      info->fscrypt_file_len, bad);
 			}
 		}
+
+		/* struct_v 8 added a versioned field - skip it */
+		if (struct_v >= 8) {
+			u8 v8_struct_v, v8_struct_compat;
+			u32 v8_struct_len;
+
+			ceph_decode_8_safe(p, end, v8_struct_v, bad);
+			ceph_decode_8_safe(p, end, v8_struct_compat, bad);
+			ceph_decode_32_safe(p, end, v8_struct_len, bad);
+			ceph_decode_skip_n(p, end, v8_struct_len, bad);
+		}
+
 		*p = end;
 	} else {
 		/* legacy (unversioned) struct */
-- 
2.34.1


