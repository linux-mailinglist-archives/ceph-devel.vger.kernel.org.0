Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11FB96807AE
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Jan 2023 09:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbjA3Ino (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Jan 2023 03:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjA3Inm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 Jan 2023 03:43:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EBC7EDA
        for <ceph-devel@vger.kernel.org>; Mon, 30 Jan 2023 00:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675068175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qHFIaD6BXKAsy4VZvTC6ndn33gIO42CmkbpMWIDxKX4=;
        b=cWJrgw7VhWa4jIetDXLXKtcaAKpZiEncjy39qYEeKogi/BjyNbtuqlv7oLGBg+Uqnsm4/b
        HAtSyIKiPrfrZVY15q5pCMeUkti44kVEXBNmcc+w1bFVUjMu11s/Jlq2bgoy0ED3kOxV6B
        COx+NCKxaNbR4UvTrCGNxamiTYWOlvo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-leOWOzlFPC6Gn66DZ1scNw-1; Mon, 30 Jan 2023 03:42:51 -0500
X-MC-Unique: leOWOzlFPC6Gn66DZ1scNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 905CF1C08780;
        Mon, 30 Jan 2023 08:42:51 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5D1B400EAD6;
        Mon, 30 Jan 2023 08:42:48 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, vshankar@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] ceph: drop the messages from MDS when unmouting
Date:   Mon, 30 Jan 2023 16:41:44 +0800
Message-Id: <20230130084147.122440-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V3:
- Fix the sequence of removing the requests from osdc and calling the
req->r_callback().
- Add a block counter to block the unmounting if there is any inflight
cap/snap/lease reply message is running.

V2:
- Fix it in ceph layer.

Xiubo Li (2):
  libceph: defer removing the req from osdc just after req->r_callback
  ceph: drop the messages from MDS when unmounting

 fs/ceph/caps.c        |  5 +++++
 fs/ceph/mds_client.c  | 12 +++++++++-
 fs/ceph/mds_client.h  | 11 ++++++++-
 fs/ceph/quota.c       |  4 ++++
 fs/ceph/snap.c        |  6 +++++
 fs/ceph/super.c       | 52 +++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/super.h       |  2 ++
 net/ceph/osd_client.c | 43 ++++++++++++++++++++++++++++-------
 8 files changed, 125 insertions(+), 10 deletions(-)

-- 
2.31.1

