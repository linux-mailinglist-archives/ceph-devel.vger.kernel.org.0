Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C226A702114
	for <lists+ceph-devel@lfdr.de>; Mon, 15 May 2023 03:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjEOBWF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 May 2023 21:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjEOBWE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 14 May 2023 21:22:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E9010E5
        for <ceph-devel@vger.kernel.org>; Sun, 14 May 2023 18:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684113679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5g0lVQuwhcN3Q0soWPfIN0hI6vz3ds0OcdSuWqRzISs=;
        b=brsIoL/1tiBQ3114PrtTQQECjqsp9QScHbZdw8QX+hbw1tSrM0q6Gr4iVFy+PdrUytxv0W
        fOIu6bHd1ilcK/pB+aKEcoA+QZ9bxedcDi0nB8TA03PyeVw0iIGhHgEz9x9J4whWnmgpzQ
        q0vOY+sCu37cgd0D2eXhpRvwpE9H4fg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-DggbuPHkMvSn8XNMi-iqhA-1; Sun, 14 May 2023 21:21:17 -0400
X-MC-Unique: DggbuPHkMvSn8XNMi-iqhA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BA9F811E7C;
        Mon, 15 May 2023 01:21:17 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-56.pek2.redhat.com [10.72.12.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FABD63F5F;
        Mon, 15 May 2023 01:21:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 0/2] ceph: fix blindly expanding the readahead windows
Date:   Mon, 15 May 2023 09:20:42 +0800
Message-Id: <20230515012044.98096-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

V6:
- Fixed the ctx issue when reading
- Fixed a potential use-after-free bug

Xiubo Li (2):
  ceph: add a dedicated private data for netfs rreq
  ceph: fix blindly expanding the readahead windows

 fs/ceph/addr.c  | 85 ++++++++++++++++++++++++++++++++++++++-----------
 fs/ceph/super.h | 13 ++++++++
 2 files changed, 80 insertions(+), 18 deletions(-)

-- 
2.40.1

