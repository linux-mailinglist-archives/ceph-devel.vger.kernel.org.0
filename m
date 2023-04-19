Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE26E72F0
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Apr 2023 08:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjDSGPI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Apr 2023 02:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjDSGPH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Apr 2023 02:15:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32CF4ECD
        for <ceph-devel@vger.kernel.org>; Tue, 18 Apr 2023 23:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681884858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Aj3as9hjb9R6z/gj+AydeEKwsI19L4vFIKMN/Erk8M8=;
        b=CtwJgC/2OOP4FfM9kFK2U3f6dXvIPia8+ofR+SVsmzPPbJxLsTC9afpgwQ/r1Y0jX9YSgT
        X90UeBkrX43mi315nuCWkdODe2cOBpI7e1WEYhICjJTi9iszj5614QFHBSGGtAdbe+AhEA
        rsogccvn/OrS/R2SsnQ304QU7Q58HkA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-xHg76yNsM-m7l1weqHGn_w-1; Wed, 19 Apr 2023 02:14:15 -0400
X-MC-Unique: xHg76yNsM-m7l1weqHGn_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E4BC38012F0;
        Wed, 19 Apr 2023 06:14:15 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-234.pek2.redhat.com [10.72.12.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D63FC16024;
        Wed, 19 Apr 2023 06:14:11 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/2] ceph: fix potential use-after-free bug when trimming caps
Date:   Wed, 19 Apr 2023 14:14:00 +0800
Message-Id: <20230419061402.183915-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V4:
- swtich ci_node to mds


Xiubo Li (2):
  ceph: export __get_cap_for_mds() helper
  ceph: fix potential use-after-free bug when trimming caps

 fs/ceph/caps.c       |  2 +-
 fs/ceph/debugfs.c    | 18 +++++++----
 fs/ceph/mds_client.c | 72 ++++++++++++++++++++++++++++----------------
 fs/ceph/mds_client.h |  3 +-
 fs/ceph/super.h      |  2 ++
 5 files changed, 62 insertions(+), 35 deletions(-)

-- 
2.39.2

