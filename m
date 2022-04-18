Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE63505776
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 15:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiDRNyw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 09:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245239AbiDRNxI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 09:53:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 968AB457A4
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 06:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650286953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x/qGSEaI1J7CLOMHtSGVcsTUFkaM9KHdpBhNLV/h/Dg=;
        b=ImWdbcTAZLPVz2zXJBv/V4tn1NDzix5Mt9nSSceSQ3bnR3+OHqij6JeDtijRfpyFVXN91h
        wCCw9skBLoYME2iuVx7Un0AQ4lHB7dWzc5HM8ckU7v7TIGJnm/wk9+v+s+RLFDhR2HSao4
        k6V9jZfOZyuCWCdbR5WBOiRR3NlRTdI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-GOQRH-omN6qNMHSLh4VpPA-1; Mon, 18 Apr 2022 09:02:31 -0400
X-MC-Unique: GOQRH-omN6qNMHSLh4VpPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42DCF1014A62;
        Mon, 18 Apr 2022 13:02:31 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83A722024CDC;
        Mon, 18 Apr 2022 13:02:25 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] ceph: flush the mdlog for filesystem sync
Date:   Mon, 18 Apr 2022 21:02:16 +0800
Message-Id: <20220418130218.738980-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

V2:
- unsafe_request_wait() --> flush_mdlog_and_wait_inode_unsafe_requests()
- wait_unsafe_requests() -> flush_mdlog_and_wait_inode_unsafe_requests()


Xiubo Li (2):
  ceph: rename unsafe_request_wait()
  ceph: flush the mdlog for filesystem sync

 fs/ceph/caps.c       |  8 ++++----
 fs/ceph/mds_client.c | 27 +++++++++++++++++++++------
 2 files changed, 25 insertions(+), 10 deletions(-)

-- 
2.36.0.rc1

