Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1A3727501
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 04:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjFHCdT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 22:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjFHCdS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 22:33:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112071FFA
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 19:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686191548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Cb7UESdu0LjT6L3cx9Q23Pu49IGspFnYuwSzNIp6eNE=;
        b=B0jXX6GzH+2oaM0TPQBMZS/pTJ7ZzdNcmlsvxDBeY/5cdUwZ4NfJeevarYq6OY8xzTm3vJ
        uyo0i+rgHas18CueC+4Yud1Iq6i85sB2I2EEdYFDUe/IK8+MuiyuSdYXqHE2kky7NMsySJ
        W7nFBFIwnjVg0Oazfb+nPzEuH0p8NGM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-1NyDdWhNM5-OjYSf1JthNg-1; Wed, 07 Jun 2023 22:32:26 -0400
X-MC-Unique: 1NyDdWhNM5-OjYSf1JthNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E783811E78;
        Thu,  8 Jun 2023 02:32:26 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-13-135.pek2.redhat.com [10.72.13.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C4CA40D1B66;
        Thu,  8 Jun 2023 02:32:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] ceph: fix fscrypt_destroy_keyring use-after-free bug
Date:   Thu,  8 Jun 2023 10:29:57 +0800
Message-Id: <20230608022959.45134-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V3:
- reuse the mount_timeout when umounting.

Xiubo Li (2):
  ceph: drop the messages from MDS when unmounting
  ceph: just wait the osd requests' callbacks to finish when unmounting

 fs/ceph/addr.c       | 10 +++++
 fs/ceph/caps.c       |  6 ++-
 fs/ceph/mds_client.c | 14 +++++--
 fs/ceph/mds_client.h | 11 +++++-
 fs/ceph/quota.c      | 14 +++----
 fs/ceph/snap.c       | 10 +++--
 fs/ceph/super.c      | 87 +++++++++++++++++++++++++++++++++++++++++++-
 fs/ceph/super.h      |  5 +++
 8 files changed, 140 insertions(+), 17 deletions(-)

-- 
2.40.1

