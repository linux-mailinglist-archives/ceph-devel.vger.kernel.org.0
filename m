Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F39838F40
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfFGPi3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbfFGPi2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:28 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 816B321530;
        Fri,  7 Jun 2019 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921908;
        bh=ExoCL8j1cJBg9m+SRiqG77O6/27vctei/f3S/6UsoOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0TwQgV51RdPIRuwpVNzisx1Qag35rgALex0TNbPKHNTPx7q+QiNaciTocm2aVk08
         jaaKAJpzMf6rPHU8WSd5Xy0XvqNK1XETmEWp6/m//e99v6HWrSwYG4Cbj1eWM9n3Oo
         NhWQRm7nFCqczHv1uJphgOmVyDJjM+GiFZdvA/5U=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 11/16] libceph: turn on CEPH_FEATURE_MSG_ADDR2
Date:   Fri,  7 Jun 2019 11:38:11 -0400
Message-Id: <20190607153816.12918-12-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153816.12918-1-jlayton@kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
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

