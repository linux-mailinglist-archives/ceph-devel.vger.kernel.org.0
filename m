Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAF72498E7
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 10:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgHSI6D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 04:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgHSI53 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 04:57:29 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2392C061347
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 01:57:28 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id jp10so25411344ejb.0
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 01:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HX205tRG8ZHJcvDKDnqPUKsIjXFVc3RObdikFIjb31s=;
        b=Q9ZsmRZCPLgixq+Z4fzykk+1jmj5x9IlFbqCLMD3on/THKZLp0slvi5sSLa993qalv
         s66mVKzMDolOpsxEB/IyJvAXgru1r52NAqxdhR+LvEmgDIQ0yJXQZIVv3x6vmbUpoCm+
         Rfn+V6PCgPN+QBzLhJxKVuA973P5TVUauK6fFFoxerc3VVgWlaR1jdO5YSXjZ9V/BAAQ
         STp+wZ1G6HFNh8ujcjKvRgyI3UpJjFiu3zXHhsinGSh2tJvxT+02vBz1augRn1qf7ZjV
         jQcr6JChZHoCs5qTAeXWgrhdy4YHdgQGiywWTSPoWOWyWQdH98ig2ab+S17rcTJC6vM9
         yoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HX205tRG8ZHJcvDKDnqPUKsIjXFVc3RObdikFIjb31s=;
        b=Ht6mJo5UV6RR5FjD2EOqfMq1WhnkuPVpUMQysBWM2iS2SujmThL8hDm9qU1HvJhzbi
         anqR/QY2tfa4E10QLkrwCe0MK+soUEZwbi3USp/IK+QRv6qmkoOJWbVPXkNZNMJNjPKI
         9ZCm1zjY8s/WqzG+PFFmYYPMKxuo2XxkPqO1BRNLTJEdiYLlv+tls3OTSSp5ZUK+3U01
         AIoZ804iT0NldgRJDD5mVgp1e/yFdsjTgR5nDyiQy+jUgHwvtctQm6kTKobQRc3DGSa7
         xCkR5SYo4zgORCxUZGLfSsr9xD32y3cbv77h0h1EuB7MCSNkXJuymnoUsBuznIzBI+/B
         DcRQ==
X-Gm-Message-State: AOAM533gJQdsQ9B3jumgFIzaWS+fjowxkzCvzRvpa6XspDZJiGwuf7GL
        cHwuvO8vxKYSqaichXCT2iio1UP68Wc=
X-Google-Smtp-Source: ABdhPJxQ+ebtdUO6KbW147ao0cvMPnes+8HalLD/WsgaMM11u0Qt2Hl8KY5aZPUfichKtbNX9niX0Q==
X-Received: by 2002:a17:907:42cd:: with SMTP id nz21mr24433151ejb.395.1597827447079;
        Wed, 19 Aug 2020 01:57:27 -0700 (PDT)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id y13sm17233114eds.64.2020.08.19.01.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 01:57:26 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH] libceph: add __maybe_unused to DEFINE_CEPH_FEATURE
Date:   Wed, 19 Aug 2020 10:57:36 +0200
Message-Id: <20200819085736.21718-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Avoid -Wunused-const-variable warnings for "make W=1".

Reported-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/ceph_features.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/ceph/ceph_features.h b/include/linux/ceph/ceph_features.h
index fcd84e8d88f4..999636d53cf2 100644
--- a/include/linux/ceph/ceph_features.h
+++ b/include/linux/ceph/ceph_features.h
@@ -11,14 +11,14 @@
 #define CEPH_FEATURE_INCARNATION_2 (1ull<<57) // CEPH_FEATURE_SERVER_JEWEL
 
 #define DEFINE_CEPH_FEATURE(bit, incarnation, name)			\
-	static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);		\
-	static const uint64_t CEPH_FEATUREMASK_##name =			\
+	static const uint64_t __maybe_unused CEPH_FEATURE_##name = (1ULL<<bit);		\
+	static const uint64_t __maybe_unused CEPH_FEATUREMASK_##name =			\
 		(1ULL<<bit | CEPH_FEATURE_INCARNATION_##incarnation);
 
 /* this bit is ignored but still advertised by release *when* */
 #define DEFINE_CEPH_FEATURE_DEPRECATED(bit, incarnation, name, when) \
-	static const uint64_t DEPRECATED_CEPH_FEATURE_##name = (1ULL<<bit); \
-	static const uint64_t DEPRECATED_CEPH_FEATUREMASK_##name =		\
+	static const uint64_t __maybe_unused DEPRECATED_CEPH_FEATURE_##name = (1ULL<<bit);	\
+	static const uint64_t __maybe_unused DEPRECATED_CEPH_FEATUREMASK_##name =		\
 		(1ULL<<bit | CEPH_FEATURE_INCARNATION_##incarnation);
 
 /*
-- 
2.19.2

