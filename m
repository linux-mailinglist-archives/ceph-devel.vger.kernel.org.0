Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45A960DBCF
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Oct 2022 09:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiJZHEj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Oct 2022 03:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiJZHEi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Oct 2022 03:04:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CA2DF93
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 00:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666767874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qy6jRwuJera0Dg1UeCpGaUhg/SbswZwpnzi0R1uHwAw=;
        b=FuddleVZb7+FzgLTdU9daCzU3zuOREQ/iWE2IWopLmfr9f0JEUgtwEIlCIrUKE3vlU1WRY
        TCrIe0HOX1G+/V40TvXTO3f+8S0EoMJl4MKCKeWuNf3l3LKz8cvuSF2wZ9ADC1w2f1l1G9
        dvjHyP+9kaXTQFRnpTfP3xV812T9i50=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-Iw_7BFTVOw2yb3f8BgOO-Q-1; Wed, 26 Oct 2022 03:04:31 -0400
X-MC-Unique: Iw_7BFTVOw2yb3f8BgOO-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14D20858F13;
        Wed, 26 Oct 2022 07:04:31 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D87D11415117;
        Wed, 26 Oct 2022 07:04:27 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     david@fromorbit.com, djwong@kernel.org, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] encrypt: add ceph support
Date:   Wed, 26 Oct 2022 15:04:16 +0800
Message-Id: <20221026070418.259351-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Xiubo Li (2):
  encrypt: rename _scratch_mkfs_encrypted to _scratch_check_encrypted
  encrypt: add ceph support

 common/encrypt | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

-- 
2.31.1

