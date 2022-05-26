Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97A9534A4C
	for <lists+ceph-devel@lfdr.de>; Thu, 26 May 2022 08:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239023AbiEZGHi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 02:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbiEZGHf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 02:07:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50ACEBA9BC
        for <ceph-devel@vger.kernel.org>; Wed, 25 May 2022 23:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653545253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ivCgzLhpKwEMrJzhwT2nIXJy667bcBApWWlpFwiwOhw=;
        b=Vwk9OKvZm2NQaqA2eAF5dBFIqBzY3oH/t07jNZEM+QxdwCqUmTk5AF2egIKh3Rm777oFPo
        nVC7XnIpo3JvcJ6bWDE2WVjkq91t6hOlD5GFW1dKjeBu5klkY2LKI1oe1aD+UTEEOCVqNe
        rwlx6s3knRI/eabtSGdDpyKy2AYsUjo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-WZq0HsF-M1GRii64O_NINQ-1; Thu, 26 May 2022 02:07:29 -0400
X-MC-Unique: WZq0HsF-M1GRii64O_NINQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37AE53C02191;
        Thu, 26 May 2022 06:07:29 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B0652026D64;
        Thu, 26 May 2022 06:07:28 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: remove useless CEPHFS_FEATURES_CLIENT_REQUIRED
Date:   Thu, 26 May 2022 14:07:21 +0800
Message-Id: <20220526060721.735547-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This macro was added but never be used. And check the ceph code
there has another CEPHFS_FEATURES_MDS_REQUIRED but always be empty.

We should clean up all this related code, which make no sense but
introducing confusion.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 636fcf4503e0..d8ec2ac93da3 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -42,7 +42,6 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_DELEG_INO,		\
 	CEPHFS_FEATURE_METRIC_COLLECT,		\
 }
-#define CEPHFS_FEATURES_CLIENT_REQUIRED {}
 
 /*
  * Some lock dependencies:
-- 
2.36.0.rc1

