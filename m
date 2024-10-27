Return-Path: <ceph-devel+bounces-1985-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFB19B2058
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 21:27:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0176B28128F
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 20:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F46917DFF1;
	Sun, 27 Oct 2024 20:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUzf7gsX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F0115885E;
	Sun, 27 Oct 2024 20:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730060844; cv=none; b=XvRW8vsI/aHxcV6JfDlq37V6YP9k/rR5RyUF/99M6E1jMidH+SGKVoZP6+jdjiNHHscM6acdt6AECTMdaBYs5yGttEB/D5CDvT6TlGxpqmGsqxlg+5zhI3/G8rzD5Md20v4jbXH29oB3a9wU+TKERaLqLDDW7IaKDqwbSepp6B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730060844; c=relaxed/simple;
	bh=JpXCiKC2ct+IT2kSHw/v+QOTATgFdJ18Z/JSLY8FTvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q2U9QYpYQHE21yu8Rd0ZYScjca0C997YLj+GU/4KXkonTAO6PbRunk95RrcQj5BxZec3SklPyTwhBbsC142FpsEQzqubjsNyCXqDhOh7FhV+Ztn87+4FWLWqw6BfATWUijZhv5RCTDmab7SOGxloB5iaAA7KToD8nEv1dcDkpMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUzf7gsX; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43163667f0eso35864845e9.0;
        Sun, 27 Oct 2024 13:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730060840; x=1730665640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pRQHOJ1yYQQJLj2MH1qHa8MZFRBtwB0M1hjRbBCmZ8w=;
        b=bUzf7gsX3VfiiAR079SEGNRXO5BAOWhtVC7Nvc2qPmZsB9y0jZAnSe3DwC9Sx0But8
         l0zol6MEWMmcRDaLoW7NpovyovPkybI3l8UBT6vGoBkyfBCrh8IBOpdWkCai2ag2ajLh
         rtXM6iEqH8lsPy9Ml2cMAiLteOIoF+bCtddrPsShJ6LbQAr+o9cYb23+A3xRiBUjCi/5
         hfEt6bxqYBwRhVlrjKr7LLWQ9+NUkY/5WnY9C5oWjErOoOcr4IOeRWytpOXi15eVVQF7
         pyrrNz/c10hhk3DoNkbEiolTO3XZjdoL1c2+qydf5ndDmG2i3MhgXkJAO9h/UJR22/dp
         V2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730060840; x=1730665640;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pRQHOJ1yYQQJLj2MH1qHa8MZFRBtwB0M1hjRbBCmZ8w=;
        b=bj25oJNNik7i75ad9BkYpFvX42n+mb4PA0xtU8e2T6w9cKPuCsh+ztxFe6LzhAH4qJ
         GzzndzL4iNpIozV6xygmcPXea5sFNtZRJ7b/V1xJ8Ktll5azD5KSA64/wQmGqPnR3qkT
         FEpG0Da2OPocX8fu346aFE3CcXO6/P71VyOXAX757uIZ8/714QImHLdoEmAq91LohCEC
         9hXN1XdG/Ti4ybAZihVxzv/Qnb9oENL1+cSG97ZKlCUSWZBDToQUCjsPOObcXHxkuVC8
         M5bxiFOWuWgFLepovxokd6sAjfCFRDYZvX6jaY3V1nR26n8Nj5OjxtquLBYL0S55fGgJ
         Vz5g==
X-Forwarded-Encrypted: i=1; AJvYcCWhq2Vkfij7VVw/HbvIrUGuTcLFCactakHTIK/lWSXN7G7FbwJ/nB3t+NfSzU91SdV/oSCLmgA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvAHH8fuylV9htJ6nsy7Y6NLLnTldiDPgvZ+SUMWy6zUMBpaBw
	SBNn6vhTz+AGiuGvUUHyf3CuB2PcI5h32VvevB5UAuAcmSvDVaX1pyHvKw==
X-Google-Smtp-Source: AGHT+IGfZlFtFiOmu6yt4/YDXSdaWRDmabBDLowk75VcOEYzt8Gz3JYTjL8M6596GWqRfATTt9b9rg==
X-Received: by 2002:a05:600c:1c82:b0:431:5503:43ca with SMTP id 5b1f17b1804b1-4319ad16173mr47913515e9.28.1730060840214;
        Sun, 27 Oct 2024 13:27:20 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b5430edsm116260535e9.2.2024.10.27.13.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 13:27:19 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] MAINTAINERS: exclude net/ceph from networking
Date: Sun, 27 Oct 2024 21:25:55 +0100
Message-ID: <20241027202556.1621268-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

net/ceph (libceph) patches have always gone through the Ceph tree.
Avoid CCing netdev in addition to ceph-devel list.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e9659a5a7fb3..94077e2de510 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16096,6 +16096,7 @@ X:	include/net/mac80211.h
 X:	include/net/wext.h
 X:	net/9p/
 X:	net/bluetooth/
+X:	net/ceph/
 X:	net/mac80211/
 X:	net/rfkill/
 X:	net/wireless/
-- 
2.46.1


