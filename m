Return-Path: <ceph-devel+bounces-4241-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 198E5CEC0B5
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 14:59:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F346A3011F94
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 13:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504E43233E8;
	Wed, 31 Dec 2025 13:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDha6G6G"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3191C84D0
	for <ceph-devel@vger.kernel.org>; Wed, 31 Dec 2025 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767189543; cv=none; b=Mgg546WQJC5L1n+QEJxbTvhU7HIREThXZiM4KbDqBKI2t2ygnt2nrdYskovRixk0BuUjD21rVSodfZ77+PPLbVyNNbpxkri8ZH/sZANOrXSea4IDnL860AtyaILJaJyHZBWArU5PlcoPpFS6Z/UFCwZg4hX4U6J92Diw/jUVELM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767189543; c=relaxed/simple;
	bh=3Xxr40yQ7vzy68itfDE/O9mStKK88v/T1Dob5gt+4Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WXZ3OlpaOJr9gvw8jcasieJ1bXqgA8fB4mgFBJyeWSUGdEp3OkU/HaySLzGPG4+5Z3zk4X6KiF/FlvG0HPCWu27nyPnvo4OAqlPeUUNPsrFN+Cv9rMStdDftMH0lmpJfEjoMABlp93N3hUcndM6nJzQ1pW4MdHwlobLhggLlKYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDha6G6G; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so52392475e9.3
        for <ceph-devel@vger.kernel.org>; Wed, 31 Dec 2025 05:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767189540; x=1767794340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=77HTaYFApjkvXrJkdYNYnkXZ+NdLyCZW0tESn1C/I30=;
        b=lDha6G6GKo8pHy4sBHtushCxyYbbfdVdd4kuSdqvStIRFvegVCRwsZLG3ukC6jOTq4
         WsJQHoN2kxskIzDqE5DMgMM/erSXhS4DBYsMJvL3H0Afc67wfHV3gmxeMUinc2W0C/E6
         4heC5NDyMF0r8FtU9h9OSkAJFOib4EOXG79xAQ7JwA9if91IrbTAaE+beuLAywndAfjC
         7juC4YHwxusw4bxfKRJaS8f6UirPpYwB4GbBTReaEaDsbs9GJaY3pJiFscACd8t/ErN9
         FSTA4NMlnKi5yJj1G3mXjwuGTE5me5HGNwVeA2VxGEkOraQ+r79c9AUBiLbq7oyKl6Tc
         9aPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767189540; x=1767794340;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=77HTaYFApjkvXrJkdYNYnkXZ+NdLyCZW0tESn1C/I30=;
        b=tyAveTB43VOL11i2KUh7p30BJ1OQHFfm17NOyetvBYC4mOySCHXD27ujuxgnsU89KM
         jffiL7DYeFFaAp3F2AhhrjXTNGSMFYIDoo6Agwyea4OoT5PKxTosounc8UUYhjI2HqEb
         9tUA0WUFHnkOZY7alO3f+qlzoyxTYXn8YPN6h50dHJCxDtSyWAtD89yoS/llc7pYAGfU
         318Y1NgbvrImrjc9mf/6tC+zMUNk0SlUMId26mmfdhNijsHQsnVa/EgPhf+t4ItZXwbz
         btu6RKxu6q7RhBCEMmVbKIHDYkJVQHbe/D44qLH4xLd577HeFGOtxOezDHUw7wohvHhA
         JnKg==
X-Gm-Message-State: AOJu0Yz5OU7r7AiOGfgQLpPI1Pqh5qFzVZTmsppigtoXZDsE6oa/BtjV
	pt7ZOc26rS1iDbRu9YO/Pfdr8KuoQiPZrYfXJOXw1AtWVEPiO0DdMI1hULHdRQ==
X-Gm-Gg: AY/fxX5E/bJOjrnupCTq9CahduLhs4i9j3sAT2iHZFHRWesOI1c8TFC7vgmwkcYGaLU
	ON5n9cLAp9CijkrAJ5cNktlo4bGFFiEoWk27CTtdoR8ophzTwBvZQkJyJtaqCGw8e6IFtrtmnZj
	0V08YBf7Uhuy1VIjRC0m7FQykIWZj0gl/aZnQ0Y2fVEToRUuRqDEfRY+qiF6x74DfE+BTUm+Lmu
	ItNVb8esHEugxvrSVsZJuB0TFgvCUhalXYvuwfPhK+7i7sIj2q9dUs54xKXSl/FKkSX0ZwEytyo
	WK1iZIUv9DuJlPaNn98RQbwKWlpSornyODleeGA671LE4S/CYiHA6vyG2h7EtLxNF5bYmMOGVRQ
	Rei1CX9OPnpBNtPH3CpH+3NndkknDAxEQ2fA8Rpy/q7JW2rvfIzfI95PltvJzCnEVT/RRbxBBWy
	FJNGvNR10g7cAenULBdZktvEO7Uq2u3/CQswf5m2F0kVMa8zXxAagy9Q==
X-Google-Smtp-Source: AGHT+IEDBrcGE1qASd3cAqKmMD/gZ4nJzqXbrCNk1esGgJU7Xi99FgmDsXVgcjdordInfp+LiES8RA==
X-Received: by 2002:a05:600c:3b2a:b0:477:7ab8:aba with SMTP id 5b1f17b1804b1-47d1953bd8bmr453186695e9.1.1767189539534;
        Wed, 31 Dec 2025 05:58:59 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa2beasm73114919f8f.33.2025.12.31.05.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 05:58:58 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH] libceph: return the handler error from mon_handle_auth_done()
Date: Wed, 31 Dec 2025 14:58:43 +0100
Message-ID: <20251231135845.4044168-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently any error from ceph_auth_handle_reply_done() is propagated
via finish_auth() but isn't returned from mon_handle_auth_done().  This
results in higher layers learning that (despite the monitor considering
us to be successfully authenticated) something went wrong in the
authentication phase and reacting accordingly, but msgr2 still trying
to proceed with establishing the session in the background.  In the
case of secure mode this can trigger a WARN in setup_crypto() and later
lead to a NULL pointer dereference inside of prepare_auth_signature().

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/mon_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index c227ececa925..fa8dd2a20f7d 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1417,7 +1417,7 @@ static int mon_handle_auth_done(struct ceph_connection *con,
 	if (!ret)
 		finish_hunting(monc);
 	mutex_unlock(&monc->mutex);
-	return 0;
+	return ret;
 }
 
 static int mon_handle_auth_bad_method(struct ceph_connection *con,
-- 
2.49.0


