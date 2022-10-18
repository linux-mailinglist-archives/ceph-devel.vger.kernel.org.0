Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416CE602341
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Oct 2022 06:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiJREbK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Oct 2022 00:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJREbI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Oct 2022 00:31:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20939E2FE
        for <ceph-devel@vger.kernel.org>; Mon, 17 Oct 2022 21:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666067467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hd4yHjeVX1BYkuGOpYmrJMyM4thcND8gUXSPb96JpXY=;
        b=K2F8+8AlUEWy9SwnPpnUEBzOjm4u7wL3ZZTma7DX8Le8cK2WrjbQn45CzIEk03JCaiWTyH
        mol4ZIU+vhFgyrFgFKfZAOweO3qKmyGLCx+MvRHtUyX0xCQUoUYHUdwuDMkz6yuujU7BDI
        KUZtHiggTWLddWYz5KaXqHkPrVWrclw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148--iBceGyDNoSiV6cjAMlTMQ-1; Tue, 18 Oct 2022 00:31:03 -0400
X-MC-Unique: -iBceGyDNoSiV6cjAMlTMQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A624D3C11EA2;
        Tue, 18 Oct 2022 04:31:02 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F1A3492B0A;
        Tue, 18 Oct 2022 04:31:00 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] ceph: check caps immediately after async creating finishes
Date:   Tue, 18 Oct 2022 12:30:55 +0800
Message-Id: <20221018043057.24912-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
  ceph: remove useless session parameter for check_caps()
  ceph: try to check caps immediately after async creating finishes

 fs/ceph/addr.c  |  2 +-
 fs/ceph/caps.c  | 25 +++++++++++--------------
 fs/ceph/file.c  | 26 ++++++++++++++++----------
 fs/ceph/inode.c |  6 +++---
 fs/ceph/ioctl.c |  2 +-
 fs/ceph/super.h |  4 ++--
 6 files changed, 34 insertions(+), 31 deletions(-)

-- 
2.31.1

