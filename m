Return-Path: <ceph-devel+bounces-29-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B50A7DFF37
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 07:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5974D281D93
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 06:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA86187C;
	Fri,  3 Nov 2023 06:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fRH7E88F"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6E17E
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 06:40:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01223CA
	for <ceph-devel@vger.kernel.org>; Thu,  2 Nov 2023 23:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698993649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bOkyCnGedvhKQ4FOLUi1bMbyAu4JzNBZhTd0vR6PMq4=;
	b=fRH7E88FTb4YuQ3RUIjTmayA1FmkoSoTyEXy/67Nyqevt0OfzI5LDNNIFCUe9QMrKdtoZv
	NWEcVg4N98GO7WwrBTKeh5rNC5kgcAt/ax20Qdd4fTdQPmeCcyQ/NdpDILA1Tu0D7byqz1
	2jlX2KygnhNgOKcqAM7Y+h5f2xSL/sw=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-6b0G-eS_NwCWJwILtLm3Lw-1; Fri, 03 Nov 2023 02:40:47 -0400
X-MC-Unique: 6b0G-eS_NwCWJwILtLm3Lw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-573fdb618eeso1382624a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 02 Nov 2023 23:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698993645; x=1699598445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bOkyCnGedvhKQ4FOLUi1bMbyAu4JzNBZhTd0vR6PMq4=;
        b=WJwbr80GYv0D3rcjdrOjTj6ibsHpoD+9264MRvgggmJdVtbm2VWG58F+jU9dKpr1zB
         j9W/ZkK0VbK7qCbFGg6x15kP6X6M8qf2HFJam68bB7v8/GUtVuozrFqZBx1twFohtuuq
         MpmnaW548Vfi7OXcKveVwwxAB4A6abcd31X5IgiE9xfWyYDVM5528xXSuCIUBxaVERTo
         zFcdlUBNZYxsko4dchUNBgBU3ICbGEkCgpLxXLGfmxGnaONSDaoFr87nUfhD5kdAq90g
         g6MgHnRnz0Ni7nW53R1z/XQ9djpXATeIq+jAC8JhNZIVAejo39TbREpEtI26EbB2R+rs
         vKBg==
X-Gm-Message-State: AOJu0Ywqe2tcCrDdnSMPOmZIMEMd5QqysDCNknzB5Ofr0DllM7st2T92
	ihQJ42DaAKM7pWyr93lXe1NALq9JLMc94f7eBP9RI5gCSMd/3Ln1xKSFGqJSzzjR/tNvYvJFrfo
	rnmuYDD6RjHvcI8vKxUb3tgLs9sCihJAYbRe/nZ5ZEe2UmT25DOD34S+XZOIyNK0fX6tDNm5ZxG
	jMmw6I7w==
X-Received: by 2002:a17:903:605:b0:1cc:7f53:c190 with SMTP id kg5-20020a170903060500b001cc7f53c190mr4957063plb.51.1698993645642;
        Thu, 02 Nov 2023 23:40:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPBtCzkaSJ/xpgAZrPiIMouFGhGX66HZucUCQdUOJKof2keNx7JhXuRGyyaCTKuK5qtL7Dgw==
X-Received: by 2002:a17:903:605:b0:1cc:7f53:c190 with SMTP id kg5-20020a170903060500b001cc7f53c190mr4957053plb.51.1698993645333;
        Thu, 02 Nov 2023 23:40:45 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([106.51.169.35])
        by smtp.gmail.com with ESMTPSA id y7-20020a170902b48700b001bf52834696sm685420plr.207.2023.11.02.23.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 23:40:44 -0700 (PDT)
From: Venky Shankar <vshankar@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: xiubli@redhat.com,
	mchangir@redhat.com,
	Venky Shankar <vshankar@redhat.com>
Subject: [PATCH] ceph: reinitialize mds feature bit even when session in open
Date: Fri,  3 Nov 2023 12:10:27 +0530
Message-ID: <20231103064027.316296-1-vshankar@redhat.com>
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
 fs/ceph/mds_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a7bffb030036..48d75e17115c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4192,6 +4192,7 @@ static void handle_session(struct ceph_mds_session *session,
 		if (session->s_state == CEPH_MDS_SESSION_OPEN) {
 			pr_notice_client(cl, "mds%d is already opened\n",
 					 session->s_mds);
+			session->s_features = features;
 		} else {
 			session->s_state = CEPH_MDS_SESSION_OPEN;
 			session->s_features = features;
-- 
2.39.3


