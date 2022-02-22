Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F844BF21F
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Feb 2022 07:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiBVGfJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Feb 2022 01:35:09 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBVGfI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Feb 2022 01:35:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 891F4EBB91
        for <ceph-devel@vger.kernel.org>; Mon, 21 Feb 2022 22:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645511682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KbuWvkqeqHRgZtKbiJeRPY7PoxSpZqWgdvo3OoRDA0Y=;
        b=ZYoVJPonsaKDiuMB2wpbQuj5+gO/waQYIXRBkaqbzDxZBF5Akz1CUVkDQAG9B1O6z7Rf2X
        8sbxWdbf2nTLbFvE9YtkUHcVFBSvsKb1TeDjhvCnyvczd6K4wbbrBTF7c0abk1LETWpRqm
        Dzk9uhq2oDjRqqy5a0vA3ry1RlIAV40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-DjAxpz6oNSSFjIYt97ngjg-1; Tue, 22 Feb 2022 01:34:38 -0500
X-MC-Unique: DjAxpz6oNSSFjIYt97ngjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D67641808320;
        Tue, 22 Feb 2022 06:34:37 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B185519A0;
        Tue, 22 Feb 2022 06:34:35 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] ceph: create the global dummy snaprealm once
Date:   Tue, 22 Feb 2022 14:34:31 +0800
Message-Id: <20220222063433.217466-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Xiubo Li (2):
  ceph: remove incorrect and unused CEPH_INO_DOTDOT macro
  ceph: do not release the global snaprealm until unmounting

 fs/ceph/mds_client.c         |  2 +-
 fs/ceph/snap.c               | 13 +++++++++++--
 fs/ceph/super.h              |  2 +-
 include/linux/ceph/ceph_fs.h |  4 ++--
 4 files changed, 15 insertions(+), 6 deletions(-)

-- 
2.27.0

