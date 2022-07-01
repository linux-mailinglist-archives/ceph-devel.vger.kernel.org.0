Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0633563164
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Jul 2022 12:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiGAKaS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Jul 2022 06:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbiGAKaR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Jul 2022 06:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEA474DD6
        for <ceph-devel@vger.kernel.org>; Fri,  1 Jul 2022 03:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2999962388
        for <ceph-devel@vger.kernel.org>; Fri,  1 Jul 2022 10:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EE1C3411E;
        Fri,  1 Jul 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656671415;
        bh=b1z7RqADGi5j02xnw4M2iDEWD9wa9AoTPCLirx0F8kI=;
        h=From:To:Cc:Subject:Date:From;
        b=c5BenwoF6/+uBBf4kbyzfGYhk5HWZJhdUsgDOqa8u7+G1yF+l9/arR8JOw+aKQamY
         ejiYVAE4h5YsS6yVukhmNX95dN3XpS71kJC4NfGU/NfVUUyeh+d93h1vtts25zdNb5
         IU938UB0DGpb8V3Y4ayMdYODKkh29WDsXYCieELauxtyr15DY8wlqt69tdC4mBb5FB
         nTu4UMwVpIM7G0PQZ9/OESNVtrVJyxiYKp8Eba3pO+66j6RMkJFlQTkeUL9JtHjEK2
         ukcIXKfFvddrmKbTEjz0jPfriFMT2TlPqUHM/j9+d+GuHWTTseGQtCoZUlHxhatteg
         CSPON0frjbX+Q==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v3 0/2] libceph: add new iov_iter msg_data type and use it for reads
Date:   Fri,  1 Jul 2022 06:30:11 -0400
Message-Id: <20220701103013.12902-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v3:
- flesh out kerneldoc header over osd_req_op_extent_osd_data_pages
- remove export of ceph_msg_data_add_iter

v2:
- make _next handler advance the iterator in preparation for coming
  changes to iov_iter_get_pages

Just a respin to address some minor nits pointed out by Xiubo.

------------------------8<-------------------------

This patchset was inspired by some earlier work that David Howells did
to add a similar type.

Currently, we take an iov_iter from the netfs layer, turn that into an
array of pages, and then pass that to the messenger which eventually
turns that back into an iov_iter before handing it back to the socket.

This patchset adds a new ceph_msg_data_type that uses an iov_iter
directly instead of requiring an array of pages or bvecs. This allows
us to avoid an extra allocation in the buffered read path, and should
make it easier to plumb in write helpers later.

For now, this is still just a slow, stupid implementation that hands
the socket layer a page at a time like the existing messenger does. It
doesn't yet attempt to pass through the iov_iter directly.

I have some patches that pass the cursor's iov_iter directly to the
socket in the receive path, but it requires some infrastructure that's
not in mainline yet (iov_iter_scan(), for instance). It should be
possible to something similar in the send path as well.

Jeff Layton (2):
  libceph: add new iov_iter-based ceph_msg_data_type and
    ceph_osd_data_type
  ceph: use osd_req_op_extent_osd_iter for netfs reads

 fs/ceph/addr.c                  | 18 +------
 include/linux/ceph/messenger.h  |  8 ++++
 include/linux/ceph/osd_client.h |  4 ++
 net/ceph/messenger.c            | 84 +++++++++++++++++++++++++++++++++
 net/ceph/osd_client.c           | 27 +++++++++++
 5 files changed, 124 insertions(+), 17 deletions(-)

-- 
2.36.1

