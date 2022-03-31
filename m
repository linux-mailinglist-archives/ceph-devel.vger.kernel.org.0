Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EED4ED431
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Mar 2022 08:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiCaGyn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 02:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiCaGym (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 02:54:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B80D657B4
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 23:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648709574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s6suXq53nS8f5r5Snvx6seeslu4gx1kI9b0k2vhwZmo=;
        b=QwjOMZTvhMmoka6orjm2EQNCzu1D243sgDNsLZePc9fKSbdv6vHcljHgeEDMwuKbRXciFq
        6dcQOPF0qQQN2tYB/JhqrfTwMRKz2Rjyn6Scrf9oNjXZqXiS5OZek38l4q4MyrxyS+eKgr
        GZND5MnL8P6uyEuFW/75Tuy17zafDGk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-x9uyzWGyPpug8rz-Nar8NA-1; Thu, 31 Mar 2022 02:52:51 -0400
X-MC-Unique: x9uyzWGyPpug8rz-Nar8NA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7DB81C0690B;
        Thu, 31 Mar 2022 06:52:50 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7548A7AC3;
        Thu, 31 Mar 2022 06:52:48 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/3] ceph: only send the metrices supported by the MDS for old cephs
Date:   Thu, 31 Mar 2022 14:52:38 +0800
Message-Id: <20220331065241.27370-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will fix the issue in [1], and only send metrics to MDS that
supported, and for Quincy or higher ceph versions since it's safe
will force to send all the metrics. This could make sure the early
Quincy ceph versions still could get the metric which haven't backported
[2], which will fill the metric bits supported by MDS when opening
the sessions, no need to enable the force_ignore_metric_bits module
parameter.

[1]: https://tracker.ceph.com/issues/54411
[2]: https://github.com/ceph/ceph/pull/45370

Xiubo Li (3):
  ceph: add the Octopus,Pacific,Quency feature bits
  ceph: only send the metrices supported by the MDS for old cephs
  ceph: add force_ignore_metric_bits module parameter support

 fs/ceph/mds_client.c |  19 +++-
 fs/ceph/mds_client.h |  10 ++-
 fs/ceph/metric.c     | 207 ++++++++++++++++++++++++-------------------
 fs/ceph/metric.h     |   1 +
 fs/ceph/super.c      |   6 +-
 5 files changed, 144 insertions(+), 99 deletions(-)

-- 
2.27.0

