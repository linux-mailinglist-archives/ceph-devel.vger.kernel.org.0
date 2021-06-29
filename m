Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4E73B6DB4
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 06:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhF2Epa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 00:45:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231817AbhF2Ep2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 00:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624941781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJ/D38VyZ1HLJDIceujC2Hsih4/uYHo9PLxOWSjHTAM=;
        b=K1nVx8ngfFjeqGtGfUSm8XvfH1+OXGdgMMbeOcMwkd1/U3MFj0K79VPLDkgAuzz6uhPjR9
        wXm2uk4D6KlQTJB9PZIIgGSm1vjlKd+b0YMpFpf8rFX22k1lPLMWaOGCEd4URGuVSj5UOe
        UEhrYJ23cX16fAfwpD2E1T2lL3I/s6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-cY74hxDJOxa5ptI0cIqdQg-1; Tue, 29 Jun 2021 00:42:59 -0400
X-MC-Unique: cY74hxDJOxa5ptI0cIqdQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B37BB100C611;
        Tue, 29 Jun 2021 04:42:58 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D433F5D9DC;
        Tue, 29 Jun 2021 04:42:56 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 5/5] ceph: fix ceph feature bits
Date:   Tue, 29 Jun 2021 12:42:41 +0800
Message-Id: <20210629044241.30359-6-xiubli@redhat.com>
In-Reply-To: <20210629044241.30359-1-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 79d5b8ed62bf..b18eded84ede 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -27,7 +27,9 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_RECLAIM_CLIENT,
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,
 	CEPHFS_FEATURE_MULTI_RECONNECT,
+	CEPHFS_FEATURE_NAUTILUS,
 	CEPHFS_FEATURE_DELEG_INO,
+	CEPHFS_FEATURE_OCTOPUS,
 	CEPHFS_FEATURE_METRIC_COLLECT,
 
 	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
@@ -43,7 +45,9 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_REPLY_ENCODING,		\
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
+	CEPHFS_FEATURE_NAUTILUS,		\
 	CEPHFS_FEATURE_DELEG_INO,		\
+	CEPHFS_FEATURE_OCTOPUS,			\
 	CEPHFS_FEATURE_METRIC_COLLECT,		\
 						\
 	CEPHFS_FEATURE_MAX,			\
-- 
2.27.0

