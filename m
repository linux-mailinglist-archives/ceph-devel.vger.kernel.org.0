Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662457ACF7E
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Sep 2023 07:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjIYFbd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Sep 2023 01:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjIYFbc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Sep 2023 01:31:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BBABF
        for <ceph-devel@vger.kernel.org>; Sun, 24 Sep 2023 22:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695619843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VoadG9S1HODNdFK79NGQv6pMtcfNJ4P1urMfuiMxkCg=;
        b=CnqdxF0/2RQN0uBp08ptoU39gOP+8h2O/G0p+z8CGOVZ7m60+dqD8dNXlL5DclPjB6k9rv
        59i9mZPNCiwn/SQ7wg/gjGxCYIu0fLfu64R+4KkQvDuOqApUEqpXkSiRdEOnageOvn7khq
        pqhkw/6qO4pltbTyDVPENvskppzCovI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-L4SfE_R3NMe4NrLiKF-bsg-1; Mon, 25 Sep 2023 01:30:40 -0400
X-MC-Unique: L4SfE_R3NMe4NrLiKF-bsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EC97801779;
        Mon, 25 Sep 2023 05:30:39 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E83E251E3;
        Mon, 25 Sep 2023 05:30:36 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, jlayton@kernel.org, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/3] ceph: fix caps revocation stuck
Date:   Mon, 25 Sep 2023 13:28:07 +0800
Message-ID: <20230925052810.21914-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Try to issue a check caps immediately when unlinking, else the MDS may
wait for a long time when revoking caps, such as the 'Fx' and 'Fb'.


Xiubo Li (3):
  ceph: do not break the loop if CEPH_I_FLUSH is set
  ceph: always queue a writeback when revoking the Fb caps
  ceph: add ceph_cap_unlink_work to fire check caps immediately

 fs/ceph/caps.c       | 84 +++++++++++++++++++++++++++-----------------
 fs/ceph/mds_client.c | 34 ++++++++++++++++++
 fs/ceph/mds_client.h |  4 +++
 3 files changed, 89 insertions(+), 33 deletions(-)

-- 
2.39.1

