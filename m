Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A1448776
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfFQPiI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbfFQPiG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:38:06 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DB6721855;
        Mon, 17 Jun 2019 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785886;
        bh=ExoCL8j1cJBg9m+SRiqG77O6/27vctei/f3S/6UsoOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgckT6nT+8C/1PsmPUmJpdKyz4I2vp4+qDrD/5sAdooBCHYpm2v23HUkVmx0zcp04
         CbprdmTg2ZZKgeuj5Xy/dolIIzkuzS47erCUrF1xxpYsPWnVvk7w93uraEjxxb4viK
         5RMWlXZ6XOO3LQuGIKQKF/beM5lBMuPr95J+Ezjw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 13/18] libceph: turn on CEPH_FEATURE_MSG_ADDR2
Date:   Mon, 17 Jun 2019 11:37:48 -0400
Message-Id: <20190617153753.3611-14-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Now that the client can handle either address formatting, advertise to
the peer that we can support it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/ceph_features.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ceph/ceph_features.h b/include/linux/ceph/ceph_features.h
index 65a38c4a02a1..39e6f4c57580 100644
--- a/include/linux/ceph/ceph_features.h
+++ b/include/linux/ceph/ceph_features.h
@@ -211,6 +211,7 @@ DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facin
 	 CEPH_FEATURE_MON_STATEFUL_SUB |	\
 	 CEPH_FEATURE_CRUSH_TUNABLES5 |		\
 	 CEPH_FEATURE_NEW_OSDOPREPLY_ENCODING |	\
+	 CEPH_FEATURE_MSG_ADDR2 |		\
 	 CEPH_FEATURE_CEPHX_V2)
 
 #define CEPH_FEATURES_REQUIRED_DEFAULT	0
-- 
2.21.0

